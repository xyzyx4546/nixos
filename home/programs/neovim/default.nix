{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      lua-language-server nil typescript-language-server pyright
    ];

    plugins = with pkgs.vimPlugins; [
      dracula-nvim

      nvim-autopairs nvim-surround
      nvim-cmp cmp_luasnip cmp-path cmp-buffer cmp-nvim-lsp luasnip friendly-snippets
      comment-nvim
      gitsigns-nvim
      nvim-lspconfig
      telescope-nvim telescope-fzf-native-nvim telescope-ui-select-nvim
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nix
        p.tree-sitter-vim
        p.tree-sitter-bash
        p.tree-sitter-lua
        p.tree-sitter-python
        p.tree-sitter-json
        p.tree-sitter-javascript
      ]))
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/keymaps.lua}
      ${builtins.readFile ./nvim/options.lua}

      ${builtins.readFile ./nvim/plugins/autopairs.lua}
      ${builtins.readFile ./nvim/plugins/cmp.lua}
      ${builtins.readFile ./nvim/plugins/comment.lua}
      ${builtins.readFile ./nvim/plugins/gitsigns.lua}
      ${builtins.readFile ./nvim/plugins/lsp.lua}
      ${builtins.readFile ./nvim/plugins/telescope.lua}
      ${builtins.readFile ./nvim/plugins/treesitter.lua}
    '';
  };
}
