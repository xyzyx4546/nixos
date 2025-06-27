{
  imports = [
    ../common.nix
    ../common-graphical.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid"];
    kernelModules = ["kvm-amd"];
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  services = {
    ratbagd.enable = true;
    hardware.openrgb.enable = true;
    greetd.settings.initial_session = {
      command = "Hyprland &> /dev/null";
      user = "xyzyx";
    };
  };

  system.stateVersion = "24.05";
}
