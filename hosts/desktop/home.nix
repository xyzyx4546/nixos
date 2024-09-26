{ pkgs, ... }: {
  imports = [
    ../../home/programs/btop
    ../../home/programs/firefox
    ../../home/programs/git
    ../../home/programs/kitty
    ../../home/programs/mangohud
    ../../home/programs/neofetch
    ../../home/programs/neovim
    ../../home/programs/protonup
    ../../home/programs/spotify
    ../../home/programs/thunar
    ../../home/programs/zsh

    ../../home/system/ags
    ../../home/system/gtk
    ../../home/system/hyprland
    ../../home/system/material
    ../../home/system/xdg-userdirs
  ];

  home = {
    username = "xyzyx";
    homeDirectory = "/home/xyzyx";

    packages = with pkgs; [
      prismlauncher
      libnotify
      wl-clipboard

      lutris
      ckan
      protontricks
      gthumb
      gnome-calculator
      localsend
      webcord
      telegram-desktop
      piper
    ];

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
