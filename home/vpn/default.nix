{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.mullvad-vpn = {
    enable = true;
    settings = {
      enableSystemNotifications = false;
      startMinimized = true;
    };
  };

  systemd.user.services."mullvad" = {
    Unit = {
      Description = "Mullvad";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # HACK: ensure tray icon shows up in dms
      ExecStart = lib.getExe config.programs.mullvad-vpn.package;
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  home.activation."configureMullvad" = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${lib.getExe pkgs.mullvad} auto-connect set on
    ${lib.getExe pkgs.mullvad} lockdown-mode set on
    ${lib.getExe pkgs.mullvad} lan set allow
    ${lib.getExe pkgs.mullvad} relay set location ch
  '';
}
