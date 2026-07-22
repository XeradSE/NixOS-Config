# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # ./hardware-configuration.nix -- done by flake
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  #i18n.defaultLocale = "fr_FR.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "fr";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  console.keyMap = "fr";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  
  

  # Configure keymap in X11
  services.xserver.xkb.layout = "fr";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.xerad = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       tree
     ];
     shell = pkgs.zsh;
    };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;

# ==========================================
  # 1. SERVICES ET MODULES (Remplace les paquets isolés)
  # ==========================================

  # Environnement de bureau et Portails
  programs.hyprland.enable = true;
  
  # Gaming (Steam installe automatiquement les lib32, Proton, et Gamescope)
  #nixpkgs.overlays = [ inputs.millennium.overlays.default ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    #package = pkgs.millennium-steam;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Shells
  programs.zsh.enable = true;
  programs.fish.enable = true; # Si tu utilises fish en alternative

  # Virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "xerad" ];

  # Réseau et Connectivité
  services.tailscale.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # Interface graphique pour le Bluetooth

  # Impression
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip brlaser ]; # brlaser couvre les modèles Brother HL
  };

  # Audio (Pipewire remplace PulseAudio et ALSA)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Divers
  services.flatpak.enable = true;
  services.gvfs.enable = true; # Pour la corbeille et le montage USB
  # no longer needed - programs.adb.enable = true;  # Remplace android-udev


  # ==========================================
  # 2. POLICES D'ÉCRITURE
  # ==========================================
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
  ];


  # ==========================================
  # 3. PAQUETS SYSTÈME GLOBAUX
  # ==========================================
  environment.systemPackages = with pkgs; [
    # ----------------------------------------
    # Terminal & Utilitaires CLI
    wget fd fzf ripgrep jq zoxide btop fastfetch
    p7zip unrar eza # eza remplace avantageusement ls
    wl-clipboard xdotool ydotool yad kitty yazi nano
    bluetuith
    playerctl
    rclone

    # ----------------------------------------
    # Environnement Hyprland (Modules)
    mako           # Notifications
    wofi           # Lanceur d'applications
    grim slurp swappy # Capture d'écran (remplace xorg-tools)
    brightnessctl  # Luminosité
    quickshell
    oh-my-zsh
    pwvucontrol

    # ----------------------------------------
    # Développement & Outils
    neovim
    vscodium
    beekeeper-studio
    git
    gh             # github-cli
    android-studio.unwrapped
    python313

    # ----------------------------------------
    # Gaming (Steam)
    # En gros ce sont les dependancies pour steamtinkerlaunch d'après ProtonPlus
    # Il existe un paquet mais je ne sais pas le faire fonctionner avec steam seul
    unzip
    xprop
    xrandr
    xxd
    xwininfo

    # ----------------------------------------
    # Gaming (Hors Steam)
    lutris
    heroic
    prismlauncher # minecraft
    wineWow64Packages.staging # Wine avec support 32/64 bits
    winetricks
    protonplus

    # ----------------------------------------
    # Bureautique & Utilitaires GUI
    vivaldi
    kdePackages.okular
    kdePackages.gwenview
    gnome-disk-utility
    localsend
    qbittorrent
    # not in the nixos packets, but in flatpak - jdownloader
    papirus-icon-theme
    megabasterd
    davinci-resolve
    obs-studio
    
    # ----------------------------------------
    # Multimédia
    vlc
    imagemagick
    cava
  ];

  hardware.graphics = {
  	enable = true;
    enable32Bit = true;
	extraPackages = with pkgs; [
		intel-media-driver	
	];
  };

  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
    TERMINAL = "kitty";
  };

systemd.user.services.awww-slideshow = {
  description = "Awww Wallpaper Daemon and Slideshow";
  
  # Le service démarre en même temps que l'environnement graphique
  partOf = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  wantedBy = [ "graphical-session.target" ];

  # Déclare explicitement les paquets dont le script a besoin pour fonctionner
  path = with pkgs; [ 
    awww 
    coreutils # Pour shuf et sleep
    findutils # Pour find
  ];

  # Ton script bash parfaitement intégré
  script = ''
    #!/usr/bin/env bash

    DOSSIER="$HOME/Pictures/Wallpapers/"
    TEMPS="5m"

    if [ ! -d "$DOSSIER" ]; then
      echo "Erreur : Le dossier $DOSSIER n'existe pas."
      exit 1
    fi

    # Lance le démon awww en fond
    awww-daemon &
    
    # Attend que le démon soit prêt
    while ! awww query >/dev/null 2>&1; do
      sleep 0.1
    done

    # Boucle du diaporama
    while true; do
      FICHIER=$(find "$DOSSIER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

      if [ -n "$FICHIER" ]; then
        awww img "$FICHIER" --transition-type wipe --transition-angle 30 --transition-fps 60 >/dev/null 2>&1
      fi

      sleep "$TEMPS"
    done
  '';

  serviceConfig = {
    Type = "simple";
    # Relance automatiquement le script en cas de crash
    Restart = "on-failure";
    RestartSec = "5s";
  };
};

  # Activation du chargeur dynamique pour les binaires non-Nix
  # Pour utiliser Android Studio correctement (l'émulation)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    nss
    nspr
    # Bibliothèques graphiques et audio souvent requises par l'émulateur Android
    alsa-lib
    libGL
    vulkan-loader
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXrender
    libXtst
  ];
}

