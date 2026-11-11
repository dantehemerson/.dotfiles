import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import test from "node:test";
import vm from "node:vm";

const source = readFileSync(new URL("../user/.config/herdr-app/mods/lazygit/main.js", import.meta.url), "utf8")
  .replace(/^import .*;\n/gm, "")
  .replace("export default class Lazygit", "globalThis.Lazygit = class Lazygit");

function setup({ listed = [], replies = [], focus = { cwd: "/repo with spaces", pane: "p1" } } = {}) {
  const calls = [], overlays = [], notices = [], closed = [], sleeps = [];
  const context = vm.createContext({
    View: class {}, div: () => ({}),
    focused: () => focus, home: () => "/home", appHome: () => "/config with spaces",
    terminals: () => listed, props: () => ({ overlay: "launcher" }),
    hc: async (args) => { calls.push(Array.from(args)); return replies.shift(); },
    openOverlay: (spec) => overlays.push(spec), closeOverlay: (id) => closed.push(id),
    notify: (notice) => notices.push(notice),
  });
  vm.runInContext(source, context);
  const mod = new context.Lazygit();
  const cx = { spawn: (fn) => { cx.pending = fn(cx); }, sleep: async (ms) => sleeps.push(ms) };
  return { mod, cx, calls, overlays, notices, closed, sleeps };
}
const result = (value) => ({ code: 0, stdout: JSON.stringify(value) });

test("opens a newly created terminal without waiting for app discovery", async () => {
  const s = setup({ replies: [result({ address: "t1" })] });
  s.mod.init({}, s.cx);
  await s.cx.pending;
  assert.equal(s.calls.length, 1);
  assert.deepEqual(s.calls[0].slice(-4), ["/repo with spaces", "--", "sh", "/config with spaces/mods/lazygit/start.sh"]);
  assert.equal(s.overlays[0].layout.children[1].content.terminal, "t1");
  assert.deepEqual(s.closed, ["launcher"]);
  assert.deepEqual(s.sleeps, []);
});

test("validates and reuses a live terminal", async () => {
  const live = { address: "t2", name: "lazygit", state: "live" };
  const s = setup({ listed: [live], replies: [result({ terminals: [live] })] });
  assert.equal(await s.mod.terminal(), "t2");
  assert.deepEqual(s.calls, [["ls", "--json"]]);
});

test("restarts a terminal that quit before the app refreshed", async () => {
  const s = setup({ listed: [{ address: "old", name: "lazygit", state: "live" }],
    replies: [result({ terminals: [] }), result({ address: "new" })] });
  assert.equal(await s.mod.terminal(), "new");
  assert.equal(s.calls[1][0], "run");
});

test("recovers a name collision before app discovery", async () => {
  const s = setup({ replies: [{ code: 1 }, result({ terminals: [{ name: "lazygit", state: "live", address: "t3" }] })] });
  assert.equal(await s.mod.terminal(), "t3");
});

test("reports launch failure without opening a broken popup", async () => {
  const s = setup({ replies: [{ code: 1 }, { code: 1 }] });
  s.mod.init({}, s.cx);
  await s.cx.pending;
  assert.equal(s.notices.length, 1);
  assert.equal(s.overlays.length, 0);
  assert.deepEqual(s.closed, ["launcher"]);
});

test("does not duplicate an already focused popup", async () => {
  const live = { address: "t2", name: "lazygit", state: "live" };
  const s = setup({ listed: [live], replies: [result({ terminals: [live] })], focus: { terminal: "t2" } });
  s.mod.init({}, s.cx);
  await s.cx.pending;
  assert.equal(s.overlays.length, 0);
});
