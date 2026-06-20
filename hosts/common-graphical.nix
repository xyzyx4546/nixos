{
  # Graphics Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # KDE Connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # Boot Configuration
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys.enable = true;
    };

    # Silent Boot Configuration
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];

    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  programs.hyprland.enable = true;

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "start-hyprland &> /dev/null";
          user = "xyzyx";
        };
        default_session = initial_session;
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

    accounts-daemon.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
  };
}
