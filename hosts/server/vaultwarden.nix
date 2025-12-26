{
  config,
  domain,
  ...
}: {
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/backup/vaultwarden";
    environmentFile = config.sops.secrets."vaultwarden/password".path;
    config = {
      # https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
      DOMAIN = "https://vault.${domain}";
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = true;

      USER_ATTACHMENT_LIMIT = 0;

      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      ROCKET_LOG = "critical";
    };
  };

  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "01:00:00";

  backup.paths = [config.services.vaultwarden.backupDir];
}
