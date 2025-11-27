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
        # Aquí empieza tu módulo
        ({ config, lib, pkgs, ... }: {
          
          system.stateVersion = "24.05";

          # 1. PARTE DE DEFINICIÓN (El "Formulario")
          # Aquí le dices a NixOS: "Existe una opción llamada services.demo-app"
          options.services.demo-app = {
            enable = lib.mkEnableOption "el servicio demo de CONABIO";
            
            package = lib.mkOption {
              type = lib.types.package;
              default = app;
              description = "El paquete que se va a ejecutar";
            };
          };

          # 2. PARTE DE CONFIGURACIÓN (Rellenar el formulario)
          # Aquí activamos lo que acabamos de definir arriba
          config = {
            # Activamos nuestro propio servicio
            services.demo-app = {
              enable = true;
              package = app;
            };

            # Instalamos el paquete en el sistema (opcional, para verlo en consola)
            environment.systemPackages = [ app ];

            # 3. PARTE DE IMPLEMENTACIÓN (Los cables por detrás)
            # Esto solo se crea SI services.demo-app.enable es true
            systemd.services.demo-app = lib.mkIf config.services.demo-app.enable {
              description = "Servicio Demo CONABIO";
              wantedBy = [ "multi-user.target" ];
              
              script = ''
                ${config.services.demo-app.package}/bin/demo-app
              '';
              
              serviceConfig = {
                Restart = "always";
              };
            };
          };
        })
      ];
    }; 
  };
}
