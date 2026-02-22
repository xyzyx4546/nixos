{pkgs, ...}: {
  networking.networkmanager.enable = true;
  systemd.services."NetworkManager-wait-online".enable = false;

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
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 0;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys.enable = true;
    };

    # Enable cross-compilation
    binfmt.emulatedSystems = ["aarch64-linux"];

    # Silent Boot Configuration
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Plymouth (Boot Splash) Configuration
    plymouth = {
      enable = true;
      theme = "alterra";
      themePackages = [
        (pkgs.callPackage ../modules/packages/plymouth-theme {})
      ];
    };
  };

  programs.hyprland.enable = true;

  environment.systemPackages = [pkgs.bibata-cursors];
  services = {
    displayManager.dms-greeter = {
      enable = true;
      configHome = "/home/xyzyx";
      configFiles = ["/home/xyzyx/.config/hypr/hyprland.conf"];
      compositor = {
        name = "hyprland";
        customConfig = ''
          source=/var/lib/dms-greeter/hyprland.conf
          debug:suppress_errors=true
        '';
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

    interception-tools = {
      enable = true;
      plugins = [pkgs.interception-tools-plugins.caps2esc];
    };

    accounts-daemon.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };
}
