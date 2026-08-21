{
  config,
  domain,
  ...
}: let
  dbUser = "vaultwarden";
  dbName = "vaultwarden";
in {
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "mysql";
      environmentFile = config.sops.secrets."vaultwarden/password".path;
      config = {
        # https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vault.${domain}";
        SIGNUPS_ALLOWED = false;
        INVITATIONS_ALLOWED = true;

        DATABASE_URL = "mysql://${dbUser}@localhost/${dbName}";

        USER_ATTACHMENT_LIMIT = 0;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
    };

    mysql = {
      ensureDatabases = [dbName];
      ensureUsers = [
        {
          name = dbUser;
          ensurePermissions = {
            "${dbName}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    nginx.virtualHosts."vault.${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
      };
    };
  };

  backup.databases = [dbName];
}
