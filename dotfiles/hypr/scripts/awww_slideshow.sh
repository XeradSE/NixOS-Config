#!/bin/bash

# --- PARAMÈTRES ---
DOSSIER="$HOME/Pictures/Wallpapers/" # Remplace par ton vrai dossier
TEMPS="5m"                           # Temps d'attente (5m = 5 minutes, 30s = 30 secondes)

# Vérifie que le dossier existe
if [ ! -d "$DOSSIER" ]; then
  echo "Erreur : Le dossier $DOSSIER n'existe pas."
  exit 1
fi

# Lance le démon awww en fond s'il n'est pas déjà actif
if ! awww query >/dev/null 2>&1; then
  awww-daemon &
  disown
  sleep 1 # Laisse 1 seconde au moteur pour s'allumer
fi

# --- BOUCLE DU DIAPORAMA ---
while true; do
  # Sélectionne une image au hasard (shuf -n 1)
  # Si tu veux un ordre alphabétique plutôt qu'aléatoire, remplace "shuf -n 1" par "sort | head -n 1" (mais il faudra adapter pour cycler)
  FICHIER=$(find "$DOSSIER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n 1)

  if [ -n "$FICHIER" ]; then
    # Envoie l'image à awww avec une transition fluide
    awww img "$FICHIER" --transition-type wipe --transition-angle 30 --transition-fps 60 >/dev/null 2>&1
  fi

  # Met le script en pause avant la prochaine image
  sleep "$TEMPS"
done
