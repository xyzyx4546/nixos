{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      source = "~/.config/material/colors/colors-hyprland.conf";

      general = {
        disable_loading_bar = true;
        ignore_empty_input = true;
      };

      background = {
        monitor = "";
        path = "screenshot";
        blur_size = 1;
        blur_passes = 4;
        brightness = 0.5;
      };


      label = [{
        monitor = "DP-3";
        text = "$TIME";
        color = "$onSurface";
        font_size = 140;
        font_family = "Nunito Bold";
        position = "0, 150";
        halign = "center";
        valign = "center";
        shadow_passes = 4;
        shadow_size = 0;
        shadow_color = "$shadow";
      }];

      input-field = [{
        monitor = "DP-3";
        size = "200, 60";
        outline_thickness = 0;
        dots_size = 0.2;
        dots_spacing = 0.3;
        dots_center = true;
        inner_color = "$surfaceVariant";
        font_color = "$onSurface";
        placeholder_text = "";
        rounding = 20;
        position = "0, -50";
        halign = "center";
        valign = "center";
        shadow_passes = 4;
        shadow_size = 0;
        shadow_color = "$shadow";
      }];
    };
  };
}