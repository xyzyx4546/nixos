{
  config,
  inputs,
  ...
}: {
  imports = [inputs.lazytimer.homeModules.lazytimer];

  programs.lazytimer = {
    enable = true;
    settings.general.data_dir = "${config.xdg.userDirs.extraConfig.NEXTCLOUD}/Documents/lazytimer";
  };
}
