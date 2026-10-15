# Upstream sources and credits

Integrated from the engine and GUI fetched on October 14, 2026, attributed to Martini's [FULLMATCHA](https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA). Snapshot: `938e0aa72db6ee42d6bf9637ac42d9f74efe693e`.
Engine SHA256: `352744a3620fe1deacabff2cd08bab6301eabdd1ec4ed76b1711b5b195544c78`. GUI SHA256: `f445daa22d224cf6a358e616ab6cef017ca6d30641f5cc62034e2136c6376908`.
The autoexec source is the previously reviewed upstream launcher; its behavior matches the entry point supplied with this update.
Catalog and artwork sources: https://martinikaws.github.io/rivals-skins/ (skin_icon_map.json, assets/wraps.js, assets/cosmetics.js, assets/skyboxes.json).
Credits retained: Martini; mr.vage (GUI contributor, inspired by Gain's external); dantekarati; choperr0333 / @Giounis. Original credits: https://github.com/Martinikaws/RivalsSkinChangerFULLMATCHA#credits.

Integration: bundled engine, guarded memory access, prior GUI cleanup, preference migration when no config exists, HD image fallback, corner resizing, update log, and an own-repository autoexec launcher with timeout/game checks. Matcha installation files were not inspected or modified.
