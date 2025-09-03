{
  pkgs,
  lib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de-latin1";

  networking.firewall.enable = true;

  users.users.xyzyx = {
    isNormalUser = true;
    extraGroups = ["wheel" "input"];
    initialPassword = "xyzyx";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOq2xd3Eri9HfFP49Gl4snnrxMY6zXyNpWQIs9dd2L4Q"];
  };

  environment.variables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs = {
    zsh.enable = true;
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
}
