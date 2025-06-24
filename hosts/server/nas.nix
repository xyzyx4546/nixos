{pkgs, ...}: {
  fileSystems = {
    "/nas/data" = {
      device = "/dev/disk/by-label/NAS_DATA";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
    "/nas/backup" = {
      device = "/dev/disk/by-label/NAS_BACKUP";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
  };

  systemd.services = {
    "init-nas" = {
      description = "Create Samba shared directories";
      wantedBy = ["multi-user.target"];
      after = ["nas-data.mount" "nas-backup.mount"];
      requires = ["nas-data.mount" "nas-backup.mount"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.coreutils}/bin/mkdir -p /nas/data/brigitte /nas/data/david /nas/data/frank /nas/data/simon /nas/data/family
        ${pkgs.coreutils}/bin/chown xyzyx:users /nas /nas/* /nas/data/*
        ${pkgs.coreutils}/bin/chmod 755 /nas /nas/* /nas/data/*
      '';
    };
    "filebrowser" = {
      description = "Filebrowser web file manager";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "init-nas.service"];
      requires = ["network.target" "init-nas.service"];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.filebrowser}/bin/filebrowser \
            --address 127.0.0.1 \
            --port 8080 \
            --root /nas/data \
            --database /nas/filebrowser.db
        '';
        Restart = "always";
        User = "xyzyx";
        Group = "users";
      };
    };
  };

  services = {
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "security" = "user";
          "map to guest" = "bad user";
          "guest account" = "nobody";
        };
        "brigitte" = {
          "path" = "/nas/data/brigitte";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xyzyx";
        };
        "david" = {
          "path" = "/nas/data/david";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xyzyx";
        };
        "frank" = {
          "path" = "/nas/data/frank";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xyzyx";
        };
        "simon" = {
          "path" = "/nas/data/simon";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xyzyx";
        };
        "family" = {
          "path" = "/nas/data/family";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "xyzyx";
        };
      };
    };

    borgbackup.jobs."nas" = {
      user = "xyzyx";
      paths = "/nas/data";
      repo = "/nas/backup";
      doInit = false;
      encryption.mode = "none";
      startAt = "daily";
      prune.keep = {
        daily = 7;
        monthly = 6;
        yearly = -1;
      };
    };
  };
  environment.variables."BORG_REPO" = "/nas/backup";

  environment.systemPackages = [pkgs.filebrowser];
}
