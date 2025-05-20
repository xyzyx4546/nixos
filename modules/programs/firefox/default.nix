# TODO: wait for ladybird
{inputs, ...}: {
  imports = [
    ./bookmarks.nix
    ./options.nix
    ./search.nix
  ];

  programs.firefox = {
    enable = true;

    profiles."xyzyx" = {
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        # More extensions can be found using
        # nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        proton-pass
        ublock-origin
      ];
    };
  };

  home.file.".mozilla/firefox/xyzyx/chrome" = {
    source = "${builtins.fetchGit {
      url = "https://github.com/amnweb/firefox-plus.git";
      rev = "56709c4b0fd056bde8fee531dfaab1a58385c2cb";
    }}/chrome";
  };
}
