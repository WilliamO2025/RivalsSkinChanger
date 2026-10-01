# Rivals Skin Changer 3.4

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

## September 30 — upstream 3.4
Merged FULLMATCHA b938e2bff671bc3ade20953ad42b596f05c05ebe and reviewed MATCHA e6a34b99566909c2deb08f5e47492dca9160255c. Adds new Roblox layout offsets, persisted undo records, No Hands, a combined Misc tab, owned-item filtering, conflicting-swap checks, Energy Pistols tracers and the first-run notice. Our idle redraw reductions, paced artwork, corner resizing and bundled-engine session guards remain.

Upstream support code: a short identifier is derived locally from Matcha's hardware ID and shown in logs/settings. The engine downloads the author's rsc-refs blocklist and stops for listed identifiers. The hardware ID is not sent in that HTTP request. We retained this upstream behavior; our notice does not claim undetectability.

The updated autoexec launcher sets the upstream startup flag. After acknowledging the first-run notice, the GUI defaults to hidden on autoexec; Right Shift opens it. Settings > Window on autoexec changes that behavior.

Validation: Lua syntax, first-run acknowledgement, new Misc pages, No Hands config round-trip, owned-only filtering/fallback, GUI controls, once-per-server apply, performance regressions, launcher timeout/filtering and memory guards passed in isolated mocks. Live Roblox compatibility and performance remain unverified.