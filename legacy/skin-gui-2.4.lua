local UNAVAILABLE_WEAPONS = {RPG = "Unavailable: RPG skin rig compatibility issue."}
local UNAVAILABLE_SKINS = {
 ["Armature.001"]=true,
 ["Permafrost.rbxm"]=true,
 ["Beach Ball Launcher"]=true,
 ["Boogie Board"]=true,
 ["Harpoon"]=true,
 ["Ice Shaver"]=true,
 ["Inflatable Hammer"]=true,
 ["Laser Pistol"]=true,
 ["Lifeguard Board"]=true,
 ["Naginata"]=true,
 ["Paddle"]=true,
 ["Palm Tree"]=true,
 ["Pool Noodle"]=true,
 ["Popsicles"]=true,
 ["Riot Shield"]=true,
 ["Sand Shovel"]=true,
 ["Satchel"]=true,
 ["Shark"]=true,
 ["Ship In A Bottle"]=true,
 ["Smoke Grenade"]=true,
 ["Sol"]=true,
 ["Spray"]=true,
 ["Squid Flare"]=true,
 ["Squirt Gun"]=true,
 ["Squirt Pistol"]=true,
 ["Squirt Revolver"]=true,
 ["Starfish Warpstone"]=true,
 ["Summer Handgun"]=true,
 ["Sunburst Bow"]=true,
 ["Sunscreen Spray"]=true,
 ["Super Shorty"]=true,
 ["Super Soaker"]=true,
 ["Super Soaker Rifle"]=true,
 ["Super Soaker Uzi"]=true,
 ["Surfboard"]=true,

 ["Teddy Bear"]=true,
 ["Torpedo Launcher"]=true,
 ["Trowel"]=true,
 ["Umbrella"]=true,
 ["Umbrella Sniper"]=true,
 ["Water Blaster"]=true,
 ["Water Blaster 3000"]=true,
 ["Water Blaster Pistols"]=true,
 ["Water Cannon"]=true,
 ["Water Crossbow"]=true,
 ["Water Gun"]=true,
 ["Water Gunblade"]=true,
}

-- Concrete classes avoid depending on recursive superclass queries in Matcha.
local function findSkinPart(model, recursive)
    if not model then return nil end
    local class=model.ClassName
    if class=="MeshPart" or class=="Part" or class=="UnionOperation" or class=="WedgePart" or class=="CornerWedgePart" or class=="TrussPart" then return model end
    local ok,children=pcall(function() return model:GetChildren() end)
    if not ok or type(children)~="table" then return nil end
    for _,child in ipairs(children) do
        local c=child.ClassName
        if c=="MeshPart" or c=="Part" or c=="UnionOperation" or c=="WedgePart" or c=="CornerWedgePart" or c=="TrussPart" then return child end
    end
    if recursive then
        for _,child in ipairs(children) do
            local part=findSkinPart(child,true)
            if part then return part end
        end
    end
    return nil
end
local function usableSkinModel(model)
    return model and model.Address and model.Address~=0 and findSkinPart(model,true)~=nil
end

local CATALOG = {
 {name="Assault Rifle",category="Primary",skins={"Default","10B Visits","AK-47","AKEY-47","Augmented Rifle","Boneclaw Rifle","Drum Gun","Gingerbread Augmented Rifle","Glorious Assault Rifle","Pearl Rifle","Phoenix Rifle","AUG","Gingerbread AUG","Tommy Gun"}},
 {name="Battle Axe",category="Melee",skins={"Default","Balloon Axe","Ban Axe","Cerulean Axe","Glorious Battle Axe","Keyttle Axe","Mimic Axe","Nordic Axe","Street Sign","The Shred","Tiki Axe","Lifeguard Board"}},
 {name="Bow",category="Primary",skins={"Default","Balloon Bow","Bat Bow","Beloved Bow","Compound Bow","Dream Bow","Frostbite Bow","Glorious Bow","Key Bow","Palm Bow","Raven Bow","Sunburst Bow"}},
 {name="Burst Rifle",category="Primary",skins={"Default","Aqua Burst","Bullpup Burst","Electro Rifle","Glorious Burst Rifle","Keyst Rifle","Pine Burst","Pixel Burst","Sand Bullpup Burst","Spectral Burst","FAMAS","Water Blaster"}},
 {name="Chainsaw",category="Melee",skins={"Default","Blobsaw","Buzzsaw","Festive Buzzsaw","Glorious Chainsaw","Handsaws","Mega Drill","Sharksaw","Surfboard"}},
 {name="Crossbow",category="Primary",skins={"Default","Arch Crossbow","Campfire Crossbow","Crossbone","Frostbite Crossbow","Glorious Crossbow","Harpoon Crossbow","Pixel Crossbow","Violin Crossbow","Water Crossbow"}},
 {name="Daggers",category="Melee",skins={"Default","Aces","Bat Daggers","Broken Hearts","Cookies","Crystal Daggers","Glorious Daggers","Keynais","Paper Planes","Shurikens","Starfish","Toaster","Popsicles"}},
 {name="Distortion",category="Primary",skins={"Default","Bubble Distortion","Cyber Distortion","Electropunk Distortion","Experiment D15","Glorious Distortion","Magma Distortion","Plasma Distortion","Sleighstortion"}},
 {name="Energy Pistols",category="Secondary",skins={"Default","Apex Pistols","Enerkey Pistols","Glorious Energy Pistols","Hacker Pistols","Hydro Pistols","Hyperlaser Guns","New Year Energy Pistols","Sol Pistols","Soul Pistols","Void Pistols","Water Blaster Pistols"}},
 {name="Energy Rifle",category="Primary",skins={"Default","Apex Rifle","Enerkey Rifle","Glorious Energy Rifle","Hacker Rifle","Hydro Rifle","New Year Energy Rifle","Sol Rifle","Soul Rifle","Void Rifle","Super Soaker Rifle"}},
 {name="Exogun",category="Primary",skins={"Default","Exogourd","Glorious Exogun","Midnight Festive Exogun","Pearl Exogun","Ray Gun","Repulsor","Singularity","Wondergun","Laser Pistol"}},
 {name="Fists",category="Melee",skins={"Default","Boxing Gloves","Brass Knuckles","Crab Claws","Festive Fists","Fist","Fists of Hurt","Glorious Fists","Pirate Hook","Pumpkin Claws","Spy Gloves","Pool Noodle","Teddy Bear"}},
 {name="Flamethrower",category="Primary",skins={"Default","Bubblethrower","Extinguisher","Glitterthrower","Glorious Flamethrower","Jack O'Thrower","Keythrower","Lamethrower","Pixel Flamethrower","Rainbowthrower","Snowblower"}},
 {name="Flare Gun",category="Secondary",skins={"Default","Banana Flare","Dynamite Gun","Firework Gun","Glorious Flare Gun","Pocket Volcano","Vexed Flare Gun","Wrapped Flare Gun","Squid Flare"}},
 {name="Flashbang",category="Utility",skins={"Default","Camera","Disco Ball","Glorious Flashbang","Lightbulb","Pixel Flashbang","Shining Star","Skullbang","Sol"}},
 {name="Freeze Ray",category="Utility",skins={"Default","Bubble Ray","Cooler","Glorious Freeze Ray","Gum Ray","Spider Ray","Temporal Ray","Wrapped Freeze Ray","Ice Shaver"}},
 {name="Grappler",category="Utility",skins={"Default","Arcade Claw","Fishing Rod","Genie Lamp","Glorious Grappler","Lasso","Lifeguard Grappler"}},
 {name="Grenade",category="Utility",skins={"Default","Cuddle Bomb","Dynamite","Fizz Bomb","Frozen Grenade","Glorious Grenade","Jingle Grenade","Keynade","Soul Grenade","Water Balloon","Whoopee Cushion"}},
 {name="Grenade Launcher",category="Primary",skins={"Default","Balloon Launcher","Coconut Launcher","Gearnade Launcher","Glorious Grenade Launcher","Skull Launcher","Snowball Launcher","Swashbuckler","Uranium Launcher","Beach Ball Launcher"}},
 {name="Gunblade",category="Melee",skins={"Default","Boneblade","Crude Gunblade","Elf's Gunblade","Glorious Gunblade","Gunsaw","Hyper Gunblade","Keyblade","Sharkbite","Water Gunblade"}},
 {name="Handgun",category="Secondary",skins={"Default","Blaster","Gingerbread Handgun","Glorious Handgun","Gumball Handgun","Hand Gun","Pixel Handgun","Pumpkin Handgun","Sandgun","Stealth Handgun","Towerstone Handgun","Warp Handgun","Summer Handgun"}},
 {name="Jump Pad",category="Utility",skins={"Default","Bounce House","Flamingo Floatie","Glorious Jump Pad","Jolly Man","Shady Chicken Sandwich","Spider Web","Trampoline"}},
 {name="Katana",category="Melee",skins={"Default","Arch Katana","Crystal Katana","Cutlass","Evil Trident","Glorious Katana","Keytana","Lightning Bolt","Linked Sword","New Year Katana","Pixel Katana","Riptide Katana","Saber","Stellar Katana","Swordfish","Paddle","Umbrella"}},
 {name="Knife",category="Melee",skins={"Default","Armature.001","Balisong","Birthday Candle","Caladbolg","Candy Cane","Chancla","Glorious Knife","Karambit","Keylisong","Keyrambit","Machete","Pencil","Shark Tooth","Trophy Knife","Pirate Hook","Water Gun"}},
 {name="Maul",category="Melee",skins={"Default","Ban Hammer","Clown Hammer","Excalibur","Giant Popsicle","Glorious Maul","Ice Maul","Sleigh Maul","Starforge Maul","Inflatable Hammer"}},
 {name="Medkit",category="Utility",skins={"Default","Box of Chocolates","Briefcase","Bucket of Candy","Glorious Medkit","Ice Cream","Laptop","Medkitty","Milk & Cookies","Sandwich"}},
 {name="Minigun",category="Primary",skins={"Default","Fighter Jet","Glorious Minigun","Lasergun 3000","Pixel Minigun","Pumpkin Minigun","Shark Minigun","Wrapped Minigun","Shark"}},
 {name="Molotov",category="Utility",skins={"Default","Arch Molotov","Campfire Stick","Coffee","Glorious Molotov","Hot Coals","Lava Lamp","Ship In A Bottle","Torch","Vexed Candle"}},
 {name="Paintball Gun",category="Primary",skins={"Default","Boba Gun","Brain Gun","Glorious Paintball Gun","Ketchup Gun","Lemonade Gun","Paintballoon Gun","Slime Gun","Snowball Gun","Water Blaster 3000"}},
 {name="Permafrost",category="Primary",skins={"Default","Glorious Permafrost","Ice Permafrost","Permafrost.rbxm","Permasand","Snowman Permafrost","Starforge Permafrost","Temporal Permafrost"}},
 {name="RPG",category="Primary",skins={"Default","Cupcake Launcher","Firework Launcher","Glorious RPG","Nuke Launcher","Pencil Launcher","Pumpkin Launcher","Rocket Launcher","RPKEY","Spaceship Launcher","Squid Launcher","Sundae Launcher","Torpedo Launcher","Water Cannon"}},
 {name="Revolver",category="Secondary",skins={"Default","Boneclaw Revolver","Cruise Revolver","Desert Eagle","Glorious Revolver","Keyvolver","Peppergun","Peppermint Sheriff","Sheriff","Squirt Revolver"}},
 {name="Riot Shield",category="Utility",skins={"Default","Broken Surfboard","Door","Energy Shield","Glorious Riot Shield","Masterpiece","Sled","Tombstone Shield","Boogie Board"}},
 {name="Satchel",category="Utility",skins={"Default","Advanced Satchel","Bag o' Money","Glorious Satchel","Lifeguard Satchel","Notebook Satchel","Pizza Box","Potion Satchel","Suspicious Gift"}},
 {name="Scythe",category="Melee",skins={"Default","Anchor","Bat Scythe","Bug Net","Cryo Scythe","Crystal Scythe","Glorious Scythe","Keythe","Palm Scythe","Plastic Flamingo","Sakura Scythe","Scythe of Death","Naginata","Palm Tree"}},
 {name="Shorty",category="Secondary",skins={"Default","Balloon Shorty","Bubble Shorty","Cannon Shorty","Demon Shorty","Glorious Shorty","Lovely Shorty","Not So Shorty","Too Shorty","Wrapped Shorty","Squirt Pistol","Super Shorty"}},
 {name="Shotgun",category="Primary",skins={"Default","Balloon Shotgun","Broomstick","Cactus Shotgun","Glorious Shotgun","Hyper Shotgun","Shark Shotgun","Shotkey","Wrapped Shotgun","Super Soaker"}},
 {name="Slingshot",category="Secondary",skins={"Default","Boneshot","Glorious Slingshot","Goalpost","Harp","Keyshot","Lucky Horseshoe","Palmshot","Reindeer Slingshot","Stick"}},
 {name="Smoke Grenade",category="Utility",skins={"Default","Balance","Beach Ball","Emoji Cloud","Eyeball","Glorious Smoke Grenade","Hourglass","Snowglobe"}},
 {name="Sniper",category="Primary",skins={"Default","Campfire Sniper","Event Horizon","Eyething Sniper","Gingerbread Sniper","Glorious Sniper","Hyper Sniper","Keyper","Kraken Sniper","Light Fifty","Pixel Sniper","Squirt Gun","Umbrella Sniper"}},
 {name="Spear",category="Melee",skins={"Default","Chark Kebab","Fork","Giant Pencil","Glorious Spear","Plunger","Studio Light","Thunderpike","Harpoon"}},
 {name="Spray",category="Secondary",skins={"Default","Boneclaw Spray","Campfire Spray","Glorious Spray","Key Spray","Lovely Spray","Nail Gun","Pine Spray","Spray Bottle","Sunscreen Spray"}},
 {name="Subspace Tripmine",category="Utility",skins={"Default","Dev-in-the-Box","DIY Tripmine","Don't Press","Glorious Subspace Tripmine","Hazard Sign","Pot o' Keys","Spring","Trick or Treat"}},
 {name="Trowel",category="Utility",skins={"Default","Garden Shovel","Glorious Trowel","Paintbrush","Plastic Shovel","Pumpkin Carver","Scooper","Snow Shovel","Sand Shovel"}},
 {name="Uzi",category="Secondary",skins={"Default","Arch Uzi","Demon Uzi","Ducky Uzi","Electro Uzi","Glorious Uzi","Keyzi","Money Gun","Pine Uzi","Water Uzi","Super Soaker Uzi"}},
 {name="War Horn",category="Utility",skins={"Default","Air Horn","Boneclaw Horn","Glorious War Horn","Lifeguard Whistle","Mammoth Horn","Megaphone","Trumpet"}},
 {name="Warper",category="Secondary",skins={"Default","Arcane Warper","Bubbler","Electropunk Warper","Experiment W4","Frost Warper","Glitter Warper","Glorious Warper","Hotel Bell"}},
 {name="Warpstone",category="Utility",skins={"Default","Cyber Warpstone","Electropunk Warpstone","Glorious Warpstone","Teleport Disc","Unstable Warpstone","Warp Juice","Warpbone","Warpeye","Warpstar","Starfish Warpstone"}},
 {name="Wildcat",category="Primary",skins={"Default","Glorious Wildcat","Plasma Wildcat"}},
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

local scripts = LP:WaitForChild("PlayerScripts", 5)
local A = scripts and scripts:WaitForChild("Assets", 5)
local vm = A and A:WaitForChild("ViewModels", 5)
local wf = vm and vm:WaitForChild("Weapons", 5)

if not wf then
    pcall(notify, "Weapons folder not found.", "SC", 5)
    return
end
if _G.__RIVALS_SKIN_CHANGER_RUN_TOKEN ~= runToken then return end

local mrd, mwr, pcall, ipairs, pairs = memory_read, memory_write, pcall, ipairs, pairs

-- Compare the current hierarchy, not just whether an old wrapper still has a parent.
local originalGameAddress, originalPlayerAddress = game.Address, LP.Address
local originalWeaponsAddress = wf.Address
local function sessionValid()
    local ok, valid = pcall(function()
        if game.Address ~= originalGameAddress or not game:IsLoaded() then return false end
        local current = game:GetService("Players").LocalPlayer
        if not current or current.Address ~= originalPlayerAddress then return false end
        local ps = current:FindFirstChild("PlayerScripts")
        local assets = ps and ps:FindFirstChild("Assets")
        local models = assets and assets:FindFirstChild("ViewModels")
        local weapons = models and models:FindFirstChild("Weapons")
        return assets and assets.Address == A.Address and weapons and weapons.Address == wf.Address
    end)
    return ok and valid == true
end

local rd = function(a) 
    if not sessionValid() then return nil end
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
    if not _scriptAlive or not sessionValid() then return end
    if not savedMemory[a] then
        local ok, original = pcall(mrd, "uintptr_t", a)
        if not ok or original == nil then return end
        savedMemory[a] = true
        table.insert(undoActions, {address = a, value = original})
    end
    pcall(mwr, "uintptr_t", a, v)
end

local function setProperty(object, property, value)
    if not _scriptAlive or not sessionValid() then return end
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

local function fullCleanup(abandon)
    if cleanupFinished then return cleanupSucceeded end
    local restore = abandon ~= true and sessionValid()
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
    if restore then
    for _, track in ipairs(animationTracks) do
        pcall(function() track:Stop(0) end)
        pcall(function() track:Destroy() end)
    end
    for _, animation in ipairs(animationObjects) do
        pcall(function() animation:Destroy() end)
    end
    -- Undo in reverse order; never pass restoration writes through the recorder.
    for i = #undoActions, 1, -1 do
        if not sessionValid() then break end
        local entry = undoActions[i]
        if entry.address then
            local ok, result = pcall(mwr, "uintptr_t", entry.address, entry.value)
            if not ok or result == false then cleanupSucceeded = false end
        else
            -- A sound or effect may have been destroyed by the game already.
            pcall(function() entry.object[entry.property] = entry.value end)
        end
    end
    end -- Never touch old instances or memory when the asset hierarchy has changed.
    managedTasks, soundConnections, animationTracks, animationObjects = {}, {}, {}, {}
    undoActions, savedMemory, savedProperties = {}, {}, {}
    _G.__RIVALS_SKIN_CHANGER_ACTIVE = false
    return cleanupSucceeded
end

-- Register cleanup before any rig changes, event connections, or background tasks.
cleanupCurrentRun = fullCleanup
_G.__RIVALS_SKIN_CHANGER_RESTORE = fullCleanup
_G.__RIVALS_SKIN_CHANGER_ACTIVE = true

-- Best effort: Matcha may not expose this Roblox event. The hierarchy watchdog remains active.
pcall(function()
    local connection = LP.OnTeleport:Connect(function(teleportState)
        if tostring(teleportState):find("Failed", 1, true) then return end
        fullCleanup()
        local gui = _G.__RIVALS_SKIN_GUI
        if gui and gui.alive then
            if gui.BeginTransition then gui.BeginTransition(originalWeaponsAddress) end
        end
    end)
    table.insert(soundConnections, connection)
end)

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
                local firstPart = findSkinPart(sub, true)
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
            local p = findSkinPart(arrow, true)
            if p then pcall(function() setProperty(arrow, "PrimaryPart", p) end) end
        end
    end
end

-- Specialized RPG rig: ensures Rocket.Primary exists
local function fixRPGRig(skinModel)
    local rocket = skinModel:FindFirstChild("Rocket")
    if rocket and rocket.ClassName == "Model" then
        if not rocket:FindFirstChild("Primary") then
            local p = findSkinPart(rocket, true)
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
                local firstPart = findSkinPart(sub, true)
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
                local firstPart = findSkinPart(sub, true)
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
                local firstPart = findSkinPart(sub, true)
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
        pcall(function() setProperty(m, "PrimaryPart", findSkinPart(m, true)) end)
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
    if not _scriptAlive or not sessionValid() then return end
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

-- Adapted from upstream 2026-09-08; only exact Arch Katana eight-part wing layouts.
local katanaFrames
local function alignKatanaViewmodel(iv)
    if not katanaFrames then
        local ok,frames=pcall(function()
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


            return {KATANA_WINGS1_CFS,KATANA_WINGS2_CFS}
        end)
        if not ok then return end
        katanaFrames=frames
    end
    local body=iv:FindFirstChild("Body") or iv:FindFirstChild("Model")
    local primary=body and (body:FindFirstChild("Primary") or body:FindFirstChild("BodyPrimary"))
    if not primary then return end
    local wings={iv:FindFirstChild("Wings1"),iv:FindFirstChild("Wings2")}
    if not wings[1] or not wings[2] then return end
    local parts={}
    for side=1,2 do
        parts[side]={}
        for _,p in ipairs(wings[side]:GetChildren()) do
            if p.ClassName=="MeshPart" or p.ClassName=="Part" then table.insert(parts[side],p) end
        end
        if #parts[side]~=#katanaFrames[side] then return end
    end
    local base=primary.CFrame
    for side=1,2 do for i,p in ipairs(parts[side]) do setProperty(p,"CFrame",base*katanaFrames[side][i]) end end
end

spawnManaged(function()
    while _scriptAlive do
        task.wait(ACTIVE_CONFIG_SKINS["Katana"]=="Arch Katana" and .016 or .15)
        if not _scriptAlive then break end
        if ACTIVE_CONFIG_SKINS["Katana"]=="Arch Katana" then
            pcall(function()
                local v=workspace:FindFirstChild("ViewModels")
                local fp=v and v:FindFirstChild("FirstPerson")
                if fp then for _,model in ipairs(fp:GetChildren()) do
                    local name=model.Name:match("%-%s*(.-)%s*%-") or model.Name:match(LP.Name.."%s*%-%s*(.-)%s*$")
                    if name=="Katana" then local iv=model:FindFirstChild("ItemVisual");if iv then alignKatanaViewmodel(iv) end end
                end end
            end)
        end
    end
end)

-- Main skin swapper; reads weapon-to-skin mappings from the config file
local function applySkinSwapper()
    local r2 = configText
    local swappedCount = 0
    engineResult.skipped = {}
    local function skipped(weapon, skin, reason)
        table.insert(engineResult.skipped, weapon.." / "..skin..": "..reason)
    end

    for _, rawLine in ipairs(r2:split(string.char(10))) do 
        local l = rawLine:gsub(string.char(13), "")
        local q = l:find("=")
        if q then 
            local weaponName = l:sub(1, q - 1):match("^%s*(.-)%s*$")
            local skinTarget = l:sub(q + 1):match("^%s*(.-)%s*$")
            
            -- Only register configurations after a validated swap succeeds.
            
            -- Viewmodel 3D Model Memory Swapping (Symmetric Two-Way Swap)
            local defModel = wf:FindFirstChild(weaponName)
            local skinModel = findSkinModel(skinTarget)
            
            if not UNAVAILABLE_WEAPONS[weaponName] and not UNAVAILABLE_SKINS[skinTarget] and usableSkinModel(skinModel) and skinModel.Name == skinTarget and defModel and defModel.Address and defModel.Address ~= skinModel.Address then
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
                        
                        ACTIVE_CONFIG_SKINS[weaponName] = skinTarget
                        swappedCount = swappedCount + 1
                    else skipped(weaponName,skinTarget,"model swap location missing") end
                else skipped(weaponName,skinTarget,"skin folder missing") end
            else
                local reason="model not ready"
                if UNAVAILABLE_WEAPONS[weaponName] then reason="weapon skin rig disabled"
                elseif UNAVAILABLE_SKINS[skinTarget] then reason="catalog entry disabled"
                elseif not skinModel then reason="skin model not found"
                elseif skinModel.Name~=skinTarget then reason="skin name mismatch"
                elseif not usableSkinModel(skinModel) then reason="skin has no readable physical parts"
                elseif not defModel then reason="default weapon model not found" end
                skipped(weaponName,skinTarget,reason)
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
if #engineResult.skipped>0 then
    for _,reason in ipairs(engineResult.skipped) do print("[RivalsSkinChanger] Skipped "..reason) end
    pcall(notify,engineResult.skipped[1],"Skin apply details",8)
end
pcall(notify, msg, "Rivals Skin Changer", 4)
print("[RivalsSkinChanger] " .. msg)

-- Periodic watchdog: checks every 0.15 seconds and invokes cleanup when a listed condition is detected.
spawnManaged(function()
    while _scriptAlive do
        task.wait(0.15)
        if not _scriptAlive then break end
        if not sessionValid() then
            fullCleanup(true)
            local gui = _G.__RIVALS_SKIN_GUI
            if gui and gui.alive and gui.BeginTransition then gui.BeginTransition(originalWeaponsAddress) end
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

local DEFAULT_SETTINGS={autoApply=true,rememberSelections=true,rememberWindow=true,startMinimized=false,confirmReset=false,scale=1,animations=true,animationSpeed=1,reduceMotion=false,compact=false,rotation=true,rotationSpeed=1,theme="Dark",accent="Periwinkle",opacity=1,radius=9,hotkey=161,lowPower=false,effects=true}
local SETTINGS,FAVORITES,SAVED={},{},{}
for k,v in pairs(DEFAULT_SETTINGS) do SETTINGS[k]=v end
local function readClientData()
    if not readfile or not isfile then return end
    local ok,data=pcall(function()
        if isfile("rivals_skin_changer_settings.json") then return game:GetService("HttpService"):JSONDecode(readfile("rivals_skin_changer_settings.json")) end
    end)
    if ok and type(data)=="table" then
        SAVED=data
        for k,v in pairs(data.settings or {}) do if DEFAULT_SETTINGS[k]~=nil and type(v)==type(DEFAULT_SETTINGS[k]) then SETTINGS[k]=v end end
        if type(data.favorites)=="table" then for k,v in pairs(data.favorites) do if type(k)=="string" and v==true then FAVORITES[k]=true end end end
    end
    SETTINGS.scale=math.max(0.8,math.min(1.2,SETTINGS.scale))
    SETTINGS.opacity=math.max(0.75,math.min(1,SETTINGS.opacity))
    SETTINGS.radius=math.max(0,math.min(12,SETTINGS.radius))
    SETTINGS.animationSpeed=math.max(0.5,math.min(2,SETTINGS.animationSpeed))
    SETTINGS.rotationSpeed=math.max(0.25,math.min(2,SETTINGS.rotationSpeed))
end
readClientData()

-- Standalone floating GUI, rendered directly through Matcha's Drawing API.
local CATEGORIES = {"Primary", "Secondary", "Melee", "Utility"}
if not Drawing or type(Drawing.new) ~= "function" or not ismouse1pressed or not iskeypressed then
    pcall(notify, "This GUI needs Drawing.new and Matcha mouse/key input APIs.", "Rivals Skin Changer", 8)
    return
end
if not game or game.GameId ~= 6035872082 then
    pcall(notify, "Open RIVALS before loading this menu.", "Rivals Skin Changer", 6)
    return
end

local old = _G.__RIVALS_SKIN_GUI
if old and type(old.Destroy) == "function" then
    local ok, restored = pcall(old.Destroy)
    if not ok or restored == false then
        pcall(notify, "Previous cleanup failed; rejoin before loading the GUI.", "Rivals Skin Changer", 8)
        return
    end
end

local state = {
    alive = true, enabled = false, busy = false, autoApply = SETTINGS.autoApply,
    version = 0, pending = nil, status = "Auto-apply is on. Choose a skin to apply it.",
    selections = {}, suppressChanges = false
}
state.unavailable = {}
for _, weapon in ipairs(CATALOG) do
    for _, skin in ipairs(weapon.skins) do
        if skin ~= "Default" then
            if UNAVAILABLE_WEAPONS[weapon.name] then state.unavailable[skin] = UNAVAILABLE_WEAPONS[weapon.name]
            elseif UNAVAILABLE_SKINS[skin] then state.unavailable[skin] = "Unavailable: catalog entry not ready." end
        end
    end
end
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
        if weapon and validSkin(weapon, skin) ~= nil and not state.unavailable[skin] then state.selections[name] = skin end
    end
end

if not SETTINGS.rememberSelections then
    -- Start with defaults when remembering is disabled.
elseif type(SAVED.selections)=="table" then
    importSelections(SAVED.selections)
elseif type(_G.__RIVALS_SKIN_GUI_SELECTIONS) == "table" then
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
        if skin and skin ~= "Default" and not state.unavailable[skin] then table.insert(lines, weapon.name .. "=" .. skin) end
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
    if state.Save then state.Save() end
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
    if not skin then return end
    if state.unavailable[skin] then state.status=state.unavailable[skin];return end
    if state.selections[weapon.name] == skin and skin ~= "Default" then return end
    state.selections[weapon.name] = skin
    if skin == "Default" or state.autoApply then
        state.enabled = true
        request("apply")
    else
        state.status = "Selection changed. Click Apply skins."
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

-- The existing worker owns resumption; no second apply loop or script instance.
function state.BeginTransition(oldRoot)
    if not state.alive then return end
    if state.resume then return end
    state.pending = nil
    state.resume = {oldRoot=oldRoot, sawGap=false}
    state.status = "Waiting for next match assets..."
end

local function readyRoot()
    local ok, key = pcall(function()
        if not game:IsLoaded() or game.GameId ~= 6035872082 then return nil end
        local player = game:GetService("Players").LocalPlayer
        local scripts = player and player:FindFirstChild("PlayerScripts")
        local assets = scripts and scripts:FindFirstChild("Assets")
        local models = assets and assets:FindFirstChild("ViewModels")
        local weapons = models and models:FindFirstChild("Weapons")
        if not weapons or not weapons.Address then return nil end
        local children = weapons:GetChildren()
        if #children == 0 then return nil end
        -- Include membership so gradual asset loading restarts the settling timer.
        local ids = {}
        for _, child in ipairs(children) do table.insert(ids,tostring(child.Address)) end
        table.sort(ids)
        return tostring(weapons.Address)..":"..table.concat(ids,",")
    end)
    return ok and key or nil
end

local function pollResume()
    if not state.alive or state.busy then return end
    local key = readyRoot()
    local root = key and key:match("^([^:]+):")
    -- Observe the hierarchy ourselves; external runtimes may not expose OnTeleport.
    if not state.resume then
        if state.observedRoot and root ~= state.observedRoot then
            state.BeginTransition(state.observedRoot)
            if not stopEngine() then
                state.resume=nil;state.observedRoot=nil
                state.status="Cleanup failed. Rejoin before applying again."
                return
            end
        elseif not state.observedRoot and root then
            state.observedRoot=root
        end
    end
    local resume = state.resume
    if not resume then return end
    if not key then resume.sawGap=true;resume.key=nil;return end
    if root == tostring(resume.oldRoot) and not resume.sawGap then return end
    if resume.key ~= key then resume.key=key;resume.readyAt=tick();return end
    if tick()-resume.readyAt < 2 then return end
    state.resume=nil
    state.observedRoot=root
    if state.autoApply then
        local _, count = configText()
        if count>0 then request("apply");state.status="Match ready. Reapplying selected skins..." end
    else state.status="Match ready. Auto apply is off." end
end

local ICON_URLS = {
["Assault Rifle"]="https://tr.rbxcdn.com/180DAY-092e1e800488327ff1373cde65a1b135/150/150/Image/Png/noFilter",
["10B Visits"]="https://tr.rbxcdn.com/180DAY-2c07c55f06fae3e58dd20ce3f9209be5/150/150/Image/Png/noFilter",
["AK-47"]="https://tr.rbxcdn.com/180DAY-21096ba1852b2bc7c00ee2bf4812e16a/150/150/Image/Png/noFilter",
["AKEY-47"]="https://tr.rbxcdn.com/180DAY-902bf65cffc2f56b924e29ce133eccd2/150/150/Image/Png/noFilter",
["Augmented Rifle"]="https://tr.rbxcdn.com/180DAY-48f7f286c79bf8142c086f3a72e055a8/150/150/Image/Png/noFilter",
["Boneclaw Rifle"]="https://tr.rbxcdn.com/180DAY-abc3972a941dd84bfd0f4ce230b891c3/150/150/Image/Png/noFilter",
["Drum Gun"]="https://tr.rbxcdn.com/180DAY-44a35dedc05d9cc8d4739a1306c6c56b/150/150/Image/Png/noFilter",
["Gingerbread Augmented Rifle"]="https://tr.rbxcdn.com/180DAY-565a85ee5b6e572c259711c17af197cd/150/150/Image/Png/noFilter",
["Glorious Assault Rifle"]="https://tr.rbxcdn.com/180DAY-83fdb4c7a0ec8a285f1c403f575924e8/150/150/Image/Png/noFilter",
["Pearl Rifle"]="https://tr.rbxcdn.com/180DAY-5ff4b8e4d52e064e47198ceccb359934/150/150/Image/Png/noFilter",
["Phoenix Rifle"]="https://tr.rbxcdn.com/180DAY-a4d6fe27332d9e8390a89e017fc84859/150/150/Image/Png/noFilter",
["Battle Axe"]="https://tr.rbxcdn.com/180DAY-bbbf587c8f347865ed0a737c13bc38c7/150/150/Image/Png/noFilter",
["Balloon Axe"]="https://tr.rbxcdn.com/180DAY-4ce52be8b85d61aa27393ae4b68dbb00/150/150/Image/Png/noFilter",
["Ban Axe"]="https://tr.rbxcdn.com/180DAY-903eca9d25c8e0421b452bf66483f483/150/150/Image/Png/noFilter",
["Cerulean Axe"]="https://tr.rbxcdn.com/180DAY-dfa88df5911b1ddcdd2dae428079650f/150/150/Image/Png/noFilter",
["Glorious Battle Axe"]="https://tr.rbxcdn.com/180DAY-6c48b2600941fd86d9365322746e75af/150/150/Image/Png/noFilter",
["Keyttle Axe"]="https://tr.rbxcdn.com/180DAY-5a33b8ff5fdaf021d638822dae4bacd0/150/150/Image/Png/noFilter",
["Mimic Axe"]="https://tr.rbxcdn.com/180DAY-f51cae749bbf4eb96899503561364e41/150/150/Image/Png/noFilter",
["Nordic Axe"]="https://tr.rbxcdn.com/180DAY-dc664715cfc1f1f0b3a13d855071d9a7/150/150/Image/Png/noFilter",
["Street Sign"]="https://tr.rbxcdn.com/180DAY-6423b827ac50ab9956f225031354bced/150/150/Image/Png/noFilter",
["The Shred"]="https://tr.rbxcdn.com/180DAY-b2dc1c85f670168fb5619310fe5b5cc6/150/150/Image/Png/noFilter",
["Tiki Axe"]="https://tr.rbxcdn.com/180DAY-e0169c0eb520464be748793d9dc44784/150/150/Image/Png/noFilter",
["Bow"]="https://tr.rbxcdn.com/180DAY-72acd83d9c048998dffb828a517cbe74/150/150/Image/Png/noFilter",
["Balloon Bow"]="https://tr.rbxcdn.com/180DAY-da92a2d96dbaffc75213fe495824dfb1/150/150/Image/Png/noFilter",
["Bat Bow"]="https://tr.rbxcdn.com/180DAY-0811543913ed939c64ebbe09ad22ea5b/150/150/Image/Png/noFilter",
["Beloved Bow"]="https://tr.rbxcdn.com/180DAY-ece007e94825cbf44426d67d7ed4c8d8/150/150/Image/Png/noFilter",
["Compound Bow"]="https://tr.rbxcdn.com/180DAY-d18be62ddd598d9135ff9789302a43c5/150/150/Image/Png/noFilter",
["Dream Bow"]="https://tr.rbxcdn.com/180DAY-bc9bece55a2102c508926e77a0b9f915/150/150/Image/Png/noFilter",
["Frostbite Bow"]="https://tr.rbxcdn.com/180DAY-9ebbc6553ebae7baa9f087a1a4a776a4/150/150/Image/Png/noFilter",
["Glorious Bow"]="https://tr.rbxcdn.com/180DAY-3f4a3e4bf414ce3294d5b60b8e522c46/150/150/Image/Png/noFilter",
["Key Bow"]="https://tr.rbxcdn.com/180DAY-d50046a342bc5b20d79c381d34a8704d/150/150/Image/Png/noFilter",
["Palm Bow"]="https://tr.rbxcdn.com/180DAY-db7797abfaf1594ed08f0d10efcb2cc0/150/150/Image/Png/noFilter",
["Raven Bow"]="https://tr.rbxcdn.com/180DAY-036bcd2a91fc54bffff6fd73b9b9387c/150/150/Image/Png/noFilter",
["Burst Rifle"]="https://tr.rbxcdn.com/180DAY-f894e395896ec10595ae85e21c8c938d/150/150/Image/Png/noFilter",
["Aqua Burst"]="https://tr.rbxcdn.com/180DAY-7cdf0da026b3baa065767d6eb3be8533/150/150/Image/Png/noFilter",
["Bullpup Burst"]="https://tr.rbxcdn.com/180DAY-6dac8c83ddc4bd3e2e4a944d0e14aa75/150/150/Image/Png/noFilter",
["Electro Rifle"]="https://tr.rbxcdn.com/180DAY-acb2aa38dfe8a9c37f868bc4d13d31ae/150/150/Image/Png/noFilter",
["Glorious Burst Rifle"]="https://tr.rbxcdn.com/180DAY-1208d5c0ae61624c96d89fc514e557d0/150/150/Image/Png/noFilter",
["Keyst Rifle"]="https://tr.rbxcdn.com/180DAY-9d90f8736ab082a8bbcba5004e5df3c6/150/150/Image/Png/noFilter",
["Pine Burst"]="https://tr.rbxcdn.com/180DAY-77f2ebfaeafbb5f1c7d660ab0b85e155/150/150/Image/Png/noFilter",
["Pixel Burst"]="https://tr.rbxcdn.com/180DAY-e8c3ba193004c5b68822f67acb8b895b/150/150/Image/Png/noFilter",
["Sand Bullpup Burst"]="https://tr.rbxcdn.com/180DAY-9818c07af753a0a5d4909fc111aa0a31/150/150/Image/Png/noFilter",
["Spectral Burst"]="https://tr.rbxcdn.com/180DAY-8674b0ae1f86bb769bade010391279d8/150/150/Image/Png/noFilter",
["Chainsaw"]="https://tr.rbxcdn.com/180DAY-b439f1e5de8ae858d8e861481d281cab/150/150/Image/Png/noFilter",
["Blobsaw"]="https://tr.rbxcdn.com/180DAY-82799d08f0e089f63fa10c4c9fa3f3c1/150/150/Image/Png/noFilter",
["Buzzsaw"]="https://tr.rbxcdn.com/180DAY-d15f0968906548e1e46cb5c7c3a614ee/150/150/Image/Png/noFilter",
["Festive Buzzsaw"]="https://tr.rbxcdn.com/180DAY-8ca5323f854f522d41cb32eb1899810f/150/150/Image/Png/noFilter",
["Glorious Chainsaw"]="https://tr.rbxcdn.com/180DAY-cd087e634d0e3693338d2986ace1f1a6/150/150/Image/Png/noFilter",
["Handsaws"]="https://tr.rbxcdn.com/180DAY-f71e0264d4e6be96adf75285b1763361/150/150/Image/Png/noFilter",
["Mega Drill"]="https://tr.rbxcdn.com/180DAY-b27ce7d7b2e35534317b9f58b5e69227/150/150/Image/Png/noFilter",
["Sharksaw"]="https://tr.rbxcdn.com/180DAY-fe3c3f16a5a020d63ecec98a3bbeaff9/150/150/Image/Png/noFilter",
["Crossbow"]="https://tr.rbxcdn.com/180DAY-8b4c3c852a2220128713d86860b051ee/150/150/Image/Png/noFilter",
["Arch Crossbow"]="https://tr.rbxcdn.com/180DAY-178f45731989dd32b7a1fe31e98ac0fa/150/150/Image/Png/noFilter",
["Campfire Crossbow"]="https://tr.rbxcdn.com/180DAY-bc42b1b4df91c950495103fd812f89c6/150/150/Image/Png/noFilter",
["Crossbone"]="https://tr.rbxcdn.com/180DAY-d55ca0454c38de5aff5778b16d50432f/150/150/Image/Png/noFilter",
["Frostbite Crossbow"]="https://tr.rbxcdn.com/180DAY-451f24f4bbe855a9c5889d546f954e7f/150/150/Image/Png/noFilter",
["Glorious Crossbow"]="https://tr.rbxcdn.com/180DAY-5742db373fc0385b53f61e2f660ebf24/150/150/Image/Png/noFilter",
["Harpoon Crossbow"]="https://tr.rbxcdn.com/180DAY-dc97d7bae9ac319cefd1325306f73da6/150/150/Image/Png/noFilter",
["Pixel Crossbow"]="https://tr.rbxcdn.com/180DAY-fa75381ca65e27b89da104836c896502/150/150/Image/Png/noFilter",
["Violin Crossbow"]="https://tr.rbxcdn.com/180DAY-af988149f69c16e0a920796ef6d77919/150/150/Image/Png/noFilter",
["Daggers"]="https://tr.rbxcdn.com/180DAY-9de0a91433445ee1e8400a74ca1669dc/150/150/Image/Png/noFilter",
["Aces"]="https://tr.rbxcdn.com/180DAY-c071c42525c06515260c82bde30006f8/150/150/Image/Png/noFilter",
["Bat Daggers"]="https://tr.rbxcdn.com/180DAY-25464c0c44a805b43bf14540c331401e/150/150/Image/Png/noFilter",
["Broken Hearts"]="https://tr.rbxcdn.com/180DAY-e97c7d4536aec1c9abb7eae25aa8eb42/150/150/Image/Png/noFilter",
["Cookies"]="https://tr.rbxcdn.com/180DAY-747f23b1638b5ba6a1158f7b1a2aa2a5/150/150/Image/Png/noFilter",
["Crystal Daggers"]="https://tr.rbxcdn.com/180DAY-77bf9c5f296bf86fe21ce45a909e2114/150/150/Image/Png/noFilter",
["Glorious Daggers"]="https://tr.rbxcdn.com/180DAY-2a284139718b152fc0b70de8ab90fbaf/150/150/Image/Png/noFilter",
["Keynais"]="https://tr.rbxcdn.com/180DAY-bee2d9a84b8c260fdf7d6c6c4fb8db26/150/150/Image/Png/noFilter",
["Paper Planes"]="https://tr.rbxcdn.com/180DAY-8027642460976341f3580cab052c7f67/150/150/Image/Png/noFilter",
["Shurikens"]="https://tr.rbxcdn.com/180DAY-48aa257173a254e91a33bceb59eff616/150/150/Image/Png/noFilter",
["Starfish"]="https://tr.rbxcdn.com/180DAY-081a2b8556f96b5059d9994d553ba07f/150/150/Image/Png/noFilter",
["Toaster"]="https://tr.rbxcdn.com/180DAY-df93619bcb78e7da5b7ce9306702cbcc/150/150/Image/Png/noFilter",
["Distortion"]="https://tr.rbxcdn.com/180DAY-12171f05e44b1dbfa91a7dc0ba4c13ac/150/150/Image/Png/noFilter",
["Bubble Distortion"]="https://tr.rbxcdn.com/180DAY-b092a070cf31269a1f90675e85230453/150/150/Image/Png/noFilter",
["Cyber Distortion"]="https://tr.rbxcdn.com/180DAY-4a6059bc16fd024a82792a8ac7a52d4e/150/150/Image/Png/noFilter",
["Electropunk Distortion"]="https://tr.rbxcdn.com/180DAY-f68f37d7d692318b526ac4413e38c616/150/150/Image/Png/noFilter",
["Experiment D15"]="https://tr.rbxcdn.com/180DAY-31f4afc072272b22119e8ef4e2c58344/150/150/Image/Png/noFilter",
["Glorious Distortion"]="https://tr.rbxcdn.com/180DAY-855005bad48bedea40052513e87c7b27/150/150/Image/Png/noFilter",
["Magma Distortion"]="https://tr.rbxcdn.com/180DAY-e2d8101d7a4279452060af9c7ec9df7f/150/150/Image/Png/noFilter",
["Plasma Distortion"]="https://tr.rbxcdn.com/180DAY-3a59710ceef619e9a5102fd5ccf12d1b/150/150/Image/Png/noFilter",
["Sleighstortion"]="https://tr.rbxcdn.com/180DAY-b1c04abe17f40f4c6b4c996d79176e2f/150/150/Image/Png/noFilter",
["Energy Pistols"]="https://tr.rbxcdn.com/180DAY-f2095db12a6c6301b9ab5a66b4f17057/150/150/Image/Png/noFilter",
["Apex Pistols"]="https://tr.rbxcdn.com/180DAY-4f560c4bb28c65703c2aead467f63c51/150/150/Image/Png/noFilter",
["Enerkey Pistols"]="https://tr.rbxcdn.com/180DAY-ea665dd7f4d50b5b2df4137f729a37f3/150/150/Image/Png/noFilter",
["Glorious Energy Pistols"]="https://tr.rbxcdn.com/180DAY-13f8d115e6d1e707e6f1bb67cd18af00/150/150/Image/Png/noFilter",
["Hacker Pistols"]="https://tr.rbxcdn.com/180DAY-64856d6772afacbdb6e77accc431caed/150/150/Image/Png/noFilter",
["Hydro Pistols"]="https://tr.rbxcdn.com/180DAY-3e343a5a10edf793df1cfc2907ad3d56/150/150/Image/Png/noFilter",
["Hyperlaser Guns"]="https://tr.rbxcdn.com/180DAY-c359b439d11564e4806d9264bcadfbe2/150/150/Image/Png/noFilter",
["New Year Energy Pistols"]="https://tr.rbxcdn.com/180DAY-255c8cb856b7480a755227fbc2ae2a6f/150/150/Image/Png/noFilter",
["Sol Pistols"]="https://tr.rbxcdn.com/180DAY-ede646f476e68d08404401ff3dafd926/150/150/Image/Png/noFilter",
["Soul Pistols"]="https://tr.rbxcdn.com/180DAY-69f7b1fe191b9b60fb3e6b23fd0e308e/150/150/Image/Png/noFilter",
["Void Pistols"]="https://tr.rbxcdn.com/180DAY-589db0d3399d7b4dadadaca21af2f773/150/150/Image/Png/noFilter",
["Energy Rifle"]="https://tr.rbxcdn.com/180DAY-d5bb0c5f8cc71d07c5dc9412c1d65452/150/150/Image/Png/noFilter",
["Apex Rifle"]="https://tr.rbxcdn.com/180DAY-8038f41824372e102af883885b48ebb9/150/150/Image/Png/noFilter",
["Enerkey Rifle"]="https://tr.rbxcdn.com/180DAY-3c3fd1ff58cea397d57340a1c2f921e6/150/150/Image/Png/noFilter",
["Glorious Energy Rifle"]="https://tr.rbxcdn.com/180DAY-ab8bf34daa8f306e88aa68864ad50cb7/150/150/Image/Png/noFilter",
["Hacker Rifle"]="https://tr.rbxcdn.com/180DAY-4b15ccec4b9f195df89b6cf5b2527262/150/150/Image/Png/noFilter",
["Hydro Rifle"]="https://tr.rbxcdn.com/180DAY-5502618315c00854b8095e4d0e275fc4/150/150/Image/Png/noFilter",
["New Year Energy Rifle"]="https://tr.rbxcdn.com/180DAY-25cd19f41afac60c93981b6b77f06059/150/150/Image/Png/noFilter",
["Sol Rifle"]="https://tr.rbxcdn.com/180DAY-200c4343fad06aeca3f165c1a5f10eb6/150/150/Image/Png/noFilter",
["Soul Rifle"]="https://tr.rbxcdn.com/180DAY-e0b4b484e916aa3ee0d7f910413e3b43/150/150/Image/Png/noFilter",
["Void Rifle"]="https://tr.rbxcdn.com/180DAY-6fc74a09904738aba7c2c081e02a3218/150/150/Image/Png/noFilter",
["Exogun"]="https://tr.rbxcdn.com/180DAY-63ec39f2410966eaea9fb82206e05cd5/150/150/Image/Png/noFilter",
["Exogourd"]="https://tr.rbxcdn.com/180DAY-b79675abaf6870f72854ec0dd7c708e4/150/150/Image/Png/noFilter",
["Glorious Exogun"]="https://tr.rbxcdn.com/180DAY-8abd7ad342dd949dc60549418e88c5e8/150/150/Image/Png/noFilter",
["Midnight Festive Exogun"]="https://tr.rbxcdn.com/180DAY-1c46303e91e88efe274d23d7d0a0d036/150/150/Image/Png/noFilter",
["Pearl Exogun"]="https://tr.rbxcdn.com/180DAY-022384014639dcf1cd5592e6c7bbd36e/150/150/Image/Png/noFilter",
["Ray Gun"]="https://tr.rbxcdn.com/180DAY-8c74f0e7d5d7d8afd4a4effef0d97f3e/150/150/Image/Png/noFilter",
["Repulsor"]="https://tr.rbxcdn.com/180DAY-a0cea5611cdfcd26db10fffa8049ce40/150/150/Image/Png/noFilter",
["Singularity"]="https://tr.rbxcdn.com/180DAY-b54b2985ac3fc10f1a720e5b70916d3b/150/150/Image/Png/noFilter",
["Wondergun"]="https://tr.rbxcdn.com/180DAY-769fd9f96949c905cd89011d8cc5abf0/150/150/Image/Png/noFilter",
["Fists"]="https://tr.rbxcdn.com/180DAY-a76e42b911dba9c1e55e9495341e4fef/150/150/Image/Png/noFilter",
["Boxing Gloves"]="https://tr.rbxcdn.com/180DAY-dcffea52d12e1fe9d451a719e8d970aa/150/150/Image/Png/noFilter",
["Brass Knuckles"]="https://tr.rbxcdn.com/180DAY-6e122f8635e378cd3c6e7085131e4f3b/150/150/Image/Png/noFilter",
["Crab Claws"]="https://tr.rbxcdn.com/180DAY-52318544f1c36e2706575045c258fcfc/150/150/Image/Png/noFilter",
["Festive Fists"]="https://tr.rbxcdn.com/180DAY-c6cf41def6dc0de100e7d3d0dbaace91/150/150/Image/Png/noFilter",
["Fist"]="https://tr.rbxcdn.com/180DAY-ae58c4ceb72fdd913d6d87f7113234bd/150/150/Image/Png/noFilter",
["Fists of Hurt"]="https://tr.rbxcdn.com/180DAY-7c744699c1e09fc16e41d50f9dc53427/150/150/Image/Png/noFilter",
["Glorious Fists"]="https://tr.rbxcdn.com/180DAY-0213e74ad43c137406eee19a926466e2/150/150/Image/Png/noFilter",
["Pirate Hook"]="https://tr.rbxcdn.com/180DAY-9bc06838a147d6a3dcfaf59e27146699/150/150/Image/Png/noFilter",
["Pumpkin Claws"]="https://tr.rbxcdn.com/180DAY-582edbca98de41f1254a9f21c50fed95/150/150/Image/Png/noFilter",
["Spy Gloves"]="https://tr.rbxcdn.com/180DAY-d3293b2ea6bf32888741e72cc4d5255f/150/150/Image/Png/noFilter",
["Flamethrower"]="https://tr.rbxcdn.com/180DAY-b80f58cf0878b8e0b0b823c663f8664b/150/150/Image/Png/noFilter",
["Bubblethrower"]="https://tr.rbxcdn.com/180DAY-617dbe6fa782917207a030238cdb0ead/150/150/Image/Png/noFilter",
["Extinguisher"]="https://tr.rbxcdn.com/180DAY-a64a6b57bf72ded8ebe1f5d4d2b9131d/150/150/Image/Png/noFilter",
["Glitterthrower"]="https://tr.rbxcdn.com/180DAY-9f4c4dd60d7b4326c4df6b4856145bf2/150/150/Image/Png/noFilter",
["Glorious Flamethrower"]="https://tr.rbxcdn.com/180DAY-9eb9a6351b6a439582c91b7f90053e31/150/150/Image/Png/noFilter",
["Jack O'Thrower"]="https://tr.rbxcdn.com/180DAY-437f24ea5caef30615af1f1213002e6f/150/150/Image/Png/noFilter",
["Keythrower"]="https://tr.rbxcdn.com/180DAY-c8e71818fc473eaac50197d86e5ca6af/150/150/Image/Png/noFilter",
["Lamethrower"]="https://tr.rbxcdn.com/180DAY-6c34e4279beeee88333bd7ab1dea21a9/150/150/Image/Png/noFilter",
["Pixel Flamethrower"]="https://tr.rbxcdn.com/180DAY-884f193edf3bfa9a937c4188cf46a04c/150/150/Image/Png/noFilter",
["Rainbowthrower"]="https://tr.rbxcdn.com/180DAY-5f049f5cc02c0a96d7b9874ece26e35f/150/150/Image/Png/noFilter",
["Snowblower"]="https://tr.rbxcdn.com/180DAY-be9b53c18d51a9728670d1ae44df63db/150/150/Image/Png/noFilter",
["Flare Gun"]="https://tr.rbxcdn.com/180DAY-b222c292e215cb91c31e85b293e69bee/150/150/Image/Png/noFilter",
["Banana Flare"]="https://tr.rbxcdn.com/180DAY-f684fc87ddfd1226bb16b72610bc8c7d/150/150/Image/Png/noFilter",
["Dynamite Gun"]="https://tr.rbxcdn.com/180DAY-ccc8a5526468c5dbd023dc78070ac7b8/150/150/Image/Png/noFilter",
["Firework Gun"]="https://tr.rbxcdn.com/180DAY-af6bbe75cc7bec0c512e19ae2143c7a6/150/150/Image/Png/noFilter",
["Glorious Flare Gun"]="https://tr.rbxcdn.com/180DAY-349390ea6bc2c85d8621850115c127e6/150/150/Image/Png/noFilter",
["Pocket Volcano"]="https://tr.rbxcdn.com/180DAY-d6da5fe8aed9850b5b27326a900871c0/150/150/Image/Png/noFilter",
["Vexed Flare Gun"]="https://tr.rbxcdn.com/180DAY-fb1d4ec68529ecb1fa8dc14c1d2dc83d/150/150/Image/Png/noFilter",
["Wrapped Flare Gun"]="https://tr.rbxcdn.com/180DAY-3326235646557365d81ff477ea8f81b8/150/150/Image/Png/noFilter",
["Flashbang"]="https://tr.rbxcdn.com/180DAY-7a985991a3bd6e04a1aec8385ff4a186/150/150/Image/Png/noFilter",
["Camera"]="https://tr.rbxcdn.com/180DAY-992e6f63274978531938e13a382c9d52/150/150/Image/Png/noFilter",
["Disco Ball"]="https://tr.rbxcdn.com/180DAY-4884eee93075e609b5a458d68cfe0629/150/150/Image/Png/noFilter",
["Glorious Flashbang"]="https://tr.rbxcdn.com/180DAY-0c4f52a52eefe6edb732f424e47edf60/150/150/Image/Png/noFilter",
["Lightbulb"]="https://tr.rbxcdn.com/180DAY-90d6a131b9b92ee7b2e01a88da0a3d89/150/150/Image/Png/noFilter",
["Pixel Flashbang"]="https://tr.rbxcdn.com/180DAY-5bff78596787ab38bda90df749bf9dc3/150/150/Image/Png/noFilter",
["Shining Star"]="https://tr.rbxcdn.com/180DAY-50e626b6457453ff74507c7980d80313/150/150/Image/Png/noFilter",
["Skullbang"]="https://tr.rbxcdn.com/180DAY-94780ad2af611eb546ef6290f50856dd/150/150/Image/Png/noFilter",
["Sol"]="https://tr.rbxcdn.com/180DAY-179286ca90d44d8b171254898d654e45/150/150/Image/Png/noFilter",
["Freeze Ray"]="https://tr.rbxcdn.com/180DAY-553d4730ebaa1cb922e84207a42345b6/150/150/Image/Png/noFilter",
["Bubble Ray"]="https://tr.rbxcdn.com/180DAY-1cbbe0cbd477b4d10b5edc84066f104f/150/150/Image/Png/noFilter",
["Cooler"]="https://tr.rbxcdn.com/180DAY-aadbc45a014545ba8ed2aaa0e894b3b0/150/150/Image/Png/noFilter",
["Glorious Freeze Ray"]="https://tr.rbxcdn.com/180DAY-77d50382f142185d6b69025187e3a165/150/150/Image/Png/noFilter",
["Gum Ray"]="https://tr.rbxcdn.com/180DAY-c51dd25c28b4beaaf140b2eebf5b0a71/150/150/Image/Png/noFilter",
["Spider Ray"]="https://tr.rbxcdn.com/180DAY-acd50010dd55687a0b3bef23eb3f108e/150/150/Image/Png/noFilter",
["Temporal Ray"]="https://tr.rbxcdn.com/180DAY-19f0e68dac5ad1e26cf15e7450ccbf3e/150/150/Image/Png/noFilter",
["Wrapped Freeze Ray"]="https://tr.rbxcdn.com/180DAY-f72404d11260847a581f402cfd77b04e/150/150/Image/Png/noFilter",
["Grappler"]="https://tr.rbxcdn.com/180DAY-ac207fc65834e42fbc29aaa20d8d695b/150/150/Image/Png/noFilter",
["Arcade Claw"]="https://tr.rbxcdn.com/180DAY-2857b588db9142d7cb5f2644eadb41db/150/150/Image/Png/noFilter",
["Fishing Rod"]="https://tr.rbxcdn.com/180DAY-b2973b84ece5dc5ddb10f73324979b7f/150/150/Image/Png/noFilter",
["Genie Lamp"]="https://tr.rbxcdn.com/180DAY-c3cfe840bbc9d49ed802d60c3847a5b3/150/150/Image/Png/noFilter",
["Glorious Grappler"]="https://tr.rbxcdn.com/180DAY-aa729cf954fa46be93a10a923d039551/150/150/Image/Png/noFilter",
["Lasso"]="https://tr.rbxcdn.com/180DAY-963d48ba8329c68d4794b0bffc560001/150/150/Image/Png/noFilter",
["Lifeguard Grappler"]="https://tr.rbxcdn.com/180DAY-608a60b50dd5ceddf8cef436c74b4e7b/150/150/Image/Png/noFilter",
["Grenade"]="https://tr.rbxcdn.com/180DAY-a1e93cf8ab57cbf03fbc4608c7c5bc93/150/150/Image/Png/noFilter",
["Cuddle Bomb"]="https://tr.rbxcdn.com/180DAY-3530d46a3ca2c99489b4574a65ae9b94/150/150/Image/Png/noFilter",
["Dynamite"]="https://tr.rbxcdn.com/180DAY-a6ba38c29cb9bdfa83979d30d68b7a83/150/150/Image/Png/noFilter",
["Fizz Bomb"]="https://tr.rbxcdn.com/180DAY-15b67b1af3ec2d3c3f01e693f7a057ae/150/150/Image/Png/noFilter",
["Frozen Grenade"]="https://tr.rbxcdn.com/180DAY-3964714a2f7864c2eac8c85a5ee64714/150/150/Image/Png/noFilter",
["Glorious Grenade"]="https://tr.rbxcdn.com/180DAY-915d119261450de5aaa65eeae4282d33/150/150/Image/Png/noFilter",
["Jingle Grenade"]="https://tr.rbxcdn.com/180DAY-0561c27d98360ef7850336b9dabd2530/150/150/Image/Png/noFilter",
["Keynade"]="https://tr.rbxcdn.com/180DAY-e74bfb001ec98d9473127fb57c3316c8/150/150/Image/Png/noFilter",
["Soul Grenade"]="https://tr.rbxcdn.com/180DAY-fd6307565dbf6df11aa60a188b67ea7c/150/150/Image/Png/noFilter",
["Water Balloon"]="https://tr.rbxcdn.com/180DAY-1edac32c6549c89c18bde7b42402dd14/150/150/Image/Png/noFilter",
["Whoopee Cushion"]="https://tr.rbxcdn.com/180DAY-3dd80c2beae45628ceb2bfdd0f4a40d4/150/150/Image/Png/noFilter",
["Grenade Launcher"]="https://tr.rbxcdn.com/180DAY-a8f139951b25cc4646fa554626680f1d/150/150/Image/Png/noFilter",
["Balloon Launcher"]="https://tr.rbxcdn.com/180DAY-e1a8e315784f678bf599e6df04120476/150/150/Image/Png/noFilter",
["Coconut Launcher"]="https://tr.rbxcdn.com/180DAY-d7fbe21d9e21af017467c1e858484bc8/150/150/Image/Png/noFilter",
["Gearnade Launcher"]="https://tr.rbxcdn.com/180DAY-bfbebfe4e547a92b8451a4cede786a2e/150/150/Image/Png/noFilter",
["Glorious Grenade Launcher"]="https://tr.rbxcdn.com/180DAY-2f7c0a8ab96380c24e6701252f55134a/150/150/Image/Png/noFilter",
["Skull Launcher"]="https://tr.rbxcdn.com/180DAY-d054a0889767ce73bb1723bce48ac8d8/150/150/Image/Png/noFilter",
["Snowball Launcher"]="https://tr.rbxcdn.com/180DAY-02cfe7ff07ca6a78908220ce3688f835/150/150/Image/Png/noFilter",
["Swashbuckler"]="https://tr.rbxcdn.com/180DAY-cec78d75314ec1866a639043ea799aa1/150/150/Image/Png/noFilter",
["Uranium Launcher"]="https://tr.rbxcdn.com/180DAY-7b2d1a2c40066191d6359b4b7cd2b84c/150/150/Image/Png/noFilter",
["Gunblade"]="https://tr.rbxcdn.com/180DAY-308ab0c40b5d85dbc7380cc9cf7d7a28/150/150/Image/Png/noFilter",
["Boneblade"]="https://tr.rbxcdn.com/180DAY-75d93f06c71ded44911a9679e5f9c647/150/150/Image/Png/noFilter",
["Crude Gunblade"]="https://tr.rbxcdn.com/180DAY-f0dd9e96d8c65fc64e14e809d54270a0/150/150/Image/Png/noFilter",
["Elf's Gunblade"]="https://tr.rbxcdn.com/180DAY-4f0f4fb7a7f8cdee1d62ab8b16e7664f/150/150/Image/Png/noFilter",
["Glorious Gunblade"]="https://tr.rbxcdn.com/180DAY-1823b93fc6061c4a7cd9962527a92424/150/150/Image/Png/noFilter",
["Gunsaw"]="https://tr.rbxcdn.com/180DAY-be3329b01fd4f9ddc61af9c43ec3a546/150/150/Image/Png/noFilter",
["Hyper Gunblade"]="https://tr.rbxcdn.com/180DAY-d3a595016bc38be199b235a479c692c6/150/150/Image/Png/noFilter",
["Keyblade"]="https://tr.rbxcdn.com/180DAY-b2e0b5f00d108e5336186950d8ef9fcb/150/150/Image/Png/noFilter",
["Sharkbite"]="https://tr.rbxcdn.com/180DAY-203a87013864a4e7b0147662b0061a6f/150/150/Image/Png/noFilter",
["Handgun"]="https://tr.rbxcdn.com/180DAY-67b2afc4664f32bf5cf85f2573f85851/150/150/Image/Png/noFilter",
["Blaster"]="https://tr.rbxcdn.com/180DAY-d4259ae64bd4feda996f5a37d136a178/150/150/Image/Png/noFilter",
["Gingerbread Handgun"]="https://tr.rbxcdn.com/180DAY-e3165603e7f1b47b8b0ed0874b32ec5e/150/150/Image/Png/noFilter",
["Glorious Handgun"]="https://tr.rbxcdn.com/180DAY-6a8497937b4fd4bae095340015dd8dad/150/150/Image/Png/noFilter",
["Gumball Handgun"]="https://tr.rbxcdn.com/180DAY-ac2ade764722e348cdec041ac9ee8e4b/150/150/Image/Png/noFilter",
["Hand Gun"]="https://tr.rbxcdn.com/180DAY-ac6ab297c84e6c4b4fed1452fdfbde16/150/150/Image/Png/noFilter",
["Pixel Handgun"]="https://tr.rbxcdn.com/180DAY-3f20c232c75dbb07bdb0b5404b85a024/150/150/Image/Png/noFilter",
["Pumpkin Handgun"]="https://tr.rbxcdn.com/180DAY-e0bd22afed996bfc33bbd009eceefd28/150/150/Image/Png/noFilter",
["Sandgun"]="https://tr.rbxcdn.com/180DAY-c6c13416be8e2b093a3987c695ed7604/150/150/Image/Png/noFilter",
["Stealth Handgun"]="https://tr.rbxcdn.com/180DAY-311db5cacabf9be17d0bb8df59abc049/150/150/Image/Png/noFilter",
["Towerstone Handgun"]="https://tr.rbxcdn.com/180DAY-a33e0c193a505c4feb4c9a6493c32095/150/150/Image/Png/noFilter",
["Warp Handgun"]="https://tr.rbxcdn.com/180DAY-8e68ecdeb9169c1a156e33744db570ce/150/150/Image/Png/noFilter",
["Jump Pad"]="https://tr.rbxcdn.com/180DAY-53478f1e3540493b4bf4ed439fe8eac3/150/150/Image/Png/noFilter",
["Bounce House"]="https://tr.rbxcdn.com/180DAY-ef90ea6135206731b06a02be356481a2/150/150/Image/Png/noFilter",
["Flamingo Floatie"]="https://tr.rbxcdn.com/180DAY-c4b6963b93b1c8efa19ed3f03f7635c5/150/150/Image/Png/noFilter",
["Glorious Jump Pad"]="https://tr.rbxcdn.com/180DAY-48123643be6fd78e9c09d41b58dbef2d/150/150/Image/Png/noFilter",
["Jolly Man"]="https://tr.rbxcdn.com/180DAY-838bfe15ddf60c2d2b35c1b35eff8853/150/150/Image/Png/noFilter",
["Shady Chicken Sandwich"]="https://tr.rbxcdn.com/180DAY-0b93a7cbdf8931fb1358135caf32527e/150/150/Image/Png/noFilter",
["Spider Web"]="https://tr.rbxcdn.com/180DAY-b817c6c1132ff1a231a0cb4ca36eab56/150/150/Image/Png/noFilter",
["Trampoline"]="https://tr.rbxcdn.com/180DAY-62151a86f928d3a42e084c32d84c2377/150/150/Image/Png/noFilter",
["Katana"]="https://tr.rbxcdn.com/180DAY-bda7329940d44412d0f195c5c082b4af/150/150/Image/Png/noFilter",
["Arch Katana"]="https://tr.rbxcdn.com/180DAY-93939b7ff8c46b8301fe9b61aa53bfc2/150/150/Image/Png/noFilter",
["Crystal Katana"]="https://tr.rbxcdn.com/180DAY-dba6e67736e394d9e7e02586a9fb6854/150/150/Image/Png/noFilter",
["Cutlass"]="https://tr.rbxcdn.com/180DAY-89a440a7d9419a0e0050be257068ffa0/150/150/Image/Png/noFilter",
["Evil Trident"]="https://tr.rbxcdn.com/180DAY-0c62ed6f65389b93df596250614f5a96/150/150/Image/Png/noFilter",
["Glorious Katana"]="https://tr.rbxcdn.com/180DAY-1ea7a91750b825a4246b37abcc041e3f/150/150/Image/Png/noFilter",
["Keytana"]="https://tr.rbxcdn.com/180DAY-5f095d2a52436146e2d8d7e8beae0393/150/150/Image/Png/noFilter",
["Lightning Bolt"]="https://tr.rbxcdn.com/180DAY-d1366667d51e6b85ba8d8466b738bce1/150/150/Image/Png/noFilter",
["Linked Sword"]="https://tr.rbxcdn.com/180DAY-f9c62e530931fe957a196eef68216912/150/150/Image/Png/noFilter",
["New Year Katana"]="https://tr.rbxcdn.com/180DAY-8c7e8c8458f9c89e5defa8c593fe6b0b/150/150/Image/Png/noFilter",
["Pixel Katana"]="https://tr.rbxcdn.com/180DAY-13eafc11d29900643fee71ab992e43db/150/150/Image/Png/noFilter",
["Riptide Katana"]="https://tr.rbxcdn.com/180DAY-b277fadf77ab82a2ab957d0bb7c6adee/150/150/Image/Png/noFilter",
["Saber"]="https://tr.rbxcdn.com/180DAY-33f2b5f9a5eaaff095e4f4ae1a3e6410/150/150/Image/Png/noFilter",
["Stellar Katana"]="https://tr.rbxcdn.com/180DAY-ae4e3e2f812260325b7fb1588031cadd/150/150/Image/Png/noFilter",
["Swordfish"]="https://tr.rbxcdn.com/180DAY-b7904b1d6b30969e6a1ba904042e95ed/150/150/Image/Png/noFilter",
["Knife"]="https://tr.rbxcdn.com/180DAY-dd185920455f993bccd781856c93dd59/150/150/Image/Png/noFilter",
["Armature.001"]="https://tr.rbxcdn.com/180DAY-1ba2c65ecf0186343fc0335fdd8e27c1/150/150/Image/Png/noFilter",
["Balisong"]="https://tr.rbxcdn.com/180DAY-3e4e326e3a4b74fb6621373b2c98548c/150/150/Image/Png/noFilter",
["Birthday Candle"]="https://tr.rbxcdn.com/180DAY-a7b9bd2ba5d61fc2f4531a62c9713f6e/150/150/Image/Png/noFilter",
["Caladbolg"]="https://tr.rbxcdn.com/180DAY-20860b3c1baec256644437b401480103/150/150/Image/Png/noFilter",
["Candy Cane"]="https://tr.rbxcdn.com/180DAY-76c875563635e9746cf5cb3f95855b58/150/150/Image/Png/noFilter",
["Chancla"]="https://tr.rbxcdn.com/180DAY-6b75c9d1a64d533d1e522a195928214c/150/150/Image/Png/noFilter",
["Glorious Knife"]="https://tr.rbxcdn.com/180DAY-ae67d6770bfd8c4e1f706a2dd62470e0/150/150/Image/Png/noFilter",
["Karambit"]="https://tr.rbxcdn.com/180DAY-57103466cfcdb342144a3015509b971c/150/150/Image/Png/noFilter",
["Keylisong"]="https://tr.rbxcdn.com/180DAY-1bea37ce2c6dd77fe2abe5db537dabcd/150/150/Image/Png/noFilter",
["Keyrambit"]="https://tr.rbxcdn.com/180DAY-0211bc632a7c882e1607e123db1d4a71/150/150/Image/Png/noFilter",
["Machete"]="https://tr.rbxcdn.com/180DAY-e66dc8ddae4b79339dbbd78a3be96565/150/150/Image/Png/noFilter",
["Pencil"]="https://tr.rbxcdn.com/180DAY-57b04ce17e6381a84b7b2f195ac54721/150/150/Image/Png/noFilter",
["Shark Tooth"]="https://tr.rbxcdn.com/180DAY-71d9b6429316c05efbd8435625fdd796/150/150/Image/Png/noFilter",
["Trophy Knife"]="https://tr.rbxcdn.com/180DAY-3c584193f98d3acbeb1cb05646d825ba/150/150/Image/Png/noFilter",
["Maul"]="https://tr.rbxcdn.com/180DAY-25a71295dfb079c21786f99b86f45105/150/150/Image/Png/noFilter",
["Ban Hammer"]="https://tr.rbxcdn.com/180DAY-23b950b99e02cda24599266289dc822e/150/150/Image/Png/noFilter",
["Clown Hammer"]="https://tr.rbxcdn.com/180DAY-ccbc76ef23c0b3cea6006fdf1cd21056/150/150/Image/Png/noFilter",
["Excalibur"]="https://tr.rbxcdn.com/180DAY-75ffae640b34e234e0d3f8520897db91/150/150/Image/Png/noFilter",
["Giant Popsicle"]="https://tr.rbxcdn.com/180DAY-e1cdde01a5bbd415f3ece29ca3b5af3f/150/150/Image/Png/noFilter",
["Glorious Maul"]="https://tr.rbxcdn.com/180DAY-a41a2028ac395e0a6b68678353f1df06/150/150/Image/Png/noFilter",
["Ice Maul"]="https://tr.rbxcdn.com/180DAY-c147dabbd2085039c0f828ed911b2f3d/150/150/Image/Png/noFilter",
["Sleigh Maul"]="https://tr.rbxcdn.com/180DAY-116b16208addcd863a7720409fe79397/150/150/Image/Png/noFilter",
["Starforge Maul"]="https://tr.rbxcdn.com/180DAY-fe0247e63525590fedf042c1e81bb434/150/150/Image/Png/noFilter",
["Medkit"]="https://tr.rbxcdn.com/180DAY-26559db8e77d8aba58da1d7378dfc3ff/150/150/Image/Png/noFilter",
["Box of Chocolates"]="https://tr.rbxcdn.com/180DAY-d204fbf9aa8a90d7783e7dd1c4a6024d/150/150/Image/Png/noFilter",
["Briefcase"]="https://tr.rbxcdn.com/180DAY-60d3b06f840a03f68ddcb2fe9b1214c3/150/150/Image/Png/noFilter",
["Bucket of Candy"]="https://tr.rbxcdn.com/180DAY-86d3654017b78e226556162019e4b29d/150/150/Image/Png/noFilter",
["Glorious Medkit"]="https://tr.rbxcdn.com/180DAY-7c56c93f5a7a00928ef0af7cf5e059f0/150/150/Image/Png/noFilter",
["Ice Cream"]="https://tr.rbxcdn.com/180DAY-2f70c5ae9d2c166bcc7063d0d421adc9/150/150/Image/Png/noFilter",
["Laptop"]="https://tr.rbxcdn.com/180DAY-698e6435731b7041d3c276772f3f1412/150/150/Image/Png/noFilter",
["Medkitty"]="https://tr.rbxcdn.com/180DAY-94582c4014fa57cf3c2f6082722615a8/150/150/Image/Png/noFilter",
["Milk & Cookies"]="https://tr.rbxcdn.com/180DAY-6a7762c27d5e3fab4f798ec7bfd69a64/150/150/Image/Png/noFilter",
["Sandwich"]="https://tr.rbxcdn.com/180DAY-754667a2e48bf95ab5f4eb82f7bbe9ec/150/150/Image/Png/noFilter",
["Minigun"]="https://tr.rbxcdn.com/180DAY-ec47e8f3814fce279609107597c582f4/150/150/Image/Png/noFilter",
["Fighter Jet"]="https://tr.rbxcdn.com/180DAY-2282922bdf8605129a8bda403b1cf26d/150/150/Image/Png/noFilter",
["Glorious Minigun"]="https://tr.rbxcdn.com/180DAY-43ab28792eabaa34120de5f26fc71e0b/150/150/Image/Png/noFilter",
["Lasergun 3000"]="https://tr.rbxcdn.com/180DAY-e7411b199ad3acc91ce20bbf17fe582e/150/150/Image/Png/noFilter",
["Pixel Minigun"]="https://tr.rbxcdn.com/180DAY-1a8b94f9b9ab69c9091e49a9872d5ea9/150/150/Image/Png/noFilter",
["Pumpkin Minigun"]="https://tr.rbxcdn.com/180DAY-ae253679fbf11a958ca336b1556d35e4/150/150/Image/Png/noFilter",
["Shark Minigun"]="https://tr.rbxcdn.com/180DAY-433f28a081bddf8c44833f9374027bea/150/150/Image/Png/noFilter",
["Wrapped Minigun"]="https://tr.rbxcdn.com/180DAY-b1df3f684c6a1e323023d03775ac33ba/150/150/Image/Png/noFilter",
["Molotov"]="https://tr.rbxcdn.com/180DAY-aae73d888f11f762b41581f5e9a7d07e/150/150/Image/Png/noFilter",
["Arch Molotov"]="https://tr.rbxcdn.com/180DAY-193cf2b1e05110a077428665ad7bb687/150/150/Image/Png/noFilter",
["Campfire Stick"]="https://tr.rbxcdn.com/180DAY-23557ffa551bf6e7849860d228304689/150/150/Image/Png/noFilter",
["Coffee"]="https://tr.rbxcdn.com/180DAY-a67f06f07e355b91cca3a6065d3552f4/150/150/Image/Png/noFilter",
["Glorious Molotov"]="https://tr.rbxcdn.com/180DAY-55221a141d60ed6eaf347aa5466b0ede/150/150/Image/Png/noFilter",
["Hot Coals"]="https://tr.rbxcdn.com/180DAY-c7164ad22fa98f8b442418d4f9b2086f/150/150/Image/Png/noFilter",
["Lava Lamp"]="https://tr.rbxcdn.com/180DAY-c6b90ac5fdc63a9f5ad3a35204758468/150/150/Image/Png/noFilter",
["Ship In A Bottle"]="https://tr.rbxcdn.com/180DAY-fc97970f97ed6df500caf935b2d7ec1c/150/150/Image/Png/noFilter",
["Torch"]="https://tr.rbxcdn.com/180DAY-502f0158abc9b98b48550b6cfa10e2c2/150/150/Image/Png/noFilter",
["Vexed Candle"]="https://tr.rbxcdn.com/180DAY-4e25d4e3fe40fdde1d8277753d71c0fb/150/150/Image/Png/noFilter",
["Paintball Gun"]="https://tr.rbxcdn.com/180DAY-a37fb93a9a0fe4d8e7257ae4c65c7ac2/150/150/Image/Png/noFilter",
["Boba Gun"]="https://tr.rbxcdn.com/180DAY-1148f595d32ace802047559086c72cb0/150/150/Image/Png/noFilter",
["Brain Gun"]="https://tr.rbxcdn.com/180DAY-25af05cdc751022f72de9a32e96169ab/150/150/Image/Png/noFilter",
["Glorious Paintball Gun"]="https://tr.rbxcdn.com/180DAY-bfd371d34241df3dd4780bd9f04bfb79/150/150/Image/Png/noFilter",
["Ketchup Gun"]="https://tr.rbxcdn.com/180DAY-f49c5dd393aa55f0206e2ec278f25421/150/150/Image/Png/noFilter",
["Lemonade Gun"]="https://tr.rbxcdn.com/180DAY-b5c292955bf6a0ea18c7b8dddd4baa07/150/150/Image/Png/noFilter",
["Paintballoon Gun"]="https://tr.rbxcdn.com/180DAY-b2ca7020e00f05405f889370c8abb058/150/150/Image/Png/noFilter",
["Slime Gun"]="https://tr.rbxcdn.com/180DAY-d29a6cf9cacd24c525141a7e0986e312/150/150/Image/Png/noFilter",
["Snowball Gun"]="https://tr.rbxcdn.com/180DAY-7adb04991b0cd172f9ea1ac678481754/150/150/Image/Png/noFilter",
["Permafrost"]="https://tr.rbxcdn.com/180DAY-9df315465fe7bb293804909a669139dd/150/150/Image/Png/noFilter",
["Glorious Permafrost"]="https://tr.rbxcdn.com/180DAY-c2ab8040012c9faa77d7fe8d903661b7/150/150/Image/Png/noFilter",
["Ice Permafrost"]="https://tr.rbxcdn.com/180DAY-c60808c2748932b927195c17ce1f3a0d/150/150/Image/Png/noFilter",
["Permafrost.rbxm"]="https://tr.rbxcdn.com/180DAY-b5c3b6cfab712f9303a01bef3319c716/150/150/Image/Png/noFilter",
["Permasand"]="https://tr.rbxcdn.com/180DAY-be6d9a5e875506781981ae5690b3dfc9/150/150/Image/Png/noFilter",
["Snowman Permafrost"]="https://tr.rbxcdn.com/180DAY-f4f122b24f134b754e95a865ebd4e80c/150/150/Image/Png/noFilter",
["Starforge Permafrost"]="https://tr.rbxcdn.com/180DAY-dc05ef78695468f34250e49cabea4df4/150/150/Image/Png/noFilter",
["Temporal Permafrost"]="https://tr.rbxcdn.com/180DAY-1d8b18e44ebaa6d86c16314131d94836/150/150/Image/Png/noFilter",
["RPG"]="https://tr.rbxcdn.com/180DAY-9a2b6500013a1d91482fa25de55b5ddf/150/150/Image/Png/noFilter",
["Cupcake Launcher"]="https://tr.rbxcdn.com/180DAY-7adbdb67a518e740f3474e235a7d3496/150/150/Image/Png/noFilter",
["Firework Launcher"]="https://tr.rbxcdn.com/180DAY-ecd0593407a6bd9a05b2ddb40e2c329a/150/150/Image/Png/noFilter",
["Glorious RPG"]="https://tr.rbxcdn.com/180DAY-aab0adfdcec29173d1c22e0257e0fae4/150/150/Image/Png/noFilter",
["Nuke Launcher"]="https://tr.rbxcdn.com/180DAY-87d4df1cd3eee97a195593fe100aadd5/150/150/Image/Png/noFilter",
["Pencil Launcher"]="https://tr.rbxcdn.com/180DAY-52c9958dd7513764c1662b622d5048bf/150/150/Image/Png/noFilter",
["Pumpkin Launcher"]="https://tr.rbxcdn.com/180DAY-a525d5542030f25c2ce9ef5e455d026c/150/150/Image/Png/noFilter",
["Rocket Launcher"]="https://tr.rbxcdn.com/180DAY-c19b3109bd957c3d1e22a003882e2f73/150/150/Image/Png/noFilter",
["RPKEY"]="https://tr.rbxcdn.com/180DAY-454b298ecd120f5f30f0f2d5164c8d03/150/150/Image/Png/noFilter",
["Spaceship Launcher"]="https://tr.rbxcdn.com/180DAY-74cd103e301995d4103d9c762b6d3b04/150/150/Image/Png/noFilter",
["Squid Launcher"]="https://tr.rbxcdn.com/180DAY-dd8bb94b6064d82fa88e841fc1970f91/150/150/Image/Png/noFilter",
["Sundae Launcher"]="https://tr.rbxcdn.com/180DAY-b77c9778a7022e374a0acfc7b125b60a/150/150/Image/Png/noFilter",
["Revolver"]="https://tr.rbxcdn.com/180DAY-d28fab78e38d4c81bd8973cab154c8fc/150/150/Image/Png/noFilter",
["Boneclaw Revolver"]="https://tr.rbxcdn.com/180DAY-0b359f04a10958e915cd0ccbf04ca795/150/150/Image/Png/noFilter",
["Cruise Revolver"]="https://tr.rbxcdn.com/180DAY-a9d8cb5d32edd7141c91285a31eb6ed5/150/150/Image/Png/noFilter",
["Desert Eagle"]="https://tr.rbxcdn.com/180DAY-d1609bbf12e16a6e9ed89190fc6ed393/150/150/Image/Png/noFilter",
["Glorious Revolver"]="https://tr.rbxcdn.com/180DAY-b6a4c9c96b333f29e46e67c98e821ef7/150/150/Image/Png/noFilter",
["Keyvolver"]="https://tr.rbxcdn.com/180DAY-5916092975e4ef6ea5ec65d831812fd9/150/150/Image/Png/noFilter",
["Peppergun"]="https://tr.rbxcdn.com/180DAY-fa61e6a6fc16085b179299f3108867fd/150/150/Image/Png/noFilter",
["Peppermint Sheriff"]="https://tr.rbxcdn.com/180DAY-02571bd3d1f0251f5944d42b8baf67a5/150/150/Image/Png/noFilter",
["Sheriff"]="https://tr.rbxcdn.com/180DAY-43bcd94bce30fd7d074204726be4e5e1/150/150/Image/Png/noFilter",
["Riot Shield"]="https://tr.rbxcdn.com/180DAY-ae6ba57e159c087e879bb1090d24987a/150/150/Image/Png/noFilter",
["Broken Surfboard"]="https://tr.rbxcdn.com/180DAY-8a6e9434f607234e37f439b9be5c1939/150/150/Image/Png/noFilter",
["Door"]="https://tr.rbxcdn.com/180DAY-ab1559ec65d2071d628756a2ea371135/150/150/Image/Png/noFilter",
["Energy Shield"]="https://tr.rbxcdn.com/180DAY-2355182c51ea50bd374e1a0eff87be3b/150/150/Image/Png/noFilter",
["Glorious Riot Shield"]="https://tr.rbxcdn.com/180DAY-8d23b9185c2d7607d74fe0e3b72f9974/150/150/Image/Png/noFilter",
["Masterpiece"]="https://tr.rbxcdn.com/180DAY-02e262037eef48159fe0fe6c85aef6ae/150/150/Image/Png/noFilter",
["Sled"]="https://tr.rbxcdn.com/180DAY-9454f14fa537f9cfccb385f86ca57c29/150/150/Image/Png/noFilter",
["Tombstone Shield"]="https://tr.rbxcdn.com/180DAY-6cd36c85166d59276a18fdc68db9eefb/150/150/Image/Png/noFilter",
["Satchel"]="https://tr.rbxcdn.com/180DAY-a53e138ae304b7d980fcbb9e3f7b18a0/150/150/Image/Png/noFilter",
["Advanced Satchel"]="https://tr.rbxcdn.com/180DAY-b75c5a64db1da4f1ccc2cafe530106d9/150/150/Image/Png/noFilter",
["Bag o' Money"]="https://tr.rbxcdn.com/180DAY-90590cd542526991c0ba1b816266828f/150/150/Image/Png/noFilter",
["Glorious Satchel"]="https://tr.rbxcdn.com/180DAY-155279c5cc7710d8e8cc29d118ff7430/150/150/Image/Png/noFilter",
["Lifeguard Satchel"]="https://tr.rbxcdn.com/180DAY-687dffbe50a9c5614c6ed048129e0d4b/150/150/Image/Png/noFilter",
["Notebook Satchel"]="https://tr.rbxcdn.com/180DAY-98db59ddfe640a193abd9a466a6e2ff8/150/150/Image/Png/noFilter",
["Pizza Box"]="https://tr.rbxcdn.com/180DAY-07c0f7eca0880fd40fe63fb79bbe0272/150/150/Image/Png/noFilter",
["Potion Satchel"]="https://tr.rbxcdn.com/180DAY-13760d36274e74ad4b67633f7cc9c790/150/150/Image/Png/noFilter",
["Suspicious Gift"]="https://tr.rbxcdn.com/180DAY-162299b7326c09856d9917fbe36dbd7f/150/150/Image/Png/noFilter",
["Scythe"]="https://tr.rbxcdn.com/180DAY-57a4092a3011b1e505a1ca331e039581/150/150/Image/Png/noFilter",
["Anchor"]="https://tr.rbxcdn.com/180DAY-18a1885022557d0c7a80872560c5867f/150/150/Image/Png/noFilter",
["Bat Scythe"]="https://tr.rbxcdn.com/180DAY-f0acdfe560686a5390a73f5398f9850e/150/150/Image/Png/noFilter",
["Bug Net"]="https://tr.rbxcdn.com/180DAY-c74815e143805c457846acbceb09664b/150/150/Image/Png/noFilter",
["Cryo Scythe"]="https://tr.rbxcdn.com/180DAY-870b84eab0b8d54ee847276b10214886/150/150/Image/Png/noFilter",
["Crystal Scythe"]="https://tr.rbxcdn.com/180DAY-fa5a618d8486d4a516d023c0ee003d74/150/150/Image/Png/noFilter",
["Glorious Scythe"]="https://tr.rbxcdn.com/180DAY-7bfbaf43958c4cd9afb236a96cb456d4/150/150/Image/Png/noFilter",
["Keythe"]="https://tr.rbxcdn.com/180DAY-e50423228faa78e849dc0b4a5eef0738/150/150/Image/Png/noFilter",
["Palm Scythe"]="https://tr.rbxcdn.com/180DAY-7487e6f606544d00444f1507da463e61/150/150/Image/Png/noFilter",
["Plastic Flamingo"]="https://tr.rbxcdn.com/180DAY-280e2a84a63df423dc82e35c078766c2/150/150/Image/Png/noFilter",
["Sakura Scythe"]="https://tr.rbxcdn.com/180DAY-08b4d46ef21f9dc735895f924c323d58/150/150/Image/Png/noFilter",
["Scythe of Death"]="https://tr.rbxcdn.com/180DAY-6b5407d4bc7967f0df14ecd12f91c959/150/150/Image/Png/noFilter",
["Shorty"]="https://tr.rbxcdn.com/180DAY-c4a7e4accb9055e5d4dd5f9c1de654dd/150/150/Image/Png/noFilter",
["Balloon Shorty"]="https://tr.rbxcdn.com/180DAY-b46a76f83acf62988d8851ce0c0c27fc/150/150/Image/Png/noFilter",
["Bubble Shorty"]="https://tr.rbxcdn.com/180DAY-e22c00bbfe09092ec953a59dda20f396/150/150/Image/Png/noFilter",
["Cannon Shorty"]="https://tr.rbxcdn.com/180DAY-357e570863bf699c0adc57a33b5a134b/150/150/Image/Png/noFilter",
["Demon Shorty"]="https://tr.rbxcdn.com/180DAY-0c177e1363a6b2b82d1ff9710ca618d5/150/150/Image/Png/noFilter",
["Glorious Shorty"]="https://tr.rbxcdn.com/180DAY-92b0aa54eafecaad9883e965301b6e36/150/150/Image/Png/noFilter",
["Lovely Shorty"]="https://tr.rbxcdn.com/180DAY-18844b19c3e8735cf45e5b353903ee95/150/150/Image/Png/noFilter",
["Not So Shorty"]="https://tr.rbxcdn.com/180DAY-d2203303b9d4455b40a2d64eec88690b/150/150/Image/Png/noFilter",
["Too Shorty"]="https://tr.rbxcdn.com/180DAY-8e56cbd9af529349dc01eefa2f298939/150/150/Image/Png/noFilter",
["Wrapped Shorty"]="https://tr.rbxcdn.com/180DAY-ce3a0f8ef3c546b64ef3990168d0c771/150/150/Image/Png/noFilter",
["Shotgun"]="https://tr.rbxcdn.com/180DAY-3358ed40376727033d38345adcd92636/150/150/Image/Png/noFilter",
["Balloon Shotgun"]="https://tr.rbxcdn.com/180DAY-1c1a0398ec26457a576f6c3c5b198546/150/150/Image/Png/noFilter",
["Broomstick"]="https://tr.rbxcdn.com/180DAY-9177f08dbd424fd0caf1cb882ba251bf/150/150/Image/Png/noFilter",
["Cactus Shotgun"]="https://tr.rbxcdn.com/180DAY-efc1ff1c533fb2f1b88f3bd501231f55/150/150/Image/Png/noFilter",
["Glorious Shotgun"]="https://tr.rbxcdn.com/180DAY-2fe969ddd3ae44f62acdb78eba48a26e/150/150/Image/Png/noFilter",
["Hyper Shotgun"]="https://tr.rbxcdn.com/180DAY-3eca54618548fa60aeda9d302e972897/150/150/Image/Png/noFilter",
["Shark Shotgun"]="https://tr.rbxcdn.com/180DAY-e6381d0fcef152a00600b6624e0a033e/150/150/Image/Png/noFilter",
["Shotkey"]="https://tr.rbxcdn.com/180DAY-95e98398fe6398ad225b6ab7cf50b3da/150/150/Image/Png/noFilter",
["Wrapped Shotgun"]="https://tr.rbxcdn.com/180DAY-c2b9097f9ce0556c917e62df1a3a87a8/150/150/Image/Png/noFilter",
["Slingshot"]="https://tr.rbxcdn.com/180DAY-2e5b5eb921578399449692fdd9f8e92b/150/150/Image/Png/noFilter",
["Boneshot"]="https://tr.rbxcdn.com/180DAY-a1204011f45f8b6c0a5a3a0ab36ddf84/150/150/Image/Png/noFilter",
["Glorious Slingshot"]="https://tr.rbxcdn.com/180DAY-87b89e4026a37c4bdff04e82601ef5b5/150/150/Image/Png/noFilter",
["Goalpost"]="https://tr.rbxcdn.com/180DAY-eb6afa07fc6e7e2b3638f082172f04aa/150/150/Image/Png/noFilter",
["Harp"]="https://tr.rbxcdn.com/180DAY-9cda48492fee961f5ee8c581b56028ac/150/150/Image/Png/noFilter",
["Keyshot"]="https://tr.rbxcdn.com/180DAY-d75004504767029cc2bbca6ccca81fee/150/150/Image/Png/noFilter",
["Lucky Horseshoe"]="https://tr.rbxcdn.com/180DAY-1ca8645529ee703ffbc4df25bc985d45/150/150/Image/Png/noFilter",
["Palmshot"]="https://tr.rbxcdn.com/180DAY-abd9821f3dae1eeff731394e8c3adcf8/150/150/Image/Png/noFilter",
["Reindeer Slingshot"]="https://tr.rbxcdn.com/180DAY-2c67ada6f62ad5a4c403d89b432abbb1/150/150/Image/Png/noFilter",
["Stick"]="https://tr.rbxcdn.com/180DAY-c40e7b1bfcf2752b79e2341b743594a2/150/150/Image/Png/noFilter",
["Smoke Grenade"]="https://tr.rbxcdn.com/180DAY-fc4337d11eb96f9dac21030c6d428104/150/150/Image/Png/noFilter",
["Balance"]="https://tr.rbxcdn.com/180DAY-108501c87e065211b1dd71befc75db2c/150/150/Image/Png/noFilter",
["Beach Ball"]="https://tr.rbxcdn.com/180DAY-8a2d92e33097b95f9ec8729d923ac598/150/150/Image/Png/noFilter",
["Emoji Cloud"]="https://tr.rbxcdn.com/180DAY-b59e90926fea596afd4e7eb1ad72e849/150/150/Image/Png/noFilter",
["Eyeball"]="https://tr.rbxcdn.com/180DAY-9f18d03fede9001be7e384e5cc3b6a41/150/150/Image/Png/noFilter",
["Glorious Smoke Grenade"]="https://tr.rbxcdn.com/180DAY-914382ed3746eae299fd06b9a6dca006/150/150/Image/Png/noFilter",
["Hourglass"]="https://tr.rbxcdn.com/180DAY-4aececce1e4c778c34f5f238734cdaed/150/150/Image/Png/noFilter",
["Snowglobe"]="https://tr.rbxcdn.com/180DAY-ae626cf690d265137f9b2699b2c5e8fd/150/150/Image/Png/noFilter",
["Sniper"]="https://tr.rbxcdn.com/180DAY-a0f93ffce0844cd4d83ead3ba9488b76/150/150/Image/Png/noFilter",
["Campfire Sniper"]="https://tr.rbxcdn.com/180DAY-2b07107485879e6f4a94bd3bd04cdeba/150/150/Image/Png/noFilter",
["Event Horizon"]="https://tr.rbxcdn.com/180DAY-2477e98ea491de8ac719b579eb48fbcb/150/150/Image/Png/noFilter",
["Eyething Sniper"]="https://tr.rbxcdn.com/180DAY-1e5aa4cee03c804ea199ca1b6e7e6fc5/150/150/Image/Png/noFilter",
["Gingerbread Sniper"]="https://tr.rbxcdn.com/180DAY-52aa68d80cd8ecf0a3b56b30742579c5/150/150/Image/Png/noFilter",
["Glorious Sniper"]="https://tr.rbxcdn.com/180DAY-d41530db958beb1fd0419b1572f58810/150/150/Image/Png/noFilter",
["Hyper Sniper"]="https://tr.rbxcdn.com/180DAY-515a7867be15bf77fbaa409a19f8b0fa/150/150/Image/Png/noFilter",
["Keyper"]="https://tr.rbxcdn.com/180DAY-775a27c2bf3791d7768ccd74229487e1/150/150/Image/Png/noFilter",
["Kraken Sniper"]="https://tr.rbxcdn.com/180DAY-2265a99e840b94129f0ff00ad5bbadca/150/150/Image/Png/noFilter",
["Light Fifty"]="https://tr.rbxcdn.com/180DAY-9159d56ab0794f1e4099cade30f98d3b/150/150/Image/Png/noFilter",
["Pixel Sniper"]="https://tr.rbxcdn.com/180DAY-0f8f3257cf04587312ac8b4d09548616/150/150/Image/Png/noFilter",
["Spear"]="https://tr.rbxcdn.com/180DAY-f23f7235d8a1e0b855ae88d0907b5d77/150/150/Image/Png/noFilter",
["Chark Kebab"]="https://tr.rbxcdn.com/180DAY-2c7ba048d263d792f8ff4ec3b04182f0/150/150/Image/Png/noFilter",
["Fork"]="https://tr.rbxcdn.com/180DAY-e84742a90d013b38411cf05577f9a30b/150/150/Image/Png/noFilter",
["Giant Pencil"]="https://tr.rbxcdn.com/180DAY-19f70a1e4347c885ae59a4b3d82d825b/150/150/Image/Png/noFilter",
["Glorious Spear"]="https://tr.rbxcdn.com/180DAY-3e01a7ba640c66e1180738f76bcf8cc0/150/150/Image/Png/noFilter",
["Plunger"]="https://tr.rbxcdn.com/180DAY-2f4bebef65d21d99e6d6d75a78620d29/150/150/Image/Png/noFilter",
["Studio Light"]="https://tr.rbxcdn.com/180DAY-67a40b3a5a54f75f13b6df6c957eb141/150/150/Image/Png/noFilter",
["Thunderpike"]="https://tr.rbxcdn.com/180DAY-00ec3dc96f936521562b7b9e22fca3ae/150/150/Image/Png/noFilter",
["Spray"]="https://tr.rbxcdn.com/180DAY-143e1689a943e29730dc5c48f49cec14/150/150/Image/Png/noFilter",
["Boneclaw Spray"]="https://tr.rbxcdn.com/180DAY-7a4b502bd37fd73080272ee6ff1bf99e/150/150/Image/Png/noFilter",
["Campfire Spray"]="https://tr.rbxcdn.com/180DAY-7399f550014edb5fa842aabbfbde1cef/150/150/Image/Png/noFilter",
["Glorious Spray"]="https://tr.rbxcdn.com/180DAY-18c1ae7c90e98760d9ba047f0c90248f/150/150/Image/Png/noFilter",
["Key Spray"]="https://tr.rbxcdn.com/180DAY-207c29cff02388c7149ab8957bcb199e/150/150/Image/Png/noFilter",
["Lovely Spray"]="https://tr.rbxcdn.com/180DAY-7c3deafb81587522e2abdf28b3cfabf3/150/150/Image/Png/noFilter",
["Nail Gun"]="https://tr.rbxcdn.com/180DAY-98cba4f37dbb7ae6f4da4343f34c34be/150/150/Image/Png/noFilter",
["Pine Spray"]="https://tr.rbxcdn.com/180DAY-35bcbd63cc8b566ed70ef79e6aab2830/150/150/Image/Png/noFilter",
["Spray Bottle"]="https://tr.rbxcdn.com/180DAY-dfa9a8aa4e4f4e7715d60975bcbabb90/150/150/Image/Png/noFilter",
["Subspace Tripmine"]="https://tr.rbxcdn.com/180DAY-c32cae106e98e5488262f73058609dd4/150/150/Image/Png/noFilter",
["Dev-in-the-Box"]="https://tr.rbxcdn.com/180DAY-eb09e77bc23dbfd5ae824d18e91cf40c/150/150/Image/Png/noFilter",
["DIY Tripmine"]="https://tr.rbxcdn.com/180DAY-4fd5adfd0e2dff1e0359d4562a65cc36/150/150/Image/Png/noFilter",
["Don't Press"]="https://tr.rbxcdn.com/180DAY-a28dd6f3f8559689699666266ebb87b2/150/150/Image/Png/noFilter",
["Glorious Subspace Tripmine"]="https://tr.rbxcdn.com/180DAY-2eb7c1a5a7a6c242ad4fcd3a8ceddc37/150/150/Image/Png/noFilter",
["Hazard Sign"]="https://tr.rbxcdn.com/180DAY-0d773c4fc8e2085d28ef35347379ba8c/150/150/Image/Png/noFilter",
["Pot o' Keys"]="https://tr.rbxcdn.com/180DAY-1aea0f026fc8c1379d8cc2c20c8db32d/150/150/Image/Png/noFilter",
["Spring"]="https://tr.rbxcdn.com/180DAY-413a5b5506a320f92a5d29dc0229a892/150/150/Image/Png/noFilter",
["Trick or Treat"]="https://tr.rbxcdn.com/180DAY-7721092474f1bfc71d8a03fc0d120c6e/150/150/Image/Png/noFilter",
["Trowel"]="https://tr.rbxcdn.com/180DAY-e9e0bb238c4c60c64c1aa18bab220729/150/150/Image/Png/noFilter",
["Garden Shovel"]="https://tr.rbxcdn.com/180DAY-f2e47ae51290fdd3a9621018ab50f431/150/150/Image/Png/noFilter",
["Glorious Trowel"]="https://tr.rbxcdn.com/180DAY-37747b0f2a409976090ff53e934b12bc/150/150/Image/Png/noFilter",
["Paintbrush"]="https://tr.rbxcdn.com/180DAY-1b582d10efe944101c837adf95e01043/150/150/Image/Png/noFilter",
["Plastic Shovel"]="https://tr.rbxcdn.com/180DAY-a4848f2b65ad6f399c70ea76cdec61ea/150/150/Image/Png/noFilter",
["Pumpkin Carver"]="https://tr.rbxcdn.com/180DAY-bbf38659fabc05c1b9346c11c47aa1b3/150/150/Image/Png/noFilter",
["Scooper"]="https://tr.rbxcdn.com/180DAY-1b5c7d618e794b270b7d66a666a2ac67/150/150/Image/Png/noFilter",
["Snow Shovel"]="https://tr.rbxcdn.com/180DAY-e1afafa2d89a23f58efb4afb2a41fd14/150/150/Image/Png/noFilter",
["Uzi"]="https://tr.rbxcdn.com/180DAY-be3ec3e88a6d98f35ce8b6351246fcdb/150/150/Image/Png/noFilter",
["Arch Uzi"]="https://tr.rbxcdn.com/180DAY-8172b45542bbe72a017e504e948e02c3/150/150/Image/Png/noFilter",
["Demon Uzi"]="https://tr.rbxcdn.com/180DAY-9d32251dd09043953059e0c8a2af0dae/150/150/Image/Png/noFilter",
["Ducky Uzi"]="https://tr.rbxcdn.com/180DAY-3b3155976c309f39c4e595691031c83b/150/150/Image/Png/noFilter",
["Electro Uzi"]="https://tr.rbxcdn.com/180DAY-b9df7b5f800c8380280cdbe86224c80a/150/150/Image/Png/noFilter",
["Glorious Uzi"]="https://tr.rbxcdn.com/180DAY-dd001cc73278517bd3385ecb99aadc4e/150/150/Image/Png/noFilter",
["Keyzi"]="https://tr.rbxcdn.com/180DAY-262f9fbf4dccfe5331c6696bfe6e449a/150/150/Image/Png/noFilter",
["Money Gun"]="https://tr.rbxcdn.com/180DAY-a8da966f436b2b1079bd5167b2180498/150/150/Image/Png/noFilter",
["Pine Uzi"]="https://tr.rbxcdn.com/180DAY-b6497a4b261f04c574a3fc46e27de542/150/150/Image/Png/noFilter",
["Water Uzi"]="https://tr.rbxcdn.com/180DAY-28432ee0ea36de93ac11b4ece4f692bb/150/150/Image/Png/noFilter",
["War Horn"]="https://tr.rbxcdn.com/180DAY-96a60153c000c68438f1bc3b23bdcad4/150/150/Image/Png/noFilter",
["Air Horn"]="https://tr.rbxcdn.com/180DAY-7727867771690bd14d9cccdf0222c601/150/150/Image/Png/noFilter",
["Boneclaw Horn"]="https://tr.rbxcdn.com/180DAY-bb94398469ef1e58f2630c40dffad799/150/150/Image/Png/noFilter",
["Glorious War Horn"]="https://tr.rbxcdn.com/180DAY-fbc2927d069b3efd8ccd5a26397456d7/150/150/Image/Png/noFilter",
["Lifeguard Whistle"]="https://tr.rbxcdn.com/180DAY-3e19c078d79478f5a7480207a7217f1b/150/150/Image/Png/noFilter",
["Mammoth Horn"]="https://tr.rbxcdn.com/180DAY-4a484ea8fe09f052c2f5fc8004cd24f3/150/150/Image/Png/noFilter",
["Megaphone"]="https://tr.rbxcdn.com/180DAY-be92fd3ae5b87e106a3543aa4cf40a8c/150/150/Image/Png/noFilter",
["Trumpet"]="https://tr.rbxcdn.com/180DAY-a6fb8af146abce08ca7c6de826ac52af/150/150/Image/Png/noFilter",
["Warper"]="https://tr.rbxcdn.com/180DAY-958ea3966fe1172f01a47ddab8f81269/150/150/Image/Png/noFilter",
["Arcane Warper"]="https://tr.rbxcdn.com/180DAY-1fb474fa113caa3c6d0e2f3efcd4220a/150/150/Image/Png/noFilter",
["Bubbler"]="https://tr.rbxcdn.com/180DAY-34e0d1aeecd65cebc90f6f41a0f94a76/150/150/Image/Png/noFilter",
["Electropunk Warper"]="https://tr.rbxcdn.com/180DAY-50c4b2d14510e2166117d1bda2ad5041/150/150/Image/Png/noFilter",
["Experiment W4"]="https://tr.rbxcdn.com/180DAY-48e9589c1857b52346bec08ebeae5816/150/150/Image/Png/noFilter",
["Frost Warper"]="https://tr.rbxcdn.com/180DAY-13f84022204094f9cb8e52b38cc982d6/150/150/Image/Png/noFilter",
["Glitter Warper"]="https://tr.rbxcdn.com/180DAY-8de23c423caee90470b4802c8a0660b0/150/150/Image/Png/noFilter",
["Glorious Warper"]="https://tr.rbxcdn.com/180DAY-6d46ea279e9df260b032ed08c060400e/150/150/Image/Png/noFilter",
["Hotel Bell"]="https://tr.rbxcdn.com/180DAY-c9099f650e138aa48391add10dd6dd85/150/150/Image/Png/noFilter",
["Warpstone"]="https://tr.rbxcdn.com/180DAY-ee44bdceb7c841459d3ce241303eece0/150/150/Image/Png/noFilter",
["Cyber Warpstone"]="https://tr.rbxcdn.com/180DAY-c273014cc57ef82dfa8a029da1feb6c1/150/150/Image/Png/noFilter",
["Electropunk Warpstone"]="https://tr.rbxcdn.com/180DAY-eeeb45fd7302ec2663f3f68a080d429f/150/150/Image/Png/noFilter",
["Glorious Warpstone"]="https://tr.rbxcdn.com/180DAY-2856c5523f0263bc297a4085fb69af50/150/150/Image/Png/noFilter",
["Teleport Disc"]="https://tr.rbxcdn.com/180DAY-3447947d09129e3be91fb87ab1deef03/150/150/Image/Png/noFilter",
["Unstable Warpstone"]="https://tr.rbxcdn.com/180DAY-09e9f6dc5098d6949be1d584d0985642/150/150/Image/Png/noFilter",
["Warp Juice"]="https://tr.rbxcdn.com/180DAY-249fa6124e2bbf32812e4f76cab7a8f1/150/150/Image/Png/noFilter",
["Warpbone"]="https://tr.rbxcdn.com/180DAY-e55f2600b958a99d6bf86855f05e4692/150/150/Image/Png/noFilter",
["Warpeye"]="https://tr.rbxcdn.com/180DAY-3f5550ccf5d04e3d861107e72a5f7fd1/150/150/Image/Png/noFilter",
["Warpstar"]="https://tr.rbxcdn.com/180DAY-d3b41f37d344fd858039e8c13b6023df/150/150/Image/Png/noFilter",
["Wildcat"]="https://tr.rbxcdn.com/180DAY-db64e76ffb0a2ecf8ff50801dedfc7fd/150/150/Image/Png/noFilter",
["Glorious Wildcat"]="https://tr.rbxcdn.com/180DAY-58aa5ff30fdca897d731253812b2588f/150/150/Image/Png/noFilter",
["Plasma Wildcat"]="https://tr.rbxcdn.com/180DAY-cd2e3efdb86ae2587933032cb330358a/150/150/Image/Png/noFilter",
}
local SKIN_RARITY = {
["Assault Rifle"]="Common",
["10B Visits"]="Unique",
["AK-47"]="Rare",
["AKEY-47"]="Mythical",
["Augmented Rifle"]="Legendary",
["Boneclaw Rifle"]="Rare",
["Drum Gun"]="Legendary",
["Gingerbread Augmented Rifle"]="Legendary",
["Glorious Assault Rifle"]="Common",
["Pearl Rifle"]="Rare",
["Phoenix Rifle"]="Common",
["Battle Axe"]="Common",
["Balloon Axe"]="Legendary",
["Ban Axe"]="Common",
["Cerulean Axe"]="Rare",
["Glorious Battle Axe"]="Common",
["Keyttle Axe"]="Mythical",
["Mimic Axe"]="Legendary",
["Nordic Axe"]="Common",
["Street Sign"]="Legendary",
["The Shred"]="Legendary",
["Tiki Axe"]="Rare",
["Bow"]="Common",
["Balloon Bow"]="Legendary",
["Bat Bow"]="Rare",
["Beloved Bow"]="Legendary",
["Compound Bow"]="Common",
["Dream Bow"]="Rare",
["Frostbite Bow"]="Rare",
["Glorious Bow"]="Common",
["Key Bow"]="Mythical",
["Palm Bow"]="Rare",
["Raven Bow"]="Rare",
["Burst Rifle"]="Common",
["Aqua Burst"]="Rare",
["Bullpup Burst"]="Legendary",
["Electro Rifle"]="Legendary",
["Glorious Burst Rifle"]="Common",
["Keyst Rifle"]="Mythical",
["Pine Burst"]="Common",
["Pixel Burst"]="Legendary",
["Sand Bullpup Burst"]="Legendary",
["Spectral Burst"]="Common",
["Chainsaw"]="Common",
["Blobsaw"]="Rare",
["Buzzsaw"]="Legendary",
["Festive Buzzsaw"]="Legendary",
["Glorious Chainsaw"]="Common",
["Handsaws"]="Legendary",
["Mega Drill"]="Legendary",
["Sharksaw"]="Common",
["Crossbow"]="Common",
["Arch Crossbow"]="Mythical",
["Campfire Crossbow"]="Common",
["Crossbone"]="Common",
["Frostbite Crossbow"]="Rare",
["Glorious Crossbow"]="Common",
["Harpoon Crossbow"]="Rare",
["Pixel Crossbow"]="Legendary",
["Violin Crossbow"]="Rare",
["Daggers"]="Common",
["Aces"]="Rare",
["Bat Daggers"]="Rare",
["Broken Hearts"]="Legendary",
["Cookies"]="Rare",
["Crystal Daggers"]="Mythical",
["Glorious Daggers"]="Common",
["Keynais"]="Mythical",
["Paper Planes"]="Common",
["Shurikens"]="Common",
["Starfish"]="Common",
["Toaster"]="Legendary",
["Distortion"]="Common",
["Bubble Distortion"]="Rare",
["Cyber Distortion"]="Common",
["Electropunk Distortion"]="Rare",
["Experiment D15"]="Legendary",
["Glorious Distortion"]="Common",
["Magma Distortion"]="Rare",
["Plasma Distortion"]="Rare",
["Sleighstortion"]="Rare",
["Energy Pistols"]="Common",
["Apex Pistols"]="Rare",
["Enerkey Pistols"]="Mythical",
["Glorious Energy Pistols"]="Common",
["Hacker Pistols"]="Rare",
["Hydro Pistols"]="Rare",
["Hyperlaser Guns"]="Legendary",
["New Year Energy Pistols"]="Rare",
["Sol Pistols"]="Rare",
["Soul Pistols"]="Legendary",
["Void Pistols"]="Legendary",
["Energy Rifle"]="Common",
["Apex Rifle"]="Rare",
["Enerkey Rifle"]="Mythical",
["Glorious Energy Rifle"]="Common",
["Hacker Rifle"]="Rare",
["Hydro Rifle"]="Rare",
["New Year Energy Rifle"]="Rare",
["Sol Rifle"]="Rare",
["Soul Rifle"]="Legendary",
["Void Rifle"]="Legendary",
["Exogun"]="Common",
["Exogourd"]="Rare",
["Glorious Exogun"]="Common",
["Midnight Festive Exogun"]="Common",
["Pearl Exogun"]="Rare",
["Ray Gun"]="Rare",
["Repulsor"]="Legendary",
["Singularity"]="Legendary",
["Wondergun"]="Rare",
["Fists"]="Common",
["Boxing Gloves"]="Rare",
["Brass Knuckles"]="Common",
["Crab Claws"]="Legendary",
["Festive Fists"]="Common",
["Fist"]="Legendary",
["Fists of Hurt"]="Rare",
["Glorious Fists"]="Common",
["Pirate Hook"]="Legendary",
["Pumpkin Claws"]="Common",
["Spy Gloves"]="Common",
["Flamethrower"]="Common",
["Bubblethrower"]="Rare",
["Extinguisher"]="Legendary",
["Glitterthrower"]="Rare",
["Glorious Flamethrower"]="Common",
["Jack O'Thrower"]="Rare",
["Keythrower"]="Mythical",
["Lamethrower"]="Common",
["Pixel Flamethrower"]="Legendary",
["Rainbowthrower"]="Legendary",
["Snowblower"]="Rare",
["Flare Gun"]="Common",
["Banana Flare"]="Legendary",
["Dynamite Gun"]="Rare",
["Firework Gun"]="Legendary",
["Glorious Flare Gun"]="Common",
["Pocket Volcano"]="Legendary",
["Vexed Flare Gun"]="Legendary",
["Wrapped Flare Gun"]="Common",
["Flashbang"]="Common",
["Camera"]="Legendary",
["Disco Ball"]="Legendary",
["Glorious Flashbang"]="Common",
["Lightbulb"]="Common",
["Pixel Flashbang"]="Legendary",
["Shining Star"]="Rare",
["Skullbang"]="Common",
["Sol"]="Legendary",
["Freeze Ray"]="Common",
["Bubble Ray"]="Rare",
["Cooler"]="Legendary",
["Glorious Freeze Ray"]="Common",
["Gum Ray"]="Rare",
["Spider Ray"]="Legendary",
["Temporal Ray"]="Legendary",
["Wrapped Freeze Ray"]="Common",
["Grappler"]="Common",
["Arcade Claw"]="Legendary",
["Fishing Rod"]="Legendary",
["Genie Lamp"]="Legendary",
["Glorious Grappler"]="Common",
["Lasso"]="Legendary",
["Lifeguard Grappler"]="Common",
["Grenade"]="Common",
["Cuddle Bomb"]="Legendary",
["Dynamite"]="Common",
["Fizz Bomb"]="Legendary",
["Frozen Grenade"]="Common",
["Glorious Grenade"]="Common",
["Jingle Grenade"]="Rare",
["Keynade"]="Mythical",
["Soul Grenade"]="Legendary",
["Water Balloon"]="Rare",
["Whoopee Cushion"]="Legendary",
["Grenade Launcher"]="Common",
["Balloon Launcher"]="Legendary",
["Coconut Launcher"]="Rare",
["Gearnade Launcher"]="Rare",
["Glorious Grenade Launcher"]="Common",
["Skull Launcher"]="Legendary",
["Snowball Launcher"]="Rare",
["Swashbuckler"]="Legendary",
["Uranium Launcher"]="Rare",
["Gunblade"]="Common",
["Boneblade"]="Common",
["Crude Gunblade"]="Common",
["Elf's Gunblade"]="Common",
["Glorious Gunblade"]="Common",
["Gunsaw"]="Legendary",
["Hyper Gunblade"]="Legendary",
["Keyblade"]="Mythical",
["Sharkbite"]="Common",
["Handgun"]="Common",
["Blaster"]="Rare",
["Gingerbread Handgun"]="Rare",
["Glorious Handgun"]="Common",
["Gumball Handgun"]="Common",
["Hand Gun"]="Legendary",
["Pixel Handgun"]="Legendary",
["Pumpkin Handgun"]="Common",
["Sandgun"]="Rare",
["Stealth Handgun"]="Unobtainable",
["Towerstone Handgun"]="Common",
["Warp Handgun"]="Common",
["Jump Pad"]="Common",
["Bounce House"]="Rare",
["Flamingo Floatie"]="Common",
["Glorious Jump Pad"]="Common",
["Jolly Man"]="Rare",
["Shady Chicken Sandwich"]="Rare",
["Spider Web"]="Common",
["Trampoline"]="Common",
["Katana"]="Common",
["Arch Katana"]="Mythical",
["Crystal Katana"]="Mythical",
["Cutlass"]="Legendary",
["Evil Trident"]="Rare",
["Glorious Katana"]="Common",
["Keytana"]="Mythical",
["Lightning Bolt"]="Rare",
["Linked Sword"]="Legendary",
["New Year Katana"]="Rare",
["Pixel Katana"]="Legendary",
["Riptide Katana"]="Mythical",
["Saber"]="Legendary",
["Stellar Katana"]="Rare",
["Swordfish"]="Common",
["Knife"]="Common",
["Armature.001"]="Genuine",
["Balisong"]="Legendary",
["Birthday Candle"]="Common",
["Caladbolg"]="Legendary",
["Candy Cane"]="Legendary",
["Chancla"]="Common",
["Glorious Knife"]="Common",
["Karambit"]="Legendary",
["Keylisong"]="Mythical",
["Keyrambit"]="Mythical",
["Machete"]="Common",
["Pencil"]="Legendary",
["Shark Tooth"]="Common",
["Trophy Knife"]="Genuine",
["Maul"]="Common",
["Ban Hammer"]="Legendary",
["Clown Hammer"]="Rare",
["Excalibur"]="Common",
["Giant Popsicle"]="Common",
["Glorious Maul"]="Common",
["Ice Maul"]="Common",
["Sleigh Maul"]="Rare",
["Starforge Maul"]="Rare",
["Medkit"]="Common",
["Box of Chocolates"]="Legendary",
["Briefcase"]="Rare",
["Bucket of Candy"]="Legendary",
["Glorious Medkit"]="Common",
["Ice Cream"]="Legendary",
["Laptop"]="Legendary",
["Medkitty"]="Legendary",
["Milk & Cookies"]="Legendary",
["Sandwich"]="Legendary",
["Minigun"]="Common",
["Fighter Jet"]="Legendary",
["Glorious Minigun"]="Common",
["Lasergun 3000"]="Legendary",
["Pixel Minigun"]="Legendary",
["Pumpkin Minigun"]="Common",
["Shark Minigun"]="Rare",
["Wrapped Minigun"]="Common",
["Molotov"]="Common",
["Arch Molotov"]="Mythical",
["Campfire Stick"]="Common",
["Coffee"]="Common",
["Glorious Molotov"]="Common",
["Hot Coals"]="Legendary",
["Lava Lamp"]="Rare",
["Ship In A Bottle"]="Legendary",
["Torch"]="Common",
["Vexed Candle"]="Legendary",
["Paintball Gun"]="Common",
["Boba Gun"]="Legendary",
["Brain Gun"]="Rare",
["Glorious Paintball Gun"]="Common",
["Ketchup Gun"]="Common",
["Lemonade Gun"]="Common",
["Paintballoon Gun"]="Legendary",
["Slime Gun"]="Rare",
["Snowball Gun"]="Rare",
["Permafrost"]="Common",
["Glorious Permafrost"]="Common",
["Ice Permafrost"]="Common",
["Permafrost.rbxm"]="Rare",
["Permasand"]="Rare",
["Snowman Permafrost"]="Common",
["Starforge Permafrost"]="Rare",
["Temporal Permafrost"]="Legendary",
["RPG"]="Common",
["Cupcake Launcher"]="Legendary",
["Firework Launcher"]="Legendary",
["Glorious RPG"]="Common",
["Nuke Launcher"]="Legendary",
["Pencil Launcher"]="Common",
["Pumpkin Launcher"]="Legendary",
["Rocket Launcher"]="Legendary",
["RPKEY"]="Mythical",
["Spaceship Launcher"]="Legendary",
["Squid Launcher"]="Rare",
["Sundae Launcher"]="Rare",
["Revolver"]="Common",
["Boneclaw Revolver"]="Rare",
["Cruise Revolver"]="Legendary",
["Desert Eagle"]="Rare",
["Glorious Revolver"]="Common",
["Keyvolver"]="Mythical",
["Peppergun"]="Legendary",
["Peppermint Sheriff"]="Legendary",
["Sheriff"]="Legendary",
["Riot Shield"]="Common",
["Broken Surfboard"]="Common",
["Door"]="Common",
["Energy Shield"]="Rare",
["Glorious Riot Shield"]="Common",
["Masterpiece"]="Rare",
["Sled"]="Common",
["Tombstone Shield"]="Common",
["Satchel"]="Common",
["Advanced Satchel"]="Rare",
["Bag o' Money"]="Common",
["Glorious Satchel"]="Common",
["Lifeguard Satchel"]="Common",
["Notebook Satchel"]="Common",
["Pizza Box"]="Legendary",
["Potion Satchel"]="Rare",
["Suspicious Gift"]="Common",
["Scythe"]="Common",
["Anchor"]="Rare",
["Bat Scythe"]="Rare",
["Bug Net"]="Genuine",
["Cryo Scythe"]="Rare",
["Crystal Scythe"]="Mythical",
["Glorious Scythe"]="Common",
["Keythe"]="Mythical",
["Palm Scythe"]="Legendary",
["Plastic Flamingo"]="Common",
["Sakura Scythe"]="Rare",
["Scythe of Death"]="Rare",
["Shorty"]="Common",
["Balloon Shorty"]="Legendary",
["Bubble Shorty"]="Rare",
["Cannon Shorty"]="Legendary",
["Demon Shorty"]="Rare",
["Glorious Shorty"]="Common",
["Lovely Shorty"]="Common",
["Not So Shorty"]="Common",
["Too Shorty"]="Common",
["Wrapped Shorty"]="Common",
["Shotgun"]="Common",
["Balloon Shotgun"]="Legendary",
["Broomstick"]="Rare",
["Cactus Shotgun"]="Common",
["Glorious Shotgun"]="Common",
["Hyper Shotgun"]="Legendary",
["Shark Shotgun"]="Legendary",
["Shotkey"]="Mythical",
["Wrapped Shotgun"]="Common",
["Slingshot"]="Common",
["Boneshot"]="Rare",
["Glorious Slingshot"]="Common",
["Goalpost"]="Common",
["Harp"]="Legendary",
["Keyshot"]="Mythical",
["Lucky Horseshoe"]="Legendary",
["Palmshot"]="Common",
["Reindeer Slingshot"]="Rare",
["Stick"]="Common",
["Smoke Grenade"]="Common",
["Balance"]="Common",
["Beach Ball"]="Common",
["Emoji Cloud"]="Legendary",
["Eyeball"]="Legendary",
["Glorious Smoke Grenade"]="Common",
["Hourglass"]="Rare",
["Snowglobe"]="Rare",
["Sniper"]="Common",
["Campfire Sniper"]="Common",
["Event Horizon"]="Legendary",
["Eyething Sniper"]="Common",
["Gingerbread Sniper"]="Rare",
["Glorious Sniper"]="Common",
["Hyper Sniper"]="Legendary",
["Keyper"]="Mythical",
["Kraken Sniper"]="Legendary",
["Light Fifty"]="Legendary",
["Pixel Sniper"]="Legendary",
["Spear"]="Common",
["Chark Kebab"]="Common",
["Fork"]="Common",
["Giant Pencil"]="Common",
["Glorious Spear"]="Common",
["Plunger"]="Rare",
["Studio Light"]="Common",
["Thunderpike"]="Rare",
["Spray"]="Common",
["Boneclaw Spray"]="Rare",
["Campfire Spray"]="Legendary",
["Glorious Spray"]="Common",
["Key Spray"]="Mythical",
["Lovely Spray"]="Common",
["Nail Gun"]="Common",
["Pine Spray"]="Common",
["Spray Bottle"]="Legendary",
["Subspace Tripmine"]="Common",
["Dev-in-the-Box"]="Legendary",
["DIY Tripmine"]="Common",
["Don't Press"]="Legendary",
["Glorious Subspace Tripmine"]="Common",
["Hazard Sign"]="Legendary",
["Pot o' Keys"]="Legendary",
["Spring"]="Rare",
["Trick or Treat"]="Common",
["Trowel"]="Common",
["Garden Shovel"]="Rare",
["Glorious Trowel"]="Common",
["Paintbrush"]="Rare",
["Plastic Shovel"]="Rare",
["Pumpkin Carver"]="Rare",
["Scooper"]="Rare",
["Snow Shovel"]="Rare",
["Uzi"]="Common",
["Arch Uzi"]="Mythical",
["Demon Uzi"]="Rare",
["Ducky Uzi"]="Common",
["Electro Uzi"]="Legendary",
["Glorious Uzi"]="Common",
["Keyzi"]="Mythical",
["Money Gun"]="Legendary",
["Pine Uzi"]="Common",
["Water Uzi"]="Rare",
["War Horn"]="Common",
["Air Horn"]="Rare",
["Boneclaw Horn"]="Rare",
["Glorious War Horn"]="Common",
["Lifeguard Whistle"]="Legendary",
["Mammoth Horn"]="Common",
["Megaphone"]="Common",
["Trumpet"]="Rare",
["Warper"]="Common",
["Arcane Warper"]="Legendary",
["Bubbler"]="Rare",
["Electropunk Warper"]="Rare",
["Experiment W4"]="Legendary",
["Frost Warper"]="Rare",
["Glitter Warper"]="Rare",
["Glorious Warper"]="Common",
["Hotel Bell"]="Legendary",
["Warpstone"]="Common",
["Cyber Warpstone"]="Common",
["Electropunk Warpstone"]="Rare",
["Glorious Warpstone"]="Common",
["Teleport Disc"]="Legendary",
["Unstable Warpstone"]="Rare",
["Warp Juice"]="Rare",
["Warpbone"]="Common",
["Warpeye"]="Mythical",
["Warpstar"]="Legendary",
["Wildcat"]="Common",
["Glorious Wildcat"]="Common",
["Plasma Wildcat"]="Rare",
}

-- Rivals client UI: retained Drawing components, separate from the skin engine.
local mouse=game:GetService("Players").LocalPlayer:GetMouse()
local rgb=Color3.fromRGB
local P={}
local ACCENTS={Periwinkle={159,177,247},Mint={116,217,189},Rose={227,159,181}}
local function theme()
    local dark=SETTINGS.theme=="Darker"
    P.bg=dark and rgb(10,12,17) or rgb(18,21,29);P.panel=dark and rgb(17,20,27) or rgb(25,29,39)
    P.field=dark and rgb(26,30,40) or rgb(34,40,53);P.line=rgb(47,54,69)
    P.text=rgb(236,239,247);P.muted=rgb(150,160,182);P.faint=rgb(110,123,146);P.red=rgb(223,112,128)
    local a=ACCENTS[SETTINGS.accent] or ACCENTS.Periwinkle;P.accent=rgb(a[1],a[2],a[3]);P.white=rgb(255,255,255)
end
theme()
state.drawings,state.hitboxes={},{}
state.imageCache,state.imageQueue,state.imageQueued={},{},{}
state.visible=not SETTINGS.startMinimized;state.page="Skins";state.category="Primary";state.offset=0
state.query="";state.skinQuery="";state.previewWeapon=CATALOG[1];state.previewName=state.selections[CATALOG[1].name]
if state.previewName=="Default" then state.previewName=CATALOG[1].name end
state.zoom=1;state.previewPhase=0;state.animate=SETTINGS.rotation;state.settingsGroup="General"
state.dirty=true;state.x,state.y,state.w,state.h=50,50,1100,720
if SETTINGS.rememberWindow and type(SAVED.window)=="table" then
    for _,k in ipairs({"x","y","w","h"}) do if type(SAVED.window[k])=="number" then state[k]=SAVED.window[k] end end
end
local function clampWindow()
    local view=workspace.CurrentCamera.ViewportSize
    SETTINGS.scale=math.min(SETTINGS.scale,view.X/940,view.Y/620)
    state.w=math.max(math.min(940*SETTINGS.scale,view.X),math.min(state.w,view.X))
    state.h=math.max(math.min(620*SETTINGS.scale,view.Y),math.min(state.h,view.Y))
    state.x=math.max(0,math.min(state.x,view.X-state.w));state.y=math.max(0,math.min(state.y,view.Y-state.h))
end
clampWindow()
local dirtySave=false
function state.Save()
    if not writefile then return false end
    local data={settings=SETTINGS,favorites=FAVORITES}
    if SETTINGS.rememberWindow then data.window={x=state.x,y=state.y,w=state.w,h=state.h} end
    if SETTINGS.rememberSelections then data.selections=state.selections end
    local ok=pcall(function() writefile("rivals_skin_changer_settings.json",game:GetService("HttpService"):JSONEncode(data)) end)
    dirtySave=false;return ok
end
local function mark() state.dirty=true end
local function changed() dirtySave=true;mark() end
local function motionAllowed() return SETTINGS.animations and not SETTINGS.reduceMotion and not SETTINGS.lowPower end
local transitionAt=0;local visibility=0;local closePending=false
local function transition() transitionAt=motionAllowed() and tick() or 0;mark() end
local function navigate(page) state.page=page;state.offset=0;state.query="";state.focus=nil;state.dropdown=nil;transition() end
local function favoriteKey(w,skin) return w.name.."|"..skin end
local function favorite(w,skin) local k=favoriteKey(w,skin);FAVORITES[k]=not FAVORITES[k] or nil;changed() end
local function choose(w,skin)
    if state.unavailable[skin] then state.status=state.unavailable[skin];mark();return end
    selectSkin(w,validSkin(w,skin));state.previewWeapon=w;state.previewName=skin=="Default" and w.name or skin;state.previewPhase=0;changed()
end
local function openSelector(w)
    state.dropdown=w;state.skinQuery="";state.skinOffset=0;state.previewWeapon=w
    local s=state.selections[w.name];state.previewName=s=="Default" and w.name or s
    state.focus=nil;transition()
end
local function requestReset()
    if SETTINGS.confirmReset then state.confirm="reset";transition() else resetSelections();changed() end
end
local function setAuto(value) SETTINGS.autoApply=value;state.autoApply=value;if value then request("apply") end;changed() end
function state.ReleaseInput() if state.inputCaptured and setrobloxinput then pcall(setrobloxinput,true) end;state.inputCaptured=false end
local function captureInput(value)
    if value then if not state.inputCaptured and setrobloxinput then local ok,r=pcall(setrobloxinput,false);state.inputCaptured=ok and r~=false end
    else state.ReleaseInput() end
end
local pool=0;local offsetY=0;local displayedOffsetY=0;local hoverAt=0;local switches={};local animateUntil=0
local function assign(item,k,v)
    local old=item.cache[k];local eq=old==v
    if not eq and (k=="Size" or k=="Position") and old and type(v)~="number" then eq=old.X==v.X and old.Y==v.Y end
    if not eq then item.object[k]=v;item.cache[k]=v end
end
local function draw(kind,x,y,props)
    pool=pool+1;local item=state.drawings[pool]
    if item and item.kind~=kind then item.object:Remove();item=nil end
    if not item then item={kind=kind,object=Drawing.new(kind),cache={}};state.drawings[pool]=item end
    item.x,item.y=x,y;item.used=true
    assign(item,"Position",Vector2.new(state.x+x*SETTINGS.scale,state.y+(y+offsetY)*SETTINGS.scale))
    for k,v in pairs(props) do
        if k=="_size" then if item.canSize~=false then local ok=pcall(assign,item,"Size",v*SETTINGS.scale);item.canSize=ok end
        elseif k=="Size" then assign(item,k,Vector2.new(v.X*SETTINGS.scale,v.Y*SETTINGS.scale))
        elseif k=="Radius" then assign(item,k,v*SETTINGS.scale)
        else assign(item,k,v) end
    end
    assign(item,"Visible",visibility>0);return item
end
local function rect(x,y,w,h,c,z) return draw("Square",x,y,{Size=Vector2.new(math.max(0,w),math.max(0,h)),Color=c,Filled=true,Transparency=SETTINGS.opacity,ZIndex=z or 10}) end
local function label(t,x,y,c,size,z)
    local props={Text=t,Color=c or P.text,_size=size or 13,Outline=false,Center=false,Transparency=1,ZIndex=z or 20}
    if Drawing.Fonts and Drawing.Fonts.System then props.Font=Drawing.Fonts.System end
    return draw("Text",x,y,props)
end
local function round(x,y,w,h,c,z,r)
    r=math.min(r or SETTINGS.radius,h/2,w/2)
    if r<1 then rect(x,y,w,h,c,z);return end
    rect(x+r,y,w-2*r,h,c,z);rect(x,y+r,w,h-2*r,c,z)
    for _,p in ipairs({{x+r,y+r},{x+w-r,y+r},{x+r,y+h-r},{x+w-r,y+h-r}}) do draw("Circle",p[1],p[2],{Radius=r,Color=c,Filled=true,NumSides=16,Transparency=SETTINGS.opacity,ZIndex=z or 10}) end
end
local function short(t,n) t=tostring(t);return #t>n and t:sub(1,math.max(1,n-3)).."..." or t end
local function hit(id,x,y,w,h,cb,modal) table.insert(state.hitboxes,{id=id,x=x,y=y,w=w,h=h,callback=cb,modal=modal}) end
local function contains(b,x,y) return x>=b.x and y>=b.y and x<=b.x+b.w and y<=b.y+b.h end
local function button(id,t,x,y,w,h,cb,primary,modal)
    local z=modal and 52 or 16;local hovered=state.hover==id
    -- Keep button geometry stationary; hover changes color only.
    round(x,y,w,h,primary and P.accent or (hovered and P.line or P.field),z,6)
    label(t,x+12,y+(h-15)/2,primary and P.bg or P.text,13,z+1);hit(id,x,y,w,h,cb,modal)
end
local function toggle(id,t,x,y,w,value,cb,modal)
    local z=modal and 52 or 16
    label(t,x,y+9,P.text,13,z)
    round(x+w-43,y+5,40,22,value and P.accent or P.field,z,11)
    local switch=switches[id]
    if not switch then switch={value=value,from=value and 1 or 0,at=0};switches[id]=switch end
    if switch.value~=value then switch.from=switch.value and 1 or 0;switch.value=value;switch.at=tick();animateUntil=tick()+.18 end
    local t=motionAllowed() and math.min(1,(tick()-switch.at)/(.16/SETTINGS.animationSpeed)) or 1
    local amount=switch.from+((value and 1 or 0)-switch.from)*(1-(1-t)^3)
    draw("Circle",x+w-31+17*amount,y+16,{Radius=7,Color=value and P.bg or P.muted,Filled=true,NumSides=16,Transparency=1,ZIndex=z+1})
    hit(id,x,y,w,32,function() cb(not value) end,modal)
end
local function field(id,value,placeholder,x,y,w,modal)
    round(x,y,w,34,state.focus==id and P.line or P.field,modal and 52 or 16,6)
    label(short((value~="" and value or placeholder)..(state.focus==id and " |" or ""),math.floor((w-24)/7)),x+12,y+9,value~="" and P.text or P.muted,13,modal and 53 or 20)
    hit(id,x,y,w,34,function() state.focus=id;mark() end,modal)
end
local BASE64_VALUES={};do local a="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";for i=1,#a do BASE64_VALUES[a:byte(i)]=i-1 end end
local function decode64(s)
    local out={};for i=1,#s,4 do local a,b,c,d=s:byte(i,i+3);local v=(BASE64_VALUES[a] or 0)*262144+(BASE64_VALUES[b] or 0)*4096+(BASE64_VALUES[c] or 0)*64+(BASE64_VALUES[d] or 0)
        out[#out+1]=string.char(math.floor(v/65536)%256);if c and c~=61 then out[#out+1]=string.char(math.floor(v/256)%256) end;if d and d~=61 then out[#out+1]=string.char(v%256) end end
    return table.concat(out)
end
local function getImage(n)
    if not state.imageQueued[n] and (ICON_URLS[n] or (not state.imageCache[n] and ICON_PACKS[n])) then state.imageQueued[n]=true;table.insert(state.imageQueue,n) end
    return state.imageCache[n]
end
local function icon(n,x,y,s,z)
    local data=getImage(n)
    if data then draw("Image",x,y,{Data=data,Size=Vector2.new(s,s),Color=P.white,Transparency=1,ZIndex=z or 18})
    else label("--",x+s/2-7,y+s/2-7,P.faint,12,z or 18) end
end
state.imageWorker=task.spawn(function()
    local packs={}
    while state.alive do
        task.wait(.06);if not state.alive then break end
        local n=table.remove(state.imageQueue,1)
        if n then
            local ok,data=pcall(function()
                if ICON_URLS[n] then
                    local original=ICON_URLS[n]
                    for _,url in ipairs({original:gsub("/150/150/","/420/420/"),original}) do
                        local fetched,bytes=pcall(function() return game:HttpGet(url) end)
                        if fetched and type(bytes)=="string" and bytes:sub(1,4)==string.char(137).."PNG" then return bytes end
                    end
                end
                local pack=ICON_PACKS[n]
                if pack then
                    if not packs[pack] then
                        local payload=game:GetService("HttpService"):JSONDecode(game:HttpGet(ICON_BASE..pack))
                        for name,frames in pairs(payload) do if not state.imageCache[name] and type(frames)=="table" and type(frames[1])=="string" then state.imageCache[name]=decode64(frames[1]) end end
                        packs[pack]=true
                    end
                    return state.imageCache[n]
                end
            end)
            if not state.alive then break end
            if ok and type(data)=="string" then state.imageCache[n]=data;mark() end
        end
    end
end)
local function allResults(query,favorites)
    local out={};query=query:lower()
    for _,w in ipairs(CATALOG) do
        if state.page=="Skins" or state.page=="Favorites" or w.category==state.page or query~="" then
            if query=="" and not favorites then table.insert(out,{weapon=w,skin=state.selections[w.name]})
            else for _,s in ipairs(w.skins) do
                if (not favorites or FAVORITES[favoriteKey(w,s)]) and (query=="" or w.name:lower():find(query,1,true) or s:lower():find(query,1,true)) then table.insert(out,{weapon=w,skin=s}) end
            end end
        end
    end
    return out
end
local function previewStep(dir)
    local w=state.previewWeapon;local current=state.previewName==w.name and "Default" or state.previewName;local i=(validSkin(w,current) or 0)+1
    for _=1,#w.skins do i=((i-1+dir)%#w.skins)+1;if not state.unavailable[w.skins[i]] then choose(w,w.skins[i]);return end end
end
local function cycle(key,values)
    local i=1;for j,v in ipairs(values) do if SETTINGS[key]==v then i=j%#values+1;break end end
    SETTINGS[key]=values[i];theme();clampWindow();state.animate=SETTINGS.rotation;changed()
end
local SETTING_GROUPS={"General","Interface","Appearance","Hotkeys","Performance","Data","About"}
local function settingRows()
    local g=state.settingsGroup
    if g=="General" then return {{"autoApply","Auto apply","toggle"},{"rememberSelections","Remember selections","toggle"},{"rememberWindow","Remember window","toggle"},{"startMinimized","Start minimized","toggle"},{"confirmReset","Confirm before reset","toggle"}}
    elseif g=="Interface" then return {{"scale","UI scale",{.8,1,1.2}},{"animations","Interface animations","toggle"},{"animationSpeed","Animation speed",{.5,1,1.5,2}},{"reduceMotion","Reduce motion","toggle"},{"compact","Compact rows","toggle"},{"rotation","Preview rotation","toggle"},{"rotationSpeed","Rotation speed",{.25,.5,1,1.5,2}}}
    elseif g=="Appearance" then return {{"theme","Theme",{"Dark","Darker"}},{"accent","Accent",{"Periwinkle","Mint","Rose"}},{"opacity","Background opacity",{.75,.85,.95,1}},{"radius","Corner radius",{0,6,9,12}}}
    elseif g=="Hotkeys" then return {{"hotkey","Show / hide key",{161,45,117,119}}}
    elseif g=="Performance" then return {{"lowPower","FPS-friendly mode","toggle"},{"effects","Decorative effects","toggle"},{"rotation","Preview animation","toggle"}} end
    return {}
end
local render
render=function()
    pool=0;state.hitboxes={};state.previewItem=nil
    local w,h=state.w/SETTINGS.scale,state.h/SETTINGS.scale
    theme()
    if SETTINGS.effects and not SETTINGS.lowPower then round(3,5,w,h,rgb(5,7,11),7,12) end
    round(0,0,w,h,P.bg,8,12);rect(0,42,w,1,P.line,10)
    label("R /",19,10,P.accent,20);label("Rivals Skin Changer",63,13,P.text,14)
    local _,count=configText();label(state.busy and "Applying..." or count.." selected",260,14,P.muted,11)
    button("updates-top","Update log",w-365,7,110,28,function() state.updates=true;state.focus=nil;mark() end)
    button("global-search","Search",w-248,7,76,28,function() navigate("Skins");state.focus="search" end)
    button("settings-top","Settings",w-165,7,80,28,function() navigate("Settings") end)
    button("hide","_",w-78,7,28,28,function() state.visible=false;state.focus=nil;changed() end)
    button("close","X",w-43,7,28,28,function() closePending=true;state.visible=false end)
    rect(0,43,152,h-43,P.panel,9);label("LIBRARY",19,64,P.faint,10)
    local nav={"Skins","Primary","Secondary","Melee","Utility","Favorites","Settings"}
    for i,page in ipairs(nav) do
        local y=89+(i-1)*43;local selected=state.page==page
        if selected then round(10,y,132,35,P.field,12,7);rect(10,y+8,2,19,P.accent,13) end
        label(({"[]","01","02","03","04","*","+"})[i],22,y+10,selected and P.accent or P.faint,11)
        label(page,48,y+9,selected and P.text or P.muted,13)
        hit("nav:"..page,10,y,132,35,function() navigate(page) end)
    end
    label("CLIENT 2.4",19,h-75,P.faint,10);label((({[161]="Right Shift",[45]="Insert",[117]="F6",[119]="F8"})[SETTINGS.hotkey] or "Hotkey").." to hide",19,h-54,P.muted,10)
    local left=176;local right=w-292;local cw=right-left-20
    if state.page=="Settings" then
        label("Make it yours",left,66,P.text,26);label("Preferences are saved on this device.",left,101,P.muted,12)
        local tabW=math.floor((w-left-24)/7)
        for i,g in ipairs(SETTING_GROUPS) do button("group:"..g,g,left+(i-1)*tabW,132,tabW-5,30,function() state.settingsGroup=g;transition() end,state.settingsGroup==g) end
        round(left,178,w-left-24,h-281,P.panel,12,10)
        local rows=settingRows();local rh=math.min(47,(h-302)/math.max(1,#rows))
        for i,row in ipairs(rows) do
            local key,title,kind=row[1],row[2],row[3];local y=191+(i-1)*rh;local rw=w-left-56
            if kind=="toggle" then toggle("setting:"..key,title,left+16,y,rw,SETTINGS[key],function(v)
                SETTINGS[key]=v;if key=="autoApply" then setAuto(v) end
                state.animate=SETTINGS.rotation;changed()
            end)
            else
                label(title,left+16,y+9,P.text,13)
                local value=SETTINGS[key];if key=="hotkey" then value=({[161]="Right Shift",[45]="Insert",[117]="F6",[119]="F8"})[value] or tostring(value) end
                button("setting:"..key,tostring(value).."  >",w-206,y,166,32,function() cycle(key,kind) end)
            end
        end
        if state.settingsGroup=="Hotkeys" then button("reset-hotkeys","Reset hotkey",left+16,246,155,32,function() SETTINGS.hotkey=161;changed() end) end
        if state.settingsGroup=="Data" then
            button("reset-data","Reset selected skins",left+16,196,208,36,requestReset)
            button("reset-settings","Reset settings",left+236,196,180,36,function() for k,v in pairs(DEFAULT_SETTINGS) do SETTINGS[k]=v end;setAuto(SETTINGS.autoApply);state.animate=SETTINGS.rotation;theme();clampWindow();changed() end)
            button("export","Export configuration",left+16,251,208,36,function()
                local ok=writefile and pcall(writefile,"rivals_skin_changer_export.lua",configText());state.status=ok and "Exported rivals_skin_changer_export.lua" or "File export unavailable";mark()
            end)
            button("import","Import configuration",left+236,251,208,36,function()
                local ok,s=pcall(function() return readfile("rivals_skin_changer_export.lua") end)
                if ok then local values={};for line in s:gmatch("[^\r\n]+") do local a,b=line:match("^%s*(.-)%s*=%s*(.-)%s*$");if a then values[a]=b end end;importSelections(values);if state.autoApply then request("apply") end;state.status="Imported configuration";changed()
                else state.status="Place a config in rivals_skin_changer_export.lua";mark() end
            end)
            label("Export and import use rivals_skin_changer_export.lua",left+16,310,P.muted,12)
            button("save-now","Save preferences now",left+16,354,208,36,function() state.status=state.Save() and "Preferences saved" or "Local storage unavailable";mark() end)
        elseif state.settingsGroup=="About" then
            label("Rivals Skin Changer",left+20,200,P.text,22)
            label("GUI 2.4  /  Cleanup-aware skin engine",left+20,243,P.muted,13)
            label("Build: 2026-09-10  /  "..#CATALOG.." weapons",left+20,276,P.muted,13)
            label("Catalog: martinikaws.github.io/rivals-skins",left+20,309,P.muted,12)
            label("Preview uses flat artwork. It is not a 3D renderer.",left+20,350,P.faint,12)
        end
    else
        label(state.page=="Skins" and "Your arsenal" or state.page,left,66,P.text,27)
        label(state.page=="Favorites" and "Your saved skins, across every weapon." or "Choose a weapon. Make it your own.",left,102,P.muted,12)
        field("search",state.query,"Search weapons or skins...",left,132,cw)
        local results=allResults(state.query,state.page=="Favorites");local rh=SETTINGS.compact and 54 or 68
        local rows=math.max(2,math.floor((h-275)/rh));state.offset=math.max(0,math.min(state.offset,math.max(0,#results-rows)))
        for i=1,rows do local entry=results[state.offset+i];if entry then
            local weapon,skin=entry.weapon,entry.skin;local y=180+(i-1)*rh;local selected=state.previewWeapon==weapon
            round(left,y,cw,rh-7,selected and P.field or P.panel,12,8)
            if selected then rect(left,y+12,2,rh-31,P.accent,13) end
            icon(skin=="Default" and weapon.name or skin,left+5,y-3,rh-2)
            label(short(weapon.name,math.floor((cw-130)/7)),left+rh+4,y+10,P.text,14)
            label(short(skin,math.floor((cw-130)/6)),left+rh+4,y+32,state.unavailable[skin] and P.red or P.muted,11)
            local chosenW,chosenS=weapon,skin
            hit("weapon:"..weapon.name..":"..i,left,y,cw-42,rh-7,function() local result=state.query~="" or state.page=="Favorites";if result then state.category=chosenW.category;state.page=chosenW.category;state.query="";state.offset=0 end;openSelector(chosenW);if result then state.skinQuery=chosenS=="Default" and "" or chosenS;state.previewName=chosenS=="Default" and chosenW.name or chosenS end end)
            label(FAVORITES[favoriteKey(weapon,skin)] and "*" or "+",left+cw-30,y+17,P.accent,21)
            hit("favorite:"..i,left+cw-42,y,42,rh-7,function() favorite(chosenW,chosenS) end)
        end end
        if #results==0 then label("No matching skins",left+18,205,P.muted,15) end
        local fy=h-86
        button("list-up","Previous",left,fy,87,30,function() state.offset=math.max(0,state.offset-rows);mark() end)
        label((#results==0 and "0" or tostring(state.offset+1).."-"..math.min(#results,state.offset+rows)).." / "..#results,left+100,fy+8,P.faint,11)
        button("list-down","Next",left+cw-75,fy,75,30,function() state.offset=math.min(math.max(0,#results-rows),state.offset+rows);mark() end)
        round(right,66,268,h-122,P.panel,12,11)
        label("PREVIEW",right+18,83,P.faint,10);label("2D",right+230,83,P.accent,11)
        local name=state.previewName;local weapon=state.previewWeapon
        label(weapon.name,right+18,113,P.muted,12)
        label(short(name,24),right+18,135,P.text,19)
        local areaH=math.max(100,h-465);local ps=math.min(areaH,math.min(242,areaH/1.1)*state.zoom);local cx=right+134;local cy=172+areaH/2
        local width=ps*math.cos(.65*math.sin(state.previewPhase));local data=getImage(name)
        if data then state.previewItem=draw("Image",cx-width/2,cy-ps/2,{Data=data,Size=Vector2.new(width,ps),Color=P.white,Transparency=1,ZIndex=20});state.previewGeometry={cx=cx,cy=cy,size=ps}
        else label(ICON_URLS[name] and "Loading artwork..." or "Artwork unavailable",right+50,cy,P.faint,12) end
        hit("rotate-drag",right+14,176,240,math.max(80,h-364),function() state.turnDrag={x=mouse.X,phase=state.previewPhase} end)
        local by=h-260
        label(SKIN_RARITY[name] or "Skin preview",right+18,by-18,P.accent,11)
        button("preview-prev","<",right+18,by+8,36,31,function() previewStep(-1) end)
        button("preview-next",">",right+214,by+8,36,31,function() previewStep(1) end)
        button("preview-favorite",FAVORITES[favoriteKey(weapon,name==weapon.name and "Default" or name)] and "Saved *" or "Favorite +",right+62,by+8,144,31,function() favorite(weapon,name==weapon.name and "Default" or name) end)
        toggle("rotation","Rotate artwork",right+18,by+54,232,state.animate,function(v) state.animate=v;SETTINGS.rotation=v;changed() end)
        button("zoom-out","-",right+18,by+99,32,28,function() state.zoom=math.max(.6,state.zoom-.1);mark() end)
        label("Zoom "..math.floor(state.zoom*100).."%",right+62,by+106,P.muted,11)
        button("zoom-in","+",right+148,by+99,32,28,function() state.zoom=math.min(1.1,state.zoom+.1);mark() end)
        button("preview-reset","Reset",right+186,by+99,64,28,function() state.zoom=1;state.previewPhase=0;mark() end)
        label("Drag artwork to turn",right+18,by+140,P.faint,10)
    end
    rect(152,h-43,w-152,1,P.line,12)
    button("apply",state.busy and "Applying..." or ((state.successUntil or 0)>tick() and "Applied  /  Done" or "Apply skins"),176,h-35,164,29,function() request("apply");transition() end,true)
    button("reset","Reset",350,h-35,72,29,requestReset)
    toggle("auto","Auto apply",442,h-36,146,state.autoApply,setAuto)
    label(short(state.status,math.max(12,math.floor((w-622)/6))),610,h-25,P.muted,10)
    if state.dropdown then
        local weapon=state.dropdown;local mw=math.min(650,w-90);local mh=math.min(526,h-80);local x=(w-mw)/2;local y=(h-mh)/2
        round(x-3,y-3,mw+6,mh+6,P.line,48,12);round(x,y,mw,mh,P.bg,49,10)
        label(weapon.name,x+22,y+19,P.text,23,53);label("Choose a skin",x+22,y+51,P.muted,12,53)
        button("skin-default","Default",x+mw-148,y+20,90,31,function() choose(weapon,"Default");state.dropdown=nil;transition() end,false,true)
        button("selector-close","X",x+mw-48,y+20,28,31,function() state.dropdown=nil;state.focus=nil;transition() end,false,true)
        field("skin-search",state.skinQuery,"Filter skins...",x+22,y+79,mw-44,true)
        local list={};for _,s in ipairs(weapon.skins) do if state.skinQuery=="" or s:lower():find(state.skinQuery:lower(),1,true) then table.insert(list,s) end end
        local rh=58;local rows=math.max(2,math.floor((mh-180)/rh));state.skinOffset=math.min(state.skinOffset,math.max(0,#list-rows))
        for i=1,rows do local skin=list[state.skinOffset+i];if skin then
            local ry=y+127+(i-1)*rh;local unavailable=state.unavailable[skin];local selected=state.selections[weapon.name]==skin
            if unavailable then round(x+21,ry-1,mw-42,53,P.red,50,7) end
            round(x+22,ry,mw-44,51,selected and P.field or P.panel,51,7)
            icon(skin=="Default" and weapon.name or skin,x+29,ry+1,49,53)
            label(short(skin,math.floor((mw-262)/7)),x+87,ry+10,P.text,13,53)
            label(selected and "Selected" or (SKIN_RARITY[skin] or "Skin"),x+87,ry+30,P.muted,10,53)
            if unavailable then label("Unavailable",x+mw-155,ry+17,P.red,11,53) end
            local s=skin;hit("skin:"..skin,x+22,ry,mw-86,51,function() choose(weapon,s);if not state.unavailable[s] then state.dropdown=nil;state.focus=nil;transition() end end,true)
            button("skin-favorite:"..skin,FAVORITES[favoriteKey(weapon,skin)] and "*" or "+",x+mw-62,ry+10,28,30,function() favorite(weapon,s) end,false,true)
        end end
        button("skins-prev","Previous",x+22,y+mh-42,93,28,function() state.skinOffset=math.max(0,state.skinOffset-rows);mark() end,false,true)
        label(#list.." skins",x+mw/2-25,y+mh-34,P.faint,11,53)
        button("skins-next","Next",x+mw-95,y+mh-42,73,28,function() state.skinOffset=math.min(math.max(0,#list-rows),state.skinOffset+rows);mark() end,false,true)
    end
    if state.updates then
        local x,y=w/2-270,h/2-155
        round(x,y,540,310,P.bg,60,10)
        label("Update log",x+22,y+22,P.text,23,63)
        label("2.4  /  September 10, 2026",x+22,y+65,P.accent,13,63)
        label("GUI retries temporary loading errors automatically.",x+22,y+103,P.muted,12,63)
        label("Mouse references refresh after match changes.",x+22,y+135,P.muted,12,63)
        label("Match detection no longer needs teleport events.",x+22,y+167,P.muted,12,63)
        label("Existing cleanup guards remain enabled.",x+22,y+199,P.muted,12,63)
        button("updates-close","Close",x+22,y+249,110,32,function() state.updates=nil;mark() end,false,true)
    end
    if state.confirm then
        local x,y=w/2-190,h/2-85;round(x,y,380,170,P.field,60,10)
        label("Reset all selected skins?",x+20,y+22,P.text,18,63);label("Every weapon will return to Default.",x+20,y+58,P.muted,12,63)
        button("confirm-reset","Reset",x+20,y+115,150,33,function() state.confirm=nil;resetSelections();changed() end,true,true)
        button("cancel-reset","Cancel",x+190,y+115,165,33,function() state.confirm=nil;mark() end,false,true)
    end
    for i=pool+1,#state.drawings do state.drawings[i].used=false;assign(state.drawings[i],"Visible",false) end
    displayedOffsetY=offsetY
    state.dirty=false;state.lastStatus=state.status
end
local function showObjects(show)
    for _,item in ipairs(state.drawings) do assign(item,"Visible",show and item.used or false) end
end
local function moveObjects()
    displayedOffsetY=offsetY
    for _,item in ipairs(state.drawings) do if item.used then assign(item,"Position",Vector2.new(state.x+item.x*SETTINGS.scale,state.y+(item.y+offsetY)*SETTINGS.scale)) end end
end
local function handleClick(mx,my)
    local x,y=(mx-state.x)/SETTINGS.scale,(my-state.y)/SETTINGS.scale-displayedOffsetY
    local w,h=state.w/SETTINGS.scale,state.h/SETTINGS.scale
    for i=#state.hitboxes,1,-1 do local b=state.hitboxes[i]
        local allowed=not state.dropdown or b.modal
        if state.updates then allowed=b.id=="updates-close" end
        if state.confirm then allowed=b.id=="confirm-reset" or b.id=="cancel-reset" end
        if allowed and contains(b,x,y) then b.callback();return end
    end
    if not state.dropdown and not state.confirm and not state.updates then
        local west=x<12 and x>=-3;local east=x>w-12 and x<=w+3;local north=y<12 and y>=-3;local south=y>h-12 and y<=h+3
        if (west or east) and (north or south) then state.resize={x=state.x,y=state.y,w=state.w,h=state.h,mx=mx,my=my,west=west,north=north};return end
    end
    state.focus=nil
    if not state.dropdown and not state.confirm and not state.updates and y>=0 and y<42 and x>=0 and x<w-365 then state.drag={x=mx-state.x,y=my-state.y} end
end
local keyWas={};local repeatAt={}
local function inputText(now)
    local shift=iskeypressed(16) or iskeypressed(160) or iskeypressed(161)
    local chars={[32]=" ",[189]="-",[190]=".",[222]="'"}
    for k=65,90 do chars[k]=string.char(shift and k or k+32) end
    for k=48,57 do chars[k]=string.char(k) end
    chars[8]="BACK";chars[27]="ESC";chars[13]="ENTER"
    for key,char in pairs(chars) do
        local down=iskeypressed(key);local fire=down and (not keyWas[key] or now>=(repeatAt[key] or 0))
        if fire and state.focus then
            repeatAt[key]=now+(keyWas[key] and .055 or .4)
            local fieldName=state.focus=="skin-search" and "skinQuery" or "query"
            if char=="ESC" or char=="ENTER" then state.focus=nil
            elseif char=="BACK" then state[fieldName]=state[fieldName]:sub(1,-2)
            elseif #state[fieldName]<64 then state[fieldName]=state[fieldName]..char end
            state.offset=0;state.skinOffset=0;mark()
        end
        keyWas[key]=down
    end
end
captureInput(state.visible)
state.renderer=task.spawn(function()
    local wasDown,wasHot=false,false;local last=tick();local saveAt=tick()+1;local resizeAt=0
    local refreshAt=0;local retryAt=0;local failureCount=0
    while state.alive do
        task.wait(SETTINGS.lowPower and .033 or .016);if not state.alive then break end
        if tick()>=retryAt then
        local ok,err=pcall(function()
            local now=tick();local dt=math.min(.05,math.max(0,now-last));last=now
            if now>=refreshAt then
                local player=game:GetService("Players").LocalPlayer
                local camera=workspace.CurrentCamera
                if not player or not camera then error("Waiting for player and camera") end
                local currentMouse=player:GetMouse()
                if not currentMouse then error("Waiting for mouse") end
                mouse=currentMouse;refreshAt=now+.5
            end
            local active=not isrbxactive or isrbxactive();local hot=iskeypressed(SETTINGS.hotkey);local down=ismouse1pressed()
            if active and hot and not wasHot and not state.focus then state.visible=not state.visible;state.drag=nil;state.resize=nil;state.dropdown=nil;state.confirm=nil;mark() end
            local target=state.visible and 1 or 0
            if motionAllowed() then local step=dt*SETTINGS.animationSpeed/.16;visibility=visibility<target and math.min(target,visibility+step) or math.max(target,visibility-step) else visibility=target end
            local transient=transitionAt>0 and math.max(0,1-(now-transitionAt)/(.18/SETTINGS.animationSpeed)) or 0
            offsetY=(1-visibility)*10+transient*transient*6
            captureInput(active and state.visible)
            if active and state.visible then
                inputText(now)
                if down and not wasDown then handleClick(mouse.X,mouse.Y) end
                if down and state.drag then
                    state.x=mouse.X-state.drag.x;state.y=mouse.Y-state.drag.y;clampWindow();moveObjects();dirtySave=true
                elseif down and state.resize then
                    local r=state.resize;local dx,dy=mouse.X-r.mx,mouse.Y-r.my
                    local vw=workspace.CurrentCamera.ViewportSize.X;local vh=workspace.CurrentCamera.ViewportSize.Y
                    local right,bottom=r.x+r.w,r.y+r.h
                    if r.west then state.x=math.max(0,math.min(r.x+dx,right-940*SETTINGS.scale));state.w=right-state.x else state.w=math.min(vw-r.x,math.max(940*SETTINGS.scale,r.w+dx)) end
                    if r.north then state.y=math.max(0,math.min(r.y+dy,bottom-620*SETTINGS.scale));state.h=bottom-state.y else state.h=math.min(vh-r.y,math.max(620*SETTINGS.scale,r.h+dy)) end
                    if now>=resizeAt then mark();resizeAt=now+.025 end;dirtySave=true
                elseif down and state.turnDrag then state.previewPhase=state.turnDrag.phase+(mouse.X-state.turnDrag.x)*.012;mark()
                elseif not down then if state.drag or state.resize then mark() end;state.drag=nil;state.resize=nil;state.turnDrag=nil end
                local hover
                if not state.drag and not state.resize then for i=#state.hitboxes,1,-1 do local b=state.hitboxes[i];if (not state.dropdown or b.modal) and contains(b,(mouse.X-state.x)/SETTINGS.scale,(mouse.Y-state.y)/SETTINGS.scale-displayedOffsetY) then hover=b.id;break end end end
                if hover~=state.hover then state.hover=hover;hoverAt=now;animateUntil=now+.15;mark() end
                if motionAllowed() and now<animateUntil and not state.drag then mark() end
                if state.lastStatus~=state.status then if state.status:find("Applied",1,true) then state.successUntil=now+1.2 end;changed() end
                if state.successUntil and now>=state.successUntil then state.successUntil=nil;mark() end
                if state.dirty and not state.drag then render() end
                if state.animate and not state.turnDrag and not state.drag and not state.resize and not state.dropdown and not state.updates and state.previewItem then
                    state.previewPhase=(state.previewPhase+dt*SETTINGS.rotationSpeed)%(math.pi*2)
                    local g=state.previewGeometry;local width=g.size*math.cos(.65*math.sin(state.previewPhase));local item=state.previewItem
                    item.x=g.cx-width/2;assign(item,"Size",Vector2.new(width*SETTINGS.scale,g.size*SETTINGS.scale));assign(item,"Position",Vector2.new(state.x+item.x*SETTINGS.scale,state.y+(item.y+offsetY)*SETTINGS.scale))
                end
            else state.drag=nil;state.resize=nil;state.turnDrag=nil end
            if visibility>0 and active then
                showObjects(true)
                if visibility~=target or transient>0 or offsetY~=0 then moveObjects() end
            else showObjects(false) end
            if visibility==0 and closePending then request("close");closePending=false end
            if dirtySave and now>=saveAt then state.Save();saveAt=now+1 end
            wasDown,wasHot=down,hot
        end)
        if not ok then
            -- A transient loading error must not destroy the worker that resumes skins.
            failureCount=failureCount+1;retryAt=tick()+math.min(3,.25*failureCount);refreshAt=0
            state.drag=nil;state.resize=nil;state.turnDrag=nil;state.focus=nil
            state.dirty=true;wasDown=true;wasHot=true
            pcall(state.ReleaseInput);pcall(showObjects,false)
            state.status="GUI waiting to recover: "..tostring(err)
            if failureCount==1 then pcall(notify,"GUI paused during loading; retrying automatically.","Rivals Skin Changer",5) end
        else
            if failureCount>0 then state.status="GUI recovered.";mark() end
            failureCount=0;retryAt=0
        end
        end
    end
end)

_G.__RIVALS_SKIN_GUI = state
state.worker = task.spawn(function()
    while state.alive do
        task.wait(0.15)
        if not state.alive then break end
        pollResume()
        local action = state.pending
        if state.resume and action == "apply" then action=nil end
        if action == "reset" then state.resume=nil end
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
                                state.status = state.status .. " " .. ((result.skipped and result.skipped[1]) or "Some models were unavailable.")
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
pcall(notify, "Rivals Skin Changer ready. Right Shift hides/shows it.", "Rivals Skin Changer", 7)
