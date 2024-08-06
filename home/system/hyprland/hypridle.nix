{ pkgs, ... }: {
  services.hypridle = {
    enable = true;

    settings = {
      listener = [{
        timeout = 1800;
        on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
      }];
    };
  };
}