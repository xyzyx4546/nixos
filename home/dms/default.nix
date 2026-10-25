{inputs, ...}: let
  mainScreen = ["eDP-1" "DP-3"];
in {
  _module.args = {inherit mainScreen;};

  imports = [
    inputs.dms.homeModules.default
    inputs.dux-plugin-registry.homeModules.default
    ./headset-battery.nix
    ./layout.nix
    ./plugins.nix
  ];

  # HACK: wallpaper config cant be set in settings.json
  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };

  # HACK: open terminal apps in kitty
  home.file.".config/environment.d/90-dms.conf".text = "TERMINAL=kitty";

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableCalendarEvents = false;

    settings = {
      configVersion = 42;
      soundsEnabled = false;
      useAutoLocation = true;
      showWeekNumber = true;
      osdAlwaysShowValue = true;
      notificationHistoryEnabled = false;

      currentThemeName = "dynamic";
      fontFamily = "Nunito";
      monoFontFamily = "JetBrainsMono Nerd Font";
      fontWeight = 500;

      launcherStyle = "island";
      dankLauncherV2ShowSourceBadges = false;

      screenPreferences = {
        osd = mainScreen;
        toast = mainScreen;
        notifications = mainScreen;
      };

      acLockTimeout = 5400;
      batteryLockTimeout = 5400;
      powerActionHoldDuration = 0.25;
      powerMenuActions = [
        "poweroff"
        "reboot"
        "suspend"
        "lock"
        "restart"
      ];
    };
  };
}
