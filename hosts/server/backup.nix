{lib, config, ...}: {
  options.backup = {
    paths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of paths to include in backups.";
    };
    localOnlyPaths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of paths to include in local-only backups.";
    };
    databases = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "List of MySQL database names to include in backups.";
    };
  };

  config = {
    fileSystems."/mnt/backup" = {
      device = "/dev/disk/by-label/BACKUP";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };

    services = {
      mysqlBackup = {
        enable = true;
        compressionAlg = "zstd";
        singleTransaction = true;
        calendar = "01:00:00";
        inherit (config.backup) databases;
      };

      restic.backups = let
        passwordFile = config.sops.secrets."restic/password".path;
        timerConfig = {
          OnCalendar = "02:00:00";
          Persistent = true;
        };
        pruneOpts = [
          "--keep-daily" "7"
          "--keep-weekly" "4"
          "--keep-monthly" "6"
          "--keep-yearly" "100"
        ];
      in {
        "local" = {
          inherit passwordFile timerConfig pruneOpts;
          paths = [config.services.mysqlBackup.location] ++ config.backup.paths ++ config.backup.localOnlyPaths;
          repository = "/mnt/backup";
        };
        "b2" = {
          inherit passwordFile timerConfig pruneOpts;
          paths = [config.services.mysqlBackup.location] ++ config.backup.paths;
          # using s3 due to issues with the current restic b2 library
          # https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#backblaze-b2
          repository = "s3:s3.eu-central-003.backblazeb2.com/sanctuary-zero/server";
          environmentFile = config.sops.secrets."restic/b2".path;
        };
      };
    };
  };
}
