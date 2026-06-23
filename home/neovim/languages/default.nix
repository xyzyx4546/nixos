{
  imports = [
    ./c.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./tex.nix
  ];

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

    luaConfigRC.virtual_diagnostic =
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

    keymaps = [
      {
        mode = "n";
        key = "<leader><leader>";
        action = "<CMD>lua require('conform').format()<CR>";
        silent = true;
        desc = "Format";
      }
    ];

    debugger.nvim-dap.ui.enable = true;

    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;
    };
  };
}
