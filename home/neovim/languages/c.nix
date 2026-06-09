{pkgs, ...}: {
  programs.nvf.settings.vim.languages.clang.enable = true;

  home.packages = with pkgs; [
    gcc
    cmake
  ];
}
