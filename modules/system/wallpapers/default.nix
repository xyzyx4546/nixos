{pkgs, ...}: {
  home.packages = with pkgs; [
    swww
    zenity
    (pkgs.writeScriptBin "wallpaper" (builtins.readFile ./material.sh))
  ];

  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };
}
