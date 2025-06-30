{
  pkgs,
  osConfig,
  ...
}: {
  programs.spotify-player = {
    enable = true;
    package = pkgs.spotify-player.override {
      withAudioBackend = "pulseaudio";
    };

    settings = {
      theme = "dracula";
      client_id = "d83c868d85a54fe28d93ec17446cfe3c";
      playback_format = "{status} {track}\n{artists}\n{metadata}";
      enable_media_control = true;
      enable_streaming = "Always";
      enable_notify = false;
      default_device = osConfig.networking.hostName;
      play_icon = "";
      pause_icon = "";
      liked_icon = " ";
      border_type = "Rounded";
      cover_img_length = 8;
      cover_img_width = 4;
      device = {
        name = osConfig.networking.hostName;
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
      {
        command = "ToggleFakeTrackRepeatMode";
        key_sequence = "r";
      }
    ];
  };
}
