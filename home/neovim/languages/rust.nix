{pkgs, ...}: {
  programs.nvf.settings.vim = {
    languages.rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
    };
  };

  home = {
    packages = with pkgs; [
      gcc
      rustc
      cargo
      rustfmt
      clippy
      cargo-release
      cargo-flamegraph
    ];
    sessionVariables.LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  };
}
