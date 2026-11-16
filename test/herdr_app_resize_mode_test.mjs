import assert from "node:assert";
import { readFileSync } from "node:fs";
import test from "node:test";
import vm from "node:vm";

const source = readFileSync(new URL("../user/.config/herdr-app/mods/resize-mode/main.js", import.meta.url), "utf8")
  .replace(/^import .*;\n/gm, "")
  .replace("export default class ResizeMode", "globalThis.ResizeMode = class ResizeMode");

const result = (value) => ({ code: 0, stdout: `${JSON.stringify({ jsonrpc: "2.0", id: 1, result: { value } })}\n` });

function setup({ doc = null, pane = "p1", zoomed = false, machine = null, execResult = null } = {}) {
  const runs = [], closed = [], commands = [], store = {};
  const context = vm.createContext({
    View: class {},
    div: () => chain(),
    h_flex: () => chain(),
    theme: () => new Proxy({}, { get: () => "#000" }),
    panes: () => [{ pane, title: "shell", zoomed }],
    focused: () => ({ pane }),
    props: () => ({ pane, overlay: "resize-mode" }),
    spaces: () => [{ id: "sp1", active: true, machine }],
    shared: (key) => store[key] ?? null,
    setShared: (key, value) => { store[key] = value; },
    run: (name, args) => runs.push([name, args ?? {}]),
    closeOverlay: (id) => closed.push(id),
    exec: async (command, args, options) => {
      commands.push({ command, args, options });
      return execResult ?? result(doc);
    },
  });
  vm.runInContext(source, context);
  const mod = new context.ResizeMode();
  const cx = {
    focus_handle: () => ({ focus() {} }),
    notify() { this.notified = true; },
    stop_propagation() { this.stopped = true; },
  };
  mod.init({}, cx);
  return { mod, cx, runs, closed, commands };
}

// Enough of the element builder for render() and key() calls in tests.
function chain() {
  const element = {
    id: () => element, size_full: () => element, px: () => element, gap: () => element,
    items_center: () => element, bg: () => element, border: () => element, border_color: () => element,
    rounded: () => element, text_size: () => element, text_color: () => element, font_semibold: () => element,
    flex_none: () => element, flex_1: () => element, min_w: () => element, truncate: () => element,
    track_focus: () => element, on_key_down: () => element, child: () => element,
  };
  return element;
}

const tab = (root) => ({
  spaces: [{ id: "sp1", tabs: [{ id: "tab1", root }] }],
});
const block = (id, size) => ({ type: "block", id, content: { terminal: id }, size });
const row = (id, children) => ({ type: "row", id, children });
const column = (id, children) => ({ type: "column", id, children });

const press = (mod, cx, key, shift = false) => {
  mod.key({ key, key_char: key.length === 1 && !shift ? key : shift ? key.toUpperCase() : null, modifiers: { shift } }, cx);
};

test("reads the focused pane from the core document", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  assert.equal(s.mod.status, "ready");
  assert.equal(s.mod.path.at(-1).id, "p1");
  assert.match(s.commands[0].args[1], /doc\.get/);
  assert.match(s.commands[0].args[1], /hc connect/);
});

test("resizes toward a neighbour by 2.5% of the split", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "l");
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "p1", weight: 1.05 }],
    ["layout.resize", { id: "p2", weight: 0.95 }],
  ]);
});

test("at the outer edge the same key shrinks the pane", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "h");
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "p1", weight: 0.95 }],
    ["layout.resize", { id: "p2", weight: 1.05 }],
  ]);
});

test("a pane in a nested column resizes the row that contains it", async () => {
  const tree = row("tab1", [
    block("left", { weight: 1 }),
    column("s1", [block("top", { weight: 1 }), block("bottom", { weight: 1 })]),
  ]);
  const s = setup({ doc: tab(tree), pane: "bottom" });
  await s.mod.loading;
  press(s.mod, s.cx, "l");
  // bottom is in the last row child, so moving right shrinks that column.
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "s1", weight: 0.95 }],
    ["layout.resize", { id: "left", weight: 1.05 }],
  ]);
});

test("vertical keys resize the nearest column", async () => {
  const tree = row("tab1", [
    block("left", { weight: 1 }),
    column("s1", [block("top", { weight: 1 }), block("bottom", { weight: 1 })]),
  ]);
  const s = setup({ doc: tab(tree), pane: "top" });
  await s.mod.loading;
  press(s.mod, s.cx, "j");
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "top", weight: 1.05 }],
    ["layout.resize", { id: "bottom", weight: 0.95 }],
  ]);
});

test("shift makes a bigger step", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "l", true);
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "p1", weight: 1.2 }],
    ["layout.resize", { id: "p2", weight: 0.8 }],
  ]);
});

test("does not squeeze a pane past the minimum share", async () => {
  const tree = row("tab1", [block("p1", { weight: 0.05 }), block("p2", { weight: 0.95 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "h");
  assert.deepEqual(s.runs, []);
});

test("fixed pixel splits step in pixels", async () => {
  const tree = row("tab1", [block("p1", { px: 400 }), block("p2", { px: 600 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "l");
  assert.deepEqual(s.runs, [
    ["layout.resize", { id: "p1", px: 420 }],
    ["layout.resize", { id: "p2", px: 580 }],
  ]);
});

test("qualifies ids on another machine and unzooms first", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree), pane: "vps/p1", machine: "vps", zoomed: true });
  await s.mod.loading;
  assert.equal(s.mod.machine, "vps");
  assert.deepEqual(s.runs, [["pane.zoom", { pane: "vps/p1" }]]);
  press(s.mod, s.cx, "l");
  assert.deepEqual(s.runs.at(-2), ["layout.resize", { id: "vps/p1", weight: 1.05 }]);
});

test("escape and unknown keys close the mode", async () => {
  const tree = row("tab1", [block("p1", { weight: 1 }), block("p2", { weight: 1 })]);
  const s = setup({ doc: tab(tree) });
  await s.mod.loading;
  press(s.mod, s.cx, "escape");
  press(s.mod, s.cx, "q");
  assert.deepEqual(s.closed, ["resize-mode", "resize-mode"]);
});

test("a missing pane reports it instead of resizing", async () => {
  const s = setup({ doc: tab(row("tab1", [block("other", { weight: 1 })])), pane: "p1" });
  await s.mod.loading;
  assert.equal(s.mod.status, "error");
  press(s.mod, s.cx, "l");
  assert.deepEqual(s.runs, []);
});
