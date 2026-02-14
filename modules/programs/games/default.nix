{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.steam.override {
      extraEnv."MANGOHUD" = true;
    })
    prismlauncher
    protontricks
    lsfg-vk
    (pkgs.callPackage ../../packages/melonloader-installer {})
    (pkgs.callPackage ../../packages/littlenavmap {})
    (pkgs.writeShellScriptBin "nms-editor" ''
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
