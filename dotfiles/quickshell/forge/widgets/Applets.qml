import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
      height: texte_wifi.implicitHeight + 10
      width: texte_wifi.implicitWidth + texte_sound.implicitWidth + texte_battery.implicitWidth + 70

      color: "transparent"// your actual color
      
      // ==========================================
      // DROITE : Icônes Système (Wifi, Son, Batterie)
      // ==========================================
            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                spacing: 20 // L'espacement automatique entre chaque icône
                
                // Réseau
                Text {
                  id: texte_wifi
                    text: "  ..." 
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                }
    
                Process {
                  id: wifiProc
                  // Commande pour récupérer le nom du réseau WiFi actif sous KDE
                  command: ["sh", "-c", "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo 'Déconnecté'"]
                  stdout: StdioCollector {
                    onStreamFinished: {
                      let out = this.text.trim()
                      texte_wifi.text = out === "Déconnecté" ? "⚠  Déconnecté" : "  " + out
                    }
                  }
                }
    
                Timer {
                  interval: 1000 // Vérifie toutes les 5 secondes
                  running: true
                  repeat: true
                  onTriggered: wifiProc.running = true
                }

                // Volume
                Text {
                  id: texte_sound
                    text: "  ...%" 
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                  }

                Process {
                  id: volProc
                  // wpctl est l'outil natif de PipeWire. On multiplie par 100 pour avoir un pourcentage propre.
                  command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"]
                  stdout: StdioCollector {
                    onStreamFinished: {
                      let out = this.text.trim()
                      texte_sound.text = "  " + out + "%"
                    }
                  }
                }

                Timer {
                  interval: 100 // Vérifie très souvent (demi-seconde) pour que le son soit réactif
                  running: true
                  repeat: true
                  onTriggered: volProc.running = true
                }

                // Luminosité
                Text {
                  id: texte_brightness
                    text: "󰃠 ...%" 
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                  }

                Process {
                  id: brightProc
                  command: ["sh", "-c", "/home/xerad/.config/quickshell/forge/scripts/get_brightness.sh"]
                  stdout: StdioCollector {
                    onStreamFinished: {
                      let out = this.text.trim()
                      texte_brightness.text = "󰃠 " + out + "%"
                    }
                  }
                }

                Timer {
                  interval: 100 // Vérifie très souvent (demi-seconde) pour que le son soit réactif
                  running: true
                  repeat: true
                  onTriggered: brightProc.running = true
                }
                
                // Batterie
                Text {
                  id: texte_battery
                    text: "  90%" 
                    color: "#ffffff"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                }
            }
              
Process {
        id: batProc
        // On lit directement le fichier système contenant le pourcentage de batterie
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || cat /sys/class/power_supply/BAT1/capacity"]
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim()
                texte_battery.text = "  " + out + "%"
            }
        }
    }

    Timer {
        interval: 10000 // Inutile de stresser le système, toutes les 10 secondes suffisent
        running: true
        repeat: true
        onTriggered: batProc.running = true
    }
    
    // ==========================================
    // DÉCLENCHEMENT INITIAL
    // ==========================================
    // Cette fonction native s'exécute une seule fois au chargement du module
    Component.onCompleted: {
        wifiProc.running = true
        volProc.running = true
        brightProc.running = true
        batProc.running = true
    }
}
