import QtQuick
import Quickshell
import Quickshell.Hyprland

Rectangle {
  height: workspaceText.implicitHeight + 10
  width: workspaceText.implicitWidth + 15

  color: "transparent"

  Text {
    id: workspaceText
    text: " Bureau " + (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : "1")
    anchors.centerIn: parent
    color: "#ffffff"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 14
  }
}
