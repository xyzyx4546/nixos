{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
      mappings = {
        renameSymbol = "<leader>lr";
        toggleFormatOnSave = null;
        format = null;
      };
    };

    luaConfigPost =
      # lua
      ''
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
        vim.keymap.set('n', '<leader>tv', function()
          vim.diagnostic.config({
            virtual_lines = not vim.diagnostic.config().virtual_lines,
            virtual_text = not vim.diagnostic.config().virtual_text,
          })
        end, { desc = 'Toggle diagnostic virtual lines and virtual text' })
        -- HACK: lsp.mappings.format currently doesnt always use conform
        vim.keymap.set('n', '<leader><leader>', require('conform').format, { desc = 'Format' })
      '';

    # Languages
    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;

      bash.enable = true;
      css.enable = true;
      html.enable = true;
      lua.enable = true;
      nix.enable = true;
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      ts.enable = true;
    };

    # LaTeX support
    extraPlugins."vimtex".package = pkgs.vimPlugins.vimtex;
    formatter.conform-nvim.setupOpts.formatters_by_ft.tex = ["latexindent"];
    globals.vimtex_quickfix_mode = 0;

    extraPackages = with pkgs; [
      rustfmt
      rustc
      texlab
    ];
  };

  home.packages = with pkgs; [
    cargo
    gcc
    gnumake
    nodejs
    bun
    texliveFull
  ];
}
