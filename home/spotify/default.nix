{
  pkgs,
  lib,
  config,
  osConfig,
  hostName,
  ...
}: {
  programs.spotify-player = {
    enable = true;
    package = pkgs.spotify-player.override {
      withAudioBackend = "pulseaudio";
    };

    settings = {
      theme = "dracula";
      client_id_command = {
        command = "cat";
        args = [osConfig.sops.secrets."xyzyx/spotify".path];
      };
      ncspot_only_get_endpoints = [];
      playback_format = "{status} {track}\n{artists}\n{metadata}";
      pause_on_startup = true;
      enable_media_control = true;
      enable_streaming = "DaemonOnly";
      enable_notify = false;
      default_device = hostName;
      play_icon = "";
      pause_icon = "";
      liked_icon = " ";
      border_type = "Rounded";
      cover_img_length = 8;
      cover_img_width = 4;
      device = {
        name = hostName;
        volume = 90;
      };
    };

    themes = [
      {
        name = "dracula";
        component_style = {
          playback_status = {
            fg = "Green";
            modifiers = ["Bold"];
          };
          playback_track = {
            fg = "Green";
            modifiers = ["Bold"];
          };
          playback_artists = {
            fg = "Cyan";
          };
          playback_metadata = {
            fg = "BrightBlack";
          };
          playback_progress_bar = {
            bg = "BrightBlack";
            fg = "Green";
          };
          current_playing = {
            fg = "Green";
            modifiers = ["Bold"];
          };
          page_desc = {
            fg = "Cyan";
          };
          playlist_desc = {
            fg = "BrightBlack";
            modifiers = ["Dim"];
          };
          table_header = {
            fg = "Blue";
            modifiers = ["Bold" "Underlined"];
          };
          selection = {
            bg = "BrightBlack";
            modifiers = ["Bold"];
          };
          like = {
            fg = "Red";
            modifiers = ["Bold"];
          };
        };
      }
    ];

    keymaps = [
      {
        command = "ChooseSelected";
        key_sequence = "l";
      }
      {
        command = "PreviousPage";
        key_sequence = "h";
      }
      {
        command = "FocusNextWindow";
        key_sequence = "L";
      }
      {
        command = "FocusPreviousWindow";
        key_sequence = "H";
      }
    ];
  };

  systemd.user.services."spotify" = {
    Unit = {
      Description = "Spotify";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "forking";
      TimeoutStartSec = "infinity";
      ExecStartPre = pkgs.writeShellScript "wait-for-mullvad" ''
        until ${lib.getExe pkgs.mullvad} status -j | ${lib.getExe pkgs.jq} -e ".state==\"connected\""; do sleep 2; done
      '';
      ExecStart = "/run/wrappers/bin/mullvad-exclude ${lib.getExe config.programs.spotify-player.package} -d";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
