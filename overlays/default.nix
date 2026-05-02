final: prev: {
  xfastmanager = final.callPackage ./xfastmanager {};
  melonloader-installer = final.callPackage ./melonloader-installer {};
  nms-editor = final.writeShellScriptBin "nms-editor" ''
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
    ${final.jq}/bin/jq '.GameSaveDir = "'$GAME_PATH'"' "$CONF" > "$CONF.tmp"
    mv "$CONF.tmp" "$CONF"

    (cd "$DIR" && ${final.openjdk}/bin/java -jar "$JAR" > /dev/null)
  '';

  # HACK:
  nix-output-monitor = prev.nix-output-monitor.overrideAttrs (_: {
    src = final.fetchFromGitHub {
      owner = "maralorn";
      repo = "nix-output-monitor";
      rev = "fa520d4f05d0e48d5d4675415dd0eeee72ce9a0a";
      sha256 = "sha256-+MnTTUVBJ1Sas2cz2FkHmdtzedc1YFntfM69rNQFz6k=";
    };
  });

  spotify-player = prev.spotify-player.override {
    withAudioBackend = "pulseaudio";
  };

  steam = prev.steam.override {
    extraEnv."MANGOHUD" = true;
  };

  kdePackages = prev.kdePackages.overrideScope (_kfinal: kprev: {
    kdeconnect-kde = kprev.kdeconnect-kde.overrideAttrs (old: {
      preConfigure =
        (old.preConfigure or "")
        + ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'add_subdirectory(app)' '# add_subdirectory(app)' \
            --replace-fail 'add_subdirectory(indicator)' '# add_subdirectory(indicator)' \
            --replace-fail 'add_subdirectory(urlhandler)' '# add_subdirectory(urlhandler)' \
            --replace-fail 'add_subdirectory(smsapp)' '# add_subdirectory(smsapp)' \
            --replace-fail 'add_subdirectory(plasmoid)' '# add_subdirectory(plasmoid)' \
            --replace-fail 'add_subdirectory(nautilus-extension)' '# add_subdirectory(nautilus-extension)' \
            --replace-fail 'add_subdirectory(fileitemactionplugin)' '# add_subdirectory(fileitemactionplugin)'
        '';
    });
  });
}
