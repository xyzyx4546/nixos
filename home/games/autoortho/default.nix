{pkgs ? import <nixpkgs> {}, ...}: let
  python = pkgs.python314;
in
  python.pkgs.buildPythonApplication {
    pname = "autoortho";
    version = "2.5.0";
    format = "pyproject";

    src = pkgs.fetchFromGitHub {
      owner = "ProgrammingDinosaur";
      repo = "autoortho4xplane";
      tag = "2.5.0";
      hash = "sha256-qVF3/fjm+a69Fn+TN8HU82Hqy7VB5G/ThjuEDvWUCek=";
    };

    nativeBuildInputs = [
      python.pkgs.poetry-core
    ];

    buildInputs = with pkgs; [
      libjpeg
    ];

    propagatedBuildInputs = with python.pkgs; [
      flask
      flask-socketio
      (geocoder.overrideAttrs {postPatch = "substituteInPlace geocoder/__init__.py --replace-fail '1.38.2' '1.38.1'";})
      packaging
      psutil
      mfusepy
      requests
      pyside6
      numpy
      locust
      zstandard
    ];

    patches = [./autoortho.patch];

    preBuild = ''
      make -C autoortho/aopipeline -f Makefile.linux
    '';

    postInstall = ''
      makeWrapper ${pkgs.lib.getExe python.pkgs.python} $out/bin/autoortho \
        --add-flags "$out/lib/python*/site-packages/autoortho/autoortho.py" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    '';
  }
