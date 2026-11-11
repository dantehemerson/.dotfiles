// cmd+g: lazygit in a popup over the window, in the focused terminal's
// folder. Bound in keys.json to `mod.open:lazygit`. This mod opens for an
// instant, starts lazygit in herdr-core (or reuses the one already running),
// then attaches it directly; quitting lazygit (q) closes the popup.

import { View, div } from "gpui-kit";
import { hc, focused, home, appHome, terminals, openOverlay, notify, props, closeOverlay } from "herdr";

export default class Lazygit extends View {
  init(_p, cx) {
    cx.spawn(async (cx) => {
      // props() (this overlay's id) is ready a moment after init.
      let overlay = props()?.overlay;
      for (let i = 0; i < 20 && !overlay; i++) {
        await cx.sleep(16);
        overlay = props()?.overlay;
      }
      const address = await this.terminal();
      const now = focused();
      const alreadyPeeked = Boolean(address) && now?.terminal === address && !now?.pane;
      if (overlay) closeOverlay(overlay);
      if (address && !alreadyPeeked) openOverlay({
        kind: "dialog", width: 0.8, height: 0.8,
        layout: {
          id: "lazygit-popup", type: "column",
          children: [
            { id: "lazygit-bar", type: "block", size: { px: 28 }, content: { mod: "peek", props: { terminal: address } } },
            { id: "lazygit-terminal", type: "block", content: { terminal: address } },
          ],
        },
      });
    });
  }

  // A live lazygit from an earlier popup (or from before an app restart).
  live() {
    return terminals().find((t) => t.state === "live" && t.name === "lazygit") ?? null;
  }

  // Herdr's terminal list can lag a moment behind herdr-core: a terminal that
  // has just quit may still look live here. Ask the core before reusing one.
  async coreLive(address) {
    const r = await hc(["ls", "--json"]).catch(() => null);
    if (r?.code !== 0) return false;
    try {
      return (JSON.parse(r.stdout).terminals ?? []).some((t) => t.address === address && t.state === "live");
    } catch {
      return false;
    }
  }

  async terminal() {
    const found = this.live();
    if (found && await this.coreLive(found.address)) return found.address;
    const cwd = focused()?.cwd || home();
    const r = await hc([
      "run", "--bg", "--json", "--no-parent", "--rm",
      "--name", "lazygit", "--cwd", cwd, "--", "sh", `${appHome()}/mods/lazygit/start.sh`,
    ]).catch(() => null);
    let address = null;
    try {
      address = r?.code === 0 ? JSON.parse(r.stdout).address : null;
    } catch {}
    if (!address) {
      // The name may already belong to a terminal the app hasn't listed yet.
      const list = await hc(["ls", "--json"]).catch(() => null);
      if (list?.code === 0) {
        try {
          address = (JSON.parse(list.stdout).terminals ?? [])
            .find((t) => t.name === "lazygit" && t.state === "live")?.address ?? null;
        } catch {}
      }
    }
    if (!address) {
      notify({ title: "Lazygit", body: "Could not start it. Is lazygit installed and on PATH?" });
      return null;
    }
    // A layout terminal can attach directly; terminal.peek first requires the
    // app's periodically refreshed terminal list to contain this address.
    return address;
  }

  render() {
    return div();
  }
}
