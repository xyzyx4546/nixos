{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    plugins = [
      # inputs.hyprgrass.packages.${pkgs.system}.default
      pkgs.hyprlandPlugins.hyprgrass
    ];

    settings = {
      plugin.touch_gestures = {
        # sensitivity = 1.0;
        # workspace_swipe_fingers = 3;
        # workspace_swipe_edge = "d";
        # long_press_delay = 400;
        # edge_margin = 10;

        hyprgrass-bind = [
          # Swipe and tap gestures
          ", edge:r:l, workspace, +1"
          ", edge:d:u, exec, firefox"
          ", edge:l:d, exec, pactl set-sink-volume @DEFAULT_SINK@ -4%"
          ", swipe:4:d, killactive"
          ", swipe:3:ld, exec, kitty"
          ", tap:3, exec, kitty"
        ];

        # Mouse-like gestures
        hyprgrass-bindm = [
          ", longpress:2, movewindow"
          ", longpress:3, resizewindow"
        ];
      };
    };
  };
}
