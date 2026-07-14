{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (steam.override {extraEnv."MANGOHUD" = true;})
    prismlauncher
    lsfg-vk
    melonloader-installer
    (writeShellScriptBin "nms-editor" ''
      set -euo pipefail
      trap 'rm -f "$DIR"/*.tmp' EXIT

      DIR="$HOME/.nms-editor"
      mkdir -p "$DIR"

      # Download the editor JAR if missing
      JAR="$DIR/NMSSaveEditor.jar"
      if [ "''${1:-}" = "-u" ] || [ ! -f "$JAR" ]; then
        curl -#L -o "$JAR.tmp" "https://github.com/goatfungus/NMSSaveEditor/raw/master/NMSSaveEditor.jar"
        mv "$JAR.tmp" "$JAR"
      fi

      # Set the GameSaveDir to the Proton prefix location
      CONF="$DIR/NMSSaveEditor.conf"
      GAME_PATH="/home/xyzyx/.local/share/Steam/steamapps/compatdata/275850/pfx/drive_c/users/steamuser/AppData/Roaming/HelloGames/NMS/st_76561199012207082"
      if [ ! -d "$GAME_PATH" ]; then
        echo "Error: Game save directory does not exist: $GAME_PATH" >&2
        exit 1
      fi

      [ -f "$CONF" ] || echo "{}" > "$CONF"
      ${pkgs.jq}/bin/jq '.GameSaveDir = "'$GAME_PATH'"' "$CONF" > "$CONF.tmp"
      mv "$CONF.tmp" "$CONF"

      (cd "$DIR" && ${pkgs.openjdk}/bin/java -jar "$JAR" > /dev/null)
    '')
  ];

  systemd.user.services."steam" = {
    Unit = {
      Description = "Steam";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.steam} -silent";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  xdg.configFile."lsfg-vk/conf.toml".source = (pkgs.formats.toml {}).generate "conf.toml" {
    version = 1;
    game = [
      {
        exe = "2";
        multiplier = 2;
        performance_mode = true;
      }
      {
        exe = "3";
        multiplier = 3;
        performance_mode = true;
      }
    ];
  };

  programs.mangohud.enable = true;
  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    legacy_layout=false
    round_corners=10

    gpu_list=0
    gpu_stats
    gpu_temp

    cpu_stats
    cpu_temp

    ram

    fps
    fps_text=FPS
    frametime=false;
  '';
}
