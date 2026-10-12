--[[
    HonenxWhite | Reborn
    Hub completo para Muscle Legends usando KNI_UI
    Made by Honen / cyanam1 / White
]]

-- ═══ CARGAR KNI_UI ═══
local KNI_URL = "https://raw.githubusercontent.com/rodriguezberiticajuliocesar-wq/nebula-gui/main/KNI_UI.luau"
local KNI = loadstring(game:HttpGet(KNI_URL, true))()

if not KNI then
    warn("[HonenxWhite] Error al cargar KNI_UI")
    return
end

-- ═══ SERVICIOS ═══
local services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VirtualUser = game:GetService("VirtualUser"),
    Workspace = workspace,
    Lighting = game:GetService("Lighting"),
    UserInputService = game:GetService("UserInputService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    RunService = game:GetService("RunService"),
    CollectionService = game:GetService("CollectionService"),
    HttpService = game:GetService("HttpService"),
    Stats = game:GetService("Stats"),
}

local player = services.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local backpack = player:WaitForChild("Backpack")

-- ═══ UTILS ═══
local utils = {}
utils.runtime = {}

_G.HonenxWhiteMainConnections = _G.HonenxWhiteMainConnections or {}
for _, connection in ipairs(_G.HonenxWhiteMainConnections) do
    pcall(function() connection:Disconnect() end)
end
_G.HonenxWhiteMainConnections = {}
_G.HonenxWhiteMainGeneration = (_G.HonenxWhiteMainGeneration or 0) + 1
utils.Generation = _G.HonenxWhiteMainGeneration

function utils.isCurrent()
    return utils.Generation == _G.HonenxWhiteMainGeneration
end

function utils.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(_G.HonenxWhiteMainConnections, connection)
    return connection
end

utils.playerData = {
    Player = player,
    DisplayName = player.DisplayName,
    Character = player.Character,
    Humanoid = nil,
    Camera = services.Workspace.CurrentCamera,
    Backpack = backpack,
}

utils.playerData.Humanoid = utils.playerData.Character and utils.playerData.Character:FindFirstChildOfClass("Humanoid")

utils.remotes = {
    ChangeSpeedSize = services.ReplicatedStorage.rEvents.changeSpeedSizeRemote,
    MuscleEvent = player.muscleEvent,
}

function utils.formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1e18 then return string.format("%.1fqi", n / 1e18)
    elseif n >= 1e15 then return string.format("%.1fqa", n / 1e15)
    elseif n >= 1e12 then return string.format("%.1ft", n / 1e12)
    elseif n >= 1e9 then return string.format("%.1fb", n / 1e9)
    elseif n >= 1e6 then return string.format("%.1fm", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fk", n / 1e3)
    else return tostring(math.floor(n)) end
end

function utils.formatWithCommas(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    while true do
        local newS, count = s:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
        s = newS
        if count == 0 then break end
    end
    return s
end

function utils.notify(title, text, duration, kind)
    KNI.Notify:Show(title, text, duration or 3, kind or "info")
end

-- ═══ CREAR VENTANA ═══
local window = KNI.new({
    Name = "HonenxWhite",
    Title = "HonenxWhite | Reborn",
    Width = 620,
    Height = 420,
})

_G.HonenxWhiteWindow = window

-- ═══ TABS ═══
local tabs = {
    main = window:AddTab("Main"),
    killing = window:AddTab("Killing"),
    specs = window:AddTab("Specs"),
    farming = window:AddTab("Farming"),
    fast = window:AddTab("⚡ Fast"),
    boss = window:AddTab("Boss"),
    inventory = window:AddTab("Pets"),
    boosts = window:AddTab("Boosts"),
    teleport = window:AddTab("Teleports"),
    stats = window:AddTab("Stats"),
    info = window:AddTab("Info"),
}

for _, tab in pairs(tabs) do
    tab.runtime = {}
end

-- ═══ RECONEXIÓN AL CHARACTER ═══
utils.connect(player.CharacterAdded, function(character)
    utils.playerData.Character = character
    utils.playerData.Humanoid = character:WaitForChild("Humanoid", 10)
    utils.playerData.Backpack = player:WaitForChild("Backpack")
end)

-- ═══ ANTI-AFK ═══
utils.connect(player.Idled, function()
    pcall(function()
        services.VirtualUser:CaptureController()
        services.VirtualUser:ClickButton2(Vector2.new(0, 0))
        services.VirtualUser:ClickButton1(Vector2.new(0, 0))
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB MAIN
-- ═══════════════════════════════════════════════════════════════

tabs.main:AddSection("User Settings")

tabs.main.Settings = {
    Size = {Value = 2, Enabled = false},
    Speed = {Value = 120, Enabled = false},
    FOV = {Value = 70, Enabled = false},
}

tabs.main:AddTextBox("Size (default 2):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) > 0 then
        tabs.main.Settings.Size.Value = tonumber(text)
    end
end, {clear = false})

tabs.main:AddSwitch("Set Size", function(bool)
    tabs.main.Settings.Size.Enabled = bool
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.Size.Enabled and utils.playerData.Character and utils.playerData.Humanoid then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSize", tabs.main.Settings.Size.Value)
            end)
        end
        task.wait(0.15)
    end
end)

tabs.main:AddTextBox("Speed (default 120):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) > 0 then
        tabs.main.Settings.Speed.Value = tonumber(text)
    end
end, {clear = false})

tabs.main:AddSwitch("Set Speed", function(bool)
    tabs.main.Settings.Speed.Enabled = bool
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.Speed.Enabled and utils.playerData.Character and utils.playerData.Humanoid then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSpeed", tabs.main.Settings.Speed.Value)
            end)
        end
        task.wait(0.15)
    end
end)

tabs.main:AddTextBox("FOV (1-120):", function(text)
    text = string.gsub(text, "%s+", "")
    if tonumber(text) and tonumber(text) >= 1 and tonumber(text) <= 120 then
        tabs.main.Settings.FOV.Value = tonumber(text)
    end
end, {clear = false})

tabs.main:AddSwitch("Set FOV", function(bool)
    tabs.main.Settings.FOV.Enabled = bool
    if utils.playerData.Camera then
        utils.playerData.Camera.FieldOfView = bool and tabs.main.Settings.FOV.Value or 70
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Settings.FOV.Enabled and utils.playerData.Camera then
            utils.playerData.Camera.FieldOfView = tabs.main.Settings.FOV.Value
        end
        task.wait(0.15)
    end
end)

tabs.main:AddSection("Protection & Visuals")

tabs.main.Protection = {
    AntiFling = {Enabled = false},
    PositionLock = {Enabled = false, Position = nil},
}

tabs.main.enableAntiFling = function()
    if not tabs.main.Protection.AntiFling.Enabled or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("BodyVelocity") and root.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
        root.BodyVelocity:Destroy()
    end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(100000, 0, 100000)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.P = 1250
    bv.Parent = root
    tabs.main.runtime.bv = bv
end

tabs.main.disableAntiFling = function()
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("BodyVelocity") and root.BodyVelocity.MaxForce == Vector3.new(100000, 0, 100000) then
        root.BodyVelocity:Destroy()
    end
end

tabs.main:AddSwitch("Anti Fling", function(bool)
    tabs.main.Protection.AntiFling.Enabled = bool
    if bool then tabs.main.enableAntiFling() else tabs.main.disableAntiFling() end
end):Set(false)

utils.connect(player.CharacterAdded, function(newChar)
    newChar:WaitForChild("HumanoidRootPart", 5)
    if tabs.main.Protection.AntiFling.Enabled then tabs.main.enableAntiFling() end
end)

tabs.main.lockPosition = function()
    tabs.main.enableAntiFling()
    if not tabs.main.Protection.PositionLock.Enabled or not tabs.main.Protection.PositionLock.Position then return end
    if not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if root:FindFirstChild("PositionLocker") then
        root.PositionLocker.Position = tabs.main.Protection.PositionLock.Position
    else
        tabs.main.disableAntiFling()
        local bp = Instance.new("BodyPosition")
        bp.Name = "PositionLocker"
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = tabs.main.Protection.PositionLock.Position
        bp.P = 100000
        bp.Parent = root
        tabs.main.runtime.bp = bp
    end
end

tabs.main.unlockPosition = function()
    if player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("PositionLocker") then
            root.PositionLocker:Destroy()
        end
    end
    tabs.main.Protection.PositionLock.Position = nil
end

tabs.main:AddSwitch("Lock Position", function(bool)
    tabs.main.Protection.PositionLock.Enabled = bool
    if bool then
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then tabs.main.Protection.PositionLock.Position = root.Position end
        end
        tabs.main.lockPosition()
    else
        tabs.main.unlockPosition()
    end
end)

utils.connect(player.CharacterAdded, function(newChar)
    if tabs.main.Protection.PositionLock.Enabled and newChar:WaitForChild("HumanoidRootPart", 5) then
        tabs.main.Protection.PositionLock.Position = newChar.HumanoidRootPart.Position
        tabs.main.lockPosition()
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.main.Protection.PositionLock.Enabled then tabs.main.lockPosition() end
        task.wait(0.1)
    end
end)

tabs.main.VisibilitySettings = {
    HidePets = false,
    HidePopups = false,
    ShowPetsEvent = services.ReplicatedStorage.rEvents:WaitForChild("showPetsEvent"),
    SavePlayerSizeEvent = services.ReplicatedStorage.rEvents:WaitForChild("savePlayerSizeEvent"),
}

tabs.main:AddSwitch("Hide Pets", function(state)
    tabs.main.VisibilitySettings.HidePets = state
    tabs.main.VisibilitySettings.ShowPetsEvent:FireServer(state and "hidePets" or "showPets")
end):Set(false)

tabs.main.HidePopupsSwitch = tabs.main:AddSwitch("Hide Popups", function(state)
    tabs.main.VisibilitySettings.HidePopups = state
    tabs.main.VisibilitySettings.SavePlayerSizeEvent:FireServer("showPopupsOption")
end)
tabs.main.HidePopupsSwitch:Set(false)

tabs.main.RedactConfigPath = "HonenxWhite/MuscleLegendsMainConfig.json"
tabs.main.RedactConfig = {
    RedactName = false,
    RedactStats = false,
}

tabs.main.loadRedactConfig = function()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return end
    pcall(function()
        if not isfile(tabs.main.RedactConfigPath) then return end
        local savedConfig = services.HttpService:JSONDecode(readfile(tabs.main.RedactConfigPath))
        if typeof(savedConfig) == "table" then
            tabs.main.RedactConfig.RedactName = savedConfig.RedactName == true
            tabs.main.RedactConfig.RedactStats = savedConfig.RedactStats == true
        end
    end)
end

tabs.main.saveRedactConfig = function()
    if type(writefile) ~= "function" then return end
    pcall(function()
        if type(makefolder) == "function"
            and (type(isfolder) ~= "function" or not isfolder("HonenxWhite")) then
            pcall(makefolder, "HonenxWhite")
        end
        writefile(tabs.main.RedactConfigPath, services.HttpService:JSONEncode(tabs.main.RedactConfig))
    end)
end

tabs.main.loadRedactConfig()

tabs.main.RedactNameSwitch = tabs.main:AddSwitch("Redact Name", function(state)
    tabs.main.RedactConfig.RedactName = state
    tabs.main.saveRedactConfig()
end)
tabs.main.RedactNameSwitch:Set(tabs.main.RedactConfig.RedactName)

tabs.main.RedactStatsSwitch = tabs.main:AddSwitch("Redact Stats", function(state)
    tabs.main.RedactConfig.RedactStats = state
    tabs.main.saveRedactConfig()
end)
tabs.main.RedactStatsSwitch:Set(tabs.main.RedactConfig.RedactStats)

tabs.main.WaterParts = {
    Parts = {},
    PartSize = 2048,
    TotalDistance = 50000,
    StartPosition = Vector3.new(-2, -9.5, -2),
}

task.spawn(function()
    for x = 0, math.ceil(tabs.main.WaterParts.TotalDistance / tabs.main.WaterParts.PartSize) - 1 do
        for z = 0, math.ceil(tabs.main.WaterParts.TotalDistance / tabs.main.WaterParts.PartSize) - 1 do
            for _, offset in ipairs({
                {x * tabs.main.WaterParts.PartSize, z * tabs.main.WaterParts.PartSize, "Side_" .. x .. "_" .. z},
                {-x * tabs.main.WaterParts.PartSize, z * tabs.main.WaterParts.PartSize, "LeftRight_" .. x .. "_" .. z},
                {-x * tabs.main.WaterParts.PartSize, -z * tabs.main.WaterParts.PartSize, "UpLeft_" .. x .. "_" .. z},
                {x * tabs.main.WaterParts.PartSize, -z * tabs.main.WaterParts.PartSize, "UpRight_" .. x .. "_" .. z},
            }) do
                local part = Instance.new("Part")
                part.Size = Vector3.new(tabs.main.WaterParts.PartSize, 1, tabs.main.WaterParts.PartSize)
                part.Position = tabs.main.WaterParts.StartPosition + Vector3.new(offset[1], 0, offset[2])
                part.Anchored = true
                part.Transparency = 1
                part.CanCollide = true
                part.Name = "Part_" .. offset[3]
                part.Parent = workspace
                table.insert(tabs.main.WaterParts.Parts, part)
            end
        end
    end
end)

tabs.main.WalkOnWaterSwitch = tabs.main:AddSwitch("Walk on Water", function(bool)
    for _, part in ipairs(tabs.main.WaterParts.Parts) do
        if part and part.Parent then part.CanCollide = bool end
    end
end)
tabs.main.WalkOnWaterSwitch:Set(false)

tabs.main:AddSection("Other")

tabs.main:AddSwitch("Infinite Jump", function(bool)
    _G.InfiniteJump = bool
    if bool then
        utils.connect(services.UserInputService.JumpRequest, function()
            if _G.InfiniteJump and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:ChangeState("Jumping") end
            end
        end)
    end
end)

tabs.main.FortuneWheelData = {
    Running = false,
    Generation = 0,
    Remote = services.ReplicatedStorage.rEvents:WaitForChild("openFortuneWheelRemote"),
    Chances = services.ReplicatedStorage
        :WaitForChild("shared")
        :WaitForChild("catalogs")
        :WaitForChild("fortuneWheelChances")
        :WaitForChild("Fortune Wheel"),
}

tabs.main.spinFortuneWheel = function()
    pcall(function()
        tabs.main.FortuneWheelData.Remote:InvokeServer("openFortuneWheel", tabs.main.FortuneWheelData.Chances)
    end)
end

tabs.main:AddSwitch("Spin Fortune Wheel", function(state)
    tabs.main.FortuneWheelData.Running = state
    tabs.main.FortuneWheelData.Generation += 1
    tabs.main.runtime.generation = tabs.main.FortuneWheelData.Generation
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.main.FortuneWheelData.Running and tabs.main.FortuneWheelData.Generation == tabs.main.runtime.generation do
            tabs.main.spinFortuneWheel()
            task.wait(1)
        end
    end)
end)

local timeDropdown = tabs.main:AddDropdown("Change Time", function(selection)
    services.Lighting.ClockTime = selection == "Night" and 0 or 9
end)
timeDropdown:Add("Night")
timeDropdown:Add("Day")

-- ═══════════════════════════════════════════════════════════════
-- TAB INFO
-- ═══════════════════════════════════════════════════════════════

tabs.info:AddSection("Información")
tabs.info:AddLabel("HonenxWhite | Reborn")
tabs.info:AddLabel("Made by Honen / cyanam1 / White")
tabs.info:AddLabel("")

tabs.info:AddButton("📋 Copiar Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        utils.notify("Discord", "Link copiado", 2, "success")
    end
end)

tabs.info:AddLabel("")
tabs.info:AddLabel("Contributors:")
tabs.info:AddLabel("- cyanam1 (@honey)")
tabs.info:AddLabel("- White @chilin6369")
tabs.info:AddLabel("- Honen @Owner")
tabs.info:AddLabel("")
tabs.info:AddLabel("KNI UI - v2.0")

utils.notify("HonenxWhite", "Hub cargado correctamente ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- TAB KILLING
-- ═══════════════════════════════════════════════════════════════

-- Utils de Killing
tabs.killing.getTool = function()
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name == "Punch" and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:EquipTool(v)
        end
    end
    if player.muscleEvent then
        player.muscleEvent:FireServer("punch", "leftHand")
        player.muscleEvent:FireServer("punch", "rightHand")
    end
end

tabs.killing.isPlayerAlive = function(p)
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and
        p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

tabs.killing.isSpawnProtected = function(p)
    if not p or not p.Character then return false end
    if p.Character:FindFirstChildOfClass("ForceField")
        or p.Character:FindFirstChild("spawnProtectionHighlight") then
        return true
    end
    local protectedUntil = p.Character:GetAttribute("SpawnProtectedUntil")
    return typeof(protectedUntil) == "number" and workspace:GetServerTimeNow() < protectedUntil
end

tabs.killing.getLocalCombatCharacter = function()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not humanoid or humanoid.Health <= 0 or not root then return end
    return char, humanoid, root
end

tabs.killing.positionNearTarget = function(target, heightOffset)
    if not tabs.killing.isPlayerAlive(target)
        or tabs.killing.isSpawnProtected(target)
        or tabs.killing.isSpawnProtected(player) then
        return false
    end
    local _, _, localRoot = tabs.killing.getLocalCombatCharacter()
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return false end
    localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, heightOffset, 0)
    localRoot.AssemblyLinearVelocity = Vector3.zero
    localRoot.AssemblyAngularVelocity = Vector3.zero
    return true
end

tabs.killing.touchAndPunchTarget = function(target, heightOffset)
    if not tabs.killing.positionNearTarget(target, heightOffset) then return false, false end
    services.RunService.Heartbeat:Wait()
    if not tabs.killing.positionNearTarget(target, heightOffset) then return false, false end

    local char = tabs.killing.getLocalCombatCharacter()
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
    if not char or not targetRoot or not targetHumanoid or tabs.killing.isSpawnProtected(target) then return false, false end

    local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("RightHand")
    if not hand then return false, false end

    local punchTool = char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if punchTool and punchTool.Parent ~= char and humanoid then
        humanoid:EquipTool(punchTool)
    end

    local healthBefore = targetHumanoid.Health
    local attempted = pcall(function()
        if firetouchinterest then
            firetouchinterest(targetRoot, hand, 0)
            firetouchinterest(targetRoot, hand, 1)
        end
        player.muscleEvent:FireServer("punch", hand.Name == "LeftHand" and "leftHand" or "rightHand")
    end)
    if not attempted then return false, false end

    for _ = 1, 4 do
        services.RunService.Heartbeat:Wait()
        if not tabs.killing.isPlayerAlive(target) or targetHumanoid.Health < healthBefore then
            return true, true
        end
        if tabs.killing.isSpawnProtected(target) then
            return false, false
        end
    end

    return false, true
end

tabs.killing.attackPlayerWithLimit = function(target, hitLimit, shouldContinue, heightOffset)
    local hits = 0
    while utils.isCurrent() and hits < hitLimit and shouldContinue()
        and tabs.killing.isPlayerAlive(target) and not tabs.killing.isSpawnProtected(target) do
        local hitRegistered, attempted = tabs.killing.touchAndPunchTarget(target, heightOffset)
        if hitRegistered then hits = hits + 1 end
        if not attempted then break end
        if not hitRegistered then task.wait(0.05) end
    end
    return hits
end

tabs.killing.attackPlayerForDuration = function(target, duration, shouldContinue, heightOffset)
    local startedAt = os.clock()
    while utils.isCurrent() and os.clock() - startedAt < duration
        and shouldContinue()
        and tabs.killing.isPlayerAlive(target)
        and not tabs.killing.isSpawnProtected(target) do
        if tabs.killing.positionNearTarget(target, heightOffset) then
            local char = player.Character
            local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            local leftHand = char and char:FindFirstChild("LeftHand")
            local rightHand = char and char:FindFirstChild("RightHand")
            local punchTool = char and char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if punchTool and humanoid and punchTool.Parent ~= char then
                humanoid:EquipTool(punchTool)
            end
            if targetRoot and leftHand and rightHand then
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(targetRoot, leftHand, 0)
                        firetouchinterest(targetRoot, leftHand, 1)
                        firetouchinterest(targetRoot, rightHand, 0)
                        firetouchinterest(targetRoot, rightHand, 1)
                    end
                    player.muscleEvent:FireServer("punch", "leftHand")
                    player.muscleEvent:FireServer("punch", "rightHand")
                end)
            end
        end
        services.RunService.Heartbeat:Wait()
    end
end

-- Misc
tabs.killing:AddSection("Misc")

tabs.killing.equipBestStatPets = function(priority)
    for _, folder in pairs(player.petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
            end
        end
    end
    task.wait(0.2)
    local petsByName = {}
    for _, petName in ipairs(priority) do petsByName[petName] = {} end
    for _, pet in pairs(player.petsFolder.Unique:GetChildren()) do
        if petsByName[pet.Name] then
            table.insert(petsByName[pet.Name], pet)
        end
    end
    local equipped = 0
    for _, petName in ipairs(priority) do
        for _, pet in ipairs(petsByName[petName]) do
            if equipped >= 9 then return end
            services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
            equipped = equipped + 1
            task.wait(0.1)
        end
    end
end

tabs.killing:AddButton("Equip Best Damage", function()
    tabs.killing.equipBestStatPets({"Wild Wizard", "Chaos Sorcerer", "Mighty Monster", "Small Fry"})
end)

tabs.killing:AddButton("Equip Best Health", function()
    tabs.killing.equipBestStatPets({"Mighty Monster", "Small Fry", "Wild Wizard", "Chaos Sorcerer"})
end)

tabs.killing:AddSwitch("Remove Attack Animations", function(bool)
    if bool then
        local blockedAnimations = {
            ["3638729053"] = true, ["3638767427"] = true, ["507768375"] = true,
            ["522635514"] = true, ["522638767"] = true, ["182393478"] = true,
            ["129967390"] = true, ["129967478"] = true,
        }
        local shouldBlockAnimation = function(track)
            if not track or not track.Animation then return false end
            local animationId = tostring(track.Animation.AnimationId):match("%d+")
            local animationName = string.lower((track.Name or "") .. " " .. (track.Animation.Name or ""))
            return blockedAnimations[animationId] == true
                or string.find(animationName, "punch", 1, true) ~= nil
                or string.find(animationName, "attack", 1, true) ~= nil
                or string.find(animationName, "equip", 1, true) ~= nil
        end
        local isAttackTool = function(tool)
            if not tool or not tool:IsA("Tool") then return false end
            local n = string.lower(tool.Name)
            return string.find(n, "punch", 1, true) ~= nil
        end
        local hasAttackToolEquipped = function(character)
            if not character then return false end
            for _, child in ipairs(character:GetChildren()) do
                if isAttackTool(child) then return true end
            end
            return false
        end
        local stopBlockedAnimations = function(character)
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if shouldBlockAnimation(track) then track:Stop(0) end
            end
        end
        tabs.killing.runtime.animBlockConnection = utils.connect(services.RunService.RenderStepped, function()
            local char = player.Character
            if hasAttackToolEquipped(char) then
                stopBlockedAnimations(char)
            end
        end)
    else
        if tabs.killing.runtime.animBlockConnection then
            tabs.killing.runtime.animBlockConnection:Disconnect()
            tabs.killing.runtime.animBlockConnection = nil
        end
    end
end)

-- Auto Kill
tabs.killing:AddSection("Auto Kill")

_G.whitelistedPlayers = _G.whitelistedPlayers or {}
_G.blacklistedPlayers = _G.blacklistedPlayers or {}

_G.killAll = false
_G.killBlacklistedOnly = false
_G.farmBadKarma = false
_G.farmGoodKarma = false
_G.killAllGeneration = (_G.killAllGeneration or 0) + 1
_G.killListGeneration = (_G.killListGeneration or 0) + 1

tabs.killing.isWhitelisted = function(p)
    for _, name in ipairs(_G.whitelistedPlayers) do
        if name:lower() == p.Name:lower() then return true end
    end
    return false
end

tabs.killing.isBlacklisted = function(p)
    for _, name in ipairs(_G.blacklistedPlayers) do
        if name:lower() == p.Name:lower() then return true end
    end
    return false
end

-- Whitelist dropdown
tabs.killing.WhitelistDisplayNames = {}

tabs.killing.getWhitelistDisplayName = function(username)
    local cached = tabs.killing.WhitelistDisplayNames[username]
    if cached then return cached end
    local p = services.Players:FindFirstChild(username)
    if p then
        tabs.killing.WhitelistDisplayNames[username] = p.DisplayName
        return p.DisplayName
    end
    return username
end

local function getPlayerList()
    local list = {}
    for _, p in ipairs(services.Players:GetPlayers()) do
        if p ~= player then
            table.insert(list, p.DisplayName .. " | " .. p.Name)
        end
    end
    table.sort(list)
    return list
end

tabs.killing.WhitelistDropdown = tabs.killing:AddDropdown("Add to Whitelist", function(selectedText)
    local playerName = selectedText:match("| (.+)$")
    if playerName then
        playerName = playerName:gsub("^%s*(.-)%s*$", "%1")
        for _, name in ipairs(_G.whitelistedPlayers) do
            if name:lower() == playerName:lower() then return end
        end
        table.insert(_G.whitelistedPlayers, playerName)
        utils.notify("Whitelist", "Añadido: " .. playerName, 2, "success")
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.WhitelistDropdown:Add(item) end

tabs.killing:AddSwitch("Kill Everyone", function(bool)
    _G.killAll = bool
    _G.killAllGeneration = (_G.killAllGeneration or 0) + 1
    local generation = _G.killAllGeneration
    if not bool then return end

    task.spawn(function()
        while utils.isCurrent() and _G.killAll and _G.killAllGeneration == generation do
            local foundTarget = false
            for _, p in ipairs(services.Players:GetPlayers()) do
                if not _G.killAll or _G.killAllGeneration ~= generation then break end
                if p ~= player and not tabs.killing.isWhitelisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p) then
                    foundTarget = true
                    tabs.killing.attackPlayerForDuration(p, 4, function()
                        return _G.killAll and _G.killAllGeneration == generation and not tabs.killing.isWhitelisted(p)
                    end, 3.5)
                end
            end
            if foundTarget then
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end)

tabs.killing:AddSwitch("Whitelist Friends", function(bool)
    _G.whitelistFriends = bool
    if bool then
        for _, p in pairs(services.Players:GetPlayers()) do
            if p ~= player and p:IsFriendsWith(player.UserId) then
                if not tabs.killing.isWhitelisted(p) then
                    table.insert(_G.whitelistedPlayers, p.Name)
                end
            end
        end
        utils.connect(services.Players.PlayerAdded, function(p)
            if _G.whitelistFriends and p:IsFriendsWith(player.UserId) then
                if not tabs.killing.isWhitelisted(p) then
                    table.insert(_G.whitelistedPlayers, p.Name)
                end
            end
        end)
    end
end)

-- Karma
tabs.killing:AddSection("Karma Killing")

tabs.killing.KarmaData = {FarmEvil = false, FarmGood = false, Generation = 0}

tabs.killing.matchesKarmaMode = function(p)
    local good = p:FindFirstChild("goodKarma")
    local evil = p:FindFirstChild("evilKarma")
    if not good or not evil then return false end
    local gv, ev = good.Value or 0, evil.Value or 0
    if gv + ev < 5 then return false end
    return (tabs.killing.KarmaData.FarmEvil and gv > ev)
        or (tabs.killing.KarmaData.FarmGood and ev > gv)
end

tabs.killing.restartKarmaWorker = function()
    tabs.killing.KarmaData.Generation += 1
    local generation = tabs.killing.KarmaData.Generation
    if not tabs.killing.KarmaData.FarmEvil and not tabs.killing.KarmaData.FarmGood then return end
    task.spawn(function()
        while utils.isCurrent() and (tabs.killing.KarmaData.FarmEvil or tabs.killing.KarmaData.FarmGood)
            and tabs.killing.KarmaData.Generation == generation do
            local foundTarget = false
            for _, p in ipairs(services.Players:GetPlayers()) do
                if tabs.killing.KarmaData.Generation ~= generation then break end
                if p ~= player and not tabs.killing.isWhitelisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p)
                    and tabs.killing.matchesKarmaMode(p) then
                    foundTarget = true
                    tabs.killing.attackPlayerWithLimit(p, 4, function()
                        return tabs.killing.KarmaData.Generation == generation
                            and not tabs.killing.isWhitelisted(p)
                            and tabs.killing.matchesKarmaMode(p)
                    end, 3.5)
                end
            end
            if foundTarget then
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end

tabs.killing:AddSwitch("Farm Evil Karma", function(state)
    tabs.killing.KarmaData.FarmEvil = state
    tabs.killing.restartKarmaWorker()
end)

tabs.killing:AddSwitch("Farm Good Karma", function(state)
    tabs.killing.KarmaData.FarmGood = state
    tabs.killing.restartKarmaWorker()
end)

-- Target Killing
tabs.killing:AddSection("Target Killing")

tabs.killing.KilllistDisplayNames = {}

tabs.killing.getKilllistDisplayName = function(username)
    local cached = tabs.killing.KilllistDisplayNames[username]
    if cached then return cached end
    local p = services.Players:FindFirstChild(username)
    if p then
        tabs.killing.KilllistDisplayNames[username] = p.DisplayName
        return p.DisplayName
    end
    return username
end

tabs.killing.BlacklistDropdown = tabs.killing:AddDropdown("Add to Killlist", function(selectedText)
    local selectedUsername = selectedText:match("| (.+)$")
    if selectedUsername then
        selectedUsername = selectedUsername:gsub("^%s*(.-)%s*$", "%1")
        if not tabs.killing.isBlacklisted({Name = selectedUsername}) then
            table.insert(_G.blacklistedPlayers, selectedUsername)
            utils.notify("Killlist", "Añadido: " .. selectedUsername, 2, "success")
        end
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.BlacklistDropdown:Add(item) end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        tabs.killing.WhitelistDropdown:Add(p.DisplayName .. " | " .. p.Name)
        tabs.killing.BlacklistDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tabs.killing.WhitelistDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    tabs.killing.BlacklistDropdown:Remove(p.DisplayName .. " | " .. p.Name)
end)

tabs.killing:AddSwitch("Kill List", function(bool)
    _G.killBlacklistedOnly = bool
    _G.killListGeneration = (_G.killListGeneration or 0) + 1
    local generation = _G.killListGeneration
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.killBlacklistedOnly and _G.killListGeneration == generation do
            local target
            for _, p in ipairs(services.Players:GetPlayers()) do
                if not _G.killBlacklistedOnly or _G.killListGeneration ~= generation then break end
                if p ~= player and tabs.killing.isBlacklisted(p)
                    and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p) then
                    target = p
                    break
                end
            end
            if target then
                tabs.killing.touchAndPunchTarget(target, 10)
                services.RunService.Heartbeat:Wait()
            else
                task.wait(0.1)
            end
        end
    end)
end)

-- Spectate
tabs.killing:AddSection("Spectate")

tabs.killing.SpectateData = {
    SelectedPlayer = nil,
    SelectedPlayerUserId = nil,
    Spectating = false,
    CurrentTargetConnection = nil,
}

tabs.killing.stopSpectating = function()
    if tabs.killing.SpectateData.CurrentTargetConnection then
        tabs.killing.SpectateData.CurrentTargetConnection:Disconnect()
        tabs.killing.SpectateData.CurrentTargetConnection = nil
    end
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = humanoid
            utils.playerData.Camera.CameraType = Enum.CameraType.Custom
        end
    end
end

tabs.killing.updateSpectateTarget = function(p)
    if not p then
        tabs.killing.stopSpectating()
        return
    end
    tabs.killing.SpectateData.SelectedPlayerUserId = p.UserId
    tabs.killing.SpectateData.SelectedPlayer = p
    if tabs.killing.SpectateData.CurrentTargetConnection then
        tabs.killing.SpectateData.CurrentTargetConnection:Disconnect()
        tabs.killing.SpectateData.CurrentTargetConnection = nil
    end
    local function setCamera(char)
        if not tabs.killing.SpectateData.Spectating or tabs.killing.SpectateData.SelectedPlayerUserId ~= p.UserId then return end
        local humanoid = char:WaitForChild("Humanoid", 3)
        if humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = humanoid
        end
    end
    if p.Character then setCamera(p.Character) end
    tabs.killing.SpectateData.CurrentTargetConnection = utils.connect(p.CharacterAdded, function(newChar)
        if tabs.killing.SpectateData.Spectating then setCamera(newChar) end
    end)
end

tabs.killing.SpectateDropdown = tabs.killing:AddDropdown("Choose Player", function(text)
    for _, p in ipairs(services.Players:GetPlayers()) do
        if text == p.DisplayName .. " | " .. p.Name then
            tabs.killing.SpectateData.SelectedPlayer = p
            tabs.killing.SpectateData.SelectedPlayerUserId = p.UserId
            if tabs.killing.SpectateData.Spectating then
                tabs.killing.updateSpectateTarget(p)
            end
            break
        end
    end
end)
for _, item in ipairs(getPlayerList()) do tabs.killing.SpectateDropdown:Add(item) end

tabs.killing:AddSwitch("Spectate", function(bool)
    tabs.killing.SpectateData.Spectating = bool
    if bool then
        tabs.killing.updateSpectateTarget(tabs.killing.SpectateData.SelectedPlayer)
    else
        tabs.killing.stopSpectating()
    end
end)

utils.connect(services.Players.PlayerAdded, function(p)
    tabs.killing.SpectateDropdown:Add(p.DisplayName .. " | " .. p.Name)
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tabs.killing.SpectateDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if p.UserId == tabs.killing.SpectateData.SelectedPlayerUserId then
        tabs.killing.stopSpectating()
    end
end)

-- Kill Aura
tabs.killing:AddSection("Kill Aura")

tabs.killing.KillAura = {
    RingPart = nil,
    Range = 20,
    Enabled = false,
    Generation = 0,
}

_G.deathRingEnabled = false
_G.deathRingRange = 20

tabs.killing:AddTextBox("Range (1-140):", function(text)
    if tonumber(text) then
        _G.deathRingRange = math.clamp(tonumber(text), 1, 140)
        tabs.killing.KillAura.Range = _G.deathRingRange
        if tabs.killing.KillAura.RingPart then
            tabs.killing.KillAura.RingPart.Size = Vector3.new(0.2, _G.deathRingRange * 2, _G.deathRingRange * 2)
        end
    end
end, {clear = false})

tabs.killing:AddSwitch("Kill Aura", function(bool)
    tabs.killing.KillAura.Enabled = bool
    tabs.killing.KillAura.Generation += 1
    local generation = tabs.killing.KillAura.Generation

    if not bool then
        if tabs.killing.KillAura.RingPart then
            tabs.killing.KillAura.RingPart:Destroy()
            tabs.killing.KillAura.RingPart = nil
        end
        return
    end

    -- Crear anillo
    local ring = Instance.new("Part")
    ring.Name = "HonenxWhiteKillAuraRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = Color3.fromRGB(145, 77, 255)
    ring.Transparency = 0.6
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.CastShadow = false
    ring.Size = Vector3.new(0.2, tabs.killing.KillAura.Range * 2, tabs.killing.KillAura.Range * 2)
    ring.Parent = workspace
    tabs.killing.KillAura.RingPart = ring

    -- Loop
    task.spawn(function()
        while utils.isCurrent() and tabs.killing.KillAura.Enabled and tabs.killing.KillAura.Generation == generation do
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and ring.Parent then
                ring.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
                for _, p in ipairs(services.Players:GetPlayers()) do
                    if p ~= player and not tabs.killing.isWhitelisted(p)
                        and tabs.killing.isPlayerAlive(p) and not tabs.killing.isSpawnProtected(p) then
                        local targetRoot = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot and (root.Position - targetRoot.Position).Magnitude <= tabs.killing.KillAura.Range then
                            tabs.killing.touchAndPunchTarget(p, 3.5)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end)

-- Stats
tabs.killing:AddSection("Session Stats")
local killStatsLabel = tabs.killing:AddLabel("Kills: 0")
_G.killSessionStart = nil

task.spawn(function()
    while utils.isCurrent() do
        local ls = player:FindFirstChild("leaderstats")
        local kills = ls and ls:FindFirstChild("Kills")
        if kills and killStatsLabel then
            if not _G.killSessionStart then _G.killSessionStart = kills.Value end
            killStatsLabel:SetText("Kills: " .. utils.formatNumber(kills.Value) .. " (Sesión: " .. utils.formatNumber(kills.Value - _G.killSessionStart) .. ")")
        end
        task.wait(1)
    end
end)

utils.notify("HonenxWhite", "Tab Killing cargado ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- TAB FARMING
-- ═══════════════════════════════════════════════════════════════

tabs.farming:AddSection("Rebirths")

tabs.farming.RebirthData = {
    TargetRebirths = 0,
    IsAutoRebirthing = false,
    Rebirths = player.leaderstats:WaitForChild("Rebirths"),
}

local rebirthLabel = tabs.farming:AddLabel("Rebirths: 0")
local targetLabel = tabs.farming:AddLabel("Target: None")

tabs.farming:AddTextBox("Set Rebirth Target:", function(text)
    if tonumber(text) and tonumber(text) >= 0 then
        tabs.farming.RebirthData.TargetRebirths = tonumber(text)
    end
end)

tabs.farming.RebirthData.Switch = tabs.farming:AddSwitch("Auto Rebirth", function(enabled)
    if enabled and tabs.farming.RebirthData.TargetRebirths > 0 and tabs.farming.RebirthData.Rebirths.Value < tabs.farming.RebirthData.TargetRebirths then
        tabs.farming.RebirthData.IsAutoRebirthing = true
        task.spawn(function()
            while utils.isCurrent() and tabs.farming.RebirthData.IsAutoRebirthing
                and tabs.farming.RebirthData.Rebirths.Value < tabs.farming.RebirthData.TargetRebirths do
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.1)
            end
            tabs.farming.RebirthData.IsAutoRebirthing = false
            tabs.farming.RebirthData.Switch:Set(false, true)
        end)
    else
        tabs.farming.RebirthData.IsAutoRebirthing = false
    end
end)

task.spawn(function()
    while utils.isCurrent() do
        if rebirthLabel then
            rebirthLabel:SetText("Rebirths: " .. utils.formatWithCommas(tabs.farming.RebirthData.Rebirths.Value))
        end
        if targetLabel then
            targetLabel:SetText("Target Rebirths: " .. utils.formatWithCommas(tabs.farming.RebirthData.TargetRebirths))
        end
        task.wait(0.5)
    end
end)

-- Auto Size 1
tabs.farming:AddSection("Auto Size")

tabs.farming.SizeData = {Active = false}

tabs.farming.SizeSwitch = tabs.farming:AddSwitch("Auto Size 1", function(bool)
    tabs.farming.SizeData.Active = bool
end)
tabs.farming.SizeSwitch:Set(false)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.farming.SizeData.Active and utils.playerData.Character and utils.playerData.Humanoid then
            pcall(function()
                utils.remotes.ChangeSpeedSize:InvokeServer("changeSize", 1)
            end)
        end
        task.wait(0.5)
    end
end)

-- Auto King
tabs.farming:AddSection("Auto King")

tabs.farming.KingData = {
    TargetPosition = CFrame.new(-8665.4, 17.21, -5792.9),
    TeleportActive = false,
}

tabs.farming.KingSwitch = tabs.farming:AddSwitch("Auto King", function(enabled)
    tabs.farming.KingData.TeleportActive = enabled
end)

task.spawn(function()
    while utils.isCurrent() do
        if tabs.farming.KingData.TeleportActive then
            local char = utils.playerData.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and (root.Position - tabs.farming.KingData.TargetPosition.Position).Magnitude > 5 then
                    pcall(function()
                        root.CFrame = tabs.farming.KingData.TargetPosition
                    end)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Auto Exercises
tabs.farming:AddSection("Auto Exercises")

tabs.farming.ExerciseData = {
    SelectedTool = nil,
    AutoFarm = false,
}

local exerciseDropdown = tabs.farming:AddDropdown("Select Exercise", function(selection)
    tabs.farming.ExerciseData.SelectedTool = selection
end)
exerciseDropdown:Add("Weight")
exerciseDropdown:Add("Pushups")
exerciseDropdown:Add("Situps")
exerciseDropdown:Add("Handstands")

tabs.farming.ToolExerciseSwitch = tabs.farming:AddSwitch("Start Exercising", function(enabled)
    tabs.farming.ExerciseData.AutoFarm = enabled
    if enabled then
        task.spawn(function()
            while utils.isCurrent() and tabs.farming.ExerciseData.AutoFarm do
                local char = utils.playerData.Character
                local hum = utils.playerData.Humanoid
                if char and hum and hum.Health > 0 and tabs.farming.ExerciseData.SelectedTool then
                    local tool = char:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
                        or player.Backpack:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
                    if tool and tool.Parent ~= char then
                        pcall(function() hum:EquipTool(tool) end)
                    end
                    if tool and tool.Parent == char then
                        pcall(function()
                            player.muscleEvent:FireServer("rep")
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    else
        if tabs.farming.ExerciseData.SelectedTool and player.Character then
            local tool = player.Character:FindFirstChild(tabs.farming.ExerciseData.SelectedTool)
            if tool then tool.Parent = player.Backpack end
        end
    end
end)

tabs.farming.AutoRepRunning = false
tabs.farming.AutoRepSwitch = tabs.farming:AddSwitch("Auto Rep", function(state)
    tabs.farming.AutoRepRunning = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.farming.AutoRepRunning do
            pcall(function()
                player.muscleEvent:FireServer("rep")
            end)
            task.wait(0.1)
        end
    end)
end)

-- Auto Rock
tabs.farming:AddSection("Auto Rock")

tabs.farming.RockData = {
    Data = {
        ["Tiny Rock - 0 Dura"] = 0, ["Large Rock - 100 Dura"] = 100, ["Punching Rock - 10 Dura"] = 10,
        ["Golden Rock - 5k Dura"] = 5000, ["Frost Rock - 150k Dura"] = 150000, ["Mythical Rock - 400k Dura"] = 400000,
        ["Eternal Rock - 750k Dura"] = 750000, ["Legend Rock - 1m Dura"] = 1000000, ["Muscle King Rock - 5m Dura"] = 5000000,
        ["Jungle Rock - 10m Dura"] = 10000000, ["Industrial Rock - 25m Dura"] = 25000000,
    },
    SelectedRock = nil,
}

tabs.farming.MachinesFolder = workspace:WaitForChild("machinesFolder")

local rockDropdown = tabs.farming:AddDropdown("Select Rock", function(selection)
    tabs.farming.RockData.SelectedRock = selection
end)
for rockName in pairs(tabs.farming.RockData.Data) do
    rockDropdown:Add(rockName)
end

tabs.farming.RockSwitch = tabs.farming:AddSwitch("Auto Rock", function(enabled)
    _G.RockFarmRunning = enabled
    if not enabled or not tabs.farming.RockData.SelectedRock then return end
    task.spawn(function()
        while utils.isCurrent() and _G.RockFarmRunning do
            task.wait(0.12)
            local char = utils.playerData.Character
            if char and player:FindFirstChild("Durability") and player.Durability.Value >= tabs.farming.RockData.Data[tabs.farming.RockData.SelectedRock] then
                for _, v in pairs(tabs.farming.MachinesFolder:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == tabs.farming.RockData.Data[tabs.farming.RockData.SelectedRock]
                        and char:FindFirstChild("LeftHand") and v.Parent and v.Parent:FindFirstChild("Rock") then
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(v.Parent.Rock, char.RightHand, 0)
                                firetouchinterest(v.Parent.Rock, char.RightHand, 1)
                                firetouchinterest(v.Parent.Rock, char.LeftHand, 0)
                                firetouchinterest(v.Parent.Rock, char.LeftHand, 1)
                            end
                            tabs.killing.getTool()
                        end)
                    end
                end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB FAST
-- ═══════════════════════════════════════════════════════════════

-- Fast Rep
tabs.fast:AddSection("Fast Rep")

tabs.fast.FastRepData = {
    Running = false,
    WorkerActive = false,
    CyclesPerSecond = 40,
    RepsPerCycle = 20,
    SendRate = 800,
}

local fastRepStatus = tabs.fast:AddLabel("Status: Inactive")

tabs.fast.FastRepWorkerLoop = function()
    if tabs.fast.FastRepData.WorkerActive then return end
    tabs.fast.FastRepData.WorkerActive = true
    local data = tabs.fast.FastRepData
    local interval = 1 / 40

    while utils.isCurrent() and data.Running do
        pcall(function()
            for i = 1, 20 do
                player.muscleEvent:FireServer("rep")
            end
        end)
        fastRepStatus:SetText("Status: 800 reps/s (MAX)")
        task.wait(interval)
    end
    data.WorkerActive = false
end

tabs.fast:AddTextBox("Reps por ciclo (1-20):", function(text)
    local num = tonumber(text)
    if num and num >= 1 then
        tabs.fast.FastRepData.RepsPerCycle = math.clamp(math.floor(num), 1, 20)
    end
end)

tabs.fast.FastRepToggle = tabs.fast:AddSwitch("Fast Rep (Ultra Rápido)", function(state)
    local data = tabs.fast.FastRepData
    data.Running = state
    if state then
        fastRepStatus:SetText("Status: Activando...")
        if not data.WorkerActive then
            task.spawn(tabs.fast.FastRepWorkerLoop)
        end
    else
        fastRepStatus:SetText("Status: Inactive")
    end
end)

-- Ultra Fast Rep 20K
tabs.fast:AddSection("Ultra Fast Rep 20K")

local UltraState = {
    Enabled = false,
    WorkerActive = false,
    RepsPerCycle = 200,
    CycleDelay = 0.01,
    TotalReps = 0,
}
_G.HonenxWhiteUltraFastRep = UltraState

task.spawn(function()
    if UltraState.WorkerActive then return end
    UltraState.WorkerActive = true
    while utils.isCurrent() do
        if UltraState.Enabled then
            local muscle = player:FindFirstChild("muscleEvent")
            if muscle then
                local start = os.clock()
                for i = 1, UltraState.RepsPerCycle do
                    if not UltraState.Enabled then break end
                    pcall(function() muscle:FireServer("rep") end)
                    UltraState.TotalReps = UltraState.TotalReps + 1
                end
                local elapsed = os.clock() - start
                local sleepTime = UltraState.CycleDelay - elapsed
                if sleepTime > 0 then task.wait(sleepTime) else task.wait() end
            else
                task.wait(0.05)
            end
        else
            task.wait(0.1)
        end
    end
end)

tabs.fast:AddSwitch("🚀 Ultra Fast Rep (20000 reps/s)", function(state)
    UltraState.Enabled = state
    if state then
        UltraState.TotalReps = 0
        utils.notify("Ultra Fast Rep", "🚀 ACTIVADO - 20,000 reps/s", 3, "success")
    else
        utils.notify("Ultra Fast Rep", "⏸️ Desactivado", 2, "info")
    end
end)

-- Fast Rebirth
tabs.fast:AddSection("Fast Rebirth")

tabs.fast.FastRebirthData = {
    Running = false,
    WorkerActive = false,
    Rebirths = player.leaderstats:WaitForChild("Rebirths"),
    Strength = player.leaderstats:WaitForChild("Strength"),
    TargetRebirths = 0,
    TotalRebirths = 0,
}

local fastRebirthStatus = tabs.fast:AddLabel("Status: Inactive")
local fastRebirthStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.FastRebirthWorker = function()
    local startRebirths = tabs.fast.FastRebirthData.Rebirths.Value
    tabs.fast.FastRebirthData.TotalRebirths = 0

    while utils.isCurrent() and tabs.fast.FastRebirthData.Running do
        if tabs.fast.FastRebirthData.TargetRebirths > 0
            and tabs.fast.FastRebirthData.Rebirths.Value >= tabs.fast.FastRebirthData.TargetRebirths then
            fastRebirthStatus:SetText("Status: ✅ Target alcanzado!")
            tabs.fast.FastRebirthData.Running = false
            break
        end

        local currentRebirths = tabs.fast.FastRebirthData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 3 or 4

        fastRebirthStatus:SetText("Status: 💪 Farmeando... "
            .. utils.formatNumber(tabs.fast.FastRebirthData.Strength.Value)
            .. " / " .. utils.formatNumber(targetStrength))

        while utils.isCurrent() and tabs.fast.FastRebirthData.Running
            and tabs.fast.FastRebirthData.Strength.Value < targetStrength do
            for i = 1, repsPerBurst do
                pcall(function()
                    player.muscleEvent:FireServer("rep")
                end)
            end
            task.wait(0.05)
            fastRebirthStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.FastRebirthData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.FastRebirthData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.FastRebirthData.Running
            and tabs.fast.FastRebirthData.Strength.Value >= targetStrength then
            fastRebirthStatus:SetText("Status: 🔄 Haciendo rebirth...")
            local rebirthValueBefore = tabs.fast.FastRebirthData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.12)
                attempts = attempts + 1
            until not tabs.fast.FastRebirthData.Running
                or tabs.fast.FastRebirthData.Rebirths.Value > rebirthValueBefore
                or attempts >= 50
            if tabs.fast.FastRebirthData.Rebirths.Value > rebirthValueBefore then
                tabs.fast.FastRebirthData.TotalRebirths = tabs.fast.FastRebirthData.TotalRebirths +
                    (tabs.fast.FastRebirthData.Rebirths.Value - rebirthValueBefore)
            end
        end
        task.wait(0.3)
    end
    tabs.fast.FastRebirthData.WorkerActive = false
end

tabs.fast:AddTextBox("Target rebirths (0 = infinito):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.FastRebirthData.TargetRebirths = math.floor(num)
    end
end)

tabs.fast.FastRebirthToggle = tabs.fast:AddSwitch("Fast Rebirth 🔄", function(state)
    tabs.fast.FastRebirthData.Running = state
    if state then
        fastRebirthStatus:SetText("Status: 🔄 Iniciando...")
        if not tabs.fast.FastRebirthData.WorkerActive then
            tabs.fast.FastRebirthData.WorkerActive = true
            task.spawn(tabs.fast.FastRebirthWorker)
        end
    else
        fastRebirthStatus:SetText("Status: Inactive")
    end
end)

tabs.fast:AddLabel("Conserva mascotas equipadas, no activa packs")

utils.notify("HonenxWhite", "Tab Farming + Fast cargado ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- TAB BOSS
-- ═══════════════════════════════════════════════════════════════

tabs.boss:AddSection("Boss Farming")

local bossStatusLabel = tabs.boss:AddLabel("Status: Waiting for Boss")
local bossLabel = tabs.boss:AddLabel("Boss: None")
local bossHealthLabel = tabs.boss:AddLabel("Health: 0 / 0")
local nextBossLabel = tabs.boss:AddLabel("Next Boss: N/A")

tabs.boss.Data = {
    Running = false,
    ActiveMode = nil,
    Generation = 0,
    ContinueTraining = false,
    Phase = "Waiting",
    PunchInterval = 0.3,
    LastPunch = 0,
    Bosses = {},
    BossOrder = {},
    BossByDisplayName = {},
    SelectedBosses = {},
}

-- Funciones auxiliares
tabs.boss.getBossHealth = function(health)
    if health then
        if health:IsA("Humanoid") then return health.Health end
        local ok, value = pcall(function() return health.Value end)
        if ok and tonumber(value) then return tonumber(value) end
    end
    return workspace:GetAttribute("BossHealth") or 0
end

tabs.boss.getBossMaxHealth = function(maxHealth)
    if maxHealth then
        if maxHealth:IsA("Humanoid") then return maxHealth.MaxHealth end
        local ok, value = pcall(function() return maxHealth.Value end)
        if ok and tonumber(value) then return tonumber(value) end
    end
    return workspace:GetAttribute("BossMaxHealth") or 0
end

tabs.boss.getBossHeadPosition = function(model, hitbox)
    local head = model:FindFirstChild("Head", true) or model:FindFirstChild("head", true)
    if head and head:IsA("BasePart") then return head.Position end
    return hitbox.Position + Vector3.new(0, hitbox.Size.Y * 0.35, 0)
end

tabs.boss.findActiveBoss = function(mode)
    mode = mode or "Main"

    -- Buscar por tag primero
    for _, taggedBoss in ipairs(services.CollectionService:GetTagged("BossEventBoss")) do
        if taggedBoss:IsA("Model") and taggedBoss:IsDescendantOf(workspace) then
            local hitbox = taggedBoss:FindFirstChild("BossDamageHitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                local stats = taggedBoss:FindFirstChild("stats") or taggedBoss:FindFirstChild("Stats")
                local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
                local maxHealth = stats and (stats:FindFirstChild("MaxHealth") or stats:FindFirstChild("maxHealth"))
                local healthValue = health and tonumber(health.Value)
                if healthValue and healthValue > 0 then
                    return taggedBoss, hitbox, health, maxHealth
                end
                local hum = taggedBoss:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    return taggedBoss, hitbox, hum, hum
                end
            end
        end
    end

    -- Buscar en Events/BossEvent
    local events = workspace:FindFirstChild("Events")
    local bossFolder = events and (events:FindFirstChild("BossEvent") or events:FindFirstChild("BossArena"))
    if bossFolder then
        for _, descendant in ipairs(bossFolder:GetDescendants()) do
            if descendant:IsA("Model") then
                local hitbox = descendant:FindFirstChild("BossDamageHitbox", true)
                if hitbox and hitbox:IsA("BasePart") then
                    local hum = descendant:FindFirstChildOfClass("Humanoid")
                    local stats = descendant:FindFirstChild("stats") or descendant:FindFirstChild("Stats")
                    local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
                    local healthValue = health and tonumber(health.Value)
                    if (healthValue and healthValue > 0) or (hum and hum.Health > 0) then
                        return descendant, hitbox, health or hum, health or hum
                    end
                end
            end
        end
    end

    return nil
end

tabs.boss.attack = function(model, health, maxHealth, hitbox)
    if not model or not hitbox or not hitbox.Parent then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end

    -- Equipar Punch
    local punch = char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
    if punch and punch.Parent ~= char then
        pcall(function() hum:EquipTool(punch) end)
    end

    -- Posicionarse cerca del boss
    local center = hitbox.Position
    local offset = root.Position - center
    offset = Vector3.new(offset.X, 0, offset.Z)
    if offset.Magnitude < 1 then offset = hitbox.CFrame.LookVector end
    local standPos = center + offset.Unit * math.max(4, math.min(6, hitbox.Size.Magnitude * 0.2)) + Vector3.new(0, 1.5, 0)
    root.CFrame = CFrame.lookAt(standPos, center)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    -- Fire touch + punch
    local left = char:FindFirstChild("LeftHand")
    local right = char:FindFirstChild("RightHand")
    pcall(function()
        if firetouchinterest and left then
            firetouchinterest(hitbox, left, 0)
            firetouchinterest(hitbox, left, 1)
        end
        if firetouchinterest and right then
            firetouchinterest(hitbox, right, 0)
            firetouchinterest(hitbox, right, 1)
        end
    end)

    if os.clock() - tabs.boss.Data.LastPunch >= tabs.boss.Data.PunchInterval then
        tabs.boss.Data.LastPunch = os.clock()
        pcall(function()
            player.muscleEvent:FireServer("punch", "leftHand")
            player.muscleEvent:FireServer("punch", "rightHand")
            if punch then punch:Activate() end
        end)
    end

    local displayName = workspace:GetAttribute("BossDisplayName") or model.Name
    bossLabel:SetText("Boss: " .. displayName)
    local hv = tabs.boss.getBossHealth(health)
    local mhv = tabs.boss.getBossMaxHealth(maxHealth)
    bossHealthLabel:SetText("Health: " .. utils.formatNumber(hv) .. " / " .. utils.formatNumber(mhv))
end

-- Worker principal de auto boss
tabs.boss.startAutoFarm = function(mode, state)
    if not state then
        if tabs.boss.Data.ActiveMode == mode then
            tabs.boss.Data.Running = false
            tabs.boss.Data.ActiveMode = nil
            tabs.boss.Data.Generation += 1
            bossStatusLabel:SetText("Status: Disabled")
        end
        return
    end

    -- Apagar el otro modo
    if mode == "Main" and tabs.boss.HalloweenSwitch then
        tabs.boss.HalloweenSwitch:Set(false, true)
    elseif mode == "Halloween" and tabs.boss.MainSwitch then
        tabs.boss.MainSwitch:Set(false, true)
    end

    tabs.boss.Data.ActiveMode = mode
    tabs.boss.Data.Running = true
    tabs.boss.Data.Generation += 1
    local generation = tabs.boss.Data.Generation

    task.spawn(function()
        while utils.isCurrent() and tabs.boss.Data.Running and tabs.boss.Data.Generation == generation do
            local model, hitbox, health, maxHealth = tabs.boss.findActiveBoss(mode)
            if model and hitbox then
                bossStatusLabel:SetText("Status: Fighting " .. (mode == "Halloween" and "Halloween Boss" or "Main Boss"))
                tabs.boss.attack(model, health, maxHealth, hitbox)
                task.wait(0.03)
            else
                bossStatusLabel:SetText("Status: Waiting for " .. (mode == "Halloween" and "Halloween Boss" or "Main Boss"))
                bossLabel:SetText("Boss: None")
                bossHealthLabel:SetText("Health: 0 / 0")
                task.wait(0.5)
            end
        end
    end)
end

tabs.boss.MainSwitch = tabs.boss:AddSwitch("Auto Boss — Main Island", function(state)
    tabs.boss.startAutoFarm("Main", state)
end)
tabs.boss.MainSwitch:Set(false)

tabs.boss.HalloweenSwitch = tabs.boss:AddSwitch("Auto Boss — Halloween", function(state)
    tabs.boss.startAutoFarm("Halloween", state)
end)
tabs.boss.HalloweenSwitch:Set(false)

tabs.boss:AddSwitch("Continue Training after Boss", function(state)
    tabs.boss.Data.ContinueTraining = state
end)

tabs.boss:AddSection("Info")
task.spawn(function()
    while utils.isCurrent() do
        if not tabs.boss.Data.Running then
            local nextTime = workspace:GetAttribute("BossSpawnNextTime")
            if typeof(nextTime) == "number" then
                local seconds = math.max(0, nextTime - workspace:GetServerTimeNow())
                local h = math.floor(seconds / 3600)
                local m = math.floor((seconds % 3600) / 60)
                local s = math.floor(seconds % 60)
                nextBossLabel:SetText(string.format("Next Boss: %dh %dm %ds", h, m, s))
            else
                nextBossLabel:SetText("Next Boss: N/A")
            end
        end
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB PETS
-- ═══════════════════════════════════════════════════════════════

tabs.inventory:AddSection("Pet Shop")

tabs.inventory.PetShopRuntime = services.ReplicatedStorage:WaitForChild("shared"):WaitForChild("runtime")
tabs.inventory.PetShopFolder = tabs.inventory.PetShopRuntime:WaitForChild("cPetShopFolder")
tabs.inventory.PetShopRemote = services.ReplicatedStorage.rEvents:WaitForChild("cPetShopRemote")

tabs.inventory.PetShopData = {
    PetList = {},
    Selected = {},
    SelectedList = {},
    BuyAmount = 1,
}

tabs.inventory.AuraData = {
    AuraList = {},
    Selected = {},
    SelectedList = {},
    BuyAmount = 1,
}

for _, item in ipairs(tabs.inventory.PetShopFolder:GetChildren()) do
    if item:GetAttribute("IsPowerUp") == true then
        table.insert(tabs.inventory.AuraData.AuraList, item.Name)
    else
        table.insert(tabs.inventory.PetShopData.PetList, item.Name)
    end
end
table.sort(tabs.inventory.PetShopData.PetList)
table.sort(tabs.inventory.AuraData.AuraList)

local buyPetLabel = tabs.inventory:AddLabel("Selected Pets: None")

local petShopDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.PetShopData.Selected[text] then
        tabs.inventory.PetShopData.Selected[text] = true
        table.insert(tabs.inventory.PetShopData.SelectedList, text)
    end
    buyPetLabel:SetText("Selected Pets: " .. (#tabs.inventory.PetShopData.SelectedList > 0 and table.concat(tabs.inventory.PetShopData.SelectedList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    petShopDropdown:Add(petName)
end

tabs.inventory:AddTextBox("Buy Amount:", function(text)
    tabs.inventory.PetShopData.BuyAmount = math.max(1, math.floor(tonumber(text) or 1))
end, {clear = false})

tabs.inventory:AddSwitch("Auto Buy Pet", function(bool)
    _G.AutoHatchPet = bool
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.AutoHatchPet do
            for _, petName in ipairs(tabs.inventory.PetShopData.SelectedList) do
                local selectedPet = tabs.inventory.PetShopFolder:FindFirstChild(petName)
                if selectedPet then
                    for _ = 1, tabs.inventory.PetShopData.BuyAmount do
                        pcall(function()
                            tabs.inventory.PetShopRemote:InvokeServer(selectedPet)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

tabs.inventory:AddButton("Clear Selected Pets", function()
    tabs.inventory.PetShopData.Selected = {}
    tabs.inventory.PetShopData.SelectedList = {}
    buyPetLabel:SetText("Selected Pets: None")
end)

-- Auras
tabs.inventory:AddSection("Auras")

local buyAuraLabel = tabs.inventory:AddLabel("Selected Auras: None")

local auraDropdown = tabs.inventory:AddDropdown("Choose Aura", function(text)
    if not tabs.inventory.AuraData.Selected[text] then
        tabs.inventory.AuraData.Selected[text] = true
        table.insert(tabs.inventory.AuraData.SelectedList, text)
    end
    buyAuraLabel:SetText("Selected Auras: " .. (#tabs.inventory.AuraData.SelectedList > 0 and table.concat(tabs.inventory.AuraData.SelectedList, ", ") or "None"))
end)
for _, auraName in ipairs(tabs.inventory.AuraData.AuraList) do
    auraDropdown:Add(auraName)
end

tabs.inventory:AddTextBox("Buy Amount:", function(text)
    tabs.inventory.AuraData.BuyAmount = math.max(1, math.floor(tonumber(text) or 1))
end, {clear = false})

tabs.inventory:AddSwitch("Auto Buy Aura", function(bool)
    _G.AutoHatchAura = bool
    if not bool then return end
    task.spawn(function()
        while utils.isCurrent() and _G.AutoHatchAura do
            for _, auraName in ipairs(tabs.inventory.AuraData.SelectedList) do
                local selectedAura = tabs.inventory.PetShopFolder:FindFirstChild(auraName)
                if selectedAura then
                    for _ = 1, tabs.inventory.AuraData.BuyAmount do
                        pcall(function()
                            tabs.inventory.PetShopRemote:InvokeServer(selectedAura)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Auto Evolve
tabs.inventory:AddSection("Auto Evolve")

tabs.inventory.EvolveData = {Selected = {}, SelectedList = {}, Amount = 1}

local evolveLabel = tabs.inventory:AddLabel("Selected Pets: None")

local evolveDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.EvolveData.Selected[text] then
        tabs.inventory.EvolveData.Selected[text] = true
        table.insert(tabs.inventory.EvolveData.SelectedList, text)
    end
    evolveLabel:SetText("Selected Pets: " .. (#tabs.inventory.EvolveData.SelectedList > 0 and table.concat(tabs.inventory.EvolveData.SelectedList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    evolveDropdown:Add(petName)
end

tabs.inventory:AddTextBox("Evolve Amount:", function(text)
    tabs.inventory.EvolveData.Amount = math.max(1, math.floor(tonumber(text) or 1))
end, {clear = false})

tabs.inventory.AutoEvolveRunning = false
tabs.inventory:AddSwitch("Auto Evolve", function(state)
    tabs.inventory.AutoEvolveRunning = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoEvolveRunning do
            for _, petName in ipairs(tabs.inventory.EvolveData.SelectedList) do
                for _ = 1, tabs.inventory.EvolveData.Amount do
                    pcall(function()
                        services.ReplicatedStorage.rEvents.petEvolveEvent:FireServer("evolvePet", petName)
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- Auto Trade
tabs.inventory:AddSection("Auto Trade")

tabs.inventory.TradeData = {
    SelectedPlayers = {},
    SelectedPlayerList = {},
    SelectedPets = {},
    SelectedPetList = {},
    Generation = 0,
}

local tradePlayerLabel = tabs.inventory:AddLabel("Selected Players: None")
local tradePetLabel = tabs.inventory:AddLabel("Selected Pets: None")

local tradePlayerDropdown = tabs.inventory:AddDropdown("Choose Player", function(name)
    local username = name:match("| (.+)$") or name
    if not tabs.inventory.TradeData.SelectedPlayers[username] then
        tabs.inventory.TradeData.SelectedPlayers[username] = true
        table.insert(tabs.inventory.TradeData.SelectedPlayerList, username)
    end
    tradePlayerLabel:SetText("Selected Players: " .. (#tabs.inventory.TradeData.SelectedPlayerList > 0 and table.concat(tabs.inventory.TradeData.SelectedPlayerList, ", ") or "None"))
end)

for _, p in ipairs(services.Players:GetPlayers()) do
    if p ~= player then
        tradePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

local tradePetDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    if not tabs.inventory.TradeData.SelectedPets[text] then
        tabs.inventory.TradeData.SelectedPets[text] = true
        table.insert(tabs.inventory.TradeData.SelectedPetList, text)
    end
    tradePetLabel:SetText("Selected Pets: " .. (#tabs.inventory.TradeData.SelectedPetList > 0 and table.concat(tabs.inventory.TradeData.SelectedPetList, ", ") or "None"))
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    tradePetDropdown:Add(petName)
end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        tradePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    tradePlayerDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if tabs.inventory.TradeData.SelectedPlayers[p.Name] then
        tabs.inventory.TradeData.SelectedPlayers[p.Name] = nil
        for i, v in ipairs(tabs.inventory.TradeData.SelectedPlayerList) do
            if v == p.Name then table.remove(tabs.inventory.TradeData.SelectedPlayerList, i) break end
        end
        tradePlayerLabel:SetText("Selected Players: " .. (#tabs.inventory.TradeData.SelectedPlayerList > 0 and table.concat(tabs.inventory.TradeData.SelectedPlayerList, ", ") or "None"))
    end
end)

tabs.inventory.AutoTradeRunning = false
tabs.inventory:AddSwitch("Auto Trade", function(state)
    tabs.inventory.AutoTradeRunning = state
    tabs.inventory.TradeData.Generation += 1
    if not state then return end
    local generation = tabs.inventory.TradeData.Generation

    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoTradeRunning and tabs.inventory.TradeData.Generation == generation do
            if #tabs.inventory.TradeData.SelectedPlayerList > 0 and #tabs.inventory.TradeData.SelectedPetList > 0 then
                for _, username in ipairs(tabs.inventory.TradeData.SelectedPlayerList) do
                    local tradePlayer = services.Players:FindFirstChild(username)
                    if not tabs.inventory.AutoTradeRunning or tabs.inventory.TradeData.Generation ~= generation then break end
                    if tradePlayer then
                        local tradingEvent = services.ReplicatedStorage.rEvents.tradingEvent
                        local unique = player.petsFolder.Unique
                        pcall(function()
                            tradingEvent:FireServer("sendTradeRequest", tradePlayer)
                        end)
                        task.wait(0.5)
                        local offered = 0
                        local offeredPets = {}
                        for _, selectedName in ipairs(tabs.inventory.TradeData.SelectedPetList) do
                            for _, pet in ipairs(unique:GetChildren()) do
                                if pet.Name == selectedName and not offeredPets[pet] and offered < 6 then
                                    pcall(function()
                                        tradingEvent:FireServer("offerItem", pet)
                                    end)
                                    offeredPets[pet] = true
                                    offered = offered + 1
                                    task.wait(0.05)
                                    break
                                end
                            end
                        end
                        if offered > 0 then
                            task.wait(0.5)
                            pcall(function()
                                tradingEvent:FireServer("acceptTrade")
                            end)
                            task.wait(2)
                        end
                    end
                end
            end
            task.wait(2)
        end
    end)
end)

utils.notify("HonenxWhite", "Tab Boss + Pets cargado ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- TAB BOOSTS
-- ═══════════════════════════════════════════════════════════════

tabs.boosts:AddSection("Boost Eater")

tabs.boosts.EggEaterData = {Running = false}

tabs.boosts:AddSwitch("Eat All Eggs", function(state)
    tabs.boosts.EggEaterData.Running = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.boosts.EggEaterData.Running do
            local char = player.Character
            local egg = char and char:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
            if egg then
                pcall(function()
                    player.muscleEvent:FireServer("proteinEgg", egg)
                end)
            end
            task.wait(0.25)
        end
    end)
end):Set(false)

tabs.boosts.BoostData = {
    ItemList = {"Tropical Shake", "Energy Shake", "Protein Bar", "TOUGH Bar", "Protein Shake", "ULTRA Shake", "Energy Bar"},
    Running = false,
}

tabs.boosts:AddSwitch("Eat All Boosts (expect lag)", function(state)
    tabs.boosts.BoostData.Running = state
    if not state then return end
    task.spawn(function()
        while utils.isCurrent() and tabs.boosts.BoostData.Running do
            local char = player.Character
            for _, itemName in ipairs(tabs.boosts.BoostData.ItemList) do
                local tool = char and char:FindFirstChild(itemName) or player.Backpack:FindFirstChild(itemName)
                if tool then
                    local parts = {}
                    for word in itemName:gmatch("%S+") do
                        table.insert(parts, word:lower())
                    end
                    for i = 2, #parts do
                        parts[i] = parts[i]:sub(1, 1):upper() .. parts[i]:sub(2)
                    end
                    for _ = 1, 10 do
                        pcall(function()
                            player.muscleEvent:FireServer(table.concat(parts), tool)
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- Egg Gifter
tabs.boosts:AddSection("Egg Gifter")

tabs.boosts.EggGifterData = {
    SelectedPlayer = nil,
    EggCount = 0,
}

local eggCountLabel = tabs.boosts:AddLabel("Protein Eggs: 0")

local eggPlayerDropdown = tabs.boosts:AddDropdown("Choose Player", function(name)
    local username = name:match("| (.+)$") or name
    tabs.boosts.EggGifterData.SelectedPlayer = services.Players:FindFirstChild(username)
end)

for _, p in ipairs(services.Players:GetPlayers()) do
    if p ~= player then
        eggPlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        eggPlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    eggPlayerDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if tabs.boosts.EggGifterData.SelectedPlayer == p then
        tabs.boosts.EggGifterData.SelectedPlayer = nil
    end
end)

local eggAmountBox = tabs.boosts:AddTextBox("Amount:", function(text)
    local n = tonumber(text)
    if n then
        tabs.boosts.EggGifterData.EggCount = math.max(0, math.floor(n))
    end
end, {clear = false})

tabs.boosts:AddButton("Start Gifting Eggs", function()
    local amount = tonumber(eggAmountBox.Text) or tabs.boosts.EggGifterData.EggCount
    amount = math.max(0, math.floor(amount))
    tabs.boosts.EggGifterData.EggCount = amount

    if not tabs.boosts.EggGifterData.SelectedPlayer or amount == 0 then
        utils.notify("Egg Gifter", "Configurá jugador y cantidad", 2, "warning")
        return
    end

    task.spawn(function()
        for _ = 1, amount do
            local egg = player:FindFirstChild("consumablesFolder") and player.consumablesFolder:FindFirstChild("Protein Egg")
            if not egg then break end
            pcall(function()
                services.ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", tabs.boosts.EggGifterData.SelectedPlayer, egg)
            end)
            task.wait(0.1)
        end
        utils.notify("Egg Gifter", "Envío completado", 3, "success")
    end)
end)

-- Shake Gifter
tabs.boosts:AddSection("Shake Gifter")

tabs.boosts.ShakeGifterData = {
    SelectedPlayer = nil,
    ShakeCount = 0,
}

local shakeCountLabel = tabs.boosts:AddLabel("Tropical Shakes: 0")

local shakePlayerDropdown = tabs.boosts:AddDropdown("Choose Player", function(name)
    local username = name:match("| (.+)$") or name
    tabs.boosts.ShakeGifterData.SelectedPlayer = services.Players:FindFirstChild(username)
end)

for _, p in ipairs(services.Players:GetPlayers()) do
    if p ~= player then
        shakePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end

utils.connect(services.Players.PlayerAdded, function(p)
    if p ~= player then
        shakePlayerDropdown:Add(p.DisplayName .. " | " .. p.Name)
    end
end)

utils.connect(services.Players.PlayerRemoving, function(p)
    shakePlayerDropdown:Remove(p.DisplayName .. " | " .. p.Name)
    if tabs.boosts.ShakeGifterData.SelectedPlayer == p then
        tabs.boosts.ShakeGifterData.SelectedPlayer = nil
    end
end)

local shakeAmountBox = tabs.boosts:AddTextBox("Amount:", function(text)
    local n = tonumber(text)
    if n then
        tabs.boosts.ShakeGifterData.ShakeCount = math.max(0, math.floor(n))
    end
end, {clear = false})

tabs.boosts:AddButton("Start Gifting Shakes", function()
    local amount = tonumber(shakeAmountBox.Text) or tabs.boosts.ShakeGifterData.ShakeCount
    amount = math.max(0, math.floor(amount))
    tabs.boosts.ShakeGifterData.ShakeCount = amount

    if not tabs.boosts.ShakeGifterData.SelectedPlayer or amount == 0 then
        utils.notify("Shake Gifter", "Configurá jugador y cantidad", 2, "warning")
        return
    end

    task.spawn(function()
        for _ = 1, amount do
            local shake = player:FindFirstChild("consumablesFolder") and player.consumablesFolder:FindFirstChild("Tropical Shake")
            if not shake then break end
            pcall(function()
                services.ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", tabs.boosts.ShakeGifterData.SelectedPlayer, shake)
            end)
            task.wait(0.1)
        end
        utils.notify("Shake Gifter", "Envío completado", 3, "success")
    end)
end)

-- Contador en vivo
task.spawn(function()
    while utils.isCurrent() do
        local eggCount = 0
        local shakeCount = 0
        local char = player.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item.Name == "Protein Egg" then eggCount = eggCount + 1
                elseif item.Name == "Tropical Shake" then shakeCount = shakeCount + 1 end
            end
        end
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item.Name == "Protein Egg" then eggCount = eggCount + 1
            elseif item.Name == "Tropical Shake" then shakeCount = shakeCount + 1 end
        end
        eggCountLabel:SetText("Protein Eggs: " .. eggCount)
        shakeCountLabel:SetText("Tropical Shakes: " .. shakeCount)
        task.wait(2)
    end
end)

tabs.boosts:AddLabel("Interfiere con Boosts regalados. Subí a una máquina para menos lag.")

-- ═══════════════════════════════════════════════════════════════
-- TAB TELEPORTS
-- ═══════════════════════════════════════════════════════════════

tabs.teleport:AddSection("Main")

tabs.teleport.Locations = {
    {name = "Tiny Island", pos = CFrame.new(-37.1, 9.2, 1919)},
    {name = "Main Island", pos = CFrame.new(16.07, 9.08, 133.8)},
    {name = "Beach", pos = CFrame.new(-8, 9, -169.2)},
}

for _, loc in ipairs(tabs.teleport.Locations) do
    tabs.teleport:AddButton(loc.name, function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = loc.pos
                utils.notify("Teleport", "Teletransportado a " .. loc.name, 1.5, "success")
            end
        end
    end)
end

tabs.teleport:AddSection("Gyms")

tabs.teleport.GymLocations = {
    {name = "Overcharged Gym", pos = CFrame.new(-2941.766, 151.797, 4994.552)},
    {name = "Industrial Gym", pos = CFrame.new(-5254.681641, 58.342850, 4931.850586)},
    {name = "Jungle Gym", pos = CFrame.new(-8543, 6.8, 2400)},
    {name = "Muscle King Gym", pos = CFrame.new(-8665.4, 17.21, -5792.9)},
    {name = "Legends Gym", pos = CFrame.new(4516, 991.5, -3856)},
    {name = "Infernal Gym", pos = CFrame.new(-6759, 7.36, -1284)},
    {name = "Mythical Gym", pos = CFrame.new(2250, 7.37, 1073.2)},
    {name = "Frost Gym", pos = CFrame.new(-2623, 7.36, -409)},
}

for _, gym in ipairs(tabs.teleport.GymLocations) do
    tabs.teleport:AddButton(gym.name, function()
        local char = player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = gym.pos
                utils.notify("Teleport", "Teletransportado a " .. gym.name, 1.5, "success")
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- TAB STATS
-- ═══════════════════════════════════════════════════════════════

tabs.stats:AddSection("Métricas en Tiempo Real")

tabs.stats.Data = {
    StartTime = tick(),
    StartStrength = player.leaderstats:WaitForChild("Strength").Value,
    StartRebirths = player.leaderstats:WaitForChild("Rebirths").Value,
}

local strengthGainedLabel = tabs.stats:AddLabel("Fuerza ganada: 0")
local strengthHourLabel = tabs.stats:AddLabel("x 1 Hora: 0")
local strengthDayLabel = tabs.stats:AddLabel("x 1 Día: 0")
local strengthWeekLabel = tabs.stats:AddLabel("x 1 Semana: 0")

tabs.stats:AddLabel("")

local rebirthsGainedLabel = tabs.stats:AddLabel("Rebirths ganados: 0")
local rebirthsHourLabel = tabs.stats:AddLabel("x 1 Hora: 0")
local rebirthsDayLabel = tabs.stats:AddLabel("x 1 Día: 0")
local rebirthsWeekLabel = tabs.stats:AddLabel("x 1 Semana: 0")

tabs.stats:AddLabel("")

local sessionTimeLabel = tabs.stats:AddLabel("Tiempo en sesión: 0s")

local function formatStat(n)
    if n == nil or n ~= n then return "0" end
    local absN = math.abs(n)
    local sign = n < 0 and "-" or ""
    if absN >= 1e18 then return sign .. string.format("%.2fqi", absN / 1e18)
    elseif absN >= 1e15 then return sign .. string.format("%.2fqa", absN / 1e15)
    elseif absN >= 1e12 then return sign .. string.format("%.2ft", absN / 1e12)
    elseif absN >= 1e9 then return sign .. string.format("%.2fb", absN / 1e9)
    elseif absN >= 1e6 then return sign .. string.format("%.2fm", absN / 1e6)
    elseif absN >= 1e3 then return sign .. string.format("%.2fk", absN / 1e3)
    elseif absN >= 1 then return sign .. string.format("%.0f", absN)
    else return sign .. string.format("%.2f", absN) end
end

local function formatTiempo(segundos)
    if segundos < 60 then return string.format("%ds", math.floor(segundos))
    elseif segundos < 3600 then return string.format("%dm %ds", math.floor(segundos / 60), math.floor(segundos % 60))
    elseif segundos < 86400 then return string.format("%dh %dm", math.floor(segundos / 3600), math.floor((segundos % 3600) / 60))
    else return string.format("%dd %dh", math.floor(segundos / 86400), math.floor((segundos % 86400) / 3600)) end
end

task.spawn(function()
    while utils.isCurrent() do
        local now = tick()
        local elapsed = now - tabs.stats.Data.StartTime
        if elapsed > 0.5 then
            local curStrength = player.leaderstats.Strength.Value
            local curRebirths = player.leaderstats.Rebirths.Value
            local gainS = curStrength - tabs.stats.Data.StartStrength
            local gainR = curRebirths - tabs.stats.Data.StartRebirths
            local rateS = (gainS / elapsed) * 3600
            local rateR = (gainR / elapsed) * 3600
            strengthGainedLabel:SetText("Fuerza ganada: " .. formatStat(gainS))
            strengthHourLabel:SetText("x 1 Hora: " .. formatStat(rateS))
            strengthDayLabel:SetText("x 1 Día: " .. formatStat(rateS * 24))
            strengthWeekLabel:SetText("x 1 Semana: " .. formatStat(rateS * 24 * 7))
            rebirthsGainedLabel:SetText("Rebirths ganados: " .. formatStat(gainR))
            rebirthsHourLabel:SetText("x 1 Hora: " .. formatStat(rateR))
            rebirthsDayLabel:SetText("x 1 Día: " .. formatStat(rateR * 24))
            rebirthsWeekLabel:SetText("x 1 Semana: " .. formatStat(rateR * 24 * 7))
            sessionTimeLabel:SetText("Tiempo en sesión: " .. formatTiempo(elapsed))
        end
        task.wait(1)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB INFO (ACTUALIZADO)
-- ═══════════════════════════════════════════════════════════════

tabs.info:AddSection("Información")
tabs.info:AddLabel("HonenxWhite | Reborn")
tabs.info:AddLabel("Version 2.0 - KNI UI")
tabs.info:AddLabel("Made by Honen / cyanam1 / White")
tabs.info:AddLabel("")

tabs.info:AddButton("📋 Copiar Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        utils.notify("Discord", "Link copiado", 2, "success")
    end
end)

tabs.info:AddLabel("")
tabs.info:AddLabel("Contributors:")
tabs.info:AddLabel("- cyanam1 (@honey)")
tabs.info:AddLabel("- White @chilin6369")
tabs.info:AddLabel("- Honen @Owner")
tabs.info:AddLabel("")
tabs.info:AddLabel("KNI UI - v2.0")

-- ═══════════════════════════════════════════════════════════════
-- ANTI-AFK INDEPENDIENTE
-- ═══════════════════════════════════════════════════════════════

tabs.main:AddSection("Anti-AFK")

_G.HonenxAntiAFK = true
tabs.main.AntiAFKSwitch = tabs.main:AddSwitch("Anti AFK", function(state)
    _G.HonenxAntiAFK = state
    if state then
        utils.notify("Anti-AFK", "✅ Activado", 2, "success")
    else
        utils.notify("Anti-AFK", "❌ Desactivado", 2, "info")
    end
end)
tabs.main.AntiAFKSwitch:Set(true)

task.spawn(function()
    while utils.isCurrent() do
        task.wait(60)
        if _G.HonenxAntiAFK then
            pcall(function()
                services.VirtualUser:CaptureController()
                services.VirtualUser:ClickButton2(Vector2.new(0, 0))
                services.VirtualUser:ClickButton1(Vector2.new(0, 0))
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- CIERRE
-- ═══════════════════════════════════════════════════════════════

utils.notify("HonenxWhite", "🎉 Hub completo cargado correctamente", 4, "success")
print("[HonenxWhite] Script cargado al 100%")
