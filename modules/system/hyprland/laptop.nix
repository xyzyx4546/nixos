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
        gesture pinch in 4      hyprctl dispatch killactive
      ''}"
    ];

    gestures = {
      workspace_swipe_min_speed_to_force = 3;
      workspace_swipe_create_new = false;
    };

    gesture = [
      "3, swipe, move"
      "3, swipe, mod: alt, resize"
      "4, horizontal, scale: 0.5, workspace"
    ];
  };
}
