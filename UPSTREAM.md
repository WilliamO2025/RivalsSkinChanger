# Upstream sources and credits

Integrated from the engine and GUI supplied by the user on October 12, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `user-supplied-2026-10-12`.
Engine SHA256: `77493eb903bd4033d1accb634c1e60cd467fb73447cb26425b36007789c6b0d5`. GUI SHA256: `082519833b79152dfa7516d5fdf17f077a992ab577d2c88cd225b2ccee144e30`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
