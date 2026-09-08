local CATALOG = {
    {name = "Assault Rifle", category = "Primary", skins = {"Default", "10B Visits", "AK-47", "AKEY-47", "AUG", "Boneclaw Rifle", "Gingerbread AUG", "Glorious Assault Rifle", "Pearl Rifle", "Phoenix Rifle", "Tommy Gun"}},
    {name = "Battle Axe", category = "Melee", skins = {"Default", "Balloon Axe", "Ban Axe", "Cerulean Axe", "Glorious Battle Axe", "Keyttle Axe", "Lifeguard Board", "Mimic Axe", "Nordic Axe", "Street Sign", "The Shred"}},
    {name = "Bow", category = "Primary", skins = {"Default", "Balloon Bow", "Bat Bow", "Beloved Bow", "Compound Bow", "Dream Bow", "Frostbite Bow", "Glorious Bow", "Key Bow", "Raven Bow", "Sunburst Bow"}},
    {name = "Burst Rifle", category = "Primary", skins = {"Default", "Aqua Burst", "Electro Rifle", "FAMAS", "Glorious Burst Rifle", "Keyst Rifle", "Pine Burst", "Pixel Burst", "Spectral Burst", "Water Blaster"}},
    {name = "Chainsaw", category = "Melee", skins = {"Default", "Blobsaw", "Buzzsaw", "Festive Buzzsaw", "Glorious Chainsaw", "Handsaws", "Surfboard"}},
    {name = "Crossbow", category = "Primary", skins = {"Default", "Arch Crossbow", "Crossbone", "Frostbite Crossbow", "Glorious Crossbow", "Harpoon Crossbow", "Pixel Crossbow", "Violin Crossbow", "Water Crossbow"}},
    {name = "Daggers", category = "Secondary", skins = {"Default", "Aces", "Bat Daggers", "Broken Hearts", "Cookies", "Glorious Daggers", "Keynais", "Paper Planes", "Popsicles", "Shurikens", "Toaster"}},
    {name = "Energy Pistols", category = "Secondary", skins = {"Default", "Apex Pistols", "Glorious Energy Pistols", "Hacker Pistols", "Hydro Pistols", "Hyperlaser Guns", "New Year Energy Pistols", "Soul Pistols", "Void Pistols", "Water Blaster Pistols"}},
    {name = "Energy Rifle", category = "Primary", skins = {"Default", "Apex Rifle", "Glorious Energy Rifle", "Hacker Rifle", "Hydro Rifle", "New Year Energy Rifle", "Soul Rifle", "Super Soaker Rifle", "Void Rifle"}},
    {name = "Exogun", category = "Secondary", skins = {"Default", "Exogourd", "Glorious Exogun", "Laser Pistol", "Midnight Festive Exogun", "Ray Gun", "Repulsor", "Singularity", "Wondergun"}},
    {name = "Fists", category = "Melee", skins = {"Default", "Boxing Gloves", "Brass Knuckles", "Fist", "Fists of Hurt", "Glorious Fists", "Pool Noodle", "Pumpkin Claws", "Spy Gloves", "Teddy Bear"}},
    {name = "Flamethrower", category = "Primary", skins = {"Default", "Bubblethrower", "Extinguisher", "Glitterthrower", "Glorious Flamethrower", "Jack O'Thrower", "Keythrower", "Lamethrower", "Pixel Flamethrower", "Rainbowthrower", "Snowblower"}},
    {name = "Flare Gun", category = "Secondary", skins = {"Default", "Banana Flare", "Dynamite Gun", "Firework Gun", "Glorious Flare Gun", "Squid Flare", "Vexed Flare Gun", "Wrapped Flare Gun"}},
    {name = "Flashbang", category = "Utility", skins = {"Default", "Camera", "Disco Ball", "Glorious Flashbang", "Lightbulb", "Pixel Flashbang", "Shining Star", "Skullbang", "Sol"}},
    {name = "Freeze Ray", category = "Utility", skins = {"Default", "Bubble Ray", "Glorious Freeze Ray", "Gum Ray", "Ice Shaver", "Temporal Ray", "Wrapped Freeze Ray"}},
    {name = "Grenade", category = "Utility", skins = {"Default", "Cuddle Bomb", "Dynamite", "Fizz Bomb", "Frozen Grenade", "Glorious Grenade", "Jingle Grenade", "Keynade", "Soul Grenade", "Water Balloon", "Whoopee Cushion"}},
    {name = "Grenade Launcher", category = "Primary", skins = {"Default", "Balloon Launcher", "Beach Ball Launcher", "Gearnade Launcher", "Glorious Grenade Launcher", "Skull Launcher", "Snowball Launcher", "Swashbuckler", "Uranium Launcher"}},
    {name = "Gunblade", category = "Primary", skins = {"Default", "Boneblade", "Crude Gunblade", "Elf's Gunblade", "Glorious Gunblade", "Gunsaw", "Hyper Gunblade", "Water Gunblade"}},
    {name = "Handgun", category = "Secondary", skins = {"Default", "Blaster", "Gingerbread Handgun", "Glorious Handgun", "Gumball Handgun", "Pixel Handgun", "Pumpkin Handgun", "Stealth Handgun", "Summer Handgun", "Towerstone Handgun", "Warp Handgun"}},
    {name = "Jump Pad", category = "Utility", skins = {"Default", "Bounce House", "Flamingo Floatie", "Glorious Jump Pad", "Jolly Man", "Shady Chicken Sandwich", "Spider Web", "Trampoline"}},
    {name = "Katana", category = "Melee", skins = {"Default", "Arch Katana", "Crystal Katana", "Evil Trident", "Glorious Katana", "Keytana", "Lightning Bolt", "Linked Sword", "New Year Katana", "Paddle", "Pixel Katana", "Saber", "Stellar Katana", "Swordfish", "Umbrella"}},
    {name = "Knife", category = "Melee", skins = {"Default", "Balisong", "Caladbolg", "Candy Cane", "Chancla", "Glorious Knife", "Karambit", "Keylisong", "Keyrambit", "Machete", "Pencil", "Pirate Hook", "Water Gun"}},
    {name = "Maul", category = "Melee", skins = {"Default", "Ban Hammer", "Glorious Maul", "Ice Maul", "Inflatable Hammer", "Sleigh Maul"}},
    {name = "Medkit", category = "Utility", skins = {"Default", "Box of Chocolates", "Briefcase", "Bucket of Candy", "Glorious Medkit", "Ice Cream", "Laptop", "Medkitty", "Milk & Cookies", "Sandwich"}},
    {name = "Minigun", category = "Primary", skins = {"Default", "Fighter Jet", "Glorious Minigun", "Lasergun 3000", "Pixel Minigun", "Pumpkin Minigun", "Shark", "Wrapped Minigun"}},
    {name = "Molotov", category = "Utility", skins = {"Default", "Campfire Stick", "Coffee", "Glorious Molotov", "Hot Coals", "Lava Lamp", "Ship In A Bottle", "Torch", "Vexed Candle"}},
    {name = "Paintball Gun", category = "Primary", skins = {"Default", "Boba Gun", "Brain Gun", "Glorious Paintball Gun", "Ketchup Gun", "Paintballoon Gun", "Slime Gun", "Snowball Gun", "Water Blaster 3000"}},
    {name = "Revolver", category = "Secondary", skins = {"Default", "Boneclaw Revolver", "Desert Eagle", "Glorious Revolver", "Peppermint Sheriff", "Peppergun", "Sheriff", "Squirt Revolver"}},
    {name = "Riot Shield", category = "Melee", skins = {"Default", "Boogie Board", "Door", "Energy Shield", "Glorious Riot Shield", "Masterpiece", "Sled", "Tombstone Shield"}},
    {name = "RPG", category = "Primary", skins = {"Default", "Firework Launcher", "Glorious RPG", "Nuke Launcher", "Pencil Launcher", "Pumpkin Launcher", "RPKEY", "Rocket Launcher", "Spaceship Launcher", "Squid Launcher", "Torpedo Launcher", "Water Cannon"}},
    {name = "Satchel", category = "Utility", skins = {"Default", "Advanced Satchel", "Bag o' Money", "Glorious Satchel", "Lifeguard Satchel", "Notebook Satchel", "Potion Satchel", "Suspicious Gift"}},
    {name = "Scythe", category = "Melee", skins = {"Default", "Anchor", "Bat Scythe", "Bug Net", "Cryo Scythe", "Crystal Scythe", "Glorious Scythe", "Keythe", "Naginata", "Palm Tree", "Sakura Scythe", "Scythe of Death"}},
    {name = "Shorty", category = "Secondary", skins = {"Default", "Balloon Shorty", "Demon Shorty", "Glorious Shorty", "Lovely Shorty", "Not So Shorty", "Squirt Pistol", "Super Shorty", "Too Shorty", "Wrapped Shorty"}},
    {name = "Shotgun", category = "Primary", skins = {"Default", "Balloon Shotgun", "Broomstick", "Cactus Shotgun", "Glorious Shotgun", "Hyper Shotgun", "Super Soaker", "Wrapped Shotgun"}},
    {name = "Slingshot", category = "Secondary", skins = {"Default", "Boneshot", "Glorious Slingshot", "Goalpost", "Harp", "Keyshot", "Lucky Horseshoe", "Palmshot", "Reindeer Slingshot", "Stick"}},
    {name = "Smoke Grenade", category = "Utility", skins = {"Default", "Balance", "Beach Ball", "Emoji Cloud", "Eyeball", "Glorious Smoke Grenade", "Hourglass", "Snowglobe"}},
    {name = "Sniper", category = "Primary", skins = {"Default", "Event Horizon", "Eyething Sniper", "Gingerbread Sniper", "Glorious Sniper", "Hyper Sniper", "Keyper", "Pixel Sniper", "Squirt Gun", "Umbrella Sniper"}},
    {name = "Spear", category = "Melee", skins = {"Default", "Giant Pencil", "Glorious Spear", "Harpoon", "Studio Light"}},
    {name = "Spray", category = "Secondary", skins = {"Default", "Boneclaw Spray", "Glorious Spray", "Key Spray", "Lovely Spray", "Nail Gun", "Pine Spray", "Spray Bottle", "Sunscreen Spray"}},
    {name = "Subspace Tripmine", category = "Utility", skins = {"Default", "DIY Tripmine", "Dev-in-the-Box", "Don't Press", "Glorious Subspace Tripmine", "Hazard Sign", "Pot o' Keys", "Spring", "Trick or Treat"}},
    {name = "Trowel", category = "Melee", skins = {"Default", "Garden Shovel", "Glorious Trowel", "Paintbrush", "Plastic Shovel", "Pumpkin Carver", "Sand Shovel", "Snow Shovel"}},
    {name = "Uzi", category = "Secondary", skins = {"Default", "Arch Uzi", "Demon Uzi", "Electro Uzi", "Glorious Uzi", "Keyzi", "Money Gun", "Pine Uzi", "Super Soaker Uzi", "Water Uzi"}},
    {name = "War Horn", category = "Utility", skins = {"Default", "Air Horn", "Boneclaw Horn", "Glorious War Horn", "Lifeguard Whistle", "Mammoth Horn", "Megaphone", "Trumpet"}},
    {name = "Warpstone", category = "Utility", skins = {"Default", "Cyber Warpstone", "Electropunk Warpstone", "Glorious Warpstone", "Starfish Warpstone", "Teleport Disc", "Unstable Warpstone", "Warpbone", "Warpeye", "Warpstar"}},
}

local function runEngine(configText)
local engineResult = {ok = false, count = 0, error = "Engine could not start; check executor notifications."}
-- Rerunnable wing test: each run stops and restores the preceding run.
local cleanupCurrentRun
local runToken = {}
_G.__RIVALS_SKIN_CHANGER_RUN_TOKEN = runToken
local setupOK, setupError = xpcall(function()
-- Rivals Skin Changer & Weapon Enhancement Engine
-- Resolves weapon slots and swaps model pointers in game memory.
-- Includes viewmodel, sound, and animation adjustments; timing and stability depend on the runtime.
local t_start = tick()

if not pcall(memory_read, "int", game.Address) then 
    pcall(notify, "UnsafeLua is disabled in executor.", "SC", 5) 
    return 
end

if not game:IsLoaded() then game.Loaded:Wait() end

local LP = game:GetService("Players").LocalPlayer
while not LP do
    task.wait(0.05)
    LP = game:GetService("Players").LocalPlayer
end

if game.GameId ~= 6035872082 then return end
if _G.__RIVALS_SKIN_CHANGER_RUN_TOKEN ~= runToken then return end

-- Stop the previous run before this run changes any models.
if type(_G.__RIVALS_SKIN_CHANGER_RESTORE) == "function" then
    local ok, restored = pcall(_G.__RIVALS_SKIN_CHANGER_RESTORE)
    if not ok or restored == false then
        pcall(notify, "Previous cleanup failed. Rejoin before testing again.", "SC", 6)
        return
    end
    -- Let older versions' sleeping loops finish before starting this version.
    task.wait(0.35)
end
if _G.__RIVALS_SKIN_CHANGER_RUN_TOKEN ~= runToken then return end

local A = LP:WaitForChild("PlayerScripts", 5):WaitForChild("Assets", 5)
local vm = A and A:WaitForChild("ViewModels", 5)
local wf = vm and vm:WaitForChild("Weapons", 5)

if not wf then
    pcall(notify, "Weapons folder not found.", "SC", 5)
    return
end
if _G.__RIVALS_SKIN_CHANGER_RUN_TOKEN ~= runToken then return end

local mrd, mwr, pcall, ipairs, pairs = memory_read, memory_write, pcall, ipairs, pairs

local rd = function(a) 
    local o, v = pcall(mrd, "uintptr_t", a)
    return o and v or nil 
end

local _scriptAlive = true
local soundConnections = {}
local uisConn = nil
local managedTasks = {}
local animationObjects = {}
local animationTracks = {}
local undoActions = {}
local savedMemory = {}
local savedProperties = {}
local cleanupFinished = false
local cleanupSucceeded = true

-- Record original values before this run changes them, including rig and wing pointers.
local wr = function(a, v)
    if not _scriptAlive then return end
    if not savedMemory[a] then
        local ok, original = pcall(mrd, "uintptr_t", a)
        if not ok or original == nil then return end
        savedMemory[a] = true
        table.insert(undoActions, {address = a, value = original})
    end
    pcall(mwr, "uintptr_t", a, v)
end

local function setProperty(object, property, value)
    if not _scriptAlive then return end
    local original = object[property]
    if original == value then return end
    local saved = savedProperties[object]
    if not saved then
        saved = {}
        savedProperties[object] = saved
    end
    if not saved[property] then
        saved[property] = true
        table.insert(undoActions, {object = object, property = property, value = original})
    end
    object[property] = value
end

local function fullCleanup()
    if cleanupFinished then return cleanupSucceeded end
    cleanupFinished = true
    _scriptAlive = false
    for _, connection in ipairs(soundConnections) do
        pcall(function() connection:Disconnect() end)
    end
    if uisConn then pcall(function() uisConn:Disconnect() end) end
    if task.cancel then
        for _, thread in ipairs(managedTasks) do
            if thread ~= coroutine.running() then pcall(task.cancel, thread) end
        end
    end
    for _, track in ipairs(animationTracks) do
        pcall(function() track:Stop(0) end)
        pcall(function() track:Destroy() end)
    end
    for _, animation in ipairs(animationObjects) do
        pcall(function() animation:Destroy() end)
    end
    -- Undo in reverse order; never pass restoration writes through the recorder.
    for i = #undoActions, 1, -1 do
        local entry = undoActions[i]
        if entry.address then
            local ok, result = pcall(mwr, "uintptr_t", entry.address, entry.value)
            if not ok or result == false then cleanupSucceeded = false end
        else
            -- A sound or effect may have been destroyed by the game already.
            pcall(function() entry.object[entry.property] = entry.value end)
        end
    end
    managedTasks, soundConnections, animationTracks, animationObjects = {}, {}, {}, {}
    undoActions, savedMemory, savedProperties = {}, {}, {}
    _G.__RIVALS_SKIN_CHANGER_ACTIVE = false
    return cleanupSucceeded
end

-- Register cleanup before any rig changes, event connections, or background tasks.
cleanupCurrentRun = fullCleanup
_G.__RIVALS_SKIN_CHANGER_RESTORE = fullCleanup
_G.__RIVALS_SKIN_CHANGER_ACTIVE = true

local function spawnManaged(callback)
    local thread = task.spawn(callback)
    table.insert(managedTasks, thread)
    return thread
end

local OFF = {
    Parent = 104,
    NameContainer = 112,
    Children = 120,
    Transparency = 304
}

local ga = function(f) 
    if not f or not f.Address then return end
    local n = rd(f.Address + OFF.Children)
    if not n or n == 0 then return end
    local b, e = rd(n), rd(n + 8)
    if b and e then return b, e end 
end

-- Find weapon slot in a folder's memory vector
local function findSlotAddressForWeapon(weaponModel, targetFolder)
    local f = targetFolder or wf
    local b, e = ga(f)
    if not b or not e then return nil end
    for slotAddr = b, e - 16, 16 do
        if rd(slotAddr) == weaponModel.Address then
            return slotAddr
        end
    end
    return nil
end

-- Fix ViewModelRoot RightArm if its NameContainer was corrupted/cleared
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
                    pcall(function() setProperty(c, "Name", "RightArm") end)
                    break
                end
            end
        end
    end
end
pcall(fixViewModelRoots)

-- Explicit skin mappings for special names / case folders
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
    ["Singularity"] = {folder = "Skin Case", name = "Singularity"},
    ["Temporal Ray"] = {folder = "Skin Case", name = "Temporal Ray"},
    ["Emoji Cloud"] = {folder = "Skin Case", name = "Emoji Cloud"},
    ["Gingerbread AUG"] = {folder = "Festive Skin Case", name = "Gingerbread AUG"},
    ["Lifeguard Satchel"] = {folder = "Summer Skin Case", name = "Lifeguard Satchel"},
    ["Harpoon"] = {folder = "Summer Skin Case", name = "Swordfish"},
    ["Fist"] = {folder = "Other", name = "Fist"},
}

-- Pre-indexed skin model table for name lookups
local skinIndex = {}
for _, folder in ipairs(vm:GetChildren()) do
    if folder.ClassName == "Folder" and folder.Name ~= "Weapons" and folder.Name ~= "Unobtainable" and folder.Name ~= "WIP" then
        for _, m in ipairs(folder:GetChildren()) do
            skinIndex[m.Name] = m
            skinIndex[m.Name:lower()] = m
        end
    end
end

local function findSkinModel(skinTarget)
    if EXACT_SKIN_MAP[skinTarget] then
        local f = vm:FindFirstChild(EXACT_SKIN_MAP[skinTarget].folder)
        if f then
            local m = f:FindFirstChild(EXACT_SKIN_MAP[skinTarget].name)
            if m then return m end
        end
    end
    return skinIndex[skinTarget] or skinIndex[skinTarget:lower()]
end

-- Specialized Crossbow rig: assigns Stick and Tip name pointers when source parts are available
local function fixCrossbowRig(skinModel)
    for _, partName in ipairs({"Body", "StringCurve", "Arrow", "Wings1", "Wings2"}) do
        local sub = skinModel:FindFirstChild(partName)
        if sub and sub.ClassName == "Model" then
            if not sub:FindFirstChild("Primary") then
                local firstPart = sub:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    pcall(function() setProperty(sub, "PrimaryPart", firstPart) end)
                end
            else
                pcall(function() setProperty(sub, "PrimaryPart", sub.Primary) end)
            end
        end
    end

    local arrow = skinModel:FindFirstChild("Arrow")
    local defCB = wf:FindFirstChild("Crossbow")
    local defArrow = defCB and defCB:FindFirstChild("Arrow")
    
    if arrow and defArrow then
        local stickNC = defArrow:FindFirstChild("Stick") and rd(defArrow.Stick.Address + OFF.NameContainer)
        local tipNC = defArrow:FindFirstChild("Tip") and rd(defArrow.Tip.Address + OFF.NameContainer)
        
        local nonPrimary = {}
        for _, c in ipairs(arrow:GetChildren()) do
            if c.Name ~= "Primary" and c.ClassName == "MeshPart" then
                table.insert(nonPrimary, c)
            end
        end
        
        if #nonPrimary > 0 and stickNC then
            wr(nonPrimary[1].Address + OFF.NameContainer, stickNC)
        end
        
        local extra = skinModel:FindFirstChild("Body") and skinModel.Body:FindFirstChild("_charm_attachment_model") and skinModel.Body._charm_attachment_model:FindFirstChild("Extra")
        if extra and tipNC and not arrow:FindFirstChild("Tip") then
            local spare = extra:FindFirstChildWhichIsA("MeshPart")
            if spare then
                wr(spare.Address + OFF.NameContainer, tipNC)
                pcall(function() setProperty(spare, "Parent", arrow) end)
            end
        end
    end
end

-- Specialized Bow rig: ensures Arrow parts resolve
local function fixBowRig(skinModel)
    local arrow = skinModel:FindFirstChild("Arrow")
    if arrow and arrow.ClassName == "Model" then
        if not arrow:FindFirstChild("Primary") then
            local p = arrow:FindFirstChildWhichIsA("BasePart")
            if p then pcall(function() setProperty(arrow, "PrimaryPart", p) end) end
        end
    end
end

-- Specialized RPG rig: ensures Rocket.Primary exists
local function fixRPGRig(skinModel)
    local rocket = skinModel:FindFirstChild("Rocket")
    if rocket and rocket.ClassName == "Model" then
        if not rocket:FindFirstChild("Primary") then
            local p = rocket:FindFirstChildWhichIsA("BasePart")
            if p then pcall(function() setProperty(rocket, "PrimaryPart", p) end) end
        end
    end
end

-- Specialized Grenade rig
local function fixGrenadeRig(skinModel)
    local bomb = skinModel:FindFirstChild("Bomb")
    if bomb and bomb.ClassName == "Model" then
        pcall(function() setProperty(bomb, "Name", "Body") end)
        return
    end
end

-- Specialized Gunblade / Keyblade rig
local function fixGunbladeRig(skinModel)
    for _, partName in ipairs({"Body", "Sword"}) do
        local sub = skinModel:FindFirstChild(partName)
        if sub and sub.ClassName == "Model" then
            if not sub:FindFirstChild("Primary") then
                local firstPart = sub:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    pcall(function() setProperty(sub, "PrimaryPart", firstPart) end)
                end
            else
                pcall(function() setProperty(sub, "PrimaryPart", sub.Primary) end)
            end
        end
    end
end

-- Specialized Katana rig: ensures Wings models are named and parts have valid PrimaryPart
local function fixKatanaRig(skinModel)
    local wingIdx = 1
    for _, sub in ipairs(skinModel:GetChildren()) do
        if sub.ClassName == "Model" and sub.Name ~= "_fake" then
            if sub.Name == "" or sub.Name:find("Wing") then
                pcall(function() setProperty(sub, "Name", "Wings" .. tostring(wingIdx)) end)
                wingIdx = wingIdx + 1
            end
            if not sub:FindFirstChild("Primary") then
                local firstPart = sub:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    pcall(function() setProperty(sub, "PrimaryPart", firstPart) end)
                end
            else
                pcall(function() setProperty(sub, "PrimaryPart", sub.Primary) end)
            end
        end
    end
end

-- Universal component rigger
local function rigSkinModel(m)
    if not m then return end
    
    for _, sub in ipairs(m:GetChildren()) do
        if sub.ClassName == "Model" and sub.Name ~= "Arrow" then
            if not sub:FindFirstChild("Primary") then
                local firstPart = sub:FindFirstChildWhichIsA("BasePart")
                if firstPart then
                    pcall(function() setProperty(sub, "PrimaryPart", firstPart) end)
                end
            else
                pcall(function() setProperty(sub, "PrimaryPart", sub.Primary) end)
            end
        end
    end
    
    if m:FindFirstChild("Body") and m.Body:FindFirstChild("Primary") then
        pcall(function() setProperty(m, "PrimaryPart", m.Body.Primary) end)
    elseif not m.PrimaryPart then
        pcall(function() setProperty(m, "PrimaryPart", m:FindFirstChildWhichIsA("BasePart", true)) end)
    end
    
    for _, c in ipairs(m:GetChildren()) do
        local n = c.Name:lower()
        if n:find("shell") or n:find("%.r") or n:find("%.l") or n:find("sleeve") or n:find("juggle") then
            if c.ClassName == "Model" then
                pcall(function() setProperty(c, "Name", "_fake") end)
            end
        end
    end
end

-- Active viewmodel beam and particle FX culler
spawnManaged(function()
    local rs = game:GetService("ReplicatedStorage")
    while _scriptAlive do
        task.wait(0.3)
        if not _scriptAlive then break end
        pcall(function()
            local tempVM = rs:FindFirstChild("Assets") and rs.Assets:FindFirstChild("Temp") and rs.Assets.Temp:FindFirstChild("ViewModels")
            if tempVM then
                for _, activeVM in ipairs(tempVM:GetChildren()) do
                    if activeVM.Name:find(LP.Name) then
                        local hrp = activeVM:FindFirstChild("HumanoidRootPart")
                        local isUnequipped = not hrp or hrp.Position.Magnitude < 1
                        for _, desc in ipairs(activeVM:GetDescendants()) do
                            if desc.ClassName == "Beam" or desc.ClassName == "ParticleEmitter" or desc.ClassName == "Trail" then
                                if isUnequipped and desc.Enabled then
                                    setProperty(desc, "Enabled", false)
                                elseif not isUnequipped and not desc.Enabled then
                                    setProperty(desc, "Enabled", true)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Active skins mapping table for notifications
local ACTIVE_CONFIG_SKINS = {}

-- Periodic wing retargeting (Katana Wings1/2 & Uzi Wing1/2) and equipped-weapon tracking
spawnManaged(function()
    local lastEquippedWeapon = nil
    local lastNotifyTime = 0
    while _scriptAlive do
        task.wait(0.04)
        if not _scriptAlive then break end
        pcall(function()
            local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
            if fp then
                for _, vmInst in ipairs(fp:GetChildren()) do
                    -- Parse weapon name from viewmodel instance
                    local wName = vmInst.Name:match("%-%s*(.-)%s*%-")
                    if not wName then
                        wName = vmInst.Name:match(LP.Name .. "%s*%-%s*(.-)%s*$")
                    end
                    
                    if wName and wName ~= lastEquippedWeapon and (tick() - lastNotifyTime) > 0.3 then
                        lastEquippedWeapon = wName
                        lastNotifyTime = tick()
                    end

                    -- Katana test: preserve game-created joint attachments instead of forcing Part0.
                    -- Start a fresh game session: earlier runs do not restore these joint writes.
                    if wName ~= "Katana" then
                        local hrp = vmInst:FindFirstChild("HumanoidRootPart")
                        local itemVisual = vmInst:FindFirstChild("ItemVisual")
                        local bodyModel = itemVisual and (itemVisual:FindFirstChild("Body") or itemVisual:FindFirstChild("Model"))
                        local bodyPart = bodyModel and (bodyModel:FindFirstChild("Primary") or bodyModel:FindFirstChild("BodyPrimary"))
                        local bodyJoint = hrp and (hrp:FindFirstChild('ItemVisual["Body"]') or hrp:FindFirstChild('ItemVisual[""]'))
                        local targetPart = bodyPart or (bodyJoint and bodyJoint.Part1)
                        
                        if hrp and targetPart and targetPart.Address then
                            local targetAddr = targetPart.Address
    
                            -- 1. Katana Wings: Wings1 & Wings2 (Direct memory write at offset 280: Part0)
                            local kw1 = hrp:FindFirstChild('ItemVisual["Wings1"]')
                            if kw1 and kw1.Address and rd(kw1.Address + 280) ~= targetAddr then
                                wr(kw1.Address + 280, targetAddr)
                            end
                            local kw2 = hrp:FindFirstChild('ItemVisual["Wings2"]')
                            if kw2 and kw2.Address and rd(kw2.Address + 280) ~= targetAddr then
                                wr(kw2.Address + 280, targetAddr)
                            end
    
                            -- 2. Uzi Wings: Wing1 & Wing2 (Direct memory write at offset 280: Part0)
                            local uw1 = hrp:FindFirstChild('ItemVisual["Wing1"]')
                            if uw1 and uw1.Address and rd(uw1.Address + 280) ~= targetAddr then
                                wr(uw1.Address + 280, targetAddr)
                            end
                            local uw2 = hrp:FindFirstChild('ItemVisual["Wing2"]')
                            if uw2 and uw2.Address and rd(uw2.Address + 280) ~= targetAddr then
                                wr(uw2.Address + 280, targetAddr)
                            end
    
                            -- 3. Dynamic scan for any other wing or nameless joints
                            for _, joint in ipairs(hrp:GetChildren()) do
                                if joint.ClassName == "Motor6D" and joint.Address then
                                    local jName = joint.Name
                                    if jName:find("Wing") or jName == 'ItemVisual[""]' then
                                        if rd(joint.Address + 280) ~= targetAddr then
                                            wr(joint.Address + 280, targetAddr)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Robust Bullet, Reload, and Inspect Sound Replacement Table
-- Supports both numeric ID and rbxassetid:// prefixed strings
local SOUND_REPLACEMENTS = {
    -- Assault Rifle -> AUG / AKEY-47
    ["13236548545"] = { primary = "rbxassetid://17662574783", secondary = "rbxassetid://18764343961" },
    ["13236548480"] = { primary = "rbxassetid://90757583550672", secondary = "rbxassetid://110122962237431" },
    ["13455395017"] = { primary = "rbxassetid://18887149414" },
    ["13236549929"] = { primary = "rbxassetid://18887149414", volume = 0 },
    ["13236549962"] = { primary = "rbxassetid://18887149414", volume = 0 },

    -- Sniper -> Event Horizon / Keyper (Custom Shoot, Reload, Equip, Bolt)
    ["13270206222"] = { primary = "rbxassetid://17672502566", secondary = "rbxassetid://124463680760542" },
    ["13270206087"] = { primary = "rbxassetid://77109116351775", volume = 0.8 },
    ["13455229044"] = { primary = "rbxassetid://113227486192611" },
    ["13455229188"] = { primary = "rbxassetid://17672502879" },
    ["13455394948"] = { primary = "rbxassetid://17672502716" },
    ["13269929260"] = { primary = "rbxassetid://17672502716" },
    ["13269934368"] = { primary = "rbxassetid://17672502879" },
    ["13642104835"] = { primary = "rbxassetid://113227486192611", secondary = "rbxassetid://17672502879" },

    -- Revolver -> Boneclaw Revolver / Keyvolver
    ["14417089307"] = { primary = "rbxassetid://104731232227748", secondary = "rbxassetid://13483008798" },
    ["14417089152"] = { primary = "rbxassetid://104731232227748", volume = 0 },
    ["14417089046"] = { primary = "rbxassetid://104731232227748", volume = 0 },
    ["14417088974"] = { primary = "rbxassetid://104731232227748", volume = 0 },
    ["13087405232"] = { primary = "rbxassetid://104731232227748", secondary = "rbxassetid://14457782622" },
    ["14240943641"] = { primary = "rbxassetid://14457783670" },
    ["14240944488"] = { primary = "rbxassetid://14457783670", volume = 0 },
    ["14240944327"] = { primary = "rbxassetid://14457783670", volume = 0 },
    ["13087406981"] = { primary = "rbxassetid://14457783670" },

    -- Crossbow -> Arch Crossbow
    ["82715240396507"] = { primary = "rbxassetid://81230732872783" },
    ["15132679812"] = { primary = "rbxassetid://81230732872783" },
    ["13682532502"] = { primary = "rbxassetid://114610550422028" },
    ["76155503538875"] = { primary = "rbxassetid://114610550422028", volume = 0 },
    ["15132681423"] = { primary = "rbxassetid://114610550422028" },

    -- Burst Rifle -> Keyst Rifle
    ["13087410000"] = { primary = "rbxassetid://13087362838", secondary = "rbxassetid://90757583550672" },
    ["13160326139"] = { primary = "rbxassetid://110122962237431", secondary = "rbxassetid://71387264231358" },

    -- Gunblade -> Keyblade
    ["96886470957330"] = { primary = "rbxassetid://135836738518083", secondary = "rbxassetid://115657023572170" },

    -- Shotgun -> Shotkey
    ["13479562219"] = { primary = "rbxassetid://115657023572170", secondary = "rbxassetid://96253147006478" },
    ["13515046921"] = { primary = "rbxassetid://96253147006478", volume = 0.5 },
    ["13515046988"] = { primary = "rbxassetid://96253147006478", volume = 0.5 },

    -- Grenade -> Keynade / Cuddle Bomb
    ["14522189766"] = { primary = "rbxassetid://96253147006478", secondary = "rbxassetid://14522189766" },
    ["13158735106"] = { primary = "rbxassetid://18179281854" },

    -- Uzi -> Keyzi / Arch Uzi
    ["16526185100"] = { primary = "rbxassetid://16526185100", secondary = "rbxassetid://90757583550672" },
    ["16526184479"] = { primary = "rbxassetid://16526184479", secondary = "rbxassetid://110122962237431" },

    -- Slingshot -> Keyshot
    ["13744359504"] = { primary = "rbxassetid://110122962237431" },

    -- Flamethrower -> Keythrower
    ["17209245734"] = { primary = "rbxassetid://17209245734", secondary = "rbxassetid://129124742663895" },

    -- Bow -> Key Bow
    ["90757583550672"] = { primary = "rbxassetid://90757583550672" },

    -- Molotov -> Arch Molotov
    ["14812827622"] = { primary = "rbxassetid://72790275842437" },
    ["14812827928"] = { primary = "rbxassetid://72790275842437" },

    -- Maul -> Ban Hammer
    ["10730819"] = { primary = "rbxassetid://10730819" },

    -- Warpstone -> Warpeye
    ["132455961912409"] = { primary = "rbxassetid://132455961912409" },

    -- Katana -> Arch Katana Inspect Fruit Slices, Attacks, Deflects
    ["13159969353"] = { primary = "rbxassetid://108879620126710", secondary = "rbxassetid://86510987016114" },
    ["13968137196"] = { primary = "rbxassetid://118906938239363" },
    ["14776414133"] = { primary = "rbxassetid://86510987016114" },
    ["14776437962"] = { primary = "rbxassetid://14000023581" },
    ["82797934287631"] = { primary = "rbxassetid://82797934287631" },
}

local function hookSound(sound)
    if not _scriptAlive then return end
    if not sound or sound.ClassName ~= "Sound" then return end
    local id = sound.SoundId:match("%d+")
    if not id then return end
    local repl = SOUND_REPLACEMENTS[id] or SOUND_REPLACEMENTS["rbxassetid://" .. id]
    if repl then
        setProperty(sound, "SoundId", repl.primary)
        if repl.volume then setProperty(sound, "Volume", repl.volume) end
        if repl.pitch then setProperty(sound, "PlaybackSpeed", repl.pitch) end
    end
end

-- Real-time sound interception (Event-driven + lightweight active VM scan)
pcall(function()
    local ss = game:GetService("SoundService")
    if ss then
        for _, s in ipairs(ss:GetDescendants()) do
            if s.ClassName == "Sound" then hookSound(s) end
        end
        table.insert(soundConnections, ss.DescendantAdded:Connect(function(s)
            if s.ClassName == "Sound" then hookSound(s) end
        end))
    end
    table.insert(soundConnections, workspace.DescendantAdded:Connect(function(s)
        if s.ClassName == "Sound" then hookSound(s) end
    end))
end)

spawnManaged(function()
    while _scriptAlive do
        task.wait(0.1)
        if not _scriptAlive then break end
        pcall(function()
            local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
            if fp then
                for _, vmInst in ipairs(fp:GetChildren()) do
                    for _, s in ipairs(vmInst:GetDescendants()) do
                        if s.ClassName == "Sound" then
                            hookSound(s)
                        end
                    end
                end
            end
        end)
    end
end)

-- Custom Animation Engine (Event Horizon Reload / Inspect & Arch Katana Inspect)
local sampleAnimInstance = nil
local function getSampleAnim()
    if sampleAnimInstance and sampleAnimInstance.Parent then return sampleAnimInstance end
    for _, d in ipairs(LP:GetDescendants()) do
        if d.ClassName == "Animation" then
            sampleAnimInstance = d
            return d
        end
    end
    local rs = game:GetService("ReplicatedStorage")
    for _, d in ipairs(rs:GetDescendants()) do
        if d.ClassName == "Animation" then
            sampleAnimInstance = d
            return d
        end
    end
    return nil
end

local function playCustomTrack(animator, assetId, speed)
    local sample = getSampleAnim()
    if not animator or not sample then return nil end
    if not _scriptAlive then return nil end
    local a = sample:Clone()
    table.insert(animationObjects, a)
    a.AnimationId = assetId
    local ok, track = pcall(animator.LoadAnimation, animator, a)
    if ok and track then
        if not _scriptAlive then
            pcall(function() track:Destroy() end)
            return nil
        end
        table.insert(animationTracks, track)
        track:Play(0.1, 1, speed or 1)
        return track
    end
    return nil
end

pcall(function()
    local uis = game:GetService("UserInputService")
    uisConn = uis.InputBegan:Connect(function(input, gpe)
        if gpe or not _scriptAlive then return end
        local fp = workspace:FindFirstChild("ViewModels") and workspace.ViewModels:FindFirstChild("FirstPerson")
        if not fp then return end
        for _, vmInst in ipairs(fp:GetChildren()) do
            local wName = vmInst.Name:match("%-%s*(.-)%s*%-") or vmInst.Name:match(LP.Name .. "%s*%-%s*(.-)%s*$")
            local ac = vmInst:FindFirstChild("AnimationController") or vmInst:FindFirstChildWhichIsA("AnimationController")
            local animator = ac and (ac:FindFirstChild("Animator") or ac:FindFirstChildWhichIsA("Animator"))
            
            if wName == "Sniper" and animator then
                if input.KeyCode == Enum.KeyCode.R then
                    -- Event Horizon Reload Animation
                    playCustomTrack(animator, "rbxassetid://121991964753861", 1.43)
                elseif input.KeyCode == Enum.KeyCode.F then
                    -- Event Horizon Inspect Animation
                    playCustomTrack(animator, "rbxassetid://89426100452654", 1)
                end
            elseif wName == "Katana" and animator then
                if input.KeyCode == Enum.KeyCode.F then
                    -- Arch Katana Inspect Animation (Fruit Slices)
                    playCustomTrack(animator, "rbxassetid://119980219668284", 1)
                end
            end
        end
    end)
end)

-- Main skin swapper; reads weapon-to-skin mappings from the config file
local function applySkinSwapper()
    local r2 = configText
    local swappedCount = 0

    for _, rawLine in ipairs(r2:split(string.char(10))) do 
        local l = rawLine:gsub(string.char(13), "")
        local q = l:find("=")
        if q then 
            local weaponName = l:sub(1, q - 1):match("^%s*(.-)%s*$")
            local skinTarget = l:sub(q + 1):match("^%s*(.-)%s*$")
            
            ACTIVE_CONFIG_SKINS[weaponName] = skinTarget
            
            -- Viewmodel 3D Model Memory Swapping (Symmetric Two-Way Swap)
            local defModel = wf:FindFirstChild(weaponName)
            local skinModel = findSkinModel(skinTarget)
            
            if defModel and skinModel and defModel.Address and skinModel.Address and defModel.Address ~= skinModel.Address then
                local skinFolder = skinModel.Parent
                if skinFolder and skinFolder.Address then
                    local defSlot = findSlotAddressForWeapon(defModel, wf)
                    local skinSlot = findSlotAddressForWeapon(skinModel, skinFolder)
                    
                    if defSlot and skinSlot then
                        rigSkinModel(skinModel)
                        
                        local weaponLower = weaponName:lower()
                        local skinLower = skinTarget:lower()
                        if weaponLower:find("crossbow") or skinLower:find("crossbow") then
                            pcall(fixCrossbowRig, skinModel)
                        elseif weaponLower:find("bow") or skinLower:find("bow") then
                            pcall(fixBowRig, skinModel)
                        elseif weaponLower:find("rpg") or skinLower:find("rpkey") or skinLower:find("rocket") then
                            pcall(fixRPGRig, skinModel)
                        elseif weaponLower == "grenade" or skinLower:find("nade") or skinLower:find("bomb") then
                            pcall(fixGrenadeRig, skinModel)
                        elseif weaponLower == "gunblade" or skinLower:find("gunblade") or skinLower:find("blade") then
                            pcall(fixGunbladeRig, skinModel)
                        elseif weaponLower == "katana" or skinLower:find("katana") then
                            pcall(fixKatanaRig, skinModel)
                        end
                        
                        local origDefInst = rd(defSlot)
                        local origSkinInst = rd(skinSlot)
                        local origDefNC = rd(defModel.Address + OFF.NameContainer)
                        local origSkinNC = rd(skinModel.Address + OFF.NameContainer)
                        local origDefParent = rd(defModel.Address + OFF.Parent)
                        local origSkinParent = rd(skinModel.Address + OFF.Parent)
                        
                        -- Symmetrical Two-Way Memory Swap:
                        -- 1. Swap NameContainer pointers
                        wr(skinModel.Address + OFF.NameContainer, origDefNC)
                        wr(defModel.Address + OFF.NameContainer, origSkinNC)
                        
                        -- 2. Swap parent pointers
                        wr(skinModel.Address + OFF.Parent, wf.Address)
                        wr(defModel.Address + OFF.Parent, skinFolder.Address)
                        
                        -- 3. Swap child vector slot pointers
                        wr(defSlot, skinModel.Address)
                        wr(skinSlot, defModel.Address)
                        
                        swappedCount = swappedCount + 1
                    end
                end
            end
        end 
    end
    
    return swappedCount
end

-- Run swapper and report elapsed time since script startup
local count = applySkinSwapper()
engineResult.ok = true
engineResult.count = count
local elapsed = math.floor((tick() - t_start) * 1000)
local msg = "Swapped " .. tostring(count) .. " skins in " .. tostring(elapsed) .. "ms!"
pcall(notify, msg, "Rivals Skin Changer", 4)
print("[RivalsSkinChanger] " .. msg)

-- Periodic watchdog: checks every 0.15 seconds and invokes cleanup when a listed condition is detected.
spawnManaged(function()
    while _scriptAlive do
        task.wait(0.15)
        if not _scriptAlive then break end
        if not LP or not LP.Parent or not wf or not wf.Parent or not game:IsLoaded() then
            fullCleanup()
            break
        end
    end
end)
end, function(err) return tostring(err) end)
if not setupOK then
    engineResult.ok = false
    engineResult.error = tostring(setupError)
    if cleanupCurrentRun then pcall(cleanupCurrentRun) end
    pcall(notify, "Skin changer stopped: " .. tostring(setupError), "SC", 6)
    print("[RivalsSkinChanger] Setup failed: " .. tostring(setupError))
end

return engineResult
end

-- Standalone floating GUI, rendered directly through Matcha's Drawing API.
local CATEGORIES = {"Primary", "Secondary", "Melee", "Utility"}
if not Drawing or type(Drawing.new) ~= "function" or not ismouse1pressed or not iskeypressed then
    pcall(notify, "This GUI needs Drawing.new and Matcha mouse/key input APIs.", "Rivals Skins", 8)
    return
end
if not game or game.GameId ~= 6035872082 then
    pcall(notify, "Open RIVALS before loading this menu.", "Rivals Skins", 6)
    return
end

local old = _G.__RIVALS_SKIN_GUI
if old and type(old.Destroy) == "function" then
    local ok, restored = pcall(old.Destroy)
    if not ok or restored == false then
        pcall(notify, "Previous cleanup failed; rejoin before loading the GUI.", "Rivals Skins", 8)
        return
    end
end

local state = {
    alive = true, enabled = false, busy = false, autoApply = true,
    version = 0, pending = nil, status = "Choose skins, then click Enable / Apply skins.",
    selections = {}, suppressChanges = false
}
local byName = {}
for i, weapon in ipairs(CATALOG) do
    weapon.id = "rivals_skin_gui_weapon_" .. tostring(i)
    byName[weapon.name] = weapon
    state.selections[weapon.name] = "Default"
end

local function validSkin(weapon, skin)
    for i, candidate in ipairs(weapon.skins) do
        if candidate == skin then return i - 1 end
    end
    return nil
end

local function importSelections(values)
    if type(values) ~= "table" then return end
    for name, skin in pairs(values) do
        local weapon = byName[name]
        if weapon and validSkin(weapon, skin) ~= nil then state.selections[name] = skin end
    end
end

if type(_G.__RIVALS_SKIN_GUI_SELECTIONS) == "table" then
    importSelections(_G.__RIVALS_SKIN_GUI_SELECTIONS)
elseif isfile and readfile then
    pcall(function()
        if not isfile("rivals_config.lua") then return end
        local imported = {}
        for line in readfile("rivals_config.lua"):gmatch("[^\r\n]+") do
            local name, skin = line:match("^%s*(.-)%s*=%s*(.-)%s*$")
            if name then imported[name] = skin end
        end
        importSelections(imported)
    end)
end
_G.__RIVALS_SKIN_GUI_SELECTIONS = state.selections

local function configText()
    local lines = {}
    for _, weapon in ipairs(CATALOG) do
        local skin = state.selections[weapon.name]
        if skin and skin ~= "Default" then table.insert(lines, weapon.name .. "=" .. skin) end
    end
    return table.concat(lines, "\n"), #lines
end

local function stopEngine()
    if type(_G.__RIVALS_SKIN_CHANGER_RESTORE) == "function" then
        local ok, restored = pcall(_G.__RIVALS_SKIN_CHANGER_RESTORE)
        if not ok or restored == false then return false end
    end
    return true
end

function state.Destroy()
    if not state.alive then return state.cleanupOK ~= false end
    state.alive = false
    if state.ReleaseInput then state.ReleaseInput() end
    state.pending = nil
    -- Invalidate an engine setup which may currently be sleeping.
    _G.__RIVALS_SKIN_CHANGER_RUN_TOKEN = {}
    if state.worker and task.cancel and state.worker ~= coroutine.running() then
        pcall(task.cancel, state.worker)
    end
    state.cleanupOK = stopEngine()
    if state.ReleaseInput then state.ReleaseInput() end
    if state.imageWorker and task.cancel and state.imageWorker ~= coroutine.running() then
        pcall(task.cancel, state.imageWorker)
    end
    if state.renderer and task.cancel and state.renderer ~= coroutine.running() then
        pcall(task.cancel, state.renderer)
    end
    for _,item in ipairs(state.drawings or {}) do pcall(function() item.object:Remove() end) end
    state.drawings = {}
    return state.cleanupOK
end

local function request(action)
    if not state.alive then return end
    state.version = state.version + 1
    state.pending = action
    state.status = action == "reset" and "Reset queued..." or "Changes queued..."
end

local function selectSkin(weapon, index)
    if not state.alive or state.suppressChanges then return end
    local skin = weapon.skins[(tonumber(index) or -1) + 1]
    if not skin or state.selections[weapon.name] == skin then return end
    state.selections[weapon.name] = skin
    if state.enabled and state.autoApply then
        request("apply")
    else
        state.status = "Selection changed. Click Enable / Apply skins."
    end
end

local function resetSelections()
    state.enabled = false
    state.suppressChanges = true
    for _, weapon in ipairs(CATALOG) do
        state.selections[weapon.name] = "Default"
    end
    state.suppressChanges = false
    request("reset")
end

local ICON_PATHS = {
    ["10B Visits"] = "assets/images/10b-visits.png",
    ["AK-47"] = "assets/images/ak-47.png",
    ["AKEY-47"] = "assets/images/akey-47.png",
    ["AUG"] = "assets/images/aug.png",
    ["Aces"] = "assets/images/aces.png",
    ["Advanced Satchel"] = "assets/images/advanced-satchel.png",
    ["Air Horn"] = "assets/images/air-horn.png",
    ["Anchor"] = "assets/images/anchor.png",
    ["Apex Pistols"] = "assets/images/apex-pistols.png",
    ["Apex Rifle"] = "assets/images/apex-rifle.png",
    ["Aqua Burst"] = "assets/images/aqua-burst.png",
    ["Arch Crossbow"] = "assets/images/arch-crossbow.png",
    ["Arch Katana"] = "assets/images/arch-katana.png",
    ["Arch Uzi"] = "assets/images/arch-uzi.png",
    ["Assault Rifle"] = "assets/images/assault-rifle.png",
    ["Bag o' Money"] = "assets/images/bag-o--money.png",
    ["Balance"] = "assets/images/balance.png",
    ["Balisong"] = "assets/images/balisong.png",
    ["Balloon Axe"] = "assets/images/balloon-axe.png",
    ["Balloon Bow"] = "assets/images/balloon-bow.png",
    ["Balloon Launcher"] = "assets/images/balloon-launcher.png",
    ["Balloon Shorty"] = "assets/images/balloon-shorty.png",
    ["Balloon Shotgun"] = "assets/images/balloon-shotgun.png",
    ["Ban Axe"] = "assets/images/ban-axe.png",
    ["Ban Hammer"] = "assets/images/ban-hammer.png",
    ["Banana Flare"] = "assets/images/banana-flare.png",
    ["Bat Bow"] = "assets/images/batbow.png",
    ["Bat Daggers"] = "assets/images/bat-daggers.png",
    ["Bat Scythe"] = "assets/images/batscythe.png",
    ["Battle Axe"] = "assets/images/battleaxe.png",
    ["Beach Ball"] = "assets/images/beachball.png",
    ["Beloved Bow"] = "assets/images/beloved-bow.png",
    ["Blaster"] = "assets/images/blaster.png",
    ["Blobsaw"] = "assets/images/blobsaw.png",
    ["Boba Gun"] = "assets/images/boba-gun.png",
    ["Boneblade"] = "assets/images/boneblade.png",
    ["Boneclaw Horn"] = "assets/images/boneclaw-horn.png",
    ["Boneclaw Revolver"] = "assets/images/boneclaw-revolver.png",
    ["Boneclaw Rifle"] = "assets/images/boneclaw-rifle.png",
    ["Boneclaw Spray"] = "assets/images/boneclawspray.png",
    ["Boneshot"] = "assets/images/boneshot.png",
    ["Bounce House"] = "assets/images/bounce-house.png",
    ["Bow"] = "assets/images/bow.png",
    ["Box of Chocolates"] = "assets/images/box-of-chocolates.png",
    ["Boxing Gloves"] = "assets/images/boxing-gloves.png",
    ["Brain Gun"] = "assets/images/brain-gun.png",
    ["Brass Knuckles"] = "assets/images/brassknuckles.png",
    ["Briefcase"] = "assets/images/briefcase.png",
    ["Broken Hearts"] = "assets/images/broken-hearts.png",
    ["Broomstick"] = "assets/images/broomstick.png",
    ["Bubble Ray"] = "assets/images/bubble-ray.png",
    ["Bubblethrower"] = "assets/images/bubblethrower.png",
    ["Bucket of Candy"] = "assets/images/bucketofcandy.png",
    ["Bug Net"] = "assets/images/bug-net.png",
    ["Burst Rifle"] = "assets/images/burst-rifle.png",
    ["Buzzsaw"] = "assets/images/buzzsaw.png",
    ["Cactus Shotgun"] = "assets/images/cactus-shotgun.png",
    ["Caladbolg"] = "assets/images/caladbolg.png",
    ["Camera"] = "assets/images/camera.png",
    ["Campfire Stick"] = "assets/images/campfirestick.png",
    ["Candy Cane"] = "assets/images/candy-cane.png",
    ["Cerulean Axe"] = "assets/images/cerulean-axe.png",
    ["Chainsaw"] = "assets/images/chainsaw.png",
    ["Chancla"] = "assets/images/chancla.png",
    ["Coffee"] = "assets/images/coffee.png",
    ["Compound Bow"] = "assets/images/compound-bow.png",
    ["Cookies"] = "assets/images/cookies.png",
    ["Crossbone"] = "assets/images/crossbone.png",
    ["Crossbow"] = "assets/images/crossbow.png",
    ["Crude Gunblade"] = "assets/images/crude-gunblade.png",
    ["Cryo Scythe"] = "assets/images/cryo-scythe.png",
    ["Crystal Katana"] = "assets/images/crystal-katana.png",
    ["Crystal Scythe"] = "assets/images/crystal-scythe.png",
    ["Cuddle Bomb"] = "assets/images/cuddlebomb.png",
    ["Cyber Warpstone"] = "assets/images/cyber-warpstone.png",
    ["DIY Tripmine"] = "assets/images/diy-tripmine.png",
    ["Daggers"] = "assets/images/daggers.png",
    ["Demon Shorty"] = "assets/images/demon-shorty.png",
    ["Demon Uzi"] = "assets/images/demon-uzi.png",
    ["Desert Eagle"] = "assets/images/desert-eagle.png",
    ["Dev-in-the-Box"] = "assets/images/dev-in-the-box.png",
    ["Disco Ball"] = "assets/images/disco-ball.png",
    ["Don't Press"] = "assets/images/don-t-press.png",
    ["Door"] = "assets/images/door.png",
    ["Dream Bow"] = "assets/images/dream-bow.png",
    ["Dynamite"] = "assets/images/dynamite.png",
    ["Dynamite Gun"] = "assets/images/dynamite-gun.png",
    ["Electro Rifle"] = "assets/images/electro-rifle.png",
    ["Electro Uzi"] = "assets/images/electro-uzi.png",
    ["Electropunk Warpstone"] = "assets/images/electropunk-warpstone.png",
    ["Elf's Gunblade"] = "assets/images/elf-s-gunblade.png",
    ["Emoji Cloud"] = "assets/images/emoji-cloud.png",
    ["Energy Pistols"] = "assets/images/energypistols.png",
    ["Energy Rifle"] = "assets/images/energyrifle.png",
    ["Energy Shield"] = "assets/images/energy-shield.png",
    ["Event Horizon"] = "assets/images/event-horizon.png",
    ["Evil Trident"] = "assets/images/evil-trident.png",
    ["Exogourd"] = "assets/images/exogourd.png",
    ["Exogun"] = "assets/images/exogun.png",
    ["Extinguisher"] = "assets/images/extinguisher.png",
    ["Eyeball"] = "assets/images/eyeball.png",
    ["Eyething Sniper"] = "assets/images/eyething-sniper.png",
    ["FAMAS"] = "assets/images/famas.png",
    ["Festive Buzzsaw"] = "assets/images/festive-buzzsaw.png",
    ["Fighter Jet"] = "assets/images/fighter-jet.png",
    ["Firework Gun"] = "assets/images/firework-gun.png",
    ["Firework Launcher"] = "assets/images/firework-launcher.png",
    ["Fist"] = "assets/images/fist.png",
    ["Fists"] = "assets/images/fists.png",
    ["Fists of Hurt"] = "assets/images/fists-of-hurt.png",
    ["Fizz Bomb"] = "assets/images/fizzbomb.png",
    ["Flamethrower"] = "assets/images/flamethrower.png",
    ["Flamingo Floatie"] = "assets/images/flamingofloatie.png",
    ["Flare Gun"] = "assets/images/flare-gun.png",
    ["Flashbang"] = "assets/images/flashbang.png",
    ["Freeze Ray"] = "assets/images/freezeray.png",
    ["Frostbite Bow"] = "assets/images/frostbite-bow.png",
    ["Frostbite Crossbow"] = "assets/images/frostbite-crossbow.png",
    ["Frozen Grenade"] = "assets/images/frozengrenade.png",
    ["Garden Shovel"] = "assets/images/garden-shovel.png",
    ["Gearnade Launcher"] = "assets/images/gearnade-launcher.png",
    ["Giant Pencil"] = "assets/images/giant-pencil.png",
    ["Gingerbread AUG"] = "assets/images/gingerbread-aug.png",
    ["Gingerbread Handgun"] = "assets/images/gingerbread-handgun.png",
    ["Gingerbread Sniper"] = "assets/images/gingerbread-sniper.png",
    ["Glitterthrower"] = "assets/images/glitterthrower.png",
    ["Glorious Assault Rifle"] = "assets/images/glorious-assault-rifle.png",
    ["Glorious Battle Axe"] = "assets/images/glorious-battle-axe.png",
    ["Glorious Bow"] = "assets/images/glorious-bow.png",
    ["Glorious Burst Rifle"] = "assets/images/glorious-burst-rifle.png",
    ["Glorious Chainsaw"] = "assets/images/glorious-chainsaw.png",
    ["Glorious Crossbow"] = "assets/images/glorious-crossbow.png",
    ["Glorious Daggers"] = "assets/images/glorious-daggers.png",
    ["Glorious Energy Pistols"] = "assets/images/glorious-energy-pistols.png",
    ["Glorious Energy Rifle"] = "assets/images/glorious-energy-rifle.png",
    ["Glorious Exogun"] = "assets/images/glorious-exogun.png",
    ["Glorious Fists"] = "assets/images/gloriousfists.png",
    ["Glorious Flamethrower"] = "assets/images/glorious-flamethrower.png",
    ["Glorious Flare Gun"] = "assets/images/glorious-flare-gun.png",
    ["Glorious Flashbang"] = "assets/images/glorious-flashbang.png",
    ["Glorious Freeze Ray"] = "assets/images/glorious-freeze-ray.png",
    ["Glorious Grenade"] = "assets/images/glorious-grenade.png",
    ["Glorious Grenade Launcher"] = "assets/images/glorious-grenade-launcher.png",
    ["Glorious Gunblade"] = "assets/images/glorious-gunblade.png",
    ["Glorious Handgun"] = "assets/images/glorious-handgun.png",
    ["Glorious Jump Pad"] = "assets/images/glorious-jump-pad.png",
    ["Glorious Katana"] = "assets/images/glorious-katana.png",
    ["Glorious Knife"] = "assets/images/glorious-knife.png",
    ["Glorious Maul"] = "assets/images/glorious-maul.png",
    ["Glorious Medkit"] = "assets/images/glorious-medkit.png",
    ["Glorious Minigun"] = "assets/images/glorious-minigun.png",
    ["Glorious Molotov"] = "assets/images/glorious-molotov.png",
    ["Glorious Paintball Gun"] = "assets/images/glorious-paintball-gun.png",
    ["Glorious RPG"] = "assets/images/glorious-rpg.png",
    ["Glorious Revolver"] = "assets/images/glorious-revolver.png",
    ["Glorious Riot Shield"] = "assets/images/glorious-riot-shield.png",
    ["Glorious Satchel"] = "assets/images/glorious-satchel.png",
    ["Glorious Scythe"] = "assets/images/glorious-scythe.png",
    ["Glorious Shorty"] = "assets/images/glorious-shorty.png",
    ["Glorious Shotgun"] = "assets/images/glorious-shotgun.png",
    ["Glorious Slingshot"] = "assets/images/glorious-slingshot.png",
    ["Glorious Smoke Grenade"] = "assets/images/glorious-smoke-grenade.png",
    ["Glorious Sniper"] = "assets/images/glorious-sniper.png",
    ["Glorious Spear"] = "assets/images/glorious-spear.png",
    ["Glorious Spray"] = "assets/images/glorious-spray.png",
    ["Glorious Subspace Tripmine"] = "assets/images/glorious-subspace-tripmine.png",
    ["Glorious Trowel"] = "assets/images/glorious-trowel.png",
    ["Glorious Uzi"] = "assets/images/glorious-uzi.png",
    ["Glorious War Horn"] = "assets/images/glorious-war-horn.png",
    ["Glorious Warpstone"] = "assets/images/glorious-warpstone.png",
    ["Goalpost"] = "assets/images/goalpost.png",
    ["Grenade"] = "assets/images/grenade.png",
    ["Grenade Launcher"] = "assets/images/grenadelauncher.png",
    ["Gum Ray"] = "assets/images/gum-ray.png",
    ["Gumball Handgun"] = "assets/images/gumball-handgun.png",
    ["Gunblade"] = "assets/images/gunblade.png",
    ["Gunsaw"] = "assets/images/gunsaw.png",
    ["Hacker Pistols"] = "assets/images/hacker-pistols.png",
    ["Hacker Rifle"] = "assets/images/hacker-rifle.png",
    ["Handgun"] = "assets/images/handgun.png",
    ["Handsaws"] = "assets/images/handsaws.png",
    ["Harp"] = "assets/images/harp.png",
    ["Harpoon Crossbow"] = "assets/images/harpoon-crossbow.png",
    ["Hazard Sign"] = "assets/images/hazardsign.png",
    ["Hot Coals"] = "assets/images/hot-coals.png",
    ["Hourglass"] = "assets/images/hourglass.png",
    ["Hydro Pistols"] = "assets/images/hydro-pistols.png",
    ["Hydro Rifle"] = "assets/images/hydro-rifle.png",
    ["Hyper Gunblade"] = "assets/images/hyper-gunblade.png",
    ["Hyper Shotgun"] = "assets/images/hyper-shotgun.png",
    ["Hyper Sniper"] = "assets/images/hyper-sniper.png",
    ["Hyperlaser Guns"] = "assets/images/hyperlaser-guns.png",
    ["Ice Cream"] = "assets/images/icecream.png",
    ["Ice Maul"] = "assets/images/ice-maul.png",
    ["Jack O'Thrower"] = "assets/images/jack-o-thrower.png",
    ["Jingle Grenade"] = "assets/images/jingle-grenade.png",
    ["Jolly Man"] = "assets/images/jolly-man.png",
    ["Jump Pad"] = "assets/images/jumppad.png",
    ["Karambit"] = "assets/images/karambit.png",
    ["Katana"] = "assets/images/katana.png",
    ["Ketchup Gun"] = "assets/images/ketchup-gun.png",
    ["Key Bow"] = "assets/images/keybow.png",
    ["Key Spray"] = "assets/images/key-spray.png",
    ["Keylisong"] = "assets/images/keylisong.png",
    ["Keynade"] = "assets/images/keynade.png",
    ["Keynais"] = "assets/images/keynais.png",
    ["Keyper"] = "assets/images/keyper.png",
    ["Keyrambit"] = "assets/images/keyrambit.png",
    ["Keyshot"] = "assets/images/keyshot.png",
    ["Keyst Rifle"] = "assets/images/keyst-rifle.png",
    ["Keytana"] = "assets/images/keytana.png",
    ["Keythe"] = "assets/images/keythe.png",
    ["Keythrower"] = "assets/images/keythrower.png",
    ["Keyttle Axe"] = "assets/images/keyttle-axe.png",
    ["Keyzi"] = "assets/images/keyzi.png",
    ["Knife"] = "assets/images/knife.png",
    ["Lamethrower"] = "assets/images/lamethrower.png",
    ["Laptop"] = "assets/images/laptop.png",
    ["Lasergun 3000"] = "assets/images/lasergun-3000.png",
    ["Lava Lamp"] = "assets/images/lava-lamp.png",
    ["Lifeguard Satchel"] = "assets/images/lifeguardsatchel.png",
    ["Lifeguard Whistle"] = "assets/images/lifeguardwhistle.png",
    ["Lightbulb"] = "assets/images/lightbulb.png",
    ["Lightning Bolt"] = "assets/images/lightning-bolt.png",
    ["Linked Sword"] = "assets/images/linked-sword.png",
    ["Lovely Shorty"] = "assets/images/lovely-shorty.png",
    ["Lovely Spray"] = "assets/images/lovely-spray.png",
    ["Lucky Horseshoe"] = "assets/images/lucky-horseshoe.png",
    ["Machete"] = "assets/images/machete.png",
    ["Mammoth Horn"] = "assets/images/mammoth-horn.png",
    ["Masterpiece"] = "assets/images/masterpiece.png",
    ["Maul"] = "assets/images/maul.png",
    ["Medkit"] = "assets/images/medkit.png",
    ["Medkitty"] = "assets/images/medkitty.png",
    ["Megaphone"] = "assets/images/megaphone.png",
    ["Midnight Festive Exogun"] = "assets/images/midnight-festive-exogun.png",
    ["Milk & Cookies"] = "assets/images/milk---cookies.png",
    ["Mimic Axe"] = "assets/images/mimic-axe.png",
    ["Minigun"] = "assets/images/minigun.png",
    ["Molotov"] = "assets/images/molotov.png",
    ["Money Gun"] = "assets/images/money-gun.png",
    ["Nail Gun"] = "assets/images/nail-gun.png",
    ["New Year Energy Pistols"] = "assets/images/new-year-energy-pistols.png",
    ["New Year Energy Rifle"] = "assets/images/new-year-energy-rifle.png",
    ["New Year Katana"] = "assets/images/new-year-katana.png",
    ["Nordic Axe"] = "assets/images/nordic-axe.png",
    ["Not So Shorty"] = "assets/images/not-so-shorty.png",
    ["Notebook Satchel"] = "assets/images/notebook-satchel.png",
    ["Nuke Launcher"] = "assets/images/nuke-launcher.png",
    ["Paintball Gun"] = "assets/images/paintball-gun.png",
    ["Paintballoon Gun"] = "assets/images/paintballoon-gun.png",
    ["Paintbrush"] = "assets/images/paintbrush.png",
    ["Palmshot"] = "assets/images/palmshot.png",
    ["Paper Planes"] = "assets/images/paper-planes.png",
    ["Pearl Rifle"] = "assets/images/pearlrifle.png",
    ["Pencil"] = "assets/images/pencil.png",
    ["Pencil Launcher"] = "assets/images/pencil-launcher.png",
    ["Peppergun"] = "assets/images/peppergun.png",
    ["Peppermint Sheriff"] = "assets/images/peppermint-sheriff.png",
    ["Phoenix Rifle"] = "assets/images/phoenix-rifle.png",
    ["Pine Burst"] = "assets/images/pine-burst.png",
    ["Pine Spray"] = "assets/images/pine-spray.png",
    ["Pine Uzi"] = "assets/images/pine-uzi.png",
    ["Pirate Hook"] = "assets/images/piratehook.png",
    ["Pixel Burst"] = "assets/images/pixel-burst.png",
    ["Pixel Crossbow"] = "assets/images/pixel-crossbow.png",
    ["Pixel Flamethrower"] = "assets/images/pixel-flamethrower.png",
    ["Pixel Flashbang"] = "assets/images/pixel-flashbang.png",
    ["Pixel Handgun"] = "assets/images/pixel-handgun.png",
    ["Pixel Katana"] = "assets/images/pixel-katana.png",
    ["Pixel Minigun"] = "assets/images/pixel-minigun.png",
    ["Pixel Sniper"] = "assets/images/pixel-sniper.png",
    ["Plastic Shovel"] = "assets/images/plastic-shovel.png",
    ["Pot o' Keys"] = "assets/images/pot-o--keys.png",
    ["Potion Satchel"] = "assets/images/potion-satchel.png",
    ["Pumpkin Carver"] = "assets/images/pumpkin-carver.png",
    ["Pumpkin Claws"] = "assets/images/pumpkin-claws.png",
    ["Pumpkin Handgun"] = "assets/images/pumpkin-handgun.png",
    ["Pumpkin Launcher"] = "assets/images/pumpkin-launcher.png",
    ["Pumpkin Minigun"] = "assets/images/pumpkin-minigun.png",
    ["RPG"] = "assets/images/rpg.png",
    ["RPKEY"] = "assets/images/rpkey.png",
    ["Rainbowthrower"] = "assets/images/rainbowthrower.png",
    ["Raven Bow"] = "assets/images/raven-bow.png",
    ["Ray Gun"] = "assets/images/ray-gun.png",
    ["Reindeer Slingshot"] = "assets/images/reindeer-slingshot.png",
    ["Repulsor"] = "assets/images/repulsor.png",
    ["Revolver"] = "assets/images/revolver.png",
    ["Rocket Launcher"] = "assets/images/rocket-launcher.png",
    ["Saber"] = "assets/images/saber.png",
    ["Sakura Scythe"] = "assets/images/sakura-scythe.png",
    ["Sandwich"] = "assets/images/sandwich.png",
    ["Scythe"] = "assets/images/scythe.png",
    ["Scythe of Death"] = "assets/images/scythe-of-death.png",
    ["Shady Chicken Sandwich"] = "assets/images/shady-chicken-sandwich.png",
    ["Sheriff"] = "assets/images/sheriff.png",
    ["Shining Star"] = "assets/images/shining-star.png",
    ["Shorty"] = "assets/images/shorty.png",
    ["Shotgun"] = "assets/images/shotgun.png",
    ["Shurikens"] = "assets/images/shurikens.png",
    ["Singularity"] = "assets/images/singularity.png",
    ["Skull Launcher"] = "assets/images/skull-launcher.png",
    ["Sled"] = "assets/images/sled.png",
    ["Sleigh Maul"] = "assets/images/sleigh-maul.png",
    ["Slime Gun"] = "assets/images/slime-gun.png",
    ["Slingshot"] = "assets/images/slingshot.png",
    ["Sniper"] = "assets/images/sniper.png",
    ["Snow Shovel"] = "assets/images/snow-shovel.png",
    ["Snowball Gun"] = "assets/images/snowball-gun.png",
    ["Snowball Launcher"] = "assets/images/snowball-launcher.png",
    ["Snowblower"] = "assets/images/snowblower.png",
    ["Snowglobe"] = "assets/images/snowglobe.png",
    ["Soul Pistols"] = "assets/images/soul-pistols.png",
    ["Soul Rifle"] = "assets/images/soul-rifle.png",
    ["Spaceship Launcher"] = "assets/images/spaceship-launcher.png",
    ["Spear"] = "assets/images/spear.png",
    ["Spider Web"] = "assets/images/spider-web.png",
    ["Spray Bottle"] = "assets/images/spray-bottle.png",
    ["Spring"] = "assets/images/spring.png",
    ["Spy Gloves"] = "assets/images/spy-gloves.png",
    ["Squid Launcher"] = "assets/images/squid-launcher.png",
    ["Stellar Katana"] = "assets/images/stellar-katana.png",
    ["Stick"] = "assets/images/stick.png",
    ["Studio Light"] = "assets/images/studio-light.png",
    ["Subspace Tripmine"] = "assets/images/subspace-tripmine.png",
    ["Suspicious Gift"] = "assets/images/suspicious-gift.png",
    ["Swashbuckler"] = "assets/images/swashbuckler.png",
    ["Teleport Disc"] = "assets/images/teleport-disc.png",
    ["Temporal Ray"] = "assets/images/temporal-ray.png",
    ["The Shred"] = "assets/images/the-shred.png",
    ["Toaster"] = "assets/images/toaster.png",
    ["Tombstone Shield"] = "assets/images/tombstone-shield.png",
    ["Tommy Gun"] = "assets/images/tommy-gun.png",
    ["Too Shorty"] = "assets/images/too-shorty.png",
    ["Torch"] = "assets/images/torch.png",
    ["Trampoline"] = "assets/images/trampoline.png",
    ["Trick or Treat"] = "assets/images/trick-or-treat.png",
    ["Trumpet"] = "assets/images/trumpet.png",
    ["Unstable Warpstone"] = "assets/images/unstable-warpstone.png",
    ["Uranium Launcher"] = "assets/images/uranium-launcher.png",
    ["Uzi"] = "assets/images/uzi.png",
    ["Vexed Candle"] = "assets/images/vexed-candle.png",
    ["Violin Crossbow"] = "assets/images/violin-crossbow.png",
    ["Void Pistols"] = "assets/images/void-pistols.png",
    ["Void Rifle"] = "assets/images/void-rifle.png",
    ["War Horn"] = "assets/images/war-horn.png",
    ["Warp Handgun"] = "assets/images/warp-handgun.png",
    ["Warpbone"] = "assets/images/warpbone.png",
    ["Warpeye"] = "assets/images/warpeye.png",
    ["Warpstar"] = "assets/images/warpstar.png",
    ["Warpstone"] = "assets/images/warpstone.png",
    ["Water Balloon"] = "assets/images/water-balloon.png",
    ["Water Uzi"] = "assets/images/water-uzi.png",
    ["Whoopee Cushion"] = "assets/images/whoopee-cushion.png",
    ["Wondergun"] = "assets/images/wondergun.png",
    ["Wrapped Flare Gun"] = "assets/images/wrapped-flare-gun.png",
    ["Wrapped Freeze Ray"] = "assets/images/wrapped-freeze-ray.png",
    ["Wrapped Minigun"] = "assets/images/wrapped-minigun.png",
    ["Wrapped Shorty"] = "assets/images/wrapped-shorty.png",
    ["Wrapped Shotgun"] = "assets/images/wrapped-shotgun.png",
}

-- Retained scene: stationary frames do not write Drawing properties.
state.visible,state.category,state.page=true,"Primary",1
state.x,state.y,state.w,state.h=80,70,820,590
state.drawings,state.hitboxes={},{}
state.dropdown,state.dropdownPage=nil,1
state.dirty=true
state.imageCache,state.imageQueue,state.imageQueued={},{},{}
local mouse=game:GetService("Players").LocalPlayer:GetMouse()
local rgb=Color3.fromRGB
local P={bg=rgb(13,17,25),panel=rgb(20,26,37),row=rgb(25,33,46),field=rgb(34,44,60),border=rgb(42,54,70),accent=rgb(100,231,195),text=rgb(236,243,250),muted=rgb(146,164,187),faint=rgb(89,110,136),white=rgb(255,255,255)}
local poolIndex=0
local activeScene=true
local function assign(item,key,value)
    local old=item.cache[key]
    local equal=old==value
    if not equal and (key=="Position" or key=="Size") and old~=nil and type(value)~="number" then equal=old.X==value.X and old.Y==value.Y end
    if not equal then item.object[key]=value; item.cache[key]=value end
end
local function draw(kind,x,y,props)
    poolIndex=poolIndex+1
    local item=state.drawings[poolIndex]
    if item and item.kind~=kind then item.object:Remove(); item=nil end
    if not item then item={kind=kind,object=Drawing.new(kind),cache={}}; state.drawings[poolIndex]=item end
    item.x,item.y=x,y
    assign(item,"Position",Vector2.new(state.x+x,state.y+y))
    for key,value in pairs(props) do
        if key=="_TextSize" then
            if item.canSize==nil then item.canSize=pcall(function() item.object.Size=value end); if item.canSize then item.cache.Size=value end
            elseif item.canSize then assign(item,"Size",value) end
        else assign(item,key,value) end
    end
    assign(item,"Visible",true); item.used=true
end
local function rect(x,y,w,h,color,z) draw("Square",x,y,{Size=Vector2.new(w,h),Color=color,Filled=true,Transparency=1,ZIndex=z or 10}) end
local function text(value,x,y,color,size,z)
    local props={Text=value,Color=color or P.text,_TextSize=size or 14,Center=false,Outline=false,Transparency=1,ZIndex=z or 20}
    if Drawing.Fonts and Drawing.Fonts.System then props.Font=Drawing.Fonts.System end
    draw("Text",x,y,props)
end
local function short(s,n) return #s>n and s:sub(1,n-3).."..." or s end
local function contains(hit,x,y) return x>=hit.x and x<=hit.x+hit.w and y>=hit.y and y<=hit.y+hit.h end
local function hit(id,x,y,w,h,callback,modal) table.insert(state.hitboxes,{id=id,x=x,y=y,w=w,h=h,callback=callback,modal=modal}) end
local function button(id,title,x,y,w,h,callback,accent,modal)
    local z=modal and 41 or 16
    rect(x,y,w,h,state.hover==id and P.border or (accent and P.accent or P.field),z)
    text(title,x+12,y+math.floor((h-16)/2),accent and state.hover~=id and P.bg or P.text,14,z+1)
    hit(id,x,y,w,h,callback,modal)
end
local function mark() state.dirty=true end
local function icon(name,x,y,size,z)
    local path=ICON_PATHS[name]
    local data=path and state.imageCache[path]
    if path and data==nil and not state.imageQueued[path] then state.imageQueued[path]=true; table.insert(state.imageQueue,path) end
    if type(data)=="string" then
        draw("Image",x,y,{Data=data,Size=Vector2.new(size,size),Color=P.white,Transparency=1,ZIndex=z or 14})
    else
        rect(x+4,y+size*.42,size*.72,4,P.faint,z or 14)
        rect(x+size*.30,y+size*.45,5,size*.27,P.faint,z or 14)
        rect(x+size*.66,y+size*.31,4,size*.18,P.faint,z or 14)
    end
end
local function filtered()
    local list={}; for _,weapon in ipairs(CATALOG) do if weapon.category==state.category then table.insert(list,weapon) end end; return list
end
function state.ReleaseInput()
    if state.inputCaptured and setrobloxinput then pcall(setrobloxinput,true) end
    state.inputCaptured=false
end
local function captureInput(capture)
    if capture then
        if not state.inputCaptured and setrobloxinput then local ok,result=pcall(setrobloxinput,false); state.inputCaptured=ok and result~=false end
    else state.ReleaseInput() end
end
local function showScene(show)
    if activeScene==show then return end
    activeScene=show
    for _,item in ipairs(state.drawings) do assign(item,"Visible",show and item.used or false) end
end
local function translateScene()
    for _,item in ipairs(state.drawings) do if item.used then assign(item,"Position",Vector2.new(state.x+item.x,state.y+item.y)) end end
end
local function render()
    poolIndex=0; state.hitboxes={}
    local w,h=state.w,state.h
    rect(5,7,w,h,rgb(5,8,12),8); rect(0,0,w,h,P.bg,9); rect(0,0,w,2,P.accent)
    text("R /",22,18,P.accent,24); text("SKIN STUDIO",76,18,P.text,22); text("YOUR ARSENAL. YOUR STYLE.",77,46,P.faint,10)
    button("hide","_",w-78,18,28,28,function() state.visible=false; state.dropdown=nil end)
    button("close","X",w-42,18,28,28,function() request("close") end)
    rect(18,78,164,h-159,P.panel,11); text("LOADOUT",32,94,P.faint,11)
    for i,category in ipairs(CATEGORIES) do
        local chosen=category; local cy=123+(i-1)*49; local selected=state.category==category
        if selected then rect(18,cy,3,39,P.accent,13) end
        button("category:"..category,category,29,cy,141,39,function() state.category=chosen; state.page=1; state.dropdown=nil; mark() end,selected)
    end
    text("44 WEAPONS",32,h-151,P.muted,11); text("369 SKIN OPTIONS",32,h-130,P.faint,10)
    local left=202
    text(state.category.." collection",left,83,P.text,20); text("Pick a weapon finish from its dropdown.",left,112,P.muted,12)
    local _,count=configText(); text(tostring(count).." SELECTED",w-124,92,P.accent,11)
    local list=filtered(); local rows=math.max(3,math.floor((h-268)/55)); local pages=math.max(1,math.ceil(#list/rows)); state.page=math.min(state.page,pages)
    local rowW=w-left-20
    for row=1,rows do
        local weapon=list[(state.page-1)*rows+row]
        if weapon then
            local ry=144+(row-1)*55; local skin=state.selections[weapon.name]
            rect(left,ry,rowW,48,P.row,12); icon(skin=="Default" and weapon.name or skin,left+6,ry+3,42)
            text(short(weapon.name,24),left+55,ry+7,P.text,14)
            text(skin=="Default" and "ORIGINAL FINISH" or "CUSTOM FINISH",left+55,ry+28,skin=="Default" and P.faint or P.accent,9)
            local bx=left+math.floor(rowW*.48); local bw=w-32-bx
            button("weapon:"..weapon.name,short(skin,math.max(12,math.floor((bw-35)/7))).."  v",bx,ry+7,bw,34,function()
                state.dropdown=weapon; state.dropdownPage=math.floor((validSkin(weapon,skin) or 0)/7)+1; mark()
            end)
        end
    end
    local py=h-114
    button("previous","<",left,py,30,27,function() state.page=math.max(1,state.page-1); mark() end)
    text(state.page.." / "..pages,left+44,py+6,P.muted,12)
    button("next",">",left+93,py,30,27,function() state.page=math.min(pages,state.page+1); mark() end)
    button("auto",state.autoApply and "Auto-apply  ON" or "Auto-apply  OFF",w-180,py,160,27,function() state.autoApply=not state.autoApply; mark() end)
    rect(18,h-74,w-36,1,P.border)
    button("apply",state.busy and "Applying..." or "Apply selected skins",20,h-59,205,36,function() state.enabled=true; request("apply"); mark() end,true)
    button("reset","Reset to Default",236,h-59,167,36,function() resetSelections(); mark() end)
    text(short(state.status,math.max(18,math.floor((w-438)/6))),421,h-56,P.muted,11)
    text("RIGHT SHIFT  /  hide & release input",421,h-35,P.faint,10)
    for _,corner in ipairs({{0,0},{w-9,0},{0,h-9},{w-9,h-9}}) do rect(corner[1],corner[2],9,2,P.accent,18) end
    if state.dropdown then
        local weapon=state.dropdown; local dw=math.min(458,w-60); local dh=397; local dx=math.floor((w-dw)/2); local dy=math.floor((h-dh)/2)
        rect(dx-5,dy-5,dw+10,dh+10,rgb(7,10,16),38); rect(dx,dy,dw,dh,P.panel,39); rect(dx,dy,dw,2,P.accent,40)
        text(weapon.name,dx+16,dy+15,P.text,19,42); text("SELECT A FINISH",dx+16,dy+42,P.faint,10,42)
        button("dropdown-close","X",dx+dw-42,dy+14,28,28,function() state.dropdown=nil; mark() end,false,true)
        local pages=math.max(1,math.ceil(#weapon.skins/7))
        for row=1,7 do
            local index=(state.dropdownPage-1)*7+row; local skin=weapon.skins[index]
            if skin then
                local sy=dy+66+(row-1)*39; local selected=state.selections[weapon.name]==skin
                rect(dx+12,sy,dw-24,34,selected and P.field or P.row,40)
                if selected then rect(dx+12,sy,2,34,P.accent,41) end
                icon(skin=="Default" and weapon.name or skin,dx+18,sy+1,32,42)
                text(short(skin,45),dx+62,sy+10,selected and P.accent or P.text,13,42)
                hit("skin:"..index,dx+12,sy,dw-24,34,function() selectSkin(weapon,index-1); state.dropdown=nil; mark() end,true)
            end
        end
        button("skins-previous","< Previous",dx+12,dy+354,116,28,function() state.dropdownPage=math.max(1,state.dropdownPage-1); mark() end,false,true)
        text(state.dropdownPage.." / "..pages,dx+dw/2-15,dy+361,P.muted,12,42)
        button("skins-next","Next >",dx+dw-128,dy+354,116,28,function() state.dropdownPage=math.min(pages,state.dropdownPage+1); mark() end,false,true)
    end
    for i=poolIndex+1,#state.drawings do local item=state.drawings[i]; item.used=false; assign(item,"Visible",false) end
    state.dirty=false; state.lastStatus=state.status; state.lastBusy=state.busy
end
local function cornerAt(x,y)
    local r=13
    if x>=-4 and x<=r and y>=-4 and y<=r then return "nw" end
    if x>=state.w-r and x<=state.w+4 and y>=-4 and y<=r then return "ne" end
    if x>=-4 and x<=r and y>=state.h-r and y<=state.h+4 then return "sw" end
    if x>=state.w-r and x<=state.w+4 and y>=state.h-r and y<=state.h+4 then return "se" end
end
local function click(mx,my)
    local x,y=mx-state.x,my-state.y; local corner=not state.dropdown and cornerAt(x,y)
    if corner then state.resize={corner=corner,x=state.x,y=state.y,w=state.w,h=state.h,mx=mx,my=my}; return end
    for i=#state.hitboxes,1,-1 do local ht=state.hitboxes[i]; if (not state.dropdown or ht.modal) and contains(ht,x,y) then ht.callback(); return end end
    if state.dropdown then state.dropdown=nil; mark(); return end
    if x>=0 and x<state.w-94 and y>=0 and y<70 then state.drag={x=mx-state.x,y=my-state.y} end
end
local function resize(mx,my,vw,vh)
    local r=state.resize; local left,top,right,bottom=r.x,r.y,r.x+r.w,r.y+r.h; local dx,dy=mx-r.mx,my-r.my
    local minW,minH=math.min(700,vw),math.min(520,vh)
    if r.corner:find("w") then left=math.max(0,math.min(r.x+dx,right-minW)) else right=math.min(vw,math.max(right+dx,left+minW)) end
    if r.corner:find("n") then top=math.max(0,math.min(r.y+dy,bottom-minH)) else bottom=math.min(vh,math.max(bottom+dy,top+minH)) end
    state.x,state.y=math.floor(left),math.floor(top)
    local w,h=math.floor(right-left),math.floor(bottom-top)
    if w~=state.w or h~=state.h then state.w,state.h=w,h; mark() end
end
local setupOK,setupError=pcall(function()
    local view=workspace.CurrentCamera.ViewportSize
    state.w=math.min(state.w,view.X); state.h=math.min(state.h,view.Y)
    state.x=math.max(0,math.min(state.x,view.X-state.w)); state.y=math.max(0,math.min(state.y,view.Y-state.h))
    captureInput(true); render()
end)
if not setupOK then state.Destroy(); pcall(notify,"GUI setup failed: "..tostring(setupError),"Rivals Skins",8); return end
state.imageWorker=task.spawn(function()
    local order={}
    while state.alive do
        task.wait(0.05); if not state.alive then break end
        local path=table.remove(state.imageQueue,1)
        if path then
            local ok,data=pcall(function() return game:HttpGet("https://martinikaws.github.io/rivals-skins/"..path) end)
            if not state.alive then break end
            state.imageCache[path]=ok and type(data)=="string" and data:sub(1,8)=="\137PNG\r\n\26\n" and data or false
            table.insert(order,path)
            if #order>72 then local oldest=table.remove(order,1); state.imageCache[oldest]=nil; state.imageQueued[oldest]=nil end
            mark()
        end
    end
end)
state.renderer=task.spawn(function()
    local wasDown,wasToggle=false,false
    while state.alive do
        task.wait(0.016); if not state.alive then break end
        local ok,err=pcall(function()
            local active=not isrbxactive or isrbxactive(); local down,toggle=ismouse1pressed(),iskeypressed(0xA1)
            if active and toggle and not wasToggle then state.visible=not state.visible; state.dropdown=nil; state.drag=nil; state.resize=nil; mark() end
            captureInput(active and state.visible)
            if active and state.visible then
                local mx,my=mouse.X,mouse.Y
                if down and not wasDown then click(mx,my) end
                local view=workspace.CurrentCamera.ViewportSize
                if down and state.drag then
                    local x=math.floor(math.max(0,math.min(mx-state.drag.x,math.max(0,view.X-state.w))))
                    local y=math.floor(math.max(0,math.min(my-state.drag.y,math.max(0,view.Y-state.h))))
                    if x~=state.x or y~=state.y then state.x,state.y=x,y; translateScene() end
                elseif down and state.resize then resize(mx,my,view.X,view.Y)
                elseif not down then state.drag=nil; state.resize=nil end
                local hover=nil
                if not state.drag and not state.resize then
                    for i=#state.hitboxes,1,-1 do local ht=state.hitboxes[i]; if (not state.dropdown or ht.modal) and contains(ht,mx-state.x,my-state.y) then hover=ht.id; break end end
                end
                if hover~=state.hover then state.hover=hover; mark() end
                if state.lastStatus~=state.status or state.lastBusy~=state.busy then mark() end
                if state.dirty and state.visible then render() end
            else state.drag=nil; state.resize=nil end
            captureInput(active and state.visible); showScene(active and state.visible)
            wasDown,wasToggle=down,toggle
        end)
        if not ok then state.Destroy(); pcall(notify,"GUI stopped: "..tostring(err),"Rivals Skins",8); break end
    end
end)

_G.__RIVALS_SKIN_GUI = state
state.worker = task.spawn(function()
    while state.alive do
        task.wait(0.15)
        if not state.alive then break end
        local action = state.pending
        if action then
            state.pending = nil
            local version = state.version
            if action == "close" then state.Destroy(); break end
            state.busy = true
            state.status = "Restoring previous skins..."
            local ok, failure = pcall(function()
                if action == "reset" then
                    if not stopEngine() then
                        state.status = "Cleanup failed. Rejoin before applying again."
                    else
                        state.status = "Reset complete. All selections are Default."
                    end
                else
                    local text, requested = configText()
                    if requested == 0 then
                        state.status = stopEngine() and "Defaults restored; select a skin to apply." or "Cleanup failed. Rejoin."
                    else
                        local result = runEngine(text)
                        if not state.alive then return end
                        if result.ok then
                            state.status = "Applied " .. tostring(result.count) .. "/" .. tostring(requested) .. " selected skins."
                            if result.count < requested then
                                state.status = state.status .. " Some models were unavailable."
                            end
                        else
                            state.status = tostring(result.error)
                        end
                    end
                end
            end)
            state.busy = false
            if not state.alive then break end
            if not ok then
                stopEngine()
                state.status = "Apply failed: " .. tostring(failure)
            end
            if state.version ~= version and state.pending then state.status = "Latest selection queued..." end
        end
    end
end)
pcall(notify, "Floating GUI ready. Right Shift hides/shows it.", "Rivals Skins", 7)
