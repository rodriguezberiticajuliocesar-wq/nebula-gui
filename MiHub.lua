--[[
    ═══════════════════════════════════════════════════════════════
    HonenxWhite Reborn — MiHub
    Repositorio: github.com/rodriguezberiticajuliocesar-wq/nebula-gui
    Made by Honen
    ═══════════════════════════════════════════════════════════════
    Este archivo se construye por PARTES. Cada parte se pega AL FINAL
    de la anterior. Al terminar, queda un solo script funcional.
    ═══════════════════════════════════════════════════════════════
]]

-- ═══════════ CARGAR LIBRERÍA ═══════════
local LIB_URL = "https://raw.githubusercontent.com/rodriguezberiticajuliocesar-wq/nebula-gui/main/NebulaGUI.lua"
local ok, NebulaGUI = pcall(function()
    return loadstring(game:HttpGet(LIB_URL, true))()
end)

if not ok or type(NebulaGUI) ~= "table" then
    warn("[HonenxWhite] Error al cargar NebulaGUI: " .. tostring(NebulaGUI))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "HonenxWhite",
            Text = "Error al cargar la librería GUI.",
            Duration = 5,
        })
    end)
    return
end

-- ═══════════ SERVICIOS ═══════════
local Services = {
    Players             = game:GetService("Players"),
    ReplicatedStorage   = game:GetService("ReplicatedStorage"),
    RunService          = game:GetService("RunService"),
    UserInputService    = game:GetService("UserInputService"),
    VirtualUser         = game:GetService("VirtualUser"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    TweenService        = game:GetService("TweenService"),
    Lighting            = game:GetService("Lighting"),
    Stats               = game:GetService("Stats"),
    StarterGui          = game:GetService("StarterGui"),
    HttpService         = game:GetService("HttpService"),
    TeleportService     = game:GetService("TeleportService"),
    ContextActionService = game:GetService("ContextActionService"),
    CollectionService   = game:GetService("CollectionService"),
}
local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- ═══════════ UTILS ═══════════
local Utils = {}

function Utils.getCharacter()
    return LocalPlayer.Character
end

function Utils.getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils.getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Utils.formatNumber(n)
    n = tonumber(n) or 0
    if n >= 1e18 then return string.format("%.1fqi", n / 1e18)
    elseif n >= 1e15 then return string.format("%.1fqa", n / 1e15)
    elseif n >= 1e12 then return string.format("%.1ft", n / 1e12)
    elseif n >= 1e9 then return string.format("%.1fb", n / 1e9)
    elseif n >= 1e6 then return string.format("%.1fm", n / 1e6)
    elseif n >= 1e3 then return string.format("%.1fk", n / 1e3)
    else return tostring(math.floor(n)) end
end

function Utils.formatCommas(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    while true do
        local newS, count = s:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
        s = newS
        if count == 0 then break end
    end
    return s
end

function Utils.notify(title, text, duration, kind)
    pcall(function()
        NebulaGUI.Notify.show(title, text, duration or 3, kind or "info")
    end)
end

_G.Young0xUtils = Utils

-- ═══════════ ANTI-AFK (default ON) ═══════════
_G.Young0xAntiAFK = true
LocalPlayer.Idled:Connect(function()
    if _G.Young0xAntiAFK then
        pcall(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new(0, 0))
            Services.VirtualUser:ClickButton1(Vector2.new(0, 0))
        end)
    end
end)

-- ═══════════ CREAR VENTANA ═══════════
local win = NebulaGUI:CreateWindow({
    Title = "HonenxWhite | Reborn",
    Subtitle = "Made by Honen",
    Size = UDim2.fromOffset(820, 520),
})

_G.Young0xWindow = win

-- ═══════════ CREAR TABS ═══════════
local Tabs = {
    Main      = win:AddTab("Main", "🏠"),
    Killing   = win:AddTab("Killing", "⚔️"),
    Specs     = win:AddTab("Specs", "📊"),
    Farming   = win:AddTab("Farming", "💪"),
    Fast      = win:AddTab("Fast", "⚡"),
    Boss      = win:AddTab("Boss", "👹"),
    Pets      = win:AddTab("Pets", "🐾"),
    Boosts    = win:AddTab("Boosts", "🎁"),
    Teleports = win:AddTab("TPs", "🌐"),
    Stats     = win:AddTab("Stats", "📈"),
    Info      = win:AddTab("Info", "ℹ️"),
}

_G.Young0xTabs = Tabs

-- Placeholder para verificar que carga
Tabs.Info:AddLabel("Made by Honen")
Tabs.Info:AddLabel("Rebuild 2026")

Utils.notify("HonenxWhite", "Parte 1 cargada — sigue la Parte 2", 3, "success")

-- ═══════════ [FIN PARTE 1] ═══════════
-- ═══════════════════════════════════════════════════════════════
-- [PARTE 2] TAB MAIN
-- ═══════════════════════════════════════════════════════════════

local MainState = {
    AntiFling = { Enabled = false, BodyVelocity = nil },
    LockPosition = { Enabled = false, BodyPosition = nil, Position = nil },
    HidePets = false,
    HidePopups = false,
    RedactName = false,
    RedactStats = false,
    WalkWater = { Enabled = false, Floor = nil, Connection = nil },
    InfiniteJump = false,
    Fly = { Enabled = false, Gyro = nil, Velocity = nil, Level = 10 },
}
_G.Young0xMainState = MainState

-- ═══ ANTI FLING ═══
local function enableAntiFling()
    local root = Utils.getRoot()
    if not root then return end
    if MainState.AntiFling.BodyVelocity and MainState.AntiFling.BodyVelocity.Parent then
        MainState.AntiFling.BodyVelocity:Destroy()
    end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "Young0xAntiFling"
    bv.MaxForce = Vector3.new(100000, 0, 100000)
    bv.Velocity = Vector3.zero
    bv.P = 1250
    bv.Parent = root
    MainState.AntiFling.BodyVelocity = bv
end

local function disableAntiFling()
    if MainState.AntiFling.BodyVelocity then
        MainState.AntiFling.BodyVelocity:Destroy()
        MainState.AntiFling.BodyVelocity = nil
    end
end

-- ═══ LOCK POSITION ═══
local function enableLockPosition()
    local root = Utils.getRoot()
    if not root then return end
    MainState.LockPosition.Position = root.Position
    if MainState.LockPosition.BodyPosition and MainState.LockPosition.BodyPosition.Parent then
        MainState.LockPosition.BodyPosition:Destroy()
    end
    local bp = Instance.new("BodyPosition")
    bp.Name = "Young0xLockPosition"
    bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bp.Position = MainState.LockPosition.Position
    bp.P = 100000
    bp.Parent = root
    MainState.LockPosition.BodyPosition = bp
end

local function disableLockPosition()
    if MainState.LockPosition.BodyPosition then
        MainState.LockPosition.BodyPosition:Destroy()
        MainState.LockPosition.BodyPosition = nil
    end
    MainState.LockPosition.Position = nil
end

-- ═══ HIDE PETS ═══
local function applyHidePets(hide)
    local char = Utils.getCharacter()
    if not char then return end
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("petMovementScript", true) then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = hide and 1 or 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = hide and 1 or 0
                end
            end
        end
    end
end

-- ═══ WALK ON WATER ═══
local function enableWalkWater()
    if MainState.WalkWater.Floor then MainState.WalkWater.Floor:Destroy() end
    if MainState.WalkWater.Connection then MainState.WalkWater.Connection:Disconnect() end

    local floor = Instance.new("Part")
    floor.Name = "Young0xWaterFloor"
    floor.Size = Vector3.new(2048, 1, 2048)
    floor.Anchored = true
    floor.CanCollide = true
    floor.CanTouch = false
    floor.CanQuery = false
    floor.Transparency = 1
    floor.CastShadow = false
    floor.Position = Vector3.new(0, -9.5, 0)
    floor.Parent = workspace
    MainState.WalkWater.Floor = floor

    MainState.WalkWater.Connection = Services.RunService.Heartbeat:Connect(function()
        if not MainState.WalkWater.Enabled then return end
        local root = Utils.getRoot()
        if root and floor and floor.Parent then
            local x = math.floor(root.Position.X / 256 + 0.5) * 256
            local z = math.floor(root.Position.Z / 256 + 0.5) * 256
            floor.Position = Vector3.new(x, -9.5, z)
        end
    end)
end

local function disableWalkWater()
    if MainState.WalkWater.Connection then
        MainState.WalkWater.Connection:Disconnect()
        MainState.WalkWater.Connection = nil
    end
    if MainState.WalkWater.Floor then
        MainState.WalkWater.Floor:Destroy()
        MainState.WalkWater.Floor = nil
    end
end

-- ═══ FLY ═══
local function enableFly()
    local root = Utils.getRoot()
    if not root then return end
    if MainState.Fly.Gyro then MainState.Fly.Gyro:Destroy() end
    if MainState.Fly.Velocity then MainState.Fly.Velocity:Destroy() end

    local gyro = Instance.new("BodyGyro")
    gyro.Name = "Young0xFlyGyro"
    gyro.P = 9e4
    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.CFrame = root.CFrame
    gyro.Parent = root
    MainState.Fly.Gyro = gyro

    local bv = Instance.new("BodyVelocity")
    bv.Name = "Young0xFlyVelocity"
    bv.P = 1250
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = root
    MainState.Fly.Velocity = bv
end

local function disableFly()
    if MainState.Fly.Gyro then MainState.Fly.Gyro:Destroy(); MainState.Fly.Gyro = nil end
    if MainState.Fly.Velocity then MainState.Fly.Velocity:Destroy(); MainState.Fly.Velocity = nil end
    local humanoid = Utils.getHumanoid()
    if humanoid then humanoid.PlatformStand = false end
end

-- Loop Fly
task.spawn(function()
    while task.wait(0.1) do
        if MainState.Fly.Enabled then
            local root = Utils.getRoot()
            local humanoid = Utils.getHumanoid()
            local cam = workspace.CurrentCamera
            if root and humanoid and cam then
                if not MainState.Fly.Gyro or not MainState.Fly.Gyro.Parent then enableFly() end
                local speed = 160 + (math.clamp(MainState.Fly.Level, 1, 30) - 1) * 24
                local move = Vector3.zero
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
                if move.Magnitude < 0.05 and humanoid.MoveDirection.Magnitude > 0.05 then
                    move = humanoid.MoveDirection
                end
                if move.Magnitude > 0 then move = move.Unit end

                local vertical = 0
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = 1
                elseif Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical = -1 end

                humanoid.PlatformStand = true
                MainState.Fly.Gyro.CFrame = cam.CFrame
                MainState.Fly.Velocity.Velocity = move * speed + Vector3.new(0, vertical * speed, 0)
            end
        end
    end
end)

-- Loop Lock Position
task.spawn(function()
    while task.wait(0.2) do
        if MainState.LockPosition.Enabled and MainState.LockPosition.Position then
            local root = Utils.getRoot()
            if root then
                if not MainState.LockPosition.BodyPosition or not MainState.LockPosition.BodyPosition.Parent then
                    enableLockPosition()
                else
                    MainState.LockPosition.BodyPosition.Position = MainState.LockPosition.Position
                end
            end
        end
    end
end)

-- Loop Hide Pets
task.spawn(function()
    while task.wait(0.5) do
        if MainState.HidePets then applyHidePets(true) end
    end
end)

-- Re-aplicar al respawnear
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if MainState.AntiFling.Enabled then enableAntiFling() end
    if MainState.LockPosition.Enabled then enableLockPosition() end
    if MainState.HidePets then applyHidePets(true) end
end)

-- ═══ UI ═══
Tabs.Main:AddSection("User Settings", "⚙️")

Tabs.Main:AddSwitch("Anti Fling", function(state)
    MainState.AntiFling.Enabled = state
    if state then enableAntiFling(); Utils.notify("Anti Fling", "Activado", 2, "success")
    else disableAntiFling(); Utils.notify("Anti Fling", "Desactivado", 2, "info") end
end)

Tabs.Main:AddSwitch("Lock Position", function(state)
    MainState.LockPosition.Enabled = state
    if state then enableLockPosition(); Utils.notify("Lock Position", "Activado", 2, "success")
    else disableLockPosition(); Utils.notify("Lock Position", "Desactivado", 2, "info") end
end)

Tabs.Main:AddSwitch("Hide Pets", function(state)
    MainState.HidePets = state
    applyHidePets(state)
    Utils.notify("Hide Pets", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Main:AddSwitch("Hide Popups", function(state)
    MainState.HidePopups = state
    pcall(function()
        local gameGui = PlayerGui:FindFirstChild("gameGui")
        if gameGui then
            for _, obj in ipairs(gameGui:GetDescendants()) do
                if obj:IsA("GuiObject") and obj.Name:lower():find("popup") then
                    obj.Visible = not state
                end
            end
        end
    end)
    Utils.notify("Hide Popups", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Main:AddSwitch("Redact Name", function(state)
    MainState.RedactName = state
    Utils.notify("Redact Name", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Redact Stats", function(state)
    MainState.RedactStats = state
    Utils.notify("Redact Stats", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Walk on Water", function(state)
    MainState.WalkWater.Enabled = state
    if state then enableWalkWater(); Utils.notify("Walk on Water", "Activado", 2, "success")
    else disableWalkWater(); Utils.notify("Walk on Water", "Desactivado", 2, "info") end
end)

Tabs.Main:AddSwitch("Infinite Jump", function(state)
    MainState.InfiniteJump = state
    Utils.notify("Infinite Jump", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Services.UserInputService.JumpRequest:Connect(function()
    if MainState.InfiniteJump then
        local humanoid = Utils.getHumanoid()
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Tabs.Main:AddSwitch("Fly", function(state)
    MainState.Fly.Enabled = state
    if state then enableFly(); Utils.notify("Fly", "Activado (Space=subir, Ctrl=bajar)", 3, "success")
    else disableFly(); Utils.notify("Fly", "Desactivado", 2, "info") end
end)

Tabs.Main:AddSlider("Fly Speed", 1, 30, 10, function(value)
    MainState.Fly.Level = value
end)

Tabs.Main:AddSwitch("Anti AFK", function(state)
    _G.Young0xAntiAFK = state
    Utils.notify("Anti AFK", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end, true)

Tabs.Main:AddSection("Otros", "🌐")

Tabs.Main:AddDropdown("Cambiar Hora", {"Day", "Night"}, function(opt)
    Services.Lighting.ClockTime = (opt == "Night") and 0 or 14
    Utils.notify("Hora", "Cambiado a: " .. opt, 2, "success")
end, "Day")

Tabs.Main:AddSlider("FOV", 50, 120, 70, function(value)
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = value end
end)

Tabs.Main:AddButton("🔄 Reset Character", function()
    local humanoid = Utils.getHumanoid()
    if humanoid then humanoid.Health = 0 end
end)

-- ═══════════ [FIN PARTE 2] ═══════════
-- ═══════════════════════════════════════════════════════════════
-- [PARTE 3] TAB KILLING
-- ═══════════════════════════════════════════════════════════════

local KillState = {
    AutoKill = false,
    KarmaMode = nil, -- "evil" | "good" | nil
    TargetMode = false,
    Target = nil,
    Whitelist = {},
    KillList = {},
    KillAura = { Enabled = false, Range = 20, Ring = nil, Frozen = false, CenterCFrame = nil },
    Spectate = { Enabled = false, Target = nil, Connection = nil },
    SessionKills = 0,
    SessionStartKills = nil,
    LastTotalKills = nil,
    KillSessionActive = false,
}
_G.Young0xKillState = KillState

-- ═══ UTILS DE KILLING ═══
local function isWhitelisted(player)
    if not player then return true end
    if player == LocalPlayer then return true end
    for _, name in ipairs(KillState.Whitelist) do
        if name:lower() == player.Name:lower() then return true end
    end
    return false
end

local function isBlacklisted(player)
    if not player then return false end
    for _, name in ipairs(KillState.KillList) do
        if name:lower() == player.Name:lower() then return true end
    end
    return false
end

local function isPlayerAlive(player)
    if not player then return false end
    local char = player.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    return root ~= nil and hum ~= nil and hum.Health > 0
end

local function isSpawnProtected(player)
    if not player or not player.Character then return false end
    if player.Character:FindFirstChildOfClass("ForceField") then return true end
    if player.Character:FindFirstChild("spawnProtectionHighlight") then return true end
    local untilVal = player.Character:GetAttribute("SpawnProtectedUntil")
    if type(untilVal) == "number" and workspace:GetServerTimeNow() < untilVal then return true end
    return false
end

local function getPunchTool()
    local char = Utils.getCharacter()
    if not char then return nil end
    local t = char:FindFirstChild("Punch") or Backpack:FindFirstChild("Punch")
    return t
end

local function getMuscleEvent()
    return LocalPlayer:FindFirstChild("muscleEvent")
end

-- ═══ ATTACK FUNCTION ═══
local function attackPlayer(player, duration)
    if not player or player == LocalPlayer then return false end
    if isWhitelisted(player) then return false end
    if not isPlayerAlive(player) then return false end
    if isSpawnProtected(player) then return false end

    local startTime = os.clock()
    local duration = duration or 2
    local killed = false

    while os.clock() - startTime < duration do
        if not KillState.AutoKill and not KillState.TargetMode and not KillState.KarmaMode then break end
        if not isPlayerAlive(player) then killed = true; break end
        if isSpawnProtected(player) then break end

        local myRoot = Utils.getRoot()
        local myHum = Utils.getHumanoid()
        local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local targetHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not myRoot or not myHum or not targetRoot or not targetHum then break end

        -- Teletransporte cerca del target
        myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero

        -- Equipar Punch
        local punch = getPunchTool()
        if punch and punch.Parent ~= Utils.getCharacter() then
            pcall(function() myHum:EquipTool(punch) end)
        end

        -- Fire touch interest + muscleEvent
        pcall(function()
            local leftHand = Utils.getCharacter() and Utils.getCharacter():FindFirstChild("LeftHand")
            local rightHand = Utils.getCharacter() and Utils.getCharacter():FindFirstChild("RightHand")
            if firetouchinterest and leftHand then
                firetouchinterest(targetRoot, leftHand, 0)
                firetouchinterest(targetRoot, leftHand, 1)
            end
            if firetouchinterest and rightHand then
                firetouchinterest(targetRoot, rightHand, 0)
                firetouchinterest(targetRoot, rightHand, 1)
            end
        end)

        local event = getMuscleEvent()
        if event then
            pcall(function()
                event:FireServer("punch", "leftHand")
                event:FireServer("punch", "rightHand")
            end)
        end

        Services.RunService.Heartbeat:Wait()
    end

    return killed
end

-- ═══ AUTO KILL WORKER ═══
task.spawn(function()
    while task.wait(0.1) do
        if KillState.AutoKill or KillState.TargetMode or KillState.KarmaMode then
            local targets = {}
            for _, player in ipairs(Services.Players:GetPlayers()) do
                if player ~= LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) and not isSpawnProtected(player) then
                    if KillState.TargetMode then
                        if player.Name == KillState.Target then
                            table.insert(targets, player)
                        end
                    elseif KillState.KarmaMode then
                        local good = player:FindFirstChild("goodKarma")
                        local evil = player:FindFirstChild("evilKarma")
                        if good and evil then
                            local gv, ev = good.Value or 0, evil.Value or 0
                            if gv + ev >= 5 then
                                if KillState.KarmaMode == "evil" and gv > ev then
                                    table.insert(targets, player)
                                elseif KillState.KarmaMode == "good" and ev > gv then
                                    table.insert(targets, player)
                                end
                            end
                        end
                    else
                        table.insert(targets, player)
                    end
                end
            end
            for _, t in ipairs(targets) do
                if not KillState.AutoKill and not KillState.TargetMode and not KillState.KarmaMode then break end
                attackPlayer(t, 1.5)
            end
        end
    end
end)

-- ═══ KILL AURA ═══
local function createKillAuraRing()
    if KillState.KillAura.Ring then KillState.KillAura.Ring:Destroy() end
    local ring = Instance.new("Part")
    ring.Name = "Young0xKillAuraRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = Color3.fromRGB(155, 70, 255)
    ring.Transparency = 0.6
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.CastShadow = false
    ring.Size = Vector3.new(0.2, KillState.KillAura.Range * 2, KillState.KillAura.Range * 2)
    ring.Parent = workspace
    KillState.KillAura.Ring = ring
end

task.spawn(function()
    while task.wait(0.1) do
        if KillState.KillAura.Enabled then
            local root = Utils.getRoot()
            if root then
                KillState.KillAura.CenterCFrame = root.CFrame
                if not KillState.KillAura.Ring or not KillState.KillAura.Ring.Parent then
                    createKillAuraRing()
                end
                KillState.KillAura.Ring.CFrame = root.CFrame * CFrame.Angles(0, 0, math.rad(90))
                for _, player in ipairs(Services.Players:GetPlayers()) do
                    if player ~= LocalPlayer and not isWhitelisted(player) and isPlayerAlive(player) and not isSpawnProtected(player) then
                        local tRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if tRoot and (root.Position - tRoot.Position).Magnitude <= KillState.KillAura.Range then
                            attackPlayer(player, 0.5)
                        end
                    end
                end
            end
        end
    end
end)

-- ═══ SPECTATE ═══
local function startSpectate(playerName)
    if KillState.Spectate.Connection then
        KillState.Spectate.Connection:Disconnect()
        KillState.Spectate.Connection = nil
    end
    local target = Services.Players:FindFirstChild(playerName)
    if not target then
        local cam = workspace.CurrentCamera
        local hum = Utils.getHumanoid()
        if cam and hum then cam.CameraSubject = hum end
        return
    end
    KillState.Spectate.Target = target
    local cam = workspace.CurrentCamera
    if not cam then return end
    local function update()
        local char = target.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
    update()
    KillState.Spectate.Connection = target.CharacterAdded:Connect(function()
        task.wait(0.3)
        update()
    end)
end

local function stopSpectate()
    if KillState.Spectate.Connection then
        KillState.Spectate.Connection:Disconnect()
        KillState.Spectate.Connection = nil
    end
    KillState.Spectate.Target = nil
    local cam = workspace.CurrentCamera
    local hum = Utils.getHumanoid()
    if cam and hum then cam.CameraSubject = hum end
end

-- ═══ REFRESCAR DROPDOWNS ═══
local function refreshPlayerDropdowns()
    local list = {}
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    table.sort(list)
    return list
end

-- ═══ UI ═══
Tabs.Killing:AddSection("Auto Kill", "⚔️")

Tabs.Killing:AddSwitch("Auto Kill", function(state)
    KillState.AutoKill = state
    if state then
        KillState.TargetMode = false
        KillState.KarmaMode = nil
        if KillState.SessionStartKills == nil then
            local kills = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Kills")
            KillState.SessionStartKills = kills and kills.Value or 0
            KillState.KillSessionActive = true
        end
        Utils.notify("Auto Kill", "Activado", 2, "success")
    else
        Utils.notify("Auto Kill", "Desactivado", 2, "info")
    end
end)

Tabs.Killing:AddSwitch("Farm Evil Karma", function(state)
    KillState.KarmaMode = state and "evil" or nil
    if state then KillState.AutoKill = false; KillState.TargetMode = false end
    Utils.notify("Farm Evil Karma", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Killing:AddSwitch("Farm Good Karma", function(state)
    KillState.KarmaMode = state and "good" or nil
    if state then KillState.AutoKill = false; KillState.TargetMode = false end
    Utils.notify("Farm Good Karma", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

local targetDropdown
targetDropdown = Tabs.Killing:AddDropdown("Kill Target", refreshPlayerDropdowns(), function(name)
    KillState.Target = name
    KillState.TargetMode = true
    KillState.AutoKill = false
    KillState.KarmaMode = nil
    Utils.notify("Target", "Apuntando a: " .. tostring(name), 2, "success")
end)

task.spawn(function()
    Services.Players.PlayerAdded:Connect(function()
        if targetDropdown and targetDropdown.SetOptions then
            targetDropdown:SetOptions(refreshPlayerDropdowns())
        end
    end)
    Services.Players.PlayerRemoving:Connect(function()
        if targetDropdown and targetDropdown.SetOptions then
            targetDropdown:SetOptions(refreshPlayerDropdowns())
        end
    end)
end)

Tabs.Killing:AddSwitch("Target Kill", function(state)
    KillState.TargetMode = state
    if state then KillState.AutoKill = false; KillState.KarmaMode = nil end
    Utils.notify("Target Kill", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

-- ═══ WHITELIST ═══
Tabs.Killing:AddSection("Whitelist", "🛡️")

local wlDropdown
wlDropdown = Tabs.Killing:AddDropdown("Add to Whitelist", refreshPlayerDropdowns(), function(name)
    for _, n in ipairs(KillState.Whitelist) do
        if n:lower() == name:lower() then return end
    end
    table.insert(KillState.Whitelist, name)
    Utils.notify("Whitelist", "Añadido: " .. name, 2, "success")
end)

local rwlDropdown
rwlDropdown = Tabs.Killing:AddDropdown("Remove from Whitelist", {}, function(name)
    for i = #KillState.Whitelist, 1, -1 do
        if KillState.Whitelist[i]:lower() == name:lower() then
            table.remove(KillState.Whitelist, i)
            Utils.notify("Whitelist", "Removido: " .. name, 2, "info")
            break
        end
    end
end)

Tabs.Killing:AddButton("Clear Whitelist", function()
    KillState.Whitelist = {}
    Utils.notify("Whitelist", "Lista limpiada", 2, "info")
end)

-- ═══ KILL LIST ═══
Tabs.Killing:AddSection("Kill List", "🎯")

local klDropdown
klDropdown = Tabs.Killing:AddDropdown("Add to Kill List", refreshPlayerDropdowns(), function(name)
    for _, n in ipairs(KillState.KillList) do
        if n:lower() == name:lower() then return end
    end
    table.insert(KillState.KillList, name)
    Utils.notify("Kill List", "Añadido: " .. name, 2, "success")
end)

Tabs.Killing:AddButton("Clear Kill List", function()
    KillState.KillList = {}
    Utils.notify("Kill List", "Lista limpiada", 2, "info")
end)

-- ═══ KILL AURA ═══
Tabs.Killing:AddSection("Kill Aura", "💀")

Tabs.Killing:AddSwitch("Kill Aura", function(state)
    KillState.KillAura.Enabled = state
    if state then
        createKillAuraRing()
        Utils.notify("Kill Aura", "Activado", 2, "success")
    else
        if KillState.KillAura.Ring then
            KillState.KillAura.Ring:Destroy()
            KillState.KillAura.Ring = nil
        end
        Utils.notify("Kill Aura", "Desactivado", 2, "info")
    end
end)

Tabs.Killing:AddSlider("Kill Aura Range", 1, 140, 20, function(value)
    KillState.KillAura.Range = value
    if KillState.KillAura.Ring then
        KillState.KillAura.Ring.Size = Vector3.new(0.2, value * 2, value * 2)
    end
end)

-- ═══ SPECTATE ═══
Tabs.Killing:AddSection("Spectate", "👁️")

local specDropdown
specDropdown = Tabs.Killing:AddDropdown("Spectate Player", refreshPlayerDropdowns(), function(name)
    startSpectate(name)
    Utils.notify("Spectate", "Mirando a: " .. name, 2, "success")
end)

Tabs.Killing:AddSwitch("Spectate", function(state)
    KillState.Spectate.Enabled = state
    if not state then stopSpectate() end
end)

-- ═══ STATS ═══
Tabs.Killing:AddSection("Stats", "📊")
local killStatsLabel
killStatsLabel = Tabs.Killing:AddLabel("Kills: 0 | Sesión: 0")

task.spawn(function()
    while task.wait(0.5) do
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        local kills = ls and ls:FindFirstChild("Kills")
        local total = kills and kills.Value or 0
        if KillState.SessionStartKills then
            KillState.SessionKills = total - KillState.SessionStartKills
        end
        if killStatsLabel and killStatsLabel.Parent then
            killStatsLabel.Text = string.format("Kills: %s | Sesión: %s",
                Utils.formatNumber(total),
                Utils.formatNumber(KillState.SessionKills or 0))
        end
    end
end)

-- ═══════════ [FIN PARTE 3] ═══════════
-- ═══════════════════════════════════════════════════════════════
-- [PARTE 4] TAB FARMING + TAB FAST
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- TAB FARMING
-- ═══════════════════════════════════════════════════════════════

local FarmingState = {
    AutoRebirth = { Enabled = false, Target = 0 },
    AutoSize1 = false,
    AutoKing = false,
    Exercise = { Enabled = false, Tool = nil, AutoRep = false },
    Machines = { SquatEnabled = false, LiftEnabled = false, SquatTarget = nil, LiftTarget = nil },
    Rock = { Enabled = false, Target = nil, TargetDurability = 0 },
}
_G.Young0xFarmingState = FarmingState

-- ═══ AUTO REBIRTH ═══
task.spawn(function()
    while task.wait(0.15) do
        if FarmingState.AutoRebirth.Enabled then
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local r = ls and ls:FindFirstChild("Rebirths")
            if r then
                if FarmingState.AutoRebirth.Target > 0 and r.Value >= FarmingState.AutoRebirth.Target then
                    FarmingState.AutoRebirth.Enabled = false
                    Utils.notify("Auto Rebirth", "Target alcanzado", 3, "success")
                else
                    local remote = Services.ReplicatedStorage:FindFirstChild("rEvents")
                    remote = remote and remote:FindFirstChild("rebirthRemote")
                    if remote then
                        pcall(function() remote:InvokeServer("rebirthRequest") end)
                    end
                end
            end
        end
    end
end)

-- ═══ AUTO SIZE 1 ═══
task.spawn(function()
    while task.wait(0.3) do
        if FarmingState.AutoSize1 then
            local remote = Services.ReplicatedStorage:FindFirstChild("rEvents")
            remote = remote and remote:FindFirstChild("changeSpeedSizeRemote")
            if remote then
                pcall(function() remote:InvokeServer("changeSize", 1) end)
            end
        end
    end
end)

-- ═══ AUTO KING ═══
local KING_POSITION = CFrame.new(-8665.4, 17.21, -5792.9)
task.spawn(function()
    while task.wait(0.15) do
        if FarmingState.AutoKing then
            local root = Utils.getRoot()
            if root then
                root.CFrame = KING_POSITION
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
end)

-- ═══ AUTO EXERCISE ═══
task.spawn(function()
    while task.wait(0.1) do
        if FarmingState.Exercise.Enabled then
            local char = Utils.getCharacter()
            local hum = Utils.getHumanoid()
            if char and hum and FarmingState.Exercise.Tool then
                local tool = char:FindFirstChild(FarmingState.Exercise.Tool) or Backpack:FindFirstChild(FarmingState.Exercise.Tool)
                if tool and tool.Parent ~= char then
                    pcall(function() hum:EquipTool(tool) end)
                end
                local muscle = LocalPlayer:FindFirstChild("muscleEvent")
                if muscle then
                    pcall(function() muscle:FireServer("rep") end)
                end
            end
        end
    end
end)

-- ═══ AUTO REP (independiente) ═══
task.spawn(function()
    while task.wait(0.1) do
        if FarmingState.Exercise.AutoRep then
            local muscle = LocalPlayer:FindFirstChild("muscleEvent")
            if muscle then
                pcall(function() muscle:FireServer("rep") end)
            end
        end
    end
end)

-- ═══ AUTO MACHINES (Squat / Lift) ═══
local function findMachineByName(name)
    local folder = workspace:FindFirstChild("machinesFolder")
    if not folder then return nil end
    for _, m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and m.Name:lower():find(name:lower(), 1, true) then
            return m
        end
    end
    return nil
end

local function enterMachine(machine)
    if not machine then return false end
    local char = Utils.getCharacter()
    local hum = Utils.getHumanoid()
    if not char or not hum then return false end
    local interact = nil
    for _, d in ipairs(machine:GetDescendants()) do
        if d:IsA("BasePart") and d.Name:lower() == "interactseat" then
            interact = d
            break
        end
    end
    if not interact then
        for _, d in ipairs(machine:GetDescendants()) do
            if d:IsA("Seat") then
                interact = d
                break
            end
        end
    end
    if not interact then return false end
    local root = Utils.getRoot()
    if not root then return false end
    root.CFrame = interact.CFrame * CFrame.new(0, 3, 0)
    root.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.3)
    if hum.Sit == false then
        pcall(function()
            hum.Sit = true
            hum:ChangeState(Enum.HumanoidStateType.Seated)
        end)
    end
    return true
end

task.spawn(function()
    while task.wait(0.5) do
        if FarmingState.Machines.SquatEnabled and FarmingState.Machines.SquatTarget then
            local machine = findMachineByName(FarmingState.Machines.SquatTarget)
            if machine then enterMachine(machine) end
        end
        if FarmingState.Machines.LiftEnabled and FarmingState.Machines.LiftTarget then
            local machine = findMachineByName(FarmingState.Machines.LiftTarget)
            if machine then enterMachine(machine) end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if (FarmingState.Machines.SquatEnabled or FarmingState.Machines.LiftEnabled) then
            local muscle = LocalPlayer:FindFirstChild("muscleEvent")
            if muscle then
                pcall(function() muscle:FireServer("rep") end)
            end
        end
    end
end)

-- ═══ AUTO ROCK ═══
local ROCKS_LIST = {
    { name = "Industrial Rock", durability = 25000000 },
    { name = "Ancient Rock", durability = 10000000 },
    { name = "Muscle King Rock", durability = 5000000 },
    { name = "Legend Rock", durability = 1000000 },
    { name = "Eternal Rock", durability = 750000 },
    { name = "Mythical Rock", durability = 400000 },
    { name = "Frost Rock", durability = 150000 },
    { name = "Beach Rock", durability = 5000 },
    { name = "Starter Rock", durability = 100 },
    { name = "Tiny Rock", durability = 0 },
}

task.spawn(function()
    while task.wait(0.15) do
        if FarmingState.Rock.Enabled and FarmingState.Rock.TargetDurability > 0 then
            local char = Utils.getCharacter()
            if not char then
                task.wait(0.5)
                continue
            end
            local dur = LocalPlayer:FindFirstChild("Durability")
            if not dur or dur.Value < FarmingState.Rock.TargetDurability then
                continue
            end
            local folder = workspace:FindFirstChild("machinesFolder")
            if folder then
                for _, m in ipairs(folder:GetDescendants()) do
                    if m.Name == "neededDurability" and m.Value == FarmingState.Rock.TargetDurability then
                        local rock = m.Parent and m.Parent:FindFirstChild("Rock")
                        local left = char:FindFirstChild("LeftHand")
                        local right = char:FindFirstChild("RightHand")
                        if rock and left and right and firetouchinterest then
                            pcall(function()
                                firetouchinterest(rock, left, 0)
                                firetouchinterest(rock, left, 1)
                                firetouchinterest(rock, right, 0)
                                firetouchinterest(rock, right, 1)
                            end)
                        end
                        local muscle = LocalPlayer:FindFirstChild("muscleEvent")
                        if muscle then
                            pcall(function()
                                muscle:FireServer("punch", "leftHand")
                                muscle:FireServer("punch", "rightHand")
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- ═══ UI FARMING ═══
Tabs.Farming:AddSection("Auto Rebirth", "🔄")
Tabs.Farming:AddTextBox("Target Rebirths (0 = infinito)", function(text)
    local n = tonumber(text)
    if n and n >= 0 then FarmingState.AutoRebirth.Target = math.floor(n) end
end)
Tabs.Farming:AddSwitch("Auto Rebirth", function(state)
    FarmingState.AutoRebirth.Enabled = state
    Utils.notify("Auto Rebirth", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)
Tabs.Farming:AddSwitch("Auto Size 1", function(state)
    FarmingState.AutoSize1 = state
end)
Tabs.Farming:AddSwitch("Auto King", function(state)
    FarmingState.AutoKing = state
    Utils.notify("Auto King", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Farming:AddSection("Auto Exercises", "💪")
Tabs.Farming:AddDropdown("Exercise Tool", {"Weight", "Pushups", "Situps", "Handstands"}, function(opt)
    FarmingState.Exercise.Tool = opt
end, "Weight")
Tabs.Farming:AddSwitch("Start Exercising", function(state)
    FarmingState.Exercise.Enabled = state
    Utils.notify("Exercise", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)
Tabs.Farming:AddSwitch("Auto Rep", function(state)
    FarmingState.Exercise.AutoRep = state
end)

Tabs.Farming:AddSection("Auto Machines", "🏋️")
Tabs.Farming:AddTextBox("Squat machine name", function(text)
    FarmingState.Machines.SquatTarget = text
end)
Tabs.Farming:AddSwitch("Auto Squat", function(state)
    FarmingState.Machines.SquatEnabled = state
    Utils.notify("Auto Squat", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)
Tabs.Farming:AddTextBox("Lift machine name", function(text)
    FarmingState.Machines.LiftTarget = text
end)
Tabs.Farming:AddSwitch("Auto Lift", function(state)
    FarmingState.Machines.LiftEnabled = state
    Utils.notify("Auto Lift", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Farming:AddSection("Auto Rock", "🪨")
local rockNames = {}
for _, r in ipairs(ROCKS_LIST) do table.insert(rockNames, r.name) end
Tabs.Farming:AddDropdown("Select Rock", rockNames, function(name)
    FarmingState.Rock.Target = name
    for _, r in ipairs(ROCKS_LIST) do
        if r.name == name then
            FarmingState.Rock.TargetDurability = r.durability
            break
        end
    end
end)
Tabs.Farming:AddSwitch("Auto Rock", function(state)
    FarmingState.Rock.Enabled = state
    Utils.notify("Auto Rock", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB FAST (Fast Rep + Fast Rebirth)
-- ═══════════════════════════════════════════════════════════════

local FastState = {
    FastRep = { Enabled = false, RepsPerCycle = 4, CyclesPerSecond = 20, PingControl = true, CurrentPing = 0 },
    FastRebirth = {
        Enabled = false,
        TargetRebirths = 0,
        RepPets = {"Swift Samurai"},
        RebirthPets = {"Tribal Overlord"},
        Running = false,
        WorkerActive = false,
    },
    UltraTitans = {
        Enabled = false,
        TargetRebirths = 0,
        RepPets = {"Omega Overlord"},
        RebirthPets = {"Titanium Hydra"},
    },
    ChaosOverlords = {
        Enabled = false,
        TargetRebirths = 0,
        RepPets = {"Swift Samurai"},
        RebirthPets = {"Tribal Overlord"},
    },
}
_G.Young0xFastState = FastState

-- ═══ FAST REP WORKER ═══
task.spawn(function()
    while task.wait(0.05) do
        if FastState.FastRep.Enabled then
            local muscle = LocalPlayer:FindFirstChild("muscleEvent")
            if muscle then
                local reps = FastState.FastRep.RepsPerCycle
                if FastState.FastRep.PingControl then
                    local ping = FastState.FastRep.CurrentPing
                    if ping < 100 then reps = 4
                    elseif ping < 180 then reps = 3
                    elseif ping < 280 then reps = 2
                    else reps = 1 end
                end
                for i = 1, reps do
                    pcall(function() muscle:FireServer("rep") end)
                end
            end
        end
    end
end)

-- Ping sampler
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            FastState.FastRep.CurrentPing = math.floor(
                Services.Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5
            )
        end)
    end
end)

-- ═══ FAST REBIRTH — Helper para equipar pets ═══
local function unequipAllPets()
    local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
    local equipEvent = Services.ReplicatedStorage:FindFirstChild("rEvents")
    equipEvent = equipEvent and equipEvent:FindFirstChild("equipPetEvent")
    if not petsFolder or not equipEvent then return end
    for _, folder in ipairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in ipairs(folder:GetChildren()) do
                pcall(function() equipEvent:FireServer("unequipPet", pet) end)
            end
        end
    end
    task.wait(0.3)
end

local function equipPetsByName(names)
    unequipAllPets()
    local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
    local uniqueFolder = petsFolder and petsFolder:FindFirstChild("Unique")
    local equipEvent = Services.ReplicatedStorage:FindFirstChild("rEvents")
    equipEvent = equipEvent and equipEvent:FindFirstChild("equipPetEvent")
    if not uniqueFolder or not equipEvent then return 0 end
    local equipped = 0
    for _, name in ipairs(names) do
        for _, pet in ipairs(uniqueFolder:GetChildren()) do
            if pet.Name == name then
                pcall(function() equipEvent:FireServer("equipPet", pet) end)
                equipped = equipped + 1
                task.wait(0.05)
            end
        end
    end
    task.wait(0.3)
    return equipped
end

-- ═══ FAST REBIRTH WORKER (genérico) ═══
local function fastRebirthWorker(config, runFlag)
    task.spawn(function()
        while runFlag() do
            local ls = LocalPlayer:FindFirstChild("leaderstats")
            local rStat = ls and ls:FindFirstChild("Rebirths")
            local sStat = ls and ls:FindFirstChild("Strength")
            if not rStat or not sStat then
                task.wait(0.5)
                continue
            end

            if config.TargetRebirths > 0 and rStat.Value >= config.TargetRebirths then
                Utils.notify("Fast Rebirth", "Target alcanzado", 3, "success")
                break
            end

            -- Equipar pets de rep
            equipPetsByName(config.RepPets)

            -- Farmear strength
            local targetStrength = 5000 + rStat.Value * 2550
            local muscle = LocalPlayer:FindFirstChild("muscleEvent")
            while runFlag() and sStat.Value < targetStrength do
                if muscle then
                    pcall(function()
                        for i = 1, 8 do muscle:FireServer("rep") end
                    end)
                end
                task.wait(0.05)
            end

            if not runFlag() then break end

            -- Equipar pets de rebirth
            equipPetsByName(config.RebirthPets)

            -- Rebirth
            local remote = Services.ReplicatedStorage:FindFirstChild("rEvents")
            remote = remote and remote:FindFirstChild("rebirthRemote")
            if remote then
                local before = rStat.Value
                local tries = 0
                repeat
                    pcall(function() remote:InvokeServer("rebirthRequest") end)
                    task.wait(0.08)
                    tries = tries + 1
                until not runFlag() or rStat.Value > before or tries >= 50
            end
            task.wait(0.5)
        end
    end)
end

-- ═══ UI FAST ═══
Tabs.Fast:AddSection("Fast Rep", "⚡")

Tabs.Fast:AddSwitch("Fast Rep", function(state)
    FastState.FastRep.Enabled = state
    Utils.notify("Fast Rep", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Fast:AddSwitch("Ping Control", function(state)
    FastState.FastRep.PingControl = state
end, true)

Tabs.Fast:AddTextBox("Reps per cycle (1-4)", function(text)
    local n = tonumber(text)
    if n then FastState.FastRep.RepsPerCycle = math.clamp(math.floor(n), 1, 4) end
end)

local pingLabel = Tabs.Fast:AddLabel("Ping actual: --")
task.spawn(function()
    while task.wait(1) do
        if pingLabel and pingLabel.Parent then
            pingLabel.Text = "Ping actual: " .. tostring(FastState.FastRep.CurrentPing) .. " ms"
        end
    end
end)

Tabs.Fast:AddSection("Fast Rebirth — Estándar", "🔄")

Tabs.Fast:AddTextBox("Target rebirths (0 = infinito)", function(text)
    local n = tonumber(text)
    if n and n >= 0 then FastState.FastRebirth.TargetRebirths = math.floor(n) end
end)

local fastRebirthToggle
fastRebirthToggle = Tabs.Fast:AddSwitch("Fast Rebirth", function(state)
    FastState.FastRebirth.Enabled = state
    if state then
        fastRebirthWorker(FastState.FastRebirth, function()
            return FastState.FastRebirth.Enabled
        end)
        Utils.notify("Fast Rebirth", "Activado", 2, "success")
    else
        Utils.notify("Fast Rebirth", "Desactivado", 2, "info")
    end
end)

Tabs.Fast:AddSection("Fast Rebirth — Ultra Titans", "💎")

Tabs.Fast:AddTextBox("Target rebirths (0 = infinito)", function(text)
    local n = tonumber(text)
    if n and n >= 0 then FastState.UltraTitans.TargetRebirths = math.floor(n) end
end)

Tabs.Fast:AddSwitch("Fast Rebirth Ultra Titans", function(state)
    FastState.UltraTitans.Enabled = state
    if state then
        fastRebirthWorker(FastState.UltraTitans, function()
            return FastState.UltraTitans.Enabled
        end)
        Utils.notify("Ultra Titans", "Activado", 2, "success")
    else
        Utils.notify("Ultra Titans", "Desactivado", 2, "info")
    end
end)

Tabs.Fast:AddSection("Fast Rebirth — Chaos Overlords", "🔥")

Tabs.Fast:AddTextBox("Target rebirths (0 = infinito)", function(text)
    local n = tonumber(text)
    if n and n >= 0 then FastState.ChaosOverlords.TargetRebirths = math.floor(n) end
end)

Tabs.Fast:AddSwitch("Fast Rebirth Chaos Overlords", function(state)
    FastState.ChaosOverlords.Enabled = state
    if state then
        fastRebirthWorker(FastState.ChaosOverlords, function()
            return FastState.ChaosOverlords.Enabled
        end)
        Utils.notify("Chaos Overlords", "Activado", 2, "success")
    else
        Utils.notify("Chaos Overlords", "Desactivado", 2, "info")
    end
end)

-- ═══════════ [FIN PARTE 4] ═══════════
-- ═══════════════════════════════════════════════════════════════
-- [PARTE 5] TAB BOSS + TAB PETS
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- TAB BOSS
-- ═══════════════════════════════════════════════════════════════

local BossState = {
    MainEnabled = false,
    HalloweenEnabled = false,
    ContinueTraining = false,
    TargetSpecial = nil,
    Status = "Idle",
}
_G.Young0xBossState = BossState

local SPECIAL_BOSSES = {
    "Grim Reaper",
    "Frankenbrute",
    "Pumpkin Titan",
    "Scarecrow Colossus",
}

-- Busca un boss por nombre en el Workspace
local function findBossByName(name)
    for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Model") and d.Name == name then
            local hitbox = d:FindFirstChild("BossDamageHitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                local stats = d:FindFirstChild("stats") or d:FindFirstChild("Stats")
                local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
                if health and tonumber(health.Value) and tonumber(health.Value) > 0 then
                    return d, hitbox, health
                end
                local hum = d:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    return d, hitbox, hum
                end
            end
        end
    end
    return nil
end

-- Busca boss por tags (BossEventBoss)
local function findTaggedBoss()
    local tagged = Services.CollectionService:GetTagged("BossEventBoss")
    for _, boss in ipairs(tagged) do
        if boss:IsA("Model") and boss:IsDescendantOf(workspace) then
            local hitbox = boss:FindFirstChild("BossDamageHitbox", true)
            if hitbox and hitbox:IsA("BasePart") then
                local hum = boss:FindFirstChildOfClass("Humanoid")
                local stats = boss:FindFirstChild("stats") or boss:FindFirstChild("Stats")
                local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
                local hv = health and tonumber(health.Value)
                if (hv and hv > 0) or (hum and hum.Health > 0) then
                    return boss, hitbox, hum or health
                end
            end
        end
    end
    return nil
end

-- Ataca al boss
local function attackBoss(bossModel, hitbox)
    if not bossModel or not hitbox or not hitbox.Parent then return false end
    local char = Utils.getCharacter()
    local hum = Utils.getHumanoid()
    local root = Utils.getRoot()
    if not char or not hum or not root then return false end

    -- Equipar Punch
    local punch = char:FindFirstChild("Punch") or Backpack:FindFirstChild("Punch")
    if punch and punch.Parent ~= char then
        pcall(function() hum:EquipTool(punch) end)
    end

    -- Posicionarse cerca del hitbox
    local center = hitbox.Position
    local offset = (root.Position - center)
    offset = Vector3.new(offset.X, 0, offset.Z)
    if offset.Magnitude < 1 then offset = hitbox.CFrame.LookVector end
    local standPos = center + offset.Unit * math.max(4, math.min(6, hitbox.Size.Magnitude * 0.2)) + Vector3.new(0, 1.5, 0)
    root.CFrame = CFrame.lookAt(standPos, center)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    -- Punch + fire touch
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

    local muscle = LocalPlayer:FindFirstChild("muscleEvent")
    if muscle then
        pcall(function()
            muscle:FireServer("punch", "leftHand")
            muscle:FireServer("punch", "rightHand")
        end)
    end

    return true
end

-- Worker Main Boss
task.spawn(function()
    while task.wait(0.15) do
        if BossState.MainEnabled then
            local boss, hitbox, healthRef = findTaggedBoss()
            if not boss then
                -- Buscar en Events/BossEvent
                local events = workspace:FindFirstChild("Events")
                local folder = events and (events:FindFirstChild("BossEvent") or events:FindFirstChild("BossArena"))
                if folder then
                    for _, d in ipairs(folder:GetDescendants()) do
                        if d:IsA("Model") then
                            local hb = d:FindFirstChild("BossDamageHitbox", true)
                            if hb and hb:IsA("BasePart") then
                                boss, hitbox = d, hb
                                break
                            end
                        end
                    end
                end
            end
            if boss and hitbox then
                BossState.Status = "Atacando: " .. boss.Name
                attackBoss(boss, hitbox)
            else
                BossState.Status = "Esperando boss..."
            end
        end
    end
end)

-- Worker Halloween Boss
task.spawn(function()
    while task.wait(0.3) do
        if BossState.HalloweenEnabled and BossState.TargetSpecial then
            local boss, hitbox = findBossByName(BossState.TargetSpecial)
            if boss and hitbox then
                BossState.Status = "Atacando: " .. BossState.TargetSpecial
                attackBoss(boss, hitbox)
            else
                BossState.Status = "Esperando: " .. BossState.TargetSpecial
            end
        end
    end
end)

-- ═══ UI BOSS ═══
Tabs.Boss:AddSection("Auto Boss — Main Island", "👹")

local bossStatusLabel = Tabs.Boss:AddLabel("Status: Idle")

Tabs.Boss:AddSwitch("Auto Boss Main Island", function(state)
    BossState.MainEnabled = state
    if state then
        BossState.HalloweenEnabled = false
        Utils.notify("Auto Boss", "Main Island Activado", 2, "success")
    else
        Utils.notify("Auto Boss", "Main Island Desactivado", 2, "info")
    end
end)

Tabs.Boss:AddSwitch("Continue Training after Boss", function(state)
    BossState.ContinueTraining = state
end)

Tabs.Boss:AddSection("Auto Boss — Halloween", "🎃")

Tabs.Boss:AddDropdown("World Boss Target", SPECIAL_BOSSES, function(name)
    BossState.TargetSpecial = name
end, "Grim Reaper")

Tabs.Boss:AddSwitch("Auto Boss Halloween", function(state)
    BossState.HalloweenEnabled = state
    if state then
        BossState.MainEnabled = false
        Utils.notify("Auto Boss Halloween", "Activado: " .. tostring(BossState.TargetSpecial), 2, "success")
    else
        Utils.notify("Auto Boss Halloween", "Desactivado", 2, "info")
    end
end)

Tabs.Boss:AddSection("Info", "📊")
task.spawn(function()
    while task.wait(0.5) do
        if bossStatusLabel and bossStatusLabel.Parent then
            bossStatusLabel.Text = "Status: " .. BossState.Status
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB PETS (Pet Shop + Evolve + Trade)
-- ═══════════════════════════════════════════════════════════════

local PetsState = {
    AutoBuyPet = false,
    AutoBuyAura = false,
    SelectedPets = {},
    SelectedAuras = {},
    AutoEvolve = { Enabled = false, Selected = {}, Amount = 1 },
    AutoTrade = { Enabled = false, SelectedPlayers = {}, SelectedPets = {} },
}
_G.Young0xPetsState = PetsState

-- Helper: obtener pet shop folder
local function getPetShopFolder()
    local shared = Services.ReplicatedStorage:FindFirstChild("shared")
    local runtime = shared and shared:FindFirstChild("runtime")
    return runtime and runtime:FindFirstChild("cPetShopFolder")
end

local function getPetShopRemote()
    local rEvents = Services.ReplicatedStorage:FindFirstChild("rEvents")
    return rEvents and rEvents:FindFirstChild("cPetShopRemote")
end

local function getEquipRemote()
    local rEvents = Services.ReplicatedStorage:FindFirstChild("rEvents")
    return rEvents and rEvents:FindFirstChild("equipPetEvent")
end

local function getEvolveRemote()
    local rEvents = Services.ReplicatedStorage:FindFirstChild("rEvents")
    return rEvents and rEvents:FindFirstChild("petEvolveEvent")
end

local function getTradeRemote()
    local rEvents = Services.ReplicatedStorage:FindFirstChild("rEvents")
    return rEvents and (rEvents:FindFirstChild("tradingEvent") or rEvents:FindFirstChild("tradeRemote"))
end

-- Listar pets/auras del shop
local function getPetShopLists()
    local folder = getPetShopFolder()
    if not folder then return {}, {} end
    local pets, auras = {}, {}
    for _, item in ipairs(folder:GetChildren()) do
        if item:GetAttribute("IsPowerUp") == true then
            table.insert(auras, item.Name)
        else
            table.insert(pets, item.Name)
        end
    end
    table.sort(pets)
    table.sort(auras)
    return pets, auras
end

-- Comprar pet/aura
local function buyFromShop(name)
    local folder = getPetShopFolder()
    local remote = getPetShopRemote()
    if not folder or not remote then return false end
    local item = folder:FindFirstChild(name)
    if not item then return false end
    pcall(function() remote:InvokeServer(item) end)
    return true
end

-- Workers Auto Buy
task.spawn(function()
    while task.wait(0.5) do
        if PetsState.AutoBuyPet then
            for _, name in ipairs(PetsState.SelectedPets) do
                buyFromShop(name)
                task.wait(0.1)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if PetsState.AutoBuyAura then
            for _, name in ipairs(PetsState.SelectedAuras) do
                buyFromShop(name)
                task.wait(0.1)
            end
        end
    end
end)

-- Auto Evolve worker
task.spawn(function()
    while task.wait(0.5) do
        if PetsState.AutoEvolve.Enabled then
            local remote = getEvolveRemote()
            if remote then
                for _, name in ipairs(PetsState.AutoEvolve.Selected) do
                    for _ = 1, PetsState.AutoEvolve.Amount do
                        pcall(function() remote:FireServer("evolvePet", name) end)
                    end
                end
            end
        end
    end
end)

-- Auto Trade worker
task.spawn(function()
    while task.wait(0.5) do
        if PetsState.AutoTrade.Enabled then
            local remote = getTradeRemote()
            local petsFolder = LocalPlayer:FindFirstChild("petsFolder")
            local unique = petsFolder and petsFolder:FindFirstChild("Unique")
            if not remote or not unique then
                task.wait(1)
                continue
            end
            for _, playerName in ipairs(PetsState.AutoTrade.SelectedPlayers) do
                local target = Services.Players:FindFirstChild(playerName)
                if target then
                    pcall(function() remote:FireServer("sendTradeRequest", target) end)
                    task.wait(0.5)
                    local offered = 0
                    for _, petName in ipairs(PetsState.AutoTrade.SelectedPets) do
                        for _, pet in ipairs(unique:GetChildren()) do
                            if pet.Name == petName and offered < 6 then
                                pcall(function() remote:FireServer("offerItem", pet) end)
                                offered = offered + 1
                                task.wait(0.05)
                            end
                        end
                    end
                    if offered > 0 then
                        task.wait(0.5)
                        pcall(function() remote:FireServer("acceptTrade") end)
                        task.wait(2)
                    end
                end
            end
        end
    end
end)

-- Lista de jugadores para trade
local function getPlayerNames()
    local list = {}
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    table.sort(list)
    return list
end

-- ═══ UI PETS ═══
Tabs.Pets:AddSection("Pet Shop", "🐾")

local petList, auraList = getPetShopLists()

local petShopDropdown
petShopDropdown = Tabs.Pets:AddDropdown("Buy Pet", petList, function(name)
    for _, n in ipairs(PetsState.SelectedPets) do
        if n == name then return end
    end
    table.insert(PetsState.SelectedPets, name)
    Utils.notify("Pet Shop", "Seleccionado: " .. name, 2, "info")
end)

Tabs.Pets:AddButton("Comprar Pets Seleccionadas", function()
    for _, name in ipairs(PetsState.SelectedPets) do
        buyFromShop(name)
        task.wait(0.1)
    end
    Utils.notify("Pet Shop", "Compra intentada", 2, "success")
end)

Tabs.Pets:AddSwitch("Auto Buy Pets", function(state)
    PetsState.AutoBuyPet = state
    Utils.notify("Auto Buy Pets", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Pets:AddButton("Clear Selected Pets", function()
    PetsState.SelectedPets = {}
end)

Tabs.Pets:AddSection("Auras", "🌌")

local auraDropdown
auraDropdown = Tabs.Pets:AddDropdown("Buy Aura", auraList, function(name)
    for _, n in ipairs(PetsState.SelectedAuras) do
        if n == name then return end
    end
    table.insert(PetsState.SelectedAuras, name)
end)

Tabs.Pets:AddButton("Comprar Auras Seleccionadas", function()
    for _, name in ipairs(PetsState.SelectedAuras) do
        buyFromShop(name)
        task.wait(0.1)
    end
    Utils.notify("Auras", "Compra intentada", 2, "success")
end)

Tabs.Pets:AddSwitch("Auto Buy Auras", function(state)
    PetsState.AutoBuyAura = state
end)

Tabs.Pets:AddSection("Auto Evolve", "✨")

local evolveDropdown
evolveDropdown = Tabs.Pets:AddDropdown("Evolve Pet", petList, function(name)
    for _, n in ipairs(PetsState.AutoEvolve.Selected) do
        if n == name then return end
    end
    table.insert(PetsState.AutoEvolve.Selected, name)
end)

Tabs.Pets:AddTextBox("Evolve Amount", function(text)
    local n = tonumber(text)
    if n and n >= 1 then PetsState.AutoEvolve.Amount = math.floor(n) end
end)

Tabs.Pets:AddSwitch("Auto Evolve", function(state)
    PetsState.AutoEvolve.Enabled = state
    Utils.notify("Auto Evolve", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Pets:AddSection("Auto Trade", "🔄")

local tradePlayerDropdown
tradePlayerDropdown = Tabs.Pets:AddDropdown("Trade Player", getPlayerNames(), function(name)
    for _, n in ipairs(PetsState.AutoTrade.SelectedPlayers) do
        if n == name then return end
    end
    table.insert(PetsState.AutoTrade.SelectedPlayers, name)
end)

local tradePetDropdown
tradePetDropdown = Tabs.Pets:AddDropdown("Trade Pet", petList, function(name)
    for _, n in ipairs(PetsState.AutoTrade.SelectedPets) do
        if n == name then return end
    end
    table.insert(PetsState.AutoTrade.SelectedPets, name)
end)

Tabs.Pets:AddSwitch("Auto Trade", function(state)
    PetsState.AutoTrade.Enabled = state
    Utils.notify("Auto Trade", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Pets:AddButton("Clear Trade Selection", function()
    PetsState.AutoTrade.SelectedPlayers = {}
    PetsState.AutoTrade.SelectedPets = {}
end)

-- ═══════════ [FIN PARTE 5] ═══════════
-- ═══════════════════════════════════════════════════════════════
-- [PARTE 6] TAB BOOSTS + TELEPORTS + STATS + INFO + CIERRE
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- TAB BOOSTS
-- ═══════════════════════════════════════════════════════════════

local BoostsState = {
    EatEggs = false,
    EatBoosts = false,
    EggGifter = { Player = nil, Amount = 0 },
    ShakeGifter = { Player = nil, Amount = 0 },
}
_G.Young0xBoostsState = BoostsState

-- Worker Eat Eggs
task.spawn(function()
    while task.wait(0.3) do
        if BoostsState.EatEggs then
            local char = Utils.getCharacter()
            local egg = (char and char:FindFirstChild("Protein Egg")) or Backpack:FindFirstChild("Protein Egg")
            if egg then
                local muscle = LocalPlayer:FindFirstChild("muscleEvent")
                if muscle then
                    pcall(function() muscle:FireServer("proteinEgg", egg) end)
                end
            end
        end
    end
end)

-- Worker Eat Boosts
local BOOST_ITEMS = {"Tropical Shake", "Energy Shake", "Protein Bar", "TOUGH Bar", "Protein Shake", "ULTRA Shake", "Energy Bar"}
task.spawn(function()
    while task.wait(0.15) do
        if BoostsState.EatBoosts then
            local char = Utils.getCharacter()
            for _, itemName in ipairs(BOOST_ITEMS) do
                local tool = (char and char:FindFirstChild(itemName)) or Backpack:FindFirstChild(itemName)
                if tool then
                    local muscle = LocalPlayer:FindFirstChild("muscleEvent")
                    if muscle then
                        pcall(function() muscle:FireServer(itemName, tool) end)
                    end
                end
            end
        end
    end
end)

-- Worker Egg Gifter
local GIFT_REMOTE
do
    local rEvents = Services.ReplicatedStorage:FindFirstChild("rEvents")
    GIFT_REMOTE = rEvents and rEvents:FindFirstChild("giftRemote")
end

task.spawn(function()
    while task.wait(0.3) do
        local cfg = BoostsState.EggGifter
        if cfg.Player and cfg.Amount > 0 then
            local target = Services.Players:FindFirstChild(cfg.Player)
            local consumables = LocalPlayer:FindFirstChild("consumablesFolder")
            local egg = consumables and consumables:FindFirstChild("Protein Egg")
            if target and egg and GIFT_REMOTE then
                pcall(function() GIFT_REMOTE:InvokeServer("giftRequest", target, egg) end)
                cfg.Amount = cfg.Amount - 1
                if cfg.Amount <= 0 then
                    Utils.notify("Egg Gifter", "Envío completado", 2, "success")
                    cfg.Player = nil
                end
                task.wait(0.15)
            else
                task.wait(0.5)
            end
        end
    end
end)

-- Worker Shake Gifter
task.spawn(function()
    while task.wait(0.3) do
        local cfg = BoostsState.ShakeGifter
        if cfg.Player and cfg.Amount > 0 then
            local target = Services.Players:FindFirstChild(cfg.Player)
            local consumables = LocalPlayer:FindFirstChild("consumablesFolder")
            local shake = consumables and consumables:FindFirstChild("Tropical Shake")
            if target and shake and GIFT_REMOTE then
                pcall(function() GIFT_REMOTE:InvokeServer("giftRequest", target, shake) end)
                cfg.Amount = cfg.Amount - 1
                if cfg.Amount <= 0 then
                    Utils.notify("Shake Gifter", "Envío completado", 2, "success")
                    cfg.Player = nil
                end
                task.wait(0.15)
            else
                task.wait(0.5)
            end
        end
    end
end)

-- Helper para dropdown de jugadores
local function getPlayerNamesForBoosts()
    local list = {}
    for _, p in ipairs(Services.Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    table.sort(list)
    return list
end

-- ═══ UI BOOSTS ═══
Tabs.Boosts:AddSection("Boost Eater", "🎁")

Tabs.Boosts:AddSwitch("Eat All Eggs", function(state)
    BoostsState.EatEggs = state
    Utils.notify("Eat Eggs", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Boosts:AddSwitch("Eat All Boosts", function(state)
    BoostsState.EatBoosts = state
    Utils.notify("Eat Boosts", state and "Activado" or "Desactivado (expect lag)", 2, state and "success" or "info")
end)

Tabs.Boosts:AddSection("Egg Gifter", "🥚")

Tabs.Boosts:AddDropdown("Gift Eggs To", getPlayerNamesForBoosts(), function(name)
    BoostsState.EggGifter.Player = name
end)

Tabs.Boosts:AddTextBox("Egg Amount", function(text)
    local n = tonumber(text)
    if n and n >= 1 then BoostsState.EggGifter.Amount = math.floor(n) end
end)

Tabs.Boosts:AddButton("Start Gifting Eggs", function()
    if BoostsState.EggGifter.Player and BoostsState.EggGifter.Amount > 0 then
        Utils.notify("Egg Gifter", "Enviando " .. BoostsState.EggGifter.Amount .. " eggs", 2, "info")
    else
        Utils.notify("Egg Gifter", "Configurá jugador y cantidad", 2, "warning")
    end
end)

Tabs.Boosts:AddSection("Shake Gifter", "🥤")

Tabs.Boosts:AddDropdown("Gift Shakes To", getPlayerNamesForBoosts(), function(name)
    BoostsState.ShakeGifter.Player = name
end)

Tabs.Boosts:AddTextBox("Shake Amount", function(text)
    local n = tonumber(text)
    if n and n >= 1 then BoostsState.ShakeGifter.Amount = math.floor(n) end
end)

Tabs.Boosts:AddButton("Start Gifting Shakes", function()
    if BoostsState.ShakeGifter.Player and BoostsState.ShakeGifter.Amount > 0 then
        Utils.notify("Shake Gifter", "Enviando " .. BoostsState.ShakeGifter.Amount .. " shakes", 2, "info")
    else
        Utils.notify("Shake Gifter", "Configurá jugador y cantidad", 2, "warning")
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB TELEPORTS
-- ═══════════════════════════════════════════════════════════════

local TP_LOCATIONS = {
    -- Main
    { name = "Tiny Island", pos = CFrame.new(-37.1, 9.2, 1919) },
    { name = "Main Island", pos = CFrame.new(16.07, 9.08, 133.8) },
    { name = "Beach", pos = CFrame.new(-8, 9, -169.2) },
    -- Gyms
    { name = "Overcharged Gym", pos = CFrame.new(-2941.766, 151.797, 4994.552) },
    { name = "Industrial Gym", pos = CFrame.new(-5254.68, 58.34, 4931.85) },
    { name = "Jungle Gym", pos = CFrame.new(-8543, 6.8, 2400) },
    { name = "Muscle King Gym", pos = CFrame.new(-8665.4, 17.21, -5792.9) },
    { name = "Legends Gym", pos = CFrame.new(4516, 991.5, -3856) },
    { name = "Infernal Gym", pos = CFrame.new(-6759, 7.36, -1284) },
    { name = "Mythical Gym", pos = CFrame.new(2250, 7.37, 1073.2) },
    { name = "Frost Gym", pos = CFrame.new(-2623, 7.36, -409) },
}

local function tpTo(pos)
    local root = Utils.getRoot()
    if root then
        root.CFrame = pos
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        Utils.notify("Teleport", "Teletransportado", 1.5, "success")
    end
end

Tabs.Teleports:AddSection("Main", "🏝️")
Tabs.Teleports:AddButton("Tiny Island", function() tpTo(TP_LOCATIONS[1].pos) end)
Tabs.Teleports:AddButton("Main Island", function() tpTo(TP_LOCATIONS[2].pos) end)
Tabs.Teleports:AddButton("Beach", function() tpTo(TP_LOCATIONS[3].pos) end)

Tabs.Teleports:AddSection("Gyms", "🏋️")
for i = 4, #TP_LOCATIONS do
    local loc = TP_LOCATIONS[i]
    Tabs.Teleports:AddButton(loc.name, function() tpTo(loc.pos) end)
end

-- ═══════════════════════════════════════════════════════════════
-- TAB STATS
-- ═══════════════════════════════════════════════════════════════

local StatsState = {
    StartTime = tick(),
    StartStrength = 0,
    StartRebirths = 0,
    Labels = {},
}

-- Init
task.spawn(function()
    local ls = LocalPlayer:WaitForChild("leaderstats", 10)
    if ls then
        local s = ls:WaitForChild("Strength", 10)
        local r = ls:WaitForChild("Rebirths", 10)
        if s then StatsState.StartStrength = s.Value end
        if r then StatsState.StartRebirths = r.Value end
    end
end)

local function formatTime(seconds)
    if seconds < 60 then return math.floor(seconds) .. "s"
    elseif seconds < 3600 then return string.format("%dm %ds", math.floor(seconds/60), math.floor(seconds%60))
    elseif seconds < 86400 then return string.format("%dh %dm", math.floor(seconds/3600), math.floor((seconds%3600)/60))
    else return string.format("%dd %dh", math.floor(seconds/86400), math.floor((seconds%86400)/3600)) end
end

Tabs.Stats:AddSection("Métricas en tiempo real", "📈")
Tabs.Stats:AddLabel("")

StatsState.Labels.StrengthGained = Tabs.Stats:AddLabel("💪 Fuerza ganada: 0")
StatsState.Labels.StrengthHour = Tabs.Stats:AddLabel("   x 1 Hora: 0")
StatsState.Labels.StrengthDay = Tabs.Stats:AddLabel("   x 1 Día: 0")
StatsState.Labels.StrengthWeek = Tabs.Stats:AddLabel("   x 1 Semana: 0")

Tabs.Stats:AddLabel("")
StatsState.Labels.RebirthsGained = Tabs.Stats:AddLabel("🔄 Rebirths ganados: 0")
StatsState.Labels.RebirthsHour = Tabs.Stats:AddLabel("   x 1 Hora: 0")
StatsState.Labels.RebirthsDay = Tabs.Stats:AddLabel("   x 1 Día: 0")
StatsState.Labels.RebirthsWeek = Tabs.Stats:AddLabel("   x 1 Semana: 0")

Tabs.Stats:AddLabel("")
StatsState.Labels.TimeSession = Tabs.Stats:AddLabel("⏱️ Tiempo en sesión: 0s")

task.spawn(function()
    while task.wait(1) do
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            local s = ls:FindFirstChild("Strength")
            local r = ls:FindFirstChild("Rebirths")
            local elapsed = tick() - StatsState.StartTime
            if s and elapsed > 0.5 then
                local gainS = s.Value - StatsState.StartStrength
                local rateS = (gainS / elapsed) * 3600
                StatsState.Labels.StrengthGained.Text = "💪 Fuerza ganada: " .. Utils.formatNumber(gainS)
                StatsState.Labels.StrengthHour.Text = "   x 1 Hora: " .. Utils.formatNumber(rateS)
                StatsState.Labels.StrengthDay.Text = "   x 1 Día: " .. Utils.formatNumber(rateS * 24)
                StatsState.Labels.StrengthWeek.Text = "   x 1 Semana: " .. Utils.formatNumber(rateS * 24 * 7)
            end
            if r and elapsed > 0.5 then
                local gainR = r.Value - StatsState.StartRebirths
                local rateR = (gainR / elapsed) * 3600
                StatsState.Labels.RebirthsGained.Text = "🔄 Rebirths ganados: " .. Utils.formatNumber(gainR)
                StatsState.Labels.RebirthsHour.Text = "   x 1 Hora: " .. Utils.formatNumber(rateR)
                StatsState.Labels.RebirthsDay.Text = "   x 1 Día: " .. Utils.formatNumber(rateR * 24)
                StatsState.Labels.RebirthsWeek.Text = "   x 1 Semana: " .. Utils.formatNumber(rateR * 24 * 7)
            end
            StatsState.Labels.TimeSession.Text = "⏱️ Tiempo en sesión: " .. formatTime(elapsed)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- TAB INFO
-- ═══════════════════════════════════════════════════════════════

Tabs.Info:AddSection("Información", "ℹ️")
Tabs.Info:AddLabel("HonenxWhite Reborn")
Tabs.Info:AddLabel("Made by Honen")
Tabs.Info:AddLabel("Version 1.0 — Rebuild 2026")
Tabs.Info:AddLabel("")

Tabs.Info:AddButton("📋 Copiar Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        Utils.notify("Discord", "Link copiado al portapapeles", 2, "success")
    else
        Utils.notify("Error", "Tu executor no soporta clipboard", 3, "error")
    end
end)

Tabs.Info:AddButton("🌐 Abrir Repositorio", function()
    if setclipboard then
        setclipboard("https://github.com/rodriguezberiticajuliocesar-wq/nebula-gui")
        Utils.notify("Repositorio", "Link copiado", 2, "success")
    end
end)

Tabs.Info:AddLabel("")
Tabs.Info:AddLabel("Contributors:")
Tabs.Info:AddLabel("- Honen (Owner)")
Tabs.Info:AddLabel("- cyanam1")
Tabs.Info:AddLabel("- White")

-- ═══════════════════════════════════════════════════════════════
-- EMERGENCY STOP + CIERRE
-- ═══════════════════════════════════════════════════════════════

Tabs.Info:AddSection("Emergency", "🚨")

Tabs.Info:AddButton("🛑 EMERGENCY STOP", function()
    -- Detener todo
    if _G.Young0xMainState then
        for _, state in pairs(_G.Young0xMainState) do
            if type(state) == "table" and state.Enabled ~= nil then
                state.Enabled = false
            end
        end
    end
    if _G.Young0xKillState then
        _G.Young0xKillState.AutoKill = false
        _G.Young0xKillState.KarmaMode = nil
        _G.Young0xKillState.TargetMode = false
        _G.Young0xKillState.KillAura.Enabled = false
        if _G.Young0xKillState.KillAura.Ring then
            _G.Young0xKillState.KillAura.Ring:Destroy()
        end
    end
    if _G.Young0xFarmingState then
        _G.Young0xFarmingState.AutoRebirth.Enabled = false
        _G.Young0xFarmingState.Exercise.Enabled = false
        _G.Young0xFarmingState.Rock.Enabled = false
    end
    if _G.Young0xFastState then
        _G.Young0xFastState.FastRep.Enabled = false
        _G.Young0xFastState.FastRebirth.Enabled = false
        _G.Young0xFastState.UltraTitans.Enabled = false
        _G.Young0xFastState.ChaosOverlords.Enabled = false
    end
    if _G.Young0xBossState then
        _G.Young0xBossState.MainEnabled = false
        _G.Young0xBossState.HalloweenEnabled = false
    end
    Utils.notify("Emergency Stop", "Todas las funciones detenidas", 4, "error")
end)

Tabs.Info:AddButton("❌ Cerrar GUI", function()
    win:Destroy()
end)

-- ═══════════ [FIN PARTE 6] ═══════════

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICACIÓN FINAL
-- ═══════════════════════════════════════════════════════════════
Utils.notify("HonenxWhite Reborn", "Hub cargado correctamente ✅", 4, "success")
return win
