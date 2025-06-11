{
  pkgs,
  lib,
  ...
}: {
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
      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };
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
          mappings.i = {
            "<esc>" = lib.generators.mkLuaInline "require('telescope.actions').close";
            "<C-j>" = lib.generators.mkLuaInline "require('telescope.actions').move_selection_next";
            "<C-k>" = lib.generators.mkLuaInline "require('telescope.actions').move_selection_previous";
            "<M-h>" = lib.generators.mkLuaInline "require('telescope.actions').preview_scrolling_left";
            "<M-j>" = lib.generators.mkLuaInline "require('telescope.actions').preview_scrolling_down";
            "<M-k>" = lib.generators.mkLuaInline "require('telescope.actions').preview_scrolling_up";
            "<M-l>" = lib.generators.mkLuaInline "require('telescope.actions').preview_scrolling_right";
          };
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

      # Git integration
      git = {
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };

      # Autocompletion
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          close = "Esc";
          confirm = "<Tab>";
          next = "<C-j>";
          previous = "<C-k>";
          scrollDocsDown = "<M-j>";
          scrollDocsUp = "<M-k>";
        };
        setupOpts = {
          completion = {
            menu.border = "rounded";
            documentation.window.border = "rounded";
            ghost_text.enabled = true;
          };
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

      startPlugins = with pkgs.vimPlugins; [
        heirline-nvim
        nvim-tree-lua
        nix-develop-nvim
        dressing-nvim
        nvim-sops
        presence-nvim
      ];

      extraLuaFiles = [
        ./heirline.lua
        ./tree.lua
        ./projects.lua
        ./terminals.lua
      ];
    };
  };
}
/*
vim.autocomplete.blink-cmp.setupOpts.keymap = {
  preset = "none";

  "<Up>" = ["select_prev" "fallback"];
  "<C-n>" = [
    (lib.generators.mkLuaInline '''
      function(cmp)
        if some_condition then return end -- runs the next command
          return true -- doesn't run the next command
        end,
    ''')
    "select_next"
  ];
};
*/

