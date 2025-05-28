{pkgs, ...}: {
  imports = [./common.nix];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
      "HDMI-A-1, preferred, auto, 1, mirror, eDP-1"
    ];

    input = {
      sensitivity = 1.0;
      touchpad = {
        natural_scroll = "yes";
        scroll_factor = 0.1;
      };
    };

    exec-once = [
      "${pkgs.libinput-gestures}/bin/libinput-gestures -c ${pkgs.writeText "libinput-gestures.conf" ''
        gesture swipe up 4      hyprctl dispatch togglespecialworkspace games
        gesture swipe down 4    hyprctl dispatch togglespecialworkspace browser
        gesture swipe left 4    hyprctl dispatch workspace m+1
        gesture swipe right 4   hyprctl dispatch workspace m-1
        gesture pinch out 4     hyprctl dispatch exec kitty
        gesture pinch in 4      hyprctl dispatch killactive
      ''}"
    ];

    bindm = [
      "SUPER, ALT_L, movewindow"
      "SUPER, CONTROL_L, resizewindow"
    ];
  };
}
