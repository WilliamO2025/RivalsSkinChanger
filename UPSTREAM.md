# Upstream sources and credits

Integrated from the engine and GUI fetched on October 20, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `3fd1242f17ef4c940ce16156a43a4e5423dcf330`.
Engine SHA256: `0ec43fc56975e85ff9ee82854b2a1e89aef666e9002af32c91f99f1d825b4082`. GUI SHA256: `333daa6f000e85a69935289fe280afe53186e7180a9cdafcf2f7321272789e08`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
