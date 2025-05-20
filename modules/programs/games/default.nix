# TODO: gamescope, dies das
{ pkgs, ... }: {
  home.packages = with pkgs; [
    prismlauncher
    protontricks
    lutris
    ckan
    protonup
  ];

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
