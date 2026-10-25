{
  pkgs,
  lib,
  ...
}: {
  systemd.user = {
    services."headset-battery-check".Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "check-headset-battery" ''
        set -auo pipefail

        FLAG="''${XDG_RUNTIME_DIR:-/tmp}/headset_battery_notified"
        [ -f "$FLAG" ] && exit 0

        BATTERY=$(${lib.getExe pkgs.headsetcontrol} -b | grep -oP 'Level:\s*\K\d+')

        if [ "$BATTERY" -lt 10 ]; then
          dms notify \
            -a DMS \
            -u critical \
            -i material:battery_alert \
            -h string:image-path:material:battery_alert \
            "Critical Headset Battery" \
            "Headset battery is at ''${BATTERY}% - Connect charger immediately!"

          touch "$FLAG"
        fi
      '';
    };

    timers."headset-battery-check" = {
      Timer = {
        OnStartupSec = "1m";
        OnUnitActiveSec = "5m";
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
