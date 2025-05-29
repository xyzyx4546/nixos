{
  imports = [
    ../common.nix
    ../not-so-common.nix
    ./hardware-configuration.nix
  ];

  services = {
    ratbagd.enable = true;
    hardware.openrgb.enable = true;

    displayManager.autoLogin.user = "xyzyx";
  };

  system.stateVersion = "24.05";
}
