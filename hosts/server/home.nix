{
  imports = [
    ../../modules/programs/git
    ../../modules/programs/kitty
    ../../modules/programs/neovim
    ../../modules/programs/tmux
    ../../modules/programs/zsh
  ];

  home = {
    username = "xyzyx";
    homeDirectory = "/home/xyzyx";

    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;
}
