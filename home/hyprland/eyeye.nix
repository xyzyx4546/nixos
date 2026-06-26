{
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "DP-3";
        mode = "2560x1440@144";
        position = "1920x-200";
        scale = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
      }
    ];

    workspace_rule = let
      mkWorkspace = ws: {
        workspace = ws;
        persistent = true;
        monitor = "DP-3";
      };
    in
      map mkWorkspace [1 2 3 4]
      ++ [
        {
          workspace = 5;
          monitor = "HDMI-A-1";
          default = true;
          persistent = true;
        }
      ];

    window_rule = [
      {
        match.class = "^(left|vesktop|steam|org.prismlauncher.PrismLauncher)$";
        workspace = 5;
      }
      {
        match.class = "negative:(^(firefox|left|vesktop|steam|org.prismlauncher.PrismLauncher)$)";
        monitor = 0;
      }
    ];
  };
}
