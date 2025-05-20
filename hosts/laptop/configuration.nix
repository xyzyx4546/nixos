{
  imports = [
    ../common.nix
    ../not-so-common.nix
    ./hardware-configuration.nix
  ];

  programs.steam.enable = true;


  system.stateVersion = "24.05";
}
