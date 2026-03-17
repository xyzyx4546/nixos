{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "lazytimer";
  version = "0.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "xyzyx4546";
    repo = "lazytimer";
    rev = "v${version}";
    sha256 = "sha256-1YyIGFtPZFCcK4jlWK8Nh+9hJRAWCPd9Q6dGNAd730o=";
  };

  cargoHash = "sha256-RwF6AK24IOWpSaH56GaIQkvgCbb2FM7TWno3beBlbGo=";

  meta = {
    description = "A terminal-based speedcubing timer";
    homepage = "https://github.com/xyzyx4546/lazytimer";
    mainProgram = "lazytimer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [xyzyx4546];
  };
}
