{ pkgs, ... }: {
  home.packages = with pkgs; [
    swww
    zenity
  ];

  xdg.configFile."material" = {
    recursive = true;
    source = ./material;
  };
}
