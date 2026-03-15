{inputs, ...}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
  ];

  # HACK: wallpaper config cant be set in settings.json
  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;

    plugins = {
      dankKDEConnect = {
        enable = true;
        settings.enable = true;
      };
      dankBatteryAlerts = {
        enable = true;
        settings.enable = true;
      };
    };

    settings = {
      currentThemeName = "purple";
      widgetBackgroundColor = "sc";

      fontFamily = "Nunito";
      monoFontFamily = "JetBrainsMono Nerd Font";
      fontWeight = 500;

      useAutoLocation = true;
      osdAlwaysShowValue = true;
      launcherLogoMode = "os";
      acLockTimeout = 5400;
      powerActionHoldDuration = 0.25;

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
            "cpuUsage"
            "memUsage"
            "diskUsage"
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
