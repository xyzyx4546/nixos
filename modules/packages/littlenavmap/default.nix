{pkgs}:
pkgs.stdenv.mkDerivation rec {
  pname = "littlenavmap";
  version = "3.0.18";

  src = pkgs.fetchurl {
    url = "https://github.com/albar965/littlenavmap/releases/download/v${version}/LittleNavmap-linux-ubuntu-24.04-${version}.tar.xz";
    sha256 = "sha256-fDGMNDUpCYl3NOHVz3Y0EHATjxZ4aGufGRqE0CaTxcM=";
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = with pkgs; [
    qt5.qtbase
    gtk3
  ];

  dontWrapQtApps = true;

  desktopItems = [
    (pkgs.makeDesktopItem
      {
        name = "Little Navmap";
        desktopName = "Little Navmap";
        genericName = "Little Navmap";
        comment = "A free flight planner and navigation tool for flight simulators";
        icon = pname;
        terminal = false;
        exec = pname;
        categories = [
          "Qt"
          "Utility"
          "Geography"
          "Maps"
          "Game"
        ];
        keywords = [
          "flight"
          "simulator"
          "navigation"
          "map"
          "planner"
        ];
      })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname} $out/bin
    cp -r * $out/share/${pname}/
    makeWrapper $out/share/${pname}/${pname} $out/bin/${pname} --set QT_QPA_PLATFORM xcb
    install -Dm644 littlenavmap.svg $out/share/icons/hicolor/scalable/apps/littlenavmap.svg

    runHook postInstall
  '';
}
