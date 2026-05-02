{pkgs, ...}: {
  home.packages = with pkgs; [
    steam
    prismlauncher
    lsfg-vk
    melonloader-installer
    nms-editor
  ];

  xdg.configFile."lsfg-vk/conf.toml".source = (pkgs.formats.toml {}).generate "conf.toml" {
    version = 1;
    game = [
      {
        exe = "2";
        multiplier = 2;
        performance_mode = true;
      }
      {
        exe = "3";
        multiplier = 3;
        performance_mode = true;
      }
    ];
  };

  programs.mangohud.enable = true;
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=false
    round_corners=10

    gpu_list=0
    gpu_stats
    gpu_temp

    cpu_stats
    cpu_temp

    ram

    fps
    fps_text=FPS
    frametime=false;
  '';
}
