pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import M3Shapes
import Caelestia.Config
import Caelestia.Plugins
import qs.services

// A desktop-widget clock inspired by Nebula's shape-based widgets. The loader gives this item
// the size of the whole screen, so the clock itself is a smaller draggable child.
Item {
    id: root

    required property SettingsObject settings

    readonly property int widgetSize: Math.max(100, Math.min(600, Number(settings.size)))
    readonly property var colors: palette(settings.colour)
    readonly property real restX: settings.x >= 0 ? Math.max(0, Math.min(settings.x, width - widgetSize)) : (width - widgetSize) / 2
    readonly property real restY: settings.y >= 0 ? Math.max(0, Math.min(settings.y, height - widgetSize)) : (height - widgetSize) / 2

    function palette(role: string): var {
        switch (role) {
        case "secondary":
            return { fill: Colours.tPalette.m3secondaryContainer, text: Colours.tPalette.m3onSecondaryContainer };
        case "tertiary":
            return { fill: Colours.tPalette.m3tertiaryContainer, text: Colours.tPalette.m3onTertiaryContainer };
        case "surface":
            return { fill: Colours.tPalette.m3surfaceContainerHigh, text: Colours.tPalette.m3onSurface };
        default:
            return { fill: Colours.tPalette.m3primaryContainer, text: Colours.tPalette.m3onPrimaryContainer };
        }
    }

    Item {
        id: clock

        width: root.widgetSize
        height: width
        x: root.restX + (drag.active ? drag.translation.x : 0)
        y: root.restY + (drag.active ? drag.translation.y : 0)
        opacity: Math.max(0.2, Math.min(1, settings.opacity))

        Behavior on width {
            NumberAnimation {
                duration: Tokens.anim.durations.expressiveSlowSpatial
                easing: Tokens.anim.expressiveDefaultSpatial
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Tokens.anim.durations.normal
            }
        }

        DragHandler {
            id: drag

            target: null
            enabled: root.settings.draggable
            cursorShape: Qt.ClosedHandCursor

            onActiveChanged: {
                if (active)
                    return;
                const nx = root.restX + drag.translation.x;
                const ny = root.restY + drag.translation.y;
                root.settings.x = Math.round(Math.max(0, Math.min(root.width - clock.width, nx)));
                root.settings.y = Math.round(Math.max(0, Math.min(root.height - clock.height, ny)));
            }
        }

        HoverHandler {
            cursorShape: root.settings.draggable ? Qt.OpenHandCursor : Qt.ArrowCursor
        }

        readonly property date now: systemClock.date
        readonly property real ticks: Math.floor((now.getTime() - now.getTimezoneOffset() * 60000) / 1000)
        readonly property real minuteTicks: Math.floor(ticks / 60)
        readonly property int tickCount: settings.tickStyle === "all" ? 60 : settings.tickStyle === "hours" ? 12 : 0
        readonly property bool showTicks: tickCount > 0

        property real shownSecond: ticks * 6
        property real shownMinute: minuteTicks * 6
        property real shownHour: minuteTicks * 0.5

        Behavior on shownSecond {
            enabled: root.settings.showSeconds

            NumberAnimation {
                duration: Tokens.anim.durations.normal
                easing: Tokens.anim.standard
            }
        }

        Behavior on shownMinute {
            NumberAnimation {
                duration: Tokens.anim.durations.expressiveSlowSpatial
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }

        Behavior on shownHour {
            NumberAnimation {
                duration: Tokens.anim.durations.expressiveSlowSpatial
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }

        readonly property real secondAngle: shownSecond % 360
        readonly property real minuteAngle: shownMinute % 360
        readonly property real hourAngle: shownHour % 360

        property int version: 0
        property bool ready: false
        property real innerTarget: 0.4
        property real innerRatio: innerTarget
        readonly property real inner: innerRatio * width
        readonly property real handWidth: Math.max(3, width * 0.045)
        readonly property real dotSize: Math.max(6, width * 0.06)
        readonly property real numberSize: Math.max(8, width * 0.075)
        readonly property real tickInset: showTicks ? width * 0.075 : 0

        Behavior on innerRatio {
            enabled: clock.ready

            NumberAnimation {
                duration: Tokens.anim.durations.expressiveSlowSpatial
                easing: Tokens.anim.emphasizedDecel
            }
        }

        function remeasure(): void {
            if (ref.width <= 0)
                return;
            let least = ref.width / 2;
            for (let a = 0; a < 360; a += 4)
                least = Math.min(least, ref.distanceAtAngle(a));
            innerTarget = Math.max(0.2, least / ref.width);
            version++;
            ready = true;
        }

        function edgeRatio(angle: real): real {
            if (ref.width <= 0)
                return 0.4;
            return Math.min(ref.distanceAtAngle(angle) / ref.width, innerTarget * 1.25);
        }

        SystemClock {
            id: systemClock

            enabled: root.visible
            precision: root.settings.showSeconds ? SystemClock.Seconds : SystemClock.Minutes
        }

        MaterialShape {
            id: face

            anchors.fill: parent
            shape: MaterialShape[root.settings.shape] ?? MaterialShape.Cookie12Sided
            color: root.colors.fill
            animationDuration: Tokens.anim.durations.expressiveSlowSpatial
            animationEasing: Tokens.anim.expressiveDefaultSpatial
        }

        MaterialShape {
            id: ref

            width: 200
            height: 200
            visible: false
            shape: face.shape
            animationDuration: 0

            onShapeChanged: Qt.callLater(clock.remeasure)
            Component.onCompleted: Qt.callLater(clock.remeasure)
        }

        Repeater {
            model: clock.tickCount

            Rectangle {
                required property int index

                readonly property real angle: index * (root.settings.tickStyle === "all" ? 6 : 30)
                readonly property bool major: root.settings.tickStyle === "hours" || index % 5 === 0
                readonly property real ratio: clock.edgeRatio(angle)
                readonly property real length: clock.width * (major ? 0.07 : 0.035)
                readonly property real reach: ratio * clock.width - clock.width * 0.03 - length / 2

                x: clock.width / 2 + reach * Math.sin(angle * Math.PI / 180) - width / 2
                y: clock.height / 2 - reach * Math.cos(angle * Math.PI / 180) - height / 2
                width: Math.max(major ? 2.5 : 1.5, clock.width * (major ? 0.014 : 0.008))
                height: length
                radius: width / 2
                rotation: angle
                antialiasing: true
                color: Qt.alpha(root.colors.text, major ? 0.9 : 0.4)
            }
        }

        Repeater {
            model: root.settings.showNumbers ? 12 : 0

            Text {
                required property int index

                readonly property real angle: (index + 1) * 30
                readonly property real ratio: clock.edgeRatio(angle)
                readonly property real distance: ratio * clock.width - clock.numberSize * 1.1 - clock.tickInset

                x: clock.width / 2 + distance * Math.sin(angle * Math.PI / 180) - width / 2
                y: clock.height / 2 - distance * Math.cos(angle * Math.PI / 180) - height / 2
                text: index + 1
                font.family: Tokens.font.body.small.family
                font.pixelSize: clock.numberSize
                font.weight: Font.DemiBold
                color: Qt.alpha(root.colors.text, 0.7)
            }
        }

        Text {
            id: dateText

            readonly property real sideRatio: clock.edgeRatio(180)
            readonly property real room: sideRatio * clock.width - clock.tickInset - (root.settings.showNumbers ? clock.numberSize * 2.2 : clock.width * 0.05)
            readonly property real reach: Math.max(0, Math.min(clock.inner * 0.5, room - height / 2))

            z: 2
            visible: root.settings.showDate
            x: (clock.width - width) / 2
            y: (clock.height - height) / 2 + reach
            text: Qt.formatDate(clock.now, "ddd d")
            font.family: Tokens.font.body.small.family
            font.pixelSize: clock.numberSize
            font.weight: Font.DemiBold
            color: root.colors.text
        }

        Rectangle {
            id: hourHand

            readonly property real length: clock.inner * 0.55

            x: clock.width / 2 - width / 2
            y: clock.height / 2 - length
            width: clock.handWidth
            height: length + width / 2
            radius: width / 2
            color: root.colors.text
            antialiasing: true

            transform: Rotation {
                origin.x: hourHand.width / 2
                origin.y: hourHand.length
                angle: clock.hourAngle
            }
        }

        Rectangle {
            id: minuteHand

            readonly property real length: clock.inner * 0.82

            x: clock.width / 2 - width / 2
            y: clock.height / 2 - length
            width: Math.max(2, clock.handWidth * 0.8)
            height: length + width / 2
            radius: width / 2
            color: Qt.alpha(root.colors.text, 0.6)
            antialiasing: true

            transform: Rotation {
                origin.x: minuteHand.width / 2
                origin.y: minuteHand.length
                angle: clock.minuteAngle
            }
        }

        Rectangle {
            id: secondDot

            readonly property real distance: Math.max(clock.inner * 0.5, (face.width > 0 ? face.distanceAtAngle(clock.secondAngle) : clock.inner) - clock.dotSize * 1.4 - clock.tickInset)

            visible: root.settings.showSeconds
            x: clock.width / 2 + distance * Math.sin(clock.secondAngle * Math.PI / 180) - width / 2
            y: clock.height / 2 - distance * Math.cos(clock.secondAngle * Math.PI / 180) - height / 2
            width: clock.dotSize
            height: width
            radius: width / 2
            color: root.colors.text
        }

        Rectangle {
            anchors.centerIn: parent
            width: clock.handWidth * 1.6
            height: width
            radius: width / 2
            color: root.colors.text
            antialiasing: true
        }
    }
}
