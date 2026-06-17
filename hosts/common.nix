{
  pkgs,
  lib,
  config,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs = {
    overlays = [(import ../overlays)];
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
      ];
  };

  documentation.nixos.enable = false;

  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/xyzyx/.config/sops/age/keys.txt";

    secrets = {
      "xyzyx/password".neededForUsers = true;
      "xyzyx/ssh-key" = {
        path = "/home/xyzyx/.ssh/id_ed25519";
        owner = "xyzyx";
      };
      "oink/api-key" = {};
      "oink/secret-api-key" = {};
      "restic/password" = {};
      "restic/b2" = {};
      "nextcloud/password" = {};
      "nextcloud/webdav".owner = "xyzyx";
      "vaultwarden/password" = {};
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de-latin1";

  hardware.bluetooth.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [5353]; # mDNS
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  users.users = {
    root.hashedPassword = "!";
    xyzyx = {
      isNormalUser = true;
      extraGroups = ["wheel" "input" "networkmanager"];
      hashedPasswordFile = config.sops.secrets."xyzyx/password".path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq2xd3Eri9HfFP49Gl4snnrxMY6zXyNpWQIs9dd2L4Q"];
    };
  };

  programs = {
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = [(pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")];
    };
    nh = {
      enable = true;
      flake = "/home/xyzyx/Projects/nixos";
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep=5 --keep-since=3d";
      };
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
