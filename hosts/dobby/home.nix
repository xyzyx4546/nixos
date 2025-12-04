{
  imports = [
    ../../modules/programs/git
    ../../modules/programs/neovim
    ../../modules/programs/tmux
    ../../modules/programs/yazi
    ../../modules/programs/zsh
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";

    stateVersion = "24.05";
  };

  programs = {
    nh = {
      enable = true;
      homeFlake = "/home/david/Projects/nixos";
    };
    home-manager.enable = true;
  };
}
