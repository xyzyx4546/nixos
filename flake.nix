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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    sops-nix,
    lanzaboote,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
          ./hosts/desktop/configuration.nix
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx".imports = [./hosts/desktop/home.nix];
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.dell-latitude-3480
          ./hosts/laptop/configuration.nix
          sops-nix.nixosModules.sops
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx".imports = [./hosts/laptop/home.nix];
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };

      server = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = {inherit nixos-raspberrypi;};
        modules = [
          nixos-raspberrypi.nixosModules.raspberry-pi-5.base
          nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
          ./hosts/server/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users."xyzyx".imports = [./hosts/server/home.nix];
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };

    checks.x86_64-linux = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      mkCheck = name: cmd:
        pkgs.stdenv.mkDerivation {
          name = "${name}-check";
          buildCommand = ''
            ${cmd}
            touch $out
          '';
        };
    in {
      alejandra = mkCheck "alejandra" "${pkgs.alejandra}/bin/alejandra --check ${./.}";
      statix = mkCheck "statix" "${pkgs.statix}/bin/statix check ${./.}";
      deadnix = mkCheck "deadnix" "${pkgs.deadnix}/bin/deadnix --fail ${./.}";
    };
  };
}
