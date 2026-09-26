
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

    #millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
    # Le module magique pour gérer Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    wlctl.url = "github:aashish-thapa/wlctl";
  };

  # Ce que ton Flake va générer en sortie
  outputs = { self, nixpkgs, affinity-nix, nix-flatpak, wlctl, ... }@inputs: {
    
    # La configuration des machines
    nixosConfigurations = {
      
      # Remplace "laptop" par le nom exact de ta machine (networking.hostName)
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

	# + On rend les inputs disponibles dans les autres fichiers
        specialArgs = { inherit inputs; };
        
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

          ({ pkgs, inputs, ... }: {
              nixpkgs.overlays = [ affinity-nix.overlays.default ];
              environment.systemPackages = [ 
                pkgs.affinity-v3
                inputs.wlctl.packages.${pkgs.system}.default
              ];
              packages."x86_64-linux".audio-relay = pkgs.stdenv.mkDerivation rec {
          name = "audio-relay";
          version = "0.26.3";

          ## This can't be a flake input as it has multiple top-level folders
          ## See: https://github.com/NixOS/nix/issues/7083
          src = builtins.fetchurl {
            url = https://dl.audiorelay.net/setups/linux/audiorelay-0.26.3.tar.gz;
            sha256 = "05553s1gp9bimr79nvagdk0l8ahmbwkqg6i6csavvzw40kisj49r";
          };
          sourceRoot = ".";

          desktopItem = pkgs.makeDesktopItem {
            name = "AudioRelay";
            exec = "audio-relay";
            genericName = "AudioRelay audio bridge";
            comment = "AudioRelay sound server/player";
            categories = [ "Network" "Audio" ];
            desktopName = "AudioRelay";
            mimeTypes = [];
            icon = "audiorelay";
          };

          installPhase = ''
            mkdir -p $out/share/icons/hicolor/512x512/apps
            ln -sf AudioRelay bin/audio-relay
            cp -rp bin lib $out/
            cp lib/AudioRelay.png $out/share/icons/hicolor/512x512/apps/audiorelay.png
            cp -r ${desktopItem}/share/applications $out/share
            cp $out/lib/app/AudioRelay.cfg $out/lib/app/.AudioRelay-wrapped.cfg
          '';

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            makeWrapper
          ];

          buildInputs = with pkgs; [
            alsaLib
            file
            fontconfig.lib
            freetype
            libglvnd
            libpulseaudio
            stdenv.cc.cc.lib
            xorg.libX11
            xorg.libXext
            xorg.libXi
            xorg.libXrender
            xorg.libXtst
            xorg.libXrandr
            xorg.libXinerama
            zlib
          ];

          dontAutoPatchelf = true;

          postFixup = ''
            autoPatchelf \
              $out/bin \
              $out/lib/runtime/lib/jexec \
              $out/lib/runtime/lib/jspawnhelper \
              $(find "$out/lib/runtime/lib" -type f -name 'lib*.so' -a -not -name 'libj*.so')
            wrapProgram $out/bin/AudioRelay \
              --prefix LD_LIBRARY_PATH : $out/lib/runtime/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.alsaLib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.fontconfig.lib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.freetype}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.libpulseaudio}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libX11}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXext}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXi}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXrender}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXtst}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.zlib}/lib/
          '';

          meta = with pkgs.lib; {
            description = "An application to stream audio between devices";
            homepage = "https://audiorelay.net";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
            maintainers = with maintainers; [];
          };
        };
        defaultPackage."x86_64-linux" = self.packages."x86_64-linux".audio-relay;
            })
        ];
      };

      # 🖥️ Ton PC fixe (Tour)
  desktop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./hardware-desktop.nix # Le hardware scanné sur la tour
      ./configuration.nix    # Le MÊME socle commun
      ./desktop.nix          # 🔥 Le fichier contenant tes règles uniques au fixe
      # On charge le module ici
      nix-flatpak.nixosModules.nix-flatpak
      
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
	      home-manager.backupFileExtension = "backup";
        home-manager.users.xerad = import ./home.nix;
      }

          ({ pkgs, inputs, ... }: {
              nixpkgs.overlays = [ affinity-nix.overlays.default ];
              environment.systemPackages = [ 
                pkgs.affinity-v3
                inputs.wlctl.packages.${pkgs.system}.default
              ];
              packages."x86_64-linux".audio-relay = pkgs.stdenv.mkDerivation rec {
          name = "audio-relay";
          version = "0.26.3";

          ## This can't be a flake input as it has multiple top-level folders
          ## See: https://github.com/NixOS/nix/issues/7083
          src = builtins.fetchurl {
            url = https://dl.audiorelay.net/setups/linux/audiorelay-0.26.3.tar.gz;
            sha256 = "05553s1gp9bimr79nvagdk0l8ahmbwkqg6i6csavvzw40kisj49r";
          };
          sourceRoot = ".";

          desktopItem = pkgs.makeDesktopItem {
            name = "AudioRelay";
            exec = "audio-relay";
            genericName = "AudioRelay audio bridge";
            comment = "AudioRelay sound server/player";
            categories = [ "Network" "Audio" ];
            desktopName = "AudioRelay";
            mimeTypes = [];
            icon = "audiorelay";
          };

          installPhase = ''
            mkdir -p $out/share/icons/hicolor/512x512/apps
            ln -sf AudioRelay bin/audio-relay
            cp -rp bin lib $out/
            cp lib/AudioRelay.png $out/share/icons/hicolor/512x512/apps/audiorelay.png
            cp -r ${desktopItem}/share/applications $out/share
            cp $out/lib/app/AudioRelay.cfg $out/lib/app/.AudioRelay-wrapped.cfg
          '';

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            makeWrapper
          ];

          buildInputs = with pkgs; [
            alsaLib
            file
            fontconfig.lib
            freetype
            libglvnd
            libpulseaudio
            stdenv.cc.cc.lib
            xorg.libX11
            xorg.libXext
            xorg.libXi
            xorg.libXrender
            xorg.libXtst
            xorg.libXrandr
            xorg.libXinerama
            zlib
          ];

          dontAutoPatchelf = true;

          postFixup = ''
            autoPatchelf \
              $out/bin \
              $out/lib/runtime/lib/jexec \
              $out/lib/runtime/lib/jspawnhelper \
              $(find "$out/lib/runtime/lib" -type f -name 'lib*.so' -a -not -name 'libj*.so')
            wrapProgram $out/bin/AudioRelay \
              --prefix LD_LIBRARY_PATH : $out/lib/runtime/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.alsaLib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.fontconfig.lib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.freetype}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.libpulseaudio}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.stdenv.cc.cc.lib}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libX11}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXext}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXi}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXrender}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libXtst}/lib/ \
              --prefix LD_LIBRARY_PATH : ${pkgs.zlib}/lib/
          '';

          meta = with pkgs.lib; {
            description = "An application to stream audio between devices";
            homepage = "https://audiorelay.net";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
            maintainers = with maintainers; [];
          };
        };
        defaultPackage."x86_64-linux" = self.packages."x86_64-linux".audio-relay;
            })
    ];
  };
    };
  };
}
