# Nebula Clock

A configurable, shape-based analog clock for the Caelestia desktop. It is inspired by the
desktop widgets in [Nebula](https://github.com/LilaccFlowerr/Nebula): a Material shape face,
drawn hands and ticks, a date inside the face, and a draggable position.

![Nebula Clock](preview.png)

The plugin uses the `desktop-widget` entry point, so it sits above the wallpaper and below
normal windows.

## Requirements

- A plugin-enabled Caelestia Shell build with the `desktop-widget` entry point, such as
  `caelestia-shell-plugins-git`.
- `qt6-m3shapes-git` (already required by the shell).

## Install

```sh
mkdir -p ~/.config/caelestia/plugins
git clone https://github.com/deeadly137/plugin-nebula-clock.git ~/.config/caelestia/plugins/plugin-nebula-clock
```

Enable it in `~/.config/caelestia/plugins.json`:

```json
{
    "enabled": ["deeadly137/nebulaclock"]
}
```

The shell watches the config and plugin directory, so a reload is usually automatic. Restart
the shell if the clock does not appear.

## Configure

Open **Nexus → System → Plugins**, choose **NebulaClock**, and change the settings there. The
same values can be edited directly in `plugins.json`:

```json
{
    "enabled": ["deeadly137/nebulaclock"],
    "settings": {
        "deeadly137/nebulaclock": {
            "shape": "Cookie12Sided",
            "size": 220,
            "colour": "primary",
            "opacity": 1,
            "showSeconds": true,
            "showDate": true,
            "showNumbers": false,
            "tickStyle": "hours",
            "x": -1,
            "y": -1,
            "draggable": true
        }
    }
}
```

- `shape` — `Circle`, `Cookie12Sided`, `Clover4Leaf`, `Sunny`, and other Material shapes.
- `size` — clock face size in pixels.
- `colour` — `primary`, `secondary`, `tertiary`, or `surface`.
- `opacity` — `0.2` to `1`.
- `showSeconds`, `showDate`, `showNumbers` — face details.
- `tickStyle` — `off`, `hours`, or `all`.
- `x`, `y` — desktop position. `-1` centres that axis.
- `draggable` — drag the clock directly on the desktop; the position is saved.

## Plugin details

- Manifest id: `deeadly137/nebulaclock`
- Entry point: `desktop-widget`
- Source: `NebulaClock.qml`
- Settings: `settings.qml`

## License

GPL-3.0-only. See `LICENSE`.
