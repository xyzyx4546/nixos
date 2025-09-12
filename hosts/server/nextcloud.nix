{
  pkgs,
  config,
  ...
}: {
  fileSystems = {
    "/mnt/nextcloud" = {
      device = "/dev/disk/by-label/NEXTCLOUD";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-label/BACKUP";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      https = true;
      hostName = "ehrhardt.duckdns.org";
      datadir = "/mnt/nextcloud";
      configureRedis = true;
      config = {
        adminpassFile = "${pkgs.writeText "nextcloud-pass" "nextcloud1"}";
        adminuser = "david";
        dbtype = "sqlite";
      };
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit groupfolders news calendar;
      };
    };

    borgbackup.jobs."nextcloud" = {
      user = "nextcloud";
      paths = "/mnt/nextcloud/data";
      exclude = ["/mnt/nextcloud/data/appdata_*" "/mnt/nextcloud/data/index.html"];
      repo = "/mnt/backup";
      doInit = false;
      encryption.mode = "none";
      startAt = "daily";
      preHook = "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on";
      postHook = "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off";
      prune.keep = {
        daily = 7;
        monthly = 6;
        yearly = -1;
      };
    };
  };
  environment.variables."BORG_REPO" = "/mnt/backup";

  systemd.services = {
    # HACK: Ensure tmpfiles are created after the nextcloud mount is available
    "systemd-tmpfiles-resetup" = {
      after = ["mnt-nextcloud.mount"];
      wants = ["mnt-nextcloud.mount"];
    };
    # HACK: Ensure borgbackup can toggle maintenance mode
    "borgbackup-job-nextcloud".serviceConfig.ReadWritePaths = ["/mnt/nextcloud"];
  };
}
