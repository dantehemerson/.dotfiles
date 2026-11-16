// Resize mode: prefix+r, then h/j/k/l to move the nearest divider, like the
// Herdr TUI's resize mode. Herdr has no pane.resize command (yet), so read the
// core's herdr-app document to find the split tree, then move two siblings'
// weights with layout.resize.
//
// The focused pane's size is not exposed to mods, but the document has the
// whole tab tree: split direction, nesting and each child's weight. Adjusting
// a branch and its neighbour keeps every other pane's share as it was.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { closeOverlay, exec, focused, panes, props, run, setShared, shared, spaces, theme } from "herdr";

const DOC = "herdr-app";
// Each press moves 2.5% of the split; shift moves 10%.
const STEP = 0.025;
const BIG_STEP = 0.1;
// Never squeeze a pane below this share of its split.
const MIN_SHARE = 0.05;
// For splits whose children use fixed pixel sizes instead of weights.
const STEP_PX = 20;
const BIG_STEP_PX = 80;
const MIN_PX = 40;

const DIRECTIONS = {
  h: ["row", -1], left: ["row", -1], arrowleft: ["row", -1],
  l: ["row", 1], right: ["row", 1], arrowright: ["row", 1],
  k: ["column", -1], up: ["column", -1], arrowup: ["column", -1],
  j: ["column", 1], down: ["column", 1], arrowdown: ["column", 1],
};

function visible(node) {
  return Boolean(node) && !node.hidden && node.size?.px !== 0;
}

function weightOf(node) {
  const size = node?.size ?? {};
  if (typeof size.weight === "number" && size.weight > 0) return size.weight;
  if (typeof size.px === "number" && size.px > 0) return size.px;
  return 1;
}

// The path from the tab root to the node, root first.
function findPath(node, id) {
  if (!node) return null;
  if (node.id === id) return [node];
  for (const child of node.children ?? []) {
    const rest = findPath(child, id);
    if (rest) return [node, ...rest];
  }
  return null;
}

function shellQuote(text) {
  return `'${String(text).replace(/'/g, `'\\''`)}'`;
}

export default class ResizeMode extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    this.target = props()?.pane ?? focused()?.pane ?? shared("resize-mode.pane") ?? null;
    setShared("resize-mode.pane", null);
    this.machine = null;
    this.path = null;
    this.status = "loading";
    this.error = "";
    this.loading = this.load(cx);
  }

  async load(cx) {
    try {
      await this.read();
    } catch (error) {
      this.status = "error";
      this.error = error?.message ?? "could not read the pane layout";
    }
    // The overlay may have closed while hc was reading.
    try { cx.notify(); } catch {}
  }

  async read() {
    if (!this.target) throw new Error("no pane to resize");
    const space = spaces().find((s) => s.active);
    const machine = space?.machine ?? null;
    const bare = machine && this.target.startsWith(`${machine}/`) ? this.target.slice(machine.length + 1) : this.target;
    const params = { name: DOC };
    if (machine) params.on = machine;
    const request = JSON.stringify({ jsonrpc: "2.0", id: 1, method: "doc.get", params });
    // hc() cannot write stdin, so feed the one request through a shell.
    const result = await exec("sh", ["-c", `printf '%s\\n' ${shellQuote(request)} | hc connect`], { timeout: 5000 });
    if (result.code !== 0) throw new Error(result.stderr.trim() || `hc exited ${result.code}`);
    let doc = null;
    for (const line of result.stdout.split("\n")) {
      if (!line.trim()) continue;
      const reply = JSON.parse(line);
      if (reply?.result?.value) doc = reply.result.value;
      else if (reply?.error) throw new Error(reply.error.message ?? "doc.get failed");
    }
    if (!doc) throw new Error("no document");
    for (const space of doc.spaces ?? []) {
      for (const tab of space.tabs ?? []) {
        const path = findPath(tab.root, bare);
        if (!path) continue;
        this.machine = machine;
        this.path = path;
        this.status = "ready";
        this.unzoom();
        return;
      }
    }
    throw new Error("pane not found");
  }

  unzoom() {
    const pane = panes().find((p) => p.pane === this.target);
    // A zoomed tab hides every other pane, so there is no divider to move.
    if (pane?.zoomed) run("pane.zoom", { pane: this.target });
  }

  id(node) {
    return this.machine ? `${this.machine}/${node.id}` : node.id;
  }

  key(e, cx) {
    cx.stop_propagation();
    const m = e.modifiers ?? {};
    if (e.key === "escape" || e.key === "enter") return this.close();
    const typed = e.key_char && e.key_char.length === 1 && !/[\u0000-\u001f\u007f]/.test(e.key_char) ? e.key_char : null;
    const raw = typed ?? e.key ?? e.keystroke;
    if (typeof raw !== "string") return this.close();
    const name = raw.toLowerCase();
    const direction = DIRECTIONS[name];
    if (!direction) return this.close();
    if (this.status !== "ready") return this.close();
    this.resize(direction[0], direction[1], Boolean(m.shift || raw !== name));
  }

  resize(orientation, forward, big) {
    const path = this.path;
    if (!path) return;
    // The nearest ancestor split of this orientation: a pane nested in a
    // column still resizes left and right at the row that contains it.
    let splitIndex = -1;
    for (let i = path.length - 2; i >= 0; i--) {
      const node = path[i];
      if (node.type === orientation && (node.children ?? []).filter(visible).length > 1) {
        splitIndex = i;
        break;
      }
    }
    if (splitIndex < 0) return;
    const split = path[splitIndex];
    const branch = path[splitIndex + 1];
    const children = split.children ?? [];
    const index = children.indexOf(branch);
    if (index < 0) return;

    // The neighbour the key points at grows the pane; with none on that side,
    // the same key shrinks it by giving space to the other side, as the TUI does.
    let neighbour = -1;
    let grow = false;
    for (let i = index + forward; i >= 0 && i < children.length; i += forward) {
      if (visible(children[i])) { neighbour = i; grow = true; break; }
    }
    if (neighbour < 0) {
      for (let i = index - forward; i >= 0 && i < children.length; i -= forward) {
        if (visible(children[i])) { neighbour = i; grow = false; break; }
      }
    }
    if (neighbour < 0) return;

    const parts = children.filter(visible);
    const total = parts.reduce((sum, node) => sum + weightOf(node), 0);
    const mine = weightOf(children[index]);
    const theirs = weightOf(children[neighbour]);
    const fixed = parts.every((node) => typeof node.size?.px === "number");
    if (fixed) {
      const amount = big ? BIG_STEP_PX : STEP_PX;
      const shrink = grow ? children[neighbour].size.px : children[index].size.px;
      const move = Math.min(amount, shrink - MIN_PX);
      if (move <= 0) return;
      const nextMine = children[index].size.px + (grow ? move : -move);
      const nextTheirs = children[neighbour].size.px + (grow ? -move : move);
      children[index].size = { px: nextMine };
      children[neighbour].size = { px: nextTheirs };
      run("layout.resize", { id: this.id(children[index]), px: nextMine });
      run("layout.resize", { id: this.id(children[neighbour]), px: nextTheirs });
      return;
    }

    const move = Math.min((big ? BIG_STEP : STEP) * total, (grow ? theirs : mine) - MIN_SHARE * total);
    if (move <= 0.0001) return;
    const nextMine = mine + (grow ? move : -move);
    const nextTheirs = theirs + (grow ? -move : move);
    children[index].size = { weight: nextMine };
    children[neighbour].size = { weight: nextTheirs };
    run("layout.resize", { id: this.id(children[index]), weight: nextMine });
    run("layout.resize", { id: this.id(children[neighbour]), weight: nextTheirs });
  }

  close() {
    const overlay = props()?.overlay;
    if (overlay) closeOverlay(overlay);
  }

  hint() {
    if (this.status === "loading") return "reading pane layout…";
    if (this.status === "error") return this.error;
    const pane = panes().find((p) => p.pane === this.target);
    return pane?.title ?? pane?.cwd ?? "";
  }

  render() {
    const t = theme();
    return h_flex()
      .id("resize-mode")
      .size_full()
      .px(12)
      .gap(10)
      .items_center()
      .bg(t.popover)
      .border(1)
      .border_color(t.border)
      .rounded(8)
      .text_size(12)
      .text_color(t.foreground)
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .child(div().flex_none().font_semibold().text_color(t.accent).child("resize"))
      .child(div().flex_1().min_w(0).truncate().text_color(this.status === "error" ? t.blocked : t.muted).child(this.hint()))
      .child(div().flex_none().text_color(t.dim).child("h j k l"))
      .child(div().flex_none().text_color(t.dim).child("⇧ bigger"))
      .child(div().flex_none().text_color(t.dim).child("esc done"));
  }
}
