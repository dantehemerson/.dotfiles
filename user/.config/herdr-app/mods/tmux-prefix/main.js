import { View, div } from "gpui-kit";
import { agents, closeOverlay, focused, hc, nextCommand, props, run } from "herdr";

// Adapted from herdrdev/herdr-layout-examples/tmux-prefix: backtick prefix.
const PREFIX = "`";
const BINDINGS = [
  ["g", "Open LazyGit", "mod.open", { name: "lazygit" }],
  ["y", "Open Yazi", "terminal.open", { argv: ["yazi"], place: "tab" }],
  ["c", "New tab", "tab.new"],
  ["%", "Split right", "pane.split", { direction: "right" }],
  ["|", "Split right", "pane.split", { direction: "right" }],
  ['"', "Split down", "pane.split", { direction: "down" }],
  ["x", "Close pane", "pane.close"],
  ["v", "Close pane", "pane.close"],
  ["n", "Next tab", "tab.next"],
  ["p", "Previous tab", "tab.prev"],
  ["h", "Focus left", "pane.go", { direction: "left" }],
  ["j", "Focus down", "pane.go", { direction: "down" }],
  ["k", "Focus up", "pane.go", { direction: "up" }],
  ["l", "Focus right", "pane.go", { direction: "right" }],
  ["left", "Focus left", "pane.go", { direction: "left" }],
  ["down", "Next space", "space.next"],
  ["up", "Previous space", "space.prev"],
  ["right", "Focus right", "pane.go", { direction: "right" }],
  ["J", "Next space", "space.next"],
  ["K", "Previous space", "space.prev"],
  ["ctrl+j", "Next agent", "agent.next"],
  ["ctrl+k", "Previous agent", "agent.prev"],
  ...Array.from({ length: 9 }, (_, i) => [`ctrl+${i + 1}`, `Focus agent ${i + 1}`, "agent.focus.index", { index: i }]),
  ["z", "Zoom pane", "pane.zoom"],
  ["d", "Detach (close window)", "window.close"],
  ["/", "Go to", "app.palette"],
  [",", "Rename tab", "tab.rename"],
  ...Array.from({ length: 10 }, (_, i) => [String(i), `Tab ${i === 0 ? 10 : i}`, "tab.select", { index: i === 0 ? 10 : i }]),
];

export default class TmuxPrefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    // The mod-specific key binding beats the global opener while we're open.
    cx.spawn(async (cx) => {
      for (;;) {
        await nextCommand();
        this.sendPrefix(cx);
      }
    });
  }

  dismiss() {
    closeOverlay(props().overlay);
  }

  send(key, cx) {
    const terminal = focused()?.terminal;
    if (!terminal) return this.dismiss();
    // Start the subprocess before closing cancels this view's tasks.
    const pending = hc(["keys", terminal, key]);
    cx.spawn(async () => {
      const result = await pending;
      if (result.code !== 0) console.log(`tmux-prefix: ${result.stderr}`);
    });
    this.dismiss();
  }

  sendPrefix(cx) {
    this.send(PREFIX, cx);
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers;
    if (e.key === "escape") return this.dismiss();
    const plain = !m.control && !m.alt && !m.platform;
    const key = e.key_char ?? (m.shift && e.key.length === 1 ? e.key.toUpperCase() : e.key);
    if (plain && key === PREFIX) return this.sendPrefix(cx);
    const chord = plain ? key : m.control && !m.alt && !m.platform ? `ctrl+${String(key).toLowerCase()}` : null;
    const binding = chord && BINDINGS.find((b) => b[0] === chord);
    if (!binding) return this.dismiss();
    const [, , command, args = {}] = binding;
    this.dismiss();
    if (command === "agent.focus.index") {
      const agent = agents()[args.index];
      if (agent) run("agent.focus", { terminal: agent.address });
      return;
    }
    run(command, args);
  }

  render() {
    // Keep keyboard focus without painting a hint or an overlay frame.
    return div().id("tmux-prefix").size_full().track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx));
  }
}
