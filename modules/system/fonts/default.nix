{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nunito
    nerd-fonts.jetbrains-mono
  ];
}
