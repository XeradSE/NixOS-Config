
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
  };

  # Ce que ton Flake va générer en sortie
  outputs = { self, nixpkgs, ... }@inputs: {
    
    # La configuration des machines
    nixosConfigurations = {
      
      # Remplace "laptop" par le nom exact de ta machine (networking.hostName)
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

	# + On rend les inputs disponibles dans les autres fichiers
        specialArgs = { inherit inputs; };
        
        # On inclut tes fichiers de configuration actuels
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

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
        ];
      };
      
    };
  };
}
