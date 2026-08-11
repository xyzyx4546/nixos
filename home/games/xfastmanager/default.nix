{pkgs ? import <nixpkgs> {}}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "xfastmanager";
  version = "1.2.5";

  src = pkgs.fetchFromGitHub {
    owner = "CCA3370";
    repo = "XFast-Manager";
    rev = "v${version}";
    hash = "sha256-6/b2C5ctjHg+uE9c9vnTxQHGOAETqB9Y45WWyo0N/JY=";
  };

  cargoHash = "sha256-MHvkJmg+ukZu4OLypnZQyqLR6k9Qf+MivQIAuIbtGWo=";

  npmDeps = pkgs.fetchNpmDeps {
    inherit src;
    hash = "sha256-E9bgLXEksoqgLy0X/INaeZgIhqLoUCjfzENhyAWjvLo=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
    perl
    nodejs
    npmHooks.npmConfigHook
    cargo-tauri.hook
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    webkitgtk_4_1
  ];

  patches = [./xfastmanager.patch];

  TAURI_SIGNING_PRIVATE_KEY = "";
}
