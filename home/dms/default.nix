{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.nixosModules.default
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

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableCalendarEvents = false;

    plugins = let
      mkPlugin = extraSettings: {
        enable = true;
        settings = {enabled = true;} // extraSettings;
      };
    in {
      calculator = mkPlugin {
        calcEngine = "qalc";
        alwaysActive = true;
        noTrigger = true;
      };
      dankKDEConnect = mkPlugin {
        selectedDeviceId = "c7bc322559214d9885b2509e457eb5c6";
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
      currentThemeName = "purple";
      widgetBackgroundColor = "sc";

      fontFamily = "Nunito";
      monoFontFamily = "JetBrainsMono Nerd Font";
      fontWeight = 500;

      soundsEnabled = false;
      useAutoLocation = true;
      osdAlwaysShowValue = true;
      launcherLogoMode = "os";
      showWeekNumber = true;
      acLockTimeout = 5400;
      batteryLockTimeout = 5400;
      powerActionHoldDuration = 0.25;
      notificationHistoryEnabled = false;

      screenPreferences = let
        screens = ["eDP-1" "DP-3"];
      in {
        osd = screens;
        toast = screens;
        notifications = screens;
      };

      showWorkspaceApps = true;
      reverseScrolling = true;

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
          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "systemTray"
          ];
          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];
          rightWidgets = [
            "systemMonitorPlus"
            "spacer"
            "dankKDEConnect"
            "clipboard"
            "notificationButton"
            "battery"
            "controlCenterButton"
            "powerMenuButton"
          ];
          transparency = 0;
          fontScale = 1.25;
        }
      ];

      controlCenterWidgets = [
        {
          id = "volumeSlider";
          enabled = true;
          width = 50;
        }
        {
          id = "brightnessSlider";
          enabled = true;
          width = 50;
        }
        {
          id = "wifi";
          enabled = true;
          width = 50;
        }
        {
          id = "bluetooth";
          enabled = true;
          width = 50;
        }
        {
          id = "audioOutput";
          enabled = true;
          width = 50;
        }
        {
          id = "audioInput";
          enabled = true;
          width = 50;
        }
      ];
    };
  };
}
