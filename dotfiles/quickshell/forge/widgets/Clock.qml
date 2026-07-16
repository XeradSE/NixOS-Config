import Quickshell
import QtQuick

Rectangle {
      height: text_date.implicitHeight + 10
      width: text_date.implicitWidth + 20

      color: "transparent"// your actual color

      SystemClock {
        id: clock
        precision: SystemClock.Seconds
      }
      
      Text {
        id: text_date
        text: Qt.formatDateTime(clock.date, "hh:mm:ss - (dddd) dd-MM-yyyy")
        anchors.centerIn: parent
        color: "#ffffff"
        font.pixelSize: 14
        font.family: "JetBrainsMono Nerd Font"
      }
    }
