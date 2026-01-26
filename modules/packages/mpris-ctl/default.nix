{pkgs, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "mpris-ctl";
  version = "1.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "mariusor";
    repo = "mpris-ctl";
    rev = "v${version}";
    hash = "sha256-o/E6TJuEm5eHYeTEPyi8l8Y5j0y08oXGv3XaxxydpRU=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    scdoc
  ];

  buildInputs = with pkgs; [
    dbus
  ];

  makeFlags = [
    "release"
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "INSTALL_PREFIX="
  ];
}
