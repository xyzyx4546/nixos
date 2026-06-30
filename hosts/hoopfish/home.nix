# TODO: improve scroll behaviour
{pkgs, ...}: {
  imports = [
    ../../home/dms
    ../../home/fastfetch
    ../../home/firefox
    ../../home/fonts
    ../../home/git
    ../../home/gtk
    ../../home/hyprland
    ../../home/kitty
    ../../home/lazytimer
    ../../home/neovim
    ../../home/nextcloud
    ../../home/tmux
    ../../home/spotify
    ../../home/vesktop
    ../../home/xdg
    ../../home/yazi
    ../../home/zathura
    ../../home/zsh
  ];

  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    steam
  ];
}
