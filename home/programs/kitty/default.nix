{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      include = "~/.config/material/colors/colors-kitty.conf";
      font_size = 12;
      font_family = "JetBrainsMono Nerd Font";
      window_margin_width = 11;
      remember_window_size = "no";
      background_opacity = "0.8";

      confirm_os_window_close = 0;
      enable_audio_bell = "no";
    };
  };
}