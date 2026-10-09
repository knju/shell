pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.components
import qs.services

Item {
    id: root

    required property ScreenState screenState

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    readonly property string stateDir:
        Quickshell.env("XDG_RUNTIME_DIR") + "/htb-watch"

    // Width shared by both pills: widest octet across both IPs, plus padding.
    readonly property int pillWidth:
        Math.max(localText.implicitWidth, targetText.implicitWidth) + 12

    function fmt(text) {
        const t = text.trim();
        return t ? t.split(".").join("\n") : "—";
    }

    FileView {
        id: localFile
        path: root.stateDir + "/local"
        watchChanges: true
        onFileChanged: reload()
    }

    FileView {
        id: targetFile
        path: root.stateDir + "/target"
        watchChanges: true
        onFileChanged: reload()
    }

    ColumnLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4

        // Green — your IP
        Rectangle {
            visible: localFile.text().trim() !== ""
            implicitWidth: root.pillWidth
            implicitHeight: localText.implicitHeight + 10
            radius: 6
            color: "#a3be8c"

            Text {
                id: localText
                anchors.centerIn: parent
                text: root.fmt(localFile.text())
                color: "#1e1e2e"
                font.bold: true
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 0.9
            }
        }

        // Red — target IP
        Rectangle {
            visible: targetFile.text().trim() !== ""
            implicitWidth: root.pillWidth
            implicitHeight: targetText.implicitHeight + 10
            radius: 6
            color: "#bf616a"

            Text {
                id: targetText
                anchors.centerIn: parent
                text: root.fmt(targetFile.text())
                color: "#1e1e2e"
                font.bold: true
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 0.9
            }
        }
    }
}
