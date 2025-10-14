{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ./nextcloud.nix
  ];

  nix.settings = {
    substituters = lib.mkAfter ["https://nixos-raspberrypi.cachix.org"];
    trusted-public-keys = lib.mkAfter ["nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="];
    trusted-users = ["xyzyx"];
  };

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
    nameservers = ["192.168.2.1"];
  };

  services = {
    dnsmasq = {
      enable = true;
      resolveLocalQueries = true;
      settings = {
        address = ["/fam-ehrhardt.de/192.168.2.10"];
        server = ["9.9.9.9"];
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
      domains = [
        {
          domain = "fam-ehrhardt.de";
          subdomain = "";
        }
        {
          domain = "fam-ehrhardt.de";
          subdomain = "status";
        }
      ];
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."fam-ehrhardt.de" = {
        forceSSL = true;
        enableACME = true;
      };
      virtualHosts."status.fam-ehrhardt.de" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:2812/";
          proxyWebsockets = true;
        };
      };
    };

    monit = let
      ntfy = {message}: "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures '${message}'";
    in {
      enable = true;
      config = ''
        set daemon 60
        set httpd port 2812
          allow 127.0.0.1

        check filesystem root with path /
          if space usage > 90% then exec "${ntfy {message = "Root drive is over 90% full";}}"

        check filesystem nextcloud with path /mnt/nextcloud
          if space usage > 90% then exec "${ntfy {message = "Nextcloud drive is over 90% full";}}"

        check filesystem backup with path /mnt/backup
          if space usage > 90% then exec "${ntfy {message = "Backup drive is over 90% full";}}"

        check process sshd with pidfile /run/sshd.pid
          if does not exist then exec "${ntfy {message = "SSHD is not running";}}"

        check process nginx with pidfile /run/nginx/nginx.pid
          if does not exist then exec "${ntfy {message = "Nginx is not running";}}"

        check process dnsmasq with pidfile /run/dnsmasq.pid
          if does not exist then exec "${ntfy {message = "Dnsmasq is not running";}}"

        check program borgbackup with path "${pkgs.systemd}/bin/systemctl is-failed borgbackup-job-nnextcloud.service"
          if status == 0 then exec "${ntfy {message = "Borgbackup job nextcloud failed";}}"

        check program oink with path "${pkgs.systemd}/bin/systemctl is-failed oink.service"
          if status == 0 then exec "${ntfy {message = "Oink failed";}}"
      '';
    };
  };

  systemd.services.oink.serviceConfig.EnvironmentFile = "/etc/oink.env";

  security.acme = {
    acceptTerms = true;
    defaults.email = "nobody@fam-ehrhardt.de";
  };

  networking.hostName = "server";
  system.stateVersion = "24.05";
}
