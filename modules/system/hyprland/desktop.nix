{
  imports = [./common.nix];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3, 2560x1440@144, 1920x-200, 1"
      "HDMI-A-1, 1920x1080@60, 0x0, 1"
      "HDMI-A-1, addreserved, 10, 0, 0, 0"
    ];

    # second monitor
    workspace = [
      "99, monitor:HDMI-A-1, default:true, persistent:true"
    ];
    windowrule = [
      "monitor 0, class:negative:(^(left|vesktop|org.telegram.desktop|steam|net.lutris.Lutris|org.prismlauncher.PrismLauncher)$)"
      "workspace 99, class:^(left|vesktop|org.telegram.desktop|steam|net.lutris.Lutris|org.prismlauncher.PrismLauncher)$"
    ];

    bindm = [
      ", mouse:277, movewindow"
      "SUPER, mouse:272, resizewindow"
    ];
  };
}
