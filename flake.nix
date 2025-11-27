{
  description = "Demo de actualizaciones remotas con NixOS (CONABIO)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      
    in
    {
      nixosConfigurations.client = nixpkgs.lib.nixosSystem {
        # AQUI va el sistema (fuera de modules)
        inherit system;

        modules = [
          # Tu configuración del sistema
          ({ config, lib, pkgs, ... }: {
            
            # Versión del estado (obligatorio)
            system.stateVersion = "24.05";

          })

          # Importamos configuración de hardware y general
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
