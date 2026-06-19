{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
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
    lazytimer = {
      url = "github:xyzyx4546/lazytimer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-raspberrypi,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    mkSystem = name:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs name;};
        modules = [./hosts/${name}/configuration.nix];
      };
    mkCheck = name: cmd:
      pkgs.stdenv.mkDerivation {
        name = "${name}-check";
        buildCommand = ''
          ${cmd}
          touch $out
        '';
      };
  in {
    nixosConfigurations = {
      laptop = mkSystem "laptop";
      desktop = mkSystem "desktop";
      server = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          name = "server";
        };
        modules = [./hosts/server/configuration.nix];
      };
    };

    checks.${system} = {
      alejandra = mkCheck "alejandra" "${pkgs.alejandra}/bin/alejandra --check ${./.}";
      statix = mkCheck "statix" "${pkgs.statix}/bin/statix check ${./.}";
      deadnix = mkCheck "deadnix" "${pkgs.deadnix}/bin/deadnix --fail ${./.}";
    };
  };
}
