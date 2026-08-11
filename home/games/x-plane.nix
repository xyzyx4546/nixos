{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = [
      (pkgs.callPackage ./autoortho {})
      (pkgs.callPackage ./xfastmanager {})
    ];
    file.".autoortho".text = ''
      [paths]
      xplane_path = ${config.home.homeDirectory}/.steam/steam/steamapps/common/X-Plane 12
      scenery_path = ${config.home.homeDirectory}/.autoortho-data/scenery

      [autoortho]
      maptype_override = BI
      simheaven_compat = True
    '';
  };

  programs.yazi.keymap.mgr.prepend_keymap = [
    {
      on = "<A-x>";
      run = "shell 'xfastmanager $@' --orphan";
      desc = "Install via XFast Manager";
    }
  ];

  systemd.user.services = {
    "autoortho".Service = {
      Type = "simple";
      ExecStart = "${pkgs.callPackage ./autoortho {}}/bin/autoortho -H";
    };

    "fms-mover" = {
      Service = {
        Type = "simple";
        ExecStart = pkgs.writeShellScript "fms-mover" ''
          ${pkgs.inotify-tools}/bin/inotifywait -m -q -e moved_to -e create --format '%w%f' "${config.home.homeDirectory}/Downloads" | while read -r filepath; do
            [[ "$filepath" == *.fms ]] && mv "$filepath" "${config.home.homeDirectory}/.steam/steam/steamapps/common/X-Plane 12/Output/FMS plans"
          done
        '';
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
