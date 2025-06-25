{
  pkgs,
  # lib,
  ...
}: {
  networking = {
    networkmanager.enable = true;
    # firewall.enable = lib.mkForce false;
    firewall.checkReversePath = false;
    firewall.allowedUDPPorts = [51820];
  };

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
        theme = pkgs.callPackage ../modules/packages/grub-theme/grub-theme.nix {inherit pkgs;};
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
        (pkgs.callPackage ../modules/packages/plymouth-theme/plymouth-theme.nix {inherit pkgs;})
      ];
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
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
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time";
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

    # HACK: find a better way to do this
    evdevremapkeys = {
      enable = true;
      settings = {
        devices = [
          {
            input_name = "AT Translated Set 2 keyboard";
            output_name = "AT Translated Set 2 keyboard remapped";
            remappings = {
              KEY_CAPSLOCK = ["KEY_ESC"];
              KEY_ESC = ["KEY_CAPSLOCK"];
            };
          }
          {
            input_name = "Logitech G815 RGB MECHANICAL GAMING KEYBOARD";
            output_name = "Logitech G815 RGB MECHANICAL GAMING KEYBOARD remapped";
            remappings = {
              KEY_CAPSLOCK = ["KEY_ESC"];
              KEY_ESC = ["KEY_CAPSLOCK"];
            };
          }
        ];
      };
    };
  };

  environment.systemPackages = [pkgs.cifs-utils];
  fileSystems = {
    "/nas/david" = {
      device = "//server/david";
      fsType = "cifs";
      options = ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,guest,uid=1000,gid=100"];
    };
    "/nas/family" = {
      device = "//server/family";
      fsType = "cifs";
      options = ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,guest,uid=1000,gid=100"];
    };
  };

  systemd = {
    user.services = {
      "polkit-gnome-authentication-agent-1" = {
        description = "Polkit GNOME Authentication Agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      "NetworkManager-wait-online".enable = false;
    };
  };
}
