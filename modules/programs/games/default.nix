{pkgs, ...}: {
  home.packages = with pkgs; [
    lutris-free
    prismlauncher
    protontricks
    (pkgs.callPackage ../../packages/melonloader-installer {inherit pkgs;})
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

  programs.mangohud = {
    enable = true;
    settings = {
      legacy_layout = false;
      round_corners = 10;
      gpu_text = "GPU";
      gpu_stats = true;
      gpu_temp = true;
      cpu_text = "CPU";
      cpu_stats = true;
      cpu_temp = true;
      ram = true;
      fps = true;
    };
  };
}
