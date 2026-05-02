{pkgs ? import <nixpkgs> {}}:
pkgs.buildDotnetModule rec {
  pname = "melonloader-installer";
  version = "4.2.3";

  src = pkgs.fetchFromGitHub {
    owner = "LavaGang";
    repo = "MelonLoader.Installer";
    rev = version;
    sha256 = "sha256-Ldp3/DY2MWUGWSylAifSDyInFc6wC/9hv11i2t6IA8s=";
  };

  projectFile = "MelonLoader.Installer/MelonLoader.Installer.csproj";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_9_0;
  # nix-build -A fetch-deps overlays/melonloader-installer && ./result && rm result
  nugetDeps = ./deps.json;

  # Disable auto update
  postPatch = "substituteInPlace MelonLoader.Installer/Updater.cs --replace-fail 'State != UpdateState.None' 'true'";

  dotnetInstallFlags = ["-p:PublishSingleFile=false"];
}
