{pkgs ? import <nixpkgs> {}}:
pkgs.buildDotnetModule rec {
  pname = "melonloader-installer";
  version = "4.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "LavaGang";
    repo = "MelonLoader.Installer";
    rev = version;
    sha256 = "sha256-0hUc4f1avPfNDGAQDokLpRLK4sSrUFD5GkJZeP/Gu34=";
  };

  projectFile = "MelonLoader.Installer/MelonLoader.Installer.csproj";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_9_0;
  # nix-build -E 'with import <nixpkgs> {}; (callPackage ./modules/packages/melonloader-installer/default.nix {}).fetch-deps' && ./result && rm result
  nugetDeps = ./deps.json;

  # Disable auto update
  postPatch = "substituteInPlace MelonLoader.Installer/Updater.cs --replace-fail 'State != UpdateState.None' 'true'";

  dotnetInstallFlags = ["-p:PublishSingleFile=false"];
}
