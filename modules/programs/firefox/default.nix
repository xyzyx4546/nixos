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
      rev = "9954a13541a1d8ca7e84bbb58fce68d60c517490";
    }}/chrome";
  };
}
