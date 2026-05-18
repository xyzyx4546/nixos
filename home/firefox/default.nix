# TODO: wait for ladybird
{inputs, ...}: {
  imports = [
    ./bookmarks.nix
    ./options.nix
    ./search.nix
  ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    profiles."xyzyx" = {
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        # More extensions can be found using
        # nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"
        bitwarden
        ublock-origin
        darkreader
      ];
    };
  };
}
