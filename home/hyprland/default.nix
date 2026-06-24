{
  lib,
  config,
  hostName,
  ...
}: {
  imports = [
    ./binds.nix
    ./${hostName}.nix
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    EGL_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;

    settings = {
      env = lib.mapAttrsToList (k: v: {_args = [k (toString v)];}) config.home.sessionVariables;

      config = {
        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";
          numlock_by_default = true;
          repeat_rate = 50;
          repeat_delay = 300;
          accel_profile = "flat";
          follow_mouse = 1;
        };

        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 10;
          "col.active_border" = "rgb(bd93f9)";
          "col.inactive_border" = "rgba(282a36aa)";
          layout = "dwindle";
          resize_on_border = true;
        };

        decoration = {
          rounding = 15;
          dim_around = 0.5;
          blur = {
            enabled = true;
            xray = true;
            size = 4;
            passes = 4;
            brightness = 0.5;
          };
        };

        animations.enabled = true;

        dwindle = {
          force_split = 0;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
          focus_on_activate = true;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        debug.disable_logs = false;
      };

      curve = [
        {
          _args = [
            "bezier"
            {
              type = "bezier";
              points = [[0.2 0.8] [0.1 1.0]];
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 4;
          bezier = "bezier";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 7;
          bezier = "bezier";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 4;
          bezier = "bezier";
        }
        {
          leaf = "specialWorkspace";
          enabled = true;
          speed = 4;
          bezier = "bezier";
          style = "slidevert";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 4;
          bezier = "bezier";
          style = "popin 80%";
        }
      ];

      workspace_rule = [
        {
          workspace = "special:browser";
          on_created_empty = "firefox";
        }
      ];

      window_rule = [
        {
          match.class = "^(surviving mars|Minecraft|ksp\\.x86_64|X-Plane|steam_app).*";
          workspace = "special:games";
          tile = true;
          fullscreen = true;
        }
      ];

      layer_rule = {
        match.namespace = "^dms:.*$";
        no_anim = true;
      };
    };
  };
}
