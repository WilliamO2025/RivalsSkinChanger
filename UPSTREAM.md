# Upstream sources and credits

Integrated from the engine and GUI fetched on October 16, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `40034f0486fef3ea221bf57e37713c3247ae0d6e`.
Engine SHA256: `85fa2adfd32800e57bcfa97df2beac17002ed711a17d27e462c25ceb6ac248bd`. GUI SHA256: `82232ee62465c8669ed886c4ecc2aeeeaca2b9d17afbddbda0e9fd9bcf11277a`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
