{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  domain = "fam-ehrhardt.de";
  subdomains = builtins.filter (lib.hasSuffix ".${domain}") (builtins.attrNames config.services.nginx.virtualHosts);
in {
  _module.args = {inherit domain;};

  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-amd
    nixos-hardware.nixosModules.common-pc-ssd
    disko.nixosModules.disko
    ../common.nix
    ./backup.nix
    ./home-assistant.nix
    ./nextcloud.nix
    ./vaultwarden.nix
  ];

  disko.devices.disk."primary" = {
    type = "disk";
    device = "/dev/disk/by-id/ata-EDILOCA_ES106_4TB_AA000010667";
    content = {
      type = "gpt";
      partitions = {
        "BOOT" = {
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = ["-n" "BOOT"];
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        "ROOT" = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            extraArgs = ["-L" "ROOT"];
            mountpoint = "/";
          };
        };
      };
    };
  };

  networking = {
    networkmanager.ensureProfiles.profiles."eth" = {
      connection = {
        id = "eth";
        type = "ethernet";
        autoconnect = true;
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.2.10/24";
        gateway = "192.168.2.1";
        dns = "127.0.0.1;";
      };
      ipv6.method = "auto";
    };
    firewall = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53 80 443];
    };
  };

  services = {
    dnsmasq = {
      enable = true;
      settings = {
        address = ["/${domain}/192.168.2.10"];
        server = ["192.168.2.1"];
        no-resolv = true;
        no-hosts = true;
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
            skipIPv6 = true;
          }
        ]
        ++ (map (s: {
            inherit domain;
            subdomain = lib.removeSuffix ".${domain}" s;
          })
          subdomains);
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."status.${domain}" = {
        forceSSL = true;
        useACMEHost = domain;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2812";
          proxyWebsockets = true;
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

        check process sshd matching "sshd"
        check process nginx matching "nginx"
        check process dnsmasq matching "dnsmasq"
        check process oink matching "oink"
        check process mysql matching "mysqld"
        check process onlyoffice matching "onlyoffice"
        check process nextcloud matching "phpfpm-nextcloud"
        check process matter matching "matter-server"
        check process home-assistant matching "homeassistant"
        check process vaultwarden matching "vaultwarden"

        check program restic-local with path "${checkOneshotService} restic-backups-local"
          if status != 0 then alert
        check program restic-b2 with path "${checkOneshotService} restic-backups-b2"
          if status != 0 then alert
        check program mysql-backup with path "${checkOneshotService} mysql-backup"
          if status != 0 then alert

        check filesystem root with path /
          if space usage > 80% then alert
        check filesystem backup with path /mnt/backup
          if space usage > 80% then alert
      '';
    };
  };

  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      email = "nobody@${domain}";
      extraDomainNames = subdomains;
    };
  };
}
