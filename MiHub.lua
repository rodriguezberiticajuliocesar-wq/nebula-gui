--[[
    ═══════════════════════════════════════════════════════
    HonenxWhite Reborn — Made by Honen
    Repositorio: github.com/rodriguezberiticajuliocesar-wq/nebula-gui
    ═══════════════════════════════════════════════════════
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
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    VirtualUser = game:GetService("VirtualUser"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    TweenService = game:GetService("TweenService"),
    Lighting = game:GetService("Lighting"),
    Stats = game:GetService("Stats"),
    StarterGui = game:GetService("StarterGui"),
}
local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- ═══════════ ANTI-AFK ═══════════
local AntiAFKEnabled = true
LocalPlayer.Idled:Connect(function()
    if AntiAFKEnabled then
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

-- ═══════════ TAB: MAIN ═══════════
Tabs.Main:AddSection("User Settings", "⚙️")

Tabs.Main:AddSwitch("Anti Fling", function(state)
    NebulaGUI.Notify.show("Anti Fling", state and "Activado" or "Desactivado", 2, state and "success" or "info")
end)

Tabs.Main:AddSwitch("Lock Position", function(state)
    NebulaGUI.Notify.show("Lock Position", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Hide Pets", function(state)
    NebulaGUI.Notify.show("Hide Pets", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Hide Popups", function(state)
    NebulaGUI.Notify.show("Hide Popups", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Redact Name", function(state)
    NebulaGUI.Notify.show("Redact Name", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Redact Stats", function(state)
    NebulaGUI.Notify.show("Redact Stats", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Walk on Water", function(state)
    NebulaGUI.Notify.show("Walk on Water", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Infinite Jump", function(state)
    NebulaGUI.Notify.show("Infinite Jump", state and "Activado" or "Desactivado", 2, "info")
end)

Tabs.Main:AddSwitch("Anti AFK", function(state)
    AntiAFKEnabled = state
    NebulaGUI.Notify.show("Anti AFK", state and "Activado" or "Desactivado", 2, "info")
end, true)

Tabs.Main:AddSection("Otros", "🌐")

Tabs.Main:AddDropdown("Cambiar Hora", {"Day", "Night"}, function(opt)
    Services.Lighting.ClockTime = (opt == "Night") and 0 or 14
    NebulaGUI.Notify.show("Hora", "Cambiado a: " .. opt, 2, "success")
end, "Day")

Tabs.Main:AddSlider("FOV", 50, 120, 70, function(value)
    local cam = workspace.CurrentCamera
    if cam then cam.FieldOfView = value end
end)

-- ═══════════ TAB: INFO ═══════════
Tabs.Info:AddSection("Información", "ℹ️")
Tabs.Info:AddLabel("Made by Honen")
Tabs.Info:AddLabel("Version 1.0 - Reborn")
Tabs.Info:AddLabel("")

Tabs.Info:AddButton("📋 Copiar Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/bVDtwKF92")
        NebulaGUI.Notify.show("Discord", "Link copiado al portapapeles", 2, "success")
    else
        NebulaGUI.Notify.show("Error", "Tu executor no soporta clipboard", 3, "error")
    end
end)

-- ═══════════ NOTIFICACIÓN INICIAL ═══════════
NebulaGUI.Notify.show("HonenxWhite", "Hub cargado correctamente", 3, "success")

return win
