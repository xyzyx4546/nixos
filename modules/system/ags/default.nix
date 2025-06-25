{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.ags.homeManagerModules.default];

  home.packages = with pkgs; [
    sassc
    playerctl
    brightnessctl
    libnotify
    wl-clipboard
  ];
  services.cliphist = {
    enable = true;
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
