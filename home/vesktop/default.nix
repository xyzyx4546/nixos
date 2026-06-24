{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.vesktop = {
    enable = true;
    settings = {
      discordBranch = "stable";
      tray = true;
      minimizeToTray = true;
      clickTrayToShowHide = true;
      checkUpdates = false;
      arRPC = true;
    };
    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = false;
      plugins = {
        BetterUploadButton.enabled = true;
        FakeNitro.enabled = true;
        GameActivityToggle.enabled = true;
        MessageClickActions.enabled = true;
        PermissionsViewer.enabled = true;
        ShowMeYourName = {
          enabled = true;
          displayNames = true;
        };
        YoutubeAdblock.enabled = true;
      };
    };
  };

  systemd.user.services."vesktop" = {
    Unit = {
      Description = "Vesktop";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # HACK: ensure tray icon shows up in dms
      ExecStart = "${lib.getExe config.programs.vesktop.package} --start-minimized";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
