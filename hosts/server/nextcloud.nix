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

  systemd.services."systemd-tmpfiles-resetup" = {
    after = ["mnt-nextcloud.mount"];
    wants = ["mnt-nextcloud.mount"];
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
        inherit groupfolders;
      };
    };

    borgbackup.jobs."nextcloud" = {
      user = "nextcloud";
      paths = "/mnt/nextcloud";
      repo = "/mnt/backup";
      doInit = false;
      encryption.mode = "none";
      startAt = "daily";
      prune.keep = {
        daily = 7;
        monthly = 6;
        yearly = -1;
      };
    };
  };
  environment.variables."BORG_REPO" = "/mnt/backup";
}
