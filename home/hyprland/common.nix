{
  pkgs,
  lib,
  config,
  ...
}: {
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
    # TODO: migrate to lua
    configType = "hyprlang";
    xwayland.enable = true;

    settings = {
      env = lib.mapAttrsToList (k: v: "${k},${toString v}") config.home.sessionVariables;

      exec-once = [
        "hyprctl setcursor Bibata-Modern-Classic 20"

        "sleep 1 && vesktop --start-minimized"
        "kdeconnectd"
        "steam -silent"
      ];

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

      animations = {
        enabled = "yes";

        bezier = "bezier, 0.2, 0.8, 0.1, 1";

        animation = [
          "windows, 1, 4, bezier, popin 80%"
          "border, 1, 7, bezier"
          "fade, 1, 4, bezier"
          "workspaces, 1, 4, bezier"
          "specialWorkspace, 1, 4, bezier, slidevert"
          "layers, 1, 4, bezier, popin 80%"
        ];
      };

      dwindle = {
        force_split = 0;
        preserve_split = true;
      };

      windowrule = [
        "match:class ^firefox$, workspace special:browser"
        "match:class ^(floating|xdg-desktop-portal-gtk|waypaper)$, float on, dim_around on, size 960 540"
        "match:class ^(surviving mars|Minecraft|ksp\\.x86_64|X-Plane|steam_app).*, workspace special:games, tile on, fullscreen on"
      ];

      workspace = [
        "special:browser, on-created-empty:firefox"
        "1, persistent:true, default:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
      ];

      layerrule = ["match:namespace ^(hyprpicker|dms:.*)$, no_anim on"];

      bind = [
        # Window management
        "SUPER, Q, killactive,"
        "SUPER, F, togglefloating,"
        ",F11, fullscreen, 0"

        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"

        # Programs
        "SUPER, C, exec, kitty"
        "SUPER, Y, exec, kitty yazi"
        "SUPER, S, exec, kitty --class=left spotify_player"
        "SUPER, N, exec, kitty nvim"
        "SUPER, D, exec, vesktop"
        "SUPER, V, exec, dms ipc clipboard toggle"
        "SUPER, SPACE, exec, dms ipc spotlight toggle"

        "SUPER, W, exec, dms ipc dankdash wallpaper"
        ", PRINT, exec, ${pkgs.grimblast}/bin/grimblast --notify --freeze copysave area"

        "SUPER, X, exec, dms ipc powermenu toggle"
        "SUPER SHIFT, R, exec, hyprctl reload"

        # Workspaces
        "SUPER, G, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace games"
        "SUPER, SUPER_L, exec, hyprctl dispatch focusmonitor 1 && hyprctl dispatch togglespecialworkspace browser"
        "SUPER, B, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace browser"

        "SUPER CONTROL_L, H, focusmonitor, 0"
        "SUPER CONTROL_L, L, focusmonitor, 0"

        "SUPER CONTROL_L, H, workspace, m-1"
        "SUPER CONTROL_L, L, workspace, m+1"

        "SUPER SHIFT CONTROL_L, H, movetoworkspace, m-1"
        "SUPER SHIFT CONTROL_L, L, movetoworkspace, m+1"

        "SUPER, Tab, focusmonitor, +1"
        "SUPER SHIFT, Tab, focusmonitor, -1"
      ];
      bindl = [
        ", XF86AudioMute, exec, dms ipc audio mute"
        ", XF86AudioPlay, exec, dms ipc mpris playPause"
        ", XF86AudioNext, exec, dms ipc mpris next"
        ", XF86AudioPrev, exec, dms ipc mpris previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, dms ipc audio increment 5"
        ", XF86AudioLowerVolume, exec, dms ipc audio decrement 5"
        ", XF86MonBrightnessUp, exec, dms ipc brightness increment 10 ''"
        ", XF86MonBrightnessDown, exec, dms ipc brightness decrement 10 ''"
      ];

      misc = {
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      debug.disable_logs = false;
    };
  };
}
