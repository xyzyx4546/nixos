{pkgs, ...}: {
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "David Ehrhardt";
          email = "d.ehrhardt@proton.me";
        };
        credential.helper = "store";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-eco
        gh-f
        gh-i
        gh-s
      ];
    };

    gh-dash = {
      enable = true;
      settings = {
        theme = {
          ui.table.compact = true;
          colors = {
            text = {
              primary = "#f8f8f2";
              secondary = "#bd93f9";
              inverted = "#282a36";
              faint = "#f1fa8c";
              warning = "#ff5555";
              success = "#50fa7b";
            };
            background.selected = "#44475a";
            border = {
              primary = "#44475a";
              secondary = "#44475a";
              faint = "#44475a";
            };
          };
        };
      };
    };

    lazygit = {
      enable = true;
      settings = {
        theme = {
          activeBorderColor = ["#FF79C6" "bold"];
          inactiveBorderColor = ["#BD93F9"];
          searchingActiveBorderColor = ["#8BE9FD" "bold"];
          optionsTextColor = ["#6272A4"];
          selectedLineBgColor = ["#6272A4"];
          inactiveViewSelectedLineBgColor = ["bold"];
          cherryPickedCommitFgColor = ["#6272A4"];
          cherryPickedCommitBgColor = ["#8BE9FD"];
          markedBaseCommitFgColor = ["#8BE9FD"];
          markedBaseCommitBgColor = ["#F1FA8C"];
          unstagedChangesColor = ["#FF5555"];
          defaultFgColor = ["#F8F8F2"];
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
