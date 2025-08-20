{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      formatOnSave = false;
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

        vim.keymap.set('n', '<leader><leader>', require('conform').format, { desc = 'Format file' })
      '';

    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        format_after_save = null;
        format_on_save = null;
      };
    };

    # Languages
    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;

      bash.enable = true;
      clang.enable = true;
      css = {
        enable = true;
        format.type = "prettierd";
      };
      html.enable = true;
      lua.enable = true;
      markdown = {
        enable = true;
        extensions.render-markdown-nvim.enable = true;
      };
      nix = {
        enable = true;
        lsp.server = "nixd";
      };
      python.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };
      ts = {
        enable = true;
        format.type = "prettierd";
      };
    };

    # LaTeX support
    extraPlugins = with pkgs.vimPlugins; {
      "vimtex" = {
        package = vimtex;
        setup = "require('lspconfig').texlab.setup {}";
      };
    };
    formatter.conform-nvim.setupOpts.formatters_by_ft.tex = ["latexindent"];

    extraPackages = with pkgs; [
      rustfmt
      rustc
      texlab
    ];
  };

  programs.bun.enable = true;
  home.packages = with pkgs; [
    cargo
    gcc
    gnumake
    nodejs
    texliveFull
  ];
}
