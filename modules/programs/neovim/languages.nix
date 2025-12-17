{pkgs, ...}: {
  programs.nvf.settings.vim = {
    lsp = {
      enable = true;
      inlayHints.enable = true;
      mappings = {
        renameSymbol = "lr";
        toggleFormatOnSave = null;
        format = "<leader><leader>";
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

    # TODO:
    # LaTeX support
    extraPlugins."vimtex".package = pkgs.vimPlugins.vimtex;
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
