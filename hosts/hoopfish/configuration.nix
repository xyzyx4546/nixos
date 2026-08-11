{inputs, ...}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-latitude-5520
    disko.nixosModules.disko
    lanzaboote.nixosModules.lanzaboote
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
}
