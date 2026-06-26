{
  pkgs,
  config,
  domain,
  ...
}: {
  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      https = true;
      hostName = domain;
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
        serverid = 0;
        default_phone_region = "DE";
        maintenance_window_start = 23;
        trashbin_retention_obligation = "auto, 30";
      };
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit impersonate groupfolders notes calendar contacts news;
      };
    };
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin "nextcloud-logs" ''journalctl -t Nextcloud -n "''${1:-100}" -o json | jq -C -r '.MESSAGE | fromjson' | less +G'')
  ];

  backup = {
    localOnlyPaths = [
      "${config.services.nextcloud.datadir}/data"
      "${config.services.nextcloud.datadir}/config/config.php"
    ];
    databases = [config.services.nextcloud.config.dbname];
  };
}
