{
  config,
  domain,
  ...
}: {
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
      };
    };

    matter-server.enable = true;

    nginx.virtualHosts."home.${domain}" = {
      forceSSL = true;
      useACMEHost = domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8123";
        proxyWebsockets = true;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0600 hass hass -"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0600 hass hass -"
    "f ${config.services.home-assistant.configDir}/scripts.yaml 0600 hass hass -"
  ];

  backup.paths = [
    "${config.services.home-assistant.configDir}/.storage"
    "${config.services.home-assistant.configDir}/automations.yaml"
    "${config.services.home-assistant.configDir}/scenes.yaml"
    "${config.services.home-assistant.configDir}/scripts.yaml"
    "${config.services.home-assistant.configDir}/home-assistant_v2.db"
  ];
}
