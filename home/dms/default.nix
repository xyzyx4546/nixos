{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.default
    inputs.dux-plugin-registry.homeModules.default
  ];

  # HACK: wallpaper config cant be set in settings.json
  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };

  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde.overrideAttrs (old: {
      preConfigure =
        (old.preConfigure or "")
        + ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'add_subdirectory(app)' '# add_subdirectory(app)' \
            --replace-fail 'add_subdirectory(indicator)' '# add_subdirectory(indicator)' \
            --replace-fail 'add_subdirectory(urlhandler)' '# add_subdirectory(urlhandler)' \
            --replace-fail 'add_subdirectory(smsapp)' '# add_subdirectory(smsapp)' \
            --replace-fail 'add_subdirectory(plasmoid)' '# add_subdirectory(plasmoid)' \
            --replace-fail 'add_subdirectory(nautilus-extension)' '# add_subdirectory(nautilus-extension)' \
            --replace-fail 'add_subdirectory(fileitemactionplugin)' '# add_subdirectory(fileitemactionplugin)'
        '';
    });
  };

  home.packages = with pkgs; [
    libnotify
    libqalculate
  ];

  # HACK: open terminal apps in kitty
  home.file.".config/environment.d/90-dms.conf".text = "TERMINAL=kitty";

  systemd.user = {
    services."headset-battery-check".Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "check-headset-battery" ''
        set -auo pipefail

        FLAG="''${XDG_RUNTIME_DIR:-/tmp}/headset_battery_notified"
        [ -f "$FLAG" ] && exit 0

        BATTERY=$(${lib.getExe pkgs.headsetcontrol} -b | grep -oP 'Level:\s*\K\d+')

        if [ "$BATTERY" -lt 10 ]; then
          ${lib.getExe pkgs.libnotify} \
            -a DMS \
            -u critical \
            -i material:battery_alert \
            -h string:image-path:material:battery_alert \
            "Critical Headset Battery" \
            "Headset battery is at ''${BATTERY}% - Connect charger immediately!"

          touch "$FLAG"
        fi
      '';
    };

    timers."headset-battery-check" = {
      Timer = {
        OnStartupSec = "1m";
        OnUnitActiveSec = "5m";
      };
      Install.WantedBy = ["timers.target"];
    };
  };

  programs.dank-material-shell = let
    mainScreen = ["eDP-1" "DP-3"];
    mkPlugin = args: {
      enable = true;
      settings = {enabled = true;} // removeAttrs args ["src"];
      src = lib.mkIf (args ? src) (lib.mkForce args.src);
    };
    mkIslandWidget = name: {
      id = name;
      enabled = true;
    };
    mkLockScreenWidget = name: config: {
      id = name;
      widgetType = name;
      config = {displayPreferences = mainScreen;} // config;
    };
  in {
    enable = true;
    systemd.enable = true;
    enableCalendarEvents = false;

    plugins = {
      calculator = mkPlugin {
        calcEngine = "qalc";
        alwaysActive = true;
        noTrigger = true;
      };
      dankKDEConnect = mkPlugin {
        src = inputs.dux-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}.dankKDEConnect.overrideAttrs (_: {
          postPatch = ''
            substituteInPlace DankKDEConnect/DankKDEConnect.qml \
              --replace-fail \
              'function autoSelectBestDevice() {' \
              'function autoSelectBestDevice() { selectedDeviceId = "c7bc322559214d9885b2509e457eb5c6"; return;'
          '';
        });
      };
      systemMonitorPlus = mkPlugin {
        cpuUsageEnabled = true;
        ramUsageEnabled = true;
        diskPartitionUsageEnabled = true;
        cpuTempEnabled = false;
        gpuTempEnabled = false;
        cpuUsageVisualStyle = "gauge";
        ramUsageVisualStyle = "gauge";
        diskPartitionUsageVisualStyle = "gauge";
      };
    };

    settings = {
      configVersion = 42;
      currentThemeName = "dynamic";
      widgetBackgroundColor = "sc";

      fontFamily = "Nunito";
      monoFontFamily = "JetBrainsMono Nerd Font";
      fontWeight = 500;

      soundsEnabled = false;
      useAutoLocation = true;
      osdAlwaysShowValue = true;
      launcherLogoMode = "os";
      launcherStyle = "island";
      dankLauncherV2ShowSourceBadges = false;
      showWeekNumber = true;
      acLockTimeout = 5400;
      batteryLockTimeout = 5400;
      powerActionHoldDuration = 0.25;
      notificationHistoryEnabled = false;

      screenPreferences =  {
        osd = mainScreen;
        toast = mainScreen;
        notifications = mainScreen;
      };

      powerMenuActions = [
        "poweroff"
        "reboot"
        "suspend"
        "lock"
        "restart"
      ];

      barConfigs = [
        {
          id = "default";
          enabled = true;
          screenPreferences = mainScreen;
          island = true;
          islandNotificationExpand = true;
          islandSatelliteBackground = true;
          islandInteractionMode = "click";
          islandNotch = true;
          leftWidgets = [
            {
              id = "workspaceSwitcher";
              showWorkspaceApps = true;
            }
            "systemMonitorPlus"
          ];
          islandHomeLayout = [
            (mkIslandWidget "media")
            (mkIslandWidget "clock")
            (mkIslandWidget "notifications")
            (mkIslandWidget "weather")
            (mkIslandWidget "status")
            (mkIslandWidget "privacy")
          ];
          rightWidgets = [
            "dankKDEConnect"
            "systemTray"
            "controlCenterButton"
            "powerMenuButton"
          ];
        }
      ];

      dashOptions.overview.panelRows = 4;
      dashCards = [
        {
          id = "clock";
          w = 3;
          h = 1;
          col = 0;
          row = 0;
        }
        {
          id = "notifications";
          w = 3;
          h = 4;
          col = 3;
          row = 0;
        }
        {
          id = "calendar";
          w = 3;
          h = 3;
          col = 0;
          row = 1;
        }
      ];

      controlCenterWidgets = [
        {
          id = "user";
          w = 5;
          h = 1;
          col = 0;
          row = 0;
        }
        {
          id = "edit";
          w = 1;
          h = 1;
          small = true;
          col = 5;
          row = 0;
        }
        {
          id = "settings";
          w = 1;
          h = 1;
          small = true;
          col = 6;
          row = 0;
        }
        {
          id = "power";
          w = 1;
          h = 1;
          small = true;
          col = 7;
          row = 0;
        }
        {
          id = "brightnessSlider";
          w = 4;
          h = 1;
          col = 4;
          row = 1;
        }
        {
          id = "volumeSlider";
          w = 4;
          h = 1;
          col = 0;
          row = 1;
        }
        {
          id = "wifi";
          w = 4;
          h = 1;
          col = 0;
          row = 2;
        }
        {
          id = "bluetooth";
          w = 4;
          h = 1;
          col = 4;
          row = 2;
        }
        {
          id = "audioOutput";
          w = 4;
          h = 1;
          col = 0;
          row = 3;
        }
        {
          id = "audioInput";
          w = 4;
          h = 1;
          col = 4;
          row = 3;
        }
      ];

      lockScreenWidgetInstances = [
        (mkLockScreenWidget "desktopClock" {
          style = "expressive";
          showDate = true;
        })
        (mkLockScreenWidget "lockAuth" {
          style = "ring";
          profileVisibility = "typing";
          passwordVisibility = "typing";
        })
        (mkLockScreenWidget "lockStatus" {})
        (mkLockScreenWidget "lockPower" {})
      ];
    };
  };
}
