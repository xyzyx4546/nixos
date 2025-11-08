{
  pkgs,
  lib,
  ...
}: let
  domain = "fam-ehrhardt.de";
  subdomains = [
    {
      name = "status";
      port = 2812;
    }
  ];
in {
  _module.args = { inherit domain; };

  imports = [
    ../common.nix
    ./nextcloud.nix
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
      settings = {
        apiKey = "";
        secretApiKey = "";
      };
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

    monit = {
      enable = true;
      config = ''
        set daemon 60
        set httpd port 2812
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

        check program borgbackup with path "${pkgs.systemd}/bin/systemctl is-failed borgbackup-job-nnextcloud.service"
          if status == 0 then alert
      '';
    };
  };

  systemd.services.oink.serviceConfig.EnvironmentFile = "/etc/oink.env";

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
