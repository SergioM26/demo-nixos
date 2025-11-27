{
  description = "Demo de actualizaciones remotas con NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    app = pkgs.callPackage ./app { };
  in {
    nixosConfigurations.client = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        {
          system.stateVersion = "24.05";

          environment.systemPackages = [ app ];

          services.demo-app = {
            enable = true;
            package = app;
          };

          systemd.services.demo-app = {
            wantedBy = [ "multi-user.target" ];
            script = ''
              ${app}/bin/demo-app
            '';
            serviceConfig = {
              Restart = "always";
            };
          };
        }
      ];
    };
  };
}
