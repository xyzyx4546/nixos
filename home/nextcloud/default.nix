{
  config,
  osConfig,
  ...
}: {
  programs.rclone = {
    enable = true;
    requiresUnit = "run-secrets.d.mount";
    remotes."nextcloud" = {
      config = {
        type = "webdav";
        url = "https://fam-ehrhardt.de/remote.php/dav/files/david";
        vendor = "nextcloud";
        user = "david";
      };
      secrets.pass = osConfig.sops.secrets."nextcloud/webdav".path;
      mounts."/" = {
        enable = true;
        mountPoint = config.xdg.userDirs.extraConfig.NEXTCLOUD;
        options = {
          vfs-cache-mode = "full";
          vfs-cache-max-age = "24h";
          no-modtime = true;
          no-checksum = true;
        };
      };
    };
  };

  programs = {
    vdirsyncer.enable = true;
    khal = {
      enable = true;
      settings.highlight_days.method = "bg";
    };
  };

  services.vdirsyncer = {
    enable = true;
    frequency = "*:0/5";
  };

  accounts.calendar = {
    basePath = ".calendar";
    accounts = {
      "nextcloud" = {
        remote = {
          type = "caldav";
          url = "https://fam-ehrhardt.de/remote.php/dav/";
          userName = "david";
          passwordCommand = ["cat" osConfig.sops.secrets."nextcloud/webdav".path];
        };

        vdirsyncer = {
          enable = true;
          collections = ["from a" "from b"];
          conflictResolution = "remote wins";
          metadata = ["displayname" "color"];
        };

        khal = {
          enable = true;
          type = "discover";
        };
      };

      "lectures" = {
        remote = {
          type = "http";
          url = "https://dhbw.app/ical/STG-TINF24F";
        };

        vdirsyncer.enable = true;

        khal = {
          enable = true;
          readOnly = true;
          color = "#930010";
        };
      };
    };
  };
}
