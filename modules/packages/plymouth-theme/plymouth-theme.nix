{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  pname = "alterra-plymouth-theme";
  version = "20-10-2024";

  src = ./theme;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/alterra
    cp * $out/share/plymouth/themes/alterra
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@/usr/share@$out/share@" {} \;
    runHook postInstall
  '';
}
