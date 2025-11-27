{ pkgs }:
pkgs.python3Packages.buildPythonApplication {
  pname = "demo-app";
  version = builtins.readFile ./version.txt;
  src = ./.;
  propagatedBuildInputs = [];
  doCheck = false;
}
