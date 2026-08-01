{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      url = "github:nix-community/lanzaboote/v1.1.0";
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
    dcal = {
      url = "github:AvengeMedia/dankcalendar";
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
    mkSystem = hostName:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs hostName;};
        modules = [./hosts/${hostName}/configuration.nix];
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
      eyeye = mkSystem "eyeye";
      hoopfish = mkSystem "hoopfish";
      oculus = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostName = "oculus";
        };
        modules = [./hosts/oculus/configuration.nix];
      };
    };

    packages.${system}.default = (mkSystem "holefish").config.system.build.images.iso-installer;

    checks.${system} = {
      alejandra = mkCheck "alejandra" "${pkgs.alejandra}/bin/alejandra --check ${./.}";
      statix = mkCheck "statix" "${pkgs.statix}/bin/statix check ${./.}";
      deadnix = mkCheck "deadnix" "${pkgs.deadnix}/bin/deadnix --fail ${./.}";
    };
  };
}
