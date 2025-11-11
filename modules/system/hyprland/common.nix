{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hyprlock.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    hyprland-qtutils
    xdg-desktop-portal-hyprland
    grimblast
    swww
    ags
    brightnessctl
  ];

  services.polkit-gnome.enable = true;

  xdg.configFile."wallpapers" = {
    recursive = true;
    source = ./wallpapers;
  };

  wayland.windowManager.hyprland = {
    enable = true;
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
        "EDITOR,nvim"
      ];

      exec-once = [
        "hyprctl setcursor Bibata-Modern-Classic 20"
        "swww-daemon"
        "${inputs.ags-shell.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/ags-shell"

        "[workspace special:browser silent] firefox"
        "vesktop --start-minimized"
        "Telegram -startintray"
        "steam -silent"
      ];

      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        kb_options = "caps:swapescape";
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
        "suppressevent maximize, class:.*"

        "float, class:(floating|xdg-desktop-portal-gtk|waypaper)"
        "dimaround, class:(floating|xdg-desktop-portal-gtk|waypaper)"
        "size 800 450, class:(floating|xdg-desktop-portal-gtk|waypaper)"

        "workspace special:games, class:^(surviving mars|Minecraft|ksp\\.x86_64|steam_app).*"
        "tile, class:^(surviving mars|Minecraft|ksp\\.x86_64|steam_app).*"
        "fullscreen, class:^(surviving mars|Minecraft|ksp\\.x86_64|steam_app).*"
      ];

      workspace = [
        "1, persistent:true, default:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        # "5, persistent:true, monitor:0"
        # "6, persistent:true, monitor:0"
        # "7, persistent:true, monitor:0"
        # "7, persistent:true, monitor:0"
        # "8, persistent:true, monitor:0"
        # "9, persistent:true, monitor:0"
        # "10, persistent:true, monitor:0"
      ];

      layerrule = ["noanim, ^(hyprpicker|notification_popup)$"];

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
        "SUPER, SPACE, exec, ags toggle Applauncher"

        "SUPER, W, exec, ${pkgs.waypaper}/bin/waypaper --folder ~/.config/wallpapers --random"
        "SUPER SHIFT, W, exec, ${pkgs.waypaper}/bin/waypaper --folder ~/.config/wallpapers"
        ", PRINT, exec, grimblast --notify --freeze copysave area"

        "SUPER, X, exec, hyprlock"
        "SUPER SHIFT, escape, exit,"
        "SUPER SHIFT, Q, exec, systemctl poweroff"

        # Workspaces
        "SUPER, G, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace games"
        "SUPER, SUPER_L, exec, hyprctl dispatch focusmonitor 1 && hyprctl dispatch togglespecialworkspace browser"
        "SUPER, B, exec, hyprctl dispatch focusmonitor 0 && hyprctl dispatch togglespecialworkspace browser"

        "SUPER CONTROL_L, H, workspace, m-1"
        "SUPER CONTROL_L, L, workspace, m+1"

        "SUPER SHIFT CONTROL_L, H, movetoworkspace, m-1"
        "SUPER SHIFT CONTROL_L, L, movetoworkspace, m+1"

        "SUPER, Tab, focusmonitor, +1"
        "SUPER SHIFT, Tab, focusmonitor, -1"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 0.0"
        ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      debug.disable_logs = false;
    };
  };
}
