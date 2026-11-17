{
  pkgs,
  config,
  domain,
  ...
}: let
  dbUser = "open-webui";
  dbName = "open-webui";
in {
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-cpu;
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "-1";
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_MAX_LOADED_MODELS = "1";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };

    open-webui = {
      enable = true;
      package = pkgs.open-webui.overridePythonAttrs (old: {
        dependencies = old.dependencies ++ old.optional-dependencies.postgres;
      });
      environment = {
        DATABASE_URL = "postgresql://${dbUser}@/${dbName}?host=/run/postgresql";
        VECTOR_DB = "pgvector";
        SCARF_NO_ANALYTICS = "true";
        DO_NOT_TRACK = "true";
        ANONYMIZED_TELEMETRY = "false";
      };
    };

    searx = {
      enable = true;
      settings = {
        server = {
          secret_key = "key";
          port = 8888;
        };
        search.formats = ["html" "json"];
      };
    };

    postgresql = {
      extensions = ps: with ps; [pgvector];
      ensureDatabases = [dbName];
      ensureUsers = [
        {
          name = dbUser;
          ensureDBOwnership = true;
        }
      ];
    };

    nginx.virtualHosts."chat.${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.open-webui.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_cache off;
          proxy_read_timeout 300s;
          proxy_send_timeout 300s;
          client_max_body_size 100M;
        '';
      };
    };
  };

  systemd.services.open-webui = {
    after = ["postgresql.target"];
    requires = ["postgresql.target"];
  };

  backup = {
    paths = [
      "${config.services.open-webui.stateDir}/.webui_secret_key"
      "${config.services.open-webui.stateDir}/data"
    ];
    databases = [dbName];
  };
}
