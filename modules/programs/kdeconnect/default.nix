{pkgs, ...}: {
  services.kdeconnect = {
    enable = true;
    # Disable graphical components
    package = pkgs.kdePackages.kdeconnect-kde.overrideAttrs (old: {
      preConfigure =
        (old.preConfigure or "")
        + ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'add_subdirectory(app)' '# add_subdirectory(app)' \
            --replace-fail 'add_subdirectory(indicator)' '# add_subdirectory(indicator)' \
            --replace-fail 'add_subdirectory(urlhandler)' '# add_subdirectory(urlhandler)' \
            --replace-fail 'add_subdirectory(smsapp)' '# add_subdirectory(smsapp)' \
            --replace-fail 'add_subdirectory(plasmoid)' '# add_subdirectory(plasmoid)' \
            --replace-fail 'add_subdirectory(nautilus-extension)' '# add_subdirectory(nautilus-extension)' \
            --replace-fail 'add_subdirectory(fileitemactionplugin)' '# add_subdirectory(fileitemactionplugin)'
        '';
    });
  };
}
