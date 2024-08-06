{ config, ... }: {
  xdg.userDirs = {
    enable = true;

    desktop = "${config.home.homeDirectory}/";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/";
    templates = "${config.home.homeDirectory}/";
    videos = "${config.home.homeDirectory}/";
  };
}
