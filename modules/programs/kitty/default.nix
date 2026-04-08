{
  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    font = {
      name = "family='JetBrainsMono Nerd Font' style=SemiBold";
      size = 12;
    };
    settings = {
      window_margin_width = 11;
      remember_window_size = "no";
      background_opacity = 0;
      touch_scroll_multiplier = 20;
      cursor_trail = 1;
      cursor_trail_start_threshold = 5;

      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
  };
}
