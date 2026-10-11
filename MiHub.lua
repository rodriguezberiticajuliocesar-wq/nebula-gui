--[[
    ═══════════════════════════════════════════════════════
    HonenxWhite Reborn — Made by Honen
    Repositorio: github.com/TU_USUARIO/MiHub
    ═══════════════════════════════════════════════════════
]]

-- ═══════════ CARGAR LIBRERÍA ═══════════
local LIB_URL = "https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/NebulaGUI.lua"
local ok, NebulaGUI = pcall(function()
    return loadstring(game:HttpGet(LIB_URL))()
end)

if not ok or type(NebulaGUI) ~= "table" then
    warn("[HonenxWhite] No se pudo cargar NebulaGUI: " .. tostring(NebulaGUI))
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HonenxWhite",
        Text = "Error al cargar la librería GUI.",
        Duration = 5,
    })
    return
end

-- ═══════════ SERVICIOS Y UTILS ═══════════
local Services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    TweenService = game:GetService("TweenService"),
    Lighting = game:GetService("Lighting"),
    Stats = game:GetService("Stats"),
}
local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Anti-AFK
local function setupAntiAFK()
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            Services.VirtualUser:CaptureController()
            Services.VirtualUser:ClickButton2(Vector2.new(0, 0))
            Services.VirtualUser:ClickButton1(Vector2.new(0, 0))
        end)
    end)
end
setupAntiAFK()

-- ═══════════ CREAR VENTANA ═══════════
local win = NebulaGUI:CreateWindow({
    Title = "HonenxWhite | Reborn",
    Subtitle = "Made by Honen",
    Size = UDim2.fromOffset(640, 480),
})

-- ═══════════ TABS ═══════════
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

-- ═══════════ MAIN TAB (ejemplo funcional) ═══════════
Tabs.Main:AddSection("User Settings", "⚙️")
Tabs.Main:AddSwitch("Anti Fling", function(state)
    NebulaGUI.Notify.show("Anti Fling", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)
Tabs.Main:AddSwitch("Lock Position", function(state)
    NebulaGUI.Notify.show("Lock Position", state and "Activado" or "Desactivado", 2, "info")
end)
Tabs.Main:AddSwitch("Hide Pets", function(state) print("Hide Pets:", state) end)
Tabs.Main:AddSwitch("Infinite Jump", function(state) print("Inf Jump:", state) end)

Tabs.Main:AddSection("Otros", "🌐")
Tabs.Main:AddDropdown("Cambiar Hora", {"Day", "Night"}, function(opt)
    Services.Lighting.ClockTime = (opt == "Night") and 0 or 14
end, "Day")

-- ═══════════ INFO TAB ═══════════
Tabs.Info:AddSection("Información", "ℹ️")
Tabs.Info:AddLabel("Made by Honen")
Tabs.Info:AddLabel("Version 1.0 - Reborn")
Tabs.Info:AddButton("📋 Copy Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        NebulaGUI.Notify.show("Discord", "Link copiado", 2, "success")
    end
end)

-- ═══════════ NOTIFICACIÓN INICIAL ═══════════
NebulaGUI.Notify.show("HonenxWhite", "Hub cargado correctamente", 3, "success")

return win
