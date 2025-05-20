{
  programs.firefox.profiles."xyzyx".search = {
    default = "Startpage";
    force = true;
    privateDefault = "Startpage";

    engines = {
      # --- Default ---
      "Startpage" = {
        urls = [{template = "https://www.startpage.com/do/search?prfe=d19326370c2f1d3e6f75079053e84203a4dc781421d147ae7ba652dad1bcd6a2347e3a5077406d1a7e5118441c68c4607f725b821d835f47a1ed2d57032b8cee9b616b23f2063ec95a67438e&query={searchTerms}";}];
        icon = "https://www.startpage.com/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@startpage"];
      };

      # --- NixOS ---
      "NixOS Packages" = {
        urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
        icon = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@packages"];
      };
      "NixOS Options" = {
        urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
        icon = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@nixos"];
      };
      "Homemanager" = {
        urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";}];
        icon = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@homemanager"];
      };

      # --- Wikis ---
      "Minecraft" = {
        urls = [{template = "https://minecraft.wiki/?search={searchTerms}";}];
        icon = "https://minecraft.wiki/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@minecraft"];
      };
      "Subnautica" = {
        urls = [{template = "https://subnautica.fandom.com/wiki/Special:Search?query={searchTerms}&scope=internal&navigationSearch=true";}];
        icon = "https://static.wikia.nocookie.net/subnautica/images/e/e6/Site-logo.png";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@subnautica"];
      };
      "Satisfactory" = {
        urls = [{template = "https://satisfactory.fandom.com/wiki/Special:Search?query={searchTerms}&scope=internal&navigationSearch=true";}];
        icon = "https://static.wikia.nocookie.net/satisfactory_gamepedia_en/images/e/e6/Site-logo.png";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@satisfactory"];
      };

      # --- Misc ---
      "Proton DB" = {
        urls = [{template = "https://protondb.com/search?q={searchTerms}";}];
        icon = "https://protondb.com/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@protondb"];
      };
      "Steam Keys" = {
        urls = [{template = "https://www.keyforsteam.de/katalog/?search_name={searchTerms}";}];
        icon = "https://keyforsteam.de/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@steamkeys"];
      };

      "google".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ddg".metaData.hidden = true;
      "wikipedia".metaData.hidden = true;
    };
  };
}
