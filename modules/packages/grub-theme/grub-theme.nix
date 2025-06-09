{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "xenlism-grub-theme";
  version = "16-06-2023";

  src = pkgs.fetchFromGitHub {
    owner = "xenlism";
    repo = "Grub-themes";
    rev = "40ac048df9aacfc053c515b97fcd24af1a06762f";
    hash = "sha256-ProTKsFocIxWAFbYgQ46A+GVZ7mUHXxZrvdiPJqZJ6I=";
  };

  installPhase = ''
    runHook preInstall
    cp -r xenlism-grub-1080p-nixos/Xenlism-Nixos $out
    cp ${./background.png} $out/background.png
    cp ${./nixos.png} $out/icons/nixos.png
    cp ${./windows.png} $out/icons/windows.png
    runHook postInstall
  '';
}
