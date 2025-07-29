{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    mouse = true;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    resizeAmount = 20;
    disableConfirmationPrompt = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      set -g status-style "bg=default,fg=white"
      set -g status-left ""
      set -g status-right ""
      set -g status-justify centre

      set -g window-status-format "#[bg=default,fg=#44475a]#[bg=#44475a,fg=#bd93f9]#I: #W#[bg=default,fg=#44475a]"
      set -g window-status-style "bg=default,fg=white"
      set -g window-status-current-format "#[bg=default,fg=#bd93f9]#[bg=#bd93f9,fg=#44475a]#I: #W#[bg=default,fg=#bd93f9]"
      set -g window-status-current-style "bg=default,fg=white"
    '';
  };
}
