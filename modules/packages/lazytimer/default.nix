{
  pkgs,
  lib,
  ...
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "lazytimer";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "xyzyx4546";
    repo = "lazytimer";
    rev = "v${version}";
    sha256 = "sha256-+WVUCS6mtS7yWE/Ii/bULVry6NIaYfrmSYlA9zmDfl8=";
  };

  cargoHash = "sha256-mPwBO+I1NDUkdgUbw3FoKY1QBplIGTTEIUJVXoN+nXA=";

  meta = {
    description = "A terminal-based speedcubing timer";
    homepage = "https://github.com/xyzyx4546/lazytimer";
    mainProgram = "lazytimer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [xyzyx4546];
  };
}
