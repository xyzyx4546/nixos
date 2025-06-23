{pkgs, ...}: {
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    hyprland-qtutils
    xdg-desktop-portal-hyprland
    grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    xwayland.enable = true;

    settings = {
      # Force wayland
      env = [
        "GDK_BACKEND,wayland"
        "QT_QPA_PLATFORM,wayland"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DISABLE_RDD_SANDBOX,1"
        "EGL_PLATFORM,wayland"
        "NIXOS_OZONE_WL,1"
      ];

      exec-once = [
        "hyprctl setcursor Bibata-Modern-Classic 20"
        "swww-daemon"
        "ags"

        "[workspace special:browser silent] uwsm app -- firefox"
        "uwsm app -- vesktop --start-minimized"
        "uwsm app -- telegram-desktop -startintray"
        "uwsm app -- steam -silent"
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
        blur = {
          enabled = true;
          xray = true;
          size = 4;
          passes = 4;
          new_optimizations = true;
          brightness = "0.5";
        };
        dim_around = "0.5";
      };

      animations = {
        enabled = "yes";

        bezier = "bezier, 0.25, 1, 0.5, 1";

        animation = [
          "windows, 1, 6, bezier, popin"
          "border, 1, 6, bezier"
          "borderangle, 1, 6, bezier"
          "fade, 1, 6, bezier"
          "workspaces, 1, 6, bezier"
          "specialWorkspace, 1, 6, bezier, slidevert"
          "layers, 1, 3, bezier, popin"
        ];
      };

      dwindle = {
        force_split = 0;
        preserve_split = true;
      };

      windowrule = [
        "suppressevent maximize, class:.*"

        "float, class:(floating|xdg-desktop-portal-gtk|zenity|polkit-gnome-authentication-agent-1)"
        "dimaround, class:(floating|xdg-desktop-portal-gtk|zenity|polkit-gnome-authentication-agent-1)"
        "size 800 450, class:(floating|xdg-desktop-portal-gtk|zenity|polkit-gnome-authentication-agent-1)"

        "workspace special:games, class:^(surviving mars$|Minecraft.*|ksp.x86_64.*|steam_app.*|gamescope$)"
        "tile, class:^(surviving mars$|Minecraft.*|ksp.x86_64.*|steam_app.*|gamescope$)"
        "fullscreen, class:^(surviving mars$|Minecraft.*|ksp.x86_64.*|steam_app.*|gamescope$)"
      ];

      workspace = [
        "1, persistent:true, default:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        # "5, persistent:true"
        # "6, persistent:true"
        # "7, persistent:true"
        # "7, persistent:true"
        # "8, persistent:true"
        # "9, persistent:true"
        # "10, persistent:true"
      ];

      layerrule = [
        "noanim, ^(hyprpicker|notification_popup)$"
        "blur, ^(bar)$"
        "xray 0, ^(bar)$"
      ];

      bind = [
        # Window management
        "SUPER, Q, killactive,"
        "SUPER SHIFT, escape, exit,"
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
        "SUPER, C, exec, uwsm app -- kitty"
        "SUPER, Y, exec, uwsm app -- kitty yazi"
        "SUPER, S, exec, uwsm app -- kitty --class=left spotify_player"
        "SUPER, N, exec, uwsm app -- kitty nvim"
        "SUPER, D, exec, uwsm app -- vesktop"

        "SUPER, SUPER_L, exec, ags -t app-launcher"
        "SUPER, M, exec, ags -t calculator-launcher"
        "SUPER, V, exec, ags -t clipboard-launcher"
        "SUPER SHIFT, Q, exec, ags -t powermenu-launcher"

        "SUPER, W, exec, wallpaper random"
        "SUPER SHIFT, W, exec, wallpaper select"
        "SUPER, X, exec, hyprlock"
        ", PRINT, exec, grimblast --notify --freeze copysave area"

        # Workspaces
        "SUPER, G, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace games"
        "SUPER, B, exec, hyprctl dispatch focusmonitor 1 && hyprctl dispatch togglespecialworkspace browser"
        "SUPER SHIFT, B, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace browser"

        "SUPER CONTROL_L, H, workspace, m-1"
        "SUPER CONTROL_L, L, workspace, m+1"

        "SUPER SHIFT CONTROL_L, H, movetoworkspace, m-1"
        "SUPER SHIFT CONTROL_L, L, movetoworkspace, m+1"

        "SUPER, Tab, focusmonitor, +1"
        "SUPER SHIFT, Tab, focusmonitor, -1"
      ];
      bindl = [
        ", XF86AudioMute, exec, ags -r \"const { open } = await import('file://$HOME/.config/ags/widgets/osd.js'); open('volume');\" & wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, ags -r \"const { open } = await import('file://$HOME/.config/ags/widgets/osd.js'); open('volume');\" & wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"
        ", XF86AudioLowerVolume, exec, ags -r \"const { open } = await import('file://$HOME/.config/ags/widgets/osd.js'); open('volume');\" & wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 0.0"
        ", XF86MonBrightnessUp, exec, ags -r \"const { open } = await import('file://$HOME/.config/ags/widgets/osd.js'); open('brightness');\" & brightnessctl s +10%"
        ", XF86MonBrightnessDown, exec, ags -r \"const { open } = await import('file://$HOME/.config/ags/widgets/osd.js'); open('brightness');\" & brightnessctl s 10%-"
      ];

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };

      # HACK: fix for gamescope
      debug.full_cm_proto = true;

      debug.disable_logs = false;
    };
  };
}
