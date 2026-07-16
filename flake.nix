
{
  description = "Configuration NixOS minimale avec Flakes";

  # Les sources (les dépôts où Nix va chercher les paquets)
  inputs = {
    # On utilise la branche stable 24.05
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  # Ce que ton Flake va générer en sortie
  outputs = { self, nixpkgs, ... }@inputs: {
    
    # La configuration des machines
    nixosConfigurations = {
      
      # Remplace "laptop" par le nom exact de ta machine (networking.hostName)
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # On inclut tes fichiers de configuration actuels
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
        ];
      };
      
    };
  };
}
