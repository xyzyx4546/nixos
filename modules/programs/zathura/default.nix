# TODO: enable true transparency
{
  programs.zathura = {
    enable = true;
    options = {
      font = "JetBrainsMono Nerd Font 12";
      default-bg = "rgba(0,0,0,0)";
      statusbar-bg = "rgba(0,0,0,0)";
      statusbar-h-padding = 20;
      statusbar-v-padding = 20;
      # recolor = "true"; # Enable recoloring
      # recolor-lightcolor = "#FFFFFF"; # Light colors (background) to white
      # recolor-darkcolor = "#FFFFFF"; # Dark colors (black text) to white
      # recolor-reverse-video = "true"; # Ensure dark-to-light mapping
      # recolor-keephue = "true"; # Preserve hues for images and colored text
    };
  };
}
