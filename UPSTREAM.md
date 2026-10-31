# Upstream sources and credits

Integrated from the engine and GUI fetched on October 31, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `b6db28c5672f7982a830bee3f30d37476d04788a`.
Engine SHA256: `04a5b7aa39461da99f73cedd18e6ef40d091df328e7bea86290d7e9a893ccbdb`. GUI SHA256: `915822cad366003ffaa4a4ebd77227617b0a41e72660ab3185b1e9f83c0b6b26`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
