{
  description = "Configuration NixOS minimale avec Flakes";

  # Les sources (les dépôts où Nix va chercher les paquets)
  inputs = {
    # On utilise la branche stable 24.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # + On ajoute la source de Home Manager (doit correspondre à la version de nixpkgs)
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    # Le module magique pour gérer Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    wlctl.url = "github:aashish-thapa/wlctl";

    degoog = {
      url = "github:degoog-org/degoog";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium-flake.url = "github:oxcl/nix-flake-helium-browser";
    helium-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Ce que ton Flake va générer en sortie
  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      wlctl,
      helium-flake,
      ...
    }@inputs:
    {

      # La configuration des machines
      nixosConfigurations = {

        # Remplace "laptop" par le nom exact de ta machine (networking.hostName)
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # + On rend les inputs disponibles dans les autres fichiers
          specialArgs = {
            inherit inputs;
            inherit helium-flake;
          };

          # On inclut tes fichiers de configuration actuels
          modules = [
            ./hardware-laptop.nix
            ./configuration.nix
            ./laptop.nix
            # On charge le module ici
            nix-flatpak.nixosModules.nix-flatpak

            # + On active le module Home Manager
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";

              # + On dit à Home Manager de lire la config de ton utilisateur
              # Remplace "kbetuel" par ton vrai nom d'utilisateur système
              home-manager.users.xerad = import ./home.nix;
            }

            (
              {
                pkgs,
                inputs,
                ...
              }:
              {
                nixpkgs.overlays = [
                  inputs.millennium.overlays.default
                  helium-flake.overlays.default
                ];
                environment.systemPackages = [
                  inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
                  pkgs.helium
                ];
              }
            )
          ];
        };

        # 🖥️ Ton PC fixe (Tour)
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit helium-flake;
          };
          modules = [
            ./hardware-desktop.nix # Le hardware scanné sur la tour
            ./configuration.nix # Le MÊME socle commun
            ./desktop.nix # 🔥 Le fichier contenant tes règles uniques au fixe
            # On charge le module ici
            nix-flatpak.nixosModules.nix-flatpak

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.xerad = import ./home.nix;
            }

            (
              {
                pkgs,
                inputs,
                ...
              }:
              {
                nixpkgs.overlays = [
                  inputs.millennium.overlays.default
                  helium-flake.overlays.default
                ];
                environment.systemPackages = [
                  inputs.wlctl.packages.${pkgs.stdenv.hostPlatform.system}.default
                  pkgs.helium
                ];
              }
            )
          ];
        };
      };
    };
}
