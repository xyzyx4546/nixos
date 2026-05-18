{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./keymaps.nix
    ./languages
  ];

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "dracula";
        transparent = true;
      };

      highlight = {
        Pmenu = {bg = null;};
        StatusLine = {bg = null;};
        StatusLineTerm = {bg = null;};
        LspReferenceText = {bg = "#44475a";};
        LspReferenceRead = {bg = "#44475a";};
        LspReferenceWrite = {bg = "#44475a";};
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };
      lineNumberMode = "relNumber";

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      options = {
        expandtab = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        mouse = "a";
        showmode = false;
      };

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
                action = "lua PROJECTS()";
              }
              {
                icon = "  ";
                desc = "Configuration";
                key = "x";
                action = "lua PROJECTS('nixos')";
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
            "<esc>" = lib.mkLuaInline "require('telescope.actions').close";
            "<C-j>" = lib.mkLuaInline "require('telescope.actions').move_selection_next";
            "<C-k>" = lib.mkLuaInline "require('telescope.actions').move_selection_previous";
            "<M-h>" = lib.mkLuaInline "require('telescope.actions').preview_scrolling_left";
            "<M-j>" = lib.mkLuaInline "require('telescope.actions').preview_scrolling_down";
            "<M-k>" = lib.mkLuaInline "require('telescope.actions').preview_scrolling_up";
            "<M-l>" = lib.mkLuaInline "require('telescope.actions').preview_scrolling_right";
          };
        };
      };

      terminal.toggleterm = {
        enable = true;
        lazygit = {
          enable = true;
          mappings.open = "<leader>tl";
        };
        setupOpts = {
          direction = "float";
          open_mapping = "<C-t>";
          persist_mode = false;
          close_on_exit = true;
          # HACK: shouldn't be needed due to `ui.borders.globalStyle = "rounded"`
          float_opts.border = "curved";
        };
      };

      git.gitsigns = {
        enable = true;
        mappings.toggleDeleted = null;
      };

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
        setupOpts.completion = {
          # HACK: shouldn't be needed due to `ui.borders.globalStyle = "rounded"`
          menu.border = "rounded";
          documentation.window.border = "rounded";
          ghost_text.enabled = true;
        };
      };

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

      utility = {
        ccc.enable = true;
        snacks-nvim = {
          enable = true;
          setupOpts = {
            indent.enabled = true;
            input.enabled = true;
            picker.enabled = true;
            words.enabled = true;
          };
        };
        yazi-nvim = {
          enable = true;
          mappings = {
            openYazi = "<leader>e";
            openYaziDir = "<leader>E";
          };
          setupOpts = {
            open_for_directories = true;
            keymaps.change_working_directory = "<C-c>";
          };
        };
      };

      mini = {
        ai.enable = true;
        comment.enable = true;
        move.enable = true;
        pairs.enable = true;
        surround.enable = true;

        git.enable = true;
      };

      presence.neocord = {
        enable = true;
        setupOpts.logo = "https://raw.githubusercontent.com/IogaMaster/neocord/cb9f5234941bf4a53cd69d2f321734a650e7d442/assets/logos/Neovim.png";
      };

      extraPlugins = with pkgs.vimPlugins; {
        "sops.nvim".package = pkgs.vimUtils.buildVimPlugin {
          pname = "sops.nvim";
          version = "latest";
          src = pkgs.fetchFromGitHub {
            owner = "trixnz";
            repo = "sops.nvim";
            rev = "5946285744ffef26b792839d9130135365bfa8ea";
            hash = "sha256-6BFgZSQwrh218genHjnldv1xnCjx4PIoXZcFYKVBlGo=";
          };
        };

        "heirline" = {
          package = heirline-nvim;
          setup = builtins.readFile ./lua/heirline.lua;
        };
      };

      extraPackages = with pkgs; [
        sops
      ];

      extraLuaFiles = [
        ./lua/projects.lua
      ];
    };
  };
}
