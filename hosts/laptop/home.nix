# TODO: improve scroll behaviour
{pkgs, ...}: {
  imports = [
    ../../modules/programs/fastfetch
    ../../modules/programs/firefox
    ../../modules/programs/games
    ../../modules/programs/git
    ../../modules/programs/kdeconnect
    ../../modules/programs/kitty
    ../../modules/programs/neovim
    ../../modules/programs/tmux
    ../../modules/programs/spotify
    ../../modules/programs/vesktop
    ../../modules/programs/yazi
    ../../modules/programs/zathura
    ../../modules/programs/zsh

    ../../modules/system/dms
    ../../modules/system/fonts
    ../../modules/system/gtk
    ../../modules/system/hyprland/laptop.nix
    ../../modules/system/nextcloud
    ../../modules/system/xdg
  ];

  home = {
    username = "xyzyx";
    homeDirectory = "/home/xyzyx";

    packages = with pkgs; [
      onlyoffice-desktopeditors
    ];

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
