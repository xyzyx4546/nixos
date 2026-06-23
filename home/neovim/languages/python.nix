{pkgs, ...}: {
  programs.nvf.settings.vim.languages.python = {
    enable = true;
    extraDiagnostics.enable = false;
  };

  home.packages = with pkgs; [
    python3
  ];
}
