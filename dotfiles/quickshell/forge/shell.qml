import Quickshell
import QtQuick
import "widgets"
import Quickshell.Services.SystemTray 
import Quickshell.Widgets
import Qt.labs.folderlistmodel
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: topBar

    color: "transparent"

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

    Rectangle {
      anchors.fill: parent
      color: Qt.rgba(0, 0, 0, 0.65)
    }

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

ShellRoot {
    id: root
    property bool shown: false

    Process { id: proc }

    function setWallpaper(path) {
        proc.command = ["awww", "img", path,
                        "--transition-type", "fade",
                        "--transition-duration", "0.6"]
        proc.running = true
        // sauvegarder le choix pour le restaurer au boot
        Quickshell.execDetached(["sh", "-c", `echo '${path}' > ~/.cache/current_wall`])
    }

    // Appelable depuis le terminal / Hyprland : qs -c wallpaper ipc call wallpaper toggle
    IpcHandler {
        target: "wallpaper"
        function toggle(): void { root.shown = !root.shown }
    }

    PanelWindow {
        visible: root.shown
        anchors.bottom: true
        implicitWidth: 1000
        implicitHeight: 190
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        Rectangle {
            anchors.fill: parent
            radius: 16
            color: "#cc1e1e2e"

            ListView {
                anchors.fill: parent
                anchors.margins: 12
                orientation: ListView.Horizontal
                spacing: 12
                clip: true

                model: FolderListModel {
                    folder: "file://" + Quickshell.env("HOME") + "/Pictures/wallpapers"
                    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
                    showDirs: false
                }

                delegate: Item {
                    required property string filePath
                    required property url fileUrl

                    width: 240
                    height: 166

                    Image {
                        anchors.fill: parent
                        source: parent.fileUrl
                        sourceSize: Qt.size(480, 270)   // downscale à la lecture
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.setWallpaper(parent.filePath)
                    }
                }
            }
        }
    }
}
