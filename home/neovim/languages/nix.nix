{osConfig, ...}: {
  programs.nvf.settings.vim = {
    lsp.servers.nixd.settings.nixd = let
      flake = "(builtins.getFlake \"${osConfig.programs.nh.flake}\")";
    in {
      nixpkgs.expr = "import ${flake}.inputs.nixpkgs {}";

      options = {
        nixos.expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options";
        home_manager.expr = "${flake}.nixosConfigurations.${osConfig.networking.hostName}.options.home-manager.users.type.getSubOptions []";
      };
    };

    languages.nix = {
      enable = true;
      lsp.servers = ["nixd"];
      format.type = ["alejandra"];
    };
  };
}
