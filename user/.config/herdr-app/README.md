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
- `mods/resize-mode/`: backtick then `r` for the TUI's resize mode: `h/j/k/l`
  (or arrows) move the focused pane's nearest divider and `esc` or `enter`
  leaves. It reads the core's tab layout, so it follows nested splits; each
  press moves 2.5% of the split (shift: 10%). Herdr has no pane resize command
  yet, so it edits the two neighbouring split weights with `layout.resize`.

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

On a fresh machine, install Maple Mono (the terminal font). The layout and
theme are applied by `setup/scripts/herdr_app_setup.sh`, which runs at the
end of post-install tasks (Herdr saves the selected layout/theme locally,
so the linked files alone do not restore them):

```sh
~/.dotfiles/setup/scripts/herdr_app_setup.sh
```

It runs `herdr-app do layout.switch --name square-panes` and
`herdr-app do app.theme --name material-darker`; run it again after an app
update resets the layout. It skips itself when herdr-app is not installed.
The UI font is Helvetica Neue on macOS; choose an installed alternative on
other platforms.
