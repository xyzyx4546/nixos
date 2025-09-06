{pkgs ? import <nixpkgs> {}}:
pkgs.buildDotnetModule rec {
  pname = "melonloader-installer";
  version = "4.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "LavaGang";
    repo = "MelonLoader.Installer";
    rev = version;
    sha256 = "sha256-bvfOjN+EIdEMlS0noB5Jwosv4Z31MhyNpFydkzN6nDQ=";
  };

  projectFile = "MelonLoader.Installer/MelonLoader.Installer.csproj";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
  dotnet-runtime = pkgs.dotnetCorePackages.runtime_9_0;
  nugetDeps = ./deps.json;

  dotnetInstallFlags = ["-p:PublishSingleFile=false"];
}
