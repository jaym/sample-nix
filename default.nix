{pkgs ? import <nixpkgs> {} }:

let
  python = import ./requirements.nix { inherit pkgs; };
in python.mkDerivation {
  name = "sample-1.0";
  version = "1.0";
  src = ./.;
  propagatedBuildInputs = [
    python.packages."Flask"
    python.packages."click"
    python.packages.ipython
  ];

  dontStrip = true;

}

