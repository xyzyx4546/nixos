{
  pkgs,
  lib,
  config,
  ...
}: let
  domain = "fam-ehrhardt.de";
  subdomains = [
    {
      name = "status";
      port = 2812;
    }
    {
      name = "vault";
      port = config.services.vaultwarden.config.ROCKET_PORT;
    }
    {
      name = "home";
      port = config.services.home-assistant.config.http.server_port;
    }
  ];
in {
  _module.args = {inherit domain;};

  imports = [
    ../common.nix
    ./backup.nix
    ./home-assistant.nix
    ./nextcloud.nix
    ./vaultwarden.nix
  ];

  fileSystems = {
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # HACK: temporary
  boot.loader.raspberryPi.bootloader = "kernel";

  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pciex1 = {
        enable = true;
        value = "on";
      };
      pciex1_gen = {
        enable = true;
        value = "3";
      };
    };
  };

  networking = {
    firewall = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53 80 443];
    };
    interfaces."end0".ipv4.addresses = [
      {
        address = "192.168.2.10";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.2.1";
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        address = ["/${domain}/192.168.2.10"];
        server = ["192.168.2.1"];
        no-resolv = true;
        cache-size = 1000;
      };
    };

    oink = {
      enable = true;
      apiKeyFile = config.sops.secrets."oink/api-key".path;
      secretApiKeyFile = config.sops.secrets."oink/secret-api-key".path;
      domains =
        [
          {
            inherit domain;
            subdomain = "";
          }
        ]
        ++ (map (s: {
            inherit domain;
            subdomain = s.name;
          })
          subdomains);
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts =
        (lib.listToAttrs (map (s: {
            name = "${s.name}.${domain}";
            value = {
              forceSSL = true;
              useACMEHost = domain;
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString s.port}/";
                proxyWebsockets = true;
              };
            };
          })
          subdomains))
        // {
          "${domain}" = {
            forceSSL = true;
            enableACME = true;
          };
        };
    };

    monit = let
      checkOneshotService = pkgs.writeShellScript "check-oneshot-service" ''
        set -euo pipefail

        SERVICE="$1"

        LOAD_STATE=$(systemctl show -p LoadState "$SERVICE" --value)

        if [ "$LOAD_STATE" != "loaded" ]; then
          echo "ERROR: Service has LoadState=$LOAD_STATE."
          exit 2
        fi

        ACTIVE_STATE=$(systemctl show -p ActiveState "$SERVICE" --value)

        if [ "$ACTIVE_STATE" == "active" ] || [ "$ACTIVE_STATE" == "activating" ]; then
            echo "OK: Service is currently running."
            exit 0
        fi

        EXEC_STATUS=$(systemctl show -p ExecMainStatus "$SERVICE" --value)

        if [ "$EXEC_STATUS" != "0" ]; then
            echo "ERROR: Last run failed with exit status $EXEC_STATUS."
            exit 1
        fi

        LAST_EXIT=$(systemctl show -p ExecMainExitTimestamp "$SERVICE" --value)

        if [ -z "$LAST_EXIT" ] || [ "$LAST_EXIT" = "n/a" ]; then
          echo "ERROR: Service has never run."
          exit 1
        fi

        LAST_SEC=$(date -d "$LAST_EXIT" +%s) || {
          echo "ERROR: Could not parse exit timestamp."
          exit 1
        }
        CHECK_SINCE=$(date -d "30 hours ago" +%s) || {
          echo "ERROR: Could not calculate time threshold."
          exit 1
        }

        if [ "$LAST_SEC" -lt "$CHECK_SINCE" ]; then
          echo "ERROR: Service has not run since 30 hours (last run: $LAST_EXIT)."
          exit 1
        fi

        echo "OK: Service is healthy. (last run: $LAST_EXIT)"
        exit 0
      '';
    in {
      enable = true;
      config = ''
        set daemon 60
        set httpd port 2812 read-only
          allow 127.0.0.1

        check filesystem root with path /
          if space usage > 90% then alert

        check filesystem nextcloud with path /mnt/nextcloud
          if space usage > 90% then alert

        check filesystem backup with path /mnt/backup
          if space usage > 90% then alert

        check process sshd matching "sshd"
          if does not exist then alert

        check process nginx matching "nginx"
          if does not exist then alert

        check process dnsmasq matching "dnsmasq"
          if does not exist then alert

        check process oink matching "oink"
          if does not exist then alert

        check process mysql matching "mysqld"
          if does not exist then alert

        check process nextcloud-php matching "phpfpm-nextcloud"
          if does not exist then alert

        check process matter matching "matter-server"
          if does not exist then alert

        check process home-assistant matching "homeassistant"
          if does not exist then alert

        check process vaultwarden matching "vaultwarden"
          if does not exist then alert

        check program restic-local with path "${checkOneshotService} restic-backups-local"
          if status != 0 then alert

        check program restic-b2 with path "${checkOneshotService} restic-backups-b2"
          if status != 0 then alert

        check program mysql-backup with path "${checkOneshotService} mysql-backup"
          if status != 0 then alert

        check program vaultwarden-backup with path "${checkOneshotService} backup-vaultwarden"
          if status != 0 then alert
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      email = "nobody@${domain}";
      extraDomainNames = map (s: "${s.name}.${domain}") subdomains;
    };
  };

  networking.hostName = "server";
  system.stateVersion = "24.05";
}
