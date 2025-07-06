{pkgs, ...}: {
  home.packages = [pkgs.xdg-terminal-exec];

  programs.kitty = {
    enable = true;
    themeFile = "Dracula";
    settings = {
      font_size = 12;
      font_family = "JetBrainsMono Nerd Font";
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
