# TODO: improve
{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    theme = {
      flavor.dark = "dracula";
      manager.hovered = {
        bg = "#44475a";
        bold = true;
      };
    };

    plugins = {
      # FIX: ouch plugin doesnt work properly with large .zip files
      ouch = builtins.fetchGit {
        url = "https://github.com/ndtoan96/ouch.yazi.git";
        rev = "558188d2479d73cafb7ad8fb1bee12b2b59fb607";
      };
      chmod = "${builtins.fetchGit {
        url = "https://github.com/yazi-rs/plugins.git";
        rev = "273019910c1111a388dd20e057606016f4bd0d17";
      }}/chmod.yazi";
      full-border = "${builtins.fetchGit {
        url = "https://github.com/yazi-rs/plugins.git";
        rev = "273019910c1111a388dd20e057606016f4bd0d17";
      }}/full-border.yazi";
      yaziline = builtins.fetchGit {
        url = "https://github.com/llanosrocas/yaziline.yazi.git";
        rev = "1342efed87fe7e408d44b6795ff3a62a478b381d";
      };
    };

    initLua =
      /*
      lua
      */
      ''
        require('full-border'):setup {}
        require('yaziline'):setup {
          separator_style = 'curvy',
          separator_open_thin = "",
          separator_close_thin = "",
          select_symbol = '',
          yank_symbol = '󰆐',
        }
      '';

    settings = {
      plugin = {
        prepend_previewers = [
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
        ];
      };
      manager = {
        ratio = [1 4 3];
        sorty_by = "natural";
        linemode = "size";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = "i";
          run = "spot";
        }
        {
          on = "<A-j>";
          run = "seek 1";
        }
        {
          on = "<A-k>";
          run = "seek -1";
        }
        {
          on = "<Tab>";
          run = "tab_switch -1 --relative";
        }
        {
          on = "<BackTab>";
          run = "tab_switch 1 --relative";
        }
        {
          on = ["g" "x"];
          run = "cd ~/Projects/nixos";
          desc = "Goto NixOS configuration";
        }
        {
          on = ["g" "n"];
          run = "cd /nas";
          desc = "Goto NAS";
        }
        {
          on = "T";
          run = "shell 'gtrash r' --block";
          desc = "Restore files from trash with gtrash";
        }
        {
          on = "C";
          run = "plugin ouch zip";
          desc = "Compress with ouch";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    ouch
    gtrash
  ];

  systemd.user = {
    timers."gtrash-prune" = {
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };

      Install.WantedBy = ["timers.target"];
    };

    services."gtrash-prune".Service.ExecStart = "${pkgs.gtrash}/bin/gtrash prune --day=30";
  };

  xdg.configFile."yazi/flavors/dracula.yazi/".source = builtins.fetchGit {
    url = "https://github.com/dracula/yazi.git";
    rev = "99b60fd76df4cce2778c7e6c611bfd733cf73866";
  };
}
