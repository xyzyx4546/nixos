{
  pkgs,
  config,
  domain,
  ...
}: {
  fileSystems."/mnt/nextcloud" = {
    device = "/dev/disk/by-label/NEXTCLOUD";
    fsType = "ext4";
    options = ["defaults" "noatime" "nofail"];
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      https = true;
      hostName = domain;
      datadir = "/mnt/nextcloud";
      configureRedis = true;
      database.createLocally = true;
      maxUploadSize = "16G";
      config = {
        adminpassFile = config.sops.secrets."nextcloud/password".path;
        adminuser = "david";
        dbtype = "mysql";
      };
      phpOptions = {
        "opcache.memory_consumption" = "512";
        "opcache.interned_strings_buffer" = "32";
        "opcache.max_accelerated_files" = "20000";
      };
      settings = {
        default_phone_region = "DE";
        maintenance_window_start = 23;
        trashbin_retention_obligation = "auto, 30";
      };
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit impersonate groupfolders notes calendar contacts news;
      };
    };

    mysql.dataDir = "/mnt/nextcloud/mysql";
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin
      "nextcloud-logs"
      #bash
      ''
        journalctl -t Nextcloud -n "''${1:-100}" -o json | jq -C -r '.MESSAGE | fromjson' | less +G
      '')
  ];

  systemd = {
    tmpfiles.rules = ["d /mnt/nextcloud/mysql 0750 ${config.services.mysql.user} ${config.services.mysql.group}"];

    services = {
      # HACK: Ensure tmpfiles are created after the nextcloud mount is available
      "systemd-tmpfiles-resetup" = {
        after = ["mnt-nextcloud.mount"];
        wants = ["mnt-nextcloud.mount"];
      };
      "systemd-tmpfiles-setup" = {
        after = ["mnt-nextcloud.mount"];
        wants = ["mnt-nextcloud.mount"];
      };
    };
  };

  backup = {
    localOnlyPaths = [
      "${config.services.nextcloud.datadir}/data"
      "${config.services.nextcloud.datadir}/config/config.php"
    ];
    databases = [config.services.nextcloud.config.dbname];
  };
}
