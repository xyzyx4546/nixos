{ pkgs, ... }: {
  home.packages = with pkgs; [ 
    (pkgs.xfce.thunar.override { thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ]; })
    xfce.xfconf
    file-roller
    rclone
  ];

  xdg.configFile."Thunar/uca.xml".source = ./actions.xml;
  # xdg.configFile."rclone/rclone.conf".text = ''
  #   [Proton]
  #   type = protondrive
  #   username = ehd0178@gmail.com
  # '';
}
