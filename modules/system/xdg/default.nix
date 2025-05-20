{ config, ... }: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
      extraConfig = {
        XDG_PROJECTS_DIR = "${config.home.homeDirectory}/Projects";
      };

      desktop = null;
      music = null;
      publicShare = null;
      templates = null;
      videos = null;
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        "inode/directory" = [ "yazi.desktop" ];
      };
    };
  };
}
