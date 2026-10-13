-- Rivals changer - autoexec entry point.
--
-- This loads the GUI only: a window drawn on screen. It starts hidden; Right
-- Shift shows and hides it (the key and the hiding are in its Settings). It
-- applies your saved config by itself once Rivals has loaded (Auto-apply on
-- join), and stays there, so you can change a skin mid-game and press Save &
-- Apply without rejoining.
--
-- Do not also put the changer (RivalsSkinSwapper.lua) in this folder: it would
-- run a second time and the second run is refused by its own lock.

local URL = "https://raw.githubusercontent.com/WilliamO2025/RivalsSkinChanger/main/skin-gui.lua"
local RIVALS_GAME_ID = 6035872082

local function download()
    for attempt = 1, 3 do
        -- A new URL per request avoids reusing a cached main-branch response.
        local requestUrl = URL .. "?refresh=" .. tostring(math.floor(tick()*1000)) .. "-" .. tostring(attempt)
        local ok, body = pcall(function() return game:HttpGet(requestUrl) end)
        if ok and type(body) == "string" and #body > 0 then return body, "GitHub main" end
        if attempt < 3 then task.wait(attempt) end
    end
end

-- Autoexec runs before the game exists, and a yield out here would throw, so
-- the waiting happens in its own thread. The window needs the player and the
-- camera.
task.spawn(function()
    local deadline = tick() + 300
    local loaded=false
    while tick() < deadline do
        local ok, ready = pcall(function()
            return game:IsLoaded() and game:GetService("Players").LocalPlayer ~= nil and workspace.CurrentCamera ~= nil
        end)
        if ok and ready then loaded=true;break end
        task.wait(0.5)
    end

    if not loaded then warn("Rivals launcher timed out waiting for the game.");return end
    -- Only in RIVALS.
    local okId, gameId = pcall(function() return tonumber(game.GameId) end)
    if not okId or gameId ~= RIVALS_GAME_ID then
        print("[Rivals GUI] Not RIVALS - nothing loaded in this game.")
        return
    end

    local source, from = download()
    if not source then
        warn("[Rivals GUI] Could not download the current GitHub version after 3 attempts. No old local copy was loaded.")
        return
    end

    local version = source:match("Rivals Skin Changer ([%d%.]+)") or "unknown"
    local fn, err = loadstring(source)
    if type(fn) ~= "function" then
        warn("[Rivals GUI] Could not compile the GUI: " .. tostring(err))
        return
    end
    -- Tells the GUI autoexec started it, so its window stays hidden until its
    -- key is pressed (Settings > Window on autoexec changes that).
    _G.__RivalsGuiFromAutoexec = true
    local okRun, runErr = pcall(fn)
    if not okRun then
        warn("[Rivals GUI] " .. tostring(runErr))
    else
        print("[Rivals GUI] Loaded from " .. tostring(from) .. " (version " .. version .. ").")
    end
end)
