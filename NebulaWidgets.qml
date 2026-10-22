pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.services
import deeadly137.nebulawidgets

// Nebula-style desktop widgets. The bottom-layer host supplies the widget canvas; the menu and
// corner are separate overlay windows created once for this screen.
Item {
    id: root

    readonly property string screenName: Config.screen
    readonly property var screen: Quickshell.screens.find(candidate => candidate.name === root.screenName) ?? null
    readonly property alias inputMask: canvas.inputMask

    WidgetsWindow {
        id: canvas

        anchors.fill: parent
        screenName: root.screenName
    }

    WidgetMenu {
        screen: root.screen
    }

    WidgetsCorner {
        screen: root.screen
    }
}
