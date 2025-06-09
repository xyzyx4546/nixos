{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      prismlauncher
      protontricks
      ckan
      protonup
    ];

    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    };
  };

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
