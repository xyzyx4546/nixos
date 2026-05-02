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
      cargo-release
    ];
    sessionVariables.LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  };
}
