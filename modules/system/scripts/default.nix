{ pkgs, ... }: {
  home.packages = with pkgs.writers; let
    makePythonScript = name: libraries: flakeIgnore: writePython3Bin name {
      inherit libraries;
      inherit flakeIgnore;
    } ./scripts/${name};
  in [
    # (makePythonScript "close_empty_workspaces.py" [] [ "E501" ])
    (makePythonScript "material.py" [pkgs.python312Packages.jinja2 pkgs.python312Packages.material-color-utilities] [ "E501" ])
    # (makePythonScript "workspaces.py" [] [ "E501" ])
  ];
}

