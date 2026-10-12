-- KNI_MuscleLegends.client.lua
-- Plantilla de integración con la librería KNI_UI.
-- Coloca KNI_UI como ModuleScript en ReplicatedStorage y este archivo como LocalScript.
-- Los callbacks marcados abajo son puntos de integración: incorpora únicamente lógica que
-- tengas permiso para ejecutar y que no suplante pases de pago ni abuse de RemoteEvents.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KNI = require(ReplicatedStorage:WaitForChild("KNI_UI"))

local player = Players.LocalPlayer
local window = KNI.new({
    Name = "KNI_MuscleLegends",
    Title = "KNI | Muscle Legends",
    Width = 560,
    Height = 390,
})

local tabs = {
    main = window:AddTab("Main"),
    killing = window:AddTab("Killing"),
    specs = window:AddTab("Specs"),
    farming = window:AddTab("Farming"),
    fast = window:AddTab("⚡ Fast"),
    boss = window:AddTab("Boss"),
    pets = window:AddTab("Pets"),
    boosts = window:AddTab("Boosts"),
    teleport = window:AddTab("Teleports"),
    stats = window:AddTab("Stats"),
    info = window:AddTab("Info"),
}

local function unavailable(feature)
    warn("[KNI] La función '" .. feature .. "' necesita migrarse desde el archivo original y validarse antes de activarla.")
end

tabs.main:AddLabel("KNI UI • interfaz compacta")
tabs.main:AddLabel("Arrastra la barra superior para mover la ventana.")
tabs.main:AddLabel("Usa — para minimizar y el botón KNI para restaurar.")
tabs.main:AddLabel("Cerrar elimina la interfaz y desconecta sus eventos.")

tabs.main:AddSwitch("Ejemplo de interruptor", function(enabled)
    print("[KNI] Ejemplo:", enabled)
end)

tabs.main:AddTextBox("Ejemplo de campo numérico:", function(text)
    local value = tonumber(text)
    if not value then
        warn("[KNI] Introduce un número válido.")
        return
    end
    print("[KNI] Valor:", value)
end, {clear = false})

tabs.main:AddButton("Comprobar personaje", function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    print("[KNI] Personaje:", character and character.Name or "No disponible")
    print("[KNI] Humanoid:", humanoid and humanoid.Health or "No disponible")
end)

-- Mantiene las categorías del script de referencia listas para migrar.
for _, name in ipairs({"Killing", "Specs", "Farming", "Fast", "Boss", "Pets", "Boosts", "Teleports", "Stats"}) do
    local key = string.lower(name)
    local tab = tabs[key]
    if tab then
        tab:AddLabel("Sección " .. name)
        tab:AddLabel("Migra aquí los controles y callbacks de la sección original.")
        tab:AddButton("Ver estado de migración", function()
            unavailable(name)
        end)
    end
end

tabs.info:AddLabel("KNI UI • creada desde cero")
tabs.info:AddLabel("No carga bibliotecas de interfaz desde URLs externas.")
tabs.info:AddLabel("Versión: 1.0")
tabs.info:AddButton("Cerrar interfaz", function()
    window:Destroy()
end)

print("[KNI] Interfaz cargada correctamente.")
