{config, ...}: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      pictures = "${config.home.homeDirectory}/Pictures";
      extraConfig = {
        PROJECTS = "${config.home.homeDirectory}/Projects";
        NEXTCLOUD = "${config.home.homeDirectory}/Nextcloud";
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
        "inode/directory" = ["yazi.desktop"];
        "application/pdf" = ["org.pwmt.zathura-pdf-mupdf.desktop"];
      };
    };

    configFile."mimeapps.list".force = true;
  };
}
