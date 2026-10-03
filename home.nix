{ config, pkgs, ... }:

{
  # Remplace par ton nom d'utilisateur et ton dossier personnel
  home = {
    username = "xerad";
    homeDirectory = "/home/xerad";
    file = {
      # Exemple pour Neovim :
      ".config/nvim" = {
        source = ./dotfiles/nvim;
        recursive = true;
      };

      # Exemple pour Hyprland :
      ".config/hypr".source = ./dotfiles/hypr;

      ".config/kitty".source = ./dotfiles/kitty;
      ".config/mako".source = ./dotfiles/mako;
      ".config/wofi".source = ./dotfiles/wofi;
      ".config/quickshell".source = ./dotfiles/quickshell;
      ".config/btop".source = ./dotfiles/btop;
      ".config/yazi".source = ./dotfiles/yazi;
      ".config/nixpkgs".source = ./dotfiles/nixpkgs;
      "Pictures/Wallpapers" = {
        source = ./dotfiles/wallpapers;
        recursive = true; # Le dossier n'est plus en lecteur seul, peut être utilisé pour des tests de fonds d'écrans ou autres
      };
    };
    packages = with pkgs; [
      # htop
      # ripgrep
      xdg-utils
    ];
    stateVersion = "26.05";
    pointerCursor = {
      name = "Vimix-cursors"; # Le nom du dossier généré par le thème
      package = pkgs.vimix-cursors;
      size = 24;

      # Home Manager va automatiquement exporter XCURSOR_THEME et XCURSOR_SIZE
      gtk.enable = true;
      x11.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "Kylian Betuel";
    settings.user.email = "betuelkylian17@gmail.com";

    settings = {
      credential."https://github.com" = {
        helper = "!gh auth git-credential";
      };
    };
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      imagemagick
      ghostscript
      markdownlint-cli2 # Linter
      clang-tools
      luajit
      cmake-language-server
      nixd # LSP
      nixfmt # Formatteur -> Youpi !
      statix # linter -> Un analyseur de code spécifique au langage Nix. Son rôle est de lire tes fichiers .nix et de te signaler si tu utilises des "anti-patterns" (des mauvaises pratiques) pour te suggérer une syntaxe plus propre et plus moderne.
      vscode-langservers-extracted # Un gros paquet générique fourni par Microsoft qui inclut le LSP pour JSON, mais aussi HTML, CSS et ESLint
      marksman # LSP
      pyright # LSP
      ruff # Formatteur python
      vtsls # LSP Type/JavaScript
    ];
    extraLuaPackages =
      luaPkgs: with luaPkgs; [
        magick
      ];
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;

      # Définir les applications par défaut
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
  };
}
