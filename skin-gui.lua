-- Rivals Skin Changer 3.4; upstream Martini; see UPSTREAM.md for credits.

-- Upgrade from our 2.x GUI. Only our own state and preferences are consulted.
local old = _G.__RIVALS_SKIN_GUI
if old and old.busy then error("Wait for the current skin apply to finish before upgrading.") end
if old and type(old.Destroy)=="function" then
    local ok, restored=pcall(old.Destroy)
    if not ok or restored==false then error("Previous cleanup failed. Rejoin before upgrading.") end
end
pcall(function()
    if isfile("rivals_config.lua") then return end
    local choices=_G.__RIVALS_SKIN_GUI_SELECTIONS
    if type(choices)~="table" and isfile("rivals_skin_changer_settings.json") then
        choices=game:GetService("HttpService"):JSONDecode(readfile("rivals_skin_changer_settings.json")).selections
    end
    if type(choices)~="table" then return end
    local lines={}
    for weapon,skin in pairs(choices) do
        if type(weapon)=="string" and type(skin)=="string" and skin~="Default"
            and not weapon:find("[\r\n=]") and not skin:find("[\r\n]") then
            lines[#lines+1]=weapon.."="..skin
        end
    end
    table.sort(lines)
    if #lines>0 then writefile("rivals_config.lua",table.concat(lines,"\n").."\n") end
end)

local BUNDLED_ENGINE = [====[
-- Rivals skin changer (Matcha)
local t_start = tick()

if not pcall(memory_read, "int", game.Address) then
    return
end

if not game:IsLoaded() then game.Loaded:Wait() end

-- Rivals only
local RIVALS_GAME_ID = 6035872082
local okGameId, gameId = pcall(function() return game.GameId end)
if not okGameId or tonumber(gameId) ~= RIVALS_GAME_ID then return end

local LP = game:GetService("Players").LocalPlayer
while not LP do
    task.wait(0.05)
    LP = game:GetService("Players").LocalPlayer
end

if game.GameId ~= 6035872082 then return end

if type(_G.__RIVALS_SKIN_CHANGER_RESTORE) == "function" then
    pcall(_G.__RIVALS_SKIN_CHANGER_RESTORE)
end
_G.__RIVALS_SKIN_CHANGER_RESTORE = nil
_G.__RIVALS_SKIN_CHANGER_ACTIVE = nil

-- Support ID: a short number for this PC, made here from Matcha's hardware ID
-- and scrambled so it can't be turned back into it. Nothing is sent anywhere;
-- it rides along on two of the log lines (as "ref"), so a log or screenshot
-- says which copy it came from, and the
-- changer refuses to run for IDs on the list in the rsc-refs repo.
local function supportId()
    local ok, hw = pcall(function() return gethwid() end)
    if not ok or type(hw) ~= "string" or hw == "" then return nil end
    local s = "rsc:" .. hw
    local h1, h2 = 7, 11
    for _ = 1, 3 do
        for i = 1, #s do
            local c = s:byte(i)
            h1 = (h1 * 131 + c + h2 % 251) % 999983
            h2 = (h2 * 65599 + c * 7 + i + h1 % 509) % 1000003
        end
    end
    return string.format("%04d-%04d", h1 % 10000, h2 % 10000)
end
do
    local BLACKLIST_URL = "https://raw.githubusercontent.com/Martinikaws/rsc-refs/main/list.txt"
    local id = supportId()
    _G.__RIVALS_SUPPORT_ID = id
    if id then
        -- If the list can't be fetched the changer runs as usual.
        local okList, list = pcall(function() return game:HttpGet(BLACKLIST_URL) end)
        if okList and type(list) == "string" then
            for line in list:gmatch("[^\r\n]+") do
                -- A listed ID stops here, without a message.
                if line:match("^%s*(%d%d%d%d%-%d%d%d%d)") == id then return end
            end
        end
    end
end

-- Run lock
local RUN_LOCK_SECONDS = 180
do
    local busy = _G.__RIVALS_SKIN_CHANGER_BUSY
    if type(busy) == "number" and tick() - busy < RUN_LOCK_SECONDS then
        print("[RivalsSkinChanger] Already running - wait for it to finish, then run it again if needed")
        if typeof(notify) == "function" then
            pcall(notify, "Already running - wait for it to finish", "Rivals Skin Changer", 5)
        end
        return
    end
    _G.__RIVALS_SKIN_CHANGER_BUSY = tick()
end

if typeof(notify) == "function" then pcall(notify, "Starting - applying your skins...", "Rivals Skin Changer", 5) end

-- Game folders
local psRoot = LP:WaitForChild("PlayerScripts", 30)
local A = psRoot and psRoot:WaitForChild("Assets", 30)
if not A then
    for _, d in ipairs(LP:GetDescendants()) do
        if d.Name == "Assets" and d.Parent and d.Parent.Name == "PlayerScripts" then A = d break end
    end
end
local vm = A and A:WaitForChild("ViewModels", 30)
local wf = vm and vm:WaitForChild("Weapons", 30)
local mi = A and A:WaitForChild("Misc", 10)
local tf = A and A:FindFirstChild("Throwables")
local pf = A and A:FindFirstChild("Projectiles")
local stf = A and A:FindFirstChild("SpearTightropes")

if not wf then
    _G.__RIVALS_SKIN_CHANGER_BUSY = nil
    return
end

do
    local lastWf, lastVm = -1, -1
    for _ = 1, 20 do
        local wfCount = #wf:GetChildren()
        local vmCount = #vm:GetDescendants()
        if wfCount == lastWf and vmCount == lastVm then break end
        lastWf, lastVm = wfCount, vmCount
        task.wait(0.3)
    end
end

-- Memory
local mrd, mwr
do
local rawRead, rawWrite = memory_read, memory_write
local sessionJob, sessionGame = game.JobId, game.Address
local function validSession()
    local ok, valid = pcall(function()
        if game.Address ~= sessionGame or game.JobId ~= sessionJob or not game:IsLoaded() then return false end
        local player = game:GetService("Players").LocalPlayer
        local scripts = player and player:FindFirstChild("PlayerScripts")
        local assets = scripts and scripts:FindFirstChild("Assets")
        local models = assets and assets:FindFirstChild("ViewModels")
        local weapons = models and models:FindFirstChild("Weapons")
        return weapons and weapons.Address == wf.Address
    end)
    return ok and valid == true
end
mrd = function(kind, address)
    if not validSession() then error("Server assets changed; memory read cancelled") end
    return rawRead(kind, address)
end
mwr = function(kind, address, value)
    if not validSession() then error("Server assets changed; memory write cancelled") end
    return rawWrite(kind, address, value)
end
end
local pcall, ipairs, pairs = pcall, ipairs, pairs

local rd = function(a)
    local o, v = pcall(mrd, "uintptr_t", a)
    return o and v or nil
end

local wr = function(a, v)
    pcall(mwr, "uintptr_t", a, v)
end

local OFF = {
    Parent = 104,
    NameContainer = 112,
    Children = 120,
    Transparency = 288
}

-- The undo data (what each swap overwrote) lives in _G, which a Matcha restart
-- or update wipes while the game keeps the swaps. A run then would swap the
-- models back and leave the rest of its work on the wrong ones. So each run
-- also saves the data to a file, keyed by this server; the next run reads it
-- back when _G has none, and undoes the old swaps before applying again.
local UNDO_FILE = "rivals_undo_state.txt"
local SERVER_KEY = tostring(game.JobId) .. ":" .. tostring(wf.Address)
-- Returns the saved state for this server, nil when there is none, or
-- false when there is one that can't be read.
local function loadUndo()
    local okF, text = pcall(function() return isfile(UNDO_FILE) and readfile(UNDO_FILE) or nil end)
    if not okF or type(text) ~= "string" then return nil end
    local lines = {}
    for line in text:gmatch("[^\r\n]+") do lines[#lines + 1] = line end
    if lines[1] ~= SERVER_KEY then return nil end
    local function num(s) return s ~= "-" and tonumber(s) or nil end
    local state = {restores = {}, nameCopies = {}, floats = {}, wfAddr = wf.Address}
    for i = 2, #lines do
        local f = {}
        for word in lines[i]:gmatch("%S+") do f[#f + 1] = word end
        local tag = f[1]
        if tag == "R" and #f == 13 then
            state.restores[#state.restores + 1] = {
                defSlot = num(f[2]), skinSlot = num(f[3]), origDefInst = num(f[4]), origSkinInst = num(f[5]),
                origDefCtrl = num(f[6]), origSkinCtrl = num(f[7]), defAddr = num(f[8]), skinAddr = num(f[9]),
                origDefNC = num(f[10]), origSkinNC = num(f[11]), origDefParent = num(f[12]), origSkinParent = num(f[13])}
        elseif tag == "N" and #f == 3 and num(f[2]) and num(f[3]) then
            state.nameCopies[#state.nameCopies + 1] = {num(f[2]), num(f[3])}
        elseif tag == "F" and #f == 3 and num(f[2]) and num(f[3]) then
            state.floats[#state.floats + 1] = {num(f[2]), num(f[3])}
        else
            return false
        end
    end
    return state
end

-- Undo the previous run
local dictCache = {}
do

    local old = _G.__RIVALS_COSMETICS_STATE
    _G.__RIVALS_COSMETICS_STATE = nil
    if type(old) == "table" and type(old.restores) == "table" then
        local fin = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        fin = fin and fin:FindFirstChild("Finishers")
        local charmsFolder = A and A:FindFirstChild("Charms")
        if old.key == tostring(fin and fin.Address) .. "/" .. tostring(charmsFolder and charmsFolder.Address) then
            for i = #old.restores, 1, -1 do
                local r = old.restores[i]
                if r.nameSlot then
                    wr(r.nameSlot, r.name)
                else
                    wr(r.sa, r.ia) if r.ca then wr(r.sa + 8, r.ca) end
                    wr(r.sb, r.ib) if r.cb then wr(r.sb + 8, r.cb) end
                    wr(r.ia + OFF.NameContainer, r.na)
                    wr(r.ib + OFF.NameContainer, r.nb)
                    wr(r.ia + OFF.Parent, r.pa)
                    wr(r.ib + OFF.Parent, r.pb)
                end
            end
        end
    end

    local prev = _G.__RIVALS_SKIN_CHANGER_STATE
    _G.__RIVALS_SKIN_CHANGER_STATE = nil
    if type(prev) ~= "table" then
        local saved = loadUndo()
        if saved == false then
            print("[RivalsSkinChanger] Skins were applied in this server before Matcha restarted, and the saved undo data can't be read, so applying again would mix the models up. Rejoin, then run it once.")
            if typeof(notify) == "function" then
                pcall(notify, "Applied before Matcha restarted - rejoin, then run it once", "Rivals Skin Changer", 8)
            end
            _G.__RIVALS_SKIN_CHANGER_BUSY = nil
            return
        elseif saved then
            prev = saved
            print("[RivalsSkinChanger] Matcha restarted since the last run - undoing its swaps from the saved file first")
        end
    end

    if type(prev) == "table" and type(prev.restores) == "table" and prev.wfAddr == wf.Address and (not prev.jobId or prev.jobId == game.JobId) then
        if type(prev.dicts) == "table" then dictCache = prev.dicts end

        for i = #prev.restores, 1, -1 do
            local r = prev.restores[i]
            if r.defSlot and r.origDefInst then
                wr(r.defSlot, r.origDefInst)
                if r.origDefCtrl then wr(r.defSlot + 8, r.origDefCtrl) end
            end
            if r.skinSlot and r.origSkinInst then
                wr(r.skinSlot, r.origSkinInst)
                if r.origSkinCtrl then wr(r.skinSlot + 8, r.origSkinCtrl) end
            end
            if r.defAddr and r.origDefNC then wr(r.defAddr + OFF.NameContainer, r.origDefNC) end
            if r.skinAddr and r.origSkinNC then wr(r.skinAddr + OFF.NameContainer, r.origSkinNC) end
            if r.defAddr and r.origDefParent then wr(r.defAddr + OFF.Parent, r.origDefParent) end
            if r.skinAddr and r.origSkinParent then wr(r.skinAddr + OFF.Parent, r.origSkinParent) end
        end
        local nc = prev.nameCopies or {}
        for i = #nc, 1, -1 do
            if nc[i][2] then wr(nc[i][1], nc[i][2]) end
        end
        local fl = prev.floats or {}
        for i = #fl, 1, -1 do
            pcall(mwr, "float", fl[i][1], fl[i][2])
        end
    end
end

local _scriptAlive = true
local IMG_OFF = 0xA10

-- Folder slots
local ga = function(f)
    if not f or not f.Address then return end
    local n = rd(f.Address + OFF.Children)
    if not n or n == 0 then return end
    local b, e = rd(n), rd(n + 8)
    if b and e then return b, e end
end

local function findSlotAddress(inst, targetFolder)
    if not inst or not inst.Address or not targetFolder or not targetFolder.Address then return nil end
    local b, e = ga(targetFolder)
    if not b or not e then return nil end
    for slotAddr = b, e - 16, 16 do
        if rd(slotAddr) == inst.Address then
            return slotAddr
        end
    end
    return nil
end

-- Hotbar icons
local function writeImage(label, newAssetId)
    if not _scriptAlive or not label or not label.Address or not newAssetId then return false end
    if not label:IsDescendantOf(game) then return false end
    local a = label.Address
    local ptr = mrd("uintptr_t", a + IMG_OFF)
    if not ptr or ptr < 0x10000000000 or ptr > 0x7FFFFFFFFFFF then return false end
    local cur = mrd("string", ptr)
    if not cur or cur == newAssetId then return true end
    local cap = mrd("uint64_t", a + IMG_OFF + 24) or 31
    local len = #newAssetId
    if len > cap then return false end
    for i = 1, len do
        mwr("uint8_t", ptr + i - 1, string.byte(newAssetId, i))
    end
    mwr("uint8_t", ptr + len, 0)
    mwr("uint64_t", a + IMG_OFF + 16, len)
    return true
end

local function checkImgOffset()
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then return end
    local votes, checked = {}, 0
    for _, d in ipairs(pg:GetDescendants()) do
        if d.ClassName == "ImageLabel" and d.Address then
            checked = checked + 1
            for off = 0x980, 0xB00, 8 do
                local ptr = mrd("uintptr_t", d.Address + off)
                if ptr and ptr > 0x10000000000 and ptr < 0x7FFFFFFFFFFF then
                    local s = mrd("string", ptr)
                    if s and s:find("rbxassetid://") then votes[off] = (votes[off] or 0) + 1 end
                end
            end
            if checked >= 40 then break end
        end
    end
    local best, bestN = nil, 0
    for off, n in pairs(votes) do
        if n > bestN then best, bestN = off, n end
    end
    if best and bestN >= 2 then IMG_OFF = best end
end
pcall(checkImgOffset)

-- Viewmodel root fix
local function fixViewModelRoots()
    local containers = {}
    if LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("Assets") and LP.PlayerScripts.Assets:FindFirstChild("Misc") then
        table.insert(containers, LP.PlayerScripts.Assets.Misc)
    end
    local sp = game:GetService("StarterPlayer")
    if sp:FindFirstChild("StarterPlayerScripts") and sp.StarterPlayerScripts:FindFirstChild("Assets") and sp.StarterPlayerScripts.Assets:FindFirstChild("Misc") then
        table.insert(containers, sp.StarterPlayerScripts.Assets.Misc)
    end

    for _, misc in ipairs(containers) do
        local vmr = misc:FindFirstChild("ViewModelRoot")
        if vmr and not vmr:FindFirstChild("RightArm") then
            for _, c in ipairs(vmr:GetChildren()) do
                if c.ClassName == "Part" and (c.Name == "" or c.Name == "_fake") then
                    pcall(function() c.Name = "RightArm" end)
                    break
                end
            end
        end
    end
end
pcall(fixViewModelRoots)

-- Icon ids
local ITEM_ICONS = {
    ["Assault Rifle"] = {
        ["Standard"] = "rbxassetid://17160682738",
        ["10B Visits"] = "rbxassetid://122165086598560",
        ["AK-47"] = "rbxassetid://17691132793",
        ["AKEY-47"] = "rbxassetid://80017496220683",
        ["Augmented Rifle"] = "rbxassetid://18770192853",
        ["Boneclaw Rifle"] = "rbxassetid://100015754284323",
        ["Drum Gun"] = "rbxassetid://111251887761435",
        ["Gingerbread Augmented Rifle"] = "rbxassetid://85584922619813",
        ["Glorious Assault Rifle"] = "rbxassetid://130669996688265",
        ["Pearl Rifle"] = "rbxassetid://135277426561503",
        ["Phoenix Rifle"] = "rbxassetid://140228738718621",
    },
    ["Battle Axe"] = {
        ["Standard"] = "rbxassetid://93390542043222",
        ["Balloon Axe"] = "rbxassetid://102429983628211",
        ["Ban Axe"] = "rbxassetid://111046431576859",
        ["Cerulean Axe"] = "rbxassetid://76353832683350",
        ["Glorious Battle Axe"] = "rbxassetid://87227212476138",
        ["Keyttle Axe"] = "rbxassetid://122117068984402",
        ["Mimic Axe"] = "rbxassetid://111717370450373",
        ["Nordic Axe"] = "rbxassetid://80052264197135",
        ["Street Sign"] = "rbxassetid://121743888148209",
        ["The Shred"] = "rbxassetid://71234381808727",
        ["Tiki Axe"] = "rbxassetid://87247443182820",
    },
    ["Bow"] = {
        ["Standard"] = "rbxassetid://17160802080",
        ["Balloon Bow"] = "rbxassetid://128957010941029",
        ["Bat Bow"] = "rbxassetid://108984987378619",
        ["Beloved Bow"] = "rbxassetid://110219131386799",
        ["Compound Bow"] = "rbxassetid://17672234242",
        ["Dream Bow"] = "rbxassetid://101089313144218",
        ["Frostbite Bow"] = "rbxassetid://121895626623160",
        ["Glorious Bow"] = "rbxassetid://84201415206621",
        ["Key Bow"] = "rbxassetid://122525140091212",
        ["Palm Bow"] = "rbxassetid://82899577710787",
        ["Raven Bow"] = "rbxassetid://18766861627",
    },
    ["Burst Rifle"] = {
        ["Standard"] = "rbxassetid://17160801983",
        ["Aqua Burst"] = "rbxassetid://18837670807",
        ["Bullpup Burst"] = "rbxassetid://74974560606812",
        ["Electro Rifle"] = "rbxassetid://132227459821018",
        ["Glorious Burst Rifle"] = "rbxassetid://78517330608597",
        ["Keyst Rifle"] = "rbxassetid://78377522426003",
        ["Pine Burst"] = "rbxassetid://132753732294083",
        ["Pixel Burst"] = "rbxassetid://102648809593259",
        ["Sand Bullpup Burst"] = "rbxassetid://130731663986683",
        ["Spectral Burst"] = "rbxassetid://135012309412679",
    },
    ["Chainsaw"] = {
        ["Standard"] = "rbxassetid://17160801873",
        ["Blobsaw"] = "rbxassetid://17825963589",
        ["Buzzsaw"] = "rbxassetid://74057448201836",
        ["Festive Buzzsaw"] = "rbxassetid://80811854818775",
        ["Glorious Chainsaw"] = "rbxassetid://122622447397834",
        ["Handsaws"] = "rbxassetid://18766864583",
        ["Mega Drill"] = "rbxassetid://76663867023998",
        ["Sharksaw"] = "rbxassetid://136881251000627",
    },
    ["Crossbow"] = {
        ["Standard"] = "rbxassetid://140211832612284",
        ["Arch Crossbow"] = "rbxassetid://94981733362451",
        ["Campfire Crossbow"] = "rbxassetid://76911697867059",
        ["Crossbone"] = "rbxassetid://103469183638638",
        ["Frostbite Crossbow"] = "rbxassetid://101536997945363",
        ["Glorious Crossbow"] = "rbxassetid://70875146419725",
        ["Harpoon Crossbow"] = "rbxassetid://107460405492001",
        ["Pixel Crossbow"] = "rbxassetid://115931961841903",
        ["Violin Crossbow"] = "rbxassetid://74401302514014",
    },
    ["Daggers"] = {
        ["Standard"] = "rbxassetid://91885384580845",
        ["Aces"] = "rbxassetid://139089881483398",
        ["Bat Daggers"] = "rbxassetid://92001964015225",
        ["Broken Hearts"] = "rbxassetid://74156924296351",
        ["Cookies"] = "rbxassetid://114482325531769",
        ["Crystal Daggers"] = "rbxassetid://126221748659600",
        ["Glorious Daggers"] = "rbxassetid://76023189104485",
        ["Keynais"] = "rbxassetid://84562761142610",
        ["Paper Planes"] = "rbxassetid://84003122595879",
        ["Shurikens"] = "rbxassetid://135574097643275",
        ["Starfish"] = "rbxassetid://114567820096083",
        ["Toaster"] = "rbxassetid://103344379002564",
    },
    ["Distortion"] = {
        ["Standard"] = "rbxassetid://115712150398379",
        ["Bubble Distortion"] = "rbxassetid://73319804282513",
        ["Cyber Distortion"] = "rbxassetid://88995062151276",
        ["Electropunk Distortion"] = "rbxassetid://109544539643046",
        ["Experiment D15"] = "rbxassetid://103446773933340",
        ["Glorious Distortion"] = "rbxassetid://134722661973710",
        ["Magma Distortion"] = "rbxassetid://81103807698156",
        ["Plasma Distortion"] = "rbxassetid://126813935337091",
        ["Sleighstortion"] = "rbxassetid://111242141481650",
    },
    ["Energy Pistols"] = {
        ["Standard"] = "rbxassetid://79471670126710",
        ["Apex Pistols"] = "rbxassetid://136156057859453",
        ["Enerkey Pistols"] = "rbxassetid://132955794587057",
        ["Glorious Energy Pistols"] = "rbxassetid://114418789647547",
        ["Hacker Pistols"] = "rbxassetid://140621407555872",
        ["Hydro Pistols"] = "rbxassetid://115281889984097",
        ["Hyperlaser Guns"] = "rbxassetid://106947526362970",
        ["New Year Energy Pistols"] = "rbxassetid://126589959779039",
        ["Sol Pistols"] = "rbxassetid://115012735954576",
        ["Soul Pistols"] = "rbxassetid://72213738067158",
        ["Void Pistols"] = "rbxassetid://111278471262300",
    },
    ["Energy Rifle"] = {
        ["Standard"] = "rbxassetid://110259279810005",
        ["Apex Rifle"] = "rbxassetid://88144772234151",
        ["Enerkey Rifle"] = "rbxassetid://80940171527853",
        ["Glorious Energy Rifle"] = "rbxassetid://72632815443247",
        ["Hacker Rifle"] = "rbxassetid://122816271917525",
        ["Hydro Rifle"] = "rbxassetid://73690448730060",
        ["New Year Energy Rifle"] = "rbxassetid://111446782522703",
        ["Sol Rifle"] = "rbxassetid://96272849525291",
        ["Soul Rifle"] = "rbxassetid://129351366788323",
        ["Void Rifle"] = "rbxassetid://95985016411441",
    },
    ["Exogun"] = {
        ["Standard"] = "rbxassetid://17344796376",
        ["Exogourd"] = "rbxassetid://137140750597688",
        ["Glorious Exogun"] = "rbxassetid://129125201034206",
        ["Midnight Festive Exogun"] = "rbxassetid://127612442529810",
        ["Pearl Exogun"] = "rbxassetid://77698515863000",
        ["Ray Gun"] = "rbxassetid://18766861454",
        ["Repulsor"] = "rbxassetid://109263387714628",
        ["Singularity"] = "rbxassetid://17676876756",
        ["Wondergun"] = "rbxassetid://17672060360",
    },
    ["Fists"] = {
        ["Standard"] = "rbxassetid://17160801745",
        ["Boxing Gloves"] = "rbxassetid://17672060486",
        ["Brass Knuckles"] = "rbxassetid://106879679389340",
        ["Crab Claws"] = "rbxassetid://127492118111080",
        ["Festive Fists"] = "rbxassetid://102757458529795",
        ["Fist"] = "rbxassetid://109585706680035",
        ["Fists of Hurt"] = "rbxassetid://140103672289959",
        ["Glorious Fists"] = "rbxassetid://112839297231399",
        ["Pirate Hook"] = "rbxassetid://116717593932616",
        ["Pumpkin Claws"] = "rbxassetid://90996407819750",
        ["Spy Gloves"] = "rbxassetid://117198095640784",
    },
    ["Flamethrower"] = {
        ["Standard"] = "rbxassetid://89455038280473",
        ["Bubblethrower"] = "rbxassetid://76812523297712",
        ["Extinguisher"] = "rbxassetid://95815875434568",
        ["Glitterthrower"] = "rbxassetid://88920581735649",
        ["Glorious Flamethrower"] = "rbxassetid://71676635953177",
        ["Jack O'Thrower"] = "rbxassetid://140280020818514",
        ["Keythrower"] = "rbxassetid://130308634220965",
        ["Lamethrower"] = "rbxassetid://18766862822",
        ["Pixel Flamethrower"] = "rbxassetid://17771752104",
        ["Rainbowthrower"] = "rbxassetid://102070206928252",
        ["Snowblower"] = "rbxassetid://128743586418880",
    },
    ["Flare Gun"] = {
        ["Standard"] = "rbxassetid://17160801627",
        ["Banana Flare"] = "rbxassetid://123589213761955",
        ["Dynamite Gun"] = "rbxassetid://18766865384",
        ["Firework Gun"] = "rbxassetid://17691132917",
        ["Glorious Flare Gun"] = "rbxassetid://115324763672074",
        ["Pocket Volcano"] = "rbxassetid://133260045254190",
        ["Vexed Flare Gun"] = "rbxassetid://116287930550049",
        ["Wrapped Flare Gun"] = "rbxassetid://135638020129378",
    },
    ["Flashbang"] = {
        ["Standard"] = "rbxassetid://17160801529",
        ["Camera"] = "rbxassetid://18766865640",
        ["Disco Ball"] = "rbxassetid://17672061796",
        ["Glorious Flashbang"] = "rbxassetid://96760506528185",
        ["Lightbulb"] = "rbxassetid://125489177573287",
        ["Pixel Flashbang"] = "rbxassetid://132815625474597",
        ["Shining Star"] = "rbxassetid://108392227354212",
        ["Skullbang"] = "rbxassetid://73796957224972",
        ["Sol"] = "rbxassetid://124026864365877",
    },
    ["Freeze Ray"] = {
        ["Standard"] = "rbxassetid://18429552328",
        ["Bubble Ray"] = "rbxassetid://18766865819",
        ["Cooler"] = "rbxassetid://117258208589940",
        ["Glorious Freeze Ray"] = "rbxassetid://120211873831101",
        ["Gum Ray"] = "rbxassetid://121504417727123",
        ["Spider Ray"] = "rbxassetid://136838810668332",
        ["Temporal Ray"] = "rbxassetid://18429552503",
        ["Wrapped Freeze Ray"] = "rbxassetid://76183738050112",
    },
    ["Grappler"] = {
        ["Standard"] = "rbxassetid://103255844976245",
        ["Arcade Claw"] = "rbxassetid://81529455948004",
        ["Fishing Rod"] = "rbxassetid://86648406311812",
        ["Genie Lamp"] = "rbxassetid://118514051859760",
        ["Glorious Grappler"] = "rbxassetid://113576961532090",
        ["Lasso"] = "rbxassetid://77061966583531",
        ["Lifeguard Grappler"] = "rbxassetid://91214316625102",
    },
    ["Grenade"] = {
        ["Standard"] = "rbxassetid://17160801411",
        ["Cuddle Bomb"] = "rbxassetid://116801887274189",
        ["Dynamite"] = "rbxassetid://119066463640901",
        ["Fizz Bomb"] = "rbxassetid://123256093694497",
        ["Frozen Grenade"] = "rbxassetid://96120996159611",
        ["Glorious Grenade"] = "rbxassetid://103034870490455",
        ["Jingle Grenade"] = "rbxassetid://97646859596860",
        ["Keynade"] = "rbxassetid://102785971311114",
        ["Soul Grenade"] = "rbxassetid://85903097459179",
        ["Water Balloon"] = "rbxassetid://18766859819",
        ["Whoopee Cushion"] = "rbxassetid://17672062933",
    },
    ["Grenade Launcher"] = {
        ["Standard"] = "rbxassetid://17250453814",
        ["Balloon Launcher"] = "rbxassetid://137862701599991",
        ["Coconut Launcher"] = "rbxassetid://77621998397460",
        ["Gearnade Launcher"] = "rbxassetid://133756750612042",
        ["Glorious Grenade Launcher"] = "rbxassetid://134130354519919",
        ["Skull Launcher"] = "rbxassetid://103257281022910",
        ["Snowball Launcher"] = "rbxassetid://112349955391111",
        ["Swashbuckler"] = "rbxassetid://17821233828",
        ["Uranium Launcher"] = "rbxassetid://18766860114",
    },
    ["Gunblade"] = {
        ["Standard"] = "rbxassetid://131231034374465",
        ["Boneblade"] = "rbxassetid://126327381608481",
        ["Crude Gunblade"] = "rbxassetid://126996645502136",
        ["Elf's Gunblade"] = "rbxassetid://114103306647123",
        ["Glorious Gunblade"] = "rbxassetid://88003799126136",
        ["Gunsaw"] = "rbxassetid://102700915422689",
        ["Hyper Gunblade"] = "rbxassetid://134415898983004",
        ["Keyblade"] = "rbxassetid://117153249348040",
        ["Sharkbite"] = "rbxassetid://85479471132931",
    },
    ["Handgun"] = {
        ["Standard"] = "rbxassetid://17160801282",
        ["Blaster"] = "rbxassetid://17821234554",
        ["Gingerbread Handgun"] = "rbxassetid://95881238590412",
        ["Glorious Handgun"] = "rbxassetid://85129427786041",
        ["Gumball Handgun"] = "rbxassetid://106890990556815",
        ["Hand Gun"] = "rbxassetid://18837670624",
        ["Pixel Handgun"] = "rbxassetid://82199841278177",
        ["Pumpkin Handgun"] = "rbxassetid://88495685924653",
        ["Sandgun"] = "rbxassetid://111746039012812",
        ["Stealth Handgun"] = "rbxassetid://124919185835138",
        ["Towerstone Handgun"] = "rbxassetid://88654252790032",
        ["Warp Handgun"] = "rbxassetid://102974911528828",
    },
    ["Jump Pad"] = {
        ["Standard"] = "rbxassetid://79459600453621",
        ["Bounce House"] = "rbxassetid://71226436012588",
        ["Flamingo Floatie"] = "rbxassetid://127511599700842",
        ["Glorious Jump Pad"] = "rbxassetid://71803398862947",
        ["Jolly Man"] = "rbxassetid://97375473537804",
        ["Shady Chicken Sandwich"] = "rbxassetid://86361684164972",
        ["Spider Web"] = "rbxassetid://84204578032332",
        ["Trampoline"] = "rbxassetid://103567857194140",
    },
    ["Katana"] = {
        ["Standard"] = "rbxassetid://17160801158",
        ["Arch Katana"] = "rbxassetid://94679283541658",
        ["Crystal Katana"] = "rbxassetid://88872493010693",
        ["Cutlass"] = "rbxassetid://77773371747122",
        ["Evil Trident"] = "rbxassetid://101234805269080",
        ["Glorious Katana"] = "rbxassetid://75588958786035",
        ["Keytana"] = "rbxassetid://118899310989170",
        ["Lightning Bolt"] = "rbxassetid://18768968241",
        ["Linked Sword"] = "rbxassetid://83575725004177",
        ["New Year Katana"] = "rbxassetid://102866488046710",
        ["Pixel Katana"] = "rbxassetid://127922483074145",
        ["Riptide Katana"] = "rbxassetid://136245206320139",
        ["Saber"] = "rbxassetid://17672062341",
        ["Stellar Katana"] = "rbxassetid://72617738655198",
        ["Swordfish"] = "rbxassetid://105748422389590",
    },
    ["Knife"] = {
        ["Standard"] = "rbxassetid://17160800983",
        ["Armature.001"] = "rbxassetid://104026327618871",
        ["Balisong"] = "rbxassetid://93303458333011",
        ["Birthday Candle"] = "rbxassetid://74148583096733",
        ["Caladbolg"] = "rbxassetid://101180142582964",
        ["Candy Cane"] = "rbxassetid://124021545052910",
        ["Chancla"] = "rbxassetid://17672060795",
        ["Glorious Knife"] = "rbxassetid://77448895595314",
        ["Karambit"] = "rbxassetid://18766863586",
        ["Keylisong"] = "rbxassetid://100084654831857",
        ["Keyrambit"] = "rbxassetid://108512337101248",
        ["Machete"] = "rbxassetid://84364955819899",
        ["Pencil"] = "rbxassetid://131450909376802",
        ["Shark Tooth"] = "rbxassetid://124265657652842",
        ["Trophy Knife"] = "rbxassetid://78822531823097",
    },
    ["Maul"] = {
        ["Standard"] = "rbxassetid://81478141693597",
        ["Ban Hammer"] = "rbxassetid://126491383967029",
        ["Clown Hammer"] = "rbxassetid://95487416883384",
        ["Excalibur"] = "rbxassetid://81905348145140",
        ["Giant Popsicle"] = "rbxassetid://91916939347642",
        ["Glorious Maul"] = "rbxassetid://125917253783002",
        ["Ice Maul"] = "rbxassetid://100001888078290",
        ["Sleigh Maul"] = "rbxassetid://114892026951995",
        ["Starforge Maul"] = "rbxassetid://113691709735527",
    },
    ["Medkit"] = {
        ["Standard"] = "rbxassetid://17160800734",
        ["Box of Chocolates"] = "rbxassetid://132421415091712",
        ["Briefcase"] = "rbxassetid://18142172067",
        ["Bucket of Candy"] = "rbxassetid://93791981490691",
        ["Glorious Medkit"] = "rbxassetid://73358160718523",
        ["Ice Cream"] = "rbxassetid://131246559128209",
        ["Laptop"] = "rbxassetid://18770164868",
        ["Medkitty"] = "rbxassetid://125732280509514",
        ["Milk & Cookies"] = "rbxassetid://99156135330432",
        ["Sandwich"] = "rbxassetid://17838232333",
    },
    ["Minigun"] = {
        ["Standard"] = "rbxassetid://17250458611",
        ["Fighter Jet"] = "rbxassetid://70780739230558",
        ["Glorious Minigun"] = "rbxassetid://84246894288637",
        ["Lasergun 3000"] = "rbxassetid://103437974285778",
        ["Pixel Minigun"] = "rbxassetid://18766861798",
        ["Pumpkin Minigun"] = "rbxassetid://77388785880854",
        ["Shark Minigun"] = "rbxassetid://89295703576175",
        ["Wrapped Minigun"] = "rbxassetid://127077702465909",
    },
    ["Molotov"] = {
        ["Standard"] = "rbxassetid://109264750627289",
        ["Arch Molotov"] = "rbxassetid://96589300342777",
        ["Campfire Stick"] = "rbxassetid://83823494489693",
        ["Coffee"] = "rbxassetid://17672061538",
        ["Glorious Molotov"] = "rbxassetid://108930340066987",
        ["Hot Coals"] = "rbxassetid://110423024723304",
        ["Lava Lamp"] = "rbxassetid://79616583726432",
        ["Ship In A Bottle"] = "rbxassetid://125699268308415",
        ["Torch"] = "rbxassetid://115586189235552",
        ["Vexed Candle"] = "rbxassetid://78128648928195",
    },
    ["Paintball Gun"] = {
        ["Standard"] = "rbxassetid://17160853798",
        ["Boba Gun"] = "rbxassetid://18768830660",
        ["Brain Gun"] = "rbxassetid://85970592668118",
        ["Glorious Paintball Gun"] = "rbxassetid://86297318955856",
        ["Ketchup Gun"] = "rbxassetid://76083615050939",
        ["Lemonade Gun"] = "rbxassetid://119390099120478",
        ["Paintballoon Gun"] = "rbxassetid://100129918948246",
        ["Slime Gun"] = "rbxassetid://17672062472",
        ["Snowball Gun"] = "rbxassetid://113685354916533",
    },
    ["Permafrost"] = {
        ["Standard"] = "rbxassetid://74353733133888",
        ["Glorious Permafrost"] = "rbxassetid://119977291442329",
        ["Ice Permafrost"] = "rbxassetid://83722160119335",
        ["Permafrost.rbxm"] = "rbxassetid://77732280270853",
        ["Permasand"] = "rbxassetid://108398272946629",
        ["Snowman Permafrost"] = "rbxassetid://100890626643184",
        ["Starforge Permafrost"] = "rbxassetid://105290041968367",
        ["Temporal Permafrost"] = "rbxassetid://124975247676715",
    },
    ["RPG"] = {
        ["Standard"] = "rbxassetid://17160802243",
        ["Cupcake Launcher"] = "rbxassetid://100541838356180",
        ["Firework Launcher"] = "rbxassetid://75233372670156",
        ["Glorious RPG"] = "rbxassetid://130506879885802",
        ["Nuke Launcher"] = "rbxassetid://17672061995",
        ["Pencil Launcher"] = "rbxassetid://106934516693548",
        ["Pumpkin Launcher"] = "rbxassetid://94648176067808",
        ["Rocket Launcher"] = "rbxassetid://116931956715309",
        ["RPKEY"] = "rbxassetid://108438721125410",
        ["Spaceship Launcher"] = "rbxassetid://18766860860",
        ["Squid Launcher"] = "rbxassetid://130764310743404",
        ["Sundae Launcher"] = "rbxassetid://70578055340962",
    },
    ["Revolver"] = {
        ["Standard"] = "rbxassetid://17160800299",
        ["Boneclaw Revolver"] = "rbxassetid://119174697609264",
        ["Cruise Revolver"] = "rbxassetid://72223124823807",
        ["Desert Eagle"] = "rbxassetid://17821234372",
        ["Glorious Revolver"] = "rbxassetid://118135542031794",
        ["Keyvolver"] = "rbxassetid://87974031410344",
        ["Peppergun"] = "rbxassetid://124178691056979",
        ["Peppermint Sheriff"] = "rbxassetid://95859403750768",
        ["Sheriff"] = "rbxassetid://18770192507",
    },
    ["Riot Shield"] = {
        ["Standard"] = "rbxassetid://121172272442833",
        ["Broken Surfboard"] = "rbxassetid://114987869792187",
        ["Door"] = "rbxassetid://79242603995428",
        ["Energy Shield"] = "rbxassetid://90215439337413",
        ["Glorious Riot Shield"] = "rbxassetid://132866851386509",
        ["Masterpiece"] = "rbxassetid://79914271483818",
        ["Sled"] = "rbxassetid://73881731607231",
        ["Tombstone Shield"] = "rbxassetid://125895528641243",
    },
    ["Satchel"] = {
        ["Standard"] = "rbxassetid://82237471151891",
        ["Advanced Satchel"] = "rbxassetid://113860326910548",
        ["Bag o' Money"] = "rbxassetid://129192426700659",
        ["Glorious Satchel"] = "rbxassetid://100521994805910",
        ["Lifeguard Satchel"] = "rbxassetid://105277357472003",
        ["Notebook Satchel"] = "rbxassetid://124817464748150",
        ["Pizza Box"] = "rbxassetid://99166555665247",
        ["Potion Satchel"] = "rbxassetid://76787046046890",
        ["Suspicious Gift"] = "rbxassetid://76209303162814",
    },
    ["Scythe"] = {
        ["Standard"] = "rbxassetid://17160800186",
        ["Anchor"] = "rbxassetid://18766866743",
        ["Bat Scythe"] = "rbxassetid://131711174838548",
        ["Bug Net"] = "rbxassetid://115620701626004",
        ["Cryo Scythe"] = "rbxassetid://119930754357379",
        ["Crystal Scythe"] = "rbxassetid://73971549402646",
        ["Glorious Scythe"] = "rbxassetid://115811939422419",
        ["Keythe"] = "rbxassetid://114560926055433",
        ["Palm Scythe"] = "rbxassetid://97379805071194",
        ["Plastic Flamingo"] = "rbxassetid://112023194890462",
        ["Sakura Scythe"] = "rbxassetid://133811689655966",
        ["Scythe of Death"] = "rbxassetid://17825996537",
    },
    ["Shorty"] = {
        ["Standard"] = "rbxassetid://17160800091",
        ["Balloon Shorty"] = "rbxassetid://75590262133322",
        ["Bubble Shorty"] = "rbxassetid://111294137896866",
        ["Cannon Shorty"] = "rbxassetid://137616738436928",
        ["Demon Shorty"] = "rbxassetid://116443498278384",
        ["Glorious Shorty"] = "rbxassetid://105834197552222",
        ["Lovely Shorty"] = "rbxassetid://18766862000",
        ["Not So Shorty"] = "rbxassetid://17672062572",
        ["Too Shorty"] = "rbxassetid://18129531276",
        ["Wrapped Shorty"] = "rbxassetid://136522183669611",
    },
    ["Shotgun"] = {
        ["Standard"] = "rbxassetid://17160800007",
        ["Balloon Shotgun"] = "rbxassetid://17821234823",
        ["Broomstick"] = "rbxassetid://118061559757082",
        ["Cactus Shotgun"] = "rbxassetid://131606483507460",
        ["Glorious Shotgun"] = "rbxassetid://71704618059601",
        ["Hyper Shotgun"] = "rbxassetid://18768968419",
        ["Shark Shotgun"] = "rbxassetid://116415689080224",
        ["Shotkey"] = "rbxassetid://93004214983981",
        ["Wrapped Shotgun"] = "rbxassetid://74894345245237",
    },
    ["Slingshot"] = {
        ["Standard"] = "rbxassetid://17160799888",
        ["Boneshot"] = "rbxassetid://86606957688341",
        ["Glorious Slingshot"] = "rbxassetid://101195664167288",
        ["Goalpost"] = "rbxassetid://17672063165",
        ["Harp"] = "rbxassetid://80850043664453",
        ["Keyshot"] = "rbxassetid://74006265601388",
        ["Lucky Horseshoe"] = "rbxassetid://131242126669282",
        ["Palmshot"] = "rbxassetid://109640024736812",
        ["Reindeer Slingshot"] = "rbxassetid://121612921203624",
        ["Stick"] = "rbxassetid://17672063048",
    },
    ["Smoke Grenade"] = {
        ["Standard"] = "rbxassetid://17160799767",
        ["Balance"] = "rbxassetid://18766866168",
        ["Beach Ball"] = "rbxassetid://98068366944697",
        ["Emoji Cloud"] = "rbxassetid://17821234077",
        ["Eyeball"] = "rbxassetid://135911399763146",
        ["Glorious Smoke Grenade"] = "rbxassetid://139714146508398",
        ["Hourglass"] = "rbxassetid://108311418974073",
        ["Snowglobe"] = "rbxassetid://119390465944051",
    },
    ["Sniper"] = {
        ["Standard"] = "rbxassetid://17160799574",
        ["Campfire Sniper"] = "rbxassetid://127790438907599",
        ["Event Horizon"] = "rbxassetid://80749667426815",
        ["Eyething Sniper"] = "rbxassetid://103915302076013",
        ["Gingerbread Sniper"] = "rbxassetid://99943841952995",
        ["Glorious Sniper"] = "rbxassetid://118012090175286",
        ["Hyper Sniper"] = "rbxassetid://18766864081",
        ["Keyper"] = "rbxassetid://85472935605264",
        ["Kraken Sniper"] = "rbxassetid://95011666797584",
        ["Light Fifty"] = "rbxassetid://138029440298487",
        ["Pixel Sniper"] = "rbxassetid://17676081196",
    },
    ["Spear"] = {
        ["Standard"] = "rbxassetid://122801133017271",
        ["Chark Kebab"] = "rbxassetid://74005839754537",
        ["Fork"] = "rbxassetid://105821360943308",
        ["Giant Pencil"] = "rbxassetid://107812045486260",
        ["Glorious Spear"] = "rbxassetid://98259628954838",
        ["Plunger"] = "rbxassetid://82393330699241",
        ["Studio Light"] = "rbxassetid://70443632958263",
        ["Thunderpike"] = "rbxassetid://137630900832105",
    },
    ["Spray"] = {
        ["Standard"] = "rbxassetid://92882887485248",
        ["Boneclaw Spray"] = "rbxassetid://114078818081911",
        ["Campfire Spray"] = "rbxassetid://129294699009828",
        ["Glorious Spray"] = "rbxassetid://138246745001490",
        ["Key Spray"] = "rbxassetid://94061940442700",
        ["Lovely Spray"] = "rbxassetid://131203015026683",
        ["Nail Gun"] = "rbxassetid://110577809934251",
        ["Pine Spray"] = "rbxassetid://128285758736343",
        ["Spray Bottle"] = "rbxassetid://137955019285700",
    },
    ["Subspace Tripmine"] = {
        ["Standard"] = "rbxassetid://17160799418",
        ["Dev-in-the-Box"] = "rbxassetid://125056115146240",
        ["DIY Tripmine"] = "rbxassetid://85747991601740",
        ["Don't Press"] = "rbxassetid://17821233203",
        ["Glorious Subspace Tripmine"] = "rbxassetid://112555928142930",
        ["Hazard Sign"] = "rbxassetid://73264353773454",
        ["Pot o' Keys"] = "rbxassetid://125355191847719",
        ["Spring"] = "rbxassetid://18766860615",
        ["Trick or Treat"] = "rbxassetid://101693036028491",
    },
    ["Trowel"] = {
        ["Standard"] = "rbxassetid://17160799172",
        ["Garden Shovel"] = "rbxassetid://18766864873",
        ["Glorious Trowel"] = "rbxassetid://100888500368219",
        ["Paintbrush"] = "rbxassetid://84687920829755",
        ["Plastic Shovel"] = "rbxassetid://17672062201",
        ["Pumpkin Carver"] = "rbxassetid://78827307308671",
        ["Scooper"] = "rbxassetid://100816728062854",
        ["Snow Shovel"] = "rbxassetid://78271338778848",
    },
    ["Uzi"] = {
        ["Standard"] = "rbxassetid://17160798908",
        ["Arch Uzi"] = "rbxassetid://139852585731073",
        ["Demon Uzi"] = "rbxassetid://132973040482576",
        ["Ducky Uzi"] = "rbxassetid://133780419950894",
        ["Electro Uzi"] = "rbxassetid://96806694653207",
        ["Glorious Uzi"] = "rbxassetid://120045334159124",
        ["Keyzi"] = "rbxassetid://100392703246534",
        ["Money Gun"] = "rbxassetid://100705725115757",
        ["Pine Uzi"] = "rbxassetid://82545206964916",
        ["Water Uzi"] = "rbxassetid://17821233590",
    },
    ["War Horn"] = {
        ["Standard"] = "rbxassetid://104600246515190",
        ["Air Horn"] = "rbxassetid://111168146142976",
        ["Boneclaw Horn"] = "rbxassetid://138360812591331",
        ["Glorious War Horn"] = "rbxassetid://96293355496772",
        ["Lifeguard Whistle"] = "rbxassetid://93791958663348",
        ["Mammoth Horn"] = "rbxassetid://93076834584542",
        ["Megaphone"] = "rbxassetid://107074211847347",
        ["Trumpet"] = "rbxassetid://88975601634708",
    },
    ["Warper"] = {
        ["Standard"] = "rbxassetid://88033795039891",
        ["Arcane Warper"] = "rbxassetid://83632373572638",
        ["Bubbler"] = "rbxassetid://106002684466857",
        ["Electropunk Warper"] = "rbxassetid://75386728379756",
        ["Experiment W4"] = "rbxassetid://126884960764998",
        ["Frost Warper"] = "rbxassetid://70539216094396",
        ["Glitter Warper"] = "rbxassetid://94607497565715",
        ["Glorious Warper"] = "rbxassetid://95823647035211",
        ["Hotel Bell"] = "rbxassetid://117742703173821",
    },
    ["Warpstone"] = {
        ["Standard"] = "rbxassetid://94035693279005",
        ["Cyber Warpstone"] = "rbxassetid://133002984228937",
        ["Electropunk Warpstone"] = "rbxassetid://75299042976369",
        ["Glorious Warpstone"] = "rbxassetid://137583560042806",
        ["Teleport Disc"] = "rbxassetid://104608154111107",
        ["Unstable Warpstone"] = "rbxassetid://110083777654388",
        ["Warp Juice"] = "rbxassetid://74381576761026",
        ["Warpbone"] = "rbxassetid://96452209607150",
        ["Warpeye"] = "rbxassetid://127023603234857",
        ["Warpstar"] = "rbxassetid://102652397897598",
    },
    ["Wildcat"] = {
        ["Standard"] = "rbxassetid://77401164737509",
        ["Glorious Wildcat"] = "rbxassetid://115657943825380",
        ["Plasma Wildcat"] = "rbxassetid://86238922896100",
    },
}

local STANDARD_ICON_MAP = {
    ["rbxassetid://17160682738"] = "Assault Rifle",
    ["rbxassetid://93390542043222"] = "Battle Axe",
    ["rbxassetid://17160802080"] = "Bow",
    ["rbxassetid://17160801983"] = "Burst Rifle",
    ["rbxassetid://17160801873"] = "Chainsaw",
    ["rbxassetid://140211832612284"] = "Crossbow",
    ["rbxassetid://91885384580845"] = "Daggers",
    ["rbxassetid://115712150398379"] = "Distortion",
    ["rbxassetid://79471670126710"] = "Energy Pistols",
    ["rbxassetid://110259279810005"] = "Energy Rifle",
    ["rbxassetid://17344796376"] = "Exogun",
    ["rbxassetid://17160801745"] = "Fists",
    ["rbxassetid://89455038280473"] = "Flamethrower",
    ["rbxassetid://17160801627"] = "Flare Gun",
    ["rbxassetid://17160801529"] = "Flashbang",
    ["rbxassetid://18429552328"] = "Freeze Ray",
    ["rbxassetid://103255844976245"] = "Grappler",
    ["rbxassetid://17160801411"] = "Grenade",
    ["rbxassetid://17250453814"] = "Grenade Launcher",
    ["rbxassetid://131231034374465"] = "Gunblade",
    ["rbxassetid://17160801282"] = "Handgun",
    ["rbxassetid://79459600453621"] = "Jump Pad",
    ["rbxassetid://17160801158"] = "Katana",
    ["rbxassetid://17160800983"] = "Knife",
    ["rbxassetid://81478141693597"] = "Maul",
    ["rbxassetid://17160800734"] = "Medkit",
    ["rbxassetid://17250458611"] = "Minigun",
    ["rbxassetid://109264750627289"] = "Molotov",
    ["rbxassetid://17160853798"] = "Paintball Gun",
    ["rbxassetid://74353733133888"] = "Permafrost",
    ["rbxassetid://17160802243"] = "RPG",
    ["rbxassetid://17160800299"] = "Revolver",
    ["rbxassetid://121172272442833"] = "Riot Shield",
    ["rbxassetid://82237471151891"] = "Satchel",
    ["rbxassetid://17160800186"] = "Scythe",
    ["rbxassetid://17160800091"] = "Shorty",
    ["rbxassetid://17160800007"] = "Shotgun",
    ["rbxassetid://17160799888"] = "Slingshot",
    ["rbxassetid://17160799767"] = "Smoke Grenade",
    ["rbxassetid://17160799574"] = "Sniper",
    ["rbxassetid://122801133017271"] = "Spear",
    ["rbxassetid://92882887485248"] = "Spray",
    ["rbxassetid://17160799418"] = "Subspace Tripmine",
    ["rbxassetid://17160799172"] = "Trowel",
    ["rbxassetid://17160798908"] = "Uzi",
    ["rbxassetid://104600246515190"] = "War Horn",
    ["rbxassetid://88033795039891"] = "Warper",
    ["rbxassetid://94035693279005"] = "Warpstone",
    ["rbxassetid://77401164737509"] = "Wildcat",
}

-- Skin models
local EXACT_SKIN_MAP = {
    ["AKEY-47"] = {folder = "Bundles", name = "AKEY-47"},
    ["Key Bow"] = {folder = "Bundles", name = "Key Bow"},
    ["Key Spray"] = {folder = "Bundles", name = "Key Spray"},
    ["Keylisong"] = {folder = "Bundles", name = "Keylisong"},
    ["Keynade"] = {folder = "Bundles", name = "Keynade"},
    ["Keynais"] = {folder = "Bundles", name = "Keynais"},
    ["Keyper"] = {folder = "Bundles", name = "Keyper"},
    ["Keyst Rifle"] = {folder = "Bundles", name = "Keyst Rifle"},
    ["Keythe"] = {folder = "Bundles", name = "Keythe"},
    ["Keythrower"] = {folder = "Bundles", name = "Keythrower"},
    ["Keyttle Axe"] = {folder = "Bundles", name = "Keyttle Axe"},
    ["RPKEY"] = {folder = "Bundles", name = "RPKEY"},
    ["Keyshot"] = {folder = "Bundles", name = "Keyshot"},
    ["Keyblade"] = {folder = "Bundles", name = "Keyblade"},
    ["Keyvolver"] = {folder = "Bundles", name = "Keyvolver"},
    ["Shotkey"] = {folder = "Bundles", name = "Shotkey"},
    ["Keyzi"] = {folder = "Bundles", name = "Keyzi"},
    ["Keytana"] = {folder = "Bundles", name = "Keytana"},
    ["Pot o' Keys"] = {folder = "Bundles", name = "Pot o' Keys"},
    ["Cuddle Bomb"] = {folder = "Bundles", name = "Cuddle Bomb"},
    ["Ban Hammer"] = {folder = "Bundles", name = "Ban Hammer"},
    ["10B Visits"] = {folder = "Bundles", name = "10B Visits"},
    ["Arch Crossbow"] = {folder = "Seasons", name = "Arch Crossbow"},
    ["Arch Katana"] = {folder = "Seasons", name = "Arch Katana"},
    ["Arch Uzi"] = {folder = "Seasons", name = "Arch Uzi"},
    ["Arch Molotov"] = {folder = "Seasons", name = "Arch Molotov"},
    ["Handsaws"] = {folder = "Skin Case 2", name = "Handsaws"},
    ["Void Pistols"] = {folder = "Skin Case 2", name = "Void Pistols"},
    ["Laptop"] = {folder = "Skin Case 2", name = "Laptop"},
    ["Camera"] = {folder = "Skin Case 2", name = "Camera"},
    ["Uranium Launcher"] = {folder = "Skin Case 2", name = "Uranium Launcher"},
    ["AUG"] = {folder = "Skin Case 2", name = "AUG"},
    ["Void Rifle"] = {folder = "Skin Case 3", name = "Void Rifle"},
    ["Event Horizon"] = {folder = "Skin Case 3", name = "Event Horizon"},
    ["Fighter Jet"] = {folder = "Skin Case 3", name = "Fighter Jet"},
    ["Balloon Shorty"] = {folder = "Skin Case 3", name = "Balloon Shorty"},
    ["Masterpiece"] = {folder = "Skin Case 3", name = "Masterpiece"},
    ["Paintbrush"] = {folder = "Skin Case 3", name = "Paintbrush"},
    ["Shady Chicken Sandwich"] = {folder = "Skin Case 3", name = "Shady Chicken Sandwich"},
    ["Banana Flare"] = {folder = "Skin Case 3", name = "Banana Flare"},
    ["Squid Flare"] = {folder = "Skin Case 3", name = "Banana Flare"},
    ["Boneclaw Revolver"] = {folder = "Spooky Skin Case", name = "Boneclaw Revolver"},
    ["Boneclaw Horn"] = {folder = "Spooky Skin Case", name = "Boneclaw Horn"},
    ["Brain Gun"] = {folder = "Spooky Skin Case", name = "Brain Gun"},
    ["Warpeye"] = {folder = "Spooky Skin Case", name = "Warpeye"},
    ["Warpbone"] = {folder = "Spooky Skin Case", name = "Warpbone"},
    ["Warpstar"] = {folder = "Spooky Skin Case", name = "Warpstar"},
    ["Bat Bow"] = {folder = "Spooky Skin Case", name = "Bat Bow"},
    ["Bat Daggers"] = {folder = "Spooky Skin Case", name = "Bat Daggers"},
    ["Bat Scythe"] = {folder = "Spooky Skin Case", name = "Bat Scythe"},
    ["Blobsaw"] = {folder = "Spooky Skin Case", name = "Blobsaw"},
    ["Candy Bag"] = {folder = "Spooky Skin Case", name = "Candy Bag"},
    ["Candy Bucket"] = {folder = "Spooky Skin Case", name = "Bucket Of Candy"},
    ["Bucket Of Candy"] = {folder = "Spooky Skin Case", name = "Bucket Of Candy"},
    ["Jack O'Launcher"] = {folder = "Spooky Skin Case", name = "Jack O'Launcher"},
    ["Jack O'Thrower"] = {folder = "Spooky Skin Case", name = "Jack O'Thrower"},
    ["Pumpkin Carver"] = {folder = "Spooky Skin Case", name = "Pumpkin Carver"},
    ["Pumpkin Claws"] = {folder = "Spooky Skin Case", name = "Pumpkin Claws"},
    ["Pumpkin Handgun"] = {folder = "Spooky Skin Case", name = "Pumpkin Handgun"},
    ["Pumpkin Minigun"] = {folder = "Spooky Skin Case", name = "Pumpkin Minigun"},
    ["Scythe of Death"] = {folder = "Spooky Skin Case", name = "Scythe of Death"},
    ["Soul Grenade"] = {folder = "Spooky Skin Case", name = "Soul Grenade"},
    ["Soul Pistols"] = {folder = "Spooky Skin Case", name = "Soul Pistols"},
    ["Soul Rifle"] = {folder = "Spooky Skin Case", name = "Soul Rifle"},
    ["Spider Ray"] = {folder = "Spooky Skin Case", name = "Spider Ray"},
    ["Spider Web"] = {folder = "Spooky Skin Case", name = "Spider Web"},
    ["Tombstone Shield"] = {folder = "Spooky Skin Case", name = "Tombstone Shield"},
    ["Vexed Candle"] = {folder = "Spooky Skin Case", name = "Vexed Candle"},
    ["Vexed Flare Gun"] = {folder = "Spooky Skin Case", name = "Vexed Flare Gun"},
    ["Air Horn"] = {folder = "Community Skin Case", name = "Air Horn"},
    ["Anchor"] = {folder = "Community Skin Case", name = "Anchor"},
    ["Balance"] = {folder = "Community Skin Case", name = "Balance"},
    ["Banana"] = {folder = "Community Skin Case", name = "Banana"},
    ["Bongos"] = {folder = "Community Skin Case", name = "Bongos"},
    ["Boombox"] = {folder = "Community Skin Case", name = "Boombox"},
    ["Broken Hearts"] = {folder = "Community Skin Case", name = "Broken Hearts"},
    ["Bubbler"] = {folder = "Community Skin Case", name = "Bubbler"},
    ["Cardboard Gun"] = {folder = "Community Skin Case", name = "Cardboard Gun"},
    ["Cupcake Launcher"] = {folder = "Community Skin Case", name = "Cupcake Launcher"},
    ["Donut Gun"] = {folder = "Community Skin Case", name = "Donut Gun"},
    ["Double Bass"] = {folder = "Community Skin Case", name = "Double Bass"},
    ["Dragon Hammer"] = {folder = "Community Skin Case", name = "Dragon Hammer"},
    ["Eyeball"] = {folder = "Community Skin Case", name = "Eyeball"},
    ["Frying Pan"] = {folder = "Community Skin Case", name = "Frying Pan"},
    ["Genie Lamp"] = {folder = "Community Skin Case", name = "Genie Lamp"},
    ["Giggle Grenade"] = {folder = "Community Skin Case", name = "Giggle Grenade"},
    ["Giggle Gun"] = {folder = "Community Skin Case", name = "Giggle Gun"},
    ["Glove Knife"] = {folder = "Community Skin Case", name = "Glove Knife"},
    ["Guitar"] = {folder = "Community Skin Case", name = "Guitar"},
    ["Hotel Bell"] = {folder = "Community Skin Case", name = "Hotel Bell"},
    ["Hourglass"] = {folder = "Community Skin Case", name = "Hourglass"},
    ["Katana"] = {folder = "Community Skin Case", name = "Katana"},
    ["Light Fifty"] = {folder = "Community Skin Case", name = "Light Fifty"},
    ["Lightning Bolt"] = {folder = "Community Skin Case", name = "Lightning Bolt"},
    ["Lollipop Hammer"] = {folder = "Community Skin Case", name = "Lollipop Hammer"},
    ["Magic Wand"] = {folder = "Community Skin Case", name = "Magic Wand"},
    ["Maracas"] = {folder = "Community Skin Case", name = "Maracas"},
    ["Megaphone"] = {folder = "Community Skin Case", name = "Megaphone"},
    ["Money Gun"] = {folder = "Community Skin Case", name = "Money Gun"},
    ["Nail Gun"] = {folder = "Community Skin Case", name = "Nail Gun"},
    ["Paper Planes"] = {folder = "Community Skin Case", name = "Paper Planes"},
    ["Pencil Launcher"] = {folder = "Community Skin Case", name = "Pencil Launcher"},
    ["Pencil"] = {folder = "Community Skin Case", name = "Pencil"},
    ["Peppergun"] = {folder = "Community Skin Case", name = "Peppergun"},
    ["Pinata Bat"] = {folder = "Community Skin Case", name = "Pinata Bat"},
    ["Pizza Box"] = {folder = "Community Skin Case", name = "Pizza Box"},
    ["Plunger"] = {folder = "Community Skin Case", name = "Plunger"},
    ["Police Baton"] = {folder = "Community Skin Case", name = "Police Baton"},
    ["Poseidon's Trident"] = {folder = "Community Skin Case", name = "Poseidon's Trident"},
    ["Prismatic Hammer"] = {folder = "Community Skin Case", name = "Prismatic Hammer"},
    ["Record Player"] = {folder = "Community Skin Case", name = "Record Player"},
    ["Rubber Mallet"] = {folder = "Community Skin Case", name = "Rubber Mallet"},
    ["Saxophone"] = {folder = "Community Skin Case", name = "Saxophone"},
    ["Shuriken"] = {folder = "Community Skin Case", name = "Shurikens"},
    ["Shurikens"] = {folder = "Community Skin Case", name = "Shurikens"},
    ["Silly Guitar"] = {folder = "Community Skin Case", name = "Silly Guitar"},
    ["Spatula"] = {folder = "Community Skin Case", name = "Spatula"},
    ["Spray Bottle"] = {folder = "Community Skin Case", name = "Spray Bottle"},
    ["Spring"] = {folder = "Community Skin Case", name = "Spring"},
    ["Street Sign"] = {folder = "Community Skin Case", name = "Street Sign"},
    ["Studio Light"] = {folder = "Community Skin Case", name = "Studio Light"},
    ["Subspace Tripmine"] = {folder = "Community Skin Case", name = "Subspace Tripmine"},
    ["Swordfish"] = {folder = "Community Skin Case", name = "Swordfish"},
    ["Tape Measure"] = {folder = "Community Skin Case", name = "Tape Measure"},
    ["The Ban Hammer"] = {folder = "Community Skin Case", name = "The Ban Hammer"},
    ["Toaster"] = {folder = "Community Skin Case", name = "Toaster"},
    ["Torch"] = {folder = "Community Skin Case", name = "Torch"},
    ["Toy Hammer"] = {folder = "Community Skin Case", name = "Toy Hammer"},
    ["Traffic Cone"] = {folder = "Community Skin Case", name = "Traffic Cone"},
    ["Trampoline"] = {folder = "Community Skin Case", name = "Trampoline"},
    ["Trophy Knife"] = {folder = "Community Skin Case", name = "Trophy Knife"},
    ["Trumpet"] = {folder = "Community Skin Case", name = "Trumpet"},
    ["Violin Crossbow"] = {folder = "Community Skin Case", name = "Violin Crossbow"},
    ["War Horn"] = {folder = "Community Skin Case", name = "War Horn"},
    ["Wrench"] = {folder = "Community Skin Case", name = "Wrench"}
}

-- Skin model lookup
local function findSkinModel(skinName)
    local directMap = EXACT_SKIN_MAP[skinName]
    if directMap and vm then
        local f = vm:FindFirstChild(directMap.folder)
        if f then
            local inst = f:FindFirstChild(directMap.name)
            if inst then return inst end
            for _, c in ipairs(f:GetChildren()) do
                if c.Name:lower() == directMap.name:lower() then return c end
            end
        end
    end

    if not vm then return nil end
    local targetLower = skinName:lower()
    for _, folder in ipairs(vm:GetChildren()) do
        if folder.ClassName == "Folder" and folder.Name ~= "Weapons" then
            local inst = folder:FindFirstChild(skinName)
            if inst then return inst end
            for _, c in ipairs(folder:GetChildren()) do
                if c.Name:lower() == targetLower then return c end
            end
        end
    end

    local norm = targetLower:gsub("[%s%-%'%.]+", "")
    for _, folder in ipairs(vm:GetChildren()) do
        if folder.ClassName == "Folder" and folder.Name ~= "Weapons" then
            for _, c in ipairs(folder:GetChildren()) do
                if c.Name:lower():gsub("[%s%-%'%.]+", "") == norm then
                    return c
                end
            end
        end
    end
    return nil
end

-- Memory swap
local memoryRestores = {}
local renamedScripts = {}
local floatRestores = {}

local ENABLE_MODEL_SWAPS = true

local ENABLE_RIG_FIXES = false
local ENABLE_SOUND_REPLACEMENT = false

-- Name copies
local ENABLE_NAME_COPIES = true
local nameCopies = {}
-- Writes everything the swaps overwrote to the undo file (see loadUndo).
local function saveUndo()
    local function n(v) return v and string.format("%.0f", v) or "-" end
    local out = {SERVER_KEY}
    for _, r in ipairs(memoryRestores) do
        out[#out + 1] = table.concat({"R", n(r.defSlot), n(r.skinSlot), n(r.origDefInst), n(r.origSkinInst),
            n(r.origDefCtrl), n(r.origSkinCtrl), n(r.defAddr), n(r.skinAddr), n(r.origDefNC), n(r.origSkinNC),
            n(r.origDefParent), n(r.origSkinParent)}, " ")
    end
    for _, c in ipairs(nameCopies) do out[#out + 1] = "N " .. n(c[1]) .. " " .. n(c[2]) end
    for _, f in ipairs(floatRestores) do out[#out + 1] = "F " .. n(f[1]) .. " " .. string.format("%.9g", f[2]) end
    pcall(writefile, UNDO_FILE, table.concat(out, "\n") .. "\n")
end
local function copyName(target, nameSource)
    if not ENABLE_NAME_COPIES or not target or not nameSource then return false end
    local slot = target.Address + OFF.NameContainer
    local orig, name = rd(slot), rd(nameSource.Address + OFF.NameContainer)
    if not orig or not name or orig == 0 or name == 0 then return false end
    if orig ~= name then
        table.insert(nameCopies, {slot, orig})
        wr(slot, name)
    end
    return true
end

-- Config data
local ENABLE_SKIN_DATA_SYNC = true
local skinDataPairs = {}

local configWrapPairs = {}

local configSkybox = {}
local configSounds = {}
local configSpoof = {}

local configLighting = {}
local configTracers = {}
local configNoHands = {}

local configFinishers, configCharms = {}, {}

-- Swap two instances
local function swapTwoWay(instA, instB, parentFolder)
    if not ENABLE_MODEL_SWAPS then return false end
    if not instA or not instB or not instA.Address or not instB.Address then return false end
    local a, b = instA.Address, instB.Address
    if a == b then return false end

    local folderA = instA.Parent or parentFolder
    local folderB = instB.Parent or parentFolder

    local slotA = findSlotAddress(instA, folderA)
    local slotB = findSlotAddress(instB, folderB)
    local origDefNC = rd(a + OFF.NameContainer)
    local origSkinNC = rd(b + OFF.NameContainer)
    local origDefParent = rd(a + OFF.Parent)
    local origSkinParent = rd(b + OFF.Parent)

    local origDefCtrl = slotA and rd(slotA + 8)
    local origSkinCtrl = slotB and rd(slotB + 8)

    table.insert(memoryRestores, {
        defSlot = slotA,
        skinSlot = slotB,
        origDefInst = a,
        origSkinInst = b,
        origDefCtrl = origDefCtrl,
        origSkinCtrl = origSkinCtrl,
        defAddr = a,
        skinAddr = b,
        origDefNC = origDefNC,
        origSkinNC = origSkinNC,
        origDefParent = origDefParent,
        origSkinParent = origSkinParent
    })

    if slotA then
        wr(slotA, b)
        if origSkinCtrl then wr(slotA + 8, origSkinCtrl) end
    end
    if slotB then
        wr(slotB, a)
        if origDefCtrl then wr(slotB + 8, origDefCtrl) end
    end
    wr(a + OFF.NameContainer, origSkinNC)
    wr(b + OFF.NameContainer, origDefNC)
    wr(a + OFF.Parent, origSkinParent)
    wr(b + OFF.Parent, origDefParent)
    return true
end

-- Rig fixes (off)
local function fixCrossbowRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body")
    if not b then return end
    local p = b:FindFirstChild("Primary") or b:FindFirstChild("BodyPrimary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end

    for _, c in ipairs(m:GetChildren()) do
        if c.Name == "Arch" or c.Name == "String" or c.Name:find("Arrow") or c.Name:find("Bow") or c.Name:find("Wing") then
            local cp = (c.ClassName == "Model" and (c.PrimaryPart or c:FindFirstChild("Primary") or c:FindFirstChildWhichIsA("BasePart"))) or (c:IsA("BasePart") and c)
            if cp and cp.Address and cp ~= p then
                local w = c:FindFirstChild("BodyWeld") or c:FindFirstChild("SkinAttachmentWeld")
                if not w and p.Address then
                    local existingMotor = m:FindFirstChildWhichIsA("Motor6D", true)
                    if existingMotor then
                        pcall(function() existingMotor.Part0 = p end)
                    end
                end
            end
        end
    end
end

local function fixBowRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body")
    if not b then return end
    local p = b:FindFirstChild("Primary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end
    for _, c in ipairs(m:GetChildren()) do
        if c.Name:find("String") or c.Name:find("Arrow") or c.Name:find("Limb") then
            if c:IsA("BasePart") and c.Address then
                local m6d = m:FindFirstChild(c.Name .. "Joint") or m:FindFirstChildWhichIsA("Motor6D", true)
                if m6d then
                    pcall(function() m6d.Part0 = p end)
                end
            end
        end
    end
end

local function fixRPGRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body")
    if not b then return end
    local p = b:FindFirstChild("Primary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end
    for _, c in ipairs(m:GetChildren()) do
        if c.Name:find("Rocket") or c.Name:find("Missile") or c.Name:find("Key") then
            if c:IsA("BasePart") and c.Address then
                local m6d = m:FindFirstChildWhichIsA("Motor6D", true)
                if m6d then
                    pcall(function() m6d.Part0 = p end)
                end
            end
        end
    end
end

local function fixGrenadeRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body") or m
    local p = b:FindFirstChild("Primary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end
    for _, c in ipairs(m:GetChildren()) do
        if c.Name:find("Pin") or c.Name:find("Ring") or c.Name:find("Lever") or c.Name:find("Cap") then
            if c:IsA("BasePart") and c.Address then
                local m6d = m:FindFirstChildWhichIsA("Motor6D", true)
                if m6d then
                    pcall(function() m6d.Part0 = p end)
                end
            end
        end
    end
end

local function fixGunbladeRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body")
    if not b then return end
    local p = b:FindFirstChild("Primary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end
    for _, c in ipairs(m:GetChildren()) do
        if c.Name:find("Blade") or c.Name:find("Sheath") or c.Name:find("Key") then
            if c:IsA("BasePart") and c.Address then
                local m6d = m:FindFirstChildWhichIsA("Motor6D", true)
                if m6d then
                    pcall(function() m6d.Part0 = p end)
                end
            end
        end
    end
end

local function fixKatanaRig(m)
    if not m then return end
    local b = m:FindFirstChild("Body")
    if not b then return end
    local p = b:FindFirstChild("Primary") or b:FindFirstChildWhichIsA("BasePart")
    if not p then return end
    for _, c in ipairs(m:GetChildren()) do
        if c.Name:find("Sheath") or c.Name:find("Blade") or c.Name:find("Handle") or c.Name:find("Wing") then
            if c:IsA("BasePart") and c.Address then
                local m6d = m:FindFirstChildWhichIsA("Motor6D", true)
                if m6d then
                    pcall(function() m6d.Part0 = p end)
                end
            end
        end
    end
end

local function rigSkinModel(m)
    if not m then return end
    for _, sub in ipairs(m:GetChildren()) do
        if sub.ClassName == "Model" then
            if not sub:FindFirstChild("Primary") then
                local firstPart = sub:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    pcall(function() sub.PrimaryPart = firstPart end)
                end
            else
                pcall(function() sub.PrimaryPart = sub.Primary end)
            end
        end
    end

    if m:FindFirstChild("Body") and m.Body:FindFirstChild("Primary") then
        pcall(function() m.PrimaryPart = m.Body.Primary end)
    elseif not m.PrimaryPart then
        pcall(function() m.PrimaryPart = m:FindFirstChildWhichIsA("BasePart", true) end)
    end

    for _, c in ipairs(m:GetChildren()) do
        local n = c.Name:lower()
        if n:find("shell") or n:find("%.r") or n:find("%.l") or n:find("sleeve") or n:find("juggle") then
            if c.ClassName == "Model" then
                pcall(function() c.Name = "_fake" end)
            end
        end
    end
end

-- Effects
local MISC_SPECIAL_MAP = {
    ["Arch Molotov"] = { BurningEffects = "Arch Molotov", MolotovExplosionEffects = "Arch Molotov", FireHitboxes = "Arch Molotov" },
    ["Ship In A Bottle"] = { BurningEffects = "Ship In A Bottle", MolotovExplosionEffects = "Ship In A Bottle", FireHitboxes = "Ship In A Bottle" },
    ["Coffee"] = { BurningEffects = "Coffee", MolotovExplosionEffects = "Coffee", FireHitboxes = "Coffee" },
    ["Vexed Candle"] = { BurningEffects = "Vexed Candle", MolotovExplosionEffects = "Vexed Candle", FireHitboxes = "Vexed Candle" },
    ["Lava Lamp"] = { MolotovExplosionEffects = "Lava Lamp", FireHitboxes = "Lava Lamp" },
    ["Hot Coals"] = { FireHitboxes = "Hot Coals" },
    ["Arch Katana"] = { DeflectHitEffects = "Arch Katana", DeflectActiveEffects = "Arch Katana" },
    ["Pixel Katana"] = { DeflectActiveEffects = "Pixel Katana" },
    ["Keytana"] = { DeflectHitEffects = "Keytana", DeflectActiveEffects = "Keytana" },
    ["Crystal Katana"] = { DeflectHitEffects = "Crystal Katana", DeflectActiveEffects = "Crystal Katana" },
    ["New Year Katana"] = { DeflectHitEffects = "New Year Katana", DeflectActiveEffects = "New Year Katana" },
    ["Stellar Katana"] = { DeflectHitEffects = "Stellar Katana", DeflectActiveEffects = "Stellar Katana" },
    ["Evil Trident"] = { DeflectHitEffects = "Evil Trident", DeflectActiveEffects = "Evil Trident" },
    ["Saber"] = { DeflectHitEffects = "Saber", DeflectActiveEffects = "Saber" },
    ["Lightning Bolt"] = { DeflectHitEffects = "Lightning Bolt", DeflectActiveEffects = "Lightning Bolt" },
    ["Riptide Katana"] = { DeflectHitEffects = "Riptide Katana", DeflectActiveEffects = "Riptide Katana" },
    ["Keythrower"] = { BurningEffects = "Keythrower", FlamethrowerFlames = "Keythrower", FlamethrowerAirblasts = "Keythrower" },
    ["Pixel Flamethrower"] = { BurningEffects = "Pixel Flamethrower", FlamethrowerFlames = "Pixel Flamethrower", FlamethrowerAirblasts = "Pixel Flamethrower" },
    ["Jack O'Thrower"] = { BurningEffects = "Jack O'Thrower", FlamethrowerFlames = "Jack O'Thrower" },
    ["Snowblower"] = { BurningEffects = "Snowblower", FlamethrowerFlames = "Snowblower" },
    ["Rainbowthrower"] = { BurningEffects = "Rainbowthrower", FlamethrowerFlames = "Rainbowthrower" },
    ["Glitterthrower"] = { BurningEffects = "Glitterthrower", FlamethrowerFlames = "Glitterthrower" },
    ["Extinguisher"] = { BurningEffects = "Extinguisher", FlamethrowerFlames = "Extinguisher" },
    ["Bubblethrower"] = { BurningEffects = "Bubblethrower", FlamethrowerFlames = "Bubblethrower" },
    ["Temporal Ray"] = { FreezeEffects = "Temporal" },
    ["Bubble Ray"] = { FreezeEffects = "Bubble" },
    ["Spider Ray"] = { FreezeEffects = "Cocoon" },
    ["Wrapped Freeze Ray"] = { FreezeEffects = "Wrapped" },
    ["Gum Ray"] = { FreezeEffects = "Gum" },
    ["Snowglobe"] = { SmokeClouds = "Snowglobe" },
    ["Emoji Cloud"] = { SmokeClouds = "Emoji Cloud" },
    ["Balance"] = { SmokeClouds = "Balance" },
    ["Eyeball"] = { SmokeClouds = "Eyeball" },
    ["Hourglass"] = { SmokeClouds = "Hourglass" },
    ["Beach Ball"] = { SmokeClouds = "Beach Ball" },
    ["Trampoline"] = { JumpPads = "Trampoline" },
    ["Bounce House"] = { JumpPads = "Bounce House" },
    ["Shady Chicken Sandwich"] = { JumpPads = "Shady Chicken Sandwich" },
    ["Glorious Jump Pad"] = { JumpPads = "Glorious Jump Pad" },
    ["Spider Web"] = { JumpPads = "Spider Web" },
    ["Jolly Man"] = { JumpPads = "Jolly Man" },
    ["Electropunk Warper"] = { Portals = "Electropunk Warper" },
    ["Experiment W4"] = { Portals = "Experiment W4" },
    ["Glitter Warper"] = { Portals = "Glitter Warper" },
    ["Frost Warper"] = { Portals = "Frost Warper" },
    ["Arcane Warper"] = { Portals = "Arcane Warper" },
    ["Hotel Bell"] = { Portals = "Hotel Bell" },
    ["Bubbler"] = { Portals = "Bubbler" },
    ["Experiment D15"] = { Vortexes = "Distortion" },
    ["Cyber Distortion"] = { Vortexes = "Cyber Distortion" },
    ["Sleighstortion"] = { Vortexes = "Sleighstortion" },
    ["Magma Distortion"] = { Vortexes = "Magma Distortion" },
    ["Plasma Distortion"] = { Vortexes = "Plasma Distortion" },
    ["Bubble Distortion"] = { Vortexes = "Bubble Distortion" },
    ["Teleport Disc"] = { BlipEffects = "Teleport Disc" },
    ["Warpeye"] = { BlipEffects = "Warpeye" },
    ["Electropunk Warpstone"] = { BlipEffects = "Electropunk Warpstone" },
    ["Warpstar"] = { BlipEffects = "Warpstar" },
    ["Warpbone"] = { BlipEffects = "Warpbone" },
    ["Cyber Warpstone"] = { BlipEffects = "Cyber Warpstone" },
    ["Wondergun"] = { MuzzleFlashes = "Wondergun" },
    ["Singularity"] = { MuzzleFlashes = "Singularity" },
    ["Midnight Festive Exogun"] = { MuzzleFlashes = "Midnight Festive Exogun" },
    ["Repulsor"] = { MuzzleFlashes = "Repulsor" }
}

local MISC_EXPLOSIONS_MAP = {
    Wondergun = "WondergunExplosionParticles",
    Singularity = "SingularityExplosionParticles",
    ["Midnight Festive Exogun"] = "MidnightFestiveExogunExplosionParticles",
    Repulsor = "RepulsorExplosionParticles",
    Exogourd = "ExogourdExplosionParticles",
    ["Ray Gun"] = "RayGunExplosionParticles",
    Advanced = "AdvancedExplosionParticles",
    ["Cyber Distortion"] = "CyberExplosionParticles",
    Sleighstortion = "SleighstortionExplosionParticles",
    ["Magma Distortion"] = "MagmaDistortionExplosionParticles",
    ["Plasma Distortion"] = "PlasmaDistortionExplosionParticles",
    ["Experiment D15"] = "ExperimentD15ExplosionParticles",
    ["Gum Ray"] = "GumRayExplosionEffect",
    ["Bubble Ray"] = "BubbleRayExplosionEffect",
    ["Spider Ray"] = "SpiderRayExplosionEffect",
    ["Temporal Ray"] = "TemporalRayExplosionEffect",
    ["Wrapped Freeze Ray"] = "WrappedFreezeRayExplosionEffect",
    RPKEY = "RPKEYExplosionEffect"
}

local MISC_EXPLOSIONS_BASE = {
    Exogun = "ExogunExplosionParticles",
    Distortion = "DistortionExplosionParticles",
    ["Freeze Ray"] = "FreezeRayExplosionEffect",
    RPG = "ExplosionEffect"
}

-- Scopes. The game picks these by the viewmodel's name (Mouse.Scope._Setup),
-- which is the owned skin in swap mode and the weapon in switch mode, so the
-- target's images are written over whatever it chose.
local SCOPE_RETICLES = {
    Sniper = {
        blur = "rbxassetid://13466088854",
        circle = "rbxassetid://13466076605"
    },
    ["Pixel Sniper"] = {
        blur = "rbxassetid://18171031143",
        circle = "rbxassetid://18171045114"
    },
    Keyper = {
        blur = "rbxassetid://129335242148588",
        circle = "rbxassetid://81498448678518"
    }
}
-- weapon -> {target skin, owned skin or nil}, for weapons with a scope.
local scopeSkins = {}


-- Sound callbacks (off)
local ACTIVE_CONFIG_SKINS = {}

local ENABLE_SOUND_CALLBACKS = false

local function applySoundCallbacks()
    if not ENABLE_SOUND_CALLBACKS then return end
    local rs = game:GetService("ReplicatedStorage")
    local sc = rs:FindFirstChild("Modules") and rs.Modules:FindFirstChild("AnimationLibrary") and rs.Modules.AnimationLibrary:FindFirstChild("SoundCallbacks")
    if not sc then return end

    local function pfx(n)
        return n:lower():gsub("[%s%-%'%.]+", "")
    end

    local abn = {}
    for _, c in ipairs(sc:GetChildren()) do
        abn[c.Name] = c
    end

    for weaponName, skinTarget in pairs(ACTIVE_CONFIG_SKINS) do
        local wp = pfx(weaponName)
        local sp = pfx(skinTarget)
        local spfx = wp .. "_" .. sp .. "_"
        for name, inst in pairs(abn) do
            if name:sub(1, #spfx) == spfx then
                local suffix = name:sub(#spfx + 1)
                local defInst = abn[wp .. "_" .. suffix]

                if defInst and inst and defInst.Address and inst.Address and defInst.Address ~= inst.Address then
                    swapTwoWay(defInst, inst, sc)
                end
            end
        end
    end
end

-- Live features (off)
local ENABLE_PERSISTENT_FEATURES = false

local tickJobs = {}
local function every(interval, fn)
    table.insert(tickJobs, {interval = interval, acc = 0, fn = fn})
end
local tickConn = nil
if ENABLE_PERSISTENT_FEATURES then
    tickConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
        if not _scriptAlive then return end
        for _, j in ipairs(tickJobs) do
            j.acc = j.acc + (dt or 1 / 60)
            if j.acc >= j.interval then
                j.acc = 0
                pcall(j.fn)
            end
        end
    end)
end

do
    local rs = game:GetService("ReplicatedStorage")
    every(0.3, function()
        local tempVM = rs:FindFirstChild("Assets") and rs.Assets:FindFirstChild("Temp") and rs.Assets.Temp:FindFirstChild("ViewModels")
        if tempVM then
            for _, activeVM in ipairs(tempVM:GetChildren()) do
                if activeVM.Name:find(LP.Name) then
                    local hrp = activeVM:FindFirstChild("HumanoidRootPart")
                    local isUnequipped = not hrp or hrp.Position.Magnitude < 1
                    for _, desc in ipairs(activeVM:GetDescendants()) do
                        if desc.ClassName == "Beam" or desc.ClassName == "ParticleEmitter" or desc.ClassName == "Trail" then
                            if isUnequipped and desc.Enabled then
                                desc.Enabled = false
                            elseif not isUnequipped and not desc.Enabled then
                                desc.Enabled = true
                            end
                        end
                    end
                end
            end
        end
    end)
end

local KATANA_WINGS1_CFS = {
    CFrame.new(0.0002, 0.7842, 0.3093, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.7051, 0.5293, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.4365, 0.2489, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.5693, 0.4387, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.9033, 0.6045, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 1.1191, 0.5842, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.4941, 0.3402, -0.0000, 0.0000, -1.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -0.0000),
    CFrame.new(0.0002, 0.8711, 0.4950, 1.0000, 0.0000, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, 1.0000)
}

local KATANA_WINGS2_CFS = {
    CFrame.new(0.0002, 0.7842, -0.2913, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.7051, -0.5112, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.4365, -0.2307, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.5693, -0.4207, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.9033, -0.5864, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 1.1191, -0.5662, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.4941, -0.3221, 0.0000, 0.0000, 1.0000, 0.0000, 1.0000, 0.0000, -1.0000, 0.0000, 0.0000),
    CFrame.new(0.0002, 0.8711, -0.4769, 1.0000, 0.0000, 0.0000, 0.0000, 1.0000, 0.0000, 0.0000, 0.0000, 1.0000)
}

local UZI_WING1_CFS = {
    CFrame.new(0.2378, 0.3091, -0.5935, 0.4226, 0.5825, 0.6943, 0.0000, 0.7661, -0.6428, -0.9063, 0.2716, 0.3237),
    CFrame.new(0.2371, 0.3089, -0.5945, 0.4226, 0.5825, 0.6943, 0.0000, 0.7661, -0.6428, -0.9063, 0.2716, 0.3237)
}

local UZI_WING2_CFS = {
    CFrame.new(-0.2374, 0.3092, -0.5944, -0.4226, 0.5825, 0.6943, -0.0000, 0.7661, -0.6428, -0.9063, -0.2716, -0.3237),
    CFrame.new(-0.2384, 0.3089, -0.5944, -0.4226, 0.5825, 0.6943, -0.0000, 0.7661, -0.6428, -0.9063, -0.2716, -0.3237)
}

local lastEquippedWeapon = nil
local function alignWeaponWings()
    local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
    if not fp then return end

    for _, vmInst in ipairs(fp:GetChildren()) do
        local wName = vmInst.Name:match("%-%s*(.-)%s*%-") or vmInst.Name:match(LP.Name .. "%s*%-%s*(.-)%s*$")
        if wName and wName ~= lastEquippedWeapon then
            lastEquippedWeapon = wName
        end

        local iv = vmInst:FindFirstChild("ItemVisual")
        if iv then
            local body = iv:FindFirstChild("Body") or iv:FindFirstChild("Model")
            local bp = body and (body:FindFirstChild("Primary") or body:FindFirstChild("BodyPrimary"))
            if bp then
                local bcf = bp.CFrame

                local uw1 = iv:FindFirstChild("Wing1")
                local uw2 = iv:FindFirstChild("Wing2")
                if uw1 and uw2 then
                    local idx1 = 1
                    for _, c in ipairs(uw1:GetChildren()) do
                        if c.ClassName == "MeshPart" or c.ClassName == "Part" then
                            local cf = UZI_WING1_CFS[idx1] or UZI_WING1_CFS[2]
                            if cf then c.CFrame = bcf * cf end
                            idx1 = idx1 + 1
                        end
                    end
                    local idx2 = 1
                    for _, c in ipairs(uw2:GetChildren()) do
                        if c.ClassName == "MeshPart" or c.ClassName == "Part" then
                            local cf = UZI_WING2_CFS[idx2] or UZI_WING2_CFS[2]
                            if cf then c.CFrame = bcf * cf end
                            idx2 = idx2 + 1
                        end
                    end
                end

                local kw1 = iv:FindFirstChild("Wings1")
                local kw2 = iv:FindFirstChild("Wings2")
                if kw1 and kw2 then
                    local idx1 = 1
                    for _, c in ipairs(kw1:GetChildren()) do
                        if c.ClassName == "MeshPart" or c.ClassName == "Part" then
                            local cf = KATANA_WINGS1_CFS[idx1]
                            if cf then c.CFrame = bcf * cf end
                            idx1 = idx1 + 1
                        end
                    end
                    local idx2 = 1
                    for _, c in ipairs(kw2:GetChildren()) do
                        if c.ClassName == "MeshPart" or c.ClassName == "Part" then
                            local cf = KATANA_WINGS2_CFS[idx2]
                            if cf then c.CFrame = bcf * cf end
                            idx2 = idx2 + 1
                        end
                    end
                end
            end
        end
    end
end

local SOUND_REPLACEMENTS = {
    ["13236548545"] = { primary = "rbxassetid://17662574783", secondary = "rbxassetid://18764343961" },
    ["13236548480"] = { primary = "rbxassetid://90757583550672", secondary = "rbxassetid://110122962237431" },
    ["13455395017"] = { primary = "rbxassetid://18887149414" },
    ["13236549929"] = { primary = "rbxassetid://18887149414", volume = 0 },
    ["13236549962"] = { primary = "rbxassetid://18887149414", volume = 0 },
    ["13270206222"] = { primary = "rbxassetid://17672502566", secondary = "rbxassetid://124463680760542" },
    ["13270206087"] = { primary = "rbxassetid://77109116351775", volume = 0.8 },
    ["13455229044"] = { primary = "rbxassetid://113227486192611" },
    ["13455229188"] = { primary = "rbxassetid://17672502879" },
    ["13455394948"] = { primary = "rbxassetid://17672502716" },
    ["13269929260"] = { primary = "rbxassetid://17672502716" },
    ["13269934368"] = { primary = "rbxassetid://17672502879" },
    ["13642104835"] = { primary = "rbxassetid://113227486192611", secondary = "rbxassetid://17672502879" },
    ["14417089307"] = { primary = "rbxassetid://104731232227748", secondary = "rbxassetid://13483008798" },
    ["14417089152"] = { primary = "rbxassetid://104731232227748", volume = 0 },
    ["14417088974"] = { primary = "rbxassetid://104731232227748", volume = 0 },
    ["13087405232"] = { primary = "rbxassetid://104731232227748", secondary = "rbxassetid://14457782622" },
    ["14240943641"] = { primary = "rbxassetid://14457783670" },
    ["14240944488"] = { primary = "rbxassetid://14457783670", volume = 0 },
    ["14240944327"] = { primary = "rbxassetid://14457783670", volume = 0 },
    ["13087406981"] = { primary = "rbxassetid://14457783670" },
    ["82715240396507"] = { primary = "rbxassetid://81230732872783" },
    ["15132679812"] = { primary = "rbxassetid://81230732872783" },
    ["13682532502"] = { primary = "rbxassetid://114610550422028" },
    ["76155503538875"] = { primary = "rbxassetid://114610550422028", volume = 0 },
    ["15132681423"] = { primary = "rbxassetid://114610550422028" },
    ["13087410000"] = { primary = "rbxassetid://13087362838", secondary = "rbxassetid://90757583550672" },
    ["13160326139"] = { primary = "rbxassetid://110122962237431", secondary = "rbxassetid://71387264231358" },
    ["96886470957330"] = { primary = "rbxassetid://135836738518083", secondary = "rbxassetid://115657023572170" },
    ["13479562219"] = { primary = "rbxassetid://115657023572170", secondary = "rbxassetid://96253147006478" },
    ["13515046921"] = { primary = "rbxassetid://96253147006478", volume = 0.5 },
    ["13515046988"] = { primary = "rbxassetid://96253147006478", volume = 0.5 },
    ["14522189766"] = { primary = "rbxassetid://96253147006478", secondary = "rbxassetid://14522189766" },
    ["13158735106"] = { primary = "rbxassetid://18179281854" },
    ["16526185100"] = { primary = "rbxassetid://16526185100", secondary = "rbxassetid://90757583550672" },
    ["16526184479"] = { primary = "rbxassetid://16526184479", secondary = "rbxassetid://110122962237431" },
    ["13744359504"] = { primary = "rbxassetid://110122962237431" },
    ["17209245734"] = { primary = "rbxassetid://17209245734", secondary = "rbxassetid://129124742663895" },
    ["90757583550672"] = { primary = "rbxassetid://90757583550672" },
    ["14812827622"] = { primary = "rbxassetid://72790275842437" },
    ["14812827928"] = { primary = "rbxassetid://72790275842437" },
    ["10730819"] = { primary = "rbxassetid://10730819" },
    ["132455961912409"] = { primary = "rbxassetid://132455961912409" },
    ["13159969353"] = { primary = "rbxassetid://108879620126710", secondary = "rbxassetid://86510987016114" },
    ["13968137196"] = { primary = "rbxassetid://118906938239363" },
    ["14776414133"] = { primary = "rbxassetid://86510987016114" },
    ["14776437962"] = { primary = "rbxassetid://14000023581" },
    ["82797934287631"] = { primary = "rbxassetid://82797934287631" },
}

local function hookSound(sound)
    if not sound or sound.ClassName ~= "Sound" then return end
    local id = sound.SoundId:match("%d+")
    if not id then return end
    local repl = SOUND_REPLACEMENTS[id] or SOUND_REPLACEMENTS["rbxassetid://" .. id]
    if repl then
        sound.SoundId = repl.primary
        if repl.volume then sound.Volume = repl.volume end
        if repl.pitch then sound.PlaybackSpeed = repl.pitch end
    end
end

local soundConnections = {}
pcall(function()
    if not ENABLE_SOUND_REPLACEMENT then return end
    local ss = game:GetService("SoundService")
    if ss then
        for _, s in ipairs(ss:GetDescendants()) do
            if s.ClassName == "Sound" then hookSound(s) end
        end
        if not ENABLE_PERSISTENT_FEATURES then return end
        table.insert(soundConnections, ss.DescendantAdded:Connect(function(s)
            if s.ClassName == "Sound" then hookSound(s) end
        end))
    end
    table.insert(soundConnections, workspace.DescendantAdded:Connect(function(s)
        if s.ClassName == "Sound" then hookSound(s) end
    end))
end)

every(0.1, function()
    local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
    if fp then
        for _, vmInst in ipairs(fp:GetChildren()) do
            for _, s in ipairs(vmInst:GetDescendants()) do
                if s.ClassName == "Sound" then hookSound(s) end
            end
        end
    end
end)

local sampleAnimInstance = nil
local function getSampleAnim()
    if sampleAnimInstance and sampleAnimInstance.Parent then return sampleAnimInstance end
    for _, d in ipairs(LP:GetDescendants()) do
        if d.ClassName == "Animation" then sampleAnimInstance = d return d end
    end
    local rs = game:GetService("ReplicatedStorage")
    for _, d in ipairs(rs:GetDescendants()) do
        if d.ClassName == "Animation" then sampleAnimInstance = d return d end
    end
    return nil
end

local function playCustomTrack(animator, assetId, speed)
    local sample = getSampleAnim()
    if not animator or not sample then return nil end
    local a = sample:Clone()
    a.AnimationId = assetId
    local ok, track = pcall(animator.LoadAnimation, animator, a)
    if ok and track then
        track:Play(0.1, 1, speed or 1)
        return track
    end
    return nil
end

local uisConn = nil
pcall(function()
    if not ENABLE_PERSISTENT_FEATURES then return end
    local uis = game:GetService("UserInputService")
    uisConn = uis.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
        if not fp then return end
        for _, vmInst in ipairs(fp:GetChildren()) do
            local wName = vmInst.Name:match("%-%s*(.-)%s*%-") or vmInst.Name:match(LP.Name .. "%s*%-%s*(.-)%s*$")
            local ac = vmInst:FindFirstChild("AnimationController") or vmInst:FindFirstChildWhichIsA("AnimationController")
            local animator = ac and (ac:FindFirstChild("Animator") or ac:FindFirstChildWhichIsA("Animator"))

            if wName == "Sniper" and animator then
                if input.KeyCode == Enum.KeyCode.R then
                    playCustomTrack(animator, "rbxassetid://121991964753861", 1.43)
                elseif input.KeyCode == Enum.KeyCode.F then
                    playCustomTrack(animator, "rbxassetid://89426100452654", 1)
                end
            elseif wName == "Katana" and animator then
                if input.KeyCode == Enum.KeyCode.F then
                    playCustomTrack(animator, "rbxassetid://119980219668284", 1)
                end
            end
        end
    end)
end)

-- Notifications
local function notifyUser(title, text, duration)
    duration = duration or 8
    if typeof(notify) == "function" then
        pcall(notify, text, title, duration)
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
end

-- Config
local function parseSkinSwapLine(rawLine)
    local l = rawLine:gsub(string.char(13), "")
    if l:match("^%s*%-%-") then return nil end
    local w, o, t = l:match("^%s*([^|]-)%s*|%s*([^>]-)%s*>%s*(.-)%s*$")
    if w and o and t and #w > 0 and #o > 0 and #t > 0 and o ~= t then return w, o, t end
end

local function parseConfigLine(rawLine)
    local l = rawLine:gsub(string.char(13), ""):gsub(string.char(10), ""):match("^%s*(.-)%s*$")
    if not l or #l == 0 or l:sub(1, 2) == "--" or l:sub(1, 1) == "#" or l == "return {" or l == "}" then
        return nil, nil
    end

    local sep = l:find("=") or l:find(":")
    if not sep then return nil, nil end

    local w = l:sub(1, sep - 1):match("^%s*(.-)%s*$")
    local s = l:sub(sep + 1):match("^%s*(.-)%s*$")
    if not w or not s then return nil, nil end

    s = s:gsub("[,;]+$", ""):match("^%s*(.-)%s*$")

    w = w:gsub('^%["', ''):gsub('"%]$', ''):gsub("^%['", ''):gsub("'%]$", ''):gsub('^%[', ''):gsub('%]$', '')

    w = w:gsub('^"', ''):gsub('"$', ''):gsub("^'", ''):gsub("'$", ''):match("^%s*(.-)%s*$")
    s = s:gsub('^"', ''):gsub('"$', ''):gsub("^'", ''):gsub("'$", ''):match("^%s*(.-)%s*$")

    if w and s and #w > 0 and #s > 0 then
        return w, s
    end
    return nil, nil
end

-- Lua table reading
local NODE_SIZE, NODE_KEY, STRING_DATA = 32, 16, 24

local function nodeKey(node)
    local kp = rd(node + NODE_KEY)
    if not kp or kp < 0x10000 then return nil end
    local ok, str = pcall(mrd, "string", kp + STRING_DATA)
    if ok and type(str) == "string" and #str > 0 and #str < 80 then return str end
end

-- 2^lsizenode (byte +6) is the real node count; walking past it reads other
-- tables' nodes and can match a foreign entry with the same key.
local function nodeCount(t)
    if not t or t < 0x10000 then return nil end
    local ok, l = pcall(mrd, "byte", t + 4)
    if not ok or not l or l < 0 or l > 20 then return nil end
    return 2 ^ l
end

local function walkNodes(base, maxNodes, wanted)
    local found, n, readable, want = {}, 0, 0, 0
    for _ in pairs(wanted) do want = want + 1 end
    for i = 0, maxNodes - 1 do
        local node = base + i * NODE_SIZE
        local k = nodeKey(node)
        if k then
            readable = readable + 1

            if wanted[k] and not found[k] then
                local okT, tt = pcall(mrd, "int", node + 12)
                if okT and tt ~= 0 then found[k], n = node, n + 1 end
            end
        end
        if n == want then break end
        if i == 63 and readable == 0 then break end
    end
    return found, n
end

local function tableFields(t, maxNodes, wanted)
    if not t or t < 0x10000 then return nil, 0 end
    maxNodes = math.min(maxNodes, nodeCount(t) or maxNodes)
    local best, bestN, bestBase = nil, 0, nil
    for off = 0, 56, 8 do
        local base = rd(t + off)
        if base and base > 0x10000 then
            local found, n = walkNodes(base, maxNodes, wanted)
            if n > bestN then best, bestN, bestBase = found, n, base end
        end
    end
    return best, bestN, bestBase
end

local VM_ANCHOR, COS_ANCHOR = {["Assault Rifle"] = true}, {["Glass"] = true}

local SCAN_KEY = "AK-47"

local function walkAround(center, span, wanted)
    local found, n = {}, 0
    local function visit(node)
        local k = nodeKey(node)
        if k and wanted[k] and not found[k] then

            local okT, tt = pcall(mrd, "int", node + 12)
            if okT and tt ~= 0 then found[k], n = node, n + 1 end
        end
    end
    visit(center)
    for i = 1, span do
        visit(center + i * NODE_SIZE)
        visit(center - i * NODE_SIZE)
    end
    return found, n
end

-- Registry route
-- Roblox build 02c37bc (Sep 30 2026): the type byte of a Luau object is
-- byte 1 of its header (was 0), a table's lsizenode is byte 4 (was 6), and
-- the thread's global state is at +0x68 (was +0x18).
local ROUTE = {thread = 0x170, slot = 0x178, globalState = 0x68, registry = 0x620, node = 0x18, array = 0x20}
local GC_TT = 1
local TAG_TABLE, TAG_THREAD = 7, 10

local function rbyte(a) local ok, v = pcall(mrd, "byte", a) return ok and v or nil end
local function rint(a) local ok, v = pcall(mrd, "int", a) return ok and v or nil end

local function moduleTable(ms)
    if not ms or not ms.Address then return nil end
    local thread = rd(ms.Address + ROUTE.thread)
    if not thread or thread < 0x10000 or rbyte(thread + GC_TT) ~= TAG_THREAD then return nil end
    local g = rd(thread + ROUTE.globalState)
    local reg = g and g > 0x10000 and rd(g + ROUTE.registry)
    if not reg or reg < 0x10000 or rbyte(reg + GC_TT) ~= TAG_TABLE or rint(g + ROUTE.registry + 12) ~= TAG_TABLE then return nil end
    local slot, size, arr = rint(ms.Address + ROUTE.slot), rint(reg + 8), rd(reg + ROUTE.array)
    if not slot or not size or not arr or slot < 1 or slot > size then return nil end
    local t = rd(arr + (slot - 1) * 16)
    if not t or t < 0x10000 or rbyte(t + GC_TT) ~= TAG_TABLE then return nil end
    return t
end

local function nodesOf(t, maxNodes, wanted)
    local base = t and t > 0x10000 and rbyte(t + GC_TT) == TAG_TABLE and rd(t + ROUTE.node)
    if not base or base < 0x10000 then return nil end
    local count = math.min(maxNodes, nodeCount(t) or maxNodes)
    local found, n = walkNodes(base, count, wanted)
    return found, n, base, count
end

local function dictionariesViaRegistry(wantVm, wantCos)
    local mods = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    local vm, cos, vmBase, cosBase, vmCount, cosCount
    if wantVm then
        local f = nodesOf(moduleTable(mods and mods:FindFirstChild("ItemLibrary")), 256, {ViewModels = true, ViewModelOrder = true})
        local dict = f and f.ViewModels and f.ViewModelOrder and rd(f.ViewModels)
        local d, _, base, count = nodesOf(dict, 8192, VM_ANCHOR)
        if d and d["Assault Rifle"] then vm, vmBase, vmCount = d["Assault Rifle"], base, count end
    end
    if wantCos then
        local f = nodesOf(moduleTable(mods and mods:FindFirstChild("CosmeticLibrary")), 256, {Cosmetics = true})
        local dict = f and f.Cosmetics and rd(f.Cosmetics)
        local d, _, base, count = nodesOf(dict, 16384, COS_ANCHOR)
        if d and d["Glass"] then cos, cosBase, cosCount = d["Glass"], base, count end
    end
    return vm, cos, vmBase, cosBase, vmCount, cosCount
end

-- Item dictionaries
local function findDictionaries(cache, needVm, needCos)
    local vm, cos = nil, nil

    local forceScan = cache.forceScan
    if not forceScan then
        if needVm and cache.vm and select(2, walkAround(cache.vm, 2048, VM_ANCHOR)) > 0 then vm = cache.vm end
        if needCos and cache.cos and select(2, walkAround(cache.cos, 4096, COS_ANCHOR)) > 0 then cos = cache.cos end
        if (vm or not needVm) and (cos or not needCos) then
            cache.route = "cache"
            return vm, cos
        end
    end

    local okR, rvm, rcos, rvmBase, rcosBase, rvmCount, rcosCount = false, nil, nil, nil, nil, nil, nil
    if not forceScan then
        okR, rvm, rcos, rvmBase, rcosBase, rvmCount, rcosCount =
            pcall(dictionariesViaRegistry, needVm and not vm, needCos and not cos)
    end
    if okR then
        if rvm then vm, cache.vmBase, cache.vmCount = rvm, rvmBase, rvmCount end
        if rcos then cos, cache.cosBase, cache.cosCount = rcos, rcosBase, rcosCount end
    end
    if (vm or not needVm) and (cos or not needCos) then
        cache.vm, cache.cos = vm or cache.vm, cos or cache.cos
        cache.route = "registry"
        return vm, cos
    end

    cache.route, cache.vmBase, cache.cosBase, cache.vmCount, cache.cosCount = "scan", nil, nil, nil, nil

    local job = game.JobId
    local okG, rows = pcall(getgc, {SCAN_KEY})

    if game.JobId ~= job then return nil, nil, "server changed during the scan" end
    for _, r in ipairs(okG and type(rows) == "table" and rows or {}) do

        local f = tableFields(rd(r.addr), 32, {Animations = true, Rarity = true, Type = true})
        if f and f.Animations then
            if needVm and not vm and select(2, walkAround(r.addr, 2048, VM_ANCHOR)) > 0 then vm = r.addr end
        elseif f and f.Rarity and f.Type then
            if needCos and not cos and select(2, walkAround(r.addr, 4096, COS_ANCHOR)) > 0 then cos = r.addr end
        end
    end

    if (needVm and not vm) or (needCos and not cos) then
        if game.JobId ~= job then return nil, nil, "server changed during the scan" end
        local okF, frows = pcall(getgc, {"ViewModels", "Cosmetics"})
        for _, r in ipairs(okF and type(frows) == "table" and frows or {}) do
            if r.key == "ViewModels" and needVm and not vm then
                local f = tableFields(rd(r.addr), 2048, VM_ANCHOR)
                vm = f and f["Assault Rifle"] or vm
            elseif r.key == "Cosmetics" and needCos and not cos then
                local f = tableFields(rd(r.addr), 4096, COS_ANCHOR)
                cos = f and f["Glass"] or cos
            end
        end
        if game.JobId ~= job then return nil, nil, "server changed during the scan" end
    end
    cache.vm, cache.cos = vm or cache.vm, cos or cache.cos
    return vm, cos, (not okG) and "gc scan failed" or nil
end

local VM_FIELDS = {Animations = true, RootPartOffset = true, Image = true, ImageHighResolution = true}
local WRAP_FIELDS = {WrapGroups = true}

-- Animations, offsets, icons, wraps
local function syncSkinData(pairList, wrapPairs, cache)
    if #pairList == 0 and #wrapPairs == 0 then return 0 end
    local vm, cos, err = findDictionaries(cache, #pairList > 0, #wrapPairs > 0)
    if #pairList > 0 and not vm and #wrapPairs > 0 and not cos then return 0, err or "item dictionaries not found" end

    local vmWanted, cosWanted = {}, {}
    for _, p in ipairs(pairList) do vmWanted[p[1]], vmWanted[p[2]] = true, true end
    for _, p in ipairs(wrapPairs) do cosWanted[p[1]], cosWanted[p[2]] = true, true end

    local vmNodes = vm and (cache.vmBase and walkNodes(cache.vmBase, cache.vmCount or 8192, vmWanted) or walkAround(vm, 2048, vmWanted)) or {}
    local cosNodes = cos and (cache.cosBase and walkNodes(cache.cosBase, cache.cosCount or 16384, cosWanted) or walkAround(cos, 4096, cosWanted)) or {}

    local function viewModelSlots(name)
        local node = vmNodes[name]
        local f = node and tableFields(rd(node), 32, VM_FIELDS)
        if f and f.Animations and f.RootPartOffset then
            return {f.Animations, f.RootPartOffset, f.Image or false, f.ImageHighResolution or false}
        end
    end

    local synced, missed = 0, {}
    for _, p in ipairs(pairList) do
        local d, k = viewModelSlots(p[1]), viewModelSlots(p[2])
        local vals = k and {rd(k[1]), rd(k[2]), k[3] and rd(k[3]), k[4] and rd(k[4])}
        if d and vals and vals[1] and vals[2] and vals[1] ~= 0 and vals[2] ~= 0 then

            for j = 1, 4 do
                if d[j] and vals[j] and vals[j] ~= 0 then wr(d[j], vals[j]) end
            end
            synced = synced + 1
        else
            missed[#missed + 1] = p[2]
        end
    end

    local function wrapGroupsSlot(name)
        local node = cosNodes[name]
        local f = node and tableFields(rd(node), 32, WRAP_FIELDS)
        return f and f.WrapGroups
    end
    local wrapsApplied, wrapsMissed = 0, {}
    for _, p in ipairs(wrapPairs) do
        local ownedSlot, targetSlot = wrapGroupsSlot(p[1]), wrapGroupsSlot(p[2])
        local targetGroups = targetSlot and rd(targetSlot)
        if ownedSlot and targetGroups and targetGroups ~= 0 and ownedSlot ~= targetSlot then
            wr(ownedSlot, targetGroups)
            wrapsApplied = wrapsApplied + 1
        else
            wrapsMissed[#wrapsMissed + 1] = p[1] .. "=" .. p[2]
        end
    end
    local note = (#missed > 0) and ("not found: " .. table.concat(missed, ", ")) or err
    return synced, note, wrapsApplied, wrapsMissed, missed
end

-- Skin swaps
local function applySkinSwapper()
    if not isfile or not readfile then
        return 0, "Executor does not support isfile/readfile functions."
    end

    local candidatePaths = {
        "rivals_config.lua",
        "workspace/rivals_config.lua",
        "rivals_config.lua.txt",
        "rivals_config.txt",
        "workspace/rivals_config.txt",
        "rivals_config (1).lua",
        "rivals_config(1).lua",
        "Rivals_Config.lua",
        "rivals_config"
    }

    if typeof(listfiles) == "function" then
        pcall(function()
            for _, folder in ipairs({"", "workspace"}) do
                local files = listfiles(folder) or {}
                for _, f in ipairs(files) do
                    local clean = f:lower():gsub(string.char(92), "/")
                    if clean:find("rivals_config") then
                        table.insert(candidatePaths, f)
                    end
                end
            end
        end)
    end

    local targetFile = nil
    for _, path in ipairs(candidatePaths) do
        local ok, exists = pcall(isfile, path)
        if ok and exists then
            targetFile = path
            break
        end
    end

    if not targetFile then
        return 0, "rivals_config.lua was not found in your executor's workspace folder! Make sure rivals_config.lua is placed in your workspace directory."
    end

    print("[RivalsSkinChanger] Config: " .. tostring(targetFile)
        .. (_G.__RIVALS_SUPPORT_ID and ("  (ref " .. _G.__RIVALS_SUPPORT_ID .. ")") or ""))
    local okRead, r2 = pcall(readfile, targetFile)
    if not okRead or not r2 then
        return 0, "Failed to read file '" .. tostring(targetFile) .. "'. File may be locked by another application."
    end

    if r2:sub(1, 3) == string.char(239, 187, 191) then
        r2 = r2:sub(4)
    end

    if #r2:gsub("%s+", "") == 0 then
        return 0, "Config file '" .. tostring(targetFile) .. "' is completely empty (0 bytes). Please generate your config on the website."
    end

    if not wf then
        return 0, "Game assets folder (ViewModels.Weapons) is not loaded yet. Are you in a match or shooting range?"
    end

    local parsedPairs = 0
    local nonDefaultPairs = 0
    local missingBaseWeapons = {}
    local missingSkinModels = {}
    local swappedCount = 0
    local skippedNoScript = {}
    local vmMods = LP.PlayerScripts:FindFirstChild("Modules")
    vmMods = vmMods and vmMods:FindFirstChild("ViewModels")

    -- Family scripts by their real names, before any line trades them.
    local vmOrder = vmMods and vmMods:GetChildren() or {}
    local vmFamilies = {}
    for _, c in ipairs(vmOrder) do vmFamilies[c.Name] = c end

    -- The game picks a viewmodel script with ViewModels:FindFirstChild(name, true).
    -- On Energy Rifle, Sniper, Freeze Ray and the like the family script is both
    -- the default weapon's script and the base class every skin script requires
    -- by name (ViewModels["Energy Rifle"]), so the two can't simply trade names.
    -- Instead the skin script, named like the weapon, moves into an earlier family,
    -- which a depth-first search reaches before the family script; the family
    -- script keeps its name for the require. It trades places with a spare script
    -- there that no config line uses, which keeps its own name.
    local spares = {}
    local function moveAhead(sm, fam, inConfig)
        for _, host in ipairs(vmOrder) do
            if host == fam then return false end
            if not spares[host] then
                spares[host] = {}
                local default = host.Name:gsub("^Base", "")
                for _, c in ipairs(host:GetChildren()) do
                    if c.ClassName == "ModuleScript" and c.Name ~= default and not inConfig[c.Name] then
                        table.insert(spares[host], c)
                    end
                end
            end
            local spare = table.remove(spares[host], 1)
            if spare then
                -- Names first, so the swap leaves each with the right one; the
                -- next run then undoes the swap before the names.
                return (copyName(sm, spare) and copyName(spare, fam) and swapTwoWay(sm, spare, host)) and true or false
            end
        end
        return false
    end

    local jobs, swapJobs, touched, skippedConflicts = {}, {}, {}, {}

    local section = "skins"
    for _, rawLine in ipairs(r2:split(string.char(10))) do
        local header = rawLine:gsub(string.char(13), ""):match("^%s*%[%s*(.-)%s*%]%s*$")
        if header then
            local h = header:lower()

            section = h:find("wrap") and "wraps" or (h:find("sky") and "skybox"
                or (h:find("light") and "lighting" or (h:find("finisher") and "finishers"
                or (h:find("charm") and "charms" or (h:find("sound") and "sounds"
                or (h:find("spoof") and "spoof" or (h:find("tracer") and "tracers" or (h:find("hand") and "nohands"
                or (h:find("skin") and "skins" or "other")))))))))
        elseif section == "other" then

        elseif section == "finishers" or section == "charms" then
            local owned, target = parseConfigLine(rawLine)
            if owned and target and owned ~= target then
                local list = section == "finishers" and configFinishers or configCharms
                list[#list + 1] = {owned, target}
            end
        elseif section == "wraps" then
            local owned, target = parseConfigLine(rawLine)
            if owned and target then configWrapPairs[#configWrapPairs + 1] = {owned, target} end
        elseif section == "skybox" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configSkybox[key:lower()] = value end
        elseif section == "sounds" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configSounds[key:lower()] = value end
        elseif section == "spoof" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configSpoof[key:lower()] = value end
        elseif section == "nohands" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configNoHands[key:lower()] = value end
        elseif section == "tracers" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configTracers[key:lower()] = value end
        elseif section == "lighting" then
            local key, value = parseConfigLine(rawLine)
            if key and value then configLighting[key:lower()] = value end
        else
            local weaponName, skinTarget = parseConfigLine(rawLine)
            if weaponName and skinTarget then
                jobs[#jobs + 1] = {weaponName, skinTarget, weaponName}
            else
                local w, owned, target = parseSkinSwapLine(rawLine)
                if w then swapJobs[#swapJobs + 1] = {w, target, owned} end
            end
        end
    end
    for _, j in ipairs(swapJobs) do jobs[#jobs + 1] = j end
    local inConfig = {}
    for _, j in ipairs(jobs) do inConfig[j[1]], inConfig[j[2]], inConfig[j[3]] = true, true, true end

    for _, job in ipairs(jobs) do
        local weaponName, skinTarget, srcName = job[1], job[2], job[3]
        local ownedSwap = srcName ~= weaponName
        parsedPairs = parsedPairs + 1
        local skinLower = skinTarget:lower()
        local isSkin = skinLower ~= "default" and skinLower ~= "standard"
        -- Set once the skin's own viewmodel script is in place. That script
        -- finds its effects by their real names, so they must not be renamed.
        local scriptMoved = false

        if isSkin and (touched[skinTarget] or touched[srcName]) then
            table.insert(skippedConflicts, srcName .. " -> " .. skinTarget
                .. " (" .. (touched[skinTarget] or touched[srcName]) .. " already uses it)")
        else
            if isSkin then
                local line = srcName .. " -> " .. skinTarget
                touched[skinTarget], touched[srcName] = line, line
                nonDefaultPairs = nonDefaultPairs + 1
                if not ownedSwap then ACTIVE_CONFIG_SKINS[weaponName] = skinTarget end
                if SCOPE_RETICLES[weaponName] then
                    scopeSkins[weaponName] = {skinTarget, ownedSwap and srcName or nil}
                end
                local function findSource()
                    if ownedSwap then return findSkinModel(srcName) end
                    return wf:FindFirstChild(weaponName)
                end

                local defModel = findSource()
                if not defModel then
                    for _ = 1, 6 do
                        task.wait(0.5)
                        defModel = findSource()
                        if defModel then break end
                    end
                end
                if not defModel then
                    table.insert(missingBaseWeapons, srcName)
                else

                    local skinModel = findSkinModel(skinTarget)
                    if not skinModel then
                        for _ = 1, 6 do
                            task.wait(0.5)
                            skinModel = findSkinModel(skinTarget)
                            if skinModel then break end
                        end
                    end
                    if not skinModel then
                        table.insert(missingSkinModels, skinTarget)
                    else
                        if defModel.Address and skinModel.Address and defModel.Address ~= skinModel.Address then
                            if ENABLE_RIG_FIXES then rigSkinModel(skinModel) end

                            local weaponLower = weaponName:lower()
                            if weaponLower:find("crossbow") or skinLower:find("crossbow") then
                                if ENABLE_RIG_FIXES then pcall(fixCrossbowRig, skinModel) end
                            elseif weaponLower:find("bow") or skinLower:find("bow") then
                                if ENABLE_RIG_FIXES then pcall(fixBowRig, skinModel) end
                            elseif weaponLower:find("rpg") or skinLower:find("rpkey") or skinLower:find("rocket") then
                                if ENABLE_RIG_FIXES then pcall(fixRPGRig, skinModel) end
                            elseif weaponLower == "grenade" or skinLower:find("nade") or skinLower:find("bomb") then
                                if ENABLE_RIG_FIXES then pcall(fixGrenadeRig, skinModel) end
                            elseif weaponLower == "gunblade" or skinLower:find("gunblade") or skinLower:find("blade") then
                                if ENABLE_RIG_FIXES then pcall(fixGunbladeRig, skinModel) end
                            elseif weaponLower == "katana" or skinLower:find("katana") then
                                if ENABLE_RIG_FIXES then pcall(fixKatanaRig, skinModel) end
                            end

                            local baseMod = vmMods and vmMods:FindFirstChild("Base" .. (weaponName:gsub(" ", "")))
                            local defMod = baseMod and baseMod:FindFirstChild(srcName)
                            local skinMod = baseMod and baseMod:FindFirstChild(skinTarget)
                            if defMod and not skinMod and not ownedSwap then
                                table.insert(skippedNoScript, weaponName .. "=" .. skinTarget)
                            elseif swapTwoWay(defModel, skinModel, wf) then
                                swappedCount = swappedCount + 1
                                table.insert(skinDataPairs, {srcName, skinTarget})
                                if defMod and skinMod then
                                    scriptMoved = swapTwoWay(defMod, skinMod, baseMod) and true or false
                                elseif ownedSwap then

                                    local fam = baseMod or vmFamilies[weaponName]
                                    local om = fam and fam:FindFirstChild(srcName)
                                    local sm = fam and fam:FindFirstChild(skinTarget)
                                    if om and sm then
                                        scriptMoved = swapTwoWay(om, sm, fam) and true or false
                                    elseif sm and copyName(sm, skinModel) then
                                        scriptMoved = true
                                        table.insert(renamedScripts, {srcName, skinTarget})
                                    elseif om then
                                        copyName(om, defModel)
                                    end
                                elseif not baseMod then

                                    local fam = vmFamilies[weaponName]
                                    local sm = fam and fam:FindFirstChild(skinTarget)
                                    if sm and fam.ClassName == "ModuleScript" then
                                        if moveAhead(sm, fam, inConfig) then
                                            scriptMoved = true
                                            table.insert(renamedScripts, {weaponName, skinTarget})
                                        end
                                    elseif sm and not fam:FindFirstChild(weaponName) and copyName(sm, fam) then
                                        scriptMoved = true
                                        table.insert(renamedScripts, {weaponName, skinTarget})
                                    end
                                end
                            end
                        end
                    end
                end

                -- Thrown, fired and stuck-in-the-wall copies of the item (a
                -- grenade in flight, an arrow, the thrown spear and its rope).
                -- The game picks them by skin name, for every weapon.
                for _, folder in ipairs({tf or false, pf or false, stf or false}) do
                    local ts = folder and folder:FindFirstChild(skinTarget)
                    if ts then
                        local tb = folder:FindFirstChild(srcName)
                        if tb then
                            swapTwoWay(tb, ts, folder)
                        else
                            copyName(ts, ownedSwap and findSkinModel(srcName) or wf:FindFirstChild(weaponName))
                        end
                    end
                end

                if mi then
                    local spec = MISC_SPECIAL_MAP[skinTarget]
                    if spec then
                        for folderName, itemName in pairs(spec) do
                            local folder = mi:FindFirstChild(folderName)
                            if folder then

                                local weaponItem = folder:FindFirstChild(srcName)
                                local skinItem = folder:FindFirstChild(itemName)
                                if skinItem and weaponItem then
                                    swapTwoWay(weaponItem, skinItem, folder)
                                elseif skinItem then
                                    copyName(skinItem, ownedSwap and findSkinModel(srcName) or wf:FindFirstChild(weaponName))
                                end
                            end
                        end
                    end

                    -- Every other effect folder keyed by skin name (muzzle flashes,
                    -- flames, deflects...): the owned item takes the target's entry.
                    -- A variant of the owned entry ("Hyperlaser Guns Red") would
                    -- still win for its hand, so it is renamed out of the way.
                    for _, folder in ipairs(mi:GetChildren()) do
                        if folder.ClassName == "Folder" and not (spec and spec[folder.Name]) then
                            local skinItem = folder:FindFirstChild(skinTarget)
                            if skinItem then
                                local weaponItem = folder:FindFirstChild(srcName)
                                if weaponItem then
                                    swapTwoWay(weaponItem, skinItem, folder)
                                else
                                    copyName(skinItem, ownedSwap and findSkinModel(srcName) or wf:FindFirstChild(weaponName))
                                end
                                local prefix = srcName .. " "
                                for _, v in ipairs(folder:GetChildren()) do
                                    if v.Name:sub(1, #prefix) == prefix and not findSkinModel(v.Name)
                                        and not folder:FindFirstChild(skinTarget .. v.Name:sub(#prefix)) then
                                        copyName(v, folder)
                                    end
                                end
                            end
                        end
                    end

                    local expSkin = MISC_EXPLOSIONS_MAP[skinTarget]

                    local expBase = MISC_EXPLOSIONS_MAP[srcName]
                    if not ownedSwap then expBase = MISC_EXPLOSIONS_BASE[weaponName] end
                    if expSkin and expBase and not scriptMoved then
                        local sx = mi:FindFirstChild(expSkin)
                        local dx = mi:FindFirstChild(expBase)
                        if sx and dx then
                            swapTwoWay(dx, sx, mi)
                        end
                    end
                end
            end
        end
    end

    pcall(applySoundCallbacks)

    if swappedCount == 0 then
        if parsedPairs == 0 then
            return 0, "Found '" .. tostring(targetFile) .. "', but no valid Weapon=Skin lines were detected! Check file format."
        elseif nonDefaultPairs == 0 then
            return 0, "All " .. parsedPairs .. " weapons in '" .. tostring(targetFile) .. "' are set to Default. Please select at least one custom skin on the site."
        elseif #missingBaseWeapons > 0 and #missingSkinModels == 0 then
            return 0, "Base weapons (" .. table.concat(missingBaseWeapons, ", ") .. ") not found in game folder."
        elseif #missingSkinModels > 0 then
            return 0, "Skin models not found in game assets: " .. table.concat(missingSkinModels, ", ")
        else
            return 0, "Memory swap failed. Ensure memory read/write permissions are allowed in executor."
        end
    end

    if #missingBaseWeapons > 0 then
        print("[RivalsSkinChanger] Not swapped - model not found for: " .. table.concat(missingBaseWeapons, ", "))
    end
    if #missingSkinModels > 0 then
        print("[RivalsSkinChanger] Not swapped - skin model not found: " .. table.concat(missingSkinModels, ", "))
    end
    if #skippedConflicts > 0 then
        print("[RivalsSkinChanger] Skipped (skin already used by another line): " .. table.concat(skippedConflicts, ", "))
        -- A swap trades two models, so a skin can only be in one line.
        notifyUser("Rivals Skin Changer", "Skipped " .. #skippedConflicts .. " skin line" .. (#skippedConflicts == 1 and "" or "s")
            .. " - two lines use the same skin: " .. table.concat(skippedConflicts, ", "), 10)
    end
    if #skippedNoScript > 0 then
        print("[RivalsSkinChanger] Left default (skin has no viewmodel script of its own): " .. table.concat(skippedNoScript, ", "))
    end
    if #renamedScripts > 0 then
        local names = {}
        for _, rn in ipairs(renamedScripts) do names[#names + 1] = rn[2] end
        print("[RivalsSkinChanger] Using the skin's own viewmodel script: " .. table.concat(names, ", "))
    end
    return swappedCount, nil
end

-- Wait for the game
local gameReady = false
do
    local mods = game:GetService("ReplicatedStorage"):WaitForChild("Modules", 30)
    local il = mods and mods:WaitForChild("ItemLibrary", 30)
    local cl = mods and mods:WaitForChild("CosmeticLibrary", 30)
    local job, t0, told = game.JobId, tick(), false
    while tick() - t0 < 60 do
        local okI, itemTable = pcall(moduleTable, il)
        if okI and itemTable then

            for _ = 1, 10 do
                local okC, cosTable = pcall(moduleTable, cl)
                if okC and cosTable then break end
                task.wait(0.5)
            end
            gameReady = true
            break
        end
        if not told and tick() - t0 > 2 then
            told = true
            print("[RivalsSkinChanger] Waiting for the game to finish loading...")
        end
        task.wait(0.5)
        if game.JobId ~= job then
            print("[RivalsSkinChanger] Server changed while waiting - stopped")
            _G.__RIVALS_SKIN_CHANGER_BUSY = nil
            return
        end
    end
    if not gameReady then
        print("[RivalsSkinChanger] The game still isn't reporting its item tables after 60s - going ahead anyway")
    end
end

local count, errorReason = applySkinSwapper()
saveUndo() -- saved now, in case a later step fails before the final save
local elapsed = math.floor((tick() - t_start) * 1000)

if count == 0 then
    local errText = errorReason or "Unknown error while loading skins."
    warn("[RivalsSkinChanger] ==================================================")
    warn("[RivalsSkinChanger] ERROR: 0 SKINS LOADED!")
    warn("[RivalsSkinChanger] Details: " .. errText)
    warn("[RivalsSkinChanger] ==================================================")
    notifyUser("Rivals Skin Changer Error", "0 Skins Loaded: " .. errText, 10)
else
    local msg = "Swapped " .. tostring(count) .. " skins in " .. tostring(elapsed) .. "ms!"
        .. (_G.__RIVALS_SUPPORT_ID and ("  ref " .. _G.__RIVALS_SUPPORT_ID) or "")
    print("[RivalsSkinChanger] " .. msg)
    notifyUser("Rivals Skin Changer", "Swapped " .. tostring(count) .. " skins - loading animations, offsets and icons...", 6)
end

local function replaceStandardIcon(label)
    if not label or not label.Address then return end
    local ptr = mrd("uintptr_t", label.Address + IMG_OFF)
    if not ptr or ptr < 0x10000000000 or ptr > 0x7FFFFFFFFFFF then return end
    local cur = mrd("string", ptr)
    if not cur then return end
    local weaponName = STANDARD_ICON_MAP[cur]
    if weaponName and ACTIVE_CONFIG_SKINS[weaponName] then
        local skinTarget = ACTIVE_CONFIG_SKINS[weaponName]
        local skinIcon = ITEM_ICONS[weaponName] and (ITEM_ICONS[weaponName][skinTarget] or ITEM_ICONS[weaponName][skinTarget:lower()])
        if skinIcon and skinIcon ~= cur then
            writeImage(label, skinIcon)
        end
    end
end

local runService = game:GetService("RunService")
local renderSteppedConn = nil
local pgDescConn = nil

local function fastSyncGui()
    if not _scriptAlive or not game:IsLoaded() or not LP or not LP.Parent or not LP:IsDescendantOf(game) then return end
    pcall(alignWeaponWings)
    local pg = LP:FindFirstChild("PlayerGui")
    local mg = pg and pg:FindFirstChild("MainGui")
    local mf = mg and mg:FindFirstChild("MainFrame")
    if not mf then return end

    local fi = mf:FindFirstChild("FighterInterfaces")
    local lni = fi and fi:FindFirstChild(LP.Name)
    if lni then
        local sub = lni:FindFirstChild("BottomRight") or lni:FindFirstChild("BottomCenter") or lni:FindFirstChild("BottomLeft")
        local c = sub and sub:FindFirstChild("Container")
        local hb = c and c:FindFirstChild("Hotbar")
        local cont = hb and hb:FindFirstChild("Container")
        if cont then
            for _, slot in ipairs(cont:GetChildren()) do
                if slot.ClassName == "Frame" then
                    if slot.Name == "EquippedDisplay" then
                        local c2 = slot:FindFirstChild("Container")
                        local w2 = c2 and c2:FindFirstChild("Weapon")
                        local iconLabel = w2 and w2:FindFirstChild("Icon")
                        if iconLabel and iconLabel.ClassName == "ImageLabel" and lastEquippedWeapon then
                            local skinTarget = ACTIVE_CONFIG_SKINS[lastEquippedWeapon]
                            if skinTarget then
                                local skinIcon = ITEM_ICONS[lastEquippedWeapon] and (ITEM_ICONS[lastEquippedWeapon][skinTarget] or ITEM_ICONS[lastEquippedWeapon][skinTarget:lower()])
                                if skinIcon then
                                    writeImage(iconLabel, skinIcon)
                                end
                            end
                        end
                    elseif slot.Name ~= "KeybindGamepadEquipLast" and slot.Name ~= "KeybindGamepadEquipNext" and slot.Name ~= "Layout" then
                        local weaponName = slot.Name
                        local skinTarget = ACTIVE_CONFIG_SKINS[weaponName]
                        if skinTarget then
                            local skinIcon = ITEM_ICONS[weaponName] and (ITEM_ICONS[weaponName][skinTarget] or ITEM_ICONS[weaponName][skinTarget:lower()])
                            if skinIcon then
                                local iconLabel = slot:FindFirstChild("Icon")
                                if iconLabel and iconLabel.ClassName == "ImageLabel" then
                                    writeImage(iconLabel, skinIcon)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local eq = mf:FindFirstChild("Equipment")
    if eq and eq.Visible then
        for _, d in ipairs(eq:GetDescendants()) do
            if d.ClassName == "ImageLabel" or d.ClassName == "ImageButton" then
                replaceStandardIcon(d)
            end
        end
    end

    local pages = mf:FindFirstChild("Pages")
    if pages then
        local pw = pages:FindFirstChild("PickWeapons")
        if pw and pw.Visible then
            local list = pw:FindFirstChild("List") and pw.List:FindFirstChild("Container")
            if list then
                for _, f in ipairs(list:GetChildren()) do
                    local btn = f:FindFirstChild("Button")
                    local pic = btn and btn:FindFirstChild("Icon") and btn.Icon:FindFirstChild("Picture")
                    if pic and pic.ClassName == "ImageLabel" then
                        replaceStandardIcon(pic)
                    end
                end
            end
            local chosen = pw:FindFirstChild("ChosenWeapons")
            if chosen then
                for _, f in ipairs(chosen:GetChildren()) do
                    local btn = f:FindFirstChild("Button")
                    local pic = btn and btn:FindFirstChild("Picture")
                    if pic and pic.ClassName == "ImageLabel" then
                        replaceStandardIcon(pic)
                    end
                end
            end
        end

        local pw2 = pages:FindFirstChild("PickWeaponsList")
        if pw2 and pw2.Visible then
            local lc = pw2:FindFirstChild("ListContainer") and pw2.ListContainer:FindFirstChild("List") and pw2.ListContainer.List:FindFirstChild("Container")
            if lc then
                for _, s in ipairs(lc:GetChildren()) do
                    local btn = s:FindFirstChild("Button")
                    local pic = btn and btn:FindFirstChild("Icon") and btn.Icon:FindFirstChild("Picture")
                    if pic and pic.ClassName == "ImageLabel" then
                        replaceStandardIcon(pic)
                    end
                end
            end
            local ch = pw2:FindFirstChild("ChosenWeapons")
            if ch then
                for _, s in ipairs(ch:GetChildren()) do
                    local btn = s:FindFirstChild("Button")
                    local pic = btn and btn:FindFirstChild("Picture")
                    if pic and pic.ClassName == "ImageLabel" then
                        replaceStandardIcon(pic)
                    end
                end
            end
        end
    end

    for weaponName, pick in pairs(scopeSkins) do
        -- The target's scope, or the plain one when only the owned skin has its own.
        local scopeConf = SCOPE_RETICLES[pick[1]]
            or (pick[2] and SCOPE_RETICLES[pick[2]] and SCOPE_RETICLES[weaponName])
        if scopeConf then
            local ii = mf:FindFirstChild("ItemInterfaces")
            local si = ii and ii:FindFirstChild(LP.Name .. " - " .. weaponName)
            local sc2 = si and si:FindFirstChild("Mouse") and si.Mouse:FindFirstChild("Scope")
            if sc2 then
                local bi = sc2:FindFirstChild("Blur") and sc2.Blur:FindFirstChild("ImageLabel")
                local ci = sc2:FindFirstChild("Circle") and sc2.Circle:FindFirstChild("ImageLabel")
                if bi and scopeConf.blur then writeImage(bi, scopeConf.blur) end
                if ci and scopeConf.circle then writeImage(ci, scopeConf.circle) end
            end
        end
    end
end

pcall(function()
    if not ENABLE_PERSISTENT_FEATURES then return end
    renderSteppedConn = runService.RenderStepped:Connect(fastSyncGui)
end)

pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        if not ENABLE_PERSISTENT_FEATURES then return end
        pgDescConn = pg.DescendantAdded:Connect(function(d)
            if d.ClassName == "ImageLabel" or d.ClassName == "ImageButton" then
                replaceStandardIcon(d)
                if d.Name == "Icon" and d.Parent and d.Parent.ClassName == "Frame" then
                    local wName = d.Parent.Name
                    local skinTarget = ACTIVE_CONFIG_SKINS[wName]
                    if skinTarget then
                        local skinIcon = ITEM_ICONS[wName] and (ITEM_ICONS[wName][skinTarget] or ITEM_ICONS[wName][skinTarget:lower()])
                        if skinIcon then
                            writeImage(d, skinIcon)
                        end
                    end
                end
            end
        end)
    end
end)

-- Wraps
local function readWrapPairs()
    local list, seen = {}, {}

    for _, p in ipairs(configWrapPairs) do
        if not seen[p[1]] then
            seen[p[1]] = true
            list[#list + 1] = p
        end
    end
    for _, p in ipairs({"rivals_wraps.lua", "rivals_wraps.txt", "workspace/rivals_wraps.lua", "workspace/rivals_wraps.txt"}) do
        local okE, exists = pcall(isfile, p)
        if okE and exists then
            local okR, content = pcall(readfile, p)
            if okR and content then
                for line in content:gmatch("[^\r\n]+") do

                    local owned, target = line:match("^%s*([^=%-][^=]-)%s*=%s*(.-)%s*$")
                    if owned and target and target ~= "" and not seen[owned] then
                        seen[owned] = true
                        list[#list + 1] = {owned, target}
                    end
                end
                break
            end
        end
    end
    return list
end

-- Skybox
local SKYBOX_PRESETS = {
    ["blue"] = {"14147881792", "14147882149", "14147882761", "14147883091", "14147882405", "14147881297"},
    ["station"] = {"2108482005", "2108545280", "2108482231", "2108482395", "2108482542", "2108482676"},
    ["graveyard"] = {"135908632589654", "103020541883227", "135908632589654", "135908632589654", "135908632589654", "72960281658487"},
    ["sudden death"] = {"84214501374682", "89972436184102", "84214501374682", "84214501374682", "84214501374682", "92138082970751"},
    ["space"] = {"10196550937", "10196550667", "10196550367", "10196550128", "10196549902", "10196567794"},
    ["westown"] = {"12261809766", "12261813110", "12261809766", "12261809766", "12261809766", "12261813678"},
    ["black"] = {"91612392386438", "91612392386438", "91612392386438", "91612392386438", "91612392386438", "91612392386438"},
    -- Uploaded skybox packs (tools/skies in the site repo), bk, dn, ft, lf, rt, up.
    ["cloudy 01"] = {"126754633897436", "86836627001306", "95905829433933", "122177936450348", "73237790687889", "90043570165995"},
    ["cloudy 02"] = {"94510925134380", "83533436371824", "98229751924468", "106855992262577", "71111483218129", "119866829919660"},
    ["cloudy 03"] = {"134908890676304", "98162794332047", "125777961418491", "109989177196148", "137809355685720", "114251179295721"},
    ["cloudy 04"] = {"107504801883128", "100991020543969", "73636039679787", "110786702878669", "82663836073959", "112042298121106"},
    ["cloudy 05"] = {"79487977466864", "90350734201812", "101510283118396", "102883759888031", "120175709830675", "136284198010930"},
    ["cloudy 06"] = {"133455855232355", "75675276221409", "102683810113255", "134026356692589", "111492255033052", "101979509281748"},
    ["cloudy 07"] = {"124630411829214", "137650278511829", "94482967698658", "103953753436574", "112959082352845", "137140884144826"},
    ["cloudy 08"] = {"90205622288987", "110151968622887", "104626178246233", "91598099503456", "81058694870129", "93729434721830"},
    ["cloudy 09"] = {"139434321199889", "98219516871257", "105913104685597", "125324169983163", "116997570198371", "103330194362875"},
    ["cloudy 10"] = {"81449501205294", "124487320003897", "80904431050447", "86646953803917", "75263551301936", "97788349971545"},
    ["cloudy 11"] = {"120871881275722", "127341735225402", "116601891103440", "94491027998722", "88353388175296", "91160816562958"},
    ["cloudy 12"] = {"113535280016994", "127900371948747", "120725193588788", "111770429925795", "129196586387140", "79378495098669"},
    ["cloudy 13"] = {"108831654470087", "79181118455270", "112187446252336", "104704362496407", "140447704903267", "71772855934062"},
    ["cloudy 14"] = {"105093562532797", "85003418570488", "131779651921685", "70609184831645", "86282293662867", "134608849387985"},
    ["cloudy 15"] = {"131536188889612", "118093331916732", "107336475861306", "110056465107774", "105163681975273", "92081035276480"},
    ["cloudy 16"] = {"109782717368475", "76246782640274", "121489338023768", "105948832901369", "115101533846700", "114420609506473"},
    ["cloudy 17"] = {"88662414547866", "110554210020228", "88313273447587", "134665095359798", "90541216303413", "121014099637227"},
    ["cloudy 18"] = {"106360292691579", "103249577541997", "110484795494314", "129304457043156", "114083127638311", "78124003378079"},
    ["cloudy 19"] = {"115116233569094", "133685857606690", "95607439806027", "93689502105544", "128807133605420", "111228278131898"},
    ["cloudy 20"] = {"124208488902038", "91200268945217", "111384709364077", "140170044783927", "118024637233382", "111697448595697"},
    ["cloudy 21"] = {"104201550309251", "117677338325723", "78563702293497", "120997393510904", "103388622930665", "89839615332589"},
    ["cloudy 22"] = {"74892504537101", "88612926659487", "79034090244073", "71664566729417", "134540865217875", "127631258082669"},
    ["cloudy 23"] = {"119599708543402", "83824957038386", "122253064867736", "82619654415458", "100939349583458", "74891504302768"},
    ["cloudy 24"] = {"121378533477721", "117082750895246", "115547003946313", "121390352061507", "79982218533687", "72692515998179"},
    ["cloudy 25"] = {"83309474203162", "124498349051494", "134496968945569", "107851671443849", "85866561501104", "78405144176503"},
    ["aurora"] = {"82352303427137", "96955417930238", "70693009382116", "92323947198095", "101484321631706", "127098348323271"},
    ["beautiful"] = {"116672032304016", "95474895156007", "117254687878540", "123939119810944", "79800107437752", "111449085724360"},
    ["black hole"] = {"116504252512407", "121192434046906", "93140195195460", "126158825072453", "108152937067748", "120737673672733"},
    ["blue sky"] = {"111226335375496", "70698080470589", "135460470760231", "108364190494169", "102401408407259", "84913859761300"},
    ["broken sky"] = {"140318382500274", "70376747543189", "122572758833753", "81796529025721", "130970680489698", "127489560502180"},
    ["castle grounds"] = {"132684157632736", "75871520273888", "123610654088356", "81901114515968", "125953193051791", "127486891652478"},
    ["chill gray"] = {"77842177495110", "114334349985521", "73085498719543", "86536487540867", "84114373463358", "82808825050309"},
    ["chill pink"] = {"118254399894024", "85716664023514", "85009657482785", "131849586353390", "104031429125910", "134439405617170"},
    ["chroma key"] = {"90442722159154", "101767999901114", "135103395168302", "81361144661403", "120260457258062", "106801842629627"},
    ["clear skies"] = {"131604034085442", "124442772007488", "112131474227507", "122804241917136", "124902787794157", "78411342576386"},
    ["cyan"] = {"128656160498159", "118751508340898", "105253548774950", "128681770617915", "90450225168968", "80720430106936"},
    ["dead star forest"] = {"132669969757222", "83257816122732", "107514798824659", "79329572889354", "120138393789020", "99834020318151"},
    ["elegant morning"] = {"136596483616545", "71044316590502", "104097006599780", "125119298107295", "78607773761530", "114308879347225"},
    ["emo"] = {"102057353520404", "116942968724467", "130364322644635", "129139815007127", "103930352896233", "88432806535250"},
    ["fade blue"] = {"70733763806586", "109278040786728", "82544751736691", "94758701607223", "84907768047806", "92504584784302"},
    ["forest"] = {"130105943383590", "87400440640257", "128128579477883", "71462749755980", "88253495750932", "134930785824238"},
    ["galaxy"] = {"84129238345796", "103265672483730", "111177857256367", "136671627884048", "112973201740035", "79105441573587"},
    ["goodnight"] = {"74147707477322", "104523964090186", "122795694381170", "132165510807421", "97017409517063", "104070547512626"},
    ["grimnight"] = {"102210941854270", "100071765140291", "89968755628817", "74976196740154", "98509116093327", "139554813054186"},
    ["hades"] = {"80609197077607", "134171614722360", "138791372904720", "81411466729497", "126710749167136", "73236105065482"},
    ["hazy"] = {"83761265032166", "95296355231411", "127921746808314", "87116530681623", "124355925636828", "116541187345656"},
    ["jungle"] = {"80590623005999", "131910954278674", "107456602072991", "84324211182348", "129168150784414", "81963990472289"},
    ["light blue"] = {"118414702738976", "122597975638493", "124870258148165", "112730907758242", "126654131576636", "117444670288097"},
    ["light pink"] = {"139223053439707", "103995147942567", "99465211065402", "102235997947203", "110149967143852", "100057183813215"},
    ["minecraft end"] = {"116945895581974", "78722265045527", "134800311806353", "88177582544328", "75599829998976", "104125293164860"},
    ["minecraft"] = {"114454130916729", "109548025240626", "130020938273317", "110272487224075", "136239019000790", "81171956837775"},
    ["moonlight"] = {"98895094117807", "98962847961441", "134374834765126", "128874794490495", "138146075324352", "128466147827573"},
    ["blue nebula"] = {"86686245579171", "108113096612020", "81877733877143", "119128617757798", "128328409316361", "102542960042748"},
    ["gold nebula"] = {"84095138366077", "77738459731844", "119092184893445", "137679633917616", "122487493876092", "103170638607510"},
    ["neon sky"] = {"110536311519381", "74820745224715", "109305772584204", "104093162456511", "120628751321359", "70629794155932"},
    ["neon sky 2"] = {"117695973144304", "96687214728525", "107244237325558", "79853143003679", "103164363708800", "80287143613038"},
    ["night"] = {"111506849899115", "111624859236839", "85274575738080", "125290741835689", "113064117603145", "131125584492971"},
    ["night sky moon"] = {"112908838333749", "88106974251525", "95077927902336", "103082598474272", "126296579988260", "136018257995007"},
    ["northern lights"] = {"135667725269914", "105659975445493", "139686226882630", "103053836788988", "133783036950754", "131678127881562"},
    ["oblivion"] = {"96685133253614", "86123661388551", "124862863981581", "116092220825677", "138516114089401", "82914065543123"},
    ["orange"] = {"138978746667522", "95283566510780", "102907453647408", "109462964348020", "120987252565412", "133626741339263"},
    ["overcast"] = {"99870262630210", "93059109878338", "72163615129668", "109874952315586", "127298432525460", "86261531752900"},
    ["pandora"] = {"110311863780960", "124328705240454", "133885444367306", "83902983588286", "135627944664931", "80639059541487"},
    ["peaceful morning"] = {"80744984797601", "139160805974232", "86848296784362", "84785420334318", "112196955715008", "90763575016985"},
    ["pink sunrise"] = {"94014428698610", "113515710394443", "92061586341960", "97121838959073", "140530693929389", "94028327724496"},
    ["pumpkin hill"] = {"129716677007306", "124105363416376", "105971182728755", "89198494997022", "138716194235633", "84890062729003"},
    ["purple nebula"] = {"75026396953993", "99796459631730", "115194314582283", "116461720353785", "75882647617429", "86759680720821"},
    ["red"] = {"81671840129096", "95334302882082", "118809384240080", "81331903433727", "86424558511460", "124960075039840"},
    ["setting sun"] = {"111401606618381", "123413205062436", "123294723748917", "111859405551319", "136486797861154", "105783476050536"},
    ["sfoth"] = {"134938753015290", "115871984730647", "129890749688631", "139637924732127", "131258245002931", "120078593797661"},
    ["shiverfrost"] = {"109671844082146", "76699561795262", "74660081943856", "88233310916948", "121911031322655", "84001786617208"},
    ["sky 05"] = {"115023392465265", "75603771116960", "78650451282536", "139249932495923", "109204323592662", "78606335131166"},
    ["sky 13"] = {"82376944970913", "93258366205385", "117596344693687", "109213974819587", "93314873685454", "111780089442621"},
    ["sky 22"] = {"136007365598982", "113090853463695", "102781864501443", "86334871447680", "129595274224805", "87293939325159"},
    ["sky 31"] = {"112473313859415", "119563752872717", "84283685338061", "134249301389168", "84283059059446", "102509841088734"},
    ["sky 38"] = {"85926227746329", "109924332182419", "134503258168834", "107319881513601", "115465032587932", "140683409884042"},
    ["sky 47"] = {"92328573760216", "134440566308824", "91601437949085", "104367884785983", "77798112301231", "110687721781978"},
    ["disaster"] = {"137160574941336", "102081467095261", "103689251646919", "102821281425724", "120985841295097", "136071964183254"},
    ["nibiru"] = {"86777970883943", "78763305966371", "114611372007819", "128061927873372", "85771331520419", "97909107363558"},
    ["sky purple"] = {"100569279835430", "92953290387081", "128755780823612", "133226682664457", "93855588590700", "127394092345028"},
    ["sky sunset"] = {"140082532251676", "103439208027471", "139582216083282", "113085611483648", "117039129859641", "82063345800656"},
    ["sky 2006"] = {"108049587733516", "90827876928083", "88528160176232", "132704699369288", "120394575432100", "120102414361858"},
    ["space blue"] = {"119997319906862", "86627772038606", "107221202344783", "110202674373451", "136027305730732", "108280367323622"},
    ["spooky"] = {"91607656582731", "99188944117258", "72879878113173", "127320958969849", "85021430483699", "124093998930865"},
    ["sunny sky"] = {"110554184501744", "98230875632640", "102338421528132", "90545823496973", "85347898526250", "90004379021835"},
    ["universe"] = {"109782613665358", "91334243969431", "85256564797442", "71131512684325", "108186194320722", "103590433878590"},
    ["utter east"] = {"92625772015085", "133826037116886", "122990386269233", "134162842602682", "121655127580859", "132800848916708"},
    ["whomp fortress"] = {"102494717825947", "101497319167422", "134923413288202", "79580117155905", "135186735517033", "109014827889452"},
    ["winterness"] = {"93314155085684", "86544552740075", "82163169918498", "113463592358754", "89545353728911", "112700328026196"},
    ["xen"] = {"138521026317896", "93370270064161", "77429040495782", "124709280024255", "117416468013692", "98120283931640"},
    ["zen end"] = {"109470247657976", "118949631704099", "122702664050796", "139189653780112", "125062544262187", "85640581945708"},
    ["classic"] = {"rbxasset://sky/sky512_bk.tex", "rbxasset://sky/sky512_dn.tex", "rbxasset://sky/sky512_ft.tex",
                   "rbxasset://sky/sky512_lf.tex", "rbxasset://sky/sky512_rt.tex", "rbxasset://sky/sky512_up.tex"}
}
local SKYBOX_FACES = {{"bk", 0xe8}, {"dn", 0x118}, {"ft", 0x148}, {"lf", 0x178}, {"rt", 0x1a8}, {"up", 0x1d8}}

local function skyboxAssetId(v)
    v = tostring(v):match("^%s*(.-)%s*$")
    if v:find("://") then return v end
    local digits = v:match("^(%d+)$")
    return digits and ("rbxassetid://" .. digits) or nil
end

local function writeRobloxString(base, str)
    local ptr, cap = rd(base), mrd("uint64_t", base + 24)
    if not ptr or not cap or ptr < 0x10000 or #str > cap then return false end
    for i = 1, #str do mwr("uint8_t", ptr + i - 1, string.byte(str, i)) end
    mwr("uint8_t", ptr + #str, 0)
    mwr("uint64_t", base + 16, #str)
    return true
end

local function applySkybox(conf)
    local ids = {}
    local preset = conf.preset or conf.skybox or conf.name
    -- "gray" is Roblox's DebugSkyGray render flag, not a set of images: it
    -- greys the sky at once, on every map. Any other choice turns it off.
    local gray = preset and tostring(preset):lower() == "gray"
    if type(setfflag) == "function" then pcall(setfflag, "DebugSkyGray", gray and 1 or 0) end
    if gray then return 0, "gray sky on - shows straight away" end
    if preset then
        local p = SKYBOX_PRESETS[tostring(preset):lower()]
        if not p then return 0, "unknown skybox preset '" .. tostring(preset) .. "'" end
        for i, v in ipairs(p) do ids[i] = skyboxAssetId(v) end
    end
    local all = conf.all and skyboxAssetId(conf.all)
    if all then for i = 1, 6 do ids[i] = all end end
    for i, f in ipairs(SKYBOX_FACES) do
        local one = conf[f[1]] and skyboxAssetId(conf[f[1]])
        if one then ids[i] = one end
    end

    local given = 0
    for i = 1, 6 do if ids[i] then given = given + 1 end end
    if given == 0 then return 0, nil end

    local skies, seen = {}, {}
    local function add(inst)
        if inst and inst.ClassName == "Sky" and inst.Address and not seen[inst.Address] then
            seen[inst.Address] = true
            skies[#skies + 1] = inst
        end
    end
    local roots = {}
    local playerScripts = LP:FindFirstChild("PlayerScripts")
    local starterScripts = game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts")

    if playerScripts then roots[#roots + 1] = playerScripts end
    if starterScripts then roots[#roots + 1] = starterScripts end
    for _, root in ipairs(roots) do
        for _, sub in ipairs({"Assets", "Modules"}) do
            local folder = root:FindFirstChild(sub)
            local profiles = folder and folder:FindFirstChild("LightingProfiles")
            for _, prof in ipairs(profiles and profiles:GetChildren() or {}) do
                for _, c in ipairs(prof:GetChildren()) do add(c) end
            end
        end
    end

    if not playerScripts then
        for _, d in ipairs(LP:GetDescendants()) do
            local profiles = d.Parent and d.Parent.Parent
            if profiles and profiles.Name == "LightingProfiles" then add(d) end
        end
    end
    for _, c in ipairs(game:GetService("Lighting"):GetChildren()) do add(c) end

    local patched, skipped = 0, 0
    for _, d in ipairs(skies) do
        local ok = 0
        for i, f in ipairs(SKYBOX_FACES) do
            if ids[i] and writeRobloxString(d.Address + f[2], ids[i]) then ok = ok + 1 end
        end
        if ok == given then patched = patched + 1 else skipped = skipped + 1 end
    end
    if patched == 0 then return 0, "no sky templates found" end
    return patched, (skipped > 0) and (skipped .. " sky templates were left alone (id too long for the game's buffer)") or nil
end

-- Hit, headshot and kill sounds
-- ClientViewModel.PlayHitmarkerSound hands plain string constants to
-- CreateSound: "...13110130082" on a body hit, "...16537449730" layered with
-- "...16537337310" on a headshot. Kill sounds come from
-- SoundLibrary.EliminationSounds. Luau interns strings, so each id is a
-- single object, and SoundLibrary lists all of them (AlwaysPreload,
-- EliminationSounds) - that is how they are found. Rewriting an object's
-- text changes what the next CreateSound plays. Each sits in a 56-byte
-- block: text at +24, length at +20, room for 31 characters.
local SOUND_TARGETS = {
    ["rbxassetid://13110130082"] = "hit",
    ["rbxassetid://16537449730"] = "critical",
    ["rbxassetid://16537337310"] = "criticallayer",
    ["rbxassetid://16530229616"] = "kill",
    ["rbxassetid://16530229541"] = "kill",
    ["rbxassetid://16530229695"] = "kill",
}
local SOUND_TEXT_MAX, SOUND_LEN, TAG_STRING = 31, 20, 6

-- nil = keep the game's sound, "" = silence, false = not usable.
local function soundText(v)
    v = tostring(v):match("^%s*(.-)%s*$")
    local low = v:lower()
    if low == "" or low == "default" then return nil end
    if low == "none" or low == "mute" or low == "off" then return "" end
    local id = skyboxAssetId(v)
    if id and #id <= SOUND_TEXT_MAX then return id end
    return false
end

local function writeLuaString(ts, text)
    if #text > SOUND_TEXT_MAX then return false end
    for i = 1, #text do mwr("byte", ts + STRING_DATA + i - 1, string.byte(text, i)) end
    mwr("byte", ts + STRING_DATA + #text, 0)
    mwr("int", ts + SOUND_LEN, #text)
    return true
end

local function collectSoundStrings(out, tbl, depth)
    local size, arr = rint(tbl + 8), rd(tbl + ROUTE.array)
    if not size or not arr or size < 1 or size > 256 or arr < 0x10000 then return end
    for i = 0, size - 1 do
        local v = arr + i * 16
        local tag, p = rint(v + 12), rd(v)
        if tag == TAG_STRING and p and p > 0x10000 then
            local ok, s = pcall(mrd, "string", p + STRING_DATA)
            if ok and SOUND_TARGETS[s] then out[s] = p end
        elseif tag == TAG_TABLE and depth > 0 and p and p > 0x10000 then
            collectSoundStrings(out, p, depth - 1)
        end
    end
end

local function applySounds(conf)
    -- Put back the text the last run wrote, where it is still ours.
    local prev = _G.__RIVALS_SOUND_STATE
    _G.__RIVALS_SOUND_STATE = nil
    for _, r in ipairs(type(prev) == "table" and prev.restores or {}) do
        local ok, now = pcall(mrd, "string", r[1] + STRING_DATA)
        if ok and now == r[3] then writeLuaString(r[1], r[2]) end
    end

    local want, bad = {}, {}
    for key, value in pairs(conf) do
        if key == "hit" or key == "critical" or key == "kill" then
            local text = soundText(value)
            if text == false then
                bad[#bad + 1] = key .. "=" .. tostring(value)
            elseif text then
                want[key] = text
            end
        end
    end
    -- A custom headshot replaces the layered pair, so its second layer goes quiet.
    if want.critical then want.criticallayer = "" end
    if not next(want) then return 0, (#bad > 0) and ("not an audio id: " .. table.concat(bad, ", ")) or nil end

    local modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    local f = nodesOf(moduleTable(modules and modules:FindFirstChild("SoundLibrary")), 64,
        {AlwaysPreload = true, EliminationSounds = true})
    local found = {}
    for _, node in pairs(f or {}) do
        local t = rd(node)
        if t and t > 0x10000 then collectSoundStrings(found, t, 1) end
    end

    local restores, changed = {}, 0
    for original, ts in pairs(found) do
        local text = want[SOUND_TARGETS[original]]
        if text and writeLuaString(ts, text) then
            restores[#restores + 1] = {ts, original, text}
            changed = changed + 1
        end
    end
    _G.__RIVALS_SOUND_STATE = {restores = restores}
    if changed == 0 then
        return 0, "sounds not found - rejoin if an earlier run already changed them"
    end
    return changed, (#bad > 0) and ("not an audio id: " .. table.concat(bad, ", ")) or nil
end

-- Sound volume. Every audio file has its own loudness while Rivals plays each
-- at a fixed volume, so custom sounds come out louder or quieter. The game
-- creates each hit, headshot and kill sound fresh, parented to the script
-- that plays it (ClientViewModel for hits, EliminationSlots for kills); a
-- light watcher scales new ones by the chosen multiplier. Volume is the float
-- at +0x120 of a Sound.
local SOUND_VOLUME_OFF = 0x120
local DEFAULT_SOUND_TEXT = {
    hit = {"rbxassetid://13110130082"},
    critical = {"rbxassetid://16537449730"},
    kill = {"rbxassetid://16530229616", "rbxassetid://16530229541", "rbxassetid://16530229695"},
}

local function startVolumeWatcher(conf)
    _G.__RIVALS_SOUND_WATCH = (_G.__RIVALS_SOUND_WATCH or 0) + 1
    local token = _G.__RIVALS_SOUND_WATCH
    local gains = {}
    for _, slot in ipairs({"hit", "critical", "kill"}) do
        local g = tonumber(tostring(conf[slot .. "volume"] or ""):match("[%d%.]+"))
        if g then
            if g > 5 then g = g / 100 end  -- "150" means 150%
            g = math.clamp(g, 0, 5)
            if g ~= 1 then
                local custom = soundText(conf[slot] or "")
                local texts = custom and custom ~= "" and {custom} or DEFAULT_SOUND_TEXT[slot]
                for _, t in ipairs(texts) do gains[t] = g end
            end
        end
    end
    if not next(gains) then return 0 end

    local fighter = LP.PlayerScripts:FindFirstChild("Modules")
    fighter = fighter and fighter:FindFirstChild("ClientReplicatedClasses")
    fighter = fighter and fighter:FindFirstChild("ClientFighter")
    local item = fighter and fighter:FindFirstChild("ClientItem")
    local ui = fighter and fighter:FindFirstChild("FighterInterface")
    local parents = {item and item:FindFirstChild("ClientViewModel"), ui and ui:FindFirstChild("EliminationSlots")}
    -- A Heartbeat connection rather than a spawned loop: Matcha stops resuming
    -- a thread's task.wait once the changer run that spawned it has ended.
    if _G.__RIVALS_SOUND_CONN then pcall(function() _G.__RIVALS_SOUND_CONN:Disconnect() end) end
    local seen = {}
    _G.__RIVALS_SOUND_CONN = game:GetService("RunService").Heartbeat:Connect(function()
        if _G.__RIVALS_SOUND_WATCH ~= token then return end
        local now = tick()
        for _, parent in ipairs(parents) do
            if parent then
                for _, s in ipairs(parent:GetChildren()) do
                    local a = s.ClassName == "Sound" and s.Address
                    if a and not seen[a] then
                        seen[a] = now
                        local ok, text = pcall(mrd, "string", rd(a + 0xb8))
                        local g = ok and gains[text]
                        if g then
                            local v = mrd("float", a + SOUND_VOLUME_OFF)
                            if v then mwr("float", a + SOUND_VOLUME_OFF, v * g) end
                        end
                    end
                end
            end
        end
        -- Sounds live at most 10 s; forget old ones so a reused address counts again.
        for a, t in pairs(seen) do if now - t > 15 then seen[a] = nil end end
    end)
    local n = 0
    for _ in pairs(gains) do n = n + 1 end
    return n
end

-- Spoof: your name, level, streak and badges as you see them. The server keeps
-- the real ones, so only your screen changes - except Device, which is sent to
-- the server and shows to everyone.
--
-- A label only redraws when the game sets its text (the glyphs are laid out
-- right then), so rewriting a label's text in memory never shows properly.
-- Instead the values are changed where the game reads them: your player's
-- DisplayName (for every nametag, player list entry and profile it builds from
-- then on) and the attributes it draws level, streak, ELO and badges from. The
-- profile card's level and rank come from the server when it opens, so those
-- stay real, and so does the @username (your account name).
local SPOOF_ATTRS = {
    level = "Level", streak = "StatisticDuelsWinStreak", elo = "DisplayELO",
    influencer = "IsInfluencer", employee = "IsRobloxEmployee", trustworthy = "IsTrustWorthy",
    -- The name effect (gold Prime, purple Contraband) on the nametag, player
    -- list and profile: the game draws it from this attribute.
    effect = "PlayerStatus",
}
local NAME_EFFECTS = {prime = "Prime", gold = "Prime", contraband = "Contraband", purple = "Contraband",
    none = "", off = "", ["false"] = ""}
local SPOOF_STATS = {level = "Level", streak = "Win Streak", elo = "Current ELO"}
local DISPLAY_NAME_OFF = 0x128 -- Player.DisplayName, a std::string
local GLYPHS, GLYPHS_END, GLYPH_SIZE = 0xc18, 0xc20, 56 -- laid-out glyphs, codepoint at +12
local SPOOF_REAL_FILE = "rivals_spoof_real.txt"
local DEVICES = {mousekeyboard = "MouseKeyboard", keyboard = "MouseKeyboard", pc = "MouseKeyboard",
    touch = "Touch", mobile = "Touch", gamepad = "Gamepad", controller = "Gamepad", vr = "VR"}

local function readStdString(a)
    local size, cap = rd(a + 16), rd(a + 24)
    if not size or not cap or size > 256 or cap < size then return nil end
    local p = cap > 15 and rd(a) or a
    local ok, s = pcall(mrd, "string", p)
    return ok and type(s) == "string" and s:sub(1, size) or nil
end
local function writeStdString(a, text)
    local cap = rd(a + 24)
    if not cap or #text > cap then return false end
    local p = cap > 15 and rd(a) or a
    for i = 1, #text do mwr("byte", p + i - 1, string.byte(text, i)) end
    mwr("byte", p + #text, 0)
    wr(a + 16, #text)
    return true
end
-- What a label actually shows: its laid-out glyphs, as text.
local function shownText(label)
    local b, e = rd(label.Address + GLYPHS), rd(label.Address + GLYPHS_END)
    if not b or not e or e < b or e - b > GLYPH_SIZE * 64 then return nil end
    local out = {}
    for g = b, e - GLYPH_SIZE, GLYPH_SIZE do
        local cp = rint(g + 12)
        if cp ~= 0 then -- (0: padding left by patchGlyphs)
            if not cp or cp < 32 or cp > 126 then return nil end
            out[#out + 1] = string.char(cp)
        end
    end
    return table.concat(out)
end
-- The profile card sets its level and rank from the server each time it
-- opens, so the text can't be changed at the source. What can be changed is
-- the result: the laid-out glyphs (glyph index at +8, character at +12), which
-- is what gets drawn. Digits sit in order in the game's font, so a number
-- becomes another by swapping glyph indices; other characters are looked up
-- from glyphs already laid out on the card. It can't add glyphs, only reuse or
-- drop them, so the new text can't be longer than the old one.
local RANK_THRESHOLDS = {
    {0, "Bronze 1", "rbxassetid://106623367501544"}, {200, "Bronze 2", "rbxassetid://131795064007344"},
    {400, "Bronze 3", "rbxassetid://73543520622815"}, {600, "Silver 1", "rbxassetid://80716950169934"},
    {800, "Silver 2", "rbxassetid://136100661820261"}, {1000, "Silver 3", "rbxassetid://107898816876115"},
    {1200, "Gold 1", "rbxassetid://134520747948636"}, {1400, "Gold 2", "rbxassetid://114166096331502"},
    {1600, "Gold 3", "rbxassetid://90039594400813"}, {1800, "Platinum 1", "rbxassetid://133903971285645"},
    {2000, "Platinum 2", "rbxassetid://82834564754747"}, {2200, "Platinum 3", "rbxassetid://73345783863790"},
    {2400, "Diamond 1", "rbxassetid://113997689031026"}, {2600, "Diamond 2", "rbxassetid://88059506918419"},
    {2800, "Diamond 3", "rbxassetid://112183171942172"}, {3000, "Onyx 1", "rbxassetid://104871954739030"},
    {3200, "Onyx 2", "rbxassetid://109012386782238"}, {3400, "Onyx 3", "rbxassetid://127982903682334"},
    {3600, "Nemesis", "rbxassetid://116941545385923"},
}
local function rankFor(elo)
    local pick = RANK_THRESHOLDS[1]
    for _, r in ipairs(RANK_THRESHOLDS) do if elo >= r[1] then pick = r end end
    return pick[2], pick[3]
end
local function glyphList(label)
    local b, e = rd(label.Address + GLYPHS), rd(label.Address + GLYPHS_END)
    if not b or not e or e < b or e - b > GLYPH_SIZE * 64 then return nil end
    local list = {}
    for g = b, e - GLYPH_SIZE, GLYPH_SIZE do
        list[#list + 1] = {addr = g, width = rint(g + 4), glyph = rint(g + 8), cp = rint(g + 12)}
    end
    return list, b
end
-- Every label laid out on the card: its characters, their glyph index and
-- width (each glyph carries its advance; the game spaces text by it).
local function glyphMap(root)
    local map = {glyph = {}, labels = {}}
    for _, d in ipairs(root:GetDescendants()) do
        if d.ClassName == "TextLabel" then
            local widths = {}
            for _, g in ipairs(glyphList(d) or {}) do
                if g.cp and g.glyph and g.cp > 0 and g.cp < 128 then
                    local c = string.char(g.cp)
                    map.glyph[c] = g.glyph
                    widths[c] = g.width
                    local digit = g.cp - 48
                    if digit >= 0 and digit <= 9 then map.zero = g.glyph - digit end
                end
            end
            if next(widths) then map.labels[#map.labels + 1] = widths end
        end
    end
    -- Digits sit in order in the font.
    if map.zero then for dg = 0, 9 do map.glyph[tostring(dg)] = map.glyph[tostring(dg)] or map.zero + dg end end
    return map
end
-- A character's width at a label's size: its own if it has it, otherwise
-- another label's scaled by a character both have.
local function widthFor(c, own, map)
    if own[c] then return own[c] end
    -- (scaled by every character both have, so one narrow letter can't skew it)
    for _, other in ipairs(map.labels) do
        if other[c] then
            local mine, theirs = 0, 0
            for k, w in pairs(own) do
                if other[k] then mine, theirs = mine + w, theirs + other[k] end
            end
            if theirs > 0 then return math.floor(other[c] * mine / theirs + 0.5) end
        end
    end
    local sum, n = 0, 0
    for _, w in pairs(own) do sum, n = sum + w, n + 1 end
    return n > 0 and math.floor(sum / n + 0.5) or nil
end
-- Make a label show `text` by rewriting its glyphs. When the text can't be
-- shown (longer than the label's glyphs, or a character missing) the label is
-- cleared, or left as it is with `keep`.
local function patchGlyphs(label, text, map, keep)
    local list, b = glyphList(label)
    if not list or #list == 0 then return false end
    local shown = {}
    for _, g in ipairs(list) do
        if g.cp ~= 0 then shown[#shown + 1] = string.char(math.max(0, math.min(255, g.cp or 63))) end
    end
    if table.concat(shown) == text then return true end
    local ok = #text <= #list
    local own = {}
    for _, g in ipairs(list) do
        if g.cp and g.cp > 0 and g.cp < 128 then own[string.char(g.cp)] = g.width end
    end
    local glyphs, widths = {}, {}
    for i = 1, ok and #text or 0 do
        local c = text:sub(i, i)
        glyphs[i], widths[i] = map.glyph[c], widthFor(c, own, map)
        if not glyphs[i] or not widths[i] then ok = false end
    end
    if not ok then
        if not keep then wr(label.Address + GLYPHS_END, b) end -- nothing rather than the real value
        return false
    end
    -- The glyph count can't shrink (the game puts the end back), so spare
    -- glyphs go first as zero-width copies of the first character: drawn
    -- exactly on top of it, they don't show.
    local pad = #list - #text
    -- Checked again right before writing: a label laid out again (or gone)
    -- since it was read must not be written into.
    local b2, e2 = rd(label.Address + GLYPHS), rd(label.Address + GLYPHS_END)
    if b2 ~= b or e2 ~= b + #list * GLYPH_SIZE or rint(list[1].addr + 12) ~= list[1].cp then return false end
    for i = 1, #list do
        local j = i - pad
        mwr("int", list[i].addr + 4, j >= 1 and widths[j] or 0)
        mwr("int", list[i].addr + 8, glyphs[math.max(j, 1)])
        mwr("int", list[i].addr + 12, j >= 1 and string.byte(text, j) or 0)
    end
    return true
end
-- Two labels' character -> glyph tables are from the same font when every
-- character they share has the same glyph.
local function sameFont(a, b)
    local shared = 0
    for c, g in pairs(a) do
        if b[c] ~= nil then
            if b[c] ~= g then return false end
            shared = shared + 1
        end
    end
    return shared >= 2
end
-- Every label's glyphs under some roots, as {glyph = char -> index, widths}.
local function glyphSamples(roots)
    local out = {}
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if d.ClassName == "TextLabel" then
                local s = {glyph = {}, widths = {}}
                for _, g in ipairs(glyphList(d) or {}) do
                    if g.cp and g.glyph and g.cp > 32 and g.cp < 127 then
                        local c = string.char(g.cp)
                        s.glyph[c], s.widths[c] = g.glyph, g.width
                    end
                end
                if next(s.glyph) then out[#out + 1] = s end
            end
        end
    end
    return out
end
local function prettyNumber(n)
    local s = tostring(math.floor(n))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""))
end

local function spoofFlag(v)
    local low = tostring(v or ""):lower()
    if low == "true" or low == "1" or low == "on" or low == "yes" then return true end
    if low == "false" or low == "0" or low == "off" or low == "no" then return false end
    return nil
end

local function startSpoof(conf)
    _G.__RIVALS_SPOOF = (_G.__RIVALS_SPOOF or 0) + 1
    local token = _G.__RIVALS_SPOOF

    -- The real values, read once before anything is changed. The display name
    -- is also kept in a file: after a Matcha restart the player object may
    -- still carry a spoofed one.
    local real = _G.__RIVALS_SPOOF_REAL
    if not real or real.user ~= LP.Name then
        real = {user = LP.Name, attrs = {}, stats = {}}
        local okF, saved = pcall(readfile, SPOOF_REAL_FILE)
        local savedUser, savedName = (okF and type(saved) == "string" and saved or ""):match("^(.-)\n(.-)\n?$")
        if savedUser == LP.Name and savedName and savedName ~= "" then
            real.display = savedName
        else
            real.display = readStdString(LP.Address + DISPLAY_NAME_OFF)
            if real.display then pcall(writefile, SPOOF_REAL_FILE, LP.Name .. "\n" .. real.display .. "\n") end
        end
        for key, attr in pairs(SPOOF_ATTRS) do real.attrs[key] = LP:GetAttribute(attr) end
        real.effectRead = true
        local ls = LP:FindFirstChild("CustomLeaderstats")
        for key, stat in pairs(SPOOF_STATS) do
            local v = ls and ls:FindFirstChild(stat)
            if v then real.stats[key] = v.Value end
        end
        _G.__RIVALS_SPOOF_REAL = real
    end

    -- A record from before the effect existed has no real effect in it; none
    -- was spoofed then, so what the player has now is the real one. No effect
    -- is kept as "", which the game draws as nothing, so it can be put back.
    if not real.effectRead then
        real.attrs.effect, real.effectRead = LP:GetAttribute("PlayerStatus"), true
    end
    if real.attrs.effect == nil then real.attrs.effect = "" end

    local want = {
        effect = conf.effect and NAME_EFFECTS[tostring(conf.effect):lower():gsub("%s", "")],
        name = conf.name and conf.name ~= "" and conf.name or nil,
        user = conf.username and conf.username:gsub("^@", "") ~= "" and (conf.username:gsub("^@", "")) or nil,
        level = tonumber(conf.level), streak = tonumber(conf.streak), elo = tonumber(conf.elo),
        influencer = spoofFlag(conf.influencer), employee = spoofFlag(conf.employee),
        trustworthy = spoofFlag(conf.trustworthy),
    }
    local device = conf.device and DEVICES[conf.device:lower():gsub("[%s&/_-]", "")]
    local any = device ~= nil
    for _, v in pairs(want) do if v ~= nil then any = true end end

    -- The name the player object should carry; the field has room for as many
    -- characters as the real name's storage (15 for a short name).
    local notes = {}
    local shownName = want.name or real.display
    local nameCap = rd(LP.Address + DISPLAY_NAME_OFF + 24)
    if want.name and nameCap and #want.name > nameCap then
        notes[#notes + 1] = "name longer than " .. nameCap .. " characters - kept the real one"
        shownName = real.display
    end
    -- The @username is redrawn over the real one's glyphs, so it can't be
    -- longer than the real one.
    local realUser = "@" .. LP.Name
    local shownUser = want.user and "@" .. want.user or realUser
    if #shownUser > #realUser then
        notes[#notes + 1] = "username longer than " .. #LP.Name .. " characters - kept the real one"
        shownUser = realUser
    end

    local function applyValues()
        for key, attr in pairs(SPOOF_ATTRS) do
            local v = want[key]
            if v == nil then v = real.attrs[key] end
            if v ~= nil and LP:GetAttribute(attr) ~= v then pcall(LP.SetAttribute, LP, attr, v) end
        end
        local ls = LP:FindFirstChild("CustomLeaderstats")
        for key, stat in pairs(SPOOF_STATS) do
            local obj = ls and ls:FindFirstChild(stat)
            local v = want[key] or real.stats[key]
            if obj and v ~= nil and obj.Value ~= v then pcall(function() obj.Value = v end) end
        end
        if shownName and readStdString(LP.Address + DISPLAY_NAME_OFF) ~= shownName then
            writeStdString(LP.Address + DISPLAY_NAME_OFF, shownName)
            -- The nametag and player list set your name again (through the
            -- game, so it redraws) whenever PlayerStatus changes: change it
            -- and put it back.
            local status = LP:GetAttribute("PlayerStatus")
            pcall(LP.SetAttribute, LP, "PlayerStatus", status == nil and "" or nil)
            pcall(LP.SetAttribute, LP, "PlayerStatus", status)
        end
    end

    -- Your name reaches the nametag, player list and profile through the
    -- DisplayName above, whenever the game sets it (the nametag on every
    -- status change, the profile on every opening, the player list when your
    -- slot is made). Labels are never rewritten in memory for the name: the
    -- player list's name layers are destroyed and remade whenever it opens,
    -- and writing into one that just went away crashed the game.
    -- The @username is your account name, which the game gets from the
    -- server, so it can only be redrawn: its glyphs are swapped for the same
    -- font's (its text stays real - that is how your own profile card is told
    -- apart from others). Only on the nametag and profile card, which stay put.
    local lastHeal = 0
    local function mapFor(label, samples)
        local own = {}
        for _, g in ipairs(glyphList(label) or {}) do
            if g.cp and g.cp > 32 and g.cp < 127 then own[string.char(g.cp)] = g.glyph end
        end
        local map = {glyph = {}, labels = {}}
        for _, s in ipairs(samples) do
            if sameFont(own, s.glyph) then
                for c, g in pairs(s.glyph) do map.glyph[c] = map.glyph[c] or g end
                map.labels[#map.labels + 1] = s.widths
            end
        end
        return map
    end
    local function userSampleOf(label)
        local s = {glyph = {}, widths = {}}
        for _, g in ipairs(glyphList(label) or {}) do
            if g.cp and g.cp > 32 and g.cp < 127 then
                s.glyph[string.char(g.cp)], s.widths[string.char(g.cp)] = g.glyph, g.width
            end
        end
        return s
    end
    local function heal()
        local char = workspace:FindFirstChild(LP.Name)
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local tag = hrp and hrp:FindFirstChild("NametagGui")
        if not tag then return end
        local labels = {}
        for _, d in ipairs(tag:GetDescendants()) do
            if d.ClassName == "TextLabel" and d.Parent and d.Parent.Name ~= "_ITEMSTATUSCLONE" then
                local okT, text = pcall(function() return d.Text end)
                if okT and text == realUser then labels[#labels + 1] = d end
            end
        end
        for _, d in ipairs(labels) do
            local shows = shownText(d)
            if shows == realUser and not real.userSample then real.userSample = userSampleOf(d) end
            if shows and shows ~= shownUser then
                local samples = glyphSamples({tag})
                if real.userSample then table.insert(samples, 1, real.userSample) end
                -- (straight after, so the label can't have gone in between)
                if d.Parent then patchGlyphs(d, shownUser, mapFor(d, samples), true) end
            end
        end
    end

    local function pass()
        local now = tick()
        real.beat = now
        pcall(applyValues)
        if now - lastHeal > 3 then lastHeal = now; pcall(heal) end
    end

    -- The profile card keeps its frame between openings (parked in
    -- Assets.Temp.Pages while closed) and lays its text out again each time it
    -- opens, so it is checked every frame while it shows you.
    -- The page is only made the first time it opens in a server, straight
    -- into the open pages (MainFrame.Pages), and parked in Temp.Pages when
    -- closed; it is looked for in both until found.
    local parked, page
    pcall(function() parked = LP.PlayerScripts.Assets.Temp.Pages end)
    local wantLevel = want.level and prettyNumber(want.level)
    local wantRank, wantRankImage
    if want.elo then wantRank, wantRankImage = rankFor(want.elo) end
    local cardMap
    local function profilePass()
        if not (wantLevel or wantRank or shownUser ~= realUser) or not parked then return end
        if not page then
            page = parked:FindFirstChild("ViewProfile")
            if not page then
                local open = LP.PlayerGui:FindFirstChild("MainGui")
                open = open and open:FindFirstChild("MainFrame")
                open = open and open:FindFirstChild("Pages")
                page = open and open:FindFirstChild("ViewProfile")
            end
            if not page then return end
        end
        if page.Parent == parked then cardMap = nil return end -- closed
        local player = page:FindFirstChild("Active")
        player = player and player:FindFirstChild("Player")
        local user = player and player:FindFirstChild("Username")
        local okU, userText = pcall(function() return user.Text end)
        if not okU or userText ~= realUser then return end -- someone else's profile
        if not cardMap then
            if not real.userSample and shownText(user) == realUser then
                real.userSample = {glyph = {}, widths = {}}
                for _, g in ipairs(glyphList(user) or {}) do
                    if g.cp and g.cp > 32 and g.cp < 127 then
                        real.userSample.glyph[string.char(g.cp)] = g.glyph
                        real.userSample.widths[string.char(g.cp)] = g.width
                    end
                end
            end
            cardMap = glyphMap(page)
            if real.userSample then -- your real username's letters, to put it back
                for c, g in pairs(real.userSample.glyph) do cardMap.glyph[c] = cardMap.glyph[c] or g end
                cardMap.labels[#cardMap.labels + 1] = real.userSample.widths
            end
        end
        if shownText(user) ~= shownUser then patchGlyphs(user, shownUser, cardMap, true) end
        local bragging = player:FindFirstChild("Bragging")
        if not bragging then return end
        local level = bragging:FindFirstChild("Level")
        level = level and level:FindFirstChild("Value")
        if level and wantLevel then patchGlyphs(level, wantLevel, cardMap) end
        local rank = bragging:FindFirstChild("Rank")
        if rank and wantRank then
            local title = rank:FindFirstChild("Title")
            if title then patchGlyphs(title, wantRank, cardMap) end
            -- The icon's image, wherever the ImageLabel keeps it (images do
            -- redraw from memory, unlike text).
            local container = rank:FindFirstChild("Container")
            for _, d in ipairs(container and container:GetDescendants() or {}) do
                if d.ClassName == "ImageLabel" and d.Name == "Icon" then
                    for _, off in ipairs({IMG_OFF, 0xA18, 0xA10}) do
                        local current = readStdString(d.Address + off)
                        if current and current:find("^rbxasset") then
                            if current ~= wantRankImage then writeStdString(d.Address + off, wantRankImage) end
                            break
                        end
                    end
                end
            end
        end
    end

    -- Driven by Heartbeat, not a spawned loop: Matcha stops resuming a
    -- thread's task.wait once the changer run that spawned it has ended, while
    -- connections keep firing (the icon sync works the same way). The game can
    -- reset the attributes, so they are put back every half second.
    if _G.__RIVALS_SPOOF_CONN then pcall(function() _G.__RIVALS_SPOOF_CONN:Disconnect() end) end
    _G.__RIVALS_SPOOF_CONN = nil
    local okFirst, firstErr = pcall(pass) -- once now, so clearing it restores straight away
    if not okFirst then print("[RivalsSkinChanger] Spoof: " .. tostring(firstErr)) end
    if any then
        local lastRun, lastError = tick(), nil
        _G.__RIVALS_SPOOF_CONN = game:GetService("RunService").Heartbeat:Connect(function()
            if _G.__RIVALS_SPOOF ~= token then return end
            pcall(profilePass)
            local now = tick()
            if now - lastRun < 0.5 then return end
            lastRun = now
            -- One bad pass (a page closing mid-read) must not stop the next.
            local ok, err = pcall(pass)
            if not ok and tostring(err) ~= lastError then
                lastError = tostring(err)
                print("[RivalsSkinChanger] Spoof: " .. lastError)
            end
        end)
    end

    if device then
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local rep = remotes and remotes:FindFirstChild("Replication")
        local fighter = rep and rep:FindFirstChild("Fighter")
        local setControls = fighter and fighter:FindFirstChild("SetControls")
        local okF, err = false, "SetControls not found"
        if setControls then okF, err = pcall(function() setControls:FireServer(device) end) end
        notes[#notes + 1] = okF and ("device shown as " .. device)
            or ("device not changed (needs Matcha's Hybrid Mode): " .. tostring(err):sub(1, 60))
    end
    if want.name then notes[#notes + 1] = "the name shows on your nametag and profile; the Tab list keeps the real one until it remakes your slot (next join)" end
    return any, #notes > 0 and table.concat(notes, "; ") or nil
end

-- Lighting
local LIGHTING_FIELDS = {
    brightness = {off = 0x108, key = "Brightness"},
    exposure = {off = 0x114, key = "ExposureCompensation"},
    diffuse = {off = 0x10c, key = "EnvironmentDiffuseScale"},
    specular = {off = 0x110, key = "EnvironmentSpecularScale"},
    shadowsoftness = {off = nil, key = "ShadowSoftness"},
    ambient = {off = 0xc0, key = "Ambient", color = true},
    outdoor = {off = 0xf0, key = "OutdoorAmbient", color = true},
    fogcolor = {off = 0xe4, key = "FogColor", color = true}
}
local LIGHTING_PRESETS = {
    ["dark"] = {brightness = 0.35, exposure = -1.3, diffuse = 0.15, specular = 0.2, ambient = 0.02, outdoor = 0.03, fogcolor = 0.02},
    -- The game's own skies, tuned by hand to each sky's colours.
    ["blue"] = {brightness = 2.2, exposure = 0.1, diffuse = 1, specular = 1, ambient = "#4a4f58", outdoor = "#8a93a3", fogcolor = "#bfd2e8"},
    ["classic"] = {brightness = 2, exposure = 0, diffuse = 1, specular = 1, ambient = "#4c5058", outdoor = "#8c96a8", fogcolor = "#c0d0e8"},
    ["space"] = {brightness = 0.6, exposure = -0.5, diffuse = 1, specular = 1, ambient = "#1c1630", outdoor = "#3a2f5c", fogcolor = "#0c0918"},
    ["graveyard"] = {brightness = 0.8, exposure = -0.4, diffuse = 1, specular = 1, ambient = "#26302a", outdoor = "#46584c", fogcolor = "#3b4a40"},
    ["sudden death"] = {brightness = 1.2, exposure = -0.2, diffuse = 1, specular = 1, ambient = "#3a1c1c", outdoor = "#6e3434", fogcolor = "#7a2e2a"},
    ["station"] = {brightness = 1.8, exposure = 0, diffuse = 1, specular = 1, ambient = "#4a3a36", outdoor = "#8a6e66", fogcolor = "#d19a86"},
    ["westown"] = {brightness = 2.4, exposure = 0.15, diffuse = 1, specular = 1, ambient = "#554536", outdoor = "#9c8466", fogcolor = "#e0c29a"},
    ["black"] = {brightness = 0.35, exposure = -1.3, diffuse = 0.15, specular = 0.2, ambient = 0.02, outdoor = 0.03, fogcolor = 0.02},
    ["gray"] = {brightness = 1.6, exposure = -0.05, diffuse = 1, specular = 1, ambient = "#4a4a4a", outdoor = "#808080", fogcolor = "#9a9a9a"},
    -- One per uploaded sky, from its colours (tools/skies/lighting_from_skies.py).
    -- "Preset=match" picks the one named like the current skybox.
    ["cloudy 01"] = {brightness = 1.85, exposure = 0.05, diffuse = 1, specular = 1, ambient = "#443b39", outdoor = "#767278", fogcolor = "#aa8782"},
    ["cloudy 02"] = {brightness = 2.73, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#565149", outdoor = "#908c83", fogcolor = "#c9b89b"},
    ["cloudy 03"] = {brightness = 2.28, exposure = 0.27, diffuse = 1, specular = 1, ambient = "#4f4745", outdoor = "#908680", fogcolor = "#ac938b"},
    ["cloudy 04"] = {brightness = 2.52, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#4b5153", outdoor = "#7f8ea4", fogcolor = "#d7f0fd"},
    ["cloudy 05"] = {brightness = 2.41, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#484e51", outdoor = "#7d8ea7", fogcolor = "#cde8fa"},
    ["cloudy 06"] = {brightness = 1.95, exposure = 0.1, diffuse = 1, specular = 1, ambient = "#3b4045", outdoor = "#67799d", fogcolor = "#c7e4fb"},
    ["cloudy 07"] = {brightness = 2.12, exposure = 0.19, diffuse = 1, specular = 1, ambient = "#48434a", outdoor = "#847d91", fogcolor = "#cdb8d5"},
    ["cloudy 08"] = {brightness = 2.29, exposure = 0.27, diffuse = 1, specular = 1, ambient = "#494948", outdoor = "#838992", fogcolor = "#c7c8c3"},
    ["cloudy 09"] = {brightness = 2.01, exposure = 0.13, diffuse = 1, specular = 1, ambient = "#48412c", outdoor = "#7d7b76", fogcolor = "#b0994b"},
    ["cloudy 10"] = {brightness = 1.8, exposure = 0.03, diffuse = 1, specular = 1, ambient = "#3a3c3b", outdoor = "#6c7273", fogcolor = "#6c736f"},
    ["cloudy 11"] = {brightness = 1.21, exposure = -0.27, diffuse = 1, specular = 1, ambient = "#2e2842", outdoor = "#595073", fogcolor = "#5b4a97"},
    ["cloudy 12"] = {brightness = 1.05, exposure = -0.35, diffuse = 1, specular = 1, ambient = "#28262a", outdoor = "#4e4b5f", fogcolor = "#655b6c"},
    ["cloudy 13"] = {brightness = 1.83, exposure = 0.04, diffuse = 1, specular = 1, ambient = "#423b36", outdoor = "#7d7067", fogcolor = "#c2a692"},
    ["cloudy 14"] = {brightness = 2.01, exposure = 0.13, diffuse = 1, specular = 1, ambient = "#374539", outdoor = "#678271", fogcolor = "#8ccd96"},
    ["cloudy 15"] = {brightness = 0.91, exposure = -0.42, diffuse = 1, specular = 1, ambient = "#232229", outdoor = "#4c4544", fogcolor = "#3b374b"},
    ["cloudy 16"] = {brightness = 2.02, exposure = 0.14, diffuse = 1, specular = 1, ambient = "#41414d", outdoor = "#787a94", fogcolor = "#a9aadc"},
    ["cloudy 17"] = {brightness = 1.54, exposure = -0.1, diffuse = 1, specular = 1, ambient = "#433031", outdoor = "#72606c", fogcolor = "#ab696a"},
    ["cloudy 18"] = {brightness = 1.54, exposure = -0.1, diffuse = 1, specular = 1, ambient = "#353435", outdoor = "#60656f", fogcolor = "#928f93"},
    ["cloudy 19"] = {brightness = 1.55, exposure = -0.1, diffuse = 1, specular = 1, ambient = "#4a2f2d", outdoor = "#8b5b56", fogcolor = "#ac5753"},
    ["cloudy 20"] = {brightness = 2.44, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#4c4d55", outdoor = "#8b8c97", fogcolor = "#9597af"},
    ["cloudy 21"] = {brightness = 1.65, exposure = -0.05, diffuse = 1, specular = 1, ambient = "#4f3221", outdoor = "#856540", fogcolor = "#ab5928"},
    ["cloudy 22"] = {brightness = 1.23, exposure = -0.26, diffuse = 1, specular = 1, ambient = "#41271e", outdoor = "#744f3f", fogcolor = "#b05335"},
    ["cloudy 23"] = {brightness = 2.0, exposure = 0.13, diffuse = 1, specular = 1, ambient = "#493f41", outdoor = "#8f747d", fogcolor = "#c39aa4"},
    ["cloudy 24"] = {brightness = 2.3, exposure = 0.28, diffuse = 1, specular = 1, ambient = "#4c4947", outdoor = "#918787", fogcolor = "#9e938e"},
    ["cloudy 25"] = {brightness = 1.74, exposure = -0.0, diffuse = 1, specular = 1, ambient = "#3b393f", outdoor = "#706c7b", fogcolor = "#9791a6"},
    ["aurora"] = {brightness = 1.02, exposure = -0.36, diffuse = 1, specular = 1, ambient = "#182a23", outdoor = "#365340", fogcolor = "#2b7558"},
    ["beautiful"] = {brightness = 1.39, exposure = -0.18, diffuse = 1, specular = 1, ambient = "#203341", outdoor = "#2765b1", fogcolor = "#49a8ed"},
    ["black hole"] = {brightness = 1.17, exposure = -0.29, diffuse = 1, specular = 1, ambient = "#39261f", outdoor = "#6b4d43", fogcolor = "#75422c"},
    ["blue sky"] = {brightness = 2.43, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#3f505b", outdoor = "#6993b6", fogcolor = "#83bee6"},
    ["broken sky"] = {brightness = 2.68, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#505253", outdoor = "#8d8c8a", fogcolor = "#adb2b5"},
    ["castle grounds"] = {brightness = 2.14, exposure = 0.2, diffuse = 1, specular = 1, ambient = "#31485c", outdoor = "#4b8cb4", fogcolor = "#54a1e4"},
    ["chill gray"] = {brightness = 1.57, exposure = -0.09, diffuse = 1, specular = 1, ambient = "#333536", outdoor = "#636668", fogcolor = "#565b5d"},
    ["chill pink"] = {brightness = 1.67, exposure = -0.04, diffuse = 1, specular = 1, ambient = "#3e3546", outdoor = "#64698d", fogcolor = "#574467"},
    ["chroma key"] = {brightness = 2.69, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#1d671e", outdoor = "#31b034", fogcolor = "#00ff06"},
    ["clear skies"] = {brightness = 1.79, exposure = 0.02, diffuse = 1, specular = 1, ambient = "#373c3f", outdoor = "#5a71aa", fogcolor = "#d0ebfd"},
    ["cyan"] = {brightness = 1.82, exposure = 0.04, diffuse = 1, specular = 1, ambient = "#343e40", outdoor = "#61767a", fogcolor = "#3e5256"},
    ["dead star forest"] = {brightness = 0.73, exposure = -0.5, diffuse = 1, specular = 1, ambient = "#211c23", outdoor = "#503842", fogcolor = "#1b151c"},
    ["elegant morning"] = {brightness = 2.17, exposure = 0.21, diffuse = 1, specular = 1, ambient = "#454648", outdoor = "#7f8389", fogcolor = "#989aa2"},
    ["emo"] = {brightness = 0.77, exposure = -0.49, diffuse = 1, specular = 1, ambient = "#1e1f22", outdoor = "#3d4048", fogcolor = "#16171b"},
    ["fade blue"] = {brightness = 2.49, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#43505f", outdoor = "#788fad", fogcolor = "#8fc1f6"},
    ["forest"] = {brightness = 2.05, exposure = 0.15, diffuse = 1, specular = 1, ambient = "#494236", outdoor = "#7e7d74", fogcolor = "#393124"},
    ["galaxy"] = {brightness = 0.5, exposure = -0.62, diffuse = 1, specular = 1, ambient = "#1b0f5b", outdoor = "#432493", fogcolor = "#07031f"},
    ["goodnight"] = {brightness = 0.96, exposure = -0.39, diffuse = 1, specular = 1, ambient = "#242141", outdoor = "#41448e", fogcolor = "#332d73"},
    ["grimnight"] = {brightness = 0.8, exposure = -0.47, diffuse = 1, specular = 1, ambient = "#1e2020", outdoor = "#3c4248", fogcolor = "#0b0c0c"},
    ["hades"] = {brightness = 0.61, exposure = -0.57, diffuse = 1, specular = 1, ambient = "#2e160d", outdoor = "#5d2e2c", fogcolor = "#9a3412"},
    ["hazy"] = {brightness = 1.02, exposure = -0.36, diffuse = 1, specular = 1, ambient = "#30241b", outdoor = "#514a47", fogcolor = "#885835"},
    ["jungle"] = {brightness = 1.87, exposure = 0.06, diffuse = 1, specular = 1, ambient = "#383f3b", outdoor = "#6b7678", fogcolor = "#415048"},
    ["light blue"] = {brightness = 1.93, exposure = 0.09, diffuse = 1, specular = 1, ambient = "#324249", outdoor = "#5e7b92", fogcolor = "#71b3ce"},
    ["light pink"] = {brightness = 1.53, exposure = -0.11, diffuse = 1, specular = 1, ambient = "#3d3040", outdoor = "#845879", fogcolor = "#be86cd"},
    ["minecraft end"] = {brightness = 0.59, exposure = -0.58, diffuse = 1, specular = 1, ambient = "#331032", outdoor = "#6b2458", fogcolor = "#140313"},
    ["minecraft"] = {brightness = 1.96, exposure = 0.11, diffuse = 1, specular = 1, ambient = "#40413b", outdoor = "#6a7a96", fogcolor = "#47493e"},
    ["moonlight"] = {brightness = 0.9, exposure = -0.42, diffuse = 1, specular = 1, ambient = "#18252a", outdoor = "#304b53", fogcolor = "#254d5e"},
    ["blue nebula"] = {brightness = 0.52, exposure = -0.61, diffuse = 1, specular = 1, ambient = "#101923", outdoor = "#23364b", fogcolor = "#060c12"},
    ["gold nebula"] = {brightness = 0.63, exposure = -0.56, diffuse = 1, specular = 1, ambient = "#211a13", outdoor = "#463728", fogcolor = "#130d07"},
    ["neon sky"] = {brightness = 1.25, exposure = -0.25, diffuse = 1, specular = 1, ambient = "#242c41", outdoor = "#4e5482", fogcolor = "#324779"},
    ["neon sky 2"] = {brightness = 0.97, exposure = -0.39, diffuse = 1, specular = 1, ambient = "#351d41", outdoor = "#374988", fogcolor = "#4a1d60"},
    ["night"] = {brightness = 0.83, exposure = -0.46, diffuse = 1, specular = 1, ambient = "#0f2431", outdoor = "#1f4968", fogcolor = "#06273c"},
    ["night sky moon"] = {brightness = 0.71, exposure = -0.52, diffuse = 1, specular = 1, ambient = "#141e2c", outdoor = "#303f4d", fogcolor = "#020407"},
    ["northern lights"] = {brightness = 0.98, exposure = -0.38, diffuse = 1, specular = 1, ambient = "#1c272a", outdoor = "#40449c", fogcolor = "#83dcf8"},
    ["oblivion"] = {brightness = 1.1, exposure = -0.32, diffuse = 1, specular = 1, ambient = "#2d2819", outdoor = "#525044", fogcolor = "#7c682d"},
    ["orange"] = {brightness = 1.56, exposure = -0.09, diffuse = 1, specular = 1, ambient = "#4b301c", outdoor = "#ac5539", fogcolor = "#c66920"},
    ["overcast"] = {brightness = 2.54, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#4a5155", outdoor = "#838e94", fogcolor = "#8aa0aa"},
    ["pandora"] = {brightness = 1.16, exposure = -0.29, diffuse = 1, specular = 1, ambient = "#1d2c38", outdoor = "#395393", fogcolor = "#4ea1e3"},
    ["peaceful morning"] = {brightness = 2.23, exposure = 0.24, diffuse = 1, specular = 1, ambient = "#474748", outdoor = "#808594", fogcolor = "#c9cacc"},
    ["pink sunrise"] = {brightness = 2.35, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#4e494f", outdoor = "#898a9b", fogcolor = "#b6a6b8"},
    ["pumpkin hill"] = {brightness = 1.24, exposure = -0.25, diffuse = 1, specular = 1, ambient = "#41271c", outdoor = "#82485e", fogcolor = "#813e22"},
    ["purple nebula"] = {brightness = 0.65, exposure = -0.55, diffuse = 1, specular = 1, ambient = "#26172a", outdoor = "#48325b", fogcolor = "#231027"},
    ["red"] = {brightness = 0.63, exposure = -0.56, diffuse = 1, specular = 1, ambient = "#2b1712", outdoor = "#54322d", fogcolor = "#682a1b"},
    ["setting sun"] = {brightness = 2.29, exposure = 0.27, diffuse = 1, specular = 1, ambient = "#5a453f", outdoor = "#98857d", fogcolor = "#c98874"},
    ["sfoth"] = {brightness = 1.34, exposure = -0.2, diffuse = 1, specular = 1, ambient = "#402b20", outdoor = "#924e3e", fogcolor = "#d37844"},
    ["shiverfrost"] = {brightness = 0.97, exposure = -0.39, diffuse = 1, specular = 1, ambient = "#21242e", outdoor = "#48494f", fogcolor = "#363d57"},
    ["sky 05"] = {brightness = 1.17, exposure = -0.29, diffuse = 1, specular = 1, ambient = "#2a2a28", outdoor = "#485560", fogcolor = "#c7cbbe"},
    ["sky 13"] = {brightness = 1.42, exposure = -0.16, diffuse = 1, specular = 1, ambient = "#322f40", outdoor = "#655a78", fogcolor = "#393552"},
    ["sky 22"] = {brightness = 1.67, exposure = -0.04, diffuse = 1, specular = 1, ambient = "#48342c", outdoor = "#7a675a", fogcolor = "#8a553f"},
    ["sky 31"] = {brightness = 1.46, exposure = -0.14, diffuse = 1, specular = 1, ambient = "#363040", outdoor = "#625e7c", fogcolor = "#7e679f"},
    ["sky 38"] = {brightness = 1.31, exposure = -0.22, diffuse = 1, specular = 1, ambient = "#2a2e32", outdoor = "#4c5b6e", fogcolor = "#657483"},
    ["sky 47"] = {brightness = 0.96, exposure = -0.39, diffuse = 1, specular = 1, ambient = "#2a231f", outdoor = "#4c4846", fogcolor = "#43332b"},
    ["disaster"] = {brightness = 0.88, exposure = -0.43, diffuse = 1, specular = 1, ambient = "#401922", outdoor = "#693a46", fogcolor = "#8d233a"},
    ["nibiru"] = {brightness = 1.18, exposure = -0.28, diffuse = 1, specular = 1, ambient = "#252a3b", outdoor = "#495371", fogcolor = "#5f73ba"},
    ["sky purple"] = {brightness = 1.68, exposure = -0.03, diffuse = 1, specular = 1, ambient = "#4b28a0", outdoor = "#9258b6", fogcolor = "#2a0f69"},
    ["sky sunset"] = {brightness = 1.56, exposure = -0.09, diffuse = 1, specular = 1, ambient = "#49302a", outdoor = "#745e80", fogcolor = "#7d4335"},
    ["sky 2006"] = {brightness = 2.86, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#4d525b", outdoor = "#918b8e", fogcolor = "#b9cbec"},
    ["space blue"] = {brightness = 0.73, exposure = -0.51, diffuse = 1, specular = 1, ambient = "#0e212a", outdoor = "#1c4557", fogcolor = "#062a3a"},
    ["spooky"] = {brightness = 1.19, exposure = -0.28, diffuse = 1, specular = 1, ambient = "#1e2e33", outdoor = "#435b3b", fogcolor = "#081114"},
    ["sunny sky"] = {brightness = 2.14, exposure = 0.2, diffuse = 1, specular = 1, ambient = "#444546", outdoor = "#7d8093", fogcolor = "#dde0e6"},
    ["universe"] = {brightness = 1.0, exposure = -0.37, diffuse = 1, specular = 1, ambient = "#3f1e20", outdoor = "#574652", fogcolor = "#99353b"},
    ["utter east"] = {brightness = 3.0, exposure = 0.3, diffuse = 1, specular = 1, ambient = "#5d4f47", outdoor = "#938b88", fogcolor = "#bf957d"},
    ["whomp fortress"] = {brightness = 0.98, exposure = -0.38, diffuse = 1, specular = 1, ambient = "#1f2530", outdoor = "#363efa", fogcolor = "#83adff"},
    ["winterness"] = {brightness = 1.82, exposure = 0.04, diffuse = 1, specular = 1, ambient = "#433b2e", outdoor = "#756d97", fogcolor = "#c0a069"},
    ["xen"] = {brightness = 1.06, exposure = -0.34, diffuse = 1, specular = 1, ambient = "#1d2a2a", outdoor = "#3a5259", fogcolor = "#2a4c4e"},
    ["zen end"] = {brightness = 0.88, exposure = -0.43, diffuse = 1, specular = 1, ambient = "#14261a", outdoor = "#2e4c43", fogcolor = "#1a522c"},
}
local COLOR3_FLOATS = 16

local function lightingColor(v)
    local hex = tostring(v):match("^#?(%x%x%x%x%x%x)$")
    if hex then
        return tonumber(hex:sub(1, 2), 16) / 255, tonumber(hex:sub(3, 4), 16) / 255, tonumber(hex:sub(5, 6), 16) / 255
    end
    local n = tonumber(v)
    if n then return n, n, n end
end

local function applyLighting(conf, cache)
    local values = {}
    local name = conf.preset and tostring(conf.preset):lower()
    if name == "match" then
        local sky = configSkybox.preset or configSkybox.skybox or configSkybox.name
        name = sky and tostring(sky):lower()
        if not (name and LIGHTING_PRESETS[name]) then return 0, "no lighting preset matches this skybox - left as it is" end
    end
    local preset = name and LIGHTING_PRESETS[name]
    if conf.preset and not preset then return 0, "unknown lighting preset '" .. tostring(conf.preset) .. "'" end
    for k, v in pairs(preset or {}) do values[k] = v end
    for k in pairs(LIGHTING_FIELDS) do
        if conf[k] then values[k] = conf[k] end
    end
    if not next(values) then return 0, nil end

    local L = game:GetService("Lighting")
    local applied = 0
    for name, raw in pairs(values) do
        local field = LIGHTING_FIELDS[name]
        if field and field.off then
            if field.color then
                local r, g, b = lightingColor(raw)
                if r then
                    mwr("float", L.Address + field.off, r)
                    mwr("float", L.Address + field.off + 4, g)
                    mwr("float", L.Address + field.off + 8, b)
                    applied = applied + 1
                end
            else
                local n = tonumber(raw)
                if n then
                    mwr("float", L.Address + field.off, n)
                    applied = applied + 1
                end
            end
        end
    end

    local nodes = {}
    for _, addr in ipairs(cache.lightNodes or {}) do
        if nodeKey(addr) == "ExposureCompensation" and nodeKey(addr + NODE_SIZE) == "Brightness" then
            nodes[#nodes + 1] = addr
        end
    end

    if #nodes == 0 then
        local lpFolders = {}
        local ps = LP:FindFirstChild("PlayerScripts")
        local folder = ps and ps:FindFirstChild("Modules") and ps.Modules:FindFirstChild("LightingProfiles")
        if folder then
            lpFolders[1] = folder
        else
            for _, d in ipairs(LP:GetDescendants()) do
                if d.Name == "LightingProfiles" and d.Parent and d.Parent.Name == "Modules" then lpFolders[1] = d break end
            end
        end
        for _, prof in ipairs(lpFolders[1] and lpFolders[1]:GetChildren() or {}) do
            if prof.ClassName == "ModuleScript" then
                local okT, t = pcall(moduleTable, prof)
                local f = okT and t and nodesOf(t, 64, {LightingProperties = true})
                local props = f and f.LightingProperties and rd(f.LightingProperties)
                local pf = props and nodesOf(props, 64, {ExposureCompensation = true, Brightness = true})
                if pf and pf.ExposureCompensation and pf.Brightness then nodes[#nodes + 1] = pf.ExposureCompensation end
            end
        end
        if #nodes > 0 then cache.lightNodes = nodes end
    end
    if #nodes == 0 then
        local okG, rows = pcall(getgc, {"ExposureCompensation"})
        for _, r in ipairs(okG and type(rows) == "table" and rows or {}) do
            if r.addr and nodeKey(r.addr) == "ExposureCompensation" and nodeKey(r.addr + NODE_SIZE) == "Brightness" then
                nodes[#nodes + 1] = r.addr
            end
        end
        cache.lightNodes = nodes
    end

    local profiles = 0
    for _, exposureNode in ipairs(nodes) do

        local wrote = false
        for i = -12, 12 do
            local node = exposureNode + i * NODE_SIZE
            local key = nodeKey(node)
            if key then
                for name, field in pairs(LIGHTING_FIELDS) do
                    if field.key == key and values[name] then
                        if field.color then
                            local ud = rd(node)
                            local r, g, b = lightingColor(values[name])
                            if ud and ud > 0x10000 and r then
                                mwr("float", ud + COLOR3_FLOATS, r)
                                mwr("float", ud + COLOR3_FLOATS + 4, g)
                                mwr("float", ud + COLOR3_FLOATS + 8, b)
                                wrote = true
                            end
                        else
                            local n = tonumber(values[name])
                            if n then
                                mwr("double", node, n)
                                wrote = true
                            end
                        end
                    end
                end
            end
        end
        if wrote then profiles = profiles + 1 end
    end
    return applied, (profiles > 0) and ("kept across map changes on " .. profiles .. " lighting profiles")
        or "applied to the current area only (lighting profiles not found)"
end

local wrapPairs = readWrapPairs()
if ENABLE_SKIN_DATA_SYNC and (#skinDataPairs > 0 or #wrapPairs > 0) then
    print("[RivalsSkinChanger] Applying skin animations, offsets, icons" .. (#wrapPairs > 0 and " + wraps" or "") .. "...")
    local tSync = tick()
    local okS, synced, note, wrapsApplied, wrapsMissed, skinsMissed = pcall(syncSkinData, skinDataPairs, wrapPairs, dictCache)
    local firstRoute = dictCache.route

    dictCache.knownMissing = dictCache.knownMissing or {}
    local function unexplained()
        local n = 0
        for _, name in ipairs(okS and skinsMissed or {}) do if not dictCache.knownMissing[name] then n = n + 1 end end
        for _, name in ipairs(okS and wrapsMissed or {}) do if not dictCache.knownMissing[name] then n = n + 1 end end
        return n
    end
    local function retry(label, forceScan)
        print("[RivalsSkinChanger] " .. tostring((synced or 0)) .. "/" .. #skinDataPairs .. " skins, "
            .. tostring(wrapsApplied or 0) .. "/" .. #wrapPairs .. " wraps - retrying with " .. label .. "...")
        dictCache.vm, dictCache.cos, dictCache.vmBase, dictCache.cosBase = nil, nil, nil, nil
        dictCache.forceScan = forceScan
        local ok2, s2, n2, w2, wm2, sm2 = pcall(syncSkinData, skinDataPairs, wrapPairs, dictCache)
        dictCache.forceScan = nil

        if ok2 and ((s2 or 0) + (w2 or 0)) >= ((synced or 0) + (wrapsApplied or 0)) then
            okS, synced, note, wrapsApplied, wrapsMissed, skinsMissed = ok2, s2, n2, w2, wm2, sm2
        end
    end
    if okS and unexplained() > 0 then retry("a fresh lookup", false) end
    if okS and unexplained() > 0 then
        notifyUser("Rivals Skin Changer", "Some skins didn't load - double-checking with a full memory scan (~30s)...", 6)
        retry("a full memory scan (~30s)", true)
        if gameReady then
            for _, name in ipairs(skinsMissed or {}) do dictCache.knownMissing[name] = true end
            for _, name in ipairs(wrapsMissed or {}) do dictCache.knownMissing[name] = true end
        end
        local gone = {}
        if skinsMissed and #skinsMissed > 0 then gone[#gone + 1] = "skins: " .. table.concat(skinsMissed, ", ") end
        if wrapsMissed and #wrapsMissed > 0 then gone[#gone + 1] = "wraps: " .. table.concat(wrapsMissed, ", ") end
        if #gone > 0 then
            print("[RivalsSkinChanger] Not in the game's item list (check the names in your config) - " .. table.concat(gone, " | "))
        end
    end
    if okS then
        local parts = {}
        if #skinDataPairs > 0 then parts[#parts + 1] = "Animations, offsets + icons applied: " .. tostring(synced) .. "/" .. #skinDataPairs end
        if #wrapPairs > 0 then parts[#parts + 1] = "Wraps applied: " .. tostring(wrapsApplied or 0) .. "/" .. #wrapPairs end
        local msg = table.concat(parts, " | ")
        local wrapNote = (wrapsMissed and #wrapsMissed > 0) and (" (wraps not found: " .. table.concat(wrapsMissed, ", ") .. ")") or ""
        print("[RivalsSkinChanger] " .. msg .. (note and (" (" .. note .. ")") or "") .. wrapNote .. string.format(" in %.1fs", tick() - tSync)
            .. (firstRoute == "scan" and " (registry route failed - used the slow memory scan)" or ""))
        notifyUser("Rivals Skin Changer", msg, 6)
    else
        print("[RivalsSkinChanger] Skin animation sync error: " .. tostring(synced))
        notifyUser("Rivals Skin Changer", "Animation sync failed - skins are still swapped", 6)
    end
end
do
    local okSky, patched, skyNote = pcall(applySkybox, configSkybox)
    if okSky and (patched or 0) > 0 then
        local msg = "Skybox set on " .. tostring(patched) .. " map profiles - it shows on the next map or area load"
        print("[RivalsSkinChanger] " .. msg .. (skyNote and (" (" .. skyNote .. ")") or ""))
        notifyUser("Rivals Skin Changer", msg, 6)
    elseif okSky and skyNote then
        print("[RivalsSkinChanger] Skybox: " .. tostring(skyNote))
    elseif not okSky then
        print("[RivalsSkinChanger] Skybox error: " .. tostring(patched))
    end
end

do
    local okS, changed, soundNote = pcall(applySounds, configSounds)
    if okS and (changed or 0) > 0 then
        print("[RivalsSkinChanger] Sounds: " .. tostring(changed) .. " replaced - heard from the next hit"
            .. (soundNote and (" (" .. soundNote .. ")") or ""))
    elseif okS and soundNote then
        print("[RivalsSkinChanger] Sounds: " .. tostring(soundNote))
    elseif not okS then
        print("[RivalsSkinChanger] Sounds error: " .. tostring(changed))
    end
    local okV, watched = pcall(startVolumeWatcher, configSounds)
    if okV and (watched or 0) > 0 then
        print("[RivalsSkinChanger] Sound volume adjusted for " .. tostring(watched) .. " sound(s)")
    elseif not okV then
        print("[RivalsSkinChanger] Sound volume error: " .. tostring(watched))
    end
end

do
    local okP, spoofing, spoofNote = pcall(startSpoof, configSpoof)
    if okP and spoofing then
        print("[RivalsSkinChanger] Spoof on - only you see it" .. (spoofNote and (" (" .. spoofNote .. ")") or ""))
    elseif not okP then
        print("[RivalsSkinChanger] Spoof error: " .. tostring(spoofing))
    end
end

do
    local okL, applied, lightNote = pcall(applyLighting, configLighting, dictCache)
    if okL and (applied or 0) > 0 then
        print("[RivalsSkinChanger] Lighting: " .. tostring(applied) .. " settings" .. (lightNote and (" - " .. lightNote) or ""))
    elseif okL and lightNote then
        print("[RivalsSkinChanger] Lighting: " .. tostring(lightNote))
    elseif not okL then
        print("[RivalsSkinChanger] Lighting error: " .. tostring(applied))
    end
end

-- Tracer colours
-- Each shot's Beam.Color comes from a ColorSequence constant: TracerEffect's
-- default, or the skin script's own (GetFriendlyTracerColor). Rewriting those
-- constants recolours the tracers the game draws itself, so they don't lag.
-- Every address belongs to this server: each write checks it still holds what
-- it did, and the watcher stops when the server or the module changes.
do
    _G.__RIVALS_TRACERS = (_G.__RIVALS_TRACERS or 0) + 1
    local token = _G.__RIVALS_TRACERS
    if _G.__RIVALS_TRACER_CONN then pcall(function() _G.__RIVALS_TRACER_CONN:Disconnect() end) end
    _G.__RIVALS_TRACER_CONN = nil

    local job = game.JobId
    local mods = psRoot and psRoot:FindFirstChild("Modules")
    local function tracerModule() return mods and moduleTable(mods:FindFirstChild("TracerEffect")) end
    local te = tracerModule()
    -- Originals, kept across runs (same server only) so turning a colour off
    -- puts the game's back.
    local orig = _G.__RIVALS_TRACER_ORIG
    if type(orig) ~= "table" or orig.te ~= te or orig.job ~= job then orig = {te = te, job = job, seqs = {}, checked = {}} end
    _G.__RIVALS_TRACER_ORIG = orig

    -- A two-keypoint ColorSequence: times 0 and 1, 0x14 apart.
    local function isSeq(seq)
        local ok0, t0 = pcall(mrd, "float", seq)
        local ok1, t1 = pcall(mrd, "float", seq + 0x14)
        return ok0 and ok1 and t0 == 0 and t1 == 1
    end
    local function writeSeq(seq, r, g, b)
        if not isSeq(seq) then return false end
        for _, k in ipairs({4, 0x18}) do
            pcall(mwr, "float", seq + k, r)
            pcall(mwr, "float", seq + k + 4, g)
            pcall(mwr, "float", seq + k + 8, b)
        end
        return true
    end
    local function isNumber(a)
        local ok, tt = pcall(mrd, "int", a + 12)
        return ok and tt == 3
    end
    for seq, c in pairs(orig.seqs) do writeSeq(seq, c[1], c[2], c[3]) end
    if orig.speed and isNumber(orig.speed[1]) then pcall(mwr, "double", orig.speed[1], orig.speed[2]) end

    -- Speed: the per-shot function moves the tracer 800 / distance percent a
    -- frame. That 800 sits in its constant list: Play's proto (closure +0x18),
    -- its child protos (+0x28), the first one's constants (+0x48). Offsets for
    -- Roblox build 02c37bc (Sep 30 2026).
    local function speedSlot()
        if orig.speed then return isNumber(orig.speed[1]) and orig.speed[1] or nil end
        local f = nodesOf(te, 1024, {Play = true})
        local cl = f and f.Play and rd(f.Play)
        local proto = cl and cl > 0x10000 and rd(cl + 0x18)
        local arr = proto and proto > 0x10000 and rd(proto + 0x28)
        local child = arr and arr > 0x10000 and rd(arr)
        local k = child and child > 0x10000 and rd(child + 0x48)
        if not k or k < 0x10000 then return nil end
        -- 800, or what an earlier run set it to (800 x a multiple of 5%)
        local fallbackSlot
        for i = 0, 63 do
            local a = k + i * 16
            local okV, v = pcall(mrd, "double", a)
            if okV and isNumber(a) then
                if v == 800 then
                    orig.speed = {a, 800}
                    return a
                end
                local pct = v / 8
                if not fallbackSlot and pct >= 5 and pct <= 300 and pct % 5 == 0 then fallbackSlot = a end
            end
        end
        if fallbackSlot then orig.speed = {fallbackSlot, 800} end
        return fallbackSlot
    end

    local function seqOf(t, key)
        local f = nodesOf(t, 1024, {[key] = true})
        local cl = f and f[key] and rd(f[key])
        local p1 = cl and cl > 0x10000 and rd(cl + 0x20)
        local seq = p1 and p1 > 0x10000 and rd(p1 + 0x10)
        if seq and seq > 0x10000 and isSeq(seq) then return seq end
    end
    -- Skin scripts load when first used, so this runs again on every equip.
    -- A loaded script is only read once; the rest is a few reads each.
    local function collect()
        local list = {}
        local function add(seq)
            if not seq then return end
            if not orig.seqs[seq] then
                orig.seqs[seq] = {mrd("float", seq + 4), mrd("float", seq + 8), mrd("float", seq + 12)}
            end
            list[#list + 1] = seq
        end
        add(seqOf(te, "VerifyTracerData"))
        local vms = mods:FindFirstChild("ViewModels")
        for _, d in ipairs(vms and vms:GetDescendants() or {}) do
            if d.ClassName == "ModuleScript" then
                local a = d.Address
                if orig.checked[a] == nil then
                    local t = moduleTable(d)
                    if t then orig.checked[a] = seqOf(t, "GetFriendlyTracerColor") or false end
                end
                add(orig.checked[a] or nil)
            end
        end
        return list
    end

    local conf = {}
    for k, v in pairs(configTracers) do conf[k:lower()] = tostring(v):lower() end

    local speed = tonumber(conf.speed)
    if speed and te then
        speed = math.max(5, math.min(300, speed))
        local slot = speedSlot()
        if slot then
            pcall(mwr, "double", slot, 800 * speed / 100)
            print("[RivalsSkinChanger] Tracers: speed " .. speed .. "%")
        else
            print("[RivalsSkinChanger] Tracers: couldn't find the tracer speed - left as it is")
        end
    end
    conf.speed = nil

    -- Energy Pistols ship with DisableTracerEffects = true, so the game draws
    -- no tracers for them. EnergyPistolsTracers=true flips it off (the gun then
    -- takes the colours and speed above like the others); without the line
    -- the game's value is put back. Only the local tracer drawing reads it.
    -- (A function of its own: the main chunk is at Luau's 200-local limit.)
    pcall(function()
        local on = spoofFlag(conf.energypistolstracers) == true
        local rsMods = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
        local lib = moduleTable(rsMods and rsMods:FindFirstChild("ItemLibrary"))
        local f = nodesOf(lib, 256, {Items = true})
        local items = f and f.Items and rd(f.Items)
        local fi = items and nodesOf(items, 256, {["Energy Pistols"] = true})
        local ep = fi and fi["Energy Pistols"] and rd(fi["Energy Pistols"])
        local fe = ep and nodesOf(ep, 256, {DisableTracerEffects = true})
        local node = fe and fe.DisableTracerEffects
        local okT, tt = pcall(mrd, "int", (node or 0) + 12)
        if node and okT and tt == 1 then
            local want = on and 0 or 1
            local okV, now = pcall(mrd, "int", node)
            if okV and now ~= want then pcall(mwr, "int", node, want) end
            if on then print("[RivalsSkinChanger] Tracers: Energy Pistols now draw tracers") end
        elseif on then
            print("[RivalsSkinChanger] Tracers: couldn't find the Energy Pistols tracer setting - left as it is")
        end
    end)
    conf.energypistolstracers = nil
    local fallback = conf.color or conf.all or conf.default
    local any = next(conf) ~= nil

    if any and te then
        local seqs, current, lastName = collect(), nil, false
        local acc, sinceCheck, lastRgb = 0, 0, nil
        local function equipped()
            local vmf = workspace:FindFirstChild("ViewModels")
            local fp = vmf and vmf:FindFirstChild("FirstPerson")
            local c = fp and fp:GetChildren()[1]
            return c and c.Name
        end
        local function pick(name)
            local parts = {}
            for p in tostring(name or ""):gmatch("[^%-]+") do parts[#parts + 1] = p:match("^%s*(.-)%s*$"):lower() end
            return (parts[3] and conf[parts[3]]) or (parts[2] and conf[parts[2]]) or fallback
        end
        local conn
        conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
            if _G.__RIVALS_TRACERS ~= token then pcall(function() conn:Disconnect() end) return end
            dt = dt or 1 / 60
            acc, sinceCheck = acc + dt, sinceCheck + dt
            if acc < 0.05 then return end
            acc = 0
            if sinceCheck >= 1 then
                sinceCheck, lastRgb = 0, nil -- rewrite once a second in case the game reset one
                if game.JobId ~= job or tracerModule() ~= te then
                    pcall(function() conn:Disconnect() end)
                    return
                end
            end
            local name = equipped()
            if name ~= lastName then
                lastName, lastRgb = name, nil
                seqs = collect()
                current = pick(name)
            end
            local r, g, b
            if current == "rainbow" then
                local c = Color3.fromHSV(tick() * 0.25 % 1, 1, 1)
                r, g, b = c.R, c.G, c.B
            elseif current and current ~= "off" and current ~= "default" then
                r, g, b = lightingColor(current)
            end
            local rgb = r and (r .. "," .. g .. "," .. b) or "orig"
            if rgb == lastRgb then return end
            lastRgb = rgb
            for _, seq in ipairs(seqs) do
                local c = r and {r, g, b} or orig.seqs[seq]
                if c then writeSeq(seq, c[1], c[2], c[3]) end
            end
        end)
        _G.__RIVALS_TRACER_CONN = conn
        print("[RivalsSkinChanger] Tracers: recolouring " .. #seqs .. " tracer colours (more load as you equip skins)")
    elseif any then
        print("[RivalsSkinChanger] Tracers: TracerEffect not loaded yet - fire once and run again")
    end
end

-- No hands
-- Your first-person arms are two parts with a SpecialMesh each; the game hides
-- them for VR by setting the mesh's Scale to zero. The same is done here for
-- the weapons in [NoHands]: the scale is written in memory, then the part's
-- Size is changed (a real property change) so the arm is drawn again with it.
-- Arms are handled as their weapon comes out, and put back the same way.
do
    _G.__RIVALS_NOHANDS = (_G.__RIVALS_NOHANDS or 0) + 1
    local token = _G.__RIVALS_NOHANDS
    if _G.__RIVALS_NOHANDS_CONN then pcall(function() _G.__RIVALS_NOHANDS_CONN:Disconnect() end) end
    _G.__RIVALS_NOHANDS_CONN = nil

    local MESH_SCALE = 0xB4 -- SpecialMesh.Scale, three floats
    local ARM_SIZE, TINY = Vector3.new(1.8, 0.45, 0.45), Vector3.new(0.001, 0.001, 0.001)
    local job = game.JobId
    -- What was hidden, kept across runs (same server) so it can be put back:
    -- mesh address -> its scale.
    local hidden = _G.__RIVALS_NOHANDS_HIDDEN
    if type(hidden) ~= "table" or hidden.job ~= job then hidden = {job = job, scales = {}, any = false} end
    _G.__RIVALS_NOHANDS_HIDDEN = hidden

    local conf = {}
    for k, v in pairs(configNoHands) do conf[k:lower()] = spoofFlag(v) end
    local function wanted(name)
        local parts = {}
        for part in tostring(name or ""):gmatch("[^%-]+") do parts[#parts + 1] = part:match("^%s*(.-)%s*$"):lower() end
        local v = parts[3] and conf[parts[3]]
        if v == nil then v = parts[2] and conf[parts[2]] end
        if v == nil then v = conf.all end
        return v == true
    end

    local function scaleOf(mesh)
        local a = mesh.Address
        local ok, x = pcall(mrd, "float", a + MESH_SCALE)
        local ok2, y = pcall(mrd, "float", a + MESH_SCALE + 4)
        local ok3, z = pcall(mrd, "float", a + MESH_SCALE + 8)
        if ok and ok2 and ok3 and x and y and z then return x, y, z end
    end
    local function setScale(mesh, x, y, z)
        local a = mesh.Address
        pcall(mwr, "float", a + MESH_SCALE, x)
        pcall(mwr, "float", a + MESH_SCALE + 4, y)
        pcall(mwr, "float", a + MESH_SCALE + 8, z)
    end
    local function pass()
        local vmf = workspace:FindFirstChild("ViewModels")
        local fp = vmf and vmf:FindFirstChild("FirstPerson")
        for _, vm in ipairs(fp and fp:GetChildren() or {}) do
            local hide = wanted(vm.Name)
            for _, armName in ipairs({"LeftArm", "RightArm"}) do
                local arm = vm:FindFirstChild(armName)
                local mesh = arm and arm:FindFirstChild("Mesh")
                if mesh and mesh.ClassName == "SpecialMesh" then
                    local x, y, z = scaleOf(mesh)
                    local key = mesh.Address
                    if hide and x and (x ~= 0 or y ~= 0 or z ~= 0) then
                        -- a sane scale only: anything else isn't the field it was
                        if x > 0 and x < 20 and y > 0 and y < 20 and z > 0 and z < 20 then
                            hidden.scales[key], hidden.any = {x, y, z}, true
                            setScale(mesh, 0, 0, 0)
                            pcall(function() arm.Size = TINY end)
                        end
                    elseif not hide and x == 0 and y == 0 and z == 0 and hidden.scales[key] then
                        local sc = hidden.scales[key]
                        hidden.scales[key] = nil
                        setScale(mesh, sc[1], sc[2], sc[3])
                        pcall(function() arm.Size = ARM_SIZE end)
                    end
                end
                -- The wrapped arm (shown instead when a wrap covers the arms) is a
                -- MeshPart, which follows its Size.
                local wrapped = vm:FindFirstChild(armName .. "Wrapped")
                if wrapped and wrapped.ClassName == "MeshPart" then
                    local okS, size = pcall(function() return wrapped.Size end)
                    if okS and size then
                        if hide and size.X > 0.01 then
                            hidden.any = true
                            pcall(function() wrapped.Size = TINY end)
                        elseif not hide and size.X <= 0.01 then
                            pcall(function() wrapped.Size = ARM_SIZE end)
                        end
                    end
                end
            end
        end
    end

    local any = false
    for _, v in pairs(conf) do if v == true then any = true end end
    -- Also runs with nothing set while arms hidden earlier are still out there,
    -- so they come back as their weapons are equipped.
    if any or hidden.any then
        local acc, conn = 0, nil
        conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
            if _G.__RIVALS_NOHANDS ~= token or game.JobId ~= job then pcall(function() conn:Disconnect() end) return end
            acc = acc + (dt or 1 / 60)
            if acc < 0.15 then return end
            acc = 0
            pcall(pass)
        end)
        _G.__RIVALS_NOHANDS_CONN = conn
        pcall(pass)
        if any then
            local names = {}
            for k, v in pairs(conf) do if v == true then names[#names + 1] = k == "all" and "every weapon" or k end end
            table.sort(names)
            print("[RivalsSkinChanger] No hands: " .. table.concat(names, ", ") .. " - only you see it")
        end
    end
end

-- Finishers and charms
-- Season rank charms
local function showOnlyVariant(model, keepName)
    local extra = model:FindFirstChild("Extra")
    local keep = extra and extra:FindFirstChild(keepName)
    if not keep then return false end
    for _, v in ipairs(extra:GetChildren()) do
        if v.Address ~= keep.Address then
            local parts = v:GetDescendants()
            parts[#parts + 1] = v
            for _, d in ipairs(parts) do
                local c = d.ClassName
                if c == "Part" or c == "MeshPart" or c == "UnionOperation" then
                    local addr = d.Address + OFF.Transparency
                    local okR, old = pcall(mrd, "float", addr)
                    if okR and old then
                        floatRestores[#floatRestores + 1] = {addr, old}
                        pcall(mwr, "float", addr, 1)
                    end
                end
            end
        end
    end
    return true
end

local function applyCosmetics()
    if #configFinishers == 0 and #configCharms == 0 then return nil end
    local modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    local finishers = modules and modules:FindFirstChild("Finishers")
    local charmModels = A and A:FindFirstChild("Charms")
    local psModules = psRoot and psRoot:FindFirstChild("Modules")
    local charmScripts = psModules and psModules:FindFirstChild("Charms")
    local used, done, missed, dupes = {}, {}, {}, {}
    -- A swap trades two models, so each one can only be in one line.
    local function claim(kind, a, b)
        local by = used[kind .. a] or used[kind .. b]
        if by then
            dupes[#dupes + 1] = a .. " -> " .. b .. " (" .. by .. " already uses it)"
            return false
        end
        used[kind .. a], used[kind .. b] = a .. " -> " .. b, a .. " -> " .. b
        return true
    end
    for _, p in ipairs(configFinishers) do
        local owned, target = p[1], p[2]
        local a, b
        for _ = 1, 20 do
            a = finishers and finishers:FindFirstChild(owned)
            b = finishers and finishers:FindFirstChild(target)
            if a and b then break end
            task.wait(0.5)
        end
        if not a or not b then
            missed[#missed + 1] = owned .. "=" .. target .. " (" .. (not a and owned or target) .. " isn't a finisher)"
        elseif not claim("f:", owned, target) then
            missed[#missed + 1] = owned .. "=" .. target .. " (already used by another line)"
        elseif swapTwoWay(a, b, finishers) then
            done[#done + 1] = owned .. " -> " .. target
        else
            missed[#missed + 1] = owned .. "=" .. target .. " (swap failed)"
        end
    end
    for _, p in ipairs(configCharms) do
        local owned, target = p[1], p[2]
        -- Charm models (the unreleased seasons especially) can still be
        -- streaming in when autoexec starts the script: look again for up to 10s.
        local a, b, variant
        for _ = 1, 20 do
            a = charmModels and charmModels:FindFirstChild(owned)
            b, variant = charmModels and charmModels:FindFirstChild(target), nil
            if not b and charmModels then
                local base, rank = target:match("^(Season %d+)%s+(.+)$")
                local m = base and charmModels:FindFirstChild(base)
                local extra = m and m:FindFirstChild("Extra")
                if extra and extra:FindFirstChild(rank) then b, variant = m, rank end
            end
            if a and b then break end
            task.wait(0.5)
        end
        if not a or not b then
            missed[#missed + 1] = owned .. "=" .. target .. " (" .. (not a and owned or target) .. " isn't a charm)"
        elseif not claim("c:", owned, variant and b.Name or target) then
            missed[#missed + 1] = owned .. "=" .. target .. " (already used by another line)"
        elseif swapTwoWay(a, b, charmModels) then
            if variant then showOnlyVariant(b, variant) end
            local oa = charmScripts and charmScripts:FindFirstChild(owned)
            local ob = charmScripts and charmScripts:FindFirstChild(target)
            if oa and ob then
                swapTwoWay(oa, ob, charmScripts)
            elseif ob then
                copyName(ob, b)
            elseif oa then
                copyName(oa, a)
            end
            done[#done + 1] = owned .. " -> " .. target
        else
            missed[#missed + 1] = owned .. "=" .. target .. " (swap failed)"
        end
    end
    return done, missed, dupes
end

do
    local okC, done, missed, dupes = pcall(applyCosmetics)
    if not okC then
        print("[RivalsSkinChanger] Finishers/charms error: " .. tostring(done))
    elseif done then
        if #done > 0 then
            local msg = "Finishers/charms: " .. table.concat(done, ", ")
            print("[RivalsSkinChanger] " .. msg .. " - finishers show from their next use, charms on the next equip")
            notifyUser("Rivals Skin Changer", msg, 6)
        end
        if #missed > 0 then
            print("[RivalsSkinChanger] Finishers/charms not applied: " .. table.concat(missed, "; "))
        end
        if dupes and #dupes > 0 then
            notifyUser("Rivals Skin Changer", "Skipped - two lines use the same finisher or charm: "
                .. table.concat(dupes, ", "), 10)
        end
    end
end

-- Save state
_G.__RIVALS_SKIN_CHANGER_STATE = {restores = memoryRestores, wfAddr = wf.Address, jobId = game.JobId, nameCopies = nameCopies, dicts = dictCache, floats = floatRestores}
saveUndo()
_G.__RIVALS_SKIN_CHANGER_BUSY = nil

]====]
-- Rivals changer GUI, drawn on screen
-- Edits rivals_config.lua and runs the skin changer, in a window of its own
-- drawn with the Drawing library (it replaced the Matcha menu tab, now kept as
-- RivalsSkinGuiMatcha.lua): weapons by loadout slot, skin grid with pictures,
-- Switch and Swap, wraps, finishers, charms, sky, lighting and sounds. A key
-- (Right Shift unless changed in Settings) shows and hides it; the accent
-- color is picked there too. Auto-apply on join applies the saved config once
-- per server.
--
-- Matcha can't create instances, so everything is Drawing objects redrawn every
-- frame from a pool. Pictures come from the config site (the same files its
-- pages use) and are cached in the workspace as .dat files.

local FILE = "rivals_config.lua"
local SETTINGS = "rivals_gui_settings.txt"
local BACKUP = "rivals_config.backup.lua"
local CACHE = "rivals_gui_cache_hd"
local IMAGE_URLS = {}
local SCRIPT_FILES = {"RivalsSkinSwapper.lua", "workspace/RivalsSkinSwapper.lua", "scripts/RivalsSkinSwapper.lua"}
local SCRIPT_URL = "https://raw.githubusercontent.com/Martinikaws/RivalsSkinChangerFULLMATCHA/refs/heads/main/main.lua"
local SITE = "https://martinikaws.github.io/rivals-skins/"
local RIVALS_GAME_ID = 6035872082
-- Keys the show/hide key can be set to (Windows key codes), by name.
local KEY_NAMES = {
    [0x08] = "Backspace", [0x09] = "Tab", [0x0D] = "Enter", [0x14] = "Caps Lock", [0x20] = "Space",
    [0x21] = "Page Up", [0x22] = "Page Down", [0x23] = "End", [0x24] = "Home", [0x25] = "Left", [0x26] = "Up",
    [0x27] = "Right", [0x28] = "Down", [0x2D] = "Insert", [0x2E] = "Delete", [0xA0] = "Left Shift",
    [0xA1] = "Right Shift", [0xA2] = "Left Ctrl", [0xA3] = "Right Ctrl", [0xA4] = "Left Alt", [0xA5] = "Right Alt",
    [0xBA] = ";", [0xBB] = "=", [0xBC] = ",", [0xBD] = "-", [0xBE] = ".", [0xBF] = "/", [0xC0] = "`",
    [0xDB] = "[", [0xDC] = "\\", [0xDD] = "]", [0xDE] = "'",
}
for i = 0, 25 do KEY_NAMES[0x41 + i] = string.char(65 + i) end
for i = 0, 9 do KEY_NAMES[0x30 + i] = tostring(i); KEY_NAMES[0x60 + i] = "Num " .. i end
for i = 1, 12 do KEY_NAMES[0x6F + i] = "F" .. i end
local function keyName(vk) return KEY_NAMES[vk] or ("Key " .. tostring(vk)) end
local DEFAULT_TOGGLE, DEFAULT_ACCENT = 0xA1, "568cff"

assert(Drawing and type(Drawing.new) == "function", "Matcha's Drawing library is required.")
assert(type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function",
    "Matcha file functions are required.")

-- A second run replaces the first; the menu-tab GUI steps aside too.
-- Only in RIVALS. (The id is 0 until the game has loaded; started that early,
-- the window closes itself once the game turns out to be another one.)
local function otherGame()
    local ok, id = pcall(function() return tonumber(game.GameId) end)
    return ok and id ~= nil and id ~= 0 and id ~= RIVALS_GAME_ID
end
if otherGame() then
    print("[Rivals GUI] Not RIVALS - the GUI stays off in this game.")
    return
end

if _G.RivalsGuiState and _G.RivalsGuiState.busy then
    error("Wait for the current apply to finish before reloading the GUI.")
end
if _G.__RivalsDrawnGui then pcall(_G.__RivalsDrawnGui.stop) end
pcall(function() UI.RemoveTab("Rivals Changer") end)

_G.RivalsGuiState = _G.RivalsGuiState or {busy = false}
local shared = _G.RivalsGuiState
shared.busy = false
local guiToken = {}
_G.__RivalsGuiSession = guiToken

-- Lists that don't come from the game

local function numbered(prefix, from, to)
    local out = {}
    for n = from, to do out[#out + 1] = string.format("%s %02d", prefix, n) end
    return out
end
local SKY_GROUPS = {
    {name = "Game skies", skies = {"blue", "space", "graveyard", "sudden death", "station", "westown", "black", "gray", "classic"}},
    {name = "Cloudy", skies = numbered("cloudy", 1, 25)},
    {name = "Space", skies = {"galaxy", "blue nebula", "gold nebula"}},
    {name = "More A-D", skies = {"aurora", "beautiful", "black hole", "blue sky", "broken sky", "castle grounds", "chill gray", "chill pink", "chroma key", "clear skies", "cyan", "dead star forest", "disaster"}},
    {name = "More E-M", skies = {"elegant morning", "emo", "fade blue", "forest", "goodnight", "grimnight", "hades", "hazy", "jungle", "light blue", "light pink", "minecraft", "minecraft end"}},
    {name = "More M-P", skies = {"moonlight", "neon sky", "neon sky 2", "nibiru", "night", "night sky moon", "northern lights", "oblivion", "orange", "overcast", "pandora", "peaceful morning", "pink sunrise"}},
    {name = "More P-S", skies = {"pumpkin hill", "purple nebula", "red", "setting sun", "sfoth", "shiverfrost", "sky 05", "sky 13", "sky 2006", "sky 22", "sky 31", "sky 38", "sky 47"}},
    {name = "More S-Z", skies = {"sky purple", "sky sunset", "space blue", "spooky", "sunny sky", "universe", "utter east", "whomp fortress", "winterness", "xen", "zen end"}},
}
-- Front faces of the game's own skies; the uploaded ones come from skyboxes.json.
local SKY_FACES = {
    blue = "14147882761", space = "10196550367", graveyard = "135908632589654",
    ["sudden death"] = "84214501374682", station = "2108482231", westown = "12261809766",
}
local SOUND_LIBRARY = {
    {name = "Rivals", sounds = {
        {"Hitmarker tick", "13110130082"}, {"Headshot crack", "16537449730"}, {"Elimination 1", "16530229616"},
        {"Elimination 2", "16530229541"}, {"Elimination 3", "16530229695"}, {"Target shatter", "14441658101"},
        {"RPG explosion", "13455969017"}, {"Equip click", "13158735106"}, {"Landing", "16736552001"},
        {"Jump", "16736552098"}, {"Duel timer tick", "17826390328"}, {"Click", "177266782"},
    }},
    {name = "Roblox", sounds = {
        {"Classic hit", "12222046"}, {"Button", "12221967"}, {"Electronic ping", "12221990"},
        {"Glass break", "12222005"}, {"Kerplunk", "12222054"}, {"Fast click", "12221976"},
        {"Bright click", "15675059323"}, {"Cute pop", "15675055424"}, {"Notification", "17208361335"},
        {"Coin", "127645268874265"}, {"Pinball bell", "16480570986"}, {"8-bit blip", "16480580213"},
        {"Metal click", "16480551554"}, {"Sparkle ding", "9126073001"}, {"Cannon blast", "3149249837"},
    }},
    {name = "Hit sounds", sounds = {
        {"Undertale critical hit", "140181868959125"}, {"Hit sound", "139520673393967"},
        {"Undertale attack hit", "140721035016341"}, {"Fist hit", "140604838213617"},
        {"TF2 critical hit", "137392628136734"}, {"AvA punch", "138208560796742"}, {"Rock hit", "82708037443413"},
        {"Spear hit", "135278368445325"}, {"Persona 5 hit", "140706017778464"},
        {"Energy sword hit", "139503070303020"}, {"Stone hit", "3581383408"}, {"8-bit impact", "109598434966968"},
        {"Minecraft hit", "73369656122118"}, {"Car hit", "1897654568"}, {"Beam hit", "103134129110384"},
    }},
    {name = "Your pack", sounds = {
        {"agpa 1", "102651850556408"}, {"agpa 2", "132463144859699"}, {"Huhh", "115574480250251"},
        {"Minecraft hurt", "127059326655954"}, {"msfrs.hit", "138523457528846"}, {"neverlose.cc", "139452805868562"},
        {"Rust headshot 2", "138750331387064"}, {"skeet (louder)", "140247876667835"},
        {"Taco Bell bong", "128327858093323"}, {"Bubble pop", "121434237134952"},
        {"Windows XP error", "95509039020568"}, {"My name is Jeff", "2867856238"}, {"HL2 crowbar", "73268721537561"},
        {"DSR-1", "93739917036633"}, {"Fatality", "97439296876895"}, {"Bepis", "1921494658"},
        {"Burp", "130147881880627"}, {"Duck quack", "140601322851309"}, {"Computer beep", "2626561747"},
        {"MGS alert", "139345986070502"}, {"Doom shotgun", "15120932483"}, {"Cash register", "120891770644830"},
        {"Cowbell", "9125935023"}, {"Winner FX", "1841267764"}, {"Cartoon bubble", "5852470908"},
    }},
    {name = "Community", sounds = {
        {"CoD hitmarker", "138832207290954"}, {"Quake hitmarker", "1455817260"},
        {"GameSense hitmarker", "4817809188"}, {"Minecraft hitmarker", "127091812835195"},
        {"Minecraft bow ding", "135478009117226"}, {"MLG hitmarker", "121351852050830"},
        {"Head hitmarker", "17724154662"}, {"TF2 hitsound", "138901307926331"}, {"osu! hitsound", "123941247147792"},
        {"Bubble pop", "119697580657161"}, {"CS:GO headshot", "133002449941130"}, {"Arsenal headshot", "18513634637"},
        {"Fortnite headshot", "2513174484"}, {"Rust headshot", "128633263668964"},
        {"Battlefield headshot", "70528023820006"}, {"PHIGHTING headshot", "138549196892842"},
        {"TF2 kill", "124543461907751"}, {"Among Us kill", "130456049552264"}, {"MM2 knife kill", "97347330766907"},
        {"Double kill", "116907610084760"},
    }},
    {name = "Kenney (CC0)", sounds = {
        {"Punch heavy", "107508753428253"}, {"Punch", "76122581259100"}, {"Metal tap", "138075431083492"},
        {"Metal clang", "133464625805308"}, {"Glass tap", "138936753289661"}, {"Glass smash", "75898126734535"},
        {"Bell hit", "126126591991039"}, {"Plate tap", "117110797440641"}, {"Tin hit", "135391446483517"},
        {"Soft thud", "95039951320381"}, {"Click", "127906824435990"}, {"Tick", "130702709867354"},
        {"Confirm", "112196335049721"}, {"Glass ding", "127490438798725"}, {"Pluck", "72021613097471"},
        {"Bong", "117732813936667"}, {"Drop", "128207733490113"}, {"Glitch", "131159017045649"},
        {"Zap", "136683295906047"}, {"Zap two-tone", "132620272525127"}, {"Pep", "70583920911483"},
        {"High up", "117530563976701"}, {"Phaser up", "104765335548518"}, {"Power up", "105788477038167"},
        {"Three-tone", "70578968807464"}, {"Small laser", "91301983822305"}, {"Retro laser", "118116613865507"},
        {"Explosion crunch", "82931503751689"},
    }},
}
local SOUND_SLOTS = {{"Hit", "Body hit"}, {"Critical", "Headshot"}, {"Kill", "Kill"}}
local RANKS = {"Archnemesis", "Nemesis", "Onyx 3", "Onyx 2", "Onyx 1", "Diamond 3", "Diamond 2", "Diamond 1",
    "Platinum 3", "Platinum 2", "Platinum 1", "Gold 3", "Gold 2", "Gold 1", "Silver 3", "Silver 2", "Silver 1",
    "Bronze 3", "Bronze 2", "Bronze 1", "Unranked"}
local RARITY_COLORS = {
    Common = Color3.fromRGB(123, 255, 0), Rare = Color3.fromRGB(0, 221, 255), Legendary = Color3.fromRGB(255, 60, 60),
    Mythical = Color3.fromRGB(129, 133, 242), Unique = Color3.fromRGB(255, 140, 0), Genuine = Color3.fromRGB(127, 163, 90),
}
-- Loadout slot of each weapon; the site's list replaces this when it loads.
local WEAPON_SLOTS = {}
for slot, names in pairs({
    Primary = {"Assault Rifle", "Bow", "Burst Rifle", "Crossbow", "Distortion", "Energy Rifle", "Flamethrower",
        "Grenade Launcher", "Gunblade", "Minigun", "Paintball Gun", "Permafrost", "RPG", "Shotgun", "Sniper", "Wildcat"},
    Secondary = {"Daggers", "Energy Pistols", "Exogun", "Flare Gun", "Handgun", "Revolver", "Shorty", "Slingshot",
        "Spray", "Uzi", "Warper"},
    Melee = {"Battle Axe", "Chainsaw", "Fists", "Katana", "Knife", "Maul", "Riot Shield", "Scythe", "Spear", "Trowel"},
    Utility = {"Flashbang", "Freeze Ray", "Grappler", "Grenade", "Jump Pad", "Medkit", "Molotov", "Satchel",
        "Smoke Grenade", "Subspace Tripmine", "War Horn", "Warpstone"},
}) do
    for _, name in ipairs(names) do WEAPON_SLOTS[name] = slot end
end
local WRAP_RARITY_NAMES = {"Common", "Rare", "Legendary", "Mythical", "Unique", "Genuine", "Unobtainable"}

local state = {
    status = "Loading...", lines = {}, values = {}, swaps = {}, readable = false,
    tab = "Skins", skinsView = "main", slotTab = "All", mode = "Switch", swapStep = 1, swapOwned = {},
    weapon = nil, cosKind = "wraps", owned = {}, rank = {},
    skyGroup = 1, soundSlot = 1, soundGroup = 1,
    inputs = {}, scroll = {}, mouseOffset = 0, open = true,
    toggleKey = DEFAULT_TOGGLE, accent = DEFAULT_ACCENT,
    -- "You own" lists show only what you own; the window stays hidden when
    -- autoexec starts it.
    ownedOnly = true, showOnAutoexec = false,
}
local catalog = {weapons = {}, wraps = {}, finishers = {}, charms = {}, skyFaces = {}, loaded = false}

-- Config file

local function trim(s) return s:match("^%s*(.-)%s*$") end
local function header(line)
    local s = line:match("^%s*%[%s*(.-)%s*%]%s*$")
    return s and s:lower() or nil
end
local function pair(line)
    if line:match("^%s*%-%-") then return nil end
    local k, v = line:match("^%s*([^=]-)%s*=%s*(.-)%s*$")
    if k and trim(k) ~= "" then return trim(k), v end
end
local function swapLine(line)
    local w, owned, target = line:match("^%s*([^|]-)%s*|%s*([^>]-)%s*>%s*(.-)%s*$")
    if w and owned and target and w ~= "" and owned ~= "" and target ~= "" then return w, owned, target end
end
local function indexConfig()
    state.values = {skins = {}, wraps = {}, finishers = {}, charms = {}, skybox = {}, lighting = {}, sounds = {}}
    state.swaps = {}
    local section = "skins"
    for _, line in ipairs(state.lines) do
        local h = header(line)
        if h then
            section = h
        elseif section == "skins" and not line:match("^%s*%-%-") and swapLine(line) then
            local w, owned, target = swapLine(line)
            state.swaps[w] = state.swaps[w] or {}
            state.swaps[w][owned] = target
        else
            local k, v = pair(line)
            if k then
                state.values[section] = state.values[section] or {}
                state.values[section][k] = v
            end
        end
    end
end
local function configText()
    if #state.lines == 0 then return "-- Rivals config\n" end
    return table.concat(state.lines, "\n") .. "\n"
end
-- Changed compared with what was last loaded or saved.
local function markChanged()
    state.dirty = configText() ~= state.cleanText
    state.status = state.dirty and "Changed - press Save & Apply." or "No changes."
end
-- The changer trades two models for each line, so a skin, finisher or charm
-- can only be in one line: it skips a second line that uses one again.
-- Returns those lines, in the order the changer would skip them.
local function configClashes()
    local out, section, touched, used, swaps = {}, "skins", {}, {}, {}
    for _, line in ipairs(state.lines) do
        local h = header(line)
        if h then
            section = h
        elseif section == "skins" then
            local w, o, t = swapLine(line)
            if w then
                swaps[#swaps + 1] = {o, t}
            else
                local k, v = pair(line)
                local low = v and v:lower()
                if k and v and low ~= "default" and low ~= "standard" then
                    if touched[v] or touched[k] then
                        out[#out + 1] = k .. " -> " .. v
                    else
                        touched[v], touched[k] = true, true
                    end
                end
            end
        elseif section == "finishers" or section == "charms" then
            local k, v = pair(line)
            if k and v then
                -- Every rank of a season charm is the same model.
                local model = section == "charms" and (v:match("^(Season %d+)%s") or v) or v
                used[section] = used[section] or {}
                local u = used[section]
                if u[k] or u[model] then out[#out + 1] = k .. " -> " .. v else u[k], u[model] = true, true end
            end
        end
    end
    -- The changer runs the swaps after the Weapon=Skin lines.
    for _, sw in ipairs(swaps) do
        if touched[sw[2]] or touched[sw[1]] then
            out[#out + 1] = sw[1] .. " -> " .. sw[2]
        else
            touched[sw[2]], touched[sw[1]] = true, true
        end
    end
    return out
end
local function clashWarning()
    local bad = configClashes()
    if #bad == 0 then return nil end
    return "Two lines use the same item - the changer skips: " .. table.concat(bad, ", ")
end
local function loadConfig()
    local raw = isfile(FILE) and readfile(FILE) or nil
    local content = (raw or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
    if content:sub(1, 3) == string.char(239, 187, 191) then content = content:sub(4) end
    local lines = {}
    for line in (content .. "\n"):gmatch("(.-)\n") do lines[#lines + 1] = line end
    while lines[#lines] == "" do table.remove(lines) end
    local cleaned = {}
    for _, line in ipairs(lines) do
        local k, v = pair(line)
        if not (k and v and k == v) then cleaned[#cleaned + 1] = line end
    end
    state.lines, state.baseline = cleaned, raw
    indexConfig()
    state.readable = true
    state.cleanText, state.dirty = configText(), false
    state.status = clashWarning() or (raw and "Loaded your configuration." or "Nothing saved yet - pick something.")
end
-- One key per section. A nil value removes the line; unknown sections get a
-- new [Header] at the end. Lines this GUI doesn't understand are kept.
local function setMapping(section, key, value)
    if shared.busy or not state.readable then return end
    local output, current, found = {}, "skins", false
    for _, line in ipairs(state.lines) do
        local h = header(line)
        if h then current = h end
        local k = not h and pair(line) or nil
        if current == section and k == key then
            if not found and value then output[#output + 1] = key .. "=" .. value end
            found = true
        else
            output[#output + 1] = line
        end
    end
    if not found and value then
        local position = section == "skins" and 1 or nil
        current = "skins"
        for i, line in ipairs(output) do
            local h = header(line)
            if h then current = h end
            if current == section then position = i + 1 end
        end
        if not position then
            output[#output + 1] = ""
            output[#output + 1] = "[" .. section:sub(1, 1):upper() .. section:sub(2) .. "]"
            position = #output + 1
        end
        table.insert(output, position, key .. "=" .. value)
    end
    state.lines = output
    indexConfig()
    markChanged()
end
-- "Weapon | Owned > Target" lives in the skins section after the Weapon=Skin
-- lines. A nil target removes it.
local function setSwap(weapon, owned, target)
    if shared.busy or not state.readable then return end
    local output, section, lastSkinLine = {}, "skins", 0
    for _, line in ipairs(state.lines) do
        local h = header(line)
        if h then section = h end
        local keep = true
        if section == "skins" and not h then
            local w, o = swapLine(line)
            if w == weapon and o == owned then keep = false end
        end
        if keep then
            output[#output + 1] = line
            if section == "skins" and not h then lastSkinLine = #output end
        end
    end
    if target then
        table.insert(output, lastSkinLine + 1, weapon .. " | " .. owned .. " > " .. target)
    end
    state.lines = output
    indexConfig()
    markChanged()
end
-- No hands: [NoHands] has Weapon=true lines, and All=true for every weapon
-- (a Weapon=false line then keeps that one's arms).
local function handsHidden(weapon)
    local v = state.values.nohands or {}
    local own = v[weapon] and tostring(v[weapon]):lower()
    if own == "true" then return true elseif own == "false" then return false end
    return tostring(v.All or ""):lower() == "true"
end
local function toggleHands(weapon)
    local all = tostring((state.values.nohands or {}).All or ""):lower() == "true"
    if handsHidden(weapon) then
        setMapping("nohands", weapon, all and "false" or nil)
    else
        setMapping("nohands", weapon, (not all) and "true" or nil)
    end
end
-- Makes a pick, then takes it back if it would put one item in two lines.
local function guarded(change, target)
    local before, was = state.lines, #configClashes()
    change()
    if #configClashes() > was then
        state.lines = before
        indexConfig()
        markChanged()
        state.status = target .. " is already used by another line. Two can't look like the same one - change that line first."
        if type(notify) == "function" then pcall(notify, "Rivals Skin Changer", state.status, 6) end
    end
end
local function saveConfig()
    assert(state.readable, "Reload the configuration before saving.")
    local current = isfile(FILE) and readfile(FILE) or nil
    assert(current == state.baseline,
        "The config changed outside this GUI. Press Reload config; your file was not overwritten.")
    local content = configText()
    if current == content then return end
    if current then
        writefile(BACKUP, current)
        assert(readfile(BACKUP) == current, "Could not verify the backup; save cancelled.")
    end
    writefile(FILE, content)
    assert(readfile(FILE) == content, "Could not verify the save. Your previous config is in " .. BACKUP)
    state.baseline = content
    state.cleanText, state.dirty = configText(), false
end

-- Settings: auto-apply is shared with the menu-tab GUI; the rest is this one's.
local function loadSettings()
    local okRead, body = pcall(readfile, SETTINGS)
    local auto
    if okRead and type(body) == "string" then
        state.settingsRead = true
        local value = body:match("autoapply%s*=%s*(%w+)")
        if value then auto = (value == "1" or value == "true" or value == "on") end
        state.mouseOffset = tonumber(body:match("mouseoffset%s*=%s*(%-?%d+)")) or 0
        local key = tonumber(body:match("togglekey%s*=%s*(%d+)"))
        state.toggleKey = key and KEY_NAMES[key] and key or DEFAULT_TOGGLE
        state.accent = body:match("accent%s*=%s*(%x%x%x%x%x%x)") or DEFAULT_ACCENT
        state.ownedOnly = body:match("ownedonly%s*=%s*(%d)") ~= "0"
        state.showOnAutoexec = body:match("showonautoexec%s*=%s*(%d)") == "1"
        state.noticeSeen = body:match("noticeseen%s*=%s*(%d)") == "1"
    end
    if auto == nil then
        auto = true
    end
    state.autoApply = auto
end
local function saveSettings()
    pcall(writefile, SETTINGS, "autoapply=" .. (state.autoApply and "1" or "0") .. "\n"
        .. "mouseoffset=" .. tostring(state.mouseOffset) .. "\n"
        .. "togglekey=" .. tostring(state.toggleKey) .. "\n"
        .. "accent=" .. tostring(state.accent) .. "\n"
        .. "ownedonly=" .. (state.ownedOnly and "1" or "0") .. "\n"
        .. "showonautoexec=" .. (state.showOnAutoexec and "1" or "0") .. "\n"
        .. "noticeseen=" .. (state.noticeSeen and "1" or "0") .. "\n")
end

-- What you own
--
-- Your player data has a CosmeticInventory table: a cosmetic's name maps to
-- true, or to a table of the weapons you own it for ({IsUniversal = true} for
-- all of them). It sits at PlayerDataController.CurrentData.Data, all Lua
-- tables, read from memory through the registry like the changer reads the
-- item libraries. nil when it can't be read; the lists then show everything.
local inventory = nil
local readInventory
do
    local mrd = memory_read
    local function rd(a) local ok, v = pcall(mrd, "uintptr_t", a) return ok and v or nil end
    local function rint(a) local ok, v = pcall(mrd, "int", a) return ok and v or nil end
    local function rbyte(a) local ok, v = pcall(mrd, "byte", a) return ok and v or nil end
    -- Roblox build 02c37bc (Sep 30 2026): an object's type is byte 1 of its
    -- header, a table's lsizenode byte 4, and a thread's global state +0x68.
    local TAG_TABLE, TAG_THREAD = 7, 10
    local function isTable(t) return t and t > 0x10000 and rbyte(t + 1) == TAG_TABLE end
    local function moduleTable(ms)
        local thread = ms and ms.Address and rd(ms.Address + 0x170)
        if not thread or thread < 0x10000 or rbyte(thread + 1) ~= TAG_THREAD then return nil end
        local g = rd(thread + 0x68)
        local reg = g and g > 0x10000 and rd(g + 0x620)
        if not isTable(reg) then return nil end
        local slot, size, arr = rint(ms.Address + 0x178), rint(reg + 8), rd(reg + 0x20)
        if not slot or not size or not arr or slot < 1 or slot > size then return nil end
        local t = rd(arr + (slot - 1) * 16)
        return isTable(t) and t or nil
    end
    -- Every string key of a table: key -> {value, type tag}
    local function fields(t)
        local out = {}
        if not isTable(t) then return out end
        local base, l = rd(t + 0x18), rbyte(t + 4)
        if not base or base < 0x10000 or not l or l > 16 then return out end
        for i = 0, 2 ^ l - 1 do
            local node = base + i * 32
            local tt, kp = rint(node + 12), rd(node + 16)
            if tt and tt ~= 0 and kp and kp > 0x10000 then
                local ok, key = pcall(mrd, "string", kp + 24)
                if ok and type(key) == "string" and #key > 0 and #key < 80 then out[key] = {rd(node), tt} end
            end
        end
        return out
    end
    readInventory = function()
        local ok, result = pcall(function()
            local ps = game:GetService("Players").LocalPlayer.PlayerScripts
            local ctl = moduleTable(ps.Controllers.PlayerDataController)
            local cur = ctl and fields(ctl).CurrentData
            local data = cur and fields(cur[1]).Data
            local inv = data and fields(data[1]).CosmeticInventory
            if not inv or not isTable(inv[1]) then return nil end
            local out, n = {}, 0
            for name, v in pairs(fields(inv[1])) do
                n = n + 1
                if v[2] == TAG_TABLE then
                    local on = {}
                    for weapon in pairs(fields(v[1])) do on[weapon] = true end
                    out[name] = on
                else
                    out[name] = true
                end
            end
            return n > 0 and out or nil
        end)
        inventory = ok and result or nil
        return inventory ~= nil
    end
end
-- Owned at all, or (for a skin) owned for that weapon.
local function owns(name, weapon)
    local e = inventory and inventory[name]
    if e == true then return true end
    if type(e) ~= "table" then return false end
    return weapon == nil or e.IsUniversal == true or e[weapon] == true
end
-- Whether the "you own" lists are cut down to what you own.
local function ownedOnly() return state.ownedOnly and inventory ~= nil end

-- Item lists

local function fetch(url)
    local body = (type(httpget) == "function") and httpget(url) or game:HttpGet(url)
    assert(type(body) == "string" and #body > 0, "Download failed: " .. url)
    return body
end
local function decode(text) return game:GetService("HttpService"):JSONDecode(text) end
local function jsAssignment(source, name)
    local encoded = source:match("window%." .. name .. "%s*=%s*(%b[])")
    return encoded and decode(encoded) or nil
end

local function loadCatalog()
    readInventory()
    local out = {weapons = {}, wraps = {}, finishers = {}, charms = {}, skyFaces = {}, loaded = true}
    -- Weapons, their skins, pictures and rarities, as the site shows them.
    local okMap, map = pcall(function() return decode(fetch(SITE .. "skin_icon_map.json")) end)
    local byName = {}
    if okMap and type(map) == "table" then
        -- The map, like the game's weapon models, has an "Unobtainable" entry
        -- that isn't a weapon.
        map.Unobtainable = nil
        for weapon, skins in pairs(map) do
            local entry = {name = weapon, skins = {}, info = {}}
            for skin, data in pairs(skins) do
                entry.info[skin] = {src = data.src, rarity = data.rarity}
                if data.src and type(data.cdnUrl) == "string" and data.cdnUrl:match("^https://tr%.rbxcdn%.com/") then
                    IMAGE_URLS[data.src] = (data.cdnUrl:gsub("/150/150/", "/420/420/"))
                end
                if skin ~= "Standard" and skin ~= "Default" then entry.skins[#entry.skins + 1] = skin end
            end
            table.sort(entry.skins)
            entry.icon = entry.info.Standard and entry.info.Standard.src
            byName[weapon] = entry
        end
    end
    -- Weapons the game has models for, so a new one still shows.
    pcall(function()
        local weapons = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.ViewModels.Weapons
        for _, w in ipairs(weapons:GetChildren()) do
            if w.Name ~= "Unobtainable" then
                byName[w.Name] = byName[w.Name] or {name = w.Name, skins = {}, info = {}}
            end
        end
    end)
    -- Slots from the site's weapon list, over the built-in ones.
    local slots = {}
    for name, slot in pairs(WEAPON_SLOTS) do slots[name] = slot end
    pcall(function()
        local encoded = fetch(SITE):match("const%s+OFFICIAL_WEAPON_DATA%s*=%s*(%b[])%s*;")
        for _, w in ipairs(encoded and decode(encoded) or {}) do
            if type(w.name) == "string" and type(w.category) == "string" then slots[w.name] = w.category end
        end
    end)
    for name, w in pairs(byName) do w.slot = slots[name] or "Other" end
    for _, w in pairs(byName) do out.weapons[#out.weapons + 1] = w end
    table.sort(out.weapons, function(a, b) return a.name < b.name end)

    local okWraps, wrapsJs = pcall(fetch, SITE .. "assets/wraps.js")
    for _, row in ipairs(okWraps and jsAssignment(wrapsJs, "WRAPS") or {}) do
        if type(row[1]) == "string" and not row[1]:find("MISSING_", 1, true) then
            -- Each part: material, color, transparency, texture id. The game has
            -- no wrap pictures (it paints a 3D sheet); the site's previews are
            -- used, with these parts as color bands until one has loaded.
            local colors, textures = {}, {}
            for _, part in ipairs(type(row[4]) == "table" and row[4] or {}) do
                local ok, c = pcall(Color3.fromHex, tostring(part[2]))
                if ok and c and #colors < 3 then
                    colors[#colors + 1] = c
                    local tex = tonumber(part[4]) or 0
                    textures[#colors] = tex > 0 and string.format("assets/images/wraps/%.0f.png", tex) or false
                end
            end
            -- The site's wrap previews, one PNG per wrap named after it.
            local slug = row[1]:lower():gsub("[^a-z0-9]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
            out.wraps[#out.wraps + 1] = {name = row[1], rarity = WRAP_RARITY_NAMES[(tonumber(row[2]) or 0) + 1],
                colors = colors, textures = textures, src = "assets/images/wrapicons/" .. slug .. ".png"}
        end
    end
    local okCos, cosJs = pcall(fetch, SITE .. "assets/cosmetics.js")
    for _, kind in ipairs({{"finishers", "FINISHERS", "assets/images/finishers/"}, {"charms", "CHARMS", "assets/images/charms/"}}) do
        local seen = {}
        for _, row in ipairs(okCos and jsAssignment(cosJs, kind[2]) or {}) do
            if type(row[1]) == "string" and not row[1]:find("MISSING_", 1, true) then
                seen[row[1]] = true
                out[kind[1]][#out[kind[1]] + 1] = {name = row[1], rarity = row[2],
                    src = (type(row[3]) == "string" and row[3] ~= "") and (kind[3] .. row[3]) or nil}
            end
        end
        -- Anything the game has that the site doesn't list yet.
        pcall(function()
            local folder = kind[1] == "finishers"
                and game:GetService("ReplicatedStorage").Modules.Finishers
                or game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Charms
            for _, m in ipairs(folder:GetChildren()) do
                if not seen[m.Name] and not m.Name:find("MISSING_", 1, true) then
                    out[kind[1]][#out[kind[1]] + 1] = {name = m.Name}
                end
            end
        end)
        table.sort(out[kind[1]], function(a, b) return a.name < b.name end)
    end
    table.sort(out.wraps, function(a, b) return a.name < b.name end)

    local okSky, skies = pcall(function() return decode(fetch(SITE .. "assets/skyboxes.json")) end)
    for name, face in pairs(SKY_FACES) do out.skyFaces[name] = face end
    for _, sky in ipairs(okSky and type(skies) == "table" and skies.skyboxes or {}) do
        if type(sky.name) == "string" and type(sky.faces) == "table" and sky.faces.ft then
            out.skyFaces[sky.name:lower()] = tostring(sky.faces.ft)
        end
    end
    catalog = out
    if not state.weapon and #catalog.weapons > 0 then state.weapon = catalog.weapons[1].name end
    state.status = okMap and string.format("%d weapons, %d wraps, %d finishers, %d charms",
        #catalog.weapons, #catalog.wraps, #catalog.finishers, #catalog.charms)
        or "The site is unreachable - pictures and skin lists are missing."
end

-- Running the changer

local function currentContext()
    local ok, result = pcall(function()
        if tonumber(game.GameId) ~= RIVALS_GAME_ID or not game:IsLoaded() then return nil end
        local jobId = game.JobId
        if type(jobId) ~= "string" or jobId == "" then return nil end
        local weapons = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.ViewModels.Weapons
        if not weapons or not weapons.Address or #weapons:GetChildren() == 0 then return nil end
        return {key = jobId .. ":" .. tostring(weapons.Address), wf = weapons.Address}
    end)
    return ok and result or nil
end
local function upstreamBusy()
    local stamp = _G.__RIVALS_SKIN_CHANGER_BUSY
    return type(stamp) == "number" and tick() - stamp < 180
end
local function changerSource()
    return BUNDLED_ENGINE, "bundled 3.4"
end
local function apply()
    local context = currentContext()
    assert(context, "Wait for Rivals and its weapon assets to finish loading.")
    assert(not upstreamBusy(), "The changer is already running.")
    saveConfig()
    state.status = "Applying..."
    local source, from = changerSource()
    local fn, err = loadstring(source)
    assert(type(fn) == "function", err or "Could not compile the changer.")
    local before = _G.__RIVALS_SKIN_CHANGER_STATE
    local okRun, runError = pcall(fn)
    if not okRun then
        _G.__RIVALS_SKIN_CHANGER_BUSY = nil
        error(runError)
    end
    local deadline = tick() + 150
    while tick() < deadline do
        local now = currentContext()
        if not now or now.key ~= context.key then
            state.status = "Server changed while applying - run it again."
            return
        end
        local finished = _G.__RIVALS_SKIN_CHANGER_STATE
        if type(finished) == "table" and finished ~= before and finished.wfAddr == context.wf and not upstreamBusy() then
            state.status = "Applied (" .. from .. "). Respawn to see new effects."
            return
        end
        state.status = "Applying... (a few seconds)"
        task.wait(0.5)
    end
    error("The changer did not finish within 150s. Check the Matcha console.")
end
local function job(label, fn)
    if shared.busy then return end
    shared.busy, state.status = true, label
    task.spawn(function()
        local ok, err = pcall(fn)
        shared.busy = false
        if not ok then
            state.status = "Error: " .. tostring(err):gsub("^.-:%d+: ", ""):sub(1, 90)
            print("[Rivals GUI] " .. tostring(err))
        end
    end)
end

-- Sound preview: the equip sounds briefly become the picked sound (see
-- RivalsSkinGui.lua for how the strings are found).
local PREVIEW_SECONDS = 10
local DEFAULT_SOUNDS = {Hit = "13110130082", Critical = "16537449730", Kill = "16530229616"}
local previewing = false
local function rdq(a) local ok, v = pcall(memory_read, "uintptr_t", a) return ok and v or nil end
local function rdi(a) local ok, v = pcall(memory_read, "int", a) return ok and v or nil end
local function readLuaString(ts) local ok, v = pcall(memory_read, "string", ts + 24) return ok and v or nil end
local function writeLuaString(ts, text)
    for i = 1, #text do memory_write("byte", ts + 24 + i - 1, string.byte(text, i)) end
    memory_write("byte", ts + 24 + #text, 0)
    memory_write("int", ts + 20, #text)
end
local function equipSoundStrings()
    local modules = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
    local ms = modules and modules:FindFirstChild("SoundLibrary")
    local thread = ms and rdq(ms.Address + 0x170)
    local g = thread and rdq(thread + 0x68)
    local reg = g and rdq(g + 0x620)
    local slot, arr = ms and rdi(ms.Address + 0x178), reg and rdq(reg + 0x20)
    local t = arr and slot and slot > 0 and rdq(arr + (slot - 1) * 16)
    if not t then return {} end
    local base = rdq(t + 0x18)
    local okL, l = pcall(memory_read, "byte", t + 4)
    if not base or not okL or l > 12 then return {} end
    for i = 0, 2 ^ l - 1 do
        local node = base + i * 32
        local key = rdq(node + 16)
        if key and readLuaString(key) == "EquipSounds" then
            local list = rdq(node)
            local size, items = list and rdi(list + 8), list and rdq(list + 0x20)
            local out = {}
            for j = 0, (size or 0) - 1 do
                local ts = rdq(items + j * 16)
                local text = ts and readLuaString(ts)
                if text and text:find("^rbxassetid://%d+$") then out[#out + 1] = ts end
            end
            return out
        end
    end
    return {}
end
local function previewSound(id)
    if previewing then return "Already on - switch weapons to hear it." end
    local digits = id and tostring(id):match("(%d+)$")
    if not digits then return "That one is muted - nothing to play." end
    local text = "rbxassetid://" .. digits
    if #text > 31 then return "That id is too long to preview." end
    local strings = equipSoundStrings()
    if #strings == 0 then return "Preview not available right now." end
    local saved = {}
    for _, ts in ipairs(strings) do
        saved[#saved + 1] = {ts, readLuaString(ts)}
        writeLuaString(ts, text)
    end
    previewing = true
    task.spawn(function()
        task.wait(PREVIEW_SECONDS)
        for _, s in ipairs(saved) do
            if readLuaString(s[1]) == text then writeLuaString(s[1], s[2]) end
        end
        previewing = false
    end)
    return "Switch weapons (1-4) in the next " .. PREVIEW_SECONDS .. " s to hear it."
end

-- Pictures: downloaded one at a time, newest request first so what's on
-- screen loads before what was scrolled past. The bytes are kept per file;
-- each place a picture is drawn gets its own Image object, so one texture can
-- show on several tiles at once.

local images, imageQueue, imageWorker = {}, {}, false
local artworkRevision=0
local lastInteraction=0
local imageObjects = {}
local function cachePath(path) return CACHE .. "/" .. path:gsub("[^%w%-_%.]", "_") .. ".dat" end
local function loadImage(path)
    local file = cachePath(path)
    local okHas, has = pcall(isfile, file)
    if okHas and has then
        local okRead, body = pcall(readfile, file)
        if okRead and type(body) == "string" and #body > 8 then return body end
    end
    local ok, body = false, nil
    if IMAGE_URLS[path] then ok, body = pcall(fetch, IMAGE_URLS[path]) end
    if not ok or type(body) ~= "string" or body:sub(2,4) ~= "PNG" then ok, body = pcall(fetch, SITE .. path) end
    if not ok or body:sub(2, 4) ~= "PNG" then return nil end
    pcall(writefile, file, body)
    return body
end
local function requestImage(path)
    local e = images[path]
    if e then return e end
    e = {state = "queued"}
    images[path] = e
    imageQueue[#imageQueue + 1] = path
    if not imageWorker then
        imageWorker = true
        pcall(makefolder, CACHE)
        task.spawn(function()
            while #imageQueue > 0 and _G.__RivalsGuiSession == guiToken do
                -- Yield before any synchronous HTTP/decode work and leave clicks/drags alone.
                task.wait(.12)
                if ismouse1pressed() or tick()-lastInteraction < .35 then
                    task.wait(.25)
                else
                local p = table.remove(imageQueue,1)
                local ok, data = pcall(loadImage, p)
                images[p].data = ok and data or nil
                images[p].state = images[p].data and "ok" or "failed"
                artworkRevision=artworkRevision+1
                end
            end
            imageWorker = false
        end)
    end
    return e
end

-- Drawing: a pool per kind, reused frame to frame; each object only gets a
-- property written when it changed.

local V2, RGB = Vector2.new, Color3.fromRGB
local FONT = (Drawing.Fonts and (Drawing.Fonts.System or Drawing.Fonts.UI)) or 1
local FONT_BOLD = (Drawing.Fonts and Drawing.Fonts.SystemBold) or FONT
local C = {
    bg = RGB(15, 16, 21), bar = RGB(19, 20, 27), panel = RGB(22, 24, 31), card = RGB(29, 31, 40),
    cardHover = RGB(37, 40, 52), line = RGB(44, 47, 60), text = RGB(226, 229, 236), dim = RGB(138, 144, 160),
    faint = RGB(90, 96, 112), good = RGB(80, 210, 120), bad = RGB(240, 90, 90),
}
-- The accent and the shades made from it; picked in Settings.
local ACCENTS = {"568cff", "8b5cf6", "ec4899", "ef4444", "f97316", "eab308", "22c55e", "14b8a6", "06b6d4", "e5e7eb"}
local function applyAccent(hex)
    local ok, c = pcall(Color3.fromHex, "#" .. tostring(hex))
    if not ok or not c then c = Color3.fromHex("#" .. DEFAULT_ACCENT) end
    C.accent = c
    C.accentDim = Color3.new(c.R * 0.42, c.G * 0.42, c.B * 0.42)
    C.accentHot = Color3.new(math.min(1, c.R + 0.08), math.min(1, c.G + 0.08), math.min(1, c.B + 0.08))
    -- Dark text on light accents so labels stay readable.
    local light = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B > 0.62
    C.onAccent = light and RGB(20, 22, 28) or RGB(255, 255, 255)
end
applyAccent(state.accent)
-- Opacity of everything drawn this frame; the open/close animation lowers it.
local Fade = 1
local Pool, Cache, Used = {sq = {}, tx = {}, ln = {}, ci = {}}, {sq = {}, tx = {}, ln = {}, ci = {}}, {sq = 0, tx = 0, ln = 0, ci = 0}
local CLASS = {sq = "Square", tx = "Text", ln = "Line", ci = "Circle"}
local shownImages, drawnImages = {}, {}

local function take(kind)
    local i = Used[kind] + 1
    Used[kind] = i
    local obj = Pool[kind][i]
    if not obj then
        obj = Drawing.new(CLASS[kind])
        Pool[kind][i], Cache[kind][i] = obj, {}
        if kind == "tx" then pcall(function() obj.Outline = false end) end
    end
    return obj, Cache[kind][i]
end
local function put(o, c, k, v) if c[k] ~= v then c[k] = v; o[k] = v end end
local function place(o, c, k, x, y)
    if c[k .. "x"] ~= x or c[k .. "y"] ~= y then c[k .. "x"], c[k .. "y"] = x, y; o[k] = V2(x, y) end
end
local function rect(x, y, w, h, color, z, corner, alpha)
    if w <= 0 or h <= 0 then return end
    local o, c = take("sq")
    place(o, c, "Position", x, y) place(o, c, "Size", w, h)
    put(o, c, "Color", color) put(o, c, "Filled", true) put(o, c, "Corner", corner or 0)
    put(o, c, "ZIndex", z or 1) put(o, c, "Transparency", (alpha or 1) * Fade) put(o, c, "Visible", true)
end
local function border(x, y, w, h, color, z, corner, thick)
    local o, c = take("sq")
    place(o, c, "Position", x, y) place(o, c, "Size", w, h)
    put(o, c, "Color", color) put(o, c, "Filled", false) put(o, c, "Thickness", thick or 1)
    put(o, c, "Corner", corner or 0) put(o, c, "ZIndex", z or 1) put(o, c, "Transparency", Fade) put(o, c, "Visible", true)
end
-- Width of a string as Matcha lays it out (its TextBounds), remembered per
-- string; an estimate if that isn't available.
local measurer, widths, widthCount = nil, {}, 0
local function textWidth(s, size, bold)
    s = tostring(s)
    local key = s .. "\1" .. size .. (bold and "b" or "")
    local known = widths[key]
    if known then return known end
    local ok, w = pcall(function()
        measurer = measurer or Drawing.new("Text")
        measurer.Visible = false
        measurer.Size, measurer.Font, measurer.Text = size, bold and FONT_BOLD or FONT, s
        return measurer.TextBounds.X
    end)
    w = (ok and type(w) == "number" and w > 0) and w or #s * size * 0.58
    if widthCount > 4000 then widths, widthCount = {}, 0 end
    widths[key], widthCount = w, widthCount + 1
    return w
end
local function fitText(s, room, size, bold)
    s = tostring(s)
    if textWidth(s, size, bold) <= room then return s end
    local lo, hi = 0, #s
    while lo < hi do
        local mid = math.floor((lo + hi + 1) / 2)
        if textWidth(s:sub(1, mid) .. "..", size, bold) <= room then lo = mid else hi = mid - 1 end
    end
    return s:sub(1, math.max(1, lo)) .. ".."
end
local function text(s, x, y, color, size, z, bold, center)
    s = tostring(s)
    if s == "" then return end
    local o, c = take("tx")
    size = size or 13
    put(o, c, "Text", s) put(o, c, "Size", size) put(o, c, "Font", bold and FONT_BOLD or FONT)
    -- Matcha draws text higher than its position by about a third of the size;
    -- this puts the letters where the layout expects them.
    put(o, c, "Center", center and true or false) place(o, c, "Position", math.floor(x + 0.5), math.floor(y + size * 0.3 + 0.5))
    put(o, c, "Color", color) put(o, c, "ZIndex", z or 5) put(o, c, "Transparency", Fade) put(o, c, "Visible", true)
end
local function line(x1, y1, x2, y2, color, z, thick)
    local o, c = take("ln")
    place(o, c, "From", x1, y1) place(o, c, "To", x2, y2)
    put(o, c, "Color", color) put(o, c, "Thickness", thick or 1) put(o, c, "ZIndex", z or 5)
    put(o, c, "Transparency", Fade) put(o, c, "Visible", true)
end
local function circle(x, y, r, color, z, filled, thick)
    local o, c = take("ci")
    place(o, c, "Position", x, y) put(o, c, "Radius", r) put(o, c, "Color", color)
    put(o, c, "Filled", filled and true or false) put(o, c, "Thickness", thick or 1)
    pcall(put, o, c, "NumSides", 32) put(o, c, "ZIndex", z or 5) put(o, c, "Transparency", Fade) put(o, c, "Visible", true)
end
-- A picture from the site; false while it downloads. `key` names the spot it
-- is drawn in when the same file shows more than once.
local function picture(path, x, y, w, h, z, key, alpha)
    if not path then return false end
    local e = requestImage(path)
    if e.state ~= "ok" then return false end
    key = key or path
    local slot = imageObjects[key]
    if not slot or slot.path ~= path then
        if slot then pcall(function() slot.obj:Remove() end) end
        local obj = Drawing.new("Image")
        obj.Visible = false
        obj.Data = e.data
        slot = {obj = obj, cache = {}, path = path}
        imageObjects[key] = slot
    end
    local o, c = slot.obj, slot.cache
    place(o, c, "Position", x, y) place(o, c, "Size", w, h)
    put(o, c, "ZIndex", z or 4) put(o, c, "Transparency", (alpha or 1) * Fade)
    if not c.Visible then c.Visible = true; o.Visible = true end
    drawnImages[key] = slot
    return true
end
local function beginFrame()
    for k in pairs(Used) do Used[k] = 0 end
    drawnImages = {}
end
local function endFrame()
    for kind, list in pairs(Pool) do
        for i = Used[kind] + 1, #list do
            local c = Cache[kind][i]
            if c and c.Visible ~= false then c.Visible = false; list[i].Visible = false end
        end
    end
    for key, slot in pairs(shownImages) do
        if not drawnImages[key] then slot.cache.Visible = false; slot.obj.Visible = false end
    end
    shownImages = drawnImages
end
local function wipe()
    for kind, list in pairs(Pool) do
        for _, o in ipairs(list) do pcall(function() o.Visible = false; o:Remove() end) end
        Pool[kind], Cache[kind], Used[kind] = {}, {}, 0
    end
    for _, slot in pairs(imageObjects) do
        pcall(function() slot.obj.Visible = false; slot.obj:Remove() end)
    end
    imageObjects, images = {}, {}
    if measurer then pcall(function() measurer:Remove() end) measurer = nil end
end

-- Input: the mouse and the keyboard are polled every frame. A click counts on
-- release, so pressing and dragging a list scrolls it instead.

local mouse, mouseAt = nil, 0
local M = {x = 0, y = 0, down = false, press = false, release = false, px = 0, py = 0, dragged = false, took = false}
local keyState = {}
local function keyHit(vk)
    local ok, down = pcall(iskeypressed, vk)
    down = ok and down == true
    local was = keyState[vk]
    keyState[vk] = down
    return down and not was, down
end
local function readInput()
    -- The player (and its mouse) is a new object after a server change.
    if not mouse or tick() - mouseAt > 2 then
        mouseAt = tick()
        pcall(function() mouse = game:GetService("Players").LocalPlayer:GetMouse() end)
    end
    local ok = pcall(function() M.x, M.y = mouse.X, mouse.Y + (state.mouseOffset or 0) end)
    if not ok then M.x, M.y = -1, -1 end
    local active = not isrbxactive or isrbxactive() ~= false
    local down = active and ismouse1pressed() == true
    M.press = down and not M.down
    M.release = M.down and not down
    M.down = down
    if M.press or M.release or M.down then lastInteraction=tick() end
    if M.press then M.px, M.py, M.dragged = M.x, M.y, false end
    if M.down and (math.abs(M.x - M.px) > 5 or math.abs(M.y - M.py) > 5) then M.dragged = true end
    M.took = false
end
local function over(x, y, w, h) return M.x >= x and M.x < x + w and M.y >= y and M.y < y + h end
local function clicked(x, y, w, h)
    if M.took or not M.release or M.dragged then return false end
    if over(x, y, w, h) and M.px >= x and M.px < x + w and M.py >= y and M.py < y + h then
        M.took = true
        return true
    end
    return false
end

-- Text boxes: while one is focused, typing goes to it and not to the game.
local TYPED = {}
for i = 0, 25 do TYPED[0x41 + i] = {string.char(97 + i), string.char(65 + i)} end
for i = 0, 9 do TYPED[0x30 + i] = {tostring(i), (")!@#$%^&*("):sub(i + 1, i + 1)} end
TYPED[0x20] = {" ", " "} TYPED[0xBD] = {"-", "_"} TYPED[0xBE] = {".", ">"} TYPED[0xDE] = {"'", "\""}
TYPED[0xBF] = {"/", "?"} TYPED[0xBA] = {";", ":"}
local focus, backspaceAt = nil, 0
local function typeInto(id)
    local value = state.inputs[id] or ""
    local shift = select(2, keyHit(0x10))
    for vk, chars in pairs(TYPED) do
        if keyHit(vk) then value = value .. chars[shift and 2 or 1] end
    end
    local bsHit, bsDown = keyHit(0x08)
    if bsHit then value = value:sub(1, -2); backspaceAt = tick() + 0.45
    elseif bsDown and tick() > backspaceAt then value = value:sub(1, -2); backspaceAt = tick() + 0.04 end
    if keyHit(0x0D) or keyHit(0x1B) then focus = nil end
    state.inputs[id] = value
end
local function textbox(id, x, y, w, h, placeholder)
    local focused = focus == id
    rect(x, y, w, h, focused and C.cardHover or C.card, 3, 5)
    border(x, y, w, h, focused and C.accent or C.line, 3, 5)
    local value = state.inputs[id] or ""
    local blink = focused and (tick() % 1 < 0.5) and "|" or ""
    if value == "" and not focused then
        text(placeholder, x + w / 2, y + (h - 13) / 2, C.faint, 13, 5, false, true)
    else
        text(fitText(value, w - 20, 13) .. blink, x + 9, y + (h - 13) / 2, C.text, 13, 5)
    end
    if clicked(x, y, w, h) then focus = id end
    return value
end
local function button(x, y, w, h, label, primary, disabled)
    local hot = not disabled and over(x, y, w, h)
    rect(x, y, w, h, primary and (hot and C.accentHot or C.accent) or (hot and C.cardHover or C.card), 3, 5)
    if not primary then border(x, y, w, h, C.line, 3, 5) end
    text(label, x + w / 2, y + (h - 13) / 2, disabled and C.faint or (primary and C.onAccent or C.text), 13, 5, primary, true)
    return not disabled and clicked(x, y, w, h)
end
-- A row of choices; returns the index clicked.
local function segmented(x, y, w, h, labels, selected)
    rect(x, y, w, h, C.panel, 3, 6)
    local each, picked = w / #labels, nil
    for i, label in ipairs(labels) do
        local bx = x + (i - 1) * each
        if i == selected then
            rect(bx + 2, y + 2, each - 4, h - 4, C.card, 3, 5)
            line(bx + each * 0.3, y + h - 3, bx + each * 0.7, y + h - 3, C.accent, 5, 2)
        end
        text(label, bx + each / 2, y + (h - 13) / 2, i == selected and C.text or C.dim, 13, 5, i == selected, true)
        if clicked(bx, y, each, h) then picked = i end
    end
    return picked
end

-- Scrolling in whole rows: drag the list, drag its bar, or PageUp/PageDown and
-- the arrow keys while pointing at it.
local function scroller(id, x, y, w, h, total, visible)
    local maxFirst = math.max(0, total - visible)
    local s = state.scroll[id] or {first = 0}
    state.scroll[id] = s
    if over(x, y, w, h) then
        if keyHit(0x22) or keyHit(0x28) then s.first = s.first + (keyState[0x22] and visible or 1) end
        if keyHit(0x21) or keyHit(0x26) then s.first = s.first - (keyState[0x21] and visible or 1) end
    end
    if M.press and over(x, y, w, h) then s.grab, s.grabFirst = M.y, s.first end
    if not M.down then s.grab = nil end
    if s.grab and M.dragged then
        local rowH = h / math.max(1, visible)
        s.first = s.grabFirst - math.floor((M.y - s.grab) / rowH + 0.5)
    end
    s.first = math.max(0, math.min(maxFirst, s.first))
    -- The bar: drag the thumb, or click above or below it to move a page.
    -- (Matcha can't read the mouse wheel.)
    if maxFirst > 0 then
        local bx, bw = x + w + 4, 8
        local barH = math.max(28, h * visible / total)
        local barY = y + (h - barH) * s.first / maxFirst
        local onBar = over(bx - 2, y, bw + 4, h)
        rect(bx, y, bw, h, C.card, 3, 4)
        if M.press and onBar then
            if M.y >= barY and M.y <= barY + barH then
                s.bar = M.y - barY
            else
                s.first = s.first + (M.y < barY and -visible or visible)
                s.grab = nil
            end
            M.dragged = true
        end
        if not M.down then s.bar = nil end
        if s.bar then
            s.first = math.floor((M.y - s.bar - y) / math.max(1, h - barH) * maxFirst + 0.5)
            s.grab = nil
            M.dragged = true
        end
        s.first = math.max(0, math.min(maxFirst, s.first))
        barY = y + (h - barH) * s.first / maxFirst
        rect(bx, barY, bw, barH, s.bar and C.accent or (onBar and C.dim or C.faint), 4, 4)
    end
    return s.first
end
local function resetScroll(id) state.scroll[id] = {first = 0} end

-- Pieces of the window

local function matches(q, name) return q == "" or name:lower():find(q, 1, true) ~= nil end
local function query(id) return trim(state.inputs[id] or ""):lower() end

-- A list on the left: rows of names, one picked, a dot where something is set.
local function sideList(id, x, y, w, h, items, selected, marked)
    local rowH = 30
    local visible = math.floor(h / rowH)
    local first = scroller(id, x, y, w, h, #items, visible)
    local picked
    for i = first + 1, math.min(#items, first + visible) do
        local name = items[i]
        local ry = y + (i - first - 1) * rowH
        local hot = over(x, ry, w, rowH - 4)
        if name == selected then
            rect(x, ry, w, rowH - 4, C.card, 3, 5)
            rect(x, ry + 6, 2, rowH - 16, C.accent, 4, 1)
        elseif hot then
            rect(x, ry, w, rowH - 4, C.panel, 3, 5)
        end
        text(fitText(name, w - 30, 13), x + 12, ry + 6, name == selected and C.text or C.dim, 13, 5)
        if marked and marked(name) then circle(x + w - 12, ry + (rowH - 4) / 2, 3, C.good, 5, true) end
        if clicked(x, ry, w, rowH - 4) then picked = name end
    end
    if #items == 0 then text("Nothing matches.", x + 8, y + 6, C.faint, 13, 5) end
    return picked
end

-- A grid of tiles with pictures. Each item: {name, src, rarity, colors, none}.
local TILE_W, TILE_H = 104, 118
local function tileGrid(id, x, y, w, h, items, isSelected, badge)
    local cols = math.max(1, math.floor((w + 8) / (TILE_W + 8)))
    local rowsVisible = math.max(1, math.floor((h + 8) / (TILE_H + 8)))
    local rows = math.ceil(#items / cols)
    local first = scroller(id, x, y, w, h, rows, rowsVisible)
    local gap = cols > 1 and (w - cols * TILE_W) / (cols - 1) or 0
    local picked
    for r = first, math.min(rows - 1, first + rowsVisible - 1) do
        for col = 0, cols - 1 do
            local item = items[r * cols + col + 1]
            if item then
                local tx = x + col * (TILE_W + gap)
                local ty = y + (r - first) * (TILE_H + 8)
                local sel = isSelected(item)
                local hot = over(tx, ty, TILE_W, TILE_H)
                rect(tx, ty, TILE_W, TILE_H, hot and C.cardHover or C.card, 3, 6)
                if sel then border(tx, ty, TILE_W, TILE_H, C.accent, 6, 6, 2) end
                local ix, iy, is = tx + 14, ty + 8, TILE_W - 28
                if item.none then
                    circle(tx + TILE_W / 2, iy + is / 2, 18, C.dim, 5, false, 2)
                    line(tx + TILE_W / 2 - 12, iy + is / 2 + 12, tx + TILE_W / 2 + 12, iy + is / 2 - 12, C.dim, 5, 2)
                elseif item.src and picture(item.src, ix, iy, is, is, 4) then
                    -- The picture; the lines below draw stand-ins while it loads.
                elseif item.colors and #item.colors > 0 then
                    -- Like the game's wrap icon: the first part is the sheet,
                    -- the second the band along the bottom, the third a corner.
                    local cols, texs = item.colors, item.textures or {}
                    local sheetH = math.floor(is * 0.68)
                    local areas = {
                        {ix, iy, is, sheetH},
                        {ix, iy + sheetH, is, is - sheetH},
                        {ix + is - 22, iy + sheetH - 22, 22, 22},
                    }
                    for k = 1, math.max(2, #cols) do
                        local a = areas[k]
                        local col3 = cols[k] or cols[1]
                        if a and col3 then
                            rect(a[1], a[2], a[3], a[4], col3, 4, 0)
                            local tex = texs[k] or (cols[k] == nil and texs[1]) or nil
                            if tex and not item.src then picture(tex, a[1], a[2], a[3], a[4], 5, "wrap:" .. item.name .. ":" .. k, 0.6) end
                        end
                    end
                    border(ix, iy, is, is, C.line, 5, 0)
                else
                    text(item.src and "..." or "?", tx + TILE_W / 2, iy + is / 2 - 7, C.faint, 14, 5, false, true)
                end
                text(fitText(item.name, TILE_W - 10, 12), tx + TILE_W / 2, ty + TILE_H - 26, sel and C.text or C.dim, 12, 5, sel, true)
                local rc = item.rarity and RARITY_COLORS[item.rarity]
                if rc then rect(tx + 30, ty + TILE_H - 6, TILE_W - 60, 2, rc, 5, 1) end
                local mark = badge and badge(item)
                if mark then
                    rect(tx + TILE_W - 24, ty + 6, 18, 18, C.accent, 5, 9)
                    text(mark, tx + TILE_W - 15, ty + 8, C.onAccent, 12, 6, true, true)
                end
                if clicked(tx, ty, TILE_W, TILE_H) then picked = item end
            end
        end
    end
    if #items == 0 then text("Nothing matches.", x + 4, y + 6, C.faint, 13, 5) end
    return picked
end

local function weaponEntry(name)
    for _, w in ipairs(catalog.weapons) do if w.name == name then return w end end
end
-- ownedFor: a weapon name, to list only the skins you own for it.
local function skinItems(w, exclude, searchId, withNone, ownedFor)
    local out = {}
    if withNone then out[1] = {name = "Default", none = true} end
    local q = query(searchId)
    local mine = ownedFor and ownedOnly()
    for _, skin in ipairs(w and w.skins or {}) do
        if skin ~= exclude and matches(q, skin)
            and (not mine or owns(skin, ownedFor) or (state.swaps[ownedFor] or {})[skin] ~= nil) then
            local info = w.info[skin] or {}
            out[#out + 1] = {name = skin, src = info.src, rarity = info.rarity}
        end
    end
    return out
end
local function swapCount(weapon)
    local n = 0
    for _ in pairs(state.swaps[weapon] or {}) do n = n + 1 end
    return n
end

-- Tabs

-- The main page: every weapon, grouped by slot like the game's loadout
-- (Primary, Secondary, Melee, Utility; A-Z inside a slot). Each tile shows
-- what the weapon looks like now.
local SLOT_ORDER = {"Primary", "Secondary", "Melee", "Utility", "Other"}
local function drawWeaponMain(x, y, w, h)
    rect(x, y, w, h, C.panel, 2, 8)
    text("Weapons", x + 16, y + 14, C.text, 15, 5, true)
    local setCount = 0
    for _, wpn in ipairs(catalog.weapons) do
        if (state.values.skins or {})[wpn.name] or swapCount(wpn.name) > 0 then setCount = setCount + 1 end
    end
    text(setCount .. " changed  -  pick one to choose its skin", x + 16, y + 36, C.dim, 12, 5)
    textbox("weaponSearch", x + w - 252, y + 14, 240, 28, "Search weapons or skins...")
    if not catalog.loaded then text("Loading lists...", x + 16, y + 70, C.dim, 14, 5) return end

    -- Slot tabs: All, then each slot that has a weapon.
    local tabs = {"All"}
    for _, slot in ipairs(SLOT_ORDER) do
        for _, wpn in ipairs(catalog.weapons) do
            if (wpn.slot or "Other") == slot then tabs[#tabs + 1] = slot break end
        end
    end
    local tabIndex = 1
    for i, t in ipairs(tabs) do if t == state.slotTab then tabIndex = i end end
    local pickedTab = segmented(x + 12, y + 54, w - 24, 32, tabs, tabIndex)
    if pickedTab and tabs[pickedTab] ~= tabs[tabIndex] then
        state.slotTab = tabs[pickedTab]
        resetScroll("weaponMain")
    end
    local only = tabs[pickedTab or tabIndex] ~= "All" and tabs[pickedTab or tabIndex] or nil

    -- Rows: a header per slot, then its tiles.
    local q = query("weaponSearch")
    local gx, gw, gy, gh = x + 12, w - 30, y + 96, h - 104
    local cols = math.max(1, math.floor((gw + 8) / (TILE_W + 8)))
    local gap = cols > 1 and (gw - cols * TILE_W) / (cols - 1) or 0
    local rows = {}
    for _, slot in ipairs(only and {only} or SLOT_ORDER) do
        local list = {}
        for _, wpn in ipairs(catalog.weapons) do
            if (wpn.slot or "Other") == slot then
                local hit = matches(q, wpn.name)
                if not hit then
                    for _, skin in ipairs(wpn.skins) do if matches(q, skin) then hit = true break end end
                end
                if hit then list[#list + 1] = wpn end
            end
        end
        if #list > 0 then
            rows[#rows + 1] = {header = slot, count = #list}
            for i = 1, #list, cols do
                local row = {}
                for k = i, math.min(#list, i + cols - 1) do row[#row + 1] = list[k] end
                rows[#rows + 1] = {tiles = row}
            end
        end
    end
    local HEADER_H, ROW_H = 30, TILE_H + 8
    local function height(row) return row.header and HEADER_H or ROW_H end
    -- How many rows fit at the end decides how far the list scrolls.
    local fitEnd, used = 0, 0
    for i = #rows, 1, -1 do
        used = used + height(rows[i])
        if used > gh then break end
        fitEnd = fitEnd + 1
    end
    local first = scroller("weaponMain", gx, gy, gw, gh, #rows, math.max(1, fitEnd))
    local cy = gy
    for i = first + 1, #rows do
        local row = rows[i]
        if cy + height(row) > gy + gh + 1 then break end
        if row.header then
            text(row.header:upper(), gx + 2, cy + 10, C.faint, 11, 5, true)
            text(tostring(row.count), gx + 2 + textWidth(row.header:upper(), 11, true) + 14, cy + 10, C.faint, 11, 5)
            line(gx + 110, cy + 16, gx + gw, cy + 16, C.line, 3, 1)
        else
            for col, wpn in ipairs(row.tiles) do
                local tx = gx + (col - 1) * (TILE_W + gap)
                local current = (state.values.skins or {})[wpn.name]
                local swaps = swapCount(wpn.name)
                local hot = over(tx, cy, TILE_W, TILE_H)
                rect(tx, cy, TILE_W, TILE_H, hot and C.cardHover or C.card, 3, 6)
                if current or swaps > 0 then border(tx, cy, TILE_W, TILE_H, C.accentDim, 6, 6, 2) end
                local info = current and wpn.info[current]
                local src = (info and info.src) or wpn.icon
                local is = TILE_W - 28
                if not picture(src, tx + 14, cy + 8, is, is, 4) then
                    text(src and "..." or "?", tx + TILE_W / 2, cy + 8 + is / 2 - 7, C.faint, 14, 5, false, true)
                end
                text(fitText(wpn.name, TILE_W - 10, 12), tx + TILE_W / 2, cy + TILE_H - 32, C.text, 12, 5, true, true)
                local sub = current or (swaps > 0 and (swaps .. " swap" .. (swaps == 1 and "" or "s")) or "Default")
                text(fitText(sub, TILE_W - 10, 11), tx + TILE_W / 2, cy + TILE_H - 17,
                    (current or swaps > 0) and C.accent or C.faint, 11, 5, false, true)
                if clicked(tx, cy, TILE_W, TILE_H) then
                    state.weapon, state.skinsView = wpn.name, "weapon"
                    state.swapStep = state.swapOwned[wpn.name] and 2 or 1
                    state.inputs.skinSearch = ""
                    resetScroll("skinGrid")
                end
            end
        end
        cy = cy + height(row)
    end
    if #rows == 0 then text("No weapon or skin matches.", gx + 4, gy + 6, C.faint, 13, 5) end
end

local function drawSkins(x, y, w, h)
    local wpn = state.skinsView == "weapon" and weaponEntry(state.weapon)
    if not wpn then
        state.skinsView = "main"
        return drawWeaponMain(x, y, w, h)
    end

    -- One weapon's page
    local rx, rw = x, w
    rect(rx, y, rw, h, C.panel, 2, 8)
    local weapon = wpn.name
    if button(rx + 12, y + 18, 72, 32, "< Back") or keyHit(0x1B) then
        state.skinsView = "main"
        focus = nil
        return
    end
    rect(rx + 94, y + 12, 44, 44, C.card, 3, 6)
    local selectedSkin = (state.values.skins or {})[weapon]
    local selectedInfo = selectedSkin and wpn.info[selectedSkin]
    picture((selectedInfo and selectedInfo.src) or wpn.icon, rx + 96, y + 14, 40, 40, 4)
    text(weapon, rx + 148, y + 14, C.text, 15, 5, true)
    local current = (state.values.skins or {})[weapon]
    local sub = state.mode == "Switch" and ("Switch  -  " .. (current or "Default"))
        or ("Swap  -  " .. swapCount(weapon) .. " set")
    text(sub, rx + 148, y + 36, C.dim, 12, 5)
    -- Your arms in first person, for this weapon.
    if button(rx + rw - 366, y + 16, 142, 32, handsHidden(weapon) and "Hands: hidden" or "Hands: shown") then
        toggleHands(weapon)
    end
    local modeAt = segmented(rx + rw - 212, y + 16, 200, 32, {"Switch", "Swap"}, state.mode == "Switch" and 1 or 2)
    if modeAt then state.mode = modeAt == 1 and "Switch" or "Swap"; resetScroll("skinGrid") end

    local gy = y + 68
    if state.mode == "Switch" then
        text("Pick what the default " .. weapon .. " looks like. Works without owning any skin.", rx + 14, gy, C.faint, 12, 5)
        gy = gy + 22
    else
        -- 1: the skin you own, 2: what it looks like. Set pairs below.
        local owned = state.swapOwned[weapon]
        local target = owned and (state.swaps[weapon] or {})[owned]
        local step = segmented(rx + 12, gy, rw - 24, 32,
            {"1  You own: " .. fitText(owned or "pick", 150, 13), "2  Looks like: " .. fitText(target or (owned and "pick" or "-"), 150, 13)},
            state.swapStep)
        if step == 1 or (step == 2 and owned) then state.swapStep = step; resetScroll("skinGrid") end
        gy = gy + 40
        local cx = rx + 12
        for o, t in pairs(state.swaps[weapon] or {}) do
            local label = fitText(o .. "  >  " .. t, 220, 12)
            local cw = textWidth(label, 12) + 34
            if cx + cw > rx + rw - 12 then break end
            rect(cx, gy, cw, 22, C.accentDim, 3, 11)
            text(label, cx + 10, gy + 4, C.text, 12, 5)
            text("x", cx + cw - 14, gy + 3, C.dim, 13, 5, true)
            if clicked(cx + cw - 22, gy, 22, 22) then
                setSwap(weapon, o, nil)
            elseif clicked(cx, gy, cw - 22, 22) then
                state.swapOwned[weapon], state.swapStep = o, 2
            end
            cx = cx + cw + 6
        end
        gy = gy + 28
    end
    textbox("skinSearch", rx + 12, gy, rw - 24, 28, "Search skins...")
    gy = gy + 38
    local gridH = y + h - gy - 30
    local items
    if state.mode == "Switch" then
        items = skinItems(wpn, nil, "skinSearch", true)
        local hit = tileGrid("skinGrid", rx + 12, gy, rw - 30, gridH, items, function(it)
            if it.none then return current == nil end
            return it.name == current
        end)
        if hit and hit.none then
            setMapping("skins", weapon, nil)
        elseif hit then
            guarded(function() setMapping("skins", weapon, hit.name) end, hit.name)
        end
    elseif state.swapStep == 1 or not state.swapOwned[weapon] then
        items = skinItems(wpn, nil, "skinSearch", false, weapon)
        if #items == 0 and ownedOnly() and query("skinSearch") == "" then
            text("You own no skins for this weapon. Settings > Lists shows every skin.", rx + 16, gy + 30, C.dim, 12, 5)
        end
        local hit = tileGrid("skinGrid", rx + 12, gy, rw - 30, gridH, items, function(it)
            return it.name == state.swapOwned[weapon]
        end, function(it) return (state.swaps[weapon] or {})[it.name] and ">" or nil end)
        if hit then state.swapOwned[weapon], state.swapStep = hit.name, 2; resetScroll("skinGrid") end
    else
        local owned = state.swapOwned[weapon]
        local target = (state.swaps[weapon] or {})[owned]
        items = skinItems(wpn, owned, "skinSearch", true)
        local hit = tileGrid("skinGrid", rx + 12, gy, rw - 30, gridH, items, function(it)
            if it.none then return target == nil end
            return it.name == target
        end)
        if hit and hit.none then
            setSwap(weapon, owned, nil)
        elseif hit then
            guarded(function() setSwap(weapon, owned, hit.name) end, hit.name)
        end
    end
    local count = #items - ((items[1] and items[1].none) and 1 or 0)
    text(count .. " skin(s) for " .. weapon, rx + 14, y + h - 22, C.faint, 12, 5)
end

local COS_KINDS = {
    {key = "wraps", label = "Wraps", section = "wraps"},
    {key = "finishers", label = "Finishers", section = "finishers"},
    {key = "charms", label = "Charms", section = "charms"},
}
local function drawCosmetics(x, y, w, h)
    local kindIndex = 1
    for i, k in ipairs(COS_KINDS) do if k.key == state.cosKind then kindIndex = i end end
    local kind = COS_KINDS[kindIndex]
    local list = catalog[kind.key] or {}
    local values = state.values[kind.section] or {}

    local lw = 210
    rect(x, y, lw, h, C.panel, 2, 8)
    local pickedKind = segmented(x + 8, y + 8, lw - 16, 30, {"Wraps", "Finishers", "Charms"}, kindIndex)
    if pickedKind and pickedKind ~= kindIndex then
        state.cosKind = COS_KINDS[pickedKind].key
        resetScroll("cosOwned") resetScroll("cosGrid")
        return
    end
    text("YOU OWN", x + 12, y + 48, C.faint, 11, 5, true)
    local sid = "cosOwnSearch" .. kind.key
    textbox(sid, x + 10, y + 66, lw - 20, 28, "Search...")
    local names, q = {}, query(sid)
    for _, item in ipairs(list) do if matches(q, item.name) and (values[item.name] ~= nil or not ownedOnly() or owns(item.name)) then names[#names + 1] = item.name end end
    local owned = state.owned[kind.key]
    local picked = sideList("cosOwned", x + 8, y + 102, lw - 22, h - 110, names, owned, function(n) return values[n] ~= nil end)
    if picked then state.owned[kind.key] = picked; resetScroll("cosGrid") end
    owned = state.owned[kind.key]

    local rx, rw = x + lw + 12, w - lw - 12
    rect(rx, y, rw, h, C.panel, 2, 8)
    if not owned then
        text("Pick one you own on the left, then what it should look like.", rx + 16, y + 18, C.dim, 13, 5)
        text("Saved as Owned=Target: the game shows the target wherever the owned one would be.", rx + 16, y + 40, C.faint, 12, 5)
        return
    end
    local target = values[owned]
    local season = target and target:match("^(Season %d+)%s")
    text(owned, rx + 16, y + 14, C.text, 15, 5, true)
    text("looks like  " .. (target or "itself"), rx + 16, y + 36, C.dim, 12, 5)
    local gy = y + 62
    if kind.key == "charms" and season then
        -- Season charms hold every rank; one has to be picked.
        local current = target:match("^Season %d+%s+(.+)$") or RANKS[1]
        local ri = 1
        for i, r in ipairs(RANKS) do if r == current then ri = i end end
        text("Rank", rx + 16, gy + 7, C.dim, 13, 5)
        if button(rx + 60, gy, 30, 28, "<") then
            ri = math.max(1, ri - 1); state.rank[owned] = RANKS[ri]; setMapping("charms", owned, season .. " " .. RANKS[ri])
        end
        text(RANKS[ri], rx + 150, gy + 7, C.text, 13, 5, true, true)
        if button(rx + 210, gy, 30, 28, ">") then
            ri = math.min(#RANKS, ri + 1); state.rank[owned] = RANKS[ri]; setMapping("charms", owned, season .. " " .. RANKS[ri])
        end
        gy = gy + 38
    end
    local tsid = "cosTargetSearch" .. kind.key
    textbox(tsid, rx + 12, gy, rw - 24, 28, "Search looks like...")
    gy = gy + 38
    local items, tq = {{name = "None", none = true}}, query(tsid)
    for _, item in ipairs(list) do
        if item.name ~= owned and matches(tq, item.name) then items[#items + 1] = item end
    end
    local hit = tileGrid("cosGrid", rx + 12, gy, rw - 30, y + h - gy - 30, items, function(it)
        if it.none then return target == nil end
        return it.name == target or (season ~= nil and it.name == season)
    end)
    if hit then
        if hit.none then
            setMapping(kind.section, owned, nil)
        elseif kind.key == "charms" and hit.name:match("^Season %d+$") then
            guarded(function() setMapping("charms", owned, hit.name .. " " .. (state.rank[owned] or RANKS[1])) end, hit.name)
        else
            guarded(function() setMapping(kind.section, owned, hit.name) end, hit.name)
        end
    end
    local set = 0
    for _ in pairs(values) do set = set + 1 end
    text(set .. " " .. kind.label:lower() .. " set  -  " .. #list .. " in the list", rx + 14, y + h - 22, C.faint, 12, 5)
end

-- Every sky in one grid (the groups only existed because Matcha's own menu
-- couldn't scroll a dropdown): the game's skies first, then the uploaded ones.
local function drawVisuals(x, y, w, h)
    local skyNow = ((state.values.skybox or {}).Preset or ""):lower()
    local rx, rw = x, w
    rect(rx, y, rw, h, C.panel, 2, 8)
    text("Skybox", rx + 16, y + 14, C.text, 15, 5, true)
    text(skyNow ~= "" and ("Now: " .. skyNow .. " (next map load)") or "Now: the game's own sky",
        rx + 16, y + 36, C.dim, 12, 5)
    local lightNow = ((state.values.lighting or {}).Preset or ""):lower()
    local li = lightNow == "dark" and 2 or (lightNow == "match" and 3 or 1)
    text("Lighting", rx + rw - 290, y + 22, C.dim, 12, 5)
    local l = segmented(rx + rw - 232, y + 14, 220, 30, {"Normal", "Dark", "Match sky"}, li)
    if l then setMapping("lighting", "Preset", ({false, "dark", "match"})[l] or nil) end

    textbox("skySearch", rx + 12, y + 56, rw - 24, 28, "Search skies...")
    local q = query("skySearch")
    local items = {}
    if q == "" then items[1] = {name = "Off", none = true} end
    for _, g in ipairs(SKY_GROUPS) do
        for _, s in ipairs(g.skies) do
            if matches(q, s) then
                local face = catalog.skyFaces[s]
                items[#items + 1] = {name = s, src = face and ("assets/images/skies/" .. face .. ".png") or nil,
                    colors = (s == "gray" and {RGB(128, 128, 128)}) or (s == "black" and {RGB(8, 8, 10)})
                        or (s == "classic" and {RGB(116, 160, 214), RGB(186, 208, 236)}) or nil}
            end
        end
    end
    local hit = tileGrid("skyGrid", rx + 12, y + 94, rw - 30, h - 104, items, function(it)
        if it.none then return skyNow == "" end
        return it.name == skyNow
    end)
    if hit then
        -- Per-face ids from the site would win over the preset; drop them.
        for _, key in ipairs({"All", "BK", "DN", "FT", "LF", "RT", "UP"}) do setMapping("skybox", key, nil) end
        setMapping("skybox", "Preset", (not hit.none) and hit.name or nil)
    end
end

-- Tracers: the colour of your shots, for every gun or one gun at a time,
-- saved as the [Tracers] section. The game draws them, so they don't lag.
local TRACER_COLORS = {
    {"Red", "ff2d2d"}, {"Orange", "ff7a00"}, {"Gold", "ffc400"}, {"Yellow", "ffee00"}, {"Lime", "a6ff00"},
    {"Green", "2dff5a"}, {"Mint", "00ffa6"}, {"Cyan", "00e5ff"}, {"Blue", "2d6bff"}, {"Purple", "8a2dff"},
    {"Pink", "ff4fd8"}, {"White", "ffffff"},
}
local function hexColor(hex)
    return RGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
end

local function drawTracers(x, y, w, h)
    local values = state.values.tracers or {}
    local lw = 210
    rect(x, y, lw, h, C.panel, 2, 8)
    text("GUNS", x + 12, y + 10, C.faint, 11, 5, true)
    textbox("tracerSearch", x + 10, y + 28, lw - 20, 28, "Search...")
    local names, q = {}, query("tracerSearch")
    if q == "" then names[1] = "All guns" end
    for _, wpn in ipairs(catalog.weapons) do if matches(q, wpn.name) then names[#names + 1] = wpn.name end end
    local picked = sideList("tracerGuns", x + 8, y + 64, lw - 22, h - 72, names, state.tracerGun or "All guns",
        function(n) return values[n == "All guns" and "Color" or n] ~= nil end)
    if picked then state.tracerGun = picked; resetScroll("tracerGrid") end

    local gun = state.tracerGun or "All guns"
    local key = gun == "All guns" and "Color" or gun
    local current = values[key] and tostring(values[key]):lower()
    local rx, rw = x + lw + 12, w - lw - 12
    rect(rx, y, rw, h, C.panel, 2, 8)
    text(gun == "All guns" and "Tracers - every gun" or ("Tracers - " .. gun), rx + 16, y + 14, C.text, 15, 5, true)
    text("Now: " .. (current or (key == "Color" and "the game's own" or "same as All guns")), rx + 16, y + 36, C.dim, 12, 5)

    local items = {{name = key == "Color" and "Game's own" or "Same as all", none = true},
        {name = "Rainbow", value = "rainbow", colors = {RGB(255, 60, 60), RGB(60, 120, 255), RGB(255, 230, 0)}}}
    for _, c in ipairs(TRACER_COLORS) do items[#items + 1] = {name = c[1], value = c[2], colors = {hexColor(c[2])}} end
    local gy = y + 62
    local hit = tileGrid("tracerGrid", rx + 12, gy, rw - 30, h - (gy - y) - 132, items, function(it)
        if it.none then return current == nil end
        return it.value == current
    end)
    if hit then setMapping("tracers", key, hit.value) end

    -- The game draws no tracers for the Energy Pistols; this turns them on.
    local ey = y + h - 122
    local epOn = tostring(values.EnergyPistolsTracers or ""):lower() == "true"
    text("Energy Pistols tracers", rx + 16, ey, C.dim, 13, 5)
    text("Not recommended with 50% speed or under", rx + 16, ey + 16, C.faint, 11, 5)
    local ep = segmented(rx + rw - 152, ey, 140, 28, {"Off", "On"}, epOn and 2 or 1)
    if ep then setMapping("tracers", "EnergyPistolsTracers", ep == 2 and "true" or nil) end

    -- Speed, for every gun: 100% is the game's own, low is slow like the
    -- Keyper. Saved when you let go, so dragging doesn't re-apply every frame.
    local sy = y + h - 84
    local sp = state.tracerSpeed or tonumber(values.Speed) or 100
    text("Speed", rx + 16, sy + 6, C.dim, 13, 5)
    local bx, bw = rx + 72, rw - 250
    local t = (sp - 5) / 195
    rect(bx, sy + 12, bw, 4, C.card, 3, 2)
    rect(bx, sy + 12, math.max(1, bw * t), 4, C.accent, 4, 2)
    circle(bx + bw * t, sy + 14, 7, C.text, 5, true)
    if M.press and over(bx - 8, sy, bw + 16, 28) then state.tracerDrag = true end
    if state.tracerDrag then
        if M.down then
            sp = math.floor((5 + 195 * math.max(0, math.min(1, (M.x - bx) / bw))) / 5 + 0.5) * 5
            state.tracerSpeed = sp
            M.dragged = true
        else
            state.tracerDrag, state.tracerSpeed = nil, nil
            setMapping("tracers", "Speed", sp ~= 100 and tostring(sp) or nil)
        end
    end
    text(sp .. "%" .. (sp <= 25 and "  - slow, like the Keyper" or (sp == 100 and "  - the game's own" or "")),
        bx + bw + 16, sy + 6, C.text, 13, 5)

    local cy = y + h - 42
    textbox("tracerHex", rx + 12, cy, rw - 140, 30, "Any colour, like ff66cc")
    if button(rx + rw - 120, cy, 108, 30, "Use colour") then
        local v = trim(state.inputs.tracerHex or ""):gsub("^#", ""):lower()
        if v:match("^%x%x%x%x%x%x$") then setMapping("tracers", key, v) else state.status = "Colours are 6 hex digits, like ff66cc" end
    end
end

-- Hands: your first-person arms, hidden on every weapon or one at a time,
-- saved as the [NoHands] section. Only you see it.
local function drawHands(x, y, w, h)
    local allOn = tostring((state.values.nohands or {}).All or ""):lower() == "true"
    local lw = 210
    rect(x, y, lw, h, C.panel, 2, 8)
    text("WEAPONS", x + 12, y + 10, C.faint, 11, 5, true)
    textbox("handsSearch", x + 10, y + 28, lw - 20, 28, "Search...")
    local names, q = {}, query("handsSearch")
    if q == "" then names[1] = "Every weapon" end
    for _, wpn in ipairs(catalog.weapons) do if matches(q, wpn.name) then names[#names + 1] = wpn.name end end
    local picked = sideList("handsList", x + 8, y + 64, lw - 22, h - 72, names, state.handsFor or "Every weapon",
        function(n)
            if n == "Every weapon" then return allOn end
            return handsHidden(n)
        end)
    if picked then state.handsFor = picked end

    local who = state.handsFor or "Every weapon"
    local every = who == "Every weapon"
    local hiddenNow = every and allOn or (not every and handsHidden(who))
    local rx, rw = x + lw + 12, w - lw - 12
    rect(rx, y, rw, h, C.panel, 2, 8)
    text("Hands - " .. (every and "every weapon" or who), rx + 16, y + 14, C.text, 15, 5, true)
    text("Now: " .. (hiddenNow and "hidden" or "shown") .. ((not every and allOn) and "  (every weapon is set to hidden)" or ""),
        rx + 16, y + 36, C.dim, 12, 5)
    local p = segmented(rx + 16, y + 64, 260, 32, {"Shown", "Hidden"}, hiddenNow and 2 or 1)
    if p and (p == 2) ~= hiddenNow then
        if every then setMapping("nohands", "All", p == 2 and "true" or nil) else toggleHands(who) end
    end
    text("Your arms in first person are hidden while that weapon is out.", rx + 16, y + 112, C.dim, 12, 5)
    text("The weapon still moves as if held. Only you see it.", rx + 16, y + 132, C.dim, 12, 5)
    text("A green dot in the list marks a weapon whose hands are hidden.", rx + 16, y + 152, C.faint, 12, 5)
    text("Shows from the next Save & Apply.", rx + 16, y + h - 26, C.faint, 12, 5)
end

local function drawSounds(x, y, w, h)
    local lw = 184
    rect(x, y, lw, h, C.panel, 2, 8)
    text("LIBRARY", x + 12, y + 10, C.faint, 11, 5, true)
    local groupNames = {"Basics"}
    for _, g in ipairs(SOUND_LIBRARY) do groupNames[#groupNames + 1] = g.name end
    local picked = sideList("soundGroups", x + 8, y + 30, lw - 22, h - 38, groupNames, groupNames[state.soundGroup])
    if picked then
        for i, n in ipairs(groupNames) do if n == picked then state.soundGroup = i end end
        resetScroll("soundList")
    end

    local rx, rw = x + lw + 12, w - lw - 12
    rect(rx, y, rw, h, C.panel, 2, 8)
    local slotLabels = {}
    for _, s in ipairs(SOUND_SLOTS) do slotLabels[#slotLabels + 1] = s[2] end
    local si = segmented(rx + 12, y + 12, 300, 30, slotLabels, state.soundSlot)
    if si then state.soundSlot = si end
    local key = SOUND_SLOTS[state.soundSlot][1]
    local current = (state.values.sounds or {})[key]
    local currentLow = current and tostring(current):lower()
    if button(rx + rw - 132, y + 12, 120, 30, "Preview") then
        state.status = previewSound(current or DEFAULT_SOUNDS[key])
    end
    text("Now: " .. (current or "game default"), rx + 16, y + 52, C.dim, 12, 5)

    local rows = {}
    if state.soundGroup == 1 then
        rows = {{"Game default", nil}, {"Mute", "none"}}
    else
        for _, s in ipairs(SOUND_LIBRARY[state.soundGroup - 1].sounds) do rows[#rows + 1] = {s[1], s[2]} end
    end
    local ly, lh, rowH = y + 76, h - 76 - 50, 30
    local visible = math.floor(lh / rowH)
    local first = scroller("soundList", rx + 12, ly, rw - 30, lh, #rows, visible)
    for i = first + 1, math.min(#rows, first + visible) do
        local row = rows[i]
        local ry = ly + (i - first - 1) * rowH
        local sel = (row[2] == nil and current == nil) or (row[2] ~= nil and row[2] == currentLow)
        rect(rx + 12, ry, rw - 30, rowH - 4, sel and C.card or (over(rx + 12, ry, rw - 30, rowH - 4) and C.cardHover or C.panel), 3, 5)
        if sel then rect(rx + 12, ry + 6, 2, rowH - 16, C.accent, 4, 1) end
        text(row[1], rx + 24, ry + 6, sel and C.text or C.dim, 13, 5, sel)
        if row[2] then text(row[2], rx + rw - 40 - textWidth(row[2], 12), ry + 7, C.faint, 12, 5) end
        if clicked(rx + 12, ry, rw - 30, rowH - 4) then setMapping("sounds", key, row[2]) end
    end
    local cy = y + h - 42
    textbox("customSound", rx + 12, cy, rw - 140, 30, "Custom audio id")
    if button(rx + rw - 120, cy, 108, 30, "Use id") then
        local v = trim(state.inputs.customSound or "")
        if v ~= "" then setMapping("sounds", key, v) end
    end
end

-- Spoof: your name, level, streak and badges as you see them, saved as the
-- [Spoof] section; the changer shows them from the next Save & Apply. Only you
-- see them, except the device, which the server is told.
local SPOOF_FIELDS = {
    {key = "Name", label = "Display name", hint = "Your display name"},
    {key = "Username", label = "@Username", hint = "Not longer than your real one"},
    {key = "Level", label = "Level", number = true},
    {key = "Streak", label = "Win streak", number = true},
    {key = "ELO", label = "ELO", number = true},
}
local SPOOF_BADGES = {{"Influencer", "Influencer badge"}, {"Employee", "Roblox employee badge"}, {"Trustworthy", "Trustworthy"}}
local DEVICE_CHOICES = {{"Real", nil}, {"PC", "MouseKeyboard"}, {"Mobile", "Touch"}, {"Controller", "Gamepad"}, {"VR", "VR"}}

-- A text box tied to one [Spoof] key: it starts at the saved value and saves
-- when you press Enter or click away.
local function spoofBox(field, x, y, w)
    local id = "spoof_" .. field.key
    local saved = (state.values.spoof or {})[field.key] or ""
    if state.inputs[id] == nil then state.inputs[id] = saved end
    text(field.label, x, y, C.dim, 12, 5)
    textbox(id, x, y + 18, w, 30, field.hint or "Real")
    if focus ~= id then
        local v = trim(state.inputs[id] or "")
        if field.number and v ~= "" and not v:match("^%d+$") then
            state.inputs[id] = saved -- digits only; keep what was there
        elseif v ~= saved then
            setMapping("spoof", field.key, v ~= "" and v or nil)
        end
    end
end

local function drawSpoof(x, y, w, h)
    rect(x, y, w, h, C.panel, 2, 8)
    local cx = x + 20
    text("Spoof", cx, y + 14, C.text, 15, 5, true)
    text("How your name and stats look to you. The server keeps the real ones. Empty = real.", cx, y + 36, C.dim, 12, 5)

    local cy, colW = y + 60, math.floor((w - 60) / 2)
    spoofBox(SPOOF_FIELDS[1], cx, cy, colW)
    spoofBox(SPOOF_FIELDS[2], cx + colW + 20, cy, colW)
    cy = cy + 62
    local third = math.floor((w - 80) / 3)
    for i = 3, 5 do spoofBox(SPOOF_FIELDS[i], cx + (i - 3) * (third + 20), cy, third) end
    cy = cy + 62

    local values = state.values.spoof or {}
    -- The effect on your name: the game's gold (Prime) or purple (Contraband).
    text("Name effect", cx, cy + 8, C.text, 13, 5)
    local effectNow = (values.Effect or ""):lower()
    local ei = (effectNow == "none" and 2) or (effectNow == "prime" and 3) or (effectNow == "contraband" and 4) or 1
    local ep = segmented(x + w - 380, cy, 360, 30, {"Real", "None", "Prime", "Contraband"}, ei)
    if ep and ep ~= ei then setMapping("spoof", "Effect", ({false, "none", "prime", "contraband"})[ep] or nil) end
    cy = cy + 36
    for _, badge in ipairs(SPOOF_BADGES) do
        text(badge[2], cx, cy + 8, C.text, 13, 5)
        local now = (values[badge[1]] or ""):lower()
        local idx = (now == "true" and 2) or (now == "false" and 3) or 1
        local pick = segmented(x + w - 260, cy, 240, 30, {"Real", "On", "Off"}, idx)
        if pick and pick ~= idx then setMapping("spoof", badge[1], ({false, "true", "false"})[pick] or nil) end
        cy = cy + 36
    end

    cy = cy + 8
    line(cx, cy, x + w - 20, cy, C.line, 3, 1)
    cy = cy + 14
    text("Device Icon (Pro Matcha Only)", cx, cy + 8, C.text, 13, 5, true)
    text("Everyone sees this one - it is sent to the server. Needs Matcha's Hybrid Mode.", cx, cy + 28, C.bad, 12, 5)
    local deviceNow = values.Device
    local di = 1
    local labels = {}
    for i, d in ipairs(DEVICE_CHOICES) do
        labels[i] = d[1]
        if d[2] and deviceNow and d[2]:lower() == deviceNow:lower() then di = i end
    end
    local dp = segmented(cx, cy + 48, 400, 30, labels, di)
    if dp and dp ~= di then setMapping("spoof", "Device", DEVICE_CHOICES[dp][2]) end

    local by = y + h - 44
    text("Shows from the next Save & Apply.", cx, by + 8, C.faint, 12, 5)
    if button(x + w - 200, by, 180, 30, "Turn it all off") then
        for _, f in ipairs(SPOOF_FIELDS) do setMapping("spoof", f.key, nil); state.inputs["spoof_" .. f.key] = "" end
        for _, b in ipairs(SPOOF_BADGES) do setMapping("spoof", b[1], nil) end
        setMapping("spoof", "Effect", nil)
        setMapping("spoof", "Device", nil)
    end
end

-- Misc: smaller features, each a tab of its own under this one.
local function drawMisc(x, y, w, h)
    local at = state.miscTab or 1
    local pick = segmented(x, y, 360, 30, {"Tracers", "Hands", "Spoof"}, at)
    if pick and pick ~= at then state.miscTab, at, focus = pick, pick, nil end
    if at == 1 then drawTracers(x, y + 38, w, h - 38)
    elseif at == 2 then drawHands(x, y + 38, w, h - 38)
    else drawSpoof(x, y + 38, w, h - 38) end
end

-- Support ID: a short number for this PC, made here from Matcha's hardware ID
-- and scrambled so it can't be turned back into it. Nothing is sent anywhere;
-- it is printed so a log or screenshot says which copy it came from, and the
-- changer refuses to run for IDs listed in the repo's blacklist.txt.
local function supportId()
    local ok, hw = pcall(function() return gethwid() end)
    if not ok or type(hw) ~= "string" or hw == "" then return nil end
    local s = "rsc:" .. hw
    local h1, h2 = 7, 11
    for _ = 1, 3 do
        for i = 1, #s do
            local c = s:byte(i)
            h1 = (h1 * 131 + c + h2 % 251) % 999983
            h2 = (h2 * 65599 + c * 7 + i + h1 % 509) % 1000003
        end
    end
    return string.format("%04d-%04d", h1 % 10000, h2 % 10000)
end
local function drawSettings(x, y, w, h)
    rect(x, y, w, h, C.panel, 2, 8)
    local cx, cy = x + 20, y + 18
    text("Auto-apply on join", cx, cy + 6, C.text, 14, 5, true)
    text("Applies your saved config by itself once per server.", cx, cy + 26, C.faint, 12, 5)
    local a = segmented(x + w - 200, cy, 180, 30, {"Off", "On"}, state.autoApply and 2 or 1)
    if a then state.autoApply = a == 2; saveSettings() end
    cy = cy + 50
    text("Mouse offset", cx, cy + 6, C.text, 14, 5, true)
    text("If the dot isn't on your cursor, move it until it is: " .. state.mouseOffset .. " px",
        cx, cy + 26, C.faint, 12, 5)
    if button(x + w - 200, cy, 84, 30, "Up") then state.mouseOffset = state.mouseOffset - 2; saveSettings() end
    if button(x + w - 104, cy, 84, 30, "Down") then state.mouseOffset = state.mouseOffset + 2; saveSettings() end
    cy = cy + 50
    text("Reload", cx, cy + 6, C.text, 14, 5, true)
    text("After editing the config elsewhere, or when the site gets new skins.", cx, cy + 26, C.faint, 12, 5)
    if button(x + w - 200, cy, 84, 30, "Lists") then job("Reading lists...", loadCatalog) end
    if button(x + w - 104, cy, 84, 30, "Config") then job("Reading config...", loadConfig) end
    cy = cy + 50
    text("Accent color", cx, cy + 6, C.text, 14, 5, true)
    text("Buttons, highlights and the picked tile.", cx, cy + 26, C.faint, 12, 5)
    for i, hex in ipairs(ACCENTS) do
        local sx = x + w - 20 - (#ACCENTS - i) * 30 - 12
        local sy = cy + 15
        local ok, col3 = pcall(Color3.fromHex, "#" .. hex)
        if ok then circle(sx, sy, 10, col3, 5, true) end
        if hex == state.accent then circle(sx, sy, 14, C.text, 5, false, 2) end
        if clicked(sx - 14, sy - 14, 28, 28) then state.accent = hex; applyAccent(hex); saveSettings() end
    end
    cy = cy + 50
    text("Show / hide key", cx, cy + 6, C.text, 14, 5, true)
    text(state.binding and "Press the key to use. Esc cancels." or "Click, then press the key that shows and hides this window.",
        cx, cy + 26, C.faint, 12, 5)
    local label = state.binding and "Press a key..." or keyName(state.toggleKey)
    if button(x + w - 200, cy, 180, 30, label, state.binding) and not state.binding then
        -- Keys already held when binding starts don't count.
        state.binding, state.bindHeld = true, {}
        for vk in pairs(KEY_NAMES) do
            local okDown, down = pcall(iskeypressed, vk)
            if okDown and down then state.bindHeld[vk] = true end
        end
    end
    cy = cy + 50
    text("Lists", cx, cy + 6, C.text, 14, 5, true)
    text(inventory and "The \"you own\" lists show only what you own, or everything."
        or "Your inventory couldn't be read - the lists show everything. Try Reload > Lists in a match.", cx, cy + 26, C.faint, 12, 5)
    local o = segmented(x + w - 200, cy, 180, 30, {"Everything", "Owned"}, state.ownedOnly and 2 or 1)
    if o then state.ownedOnly = o == 2; saveSettings() end
    cy = cy + 50
    text("Window on autoexec", cx, cy + 6, C.text, 14, 5, true)
    text("Hidden: it loads quietly and " .. keyName(state.toggleKey) .. " opens it.", cx, cy + 26, C.faint, 12, 5)
    local v = segmented(x + w - 200, cy, 180, 30, {"Hidden", "Shown"}, state.showOnAutoexec and 2 or 1)
    if v then state.showOnAutoexec = v == 2; saveSettings() end
    cy = cy + 50
    text("Unload", cx, cy + 6, C.text, 14, 5, true)
    text("Removes this window until the script runs again.", cx, cy + 26, C.faint, 12, 5)
    if button(x + w - 200, cy, 180, 30, "Unload") then state.unload = true end
    cy = cy + 58
    line(cx, cy, x + w - 20, cy, C.line, 3, 1)
    text("Skin changer by Martini", cx, cy + 14, C.dim, 13, 5, true)
    text("mr.vage - Main Contributor for the GUI", cx, cy + 36, C.dim, 12, 5)
    text("Sorta copied from Gain's external", cx, cy + 56, C.faint, 12, 5)
    text("dantekarati - Contributor for the idea", cx, cy + 76, C.faint, 12, 5)
    local rx2 = x + math.floor(w / 2)
    text("Main testers/supporters: choperr0333 aka @Giounis", rx2, cy + 16, C.faint, 12, 5)
    text("Site: " .. SITE, rx2, cy + 36, C.faint, 12, 5)
    state.supportId = state.supportId or supportId() or "unavailable"
    text("Support ID: " .. state.supportId, rx2, cy + 76, C.dim, 12, 5)
    text("Gain's Discord: https://discord.gg/RHbxDSe8Z", rx2, cy + 56, C.faint, 12, 5)
end

-- The window

local TABS = {"Skins", "Cosmetics", "Visuals", "Misc", "Sounds", "Settings"}
local DRAW = {Skins = drawSkins, Cosmetics = drawCosmetics, Visuals = drawVisuals, Misc = drawMisc, Sounds = drawSounds,
    Settings = drawSettings}
DRAW.Updates = function(x,y,w,h)
    rect(x,y,w,h,C.panel,2,8)
    text("Update log / 3.4 / September 30, 2026",x+20,y+20,C.text,18,5,true)
    local entries={"Updated Roblox memory layout and restoration fixes.",
        "Owned-only filtering and conflicting-swap warnings.",
        "Misc: No Hands, tracers, Energy Pistols and spoof.",
        "420px skin artwork where supplied; corner resizing.",
        "Bundled engine; guarded memory access during transitions.",
        "Autoexec settings and first-run notice from upstream.",
        "Autoexec installation is manual; no Matcha files were changed."}
    for i,lineText in ipairs(entries) do text(lineText,x+20,y+62+i*29,C.dim,13,5) end
end
local function viewport()
    local ok, vp = pcall(function() return workspace.CurrentCamera.ViewportSize end)
    return ok and vp or V2(1920, 1080)
end
local win = {w = 840, h = 660}
do
    local vp = viewport()
    win.x = math.floor(math.max(10, (vp.X - win.w) / 2))
    win.y = math.floor(math.max(40, (vp.Y - win.h) / 2))
end
local grabbed, lastInputGrab = nil, nil
local resizing

-- The first-run notice: it has to be read before anything else shows, and its
-- button unlocks after a few seconds. Seen once, it is remembered in the
-- settings file (shared by both GUIs).
local NOTICE_SECONDS = 10
local NOTICE = {
    "These are client-side cosmetic changes, except Device Spoof, which sends a device value to the server. Compatibility and detection risk are not guaranteed.",
    "Swap changes an owned skin into another look. Switch changes a weapon's default look. Re-equip or respawn when a feature requires it.",
    "An item can only participate in one swap at a time. Conflicting entries are skipped.",
    "Upstream derives a support code locally from Matcha's hardware ID. It appears in logs. The script downloads the author's blocklist and refuses listed codes; the hardware ID is not included in that request.",
}
local noticeLines, noticeWidth
local function drawNotice(x, y, w, h)
    state.noticeStart = state.noticeStart or tick()
    local left = math.ceil(NOTICE_SECONDS - (tick() - state.noticeStart))
    local px, pw = x + 70, w - 140
    -- Wrapped once per width: measuring text every frame is slow.
    if noticeWidth ~= pw then
        noticeLines, noticeWidth = {}, pw
        for _, para in ipairs(NOTICE) do
            local line = ""
            for word in para:gmatch("%S+") do
                local try = line == "" and word or (line .. " " .. word)
                if line ~= "" and textWidth(try, 14) > pw then
                    noticeLines[#noticeLines + 1] = line
                    line = word
                else
                    line = try
                end
            end
            if line ~= "" then noticeLines[#noticeLines + 1] = line end
            noticeLines[#noticeLines + 1] = ""
        end
    end
    local cy = y + 36
    -- A red title with a soft glow behind it (the same text, larger and faint).
    local red = RGB(255, 45, 60)
    rect(x + w / 2 - 90, cy - 6, 180, 38, red, 3, 19, 0.12)
    rect(x + w / 2 - 74, cy - 2, 148, 30, red, 3, 15, 0.16)
    text("NOTICE!", x + w / 2, cy, red, 22, 5, true, true)
    cy = cy + 52
    for _, l in ipairs(noticeLines) do
        if l ~= "" then text(l, px, cy, RGB(255, 194, 51), 14, 5) end
        cy = cy + (l == "" and 12 or 22)
    end
    local bw, ready = 280, left <= 0
    local by = math.max(cy + 16, y + h - 84)
    if button(x + (w - bw) / 2, by, bw, 38, ready and "I've read and accept" or ("I've read and accept  (" .. left .. ")"), ready, not ready) then
        state.noticeSeen = true
        saveSettings()
    end
end

local function drawWindow(slide)
    local vp = viewport()
    win.w = math.min(win.w, math.max(560, vp.X - 20))
    win.h = math.min(win.h, math.max(420, vp.Y - 40))
    if not M.down then resizing=nil end
    if M.press and not slide then
        local west=over(win.x-3,win.y-3,13,win.h+6)
        local east=over(win.x+win.w-10,win.y-3,13,win.h+6)
        local north=over(win.x-3,win.y-3,win.w+6,13)
        local south=over(win.x-3,win.y+win.h-10,win.w+6,13)
        if (west or east) and (north or south) then
            resizing={x=win.x,y=win.y,w=win.w,h=win.h,mx=M.x,my=M.y,west=west,north=north}
        end
    end
    if resizing and M.down then
        local r=resizing;local dx,dy=M.x-r.mx,M.y-r.my
        local minW,minH=math.min(740,vp.X-20),math.min(560,vp.Y-40)
        if r.west then win.x=math.max(0,math.min(r.x+dx,r.x+r.w-minW));win.w=r.x+r.w-win.x
        else win.w=math.min(vp.X-r.x,math.max(minW,r.w+dx)) end
        if r.north then win.y=math.max(0,math.min(r.y+dy,r.y+r.h-minH));win.h=r.y+r.h-win.y
        else win.h=math.min(vp.Y-r.y,math.max(minH,r.h+dy)) end
        M.dragged=true;M.took=true
    end
    local x, y, w, h = win.x, win.y + math.floor(slide or 0), win.w, win.h

    -- Drag by the title bar.
    if M.press and not slide and not resizing and over(x + 14, y + 2, w - 170, 36) then grabbed = {M.x - x, M.y - y} end
    if not M.down then grabbed = nil end
    if grabbed then
        win.x = math.floor(math.max(0, math.min(vp.X - 60, M.x - grabbed[1])))
        win.y = math.floor(math.max(0, math.min(vp.Y - 40, M.y - grabbed[2])))
        x, y = win.x, win.y
        M.dragged = true
    end

    rect(x - 1, y - 1, w + 2, h + 2, C.line, 0, 11)
    rect(x, y, w, h, C.bg, 1, 10)
    text("Rivals", x + 16, y + 12, C.text, 16, 5, true)
    text("Skin Changer", x + 16 + textWidth("Rivals ", 16, true), y + 12, C.accent, 16, 5, true)
    if button(x + w - 144, y + 8, 100, 24, "Update log") then state.tab="Updates" end
    if button(x + w - 36, y + 8, 26, 24, "x") then state.open = false end
    line(x, y + 40, x + w, y + 40, C.line, 2, 1)

    if not state.noticeSeen then
        drawNotice(x, y + 40, w, h - 40)
        circle(M.x, M.y, 2, C.accent, 9, true)
        return over(x, y, w, h)
    end

    -- Tabs
    local tw = (w - 24) / #TABS
    for i, name in ipairs(TABS) do
        local tx = x + 12 + (i - 1) * tw
        local sel = state.tab == name
        if sel then
            rect(tx + 2, y + 48, tw - 4, 30, C.card, 2, 6)
            line(tx + tw * 0.3, y + 76, tx + tw * 0.7, y + 76, C.accent, 5, 2)
        end
        text(name, tx + tw / 2, y + 55, sel and C.text or C.dim, 13, 5, sel, true)
        if clicked(tx, y + 48, tw, 30) then state.tab = name; focus = nil end
    end

    local body = y + 88
    DRAW[state.tab](x + 12, body, w - 24, h - (body - y) - 48)

    -- Footer
    local fy = y + h - 40
    line(x, fy - 2, x + w, fy - 2, C.line, 2, 1)
    local busy = shared.busy or upstreamBusy()
    text(fitText((busy and "Working...  " or "") .. tostring(state.status), w - 330, 12), x + 16, fy + 12,
        state.dirty and C.text or C.dim, 12, 5)
    -- Right-aligned against the button, so any key name sits the same way.
    local hint = keyName(state.toggleKey) .. " hides"
    text(hint, x + w - 172 - 16 - textWidth(hint, 12), fy + 12, C.faint, 12, 5)
    if button(x + w - 172, fy + 5, 160, 28, "Save & Apply", true, busy) then job("Applying...", apply) end

    -- Where the game says the mouse is, to check the offset against.
    circle(M.x, M.y, 2, C.accent, 9, true)
    return over(x, y, w, h)
end

local appliedAccent
local function captureKey()
    for vk in pairs(KEY_NAMES) do
        local ok, down = pcall(iskeypressed, vk)
        down = ok and down == true
        if down and not state.bindHeld[vk] then
            state.binding = false
            if vk ~= 0x1B then
                state.toggleKey = vk
                saveSettings()
            end
            keyState[vk] = true -- so the new key doesn't toggle on this same press
            return
        end
        if not down then state.bindHeld[vk] = nil end
    end
    local ok, esc = pcall(iskeypressed, 0x1B)
    if ok and esc then state.binding = false end
end

-- Opening pulls the window up into place while it fades in; closing drops it
-- back down and fades it out. `shown` runs 0 (hidden) to 1 (open).
local OPEN_SECONDS, CLOSE_SECONDS, SLIDE = 0.3, 0.22, 48
local shown, lastFrame = 0, nil

local lastPaint,paintKey,lastMouseX,lastMouseY = 0,nil,nil,nil
local function frame()
    readInput()
    if state.accent ~= appliedAccent then appliedAccent = state.accent; applyAccent(state.accent) end
    if state.binding then
        captureKey()
    elseif keyHit(state.toggleKey) then
        state.open = not state.open; focus = nil
    end
    local now = tick()
    local dt = math.min(0.05, now - (lastFrame or now))
    lastFrame = now
    if state.open then shown = math.min(1, shown + dt / OPEN_SECONDS)
    else shown = math.max(0, shown - dt / CLOSE_SECONDS) end

    local signature=table.concat({tostring(state.tab),tostring(state.skinsView),tostring(state.weapon),
        tostring(state.open),tostring(state.status),tostring(state.dirty),tostring(artworkRevision)},"|")
    local keyboard=focus~=nil or state.binding
    if not keyboard then
        for _,vk in ipairs({0x21,0x22,0x25,0x26,0x27,0x28,0x1B}) do
            if iskeypressed(vk) then keyboard=true;break end
        end
    end
    local redraw=signature~=paintKey or M.press or M.release or M.down or keyboard
        or M.x~=lastMouseX or M.y~=lastMouseY or (shown>0 and shown<1) or now-lastPaint>=.25
    if not redraw then return end
    lastPaint,paintKey,lastMouseX,lastMouseY=now,signature,M.x,M.y
    beginFrame()
    local overWindow = false
    if shown > 0 then
        local eased = 1 - (1 - shown) ^ 3
        if state.open and focus then typeInto(focus) end
        -- A click anywhere ends typing; a click in a box focuses it again.
        if M.press and focus then focus = nil end
        -- Clicks only count once the window is fully out.
        if shown < 1 then M.press, M.release = false, false end
        Fade = eased
        overWindow = drawWindow(shown < 1 and (1 - eased) * SLIDE or nil)
        Fade = 1
    end
    endFrame()
    -- Keep clicks and typing on the window from reaching the game.
    local grab = state.open and (not isrbxactive or isrbxactive() ~= false)
    if grab ~= lastInputGrab and type(setrobloxinput) == "function" then
        lastInputGrab = grab
        pcall(setrobloxinput, not grab)
    end
end

local alive = true
local function stop()
    alive = false
    if _G.__RivalsGuiSession == guiToken then _G.__RivalsGuiSession = nil end
    pcall(wipe)
    if type(setrobloxinput) == "function" then pcall(setrobloxinput, true) end
end
-- What is on screen right now, as text: for checking the layout from a script.
local function dump()
    local out = {}
    for i, o in ipairs(Pool.tx) do
        local c = Cache.tx[i]
        if c.Visible then out[#out + 1] = string.format("%d,%d %s", c.Positionx, c.Positiony, c.Text) end
    end
    local shown = 0
    for _ in pairs(shownImages) do shown = shown + 1 end
    out[#out + 1] = "images shown: " .. shown
    return table.concat(out, "\n")
end
_G.__RivalsDrawnGui = {stop = stop, state = state, dump = dump, win = win}

-- Auto-apply, once per server, like the menu-tab GUI.
local function autoApplyOnJoin()
    task.spawn(function()
        while alive and _G.__RivalsGuiSession == guiToken do
            local okFile, hasFile = pcall(isfile, SETTINGS)
            if not state.settingsRead and okFile and hasFile then pcall(loadSettings) end
            local context = state.autoApply and currentContext()
            local key = context and context.key
            local applied = _G.__RIVALS_SKIN_CHANGER_STATE
            if key and _G.__RivalsGuiAutoApplied ~= key and applied and applied.wfAddr == context.wf then
                _G.__RivalsGuiAutoApplied = key
            elseif key and _G.__RivalsGuiAutoApplied ~= key and not shared.busy and not upstreamBusy() then
                if isfile(FILE) and readfile(FILE):find("%S") then
                    _G.__RivalsGuiAutoApplied = key
                    if not state.dirty then loadConfig() end
                    if #catalog.weapons == 0 then pcall(loadCatalog) end
                    job("Auto-applying...", apply)
                end
            end
            task.wait(2)
        end
    end)
end

pcall(loadConfig)
pcall(loadSettings)
-- Started by autoexec, the window stays hidden until its key is pressed
-- (Settings > Window on autoexec).
local startedHidden = false
if _G.__RivalsGuiFromAutoexec then
    _G.__RivalsGuiFromAutoexec = nil
    if not state.showOnAutoexec then state.open, startedHidden = false, true end
end
-- The notice is shown straight away the first time, however it was started.
if not state.noticeSeen then state.open, startedHidden = true, false end
task.spawn(function()
    local ok, err = pcall(loadCatalog)
    if not ok then state.status = "Lists failed: " .. tostring(err):sub(1, 80) end
end)

task.spawn(function()
    local lastError
    while alive and _G.__RivalsGuiSession == guiToken do
        if otherGame() then
            print("[Rivals GUI] Not RIVALS - the GUI stays off in this game.")
            break
        end
        local ok, err = pcall(frame)
        if not ok and tostring(err) ~= lastError then
            lastError = tostring(err)
            print("[Rivals GUI] " .. lastError)
        end
        if state.unload then break end
        task.wait(.016)
    end
    stop()
end)
autoApplyOnJoin()
if startedHidden and type(notify) == "function" then
    pcall(notify, "Rivals Skin Changer", "Loaded - " .. keyName(state.toggleKey) .. " opens the window.", 5)
end
print("[Rivals GUI] Drawn window ready - " .. keyName(state.toggleKey) .. " shows and hides it."
    .. (state.autoApply and " Auto-apply is on." or ""))
