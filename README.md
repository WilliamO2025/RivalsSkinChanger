# Rivals Skin Changer 4.0.1

Hybrid of Martini's FULLMATCHA GUI/engine and our loader improvements. Open with:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/WilliamO2025/RivalsSkinChanger/main/skin-gui.lua"))()
```

Right Shift opens/hides the GUI. Pick a weapon or cosmetic, then **Save & Apply**. Drag the title to move; drag a corner to resize. The top bar contains the update log.

## Features

- Weapon categories, searchable skin artwork, Default, Switch and owned-skin Swap.
- Wraps, finishers, charms/ranks, skyboxes and lighting.
- Hit/headshot/kill sounds, tracer colour/speed, and upstream local spoof controls.
- Settings > Extras > Artwork quality: Low (150px) or HD (420px) where available, falling back to the site's artwork. Saved preference, immediate change, no skin reapply.
- Bundled engine, previous-GUI cleanup, guarded memory access and config backups.
- Favorites, recent selections, sorting/rarity/owned filters and new items read from the game.
- Config history/restore, share codes/import, inventory export and a support log.
- Themes, lighting fine-tuning and health-bar shine, pulse and backing colors.
- Optional panic key, skins-only mode and FPS-friendly live effects.
- Changed-items-only Apply and a queued Reload script button under Unload.

## Automatic startup on every join

Put this repository's **autoexec.lua** into **C:\matcha\autoexec** once. Keep only one Rivals launcher there; do not also autoexecute the engine or an older GUI. The launcher downloads our bundled GUI, waits for the player/camera, and stops in other games. It does not need RivalsSkinSwapper.lua or RivalsSkinGui.lua in the workspace.

Leave **Auto-apply on join** enabled in Settings. Saved configuration lives in rivals_config.lua and settings in rivals_gui_settings.txt. The launcher folder requirement comes from the upstream README. No Matcha installation files were inspected or changed during this update.

A normal loadstring cannot recreate a script VM after the host clears it. The autoexec launcher is the host-supported path described by upstream.

## Upgrading

**Rejoin once when upgrading to 4.0.** The new Roblox layout fixes and engine helpers cannot replace an already-running 3.9 engine through a GUI-only reload. The existing autoexec launcher fetches the current GUI on the next join; no launcher reinstall is needed.

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

## October 20 — upstream merge 3.8

Merged FULLMATCHA `3fd1242f17ef4c940ce16156a43a4e5423dcf330`: shallow asset counting, learned per-build memory-layout caching and loading retries, name reference-count fixes, switch-mode/script and scope fixes, delayed tracer retries, new skin icons, health-bar and button colors, profile-card controls, and console health summaries.

Save & Apply now immediately hides drawings and releases game input before compiling/loading. An identical config is skipped after a clean successful apply in the same server; auxiliary wrap files are included in the comparison. Changed configs still use upstream's full restore/apply cycle, because weapons can share swapped script folders. Per-weapon incremental application is not implemented. The unfinished experimental delta patch is not bundled.

Wheel input is still not supported by this Matcha Drawing menu. Drag the list or scrollbar, or point at it and use arrows/Page Up/Page Down. Upstream documents the same limitation. The menu is not guaranteed to stay responsive during synchronous host calls, and loading is not instant.

All six Misc pages, Apply hiding/no-op/retry behavior, asset counting, name reference-count handling, saved-layout retry, existing GUI performance/lifecycle, offset/layout tests and autoexec tests pass in isolated mocks. Live Roblox behavior and timing remain unverified. Rejoin to fetch 3.8 with the existing autoexec launcher; no Matcha files were changed.

## October 21 — change-only Apply and Reload script (3.9)

After the initial apply in a fresh server, Apply compares the requested settings with the last successful configuration. It restores/replaces only changed weapon groups, wraps, finishers and charms, reuses the initialized engine and dictionary lookup, and runs only affected effect handlers. Default restores the original model and animation/icon pointers. Swaps sharing a model, dictionary slot or borrowed script are updated together; failed work remains pending for retry. New servers still need the initial full apply. Upgrade from 3.8 requires one rejoin because that version did not preserve original animation pointers.

Settings > Reload script sits directly under Unload. It saves selections, fetches the newest main-branch bundle with a fresh URL, compiles it before stopping the old GUI, then cleans up drawings/input and opens one replacement. If Apply is busy, Reload queues until it finishes. Download failures leave the current window running. Already applied skins and the current incremental engine stay active during a same-version GUI reload. An engine-version upgrade may require a rejoin. Reload does not restart Roblox or Matcha.

Wheel support is conditional: the menu now subscribes to UserInputService.InputChanged when the host exposes it, consumes wheel input only over the hovered list, and disconnects on unload/reload. Matcha's published docs still list only InputBegan/InputEnded, so wheel events are not guaranteed on this build. Settings reports unavailable / waiting for host events / input received. Dragging and keyboard scrolling remain available.

Validation: isolated tests execute the actual model-swap and dictionary-sync helpers for single-weapon edits, shared script families, Default, dependent spare scripts, cosmetics, auxiliary wrap changes/removal, failed-write retry and stale-session rejection. GUI tests cover resident-engine dispatch, wheel-capable and wheel-unavailable hosts, reload placement, offline retry, selection preservation and one-window replacement. Existing launcher, layout and offset tests pass. Live Matcha/Roblox behavior is not verified.

## October 21 — Reload button fix 3.9.1

Reload is clickable while an operation is busy and shows “Waiting for apply…” after being queued. It waits for both the GUI job and engine apply lock before downloading and restarting. Repeated clicks do not start duplicate reloads. Failed downloads leave the current GUI running and allow another attempt. Tested through actual simulated mouse clicks, including both busy locks and successful replacement; live Matcha behavior remains unverified. Run the loadstring once or rejoin to replace the old disabled button.

## October 22 — upstream feature update 4.0

Merged FULLMATCHA `68f42abf4968e96a100a9f3a3f58b3db4f916a0a`, including its Roblox module-thread/registry-slot detection, gradient lookup and tracer-speed fixes. Added favorites/recent picks, filters, live-game catalog additions, config history/sharing/import/export, progress and logs, notification controls, themes, lighting tuning, health-bar extras, panic reset, skins-only mode and FPS-friendly effects.

Our resident incremental Apply remains the only apply path after initialization; upstream's separate quick-run path is disabled to avoid conflicting undo ownership. Theme and skins-only transformations feed the same diff planner used for applying. Panic restores changes without overwriting the saved config and ignores auxiliary wraps for that reset. Save & Apply brings selections back. Reload, artwork pacing, corner resizing and conditional host wheel support remain.

Validated with isolated GUI mouse/scheduler tests, all Settings pages, actual swap/sync helpers, theme-only changes, mode changes, panic/default restoration, current and older memory-layout fixtures, startup/offset tests, and failed-download reload recovery. Live Roblox/Matcha functionality and FPS improvements are not verified. “Safe mode” limits enabled features; it is not a detection or account-safety guarantee.
