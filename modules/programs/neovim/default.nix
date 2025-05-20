{pkgs, ...}: {
  imports = [
    ./keymaps.nix
    ./languages.nix
  ];

  programs.nvf = {
    enable = true;
    settings.vim = {
      # Theme and appearance settings
      theme = {
        enable = true;
        name = "dracula";
        transparent = true;
      };

      highlight = {
        TelescopeNormal = {bg = null;};
        NormalFloat = {bg = null;};
        FloatBorder = {bg = null;};
        Pmenu = {bg = null;};
        TabLineFill = {bg = null;};
        StatusLine = {bg = null;};
      };

      # General editor settings
      useSystemClipboard = true;
      lineNumberMode = "relNumber";

      globals = {
        mapleader = " ";
        maplocalleader = " ";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };

      options = {
        expandtab = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        mouse = "a";
        showmode = false;
      };

      # Dashboard configuration
      dashboard.dashboard-nvim = {
        enable = true;
        setupOpts = {
          theme = "doom";
          config = {
            header = [
              "                                                                   "
              "      ████ ██████           █████      ██                    "
              "     ███████████             █████                            "
              "     █████████ ███████████████████ ███   ███████████  "
              "    █████████  ███    █████████████ █████ ██████████████  "
              "   █████████ ██████████ █████████ █████ █████ ████ █████  "
              " ███████████ ███    ███ █████████ █████ █████ ████ █████ "
              "██████  █████████████████████ ████ █████ █████ ████ ██████"
              ""
              ""
              ""
              ""
            ];
            center = [
              {
                icon = "  ";
                desc = "New file                                 ";
                key = "e";
                action = "ene | startinsert";
              }
              {
                icon = "  ";
                desc = "Find file";
                key = "f";
                action = "cd $HOME | Telescope find_files";
              }
              {
                icon = "  ";
                desc = "Find project";
                key = "p";
                action = "lua _PROJECTS()";
              }
              {
                icon = "  ";
                desc = "Configuration";
                key = "x";
                action = "lua _PROJECTS('nixos')";
              }
              {
                icon = "  ";
                desc = "Quit";
                key = "q";
                action = "quitall";
              }
            ];
            footer = [];
            vertical_center = true;
          };
        };
      };

      # UI and visual plugins
      notify.nvim-notify = {
        enable = true;
        setupOpts = {
          top_down = false;
          stages = "slide";
        };
      };

      ui = {
        noice.enable = true;
        borders = {
          enable = true;
          globalStyle = "rounded";
        };
      };

      visuals.nvim-web-devicons.enable = true;

      telescope = {
        enable = true;
        setupOpts.defaults = {
          prompt_prefix = " ";
          selection_caret = " ";
          # FIX:
          # mappings = {
          #   i = {
          #     ['<esc>'] = require('telescope.actions').close,
          #     ['<C-j>'] = require('telescope.actions').move_selection_next,
          #     ['<C-k>'] = require('telescope.actions').move_selection_previous,
          #     ['<M-h>'] = require('telescope.actions').preview_scrolling_left,
          #     ['<M-j>'] = require('telescope.actions').preview_scrolling_down,
          #     ['<M-k>'] = require('telescope.actions').preview_scrolling_up,
          #     ['<M-l>'] = require('telescope.actions').preview_scrolling_right,
          #   }
          # },
        };
      };

      # Terminal settings
      terminal.toggleterm = {
        enable = true;
        setupOpts = {
          direction = "float";
          open_mapping = "<C-t>";
          persist_mode = false;
          close_on_exit = true;
        };
      };

      # Utility plugins
      binds.whichKey.enable = true;

      notes.todo-comments = {
        enable = true;
        mappings.telescope = "<leader>ft";
        setupOpts.highlight = {
          before = "";
          keyword = "bg";
          after = "fg";
        };
      };

      autopairs.nvim-autopairs.enable = true;

      comments.comment-nvim.enable = true;

      utility = {
        surround.enable = true;
        ccc.enable = true;
      };

      # Git integration
      git = {
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };

      # Snippets and autocompletion
      snippets.luasnip.enable = true;

      # TODO: Formatting of cmp window
      # TODO: Remove Treesitter suggestions
      autocomplete.nvim-cmp = {
        enable = true;
        mappings = {
          close = "Esc";
          confirm = "<Tab>";
          next = "<Down>";
          previous = "<Up>";
          scrollDocsDown = "<M-j>";
          scrollDocsUp = "<M-k>";
        };
        setupOpts.experimental.ghost_text = true;
      };

      startPlugins = with pkgs.vimPlugins; [
        heirline-nvim
        nvim-tree-lua
        nix-develop-nvim
        dressing-nvim
        nvim-sops
      ];

      extraLuaFiles = [
        ./heirline.lua
        ./tree.lua
        ./projects.lua
        ./snippets.lua
        ./terminals.lua
      ];
    };
  };
}
