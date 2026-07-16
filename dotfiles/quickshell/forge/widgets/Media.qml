import QtQuick
import Quickshell
import Quickshell.Io

// La boîte invisible qui contient tout
Rectangle {
    height: mediaRow.implicitHeight + 10
    width: mediaRow.implicitWidth + 15

    color: "transparent"

    // La ligne qui range l'icône et le texte côte à côte
    Row {
      id: mediaRow
      spacing: 10
      anchors.centerIn: parent
        
        Text {
            id: iconText
            text: " " 
            color: "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }

        Text {
            id: songText
            text: "Aucun média"
            color: "#ffffff"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
        }
    }

    // ------------------------------------------
    // LOGIQUE INVISIBLE (Process & Timers)
    // ------------------------------------------
    Process {
        id: mediaProc
        command: ["sh", "-c", "playerctl metadata --format '{{ title }} - {{ artist }}' 2>/dev/null || echo 'Aucun média'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let out = this.text.trim()
                if (out.length > 83) {
                    out = out.substring(0, 80) + "..."
                }
                songText.text = out
            }
        }
    }

    Process {
        id: statusProc
        command: ["sh", "-c", "playerctl status 2>/dev/null || echo 'Stopped'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let status = this.text.trim()
                if (status === "Playing") {
                    iconText.text = "" 
                    iconText.color = "#ffffff"
                } else if (status === "Paused") {
                    iconText.text = "" 
                    iconText.color = "#ffffff" 
                } else {
                    iconText.text = " " 
                    iconText.color = "#ffffff" 
                }
            }
        }
    }

    // ------------------------------------------
    // TIMERS ET ACTIONS
    // ------------------------------------------
    
    // Le timer classique (vérifie toutes les 2 secondes)
    Timer {
        interval: 2000 
        running: true
        repeat: true
        onTriggered: {
            mediaProc.running = true
            statusProc.running = true
        }
    }

    // Le timer de confirmation (se lance 200ms après un clic)
    Timer {
        id: delayTimer
        interval: 200 
        running: false
        repeat: false
        onTriggered: {
            mediaProc.running = true
            statusProc.running = true
        }
    }

    Process {
        id: playPauseProc
        command: ["playerctl", "play-pause"]
    }

    // ------------------------------------------
    // ACTION : Clic Optimiste
    // ------------------------------------------
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // 1. On envoie l'ordre au lecteur média
            playPauseProc.running = true
            
            // 2. MISE À JOUR OPTIMISTE : On change l'icône instantanément 
            // pour effacer toute sensation de lag
            if (iconText.text === "") { // Si c'était en lecture...
                iconText.text = ""      // ...on affiche Pause immédiatement
                iconText.color = "#ffffff"
            } else {
                iconText.text = ""
                iconText.color = "#ffffff"
            }

            // 3. On lance la vraie vérification 200ms plus tard
            delayTimer.start()
        }
    }

    Component.onCompleted: {
        mediaProc.running = true
        statusProc.running = true
    }
}
