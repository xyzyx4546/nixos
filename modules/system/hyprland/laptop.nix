{
  imports = [./common.nix];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
      "HDMI-A-1, preferred, auto, 1, mirror, eDP-1"
    ];

    input.sensitivity = 0.6;

    bindm = [
      "SUPER, ALT_L, movewindow"
      "SUPER, CONTROL_L, resizewindow"
    ];
  };
}
