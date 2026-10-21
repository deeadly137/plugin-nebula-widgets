import Caelestia.Plugins

SettingsObject {
    property string shape: "Cookie12Sided"
    property int size: 220
    property string colour: "primary"
    property real opacity: 1
    property bool showSeconds: true
    property bool showDate: true
    property bool showNumbers: false
    property string tickStyle: "hours"
    property int x: -1
    property int y: -1
    property bool draggable: true

    SettingMeta on shape {
        label: "Shape"
        description: "The Material shape used for the clock face"
        icon: "category"
        inputType: SettingMeta.BlobButton
        options: [
            "Circle",
            "Square",
            "Slanted",
            "Arch",
            "Oval",
            "Pill",
            "Diamond",
            "Pentagon",
            "Gem",
            "Sunny",
            "VerySunny",
            "Cookie4Sided",
            "Cookie6Sided",
            "Cookie7Sided",
            "Cookie9Sided",
            "Cookie12Sided",
            "Ghostish",
            "Clover4Leaf",
            "SoftBurst"
        ]
    }

    SettingMeta on size {
        label: "Size"
        description: "Clock face size in pixels"
        icon: "aspect_ratio"
        inputType: SettingMeta.Slider
        min: 100
        max: 600
        step: 10
    }

    SettingMeta on colour {
        label: "Colour"
        description: "Material colour role for the face and hands"
        icon: "palette"
        inputType: SettingMeta.SplitButton
        options: ["primary", "secondary", "tertiary", "surface"]
    }

    SettingMeta on opacity {
        label: "Opacity"
        description: "How strongly the clock shows over the wallpaper"
        icon: "opacity"
        inputType: SettingMeta.Slider
        min: 0.2
        max: 1
        step: 0.05
    }

    SettingMeta on showSeconds {
        label: "Seconds"
        description: "Show a dot running around the edge"
        icon: "timer"
        inputType: SettingMeta.Switch
    }

    SettingMeta on showDate {
        label: "Date"
        description: "Show today's weekday and day inside the clock"
        icon: "calendar_today"
        inputType: SettingMeta.Switch
    }

    SettingMeta on showNumbers {
        label: "Hour numbers"
        description: "Show 1 through 12 around the face"
        icon: "pin"
        inputType: SettingMeta.Switch
    }

    SettingMeta on tickStyle {
        label: "Tick marks"
        description: "Draw no ticks, twelve hour markers, or all sixty minute markers"
        icon: "more_horiz"
        inputType: SettingMeta.SplitButton
        options: ["off", "hours", "all"]
    }

    SettingMeta on x {
        label: "Horizontal position"
        description: "Drag the clock on the desktop, or use -1 to centre it"
        icon: "swap_horiz"
        inputType: SettingMeta.SpinBox
        min: -1
        max: 10000
        step: 10
    }

    SettingMeta on y {
        label: "Vertical position"
        description: "Drag the clock on the desktop, or use -1 to centre it"
        icon: "swap_vert"
        inputType: SettingMeta.SpinBox
        min: -1
        max: 10000
        step: 10
    }

    SettingMeta on draggable {
        label: "Draggable"
        description: "Move the clock by dragging it on the desktop"
        icon: "open_with"
        inputType: SettingMeta.Switch
    }
}
