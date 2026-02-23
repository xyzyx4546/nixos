{pkgs, ...}: {
  imports = [
    ../common.nix
    ../common-graphical.nix
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
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
  };

  # HACK: Set LAN speed
  systemd.services.set-lan-speed = {
    after = ["network-pre.target" "network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s enp14s0 speed 10 duplex full autoneg off";
      RemainAfterExit = true;
    };
  };

  networking.hostName = "desktop";
  system.stateVersion = "24.05";
}
