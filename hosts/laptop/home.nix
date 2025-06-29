# TODO: improve scroll behaviour
{pkgs, ...}: {
  imports = [
    ../../modules/programs/firefox
    ../../modules/programs/games
    ../../modules/programs/git
    ../../modules/programs/kitty
    ../../modules/programs/neovim
    ../../modules/programs/tmux
    ../../modules/programs/vesktop
    ../../modules/programs/yazi
    ../../modules/programs/zsh

    ../../modules/system/ags
    ../../modules/system/fonts
    ../../modules/system/gtk
    ../../modules/system/hyprland/laptop.nix
    ../../modules/system/xdg
  ];

  home = {
    username = "xyzyx";
    homeDirectory = "/home/xyzyx";

    packages = with pkgs; [
      telegram-desktop
      onlyoffice-desktopeditors
    ];

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
