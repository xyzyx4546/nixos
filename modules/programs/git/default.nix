{ pkgs, ... }: {
  home.packages = with pkgs; [
    glab
  ];

  programs = {
    git = {
      enable = true;
      userName = "David Ehrhardt";
      userEmail = "d.ehrhardt@proton.me";
      extraConfig = {
        credential.helper = "store";
        credential."https://gitlab.com".helper = "${pkgs.glab}/bin/glab auth git-credential";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    lazygit = {
      enable = true;

      settings = {
        theme = {
          activeBorderColor = [ "#FF79C6" "bold" ];
          inactiveBorderColor = [ "#BD93F9" ];
          searchingActiveBorderColor = [ "#8BE9FD" "bold" ];
          optionsTextColor = [ "#6272A4" ];
          selectedLineBgColor = [ "#6272A4" ];
          inactiveViewSelectedLineBgColor = [ "bold" ];
          cherryPickedCommitFgColor = [ "#6272A4" ];
          cherryPickedCommitBgColor = [ "#8BE9FD" ];
          markedBaseCommitFgColor = [ "#8BE9FD" ];
          markedBaseCommitBgColor = [ "#F1FA8C" ];
          unstagedChangesColor = [ "#FF5555" ];
          defaultFgColor = [ "#F8F8F2" ];
        };
        keybinding.universal = {
          nextBlock-alt2 = "]";
          prevBlock-alt2 = "[";
          nextTab = "<tab>";
          prevTab = "<backtab>";
        };
      };
    };
  };
}
