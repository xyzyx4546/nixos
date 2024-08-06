{ lib, pkgs, ... }: {
  gtk = {
    enable = true;

    font = {
      name = "Nunito";
      size = 12;
    };

    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Tela-circle-dark";
      package = pkgs.tela-circle-icon-theme;
    };

    gtk3.extraCss = ''
      @import url("../material/colors/colors-gtk.css");
    '';

    gtk4.extraCss = ''
      @import url("../material/colors/colors-gtk.css");
    '';
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 11;
  };
}