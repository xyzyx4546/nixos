{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp.servers.texlab = {
      cmd = ["${pkgs.texlab}/bin/texlab"];
      filetypes = ["tex"];
    };

    extraPlugins."vimtex".package = pkgs.vimPlugins.vimtex;
    formatter.conform-nvim.setupOpts.formatters_by_ft.tex = ["latexindent"];
    globals.vimtex_quickfix_mode = 0;
  };

  home.packages = with pkgs; [
    texliveFull
  ];
}
