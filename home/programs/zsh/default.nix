{ pkgs, ... }: {
  home.packages = with pkgs; [
    fzf
    eza
    bat
    ncdu
  ];

  programs.starship = {
    enable = true;

    settings = {
      add_newline = true;
      format = ''
        ╭─$directory$username@$hostname$git_branch$cmd_duration
        ╰─$character
      '';

      character = {
        success_symbol = "[](bold bright-green)";
        error_symbol = "[](bold red)";
      };

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
      git_branch = {
        format = "  [ $branch](bold #F1502F)";
      };
      cmd_duration = {
        format = "  [󰄉 $duration](bold #808080)";
      };

      scan_timeout = 10;
    };
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      c = "clear";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -alh --icons";
      tree = "eza -T --icons";
      du = "ncdu";
    };

    antidote = {
      enable = true;
      
      plugins = [
        "MichaelAquilina/zsh-auto-notify"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zsh-users/zsh-syntax-highlighting"
        "Aloxaf/fzf-tab"
      ];
    };

    initExtra = ''
      # auto notify
      export AUTO_NOTIFY_THRESHOLD=20
      export AUTO_NOTIFY_IGNORE=( "ranger" "nvim" "man" "fzf" "btop" "bat" "ncdu" )

      # history substring search
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down

      # fzf
      eval "$(${pkgs.fzf}/bin/fzf --zsh)"
      autoload -Uz compinit && compinit
      zstyle ':completion:*' menu yes
      zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
      bindkey '^ ' fzf-completion

      # autosuggestions
      ZSH_AUTOSUGGEST_STRATEGY=(completion history)
      bindkey '^I' autosuggest-accept
    '';
  };
}
