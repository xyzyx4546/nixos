{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [libqalculate];

  programs.dank-material-shell.plugins = let
    mkPlugin = args: {
      enable = true;
      settings = {enabled = true;} // removeAttrs args ["src"];
      src = lib.mkIf (args ? src) (lib.mkForce args.src);
    };
  in {
    calculator = mkPlugin {
      calcEngine = "qalc";
      alwaysActive = true;
      noTrigger = true;
    };
    dankKDEConnect = mkPlugin {
      src = inputs.dux-plugin-registry.packages.${pkgs.stdenv.hostPlatform.system}.dankKDEConnect.overrideAttrs (_: {
        postPatch = ''
          substituteInPlace DankKDEConnect/DankKDEConnect.qml \
            --replace-fail \
            'function autoSelectBestDevice() {' \
            'function autoSelectBestDevice() { selectedDeviceId = "c7bc322559214d9885b2509e457eb5c6"; return;'
        '';
      });
    };
    systemMonitorPlus = mkPlugin {
      cpuUsageEnabled = true;
      ramUsageEnabled = true;
      diskPartitionUsageEnabled = true;
      cpuTempEnabled = false;
      gpuTempEnabled = false;
      cpuUsageVisualStyle = "gauge";
      ramUsageVisualStyle = "gauge";
      diskPartitionUsageVisualStyle = "gauge";
    };
  };
}
