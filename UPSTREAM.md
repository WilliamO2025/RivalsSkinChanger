# Upstream sources and credits

Integrated from the engine and GUI fetched on October 22, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `68f42abf4968e96a100a9f3a3f58b3db4f916a0a`.
Engine SHA256: `f37e4cc5d16adc64b019b578f29557167931244e38c7f8ddf787ab806664aaa2`. GUI SHA256: `dc6b953d35fe666963da14789decce33f63d2bf73d82a3b458c6af924b11df31`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
