{ pkgs, inputs, ... }: {
  programs.firefox = {
    enable = true;

    profiles."xyzyx" = {
      isDefault = true;

      bookmarks = [{ toolbar = true; bookmarks = [
        {
          name = "Gaming";
          bookmarks = [
            {
              name = "Wikis";
              bookmarks = [];
            }
            { name = "Steam keys"; url = "https://www.keyforsteam.de"; }
          ];
        }
        {
          name = "Coding";
          bookmarks = [
            { name = "GitHub"; url = "https://github.com"; }
          ];
        }
        { name = "YouTube"; url = "https://www.youtube.com/feed/subscriptions"; }
      ];}];

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        # More extensions can be found using 'nix flake show "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"'
        proton-pass
        ublock-origin
      ];

      search = {
        default = "Startpage";
        privateDefault = "Startpage";
        engines = {
          "Startpage" = {
            urls = [{ template = "https://www.startpage.com/do/search?prfe=d19326370c2f1d3e6f75079053e84203a4dc781421d147ae7ba652dad1bcd6a2347e3a5077406d1a7e5118441c68c4607f725b821d835f47a1ed2d57032b8cee9b616b23f2063ec95a67438e&query={searchTerms}"; }];
            iconUpdateURL = "https://www.startpage.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@startpage" ];
          };

          "Minecraft" = {
            urls = [{ template = "https://minecraft.wiki/?search={searchTerms}"; }];
            iconUpdateURL = "https://minecraft.wiki/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@minecraft" ];
          };

          "Google".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = true;
        };
      };

      settings = {
        # SPEED
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;

        "browser.cache.jsbc_compression_level" = 3;

        "media.memory_cache_max_size" = 65536;
        "media.cache_readahead_limit" = 7200;
        "media.cache_resume_threshold" = 3600;

        "image.mem.decode_bytes_at_a_time" = 32768;

        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        "network.http.pacing.requests.enabled" = false;
        "network.dnsCacheExpiration" = 3600;
        "network.ssl_tokens_cache_capacity" = 10240;

        "network.dns.disablePrefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = true;
        "network.prefetch-next" = false;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;

        "layout.css.grid-template-masonry-value.enabled" = true;
        "dom.enable_web_task_scheduling" = true;
        "dom.security.sanitizer.enabled" = true;

        # SECURITY
        "browser.contentblocking.category" = "strict";
        "urlclassifier.trackingSkipURLs" = "*.reddit.com = *.twitter.com = *.twimg.com = *.tiktok.com";
        "urlclassifier.features.socialtracking.skipURLs" = "*.instagram.com = *.twitter.com = *.twimg.com";
        "network.cookie.sameSite.noneRequiresSecure" = true;
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.helperApps.deleteTempFileOnExit" = true;
        "browser.uitour.enabled" = false;
        "privacy.globalprivacycontrol.enabled" = true;

        "security.OCSP.enabled" = 0;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "browser.xul.error_pages.expert_bad_cert" = true;
        "security.tls.enable_0rtt_data" = false;

        "browser.privatebrowsing.forceMediaMemoryCache" = true;
        "browser.sessionstore.interval" = 60000;

        "privacy.history.custom" = true;

        "browser.urlbar.trimHttps" = true;
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "browser.urlbar.update2.engineAliasRefresh" = true;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.groupLabels.enabled" = false;
        "browser.formfill.enable" = false;
        "security.insecure_connection_text.enabled" = true;
        "security.insecure_connection_text.pbmode.enabled" = true;
        "network.IDN_show_punycode" = true;

        "dom.security.https_first" = true;
        "dom.security.https_first_schemeless" = true;

        "signon.formlessCapture.enabled" = false;
        "signon.privateBrowsingCapture.enabled" = false;
        "network.auth.subresource-http-auth-allow" = 1;
        "editor.truncate_user_pastes" = false;

        "security.mixed_content.block_display_content" = true;
        "pdfjs.enableScripting" = false;
        "extensions.autoDisableScopes" = 0;
        "extensions.postDownloadThirdPartyPrompt" = false;

        "network.http.referer.XOriginTrimmingPolicy" = 2;

        "privacy.userContext.ui.enabled" = true;

        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        "media.peerconnection.ice.default_address_only" = true;

        "browser.safebrowsing.downloads.remote.enabled" = false;

        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.manager.defaultsUrl" = "";
        "webchannel.allowObject.urlWhitelist" = "";

        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data = =";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        "dom.private-attribution.submission.enabled" = false;

        # LOOK AND FEEL
        "browser.privatebrowsing.vpnpromourl" = "";
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.tabs.tabmanager.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.aboutwelcome.enabled" = false;

        "browser.display.focus_ring_on_anything" = true;
        "browser.display.focus_ring_style" = 0;
        "browser.display.focus_ring_width" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;

        "cookiebanners.service.mode" = 1;
        "cookiebanners.service.mode.privateBrowsing" = 1;

        "browser.translations.enable" = false;

        "browser.urlbar.trending.featureGate" = false;

        "browser.startup.page" = 3;
        "browser.newtabpage.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "always";

        "extensions.pocket.enabled" = false;

        "browser.download.manager.addToRecentDocs" = false;

        "browser.menu.showViewImageInfo" = true;
        "findbar.highlightAll" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "layout.word_select.eat_space_to_next_word" = false;
        "widget.gtk.hide-pointer-while-typing.enabled" = false;

        "apz.overscroll.enabled" = true;
        "general.smoothScroll" = true;
        "mousewheel.default.delta_multiplier_y" = 275;
        "general.smoothScroll.msdPhysics.enabled" = false;
      };
    };

    policies = {
      "AppAutoUpdate" = true;
      "AppAutoUpdate_comment" = "Change to false to disable auto-updates.";
      "DisableFirefoxStudies" = true;
      "DisableTelemetry" = true;
      "DisableFeedbackCommands" = true;
      "DisablePocket" = true;
      "DisableSetDesktopBackground" = true;
      "DisableDeveloperTools" = false;
      "DontCheckDefaultBrowser" = true;
      "DNSOverHTTPS" = {
        "Enabled" = false;
        "ProviderURL" = "";
        "Locked" = false;
      };
      "ManualAppUpdateOnly" = false;
      "ManualAppUpdateOnly_comment" = "Change to true to disable auto-updates.";
      "WebsiteFilter" = {
        "Block" = [
          "https =//localhost/*"
        ];
      };
    };
  };
}
