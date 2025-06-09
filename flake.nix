# TODO: disko/nixos-anywhere
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:aylur/ags/v1";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-hardware,
    nixos-raspberrypi,
    home-manager,
    nvf,
    ...
  } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {hostName = "desktop";};
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx" = {
                imports = [
                  nvf.homeManagerModules.default
                  ./hosts/desktop/home.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {hostName = "laptop";};
        modules = [
          nixos-hardware.nixosModules.dell-latitude-3480
          ./hosts/laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx" = {
                imports = [
                  nvf.homeManagerModules.default
                  ./hosts/laptop/home.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      server = nixos-raspberrypi.lib.nixosSystemFull {
        specialArgs = {
          inherit nixos-raspberrypi;
          hostName = "server";
        };
        modules = [
          nixos-raspberrypi.nixosModules.raspberry-pi-5.base
          nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
          ./hosts/server/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx" = {
                imports = [
                  nvf.homeManagerModules.default
                  ./hosts/server/home.nix
                ];
              };
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
