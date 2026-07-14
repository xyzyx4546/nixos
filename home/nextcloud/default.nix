{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}: let
  dcalPkg = inputs.dcal.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    patches = (old.patches or []) ++ [./dcal.patch];
  });
in {
  imports = [inputs.dcal.homeModules.default];

  home.activation."setup-dcal" = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${lib.getExe dcalPkg} account add caldav \
      --name "Nextcloud" \
      --url "https://fam-ehrhardt.de/remote.php/dav" \
      --username "david" \
      --password "$(cat ${osConfig.sops.secrets."nextcloud/webdav".path})"

    ${lib.getExe dcalPkg} account add ical \
      --name "Lectures" \
      "https://dhbw.app/ical/STG-TINF24F"
  '';

  programs = {
    dank-calendar = {
      enable = true;
      package = dcalPkg;
      systemd.enable = true;
      settings.showWeekNumbers = true;
    };

    rclone = {
      enable = true;
      requiresUnit = "run-secrets.d.mount";
      remotes."nextcloud" = {
        config = {
          type = "webdav";
          url = "https://fam-ehrhardt.de/remote.php/dav/files/david";
          vendor = "nextcloud";
          user = "david";
        };
        secrets.pass = osConfig.sops.secrets."nextcloud/webdav".path;
        mounts."/" = {
          enable = true;
          mountPoint = config.xdg.userDirs.extraConfig.NEXTCLOUD;
          options = {
            vfs-cache-mode = "full";
            vfs-cache-max-age = "24h";
            no-modtime = true;
            no-checksum = true;
          };
        };
      };
    };
  };
}
