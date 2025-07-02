{pkgs, lib, ...}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "lazytimer";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "xyzyx4546";
    repo = "lazytimer";
    rev = "v${version}";
    sha256 = "sha256-rjgCvOzeENRA0HSVg1sbMuFTUn0ANot0VJCoCqCbvi8=";
  };

  cargoHash = "sha256-McknMjHr99dgBhmWoLTQUSu6houbi+UXnfe19TBuVVA=";

  meta = {
    description = "A terminal-based speedcubing timer";
    homepage = "https://github.com/xyzyx4546/lazytimer";
    mainProgram = "lazytimer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xyzyx4546 ];
  };
}
