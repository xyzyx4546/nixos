{
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
}
