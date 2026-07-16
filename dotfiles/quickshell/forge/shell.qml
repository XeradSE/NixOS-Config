import Quickshell
import QtQuick
import "widgets"
import Quickshell.Services.SystemTray 
import Quickshell.Widgets

PanelWindow {
    id: topBar

    color: "#E61e1e2e"

    anchors {
      top: true
      right: true
      left: true
    }

    margins {
      top: 0
      left: 0
      right: 0
      //bottom: 0 == rien
    }
    
    height: 30

    // =====================================
    // ZONE GAUCHE (Alignement horizontal)
    // =====================================
    Row {
        anchors.left: parent.left
        spacing: 1

        Workspace {}
        Media {}
    }

    // =====================================
    // ZONE CENTRALE
    // =====================================
    Clock {
        anchors.centerIn: parent
    }

    // =====================================
    // ZONE DROITE
    // =====================================
    Applets {
        anchors.right: parent.right
    }
}
