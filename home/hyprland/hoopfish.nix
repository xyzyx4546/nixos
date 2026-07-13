{
  wayland.windowManager.hyprland = {
    settings = {
      config = {
        input = {
          sensitivity = 1.0;
          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.1;
          };
        };

        gestures = {
          workspace_swipe_min_speed_to_force = 1;
          workspace_swipe_create_new = false;
        };
      };

      gesture = [
        {
          fingers = 3;
          direction = "swipe";
          action = "move";
        }
        {
          fingers = 3;
          direction = "swipe";
          mods = "ALT";
          action = "resize";
        }
        {
          fingers = 4;
          direction = "horizontal";
          scale = 0.5;
          action = "workspace";
        }
        {
          fingers = 4;
          direction = "vertical";
          scale = 0.5;
          action = "special";
          workspace_name = "browser";
        }
      ];

      monitor = [
        {
          output = "eDP-1";
          mode = "1920x1080@60";
          position = "0x0";
          scale = 1;
        }
      ];

      workspace_rule = let
        mkWorkspace = ws: {
          workspace = ws;
          persistent = true;
          monitor = "eDP-1";
        };
      in
        map mkWorkspace [1 2 3 4];
    };
    extraConfig = "require('dms.outputs')";
  };
}
