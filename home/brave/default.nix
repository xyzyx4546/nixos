{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.brave-origin = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    ];
    commandLineArgs = ["--hide-crash-restore-bubble"];
  };

  home.activation."mergeBraveSettings" = let
    settings = {
      brave = {
        always_show_bookmark_bar_on_ntp = false;
        enable_window_closing_confirm = false;
        show_side_panel_button = false;
      };
      browser.custom_chrome_frame = false;
      credentials_enable_service = false;
      download.prompt_for_download = false;
      extensions.pinned_extensions = [
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      ];
    };
  in
    lib.hm.dag.entryAfter ["writeBoundary"]
    # bash
    ''
      PREFS="${config.xdg.configHome}/BraveSoftware/Brave-Origin/Default/Preferences"
      mkdir -p "$(dirname "$PREFS")"
      (cat "$PREFS" || echo '{}') | ${lib.getExe pkgs.jq} -c '. * ${builtins.toJSON settings}' > "$PREFS.tmp" && mv "$PREFS.tmp" "$PREFS"
    '';
}
