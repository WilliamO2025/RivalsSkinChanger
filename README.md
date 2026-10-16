# Rivals Skin Changer 3.7

Hybrid of Martini's FULLMATCHA GUI/engine and our loader improvements. Open with:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamO2025/RivalsSkinChanger/main/skin-gui.lua"))()
```

Right Shift opens/hides the GUI. Pick a weapon or cosmetic, then **Save & Apply**. Drag the title to move; drag a corner to resize. The top bar contains the update log.

## Features

- Weapon categories, searchable skin artwork, Default, Switch and owned-skin Swap.
- Wraps, finishers, charms/ranks, skyboxes and lighting.
- Hit/headshot/kill sounds, tracer colour/speed, and upstream local spoof controls.
- 420px skin sources where available, falling back to the site's artwork.
- Bundled engine, previous-GUI cleanup, guarded memory access and config backups.

## Automatic startup on every join

Put this repository's **autoexec.lua** into **C:\matcha\autoexec** once. Keep only one Rivals launcher there; do not also autoexecute the engine or an older GUI. The launcher downloads our bundled GUI, waits for the player/camera, and stops in other games. It does not need RivalsSkinSwapper.lua or RivalsSkinGui.lua in the workspace.

Leave **Auto-apply on join** enabled in Settings. Saved configuration lives in rivals_config.lua and settings in rivals_gui_settings.txt. The launcher folder requirement comes from the upstream README. No Matcha installation files were inspected or changed during this update.

A normal loadstring cannot recreate a script VM after the host clears it. The autoexec launcher is the host-supported path described by upstream.

## Upgrading

An active 2.x GUI is stopped and restored before this GUI opens. When no rivals_config.lua exists, our saved non-default selections are imported. Existing configs are preserved. The prior GUI remains available as legacy/skin-gui-2.4.lua. Use one version at a time; rejoin before switching back to the legacy engine. Old pinned loadstrings keep loading their old commit; use the updated URL above.

This adopts the new full GUI: old favorites, standalone rotating-preview panel and interface preferences are not carried into this layout. Skin artwork appears in weapon and skin tiles, including the selected weapon header.

## Applying and validation

Re-equip for skins/wraps; respawn for some skin effects; charms appear on next equip, finishers on next use, and skyboxes on the next map/area load. These timings are upstream guidance, not live verification.

Syntax and isolated mocks passed for all eight pages, Default, title controls, resize, autoapply once per server, rerun cleanup, launcher game filtering/timeout/offline handling and guarded memory access. The live Roblox engine, cosmetics and performance still require in-game testing. Do not treat mock passes as proof that every skin works.

See UPSTREAM.md for source revision and credits.

## September 30 â€” upstream 3.4
Merged FULLMATCHA b938e2bff671bc3ade20953ad42b596f05c05ebe and reviewed MATCHA e6a34b99566909c2deb08f5e47492dca9160255c. Adds new Roblox layout offsets, persisted undo records, No Hands, a combined Misc tab, owned-item filtering, conflicting-swap checks, Energy Pistols tracers and the first-run notice. Our idle redraw reductions, paced artwork, corner resizing and bundled-engine session guards remain.

Upstream support code: a short identifier is derived locally from Matcha's hardware ID and shown in logs/settings. The engine downloads the author's rsc-refs blocklist and stops for listed identifiers. The hardware ID is not sent in that HTTP request. We retained this upstream behavior; our notice does not claim undetectability.

The updated autoexec launcher sets the upstream startup flag. After acknowledging the first-run notice, the GUI defaults to hidden on autoexec; Right Shift opens it. Settings > Window on autoexec changes that behavior.

Validation: Lua syntax, first-run acknowledgement, new Misc pages, No Hands config round-trip, owned-only filtering/fallback, GUI controls, once-per-server apply, performance regressions, launcher timeout/filtering and memory guards passed in isolated mocks. Live Roblox compatibility and performance remain unverified.
## October 12 — compatibility update 3.5

Merged the supplied engine and GUI in full: runtime Roblox memory-layout detection with fallback, updated inventory and sound lookups, and tracer support for additional layouts. Upstream disables community sky presets reported to crash on map loads; built-in game skies remain available. Existing saved presets are also checked by the engine before applying.

Retained our GUI performance improvements, HD artwork fallback, corner resizing, update log, session guards and autoexec loader. The installed launcher automatically fetches this bundle on the next join; no launcher reinstall is needed.

## October 12 — GUI recovery fix 3.5.1
Hotkey polling now precedes mouse input and drawing. Hiding releases game input before rendering, failed input-capture calls retry, and a failed mouse poll cannot prevent the show/hide toggle. The final animation frame always renders. Regression checks inject mouse and drawing errors after a mocked skin apply; live Matcha behavior still needs confirmation.

Loading responsiveness: long read-only table, nearby-node and layout searches now yield between batches so the GUI scheduler can poll the hotkey. Memory writes are unchanged, and reads revalidate the session after yielding. Synchronous host HTTP/image decoding may still pause input while that single call completes.

## October 12 — Apply responsiveness 3.5.2
New artwork downloads and image decoding wait until Apply completes; already decoded artwork remains visible. The bundled engine is compiled once per GUI session and rerun for each Apply. Slow compilation, engine execution, artwork loading/decoding, support-list HTTP and GUI polling gaps are logged with the prefix `[Rivals GUI timing]`. Elapsed engine timing includes normal waits and is not a CPU measurement. The support-list check remains unchanged. An already-running synchronous host call cannot be interrupted by these changes.

## October 12 — performance update 3.5.3
Repeated text fitting uses a bounded cache keyed by text, width, size and weight. Fully hidden windows skip drawing work after the closing frame while continuing to poll input. Layout detection searches unique offsets in the same priority order and checks the first candidate without an initial scheduler wait. Skin application, memory guards, configuration and artwork quality are unchanged. Mock operation counts verify reduced work; live FPS and apply-time improvement have not been measured.

## October 12 — artwork responsiveness 3.5.4
New textures decode at most once per redraw, at least 80ms apart, and pause during mouse interaction and Apply. Already decoded images retain their quality. Queued images from hidden/old pages are skipped and requeued when revisited. Scrollbars are wider and the weapon page shows supported scrolling controls. Wheel reading is not exposed by the documented Matcha input API; use dragging, arrows or Page Up/Down. Single synchronous downloads/decodes can still cause a pause.

## October 13 — automatic update launcher
Autoexec requests this repository’s main-branch GUI on every join with a fresh request parameter, retries download failures up to three times and logs the loaded version. It never falls back to an old local GUI. A running GUI is not replaced mid-match; updates load on the next join. Network/service failures can still prevent loading.

## October 14 — upstream compatibility fixes 3.6
Integrated FULLMATCHA revision 938e0aa72db6ee42d6bf9637ac42d9f74efe693e. GUI inventory and sound lookups now detect memory layouts dynamically. The engine fetches offsets from offsets.imtheo.lol/Offsets.json, retains a local last-good JSON fallback, and checks core Instance offsets against the running game. Updated sky, sound, display-name, lighting and mesh offsets follow the new lookup. Existing GUI, artwork pacing, performance changes and fresh-main autoexec remain. Validation uses isolated mocks, not live Roblox memory.

## October 14 — startup lifecycle fix 3.6.1
Auto-apply waits for a stable context, catches polling/file errors and marks completion only after a confirmed apply. Failed attempts remain available for manual retry rather than repeatedly mutating memory. Apply errors open the GUI with a message; renderer stop reasons are logged. A non-Rivals ID must persist for five seconds while loaded before closing the GUI. Session-memory guards now use catchable assertions even on hosts where error() only logs. These changes cannot preserve a runtime that Matcha itself terminates.

## October 16 — upstream fixes 3.7
Merged FULLMATCHA 40034f0486fef3ea221bf57e37713c3247ae0d6e. Offset selection checks the running build and keeps versioned caches. Engine and GUI support separated table-mask bytes. Sky changes target map templates, restore prior faces and reject incompatible IDs; upstream re-enables community skies and removes Classic. Lighting, sound-volume and display-name writes gain validation, including Unicode name restoration. Our GUI pacing, lifecycle fixes and latest-main launcher remain. Mock tests pass; map-load compatibility remains unverified in-game.
