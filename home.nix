{ config, pkgs, ... }:

{
  # Remplace par ton nom d'utilisateur et ton dossier personnel
  home.username = "xerad";
  home.homeDirectory = "/home/xerad";

  # C'est ici la magie ! On lie tes dossiers locaux vers ~/.config
  home.file = {
    # Exemple pour Neovim :
    ".config/nvim".source = ./dotfiles/nvim;
    
    # Exemple pour Hyprland :
    ".config/hypr".source = ./dotfiles/hypr;

    ".config/kitty".source = ./dotfiles/kitty;
    ".config/mako".source = ./dotfiles/mako;
    ".config/wofi".source = ./dotfiles/wofi;
    ".config/quickshell".source = ./dotfiles/quickshell;
    ".config/btop".source = ./dotfiles/btop;
  };

  # Tu pourras aussi installer des paquets spécifiques à ton utilisateur ici plus tard
  home.packages = with pkgs; [
    # htop
    # ripgrep
  ];

  # Ne change pas cette version, elle indique avec quelle version de HM tu as commencé
  home.stateVersion = "26.05"; 
  programs.home-manager.enable = true;

# 1. Le cœur de Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # On active les plugins classiques d'un simple clic
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
  shellAliases = {
      ll = "ls -lA";
      # $(hostname) récupère automatiquement le nom de la machine en cours
      update = "sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname)";
      cd = "z"; 
    };

    # On garde juste l'auto-démarrage pour ton fixe
    loginExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };

    programs.zsh.ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };

  # 2. Les outils qui s'intègrent tout seuls à Zsh
  # Plus besoin de rajouter des 'eval "$(zoxide init zsh)"' !
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  
  # 3. Un prompt moderne et ultra rapide (au lieu de bricoler ton propre thème)
  programs.starship = {
    enable = true;
    # enableZshIntegration = true; (activé par défaut)
  };

  gtk = {
    enable = true;
    
    theme = {
      # Le nom exact tel qu'il apparaît dans le système
      name = "Breeze"; 
      # Le paquet NixOS correspondant
      package = pkgs.kdePackages.breeze-gtk; 
    };

    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
  };

  # 2. Configuration du Curseur (Souris)
  home.pointerCursor = {
    name = "Vimix-cursors"; # Le nom du dossier généré par le thème
    package = pkgs.vimix-cursors;
    size = 24;
    
    # Home Manager va automatiquement exporter XCURSOR_THEME et XCURSOR_SIZE
    gtk.enable = true;
    x11.enable = true; 
  };

}
