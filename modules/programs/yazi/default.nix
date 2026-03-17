{
  pkgs,
  config,
  ...
}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    flavors.dracula = "${builtins.fetchGit {
      url = "https://github.com/yazi-rs/flavors.git";
      rev = "ca6165818bb84d46af5fd8f95bedd2b1c395890a";
    }}/dracula.yazi";

    theme.flavor.dark = "dracula";

    plugins = with pkgs.yaziPlugins; {
      inherit ouch chmod full-border git mime-ext;
      kdeconnect-send = builtins.fetchGit {
        url = "https://github.com/Deepak22903/kdeconnect-send.yazi.git";
        rev = "7d9098d25c2bcfa46611a593fb6cef3f431fdfdc";
      };
    };

    initLua =
      # lua
      ''
        require("full-border"):setup()
        require("git"):setup()
      '';

    settings = {
      plugin = {
        prepend_previewers = [
          {
            url = "${config.xdg.userDirs.extraConfig.NEXTCLOUD}/**";
            run = "noop";
          }
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
          {
            id = "mime";
            url = "local://*";
            run = "mime-ext.local";
            prio = "high";
          }
          {
            id = "mime";
            url = "remote://*";
            run = "mime-ext.remote";
            prio = "high";
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
          on = ["K"];
          run = "plugin kdeconnect-send";
          desc = "Send selected files via KDE Connect";
        }
        {
          on = ["g" "s"];
          run = "cd ~/.local/share/Steam/steamapps/common";
          desc = "Go to Steam apps";
        }
        {
          on = ["g" "n"];
          run = "cd ~/Nextcloud";
          desc = "Go to Nextcloud";
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
}
