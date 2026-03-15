{
  imports = [
    ../common.nix
    ../common-graphical.nix
  ];

  disko.devices.disk."primary" = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        "BOOT" = {
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = ["-n" "BOOT"];
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        "ROOT" = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings.allowDiscards = true;
            # settings = {
            #   keyFile = "/tmp/secret.key";
            # };
            content = {
              type = "filesystem";
              format = "ext4";
              extraArgs = ["-L" "ROOT"];
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme"];
    kernelModules = ["kvm-intel"];
  };

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "laptop";
  system.stateVersion = "24.05";
}
