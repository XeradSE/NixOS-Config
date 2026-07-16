{ config, pkgs, ... }:

{
  # Connecte l'utilisateur xerad automatiquement sur le TTY1
  services.getty.autologinUser = "xerad";
}
