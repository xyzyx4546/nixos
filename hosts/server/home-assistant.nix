{config, ...}: {
  services = {
    home-assistant = {
      enable = true;
      extraComponents = ["matter"];
      config = {
        default_config = {};
        homeassistant = {
          name = "Home";
          unit_system = "metric";
          time_zone = "Europe/Berlin";
        };
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = ["127.0.0.1" "::1"];
        };
      };
    };

    matter-server.enable = true;

    borgbackup.jobs.main.paths = [
      "${config.services.home-assistant.configDir}/.storage"
      "${config.services.home-assistant.configDir}/automations.yaml"
      "${config.services.home-assistant.configDir}/scenes.yaml"
      "${config.services.home-assistant.configDir}/scripts.yaml"
      "${config.services.home-assistant.configDir}/home-assistant_v2.db"
    ];
  };

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0600 hass hass -"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0600 hass hass -"
    "f ${config.services.home-assistant.configDir}/scripts.yaml 0600 hass hass -"
  ];

  networking.firewall.allowedUDPPorts = [5353];
}
