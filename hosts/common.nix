{
  pkgs,
  lib,
  config,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

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
      "vaultwarden/password" = {};
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de-latin1";

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    (pkgs.callPackage ../modules/packages/nunito {})
  ];

  hardware.bluetooth.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [5353]; # mDNS
  };

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  users.users.xyzyx = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager"];
    hashedPasswordFile = config.sops.secrets."xyzyx/password".path;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq2xd3Eri9HfFP49Gl4snnrxMY6zXyNpWQIs9dd2L4Q"];
  };

  programs = {
    zsh.enable = true;
    nh = {
      enable = true;
      # HACK:
      package = pkgs.nh.override {
        nix-output-monitor = pkgs.nix-output-monitor.overrideAttrs (_: {
          src = pkgs.fetchFromGitHub {
            owner = "maralorn";
            repo = "nix-output-monitor";
            rev = "fa520d4f05d0e48d5d4675415dd0eeee72ce9a0a";
            sha256 = "sha256-+MnTTUVBJ1Sas2cz2FkHmdtzedc1YFntfM69rNQFz6k=";
          };
        });
      };
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
}
