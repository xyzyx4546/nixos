{
  pkgs,
  config,
  ...
}: {
  networking = {
    firewall.allowedUDPPorts = [51820];

    nat = {
      enable = true;
      externalInterface = "end0";
      internalInterfaces = ["wg0"];
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = ["10.100.0.1/24"];
        listenPort = 51820;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${config.networking.nat.externalInterface} -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${config.networking.nat.externalInterface} -j MASQUERADE
        '';
        generatePrivateKeyFile = true;
        privateKeyFile = "/etc/wg-key";
        peers = [
          {
            publicKey = "7/CpYDSbvDq/lk3Ufise0I6SBG7vM0C7AtR3BHwQFHY=";
            allowedIPs = ["10.100.0.0/24"];
          }
        ];
      };
    };
  };

  services.ddclient = {
    enable = true;
    protocol = "duckdns";
    domains = ["ehrhardt.duckdns.org"];
    passwordFile = "/etc/duckdns-token";
  };
}
