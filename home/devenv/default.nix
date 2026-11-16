{
  programs.devenv = {
    enable = true;
    settings = {
      shell.prompt_prefix = false;
      # TODO: wait for proper customization options
      tui.viewport = "top";
    };
    enableZshIntegration = true;
  };
}
