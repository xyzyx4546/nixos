{pkgs, ...}: {
  home.packages = with pkgs; [
    lutris-free
    prismlauncher
    protontricks
    (pkgs.callPackage ../../packages/melonloader-installer {inherit pkgs;})
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      legacy_layout = false;
      round_corners = 10;
      gpu_text = "GPU";
      gpu_stats = true;
      gpu_temp = true;
      cpu_text = "CPU";
      cpu_stats = true;
      cpu_temp = true;
      ram = true;
      fps = true;
    };
  };
}
