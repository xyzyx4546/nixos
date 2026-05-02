{pkgs, ...}: {
  imports = [
    ../../home/dms
    ../../home/fastfetch
    ../../home/firefox
    ../../home/fonts
    ../../home/games
    ../../home/git
    ../../home/gtk
    ../../home/hyprland/laptop.nix
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
