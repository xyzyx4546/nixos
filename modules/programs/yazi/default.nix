{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    flavors = {
      dracula = builtins.fetchGit {
        url = "https://github.com/dracula/yazi.git";
        rev = "99b60fd76df4cce2778c7e6c611bfd733cf73866";
      };
    };

    theme = {
      flavor.dark = "dracula";
      mgr.hovered = {
        bg = "#44475a";
        bold = true;
      };
    };

    plugins = with pkgs.yaziPlugins; {
      inherit ouch chmod full-border git;
      gvfs = builtins.fetchGit {
        url = "https://github.com/boydaihungst/gvfs.yazi.git";
        rev = "b58c30588215093cb6f8b0dc4eed562894c091bc";
      };
      yaziline = builtins.fetchGit {
        url = "https://github.com/llanosrocas/yaziline.yazi.git";
        rev = "1342efed87fe7e408d44b6795ff3a62a478b381d";
      };
    };

    initLua =
      # lua
      ''
        require("full-border"):setup()
        require("git"):setup()
        require("gvfs"):setup({
          password_vault = "keyring",
          save_password_autoconfirm = true,
        })
        require("yaziline"):setup({
          separator_style = "curvy",
          separator_open_thin = "",
          separator_close_thin = "",
          select_symbol = "",
          yank_symbol = "󰆐",
        })
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
            mime = "application/vnd.rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
          {
            mime = "application/xz";
            run = "ouch";
          }
          {
            mime = "application/x-zstd";
            run = "ouch";
          }
          {
            mime = "application/zstd";
            run = "ouch";
          }
          {
            mime = "application/java-archive";
            run = "ouch";
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
      mgr = {
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
      mgr.prepend_keymap = [
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
          on = "T";
          run = "shell 'gtrash r' --block";
          desc = "Restore files from trash with gtrash";
        }
        {
          on = ["c" "a"];
          run = "plugin ouch zip";
          desc = "Compress with ouch";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = ["M" "m"];
          run = "plugin gvfs -- select-then-mount --jump";
          desc = "Mount device";
        }
        {
          on = ["M" "u"];
          run = "plugin gvfs -- select-then-unmount --eject";
          desc = "Eject device";
        }
        {
          on = ["M" "U"];
          run = "plugin gvfs -- select-then-unmount --eject --force";
          desc = "Force eject device";
        }
        {
          on = ["M" "a"];
          run = "plugin gvfs -- add-mount";
          desc = "Add mount URI";
        }
        {
          on = ["M" "e"];
          run = "plugin gvfs -- edit-mount";
          desc = "Edit mount URI";
        }
        {
          on = ["M" "r"];
          run = "plugin gvfs -- remove-mount";
          desc = "Remove mount URI";
        }
        {
          on = ["g" "m"];
          run = "plugin gvfs -- jump-to-device";
          desc = "Jump to device";
        }
        {
          on = ["g" "M"];
          run = "plugin gvfs -- jump-back-prev-cwd";
          desc = "Jump back from device";
        }
        {
          on = ["g" "s"];
          run = "cd ~/.local/share/Steam/steamapps/common";
          desc = "Go to Steam apps";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    ouch
    gtrash
    glib
    libsecret
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
}
