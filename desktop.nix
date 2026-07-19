{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # Connecte l'utilisateur xerad automatiquement sur le TTY1
  services.getty.autologinUser = "xerad";

  networking.hostName = "desktop";

  # On ajoute de la configuration Home Manager exclusive à cette machine
  home-manager.users.xerad = {
    programs.zsh.shellAliases = {
      poweroff = "echo '⚠️  ATTENTION : Tu vas ÉTEINDRE le serveur. Es-tu sûr ? (y/N)' && read -r ans && [ \"\$ans\" = 'y' ] && sudo systemctl poweroff";
      shutdown = "echo '⚠️  ATTENTION : Tu vas ÉTEINDRE le serveur. Es-tu sûr ? (y/N)' && read -r ans && [ \"\$ans\" = 'y' ] && sudo systemctl poweroff";
    };
  };

  # Désactive le Wi-Fi powersave (crée le fichier conf.d avec la valeur 2)
  networking.networkmanager.wifi.powersave = false;

  # Sécurités anti-sommeil pour le streaming Sunshine (équivalent à systemctl mask)
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
