{
  pkgs,
  lib,
  config,
  ...
}: {
  fileSystems = {
    "/mnt/nextcloud" = {
      device = "/dev/disk/by-label/NEXTCLOUD";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-label/BACKUP";
      fsType = "ext4";
      options = ["defaults" "noatime" "nofail"];
    };
  };

  services = {
    nextcloud = let
      customNextcloud = pkgs.nextcloud31.overrideAttrs {
        postInstall =
          lib.concatMapStrings (app: ''
            if [ ! -d "$out/apps/${lib.escapeShellArg app}" ]; then
              echo "Error: App directory '$out/apps/${lib.escapeShellArg app}' does not exist!" >&2
              exit 1
            fi
            rm -rf "$out/apps/${lib.escapeShellArg app}"
          '')
          [
            "activity"
            "admin_audit"
            "app_api"
            "bruteforcesettings"
            "circles"
            "cloud_federation_api"
            "comments"
            "contactsinteraction"
            "dashboard"
            "encryption"
            "federation"
            "files_downloadlimit"
            "files_external"
            "files_reminders"
            "files_versions"
            "firstrunwizard"
            "logreader"
            "nextcloud_announcements"
            "notifications"
            "password_policy"
            "photos"
            "privacy"
            "profile"
            "recommendations"
            "related_resources"
            "sharebymail"
            "support"
            "survey_client"
            "suspicious_login"
            "systemtags"
            "twofactor_backupcodes"
            "twofactor_nextcloud_notification"
            "twofactor_totp"
            "updatenotification"
            "user_ldap"
            "user_status"
            "weather_status"
            "webhook_listeners"
            "workflowengine"
          ];
      };
    in {
      enable = true;
      package = customNextcloud;
      https = true;
      hostName = "ehrhardt.duckdns.org";
      datadir = "/mnt/nextcloud";
      configureRedis = true;
      config = {
        adminpassFile = "${pkgs.writeText "nextcloud-pass" "nextcloud1"}";
        adminuser = "david";
        dbtype = "sqlite";
      };
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit groupfolders news calendar;
      };
    };

    borgbackup.jobs."nextcloud" = {
      user = "nextcloud";
      paths = "/mnt/nextcloud/data";
      exclude = ["/mnt/nextcloud/data/appdata_*" "/mnt/nextcloud/data/index.html"];
      repo = "/mnt/backup";
      doInit = false;
      encryption.mode = "none";
      startAt = "daily";
      preHook = "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on";
      postHook = "${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off";
      prune.keep = {
        daily = 7;
        monthly = 6;
        yearly = -1;
      };
    };
  };
  environment.variables."BORG_REPO" = "/mnt/backup";

  systemd.services = {
    # HACK: Ensure tmpfiles are created after the nextcloud mount is available
    "systemd-tmpfiles-resetup" = {
      after = ["mnt-nextcloud.mount"];
      wants = ["mnt-nextcloud.mount"];
    };
    # HACK: Ensure borgbackup can toggle maintenance mode
    "borgbackup-job-nextcloud".serviceConfig.ReadWritePaths = ["/mnt/nextcloud"];
  };
}
