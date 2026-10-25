{mainScreen, ...}: let
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
  programs.dank-material-shell.settings = {
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
}
