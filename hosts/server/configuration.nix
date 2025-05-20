{pkgs, ...}: {
  imports = [
    ../common.nix
    ./nas.nix
    ./vpn.nix
  ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
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

  networking.firewall.allowedTCPPorts = [80 443];
  services = {
    monit = {
      enable = true;
      config = ''
        set daemon 60
        set httpd port 2812
          allow 127.0.0.1

        check filesystem root with path /
          if space usage > 90% then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'Root filesystem is over 90% full'"

        check filesystem nas_data with path /nas/data
          if space usage > 90% then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'NAS data is over 90% full'"

        check filesystem nas_backup with path /nas/backup
          if space usage > 90% then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'NAS backup is over 90% full'"

        check process sshd with pidfile /run/sshd.pid
          if does not exist then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'SSH is not running'"

        check process samba with pidfile /run/samba/smbd.pid
          if does not exist then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'Samba is not running'"

        check process filebrowser matching "/bin/filebrowser"
          if does not exist then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'Filebrowser is not running'"

        check process nginx with pidfile /run/nginx/nginx.pid
          if does not exist then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'Nginx is not running'"

        check program borgbackup with path "${pkgs.systemd}/bin/systemctl is-failed borgbackup-job-nas.service"
          if status == 0 then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'Backup failed'"

        check program ddclient with path "${pkgs.systemd}/bin/systemctl is-failed ddclient.service"
          if status == 0 then exec "${pkgs.ntfy-sh}/bin/ntfy send --title=Server server-failures 'DDclient failed'"
      '';
    };
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."ehrhardt.duckdns.org" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
          };
          "/status/" = {
            proxyPass = "http://127.0.0.1:2812/";
            proxyWebsockets = true;
          };
          "/dashboard/" = {
            proxyPass = "http://127.0.0.1:8081/";
            proxyWebsockets = true;
          };
        };
      };
    };
    homepage-dashboard = {
      enable = true;
      listenPort = 8081;
      openFirewall = true;
      services = [
        {
          name = "Local Web Server";
          url = "http://localhost:80";
          icon = "fas fa-server";
        }
        {
          name = "Google";
          url = "https://www.google.com";
          icon = "fas fa-search";
        }
      ];
      widgets = [
        {
          type = "clock";
          options = {
            format = "HH:mm:ss";
          };
        }
      ];
      settings = {
        title = "My Homepage Dashboard";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "nobody@ehrhardt.duckdns.org";
    certs."ehrhardt.duckdns.org" = {
      domain = "ehrhardt.duckdns.org";
      group = "nginx";
    };
  };

  # networking = {
  #   interfaces."end0".ipv4.addresses = [
  #     {
  #       address = "192.168.2.10";
  #       prefixLength = 24;
  #     }
  #   ];
  #   defaultGateway = "192.168.2.1";
  #   nameservers = ["192.168.2.1"];
  # };

  system.stateVersion = "24.05";
}
