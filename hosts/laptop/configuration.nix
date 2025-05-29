{
  imports = [
    ../common.nix
    ../not-so-common.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";
}
