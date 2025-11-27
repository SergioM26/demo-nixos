{
  description = "Demo de actualizaciones remotas con NixOS (CONABIO)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }:
    let
      # 1. Definimos variables globales
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      
      # Importamos tu aplicación python
      app = pkgs.callPackage ./app { };
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

            # --- DEFINICIÓN DEL SERVICIO (OPTIONS) ---
            options.services.demo-app = {
              enable = lib.mkEnableOption "el servicio demo de CONABIO";
              package = lib.mkOption {
                type = lib.types.package;
                default = app;
                description = "El paquete que se va a ejecutar";
              };
            };

            # --- CONFIGURACIÓN DEL SERVICIO (CONFIG) ---
            config = lib.mkIf config.services.demo-app.enable {
              # Instalamos el paquete para poder verlo en consola
              environment.systemPackages = [ config.services.demo-app.package ];

              # Creamos el servicio de systemd
              systemd.services.demo-app = {
                description = "Servicio Demo CONABIO";
                wantedBy = [ "multi-user.target" ];
                serviceConfig = {
                  # Ejecuta el binario dentro del paquete
                  ExecStart = "${config.services.demo-app.package}/bin/demo-app";
                  Restart = "always";
                };
              };
            };
          })

          # Módulo extra para activarlo
          ({ ... }: {
            services.demo-app.enable = true;
          })
          
          # Importamos configuración de hardware y general
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
    };
}
