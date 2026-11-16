// Last tab: remembers the tab that had focus before the shown one, so a key
// can jump back to it (the app's own tab.next/tab.prev only move by position).
// Bound in keys.json to `last-tab.toggle`, and in tmux-prefix to space. The
// block draws nothing: its only job is to watch spaces() and answer commands.
// Adapted from dantehemerson/herdr-last-tab for the Herdr TUI.

import { View, div } from "gpui-kit";
import { nextCommand, run, setShared, shared, spaces } from "herdr";

const KEY = "last-tab";

export default class LastTab extends View {
  init(_props, cx) {
    // History survives restarts: shared state, keyed by stable tab ids.
    this.last = shared(KEY) ?? null;
    cx.spawn(async (cx) => {
      for (;;) {
        const command = await nextCommand();
        if (command === "toggle") this.toggle();
        // Clears the history (the next render records the shown tab alone).
        else if (command === "forget") { this.last = null; setShared(KEY, null); }
        cx.notify();
      }
    });
  }

  render() {
    const space = spaces().find((s) => s.active);
    const tab = space?.tabs.find((t) => t.active);
    // render runs whenever spaces() changes, so this is the focus watch.
    if (tab && (this.last?.current?.tab !== tab.id || this.last?.current?.space !== space.id)) {
      this.remember(space.id, tab.id);
    }
    return div().size(0);
  }

  // First sight only records the tab; later changes make the old one previous.
  remember(space, tab) {
    const current = this.last?.current ?? null;
    this.last = { current: { space, tab }, previous: current };
    setShared(KEY, this.last);
  }

  toggle() {
    const previous = this.last?.previous;
    if (!previous) return;
    const space = spaces().find((s) => s.id === previous.space);
    // The remembered tab was closed: nothing to go back to.
    if (!space?.tabs.some((t) => t.id === previous.tab)) return;
    // Another space's tab needs that space shown first.
    if (!space.active) run("space.select", { id: previous.space });
    run("tab.select", { id: previous.tab });
  }
}
