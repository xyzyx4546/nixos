{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 28d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit= true;
  };

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de-latin1";

  users.users.xyzyx = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "xyzyx";
    shell = pkgs.zsh;
  };

  services = {
    xserver.videoDrivers = ["amdgpu"];
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "Hyprland";
          user = "xyzyx";
        };
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --remember --remember-user-session --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
    gvfs.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  environment = {
    variables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      EGL_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = [pkgs.home-manager];
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      (callPackage ../../packages/nunito/nunito.nix { inherit pkgs; })
    ];
  };

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
    gamemode.enable = true;
    steam.enable = true;
  };

  system.stateVersion = "24.05";
}

