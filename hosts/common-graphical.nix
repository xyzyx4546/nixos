{pkgs, ...}: {
  networking.networkmanager.enable = true;
  systemd.services."NetworkManager-wait-online".enable = false;

  # Graphics Configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Boot Configuration
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        theme = pkgs.callPackage ../modules/packages/grub-theme {inherit pkgs;};
        splashImage = null;
        useOSProber = true;
      };
      timeout = 3;
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
        (pkgs.callPackage ../modules/packages/plymouth-theme {inherit pkgs;})
      ];
    };
  };

  programs = {
    hyprland.enable = true;
    adb.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          "MANGOHUD" = true;
        };
      };
    };
  };

  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time";
        user = "greeter";
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

    upower.enable = true;
  };
}
