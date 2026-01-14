{
  imports = [./common.nix];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3, 2560x1440@144, 1920x-200, 1"
      "HDMI-A-1, 1920x1080@60, 0x0, 1"
    ];

    # second monitor
    workspace = [
      "99, monitor:HDMI-A-1, default:true, persistent:true"
      "1, monitor:DP-3"
      "2, monitor:DP-3"
      "3, monitor:DP-3"
      "4, monitor:DP-3"
    ];
    windowrule = [
      "monitor 0, class:negative:(^(firefox|Little Navmap|left|vesktop|steam|org.prismlauncher.PrismLauncher)$)"
      "workspace 99, class:^(Little Navmap|left|vesktop|steam|org.prismlauncher.PrismLauncher)$"
    ];

    bindm = [
      ", mouse:277, movewindow"
      "ALT, mouse:272, resizewindow"
    ];
  };
}
