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
    for _,item in ipairs(state.ghost or {}) do pcall(function() item.object:Remove() end) end
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

local ICON_BASE = "https://raw.githubusercontent.com/WilliamO2025/RivalsSkinChanger/973761457b0d659ab3bfc7e68afcc97dd6389375/icons-v2/"
local ICON_PACKS = {
 ["10B Visits"]="weapon-01.json",
 ["AK-47"]="weapon-01.json",
 ["AKEY-47"]="weapon-01.json",
 ["AUG"]="weapon-01.json",
 ["Aces"]="weapon-07.json",
 ["Advanced Satchel"]="weapon-31.json",
 ["Air Horn"]="weapon-43.json",
 ["Anchor"]="weapon-32.json",
 ["Apex Pistols"]="weapon-08.json",
 ["Apex Rifle"]="weapon-09.json",
 ["Aqua Burst"]="weapon-04.json",
 ["Arch Crossbow"]="weapon-06.json",
 ["Arch Katana"]="weapon-21.json",
 ["Arch Uzi"]="weapon-42.json",
 ["Assault Rifle"]="weapon-01.json",
 ["Bag o' Money"]="weapon-31.json",
 ["Balance"]="weapon-36.json",
 ["Balisong"]="weapon-22.json",
 ["Balloon Axe"]="weapon-02.json",
 ["Balloon Bow"]="weapon-03.json",
 ["Balloon Launcher"]="weapon-17.json",
 ["Balloon Shorty"]="weapon-33.json",
 ["Balloon Shotgun"]="weapon-34.json",
 ["Ban Axe"]="weapon-02.json",
 ["Ban Hammer"]="weapon-23.json",
 ["Banana Flare"]="weapon-13.json",
 ["Bat Bow"]="weapon-03.json",
 ["Bat Daggers"]="weapon-07.json",
 ["Bat Scythe"]="weapon-32.json",
 ["Battle Axe"]="weapon-02.json",
 ["Beach Ball"]="weapon-36.json",
 ["Beloved Bow"]="weapon-03.json",
 ["Blaster"]="weapon-19.json",
 ["Blobsaw"]="weapon-05.json",
 ["Boba Gun"]="weapon-27.json",
 ["Boneblade"]="weapon-18.json",
 ["Boneclaw Horn"]="weapon-43.json",
 ["Boneclaw Revolver"]="weapon-28.json",
 ["Boneclaw Rifle"]="weapon-01.json",
 ["Boneclaw Spray"]="weapon-39.json",
 ["Boneshot"]="weapon-35.json",
 ["Bounce House"]="weapon-20.json",
 ["Bow"]="weapon-03.json",
 ["Box of Chocolates"]="weapon-24.json",
 ["Boxing Gloves"]="weapon-11.json",
 ["Brain Gun"]="weapon-27.json",
 ["Brass Knuckles"]="weapon-11.json",
 ["Briefcase"]="weapon-24.json",
 ["Broken Hearts"]="weapon-07.json",
 ["Broomstick"]="weapon-34.json",
 ["Bubble Ray"]="weapon-15.json",
 ["Bubblethrower"]="weapon-12.json",
 ["Bucket of Candy"]="weapon-24.json",
 ["Bug Net"]="weapon-32.json",
 ["Burst Rifle"]="weapon-04.json",
 ["Buzzsaw"]="weapon-05.json",
 ["Cactus Shotgun"]="weapon-34.json",
 ["Caladbolg"]="weapon-22.json",
 ["Camera"]="weapon-14.json",
 ["Campfire Stick"]="weapon-26.json",
 ["Candy Cane"]="weapon-22.json",
 ["Cerulean Axe"]="weapon-02.json",
 ["Chainsaw"]="weapon-05.json",
 ["Chancla"]="weapon-22.json",
 ["Coffee"]="weapon-26.json",
 ["Compound Bow"]="weapon-03.json",
 ["Cookies"]="weapon-07.json",
 ["Crossbone"]="weapon-06.json",
 ["Crossbow"]="weapon-06.json",
 ["Crude Gunblade"]="weapon-18.json",
 ["Cryo Scythe"]="weapon-32.json",
 ["Crystal Katana"]="weapon-21.json",
 ["Crystal Scythe"]="weapon-32.json",
 ["Cuddle Bomb"]="weapon-16.json",
 ["Cyber Warpstone"]="weapon-44.json",
 ["DIY Tripmine"]="weapon-40.json",
 ["Daggers"]="weapon-07.json",
 ["Demon Shorty"]="weapon-33.json",
 ["Demon Uzi"]="weapon-42.json",
 ["Desert Eagle"]="weapon-28.json",
 ["Dev-in-the-Box"]="weapon-40.json",
 ["Disco Ball"]="weapon-14.json",
 ["Don't Press"]="weapon-40.json",
 ["Door"]="weapon-29.json",
 ["Dream Bow"]="weapon-03.json",
 ["Dynamite"]="weapon-16.json",
 ["Dynamite Gun"]="weapon-13.json",
 ["Electro Rifle"]="weapon-04.json",
 ["Electro Uzi"]="weapon-42.json",
 ["Electropunk Warpstone"]="weapon-44.json",
 ["Elf's Gunblade"]="weapon-18.json",
 ["Emoji Cloud"]="weapon-36.json",
 ["Energy Pistols"]="weapon-08.json",
 ["Energy Rifle"]="weapon-09.json",
 ["Energy Shield"]="weapon-29.json",
 ["Event Horizon"]="weapon-37.json",
 ["Evil Trident"]="weapon-21.json",
 ["Exogourd"]="weapon-10.json",
 ["Exogun"]="weapon-10.json",
 ["Extinguisher"]="weapon-12.json",
 ["Eyeball"]="weapon-36.json",
 ["Eyething Sniper"]="weapon-37.json",
 ["FAMAS"]="weapon-04.json",
 ["Festive Buzzsaw"]="weapon-05.json",
 ["Fighter Jet"]="weapon-25.json",
 ["Firework Gun"]="weapon-13.json",
 ["Firework Launcher"]="weapon-30.json",
 ["Fist"]="weapon-11.json",
 ["Fists"]="weapon-11.json",
 ["Fists of Hurt"]="weapon-11.json",
 ["Fizz Bomb"]="weapon-16.json",
 ["Flamethrower"]="weapon-12.json",
 ["Flamingo Floatie"]="weapon-20.json",
 ["Flare Gun"]="weapon-13.json",
 ["Flashbang"]="weapon-14.json",
 ["Freeze Ray"]="weapon-15.json",
 ["Frostbite Bow"]="weapon-03.json",
 ["Frostbite Crossbow"]="weapon-06.json",
 ["Frozen Grenade"]="weapon-16.json",
 ["Garden Shovel"]="weapon-41.json",
 ["Gearnade Launcher"]="weapon-17.json",
 ["Giant Pencil"]="weapon-38.json",
 ["Gingerbread AUG"]="weapon-01.json",
 ["Gingerbread Handgun"]="weapon-19.json",
 ["Gingerbread Sniper"]="weapon-37.json",
 ["Glitterthrower"]="weapon-12.json",
 ["Glorious Assault Rifle"]="weapon-01.json",
 ["Glorious Battle Axe"]="weapon-02.json",
 ["Glorious Bow"]="weapon-03.json",
 ["Glorious Burst Rifle"]="weapon-04.json",
 ["Glorious Chainsaw"]="weapon-05.json",
 ["Glorious Crossbow"]="weapon-06.json",
 ["Glorious Daggers"]="weapon-07.json",
 ["Glorious Energy Pistols"]="weapon-08.json",
 ["Glorious Energy Rifle"]="weapon-09.json",
 ["Glorious Exogun"]="weapon-10.json",
 ["Glorious Fists"]="weapon-11.json",
 ["Glorious Flamethrower"]="weapon-12.json",
 ["Glorious Flare Gun"]="weapon-13.json",
 ["Glorious Flashbang"]="weapon-14.json",
 ["Glorious Freeze Ray"]="weapon-15.json",
 ["Glorious Grenade"]="weapon-16.json",
 ["Glorious Grenade Launcher"]="weapon-17.json",
 ["Glorious Gunblade"]="weapon-18.json",
 ["Glorious Handgun"]="weapon-19.json",
 ["Glorious Jump Pad"]="weapon-20.json",
 ["Glorious Katana"]="weapon-21.json",
 ["Glorious Knife"]="weapon-22.json",
 ["Glorious Maul"]="weapon-23.json",
 ["Glorious Medkit"]="weapon-24.json",
 ["Glorious Minigun"]="weapon-25.json",
 ["Glorious Molotov"]="weapon-26.json",
 ["Glorious Paintball Gun"]="weapon-27.json",
 ["Glorious RPG"]="weapon-30.json",
 ["Glorious Revolver"]="weapon-28.json",
 ["Glorious Riot Shield"]="weapon-29.json",
 ["Glorious Satchel"]="weapon-31.json",
 ["Glorious Scythe"]="weapon-32.json",
 ["Glorious Shorty"]="weapon-33.json",
 ["Glorious Shotgun"]="weapon-34.json",
 ["Glorious Slingshot"]="weapon-35.json",
 ["Glorious Smoke Grenade"]="weapon-36.json",
 ["Glorious Sniper"]="weapon-37.json",
 ["Glorious Spear"]="weapon-38.json",
 ["Glorious Spray"]="weapon-39.json",
 ["Glorious Subspace Tripmine"]="weapon-40.json",
 ["Glorious Trowel"]="weapon-41.json",
 ["Glorious Uzi"]="weapon-42.json",
 ["Glorious War Horn"]="weapon-43.json",
 ["Glorious Warpstone"]="weapon-44.json",
 ["Goalpost"]="weapon-35.json",
 ["Grenade"]="weapon-16.json",
 ["Grenade Launcher"]="weapon-17.json",
 ["Gum Ray"]="weapon-15.json",
 ["Gumball Handgun"]="weapon-19.json",
 ["Gunblade"]="weapon-18.json",
 ["Gunsaw"]="weapon-18.json",
 ["Hacker Pistols"]="weapon-08.json",
 ["Hacker Rifle"]="weapon-09.json",
 ["Handgun"]="weapon-19.json",
 ["Handsaws"]="weapon-05.json",
 ["Harp"]="weapon-35.json",
 ["Harpoon Crossbow"]="weapon-06.json",
 ["Hazard Sign"]="weapon-40.json",
 ["Hot Coals"]="weapon-26.json",
 ["Hourglass"]="weapon-36.json",
 ["Hydro Pistols"]="weapon-08.json",
 ["Hydro Rifle"]="weapon-09.json",
 ["Hyper Gunblade"]="weapon-18.json",
 ["Hyper Shotgun"]="weapon-34.json",
 ["Hyper Sniper"]="weapon-37.json",
 ["Hyperlaser Guns"]="weapon-08.json",
 ["Ice Cream"]="weapon-24.json",
 ["Ice Maul"]="weapon-23.json",
 ["Jack O'Thrower"]="weapon-12.json",
 ["Jingle Grenade"]="weapon-16.json",
 ["Jolly Man"]="weapon-20.json",
 ["Jump Pad"]="weapon-20.json",
 ["Karambit"]="weapon-22.json",
 ["Katana"]="weapon-21.json",
 ["Ketchup Gun"]="weapon-27.json",
 ["Key Bow"]="weapon-03.json",
 ["Key Spray"]="weapon-39.json",
 ["Keylisong"]="weapon-22.json",
 ["Keynade"]="weapon-16.json",
 ["Keynais"]="weapon-07.json",
 ["Keyper"]="weapon-37.json",
 ["Keyrambit"]="weapon-22.json",
 ["Keyshot"]="weapon-35.json",
 ["Keyst Rifle"]="weapon-04.json",
 ["Keytana"]="weapon-21.json",
 ["Keythe"]="weapon-32.json",
 ["Keythrower"]="weapon-12.json",
 ["Keyttle Axe"]="weapon-02.json",
 ["Keyzi"]="weapon-42.json",
 ["Knife"]="weapon-22.json",
 ["Lamethrower"]="weapon-12.json",
 ["Laptop"]="weapon-24.json",
 ["Lasergun 3000"]="weapon-25.json",
 ["Lava Lamp"]="weapon-26.json",
 ["Lifeguard Satchel"]="weapon-31.json",
 ["Lifeguard Whistle"]="weapon-43.json",
 ["Lightbulb"]="weapon-14.json",
 ["Lightning Bolt"]="weapon-21.json",
 ["Linked Sword"]="weapon-21.json",
 ["Lovely Shorty"]="weapon-33.json",
 ["Lovely Spray"]="weapon-39.json",
 ["Lucky Horseshoe"]="weapon-35.json",
 ["Machete"]="weapon-22.json",
 ["Mammoth Horn"]="weapon-43.json",
 ["Masterpiece"]="weapon-29.json",
 ["Maul"]="weapon-23.json",
 ["Medkit"]="weapon-24.json",
 ["Medkitty"]="weapon-24.json",
 ["Megaphone"]="weapon-43.json",
 ["Midnight Festive Exogun"]="weapon-10.json",
 ["Milk & Cookies"]="weapon-24.json",
 ["Mimic Axe"]="weapon-02.json",
 ["Minigun"]="weapon-25.json",
 ["Molotov"]="weapon-26.json",
 ["Money Gun"]="weapon-42.json",
 ["Nail Gun"]="weapon-39.json",
 ["New Year Energy Pistols"]="weapon-08.json",
 ["New Year Energy Rifle"]="weapon-09.json",
 ["New Year Katana"]="weapon-21.json",
 ["Nordic Axe"]="weapon-02.json",
 ["Not So Shorty"]="weapon-33.json",
 ["Notebook Satchel"]="weapon-31.json",
 ["Nuke Launcher"]="weapon-30.json",
 ["Paintball Gun"]="weapon-27.json",
 ["Paintballoon Gun"]="weapon-27.json",
 ["Paintbrush"]="weapon-41.json",
 ["Palmshot"]="weapon-35.json",
 ["Paper Planes"]="weapon-07.json",
 ["Pearl Rifle"]="weapon-01.json",
 ["Pencil"]="weapon-22.json",
 ["Pencil Launcher"]="weapon-30.json",
 ["Peppergun"]="weapon-28.json",
 ["Peppermint Sheriff"]="weapon-28.json",
 ["Phoenix Rifle"]="weapon-01.json",
 ["Pine Burst"]="weapon-04.json",
 ["Pine Spray"]="weapon-39.json",
 ["Pine Uzi"]="weapon-42.json",
 ["Pirate Hook"]="weapon-22.json",
 ["Pixel Burst"]="weapon-04.json",
 ["Pixel Crossbow"]="weapon-06.json",
 ["Pixel Flamethrower"]="weapon-12.json",
 ["Pixel Flashbang"]="weapon-14.json",
 ["Pixel Handgun"]="weapon-19.json",
 ["Pixel Katana"]="weapon-21.json",
 ["Pixel Minigun"]="weapon-25.json",
 ["Pixel Sniper"]="weapon-37.json",
 ["Plastic Shovel"]="weapon-41.json",
 ["Pot o' Keys"]="weapon-40.json",
 ["Potion Satchel"]="weapon-31.json",
 ["Pumpkin Carver"]="weapon-41.json",
 ["Pumpkin Claws"]="weapon-11.json",
 ["Pumpkin Handgun"]="weapon-19.json",
 ["Pumpkin Launcher"]="weapon-30.json",
 ["Pumpkin Minigun"]="weapon-25.json",
 ["RPG"]="weapon-30.json",
 ["RPKEY"]="weapon-30.json",
 ["Rainbowthrower"]="weapon-12.json",
 ["Raven Bow"]="weapon-03.json",
 ["Ray Gun"]="weapon-10.json",
 ["Reindeer Slingshot"]="weapon-35.json",
 ["Repulsor"]="weapon-10.json",
 ["Revolver"]="weapon-28.json",
 ["Rocket Launcher"]="weapon-30.json",
 ["Saber"]="weapon-21.json",
 ["Sakura Scythe"]="weapon-32.json",
 ["Sandwich"]="weapon-24.json",
 ["Scythe"]="weapon-32.json",
 ["Scythe of Death"]="weapon-32.json",
 ["Shady Chicken Sandwich"]="weapon-20.json",
 ["Sheriff"]="weapon-28.json",
 ["Shining Star"]="weapon-14.json",
 ["Shorty"]="weapon-33.json",
 ["Shotgun"]="weapon-34.json",
 ["Shurikens"]="weapon-07.json",
 ["Singularity"]="weapon-10.json",
 ["Skull Launcher"]="weapon-17.json",
 ["Skullbang"]="weapon-14.json",
 ["Sled"]="weapon-29.json",
 ["Sleigh Maul"]="weapon-23.json",
 ["Slime Gun"]="weapon-27.json",
 ["Slingshot"]="weapon-35.json",
 ["Sniper"]="weapon-37.json",
 ["Snow Shovel"]="weapon-41.json",
 ["Snowball Gun"]="weapon-27.json",
 ["Snowball Launcher"]="weapon-17.json",
 ["Snowblower"]="weapon-12.json",
 ["Snowglobe"]="weapon-36.json",
 ["Soul Grenade"]="weapon-16.json",
 ["Soul Pistols"]="weapon-08.json",
 ["Soul Rifle"]="weapon-09.json",
 ["Spaceship Launcher"]="weapon-30.json",
 ["Spear"]="weapon-38.json",
 ["Spectral Burst"]="weapon-04.json",
 ["Spider Web"]="weapon-20.json",
 ["Spray Bottle"]="weapon-39.json",
 ["Spring"]="weapon-40.json",
 ["Spy Gloves"]="weapon-11.json",
 ["Squid Launcher"]="weapon-30.json",
 ["Stealth Handgun"]="weapon-19.json",
 ["Stellar Katana"]="weapon-21.json",
 ["Stick"]="weapon-35.json",
 ["Street Sign"]="weapon-02.json",
 ["Studio Light"]="weapon-38.json",
 ["Subspace Tripmine"]="weapon-40.json",
 ["Suspicious Gift"]="weapon-31.json",
 ["Swashbuckler"]="weapon-17.json",
 ["Teleport Disc"]="weapon-44.json",
 ["Temporal Ray"]="weapon-15.json",
 ["The Shred"]="weapon-02.json",
 ["Toaster"]="weapon-07.json",
 ["Tombstone Shield"]="weapon-29.json",
 ["Tommy Gun"]="weapon-01.json",
 ["Too Shorty"]="weapon-33.json",
 ["Torch"]="weapon-26.json",
 ["Towerstone Handgun"]="weapon-19.json",
 ["Trampoline"]="weapon-20.json",
 ["Trick or Treat"]="weapon-40.json",
 ["Trumpet"]="weapon-43.json",
 ["Unstable Warpstone"]="weapon-44.json",
 ["Uranium Launcher"]="weapon-17.json",
 ["Uzi"]="weapon-42.json",
 ["Vexed Candle"]="weapon-26.json",
 ["Vexed Flare Gun"]="weapon-13.json",
 ["Violin Crossbow"]="weapon-06.json",
 ["Void Pistols"]="weapon-08.json",
 ["Void Rifle"]="weapon-09.json",
 ["War Horn"]="weapon-43.json",
 ["Warp Handgun"]="weapon-19.json",
 ["Warpbone"]="weapon-44.json",
 ["Warpeye"]="weapon-44.json",
 ["Warpstar"]="weapon-44.json",
 ["Warpstone"]="weapon-44.json",
 ["Water Balloon"]="weapon-16.json",
 ["Water Uzi"]="weapon-42.json",
 ["Whoopee Cushion"]="weapon-16.json",
 ["Wondergun"]="weapon-10.json",
 ["Wrapped Flare Gun"]="weapon-13.json",
 ["Wrapped Freeze Ray"]="weapon-15.json",
 ["Wrapped Minigun"]="weapon-25.json",
 ["Wrapped Shorty"]="weapon-33.json",
 ["Wrapped Shotgun"]="weapon-34.json",
}

-- Retained scene: stationary frames do not write Drawing properties.
state.visible,state.category,state.page=true,"Primary",1
state.x,state.y,state.w,state.h=80,70,980,660
state.drawings,state.hitboxes={},{}
state.dropdown,state.dropdownPage=nil,1
state.dirty=true
state.encodedPacks,state.previewFrames={},{}
state.animate=true
state.previewName="Assault Rifle"
state.imageCache,state.imageQueue,state.imageQueued={},{},{}
local mouse=game:GetService("Players").LocalPlayer:GetMouse()
local rgb=Color3.fromRGB
local P={bg=rgb(24,25,35),panel=rgb(32,34,46),row=rgb(35,37,50),field=rgb(43,46,64),border=rgb(47,49,64),accent=rgb(166,180,227),text=rgb(227,230,241),muted=rgb(166,172,199),faint=rgb(112,121,157),white=rgb(255,255,255)}
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
local BASE64_VALUES={}
do
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i=1,#alphabet do BASE64_VALUES[alphabet:byte(i)]=i-1 end
end
local function decode64(source)
    local out={}
    for i=1,#source,4 do
        local a,b,c,d=source:byte(i,i+3)
        local v=(BASE64_VALUES[a] or 0)*262144+(BASE64_VALUES[b] or 0)*4096+(BASE64_VALUES[c] or 0)*64+(BASE64_VALUES[d] or 0)
        out[#out+1]=string.char(math.floor(v/65536)%256)
        if c and c~=61 then out[#out+1]=string.char(math.floor(v/256)%256) end
        if d and d~=61 then out[#out+1]=string.char(v%256) end
    end
    return table.concat(out)
end
local function getImage(name)
    local pack=ICON_PACKS[name]
    if state.imageCache[name] and not (state.previewName==name and pack and not state.encodedPacks[pack]) then return state.imageCache[name] end
    if pack and not state.imageQueued[pack] then state.imageQueued[pack]=true;table.insert(state.imageQueue,pack) end
    return state.imageCache[name]
end
local function icon(name,x,y,size,z)
    local data=getImage(name)
    if data then draw("Image",x,y,{Data=data,Size=Vector2.new(size,size),Color=P.white,Transparency=1,ZIndex=z or 14})
    else text("-",x+size/2-3,y+size/2-8,P.faint,12,z or 14) end
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
local function motionGhost(show)
    if not show then
        for _,item in ipairs(state.ghost or {}) do assign(item,"Visible",false) end
        return
    end
    if not state.ghost then
        state.ghost={
            {object=Drawing.new("Square"),cache={}},
            {object=Drawing.new("Square"),cache={}},
            {object=Drawing.new("Text"),cache={}}
        }
        assign(state.ghost[1],"Filled",false);assign(state.ghost[1],"Color",P.accent)
        assign(state.ghost[2],"Filled",true);assign(state.ghost[2],"Color",P.panel)
        assign(state.ghost[3],"Text","Rivals / Appearance");assign(state.ghost[3],"Color",P.text)
        pcall(function() state.ghost[3].object.Size=13 end)
        for _,item in ipairs(state.ghost) do assign(item,"ZIndex",80);assign(item,"Transparency",1) end
    end
    local x,y=state.x,state.y
    assign(state.ghost[1],"Position",Vector2.new(x,y));assign(state.ghost[1],"Size",Vector2.new(state.w,state.h))
    assign(state.ghost[2],"Position",Vector2.new(x+1,y+1));assign(state.ghost[2],"Size",Vector2.new(state.w-2,36))
    assign(state.ghost[3],"Position",Vector2.new(x+14,y+12))
    for _,item in ipairs(state.ghost) do assign(item,"Visible",true) end
end

local function rounded(x,y,w,h,color,r,z)
    r=r or 8; z=z or 11
    rect(x+r,y,w-2*r,h,color,z);rect(x,y+r,w,h-2*r,color,z)
    for _,c in ipairs({{x+r,y+r},{x+w-r,y+r},{x+r,y+h-r},{x+w-r,y+h-r}}) do
        draw("Circle",c[1],c[2],{Radius=r,Color=color,Filled=true,Transparency=1,NumSides=14,ZIndex=z})
    end
end
local function render()
    poolIndex=0;state.hitboxes={};state.previewItem=nil
    local w,h=state.w,state.h
    rounded(4,6,w,h,rgb(8,9,14),12,8);rounded(0,0,w,h,P.bg,12,9)
    rect(0,44,w,1,P.border,10)
    text("Rivals",20,14,P.text,15);text("Appearance",74,16,P.muted,12)
    rounded(162,12,66,22,P.field,10,11);text("STUDIO",174,17,P.muted,9)
    button("hide","_",w-78,10,28,25,function() state.visible=false;state.dropdown=nil end)
    button("close","X",w-42,10,28,25,function() request("close") end)
    for i,category in ipairs(CATEGORIES) do
        local chosen=category;local tx=20+(i-1)*112
        if state.category==category then rounded(tx,58,103,30,P.field,14,11) end
        text(category,tx+14,67,state.category==category and P.text or P.faint,12)
        hit("category:"..category,tx,58,103,30,function() state.category=chosen;state.page=1;state.dropdown=nil;mark() end)
    end
    local previewW=250;local right=w-previewW-18;local left=18;local contentW=right-left-12
    rounded(left,102,contentW,h-191,P.panel,9,11)
    text("Weapons",left+15,118,P.text,13)
    local _,count=configText();text(count.." selected",left+contentW-91,119,P.muted,11)
    rect(left+12,145,contentW-24,1,P.border,12)
    local list=filtered();local rows=math.max(3,math.floor((h-289)/49));local pages=math.max(1,math.ceil(#list/rows));state.page=math.min(state.page,pages)
    for row=1,rows do
        local weapon=list[(state.page-1)*rows+row]
        if weapon then
            local ry=155+(row-1)*49;local skin=state.selections[weapon.name]
            icon(skin=="Default" and weapon.name or skin,left+12,ry+2,36)
            local nameW=math.floor(contentW*.42)-48
            text(short(weapon.name,math.max(10,math.floor(nameW/6))),left+55,ry+13,P.muted,12)
            hit("preview:"..weapon.name,left+6,ry,math.floor(contentW*.43),40,function() state.previewWeapon=weapon;state.previewName=skin=="Default" and weapon.name or skin;mark() end)
            local bx=left+math.floor(contentW*.45);local bw=contentW-(bx-left)-14
            button("weapon:"..weapon.name,short(skin,math.max(12,math.floor((bw-33)/6))).."  v",bx,ry+6,bw,30,function()
                state.previewWeapon=weapon;state.previewName=skin=="Default" and weapon.name or skin
                state.dropdown=weapon;state.dropdownPage=math.floor((validSkin(weapon,skin) or 0)/7)+1;mark()
            end)
        end
    end
    local py=h-127
    button("previous","<",left+12,py,28,25,function() state.page=math.max(1,state.page-1);mark() end)
    text(state.page.." / "..pages,left+52,py+6,P.faint,11)
    button("next",">",left+98,py,28,25,function() state.page=math.min(pages,state.page+1);mark() end)
    button("auto",state.autoApply and "Auto-apply: on" or "Auto-apply: off",left+contentW-157,py,144,25,function() state.autoApply=not state.autoApply;mark() end)
    rounded(right,102,previewW,math.min(350,h-280),P.panel,9,11)
    text("Preview",right+16,118,P.text,13);text("2D",right+previewW-36,119,P.accent,11)
    rect(right+12,145,previewW-24,1,P.border,12)
    local name=state.previewName or "Assault Rifle"
    local data=getImage(name)
    if data then
        local frames=state.previewFrames[name];local frame=frames and frames[state.previewFrame or 1] or data
        draw("Image",right+35,158,{Data=frame,Size=Vector2.new(180,180),Color=P.white,Transparency=1,ZIndex=21})
        state.previewItem=state.drawings[poolIndex]
    else
        text(ICON_PACKS[name] and "Loading artwork..." or "Artwork unavailable",right+48,238,P.faint,12)
    end
    text(short(name,28),right+16,349,P.text,13)
    text("Rotating 2D image",right+16,374,P.faint,11)
    button("rotation",state.animate and "Pause rotation" or "Rotate image",right+16,402,previewW-32,28,function() state.animate=not state.animate;mark() end)
    rounded(right,466,previewW,math.max(42,h-555),P.panel,9,11)
    text("Right Shift to hide",right+16,480,P.muted,11)
    if h>625 then text("Drag a corner to resize",right+16,502,P.faint,11) end
    rect(18,h-76,w-36,1,P.border,12)
    button("apply",state.busy and "Applying..." or "Apply skins",18,h-60,132,32,function() state.enabled=true;request("apply");mark() end,true)
    button("reset","Reset",160,h-60,89,32,function() resetSelections();mark() end)
    text(short(state.status,math.floor((w-280)/6)),267,h-52,P.muted,11)
    text("Local appearance settings",20,h-18,P.faint,9)
    for _,c in ipairs({{0,0},{w-8,0},{0,h-8},{w-8,h-8}}) do rect(c[1],c[2],8,2,P.faint,18) end
    if state.dropdown then
        local weapon=state.dropdown;local dw=420;local dh=383;local dx=math.floor((w-dw)/2);local dy=math.floor((h-dh)/2)
        rounded(dx-3,dy-3,dw+6,dh+6,rgb(8,9,14),10,38);rounded(dx,dy,dw,dh,P.panel,9,39)
        text(weapon.name,dx+16,dy+15,P.text,14,42)
        button("dropdown-close","X",dx+dw-42,dy+9,28,25,function() state.dropdown=nil;mark() end,false,true)
        local pages=math.max(1,math.ceil(#weapon.skins/7))
        for row=1,7 do
            local index=(state.dropdownPage-1)*7+row;local skin=weapon.skins[index]
            if skin then
                local sy=dy+48+(row-1)*40;local selected=state.selections[weapon.name]==skin
                rounded(dx+10,sy,dw-20,35,selected and P.field or P.row,5,40)
                icon(skin=="Default" and weapon.name or skin,dx+17,sy+1,32,42)
                text(short(skin,41),dx+60,sy+11,selected and P.text or P.muted,12,42)
                hit("skin:"..index,dx+10,sy,dw-20,35,function()
                    selectSkin(weapon,index-1);state.previewWeapon=weapon;state.previewName=skin=="Default" and weapon.name or skin;state.dropdown=nil;mark()
                end,true)
            end
        end
        button("skins-previous","<",dx+12,dy+344,32,26,function() state.dropdownPage=math.max(1,state.dropdownPage-1);mark() end,false,true)
        text(state.dropdownPage.." / "..pages,dx+dw/2-15,dy+352,P.faint,11,42)
        button("skins-next",">",dx+dw-44,dy+344,32,26,function() state.dropdownPage=math.min(pages,state.dropdownPage+1);mark() end,false,true)
    end
    for i=poolIndex+1,#state.drawings do local item=state.drawings[i];item.used=false;assign(item,"Visible",false) end
    state.dirty=false;state.lastStatus=state.status;state.lastBusy=state.busy
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
    if x>=0 and x<state.w-94 and y>=0 and y<44 then state.drag={x=mx-state.x,y=my-state.y} end
end
local function resize(mx,my,vw,vh)
    local r=state.resize; local left,top,right,bottom=r.x,r.y,r.x+r.w,r.y+r.h; local dx,dy=mx-r.mx,my-r.my
    local minW,minH=math.min(850,vw),math.min(620,vh)
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
        task.wait(0.05);if not state.alive then break end
        local pack=table.remove(state.imageQueue,1)
        if pack then
            local ok,payload=pcall(function()
                return game:GetService("HttpService"):JSONDecode(game:HttpGet(ICON_BASE..pack))
            end)
            if not state.alive then break end
            if ok and type(payload)=="table" then
                state.encodedPacks[pack]=payload;table.insert(order,pack)
                for name,frames in pairs(payload) do
                    if type(frames)=="table" and type(frames[1])=="string" then state.imageCache[name]=decode64(frames[1]) end
                end
                if #order>8 then
                    local old=table.remove(order,1)
                    state.encodedPacks[old]=nil;state.imageQueued[old]=nil
                end
                mark()
            end
        end
        local name=state.previewName
        local encoded=name and ICON_PACKS[name] and state.encodedPacks[ICON_PACKS[name]]
        if encoded and encoded[name] and not state.previewFrames[name] then
            local frames={}
            for i,data in ipairs(encoded[name]) do frames[i]=decode64(data) end
            state.previewFrames={[name]=frames};state.previewFrame=1;mark()
        end
    end
end)

state.renderer=task.spawn(function()
    local wasDown,wasToggle=false,false
    local nextFrame=0
    while state.alive do
        task.wait(0.016);if not state.alive then break end
        local ok,err=pcall(function()
            local active=not isrbxactive or isrbxactive();local down,toggle=ismouse1pressed(),iskeypressed(0xA1)
            if active and toggle and not wasToggle then state.visible=not state.visible;state.dropdown=nil;state.drag=nil;state.resize=nil;mark() end
            captureInput(active and state.visible)
            if active and state.visible then
                local mx,my=mouse.X,mouse.Y
                if down and not wasDown then click(mx,my) end
                local view=workspace.CurrentCamera.ViewportSize
                if down and state.drag then
                    state.x=math.floor(math.max(0,math.min(mx-state.drag.x,math.max(0,view.X-state.w))))
                    state.y=math.floor(math.max(0,math.min(my-state.drag.y,math.max(0,view.Y-state.h))))
                elseif down and state.resize then resize(mx,my,view.X,view.Y)
                elseif not down and (state.drag or state.resize) then state.drag=nil;state.resize=nil;mark() end
                local moving=state.drag or state.resize
                if moving then showScene(false);motionGhost(true)
                else
                    motionGhost(false)
                    local hover=nil
                    for i=#state.hitboxes,1,-1 do local ht=state.hitboxes[i];if (not state.dropdown or ht.modal) and contains(ht,mx-state.x,my-state.y) then hover=ht.id;break end end
                    if hover~=state.hover then state.hover=hover;mark() end
                    if state.lastStatus~=state.status or state.lastBusy~=state.busy then mark() end
                    if state.dirty and state.visible then render() end
                    showScene(state.visible)
                    local now=tick()
                    local frames=state.previewFrames[state.previewName]
                    if state.animate and not state.dropdown and frames and state.previewItem and now>=nextFrame then
                        state.previewFrame=(state.previewFrame or 1)%#frames+1
                        assign(state.previewItem,"Data",frames[state.previewFrame])
                        nextFrame=now+0.125
                    end
                end
            else
                if state.drag or state.resize then state.drag=nil;state.resize=nil;mark() end
                motionGhost(false);showScene(false)
            end
            captureInput(active and state.visible)
            wasDown,wasToggle=down,toggle
        end)
        if not ok then state.Destroy();pcall(notify,"GUI stopped: "..tostring(err),"Rivals Skins",8);break end
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
