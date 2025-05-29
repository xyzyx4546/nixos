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

  programs.mangohud.enable = true;

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=false

    round_corners=10

    gpu_text=GPU
    gpu_stats
    gpu_temp

    cpu_text=CPU
    cpu_stats
    cpu_temp

    ram

    fps
  '';
}
