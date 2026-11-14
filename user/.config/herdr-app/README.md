# Herdr app

Personal configuration for the Herdr desktop app (separate from `../herdr`,
the Herdr TUI). `common/link_files.sh` links these files individually:

- `settings.json`: fonts, ligatures, contrast, zoom and sounds.
- `keys.json`: shortcuts, including Command+S and the backtick prefix.
- `layouts/square-panes.json`: custom layout with square pane borders.
- `themes/material-darker.json`: Material Darker terminal colors.
- `mods/lazygit/`: Command+G LazyGit popup (requires `lazygit` and herdr-core).
- `mods/last-tab/`: remembers the previously focused tab, so pressing the
  backtick prefix then space jumps back to it, like the TUI's herdr-last-tab
  plugin. It draws nothing; its zero-height block in `layouts/square-panes.json`
  only watches tab focus.
- `mods/tmux-prefix/`: backtick-prefixed navigation and commands (`y` requires Yazi).

The LazyGit popup attaches directly, without waiting for the app's terminal-list
refresh. Its `start.sh` briefly waits for the popup's PTY resize before starting
LazyGit, avoiding a first frame drawn at the core's headless dimensions. The wait
is bounded if the viewer never resizes. Closing the popup keeps the terminal
available for reuse; quitting LazyGit with `q` ends it and closes the popup.

Herdr owns the rest of `~/.config/herdr-app`: bundled layouts/mods/themes,
icons, frame screens, generated type declarations and editor configuration,
telemetry, caches, window/session state and mod data. Leave those local;
do not link the entire config directory. Layout click overrides in
`layouts/.state/` are also local.

On a fresh machine, install Maple Mono (the terminal font) and select the
custom layout and theme after starting Herdr:

```sh
herdr-app do layout.switch --name square-panes
herdr-app do app.theme --name material-darker
```

The selected layout/theme are saved by Herdr, not synced as session state.
The UI font is Helvetica Neue on macOS; choose an installed alternative on
other platforms.
