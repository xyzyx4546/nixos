{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.callPackage ../../packages/lazytimer {inherit pkgs;})
    ncdu
    wev
    nix-prefetch-git
    nix-output-monitor
    tokei
    tldr
    speedtest-go
    asciiquarium-transparent
    neofetch
    duf
    libqalculate
    jq
    dnsutils
  ];

  xdg.configFile."neofetch/config.conf".source = ./neofetch.conf;

  programs = {
    fzf = {
      enable = true;
      changeDirWidgetOptions = ["--preview 'eza --tree --color=always --icons=always --level=5 {} | head -200'"];
      defaultOptions = [
        "--min-height 500"
        "--border"
      ];
      colors = {
        fg = "#f8f8f2";
        hl = "#bd93f9";
        "fg+" = "#f8f8f2";
        "bg+" = "#44475a";
        "hl+" = "#bd93f9";
        info = "#ffb86c";
        prompt = "#50fa7b";
        pointer = "#ff79c6";
        marker = "#ff79c6";
        spinner = "#ffb86c";
        header = "#6272a4";
      };
    };

    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
      ];
      config = {
        theme = "Dracula";
      };
    };

    btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        theme_background = false;
        vim_keys = true;
        update_ms = 1000;
        disk_free_priv = true;
      };
    };

    eza = {
      enable = true;
      colors = "always";
      icons = "always";
    };

    starship = {
      enable = true;
      settings = {
        format = ''
          [╭─](#808080)$directory$username@$hostname$cmd_duration
          [╰─](#808080)$character
        '';
        directory = {
          format = "[ $path](bold blue)";
          truncation_symbol = "…/";
        };
        username = {
          format = "  [ $user](bold yellow)";
          show_always = true;
        };
        hostname = {
          format = "[$hostname](bold yellow)";
          ssh_only = false;
        };
        cmd_duration = {
          format = "  [󰄉 $duration](bold #808080)";
        };
        add_newline = false;
      };
    };

    zsh = {
      enable = true;

      shellAliases = {
        c = "clear";
        cat = "bat";
        ls = "eza";
        ll = "eza -alh";
        tree = "eza -T";
        du = "ncdu";
        df = "duf --only local,network --hide-mp /nix/store --theme ansi";
        y = "yazi";
        t = "tmux new-session -A -s main";
      };

      autosuggestion.enable = true;
      autosuggestion.strategy = ["completion" "history"];
      historySubstringSearch.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];

      initContent = ''
        # fix vi mode
        export KEYTIMEOUT=1

        # history substring search
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down

        # fzf
        bindkey '^ ' fzf-completion
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
        zstyle ':fzf-tab:*' use-fzf-default-opts yes
        zstyle ':fzf-tab:*' switch-group '<' '>'
        zstyle ':fzf-tab:*' fzf-min-height 500
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza --tree --color=always --icons=always --level=3 $realpath | head -200'

        # autosuggestions
        bindkey '^I' autosuggest-accept

        # fix empty line
        precmd() {
          precmd() {
            if [[ "$(fc -nl -1)" != "clear" && "$(fc -nl -1)" != "c" ]]; then
              echo
            fi
          }
        }
      '';
    };
  };
}
