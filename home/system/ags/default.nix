{ inputs, pkgs, ... }: {
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = [pkgs.sassc];
  services.cliphist = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    extraOptions = [
      "-max-dedupe-search"
      "100"
      "-max-items"
      "100"
    ];
  };

  programs.ags = {
    enable = true;
    configDir = ./ags;
  };
}