{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp.servers.basedpyright.settings.basedpyright.analysis.typeCheckingMode = "basic";

    languages.python = {
      enable = true;
      extraDiagnostics.enable = false;
    };
  };

  home.packages = with pkgs; [
    python3
  ];
}
