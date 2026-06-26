{lib, ...}: {
  imports = [
    ../common.nix
  ];

  boot.zfs.forceImportRoot = false;

  users.users = {
    root.initialHashedPassword = lib.mkForce null;
    nixos.enable = false;
  };

  services.getty = {
    autologinUser = lib.mkForce "xyzyx";
    helpLine = lib.mkForce "";
  };
}
