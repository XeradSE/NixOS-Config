# 🛠️ Antisèche NixOS & Flatpak

## ❄️ Commandes Flakes (Architecture)

**Mettre à jour / Appliquer la configuration système :**
\`\`\`bash
# À lancer depuis le dossier contenant flake.nix
sudo nixos-rebuild switch --flake .#laptop
\`\`\`

**Nettoyer les anciennes générations (Ramasse-miettes) :**
\`\`\`bash
# Supprimer les builds de plus de 7 jours (Recommandé)
sudo nix-collect-garbage --delete-older-than 7d

# Tout supprimer sauf la génération actuelle (Nettoyage radical)
sudo nix-collect-garbage -d

# Nettoyer le menu de démarrage (Bootloader) dans la foulée
sudo /run/current-system/bin/switch-to-configuration boot
\`\`\`

---

## 📦 Commandes Flatpak (Applications Impératives)

**Initialiser le catalogue officiel (À ne faire qu'une fois par machine) :**
\`\`\`bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
\`\`\`

**Chercher un logiciel :**
\`\`\`bash
flatpak search <nom_du_logiciel>
\`\`\`

**Installer un logiciel :**
\`\`\`bash
flatpak install flathub <Application_ID>
# Exemple : flatpak install flathub org.jdownloader.JDownloader
\`\`\`

**Mettre à jour tous les Flatpaks :**
\`\`\`bash
flatpak update
\`\`\`

**Lancer un logiciel depuis le terminal :**
\`\`\`bash
flatpak run <Application_ID>
\`\`\`

---

JDownloader2 -> Flatpak
Nmtui-go -> executable
Affinity -> appImage
Flatseal -> Flatpak (bon pour gérer les perms des autres flatpak je crois)
Antigravity -> Nix Packages -> voir pour enable le cli et disable the gui, c'est possible
