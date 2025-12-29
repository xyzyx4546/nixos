{pkgs, ...}: {
  gtk = {
    enable = true;
    colorScheme = "dark";

    font = {
      name = "Nunito";
      size = 12;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };
}
