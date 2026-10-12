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
