-- KNI_UI.luau v2.1 (Optimizado y corregido por HonenxWhite)
-- Librería de interfaz compacta para Roblox.
-- Incluye: AddTab, AddLabel, AddSection, AddButton, AddSwitch, AddTextBox, AddDropdown, AddSlider
-- Con :Set(), :Get(), notificaciones, dropdowns dinámicos y más.
--
-- Cambios v2.1:
--   • Dropdowns con altura máxima configurable y apertura inteligente (arriba/abajo).
--   • Nombres de tabs sin cortar (TextScaled, ancho ajustado, tamaño de fuente reducido).
--   • Optimización de carga: AddBulk, refresh incremental, throttle de refresh.
--   • Botones del dropdown con ZIndex elevado para que no queden detrás de otros elementos.

local KNI = {}
KNI.__index = KNI

local COLORS = {
    Background = Color3.fromRGB(12, 13, 20),
    Panel = Color3.fromRGB(20, 22, 33),
    Panel2 = Color3.fromRGB(29, 31, 46),
    Accent = Color3.fromRGB(145, 77, 255),
    Accent2 = Color3.fromRGB(83, 49, 163),
    Text = Color3.fromRGB(244, 242, 255),
    Muted = Color3.fromRGB(160, 158, 181),
    Border = Color3.fromRGB(55, 48, 78),
    Good = Color3.fromRGB(80, 220, 160),
    Bad = Color3.fromRGB(220, 80, 100),
    Warn = Color3.fromRGB(240, 180, 80),
}

-- ⚙️ Configuración global del dropdown (podés ajustarla desde tu script)
local DROPDOWN_MAX_HEIGHT = 220   -- altura máxima del menú desplegable en px
local DROPDOWN_ITEM_HEIGHT = 22   -- altura de cada item
local DROPDOWN_PADDING = 6        -- padding interno del menú

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    make("UIStroke", {
        Color = color or COLORS.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0.15,
    }, parent)
end

local function padding(parent, left, right, top, bottom)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, left or 10),
        PaddingRight = UDim.new(0, right or 10),
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
    }, parent)
end

local function tween(obj, time, props, style, dir)
    local t = Services.TweenService:Create(
        obj,
        TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

-- ═══ NOTIFICACIONES ═══
local Notify = {}
local notifyContainer = nil

local function ensureNotifyContainer()
    if notifyContainer and notifyContainer.Parent then return notifyContainer end
    local player = Services.Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")
    local screen = make("ScreenGui", {
        Name = "KNI_Notify",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 1000,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, pg)
    local holder = make("Frame", {
        Name = "Holder",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.fromOffset(280, 500),
        BackgroundTransparency = 1,
    }, screen)
    make("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, holder)
    notifyContainer = holder
    return holder
end

function Notify:Show(title, text, duration, kind)
    local holder = ensureNotifyContainer()
    duration = duration or 4
    kind = kind or "info"
    local color = COLORS.Accent
    if kind == "success" then color = COLORS.Good
    elseif kind == "warning" then color = COLORS.Warn
    elseif kind == "error" then color = COLORS.Bad end

    local card = make("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, holder)
    corner(card, 8)
    stroke(card, color, 1.2, 0.2)

    make("Frame", {
        Size = UDim2.fromOffset(3, 36),
        Position = UDim2.new(0, 6, 0.5, -18),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.fromOffset(14, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = color,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    make("TextLabel", {
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.fromOffset(14, 22),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = COLORS.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    }, card)

    card.Position = UDim2.new(1, 300, 0, 0)
    tween(card, 0.25, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)

    task.delay(duration, function()
        if card and card.Parent then
            tween(card, 0.2, { Position = UDim2.new(1, 300, 0, 0) })
            task.wait(0.25)
            card:Destroy()
        end
    end)
end

KNI.Notify = Notify

-- ═══ KNI.new ═══
function KNI.new(options)
    options = options or {}
    local player = Services.Players.LocalPlayer
    assert(player, "KNI_UI debe iniciarse desde un LocalScript")
    local guiParent = player:WaitForChild("PlayerGui")

    local self = setmetatable({}, KNI)
    self._connections = {}
    self._tabs = {}
    self._destroyed = false
    self._minimized = false

    local gui = make("ScreenGui", {
        Name = options.Name or "KNI_Interface",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 50,
    }, guiParent)
    self.Gui = gui

    local root = make("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(options.Width or 620, options.Height or 420),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
    }, gui)
    root.ClipsDescendants = true
    corner(root, 14)
    stroke(root, COLORS.Border, 1.2)
    self.Root = root

    local top = make("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
    }, root)
    self.TopBar = top
    corner(top, 14)
    make("Frame", {
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
    }, top)

    make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -150, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = options.Title or "HonenxWhite | Reborn",
        TextColor3 = COLORS.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, top)

    local function topButton(text, x, color, callback)
        local b = make("TextButton", {
            Size = UDim2.fromOffset(28, 26),
            Position = UDim2.new(1, x, 0, 8),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = COLORS.Text,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = true,
        }, top)
        corner(b, 8)
        table.insert(self._connections, b.Activated:Connect(callback))
        return b
    end

    local restore = make("TextButton", {
        Name = "RestoreButton",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.fromOffset(52, 52),
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Text = "HW",
        TextColor3 = COLORS.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBlack,
        Visible = false,
        ZIndex = 100,
    }, gui)
    corner(restore, 18)
    stroke(restore, COLORS.Text, 1, 0.3)
    self.RestoreButton = restore

    local content = make("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(0, 42),
        Size = UDim2.new(1, 0, 1, -42),
        BackgroundTransparency = 1,
    }, root)
    self.Content = content

    -- Rail más ancho (140px) para que los nombres entren sin cortarse
    local rail = make("ScrollingFrame", {
        Name = "TabRail",
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(0, 140, 1, -20),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, content)
    corner(rail, 10)
    padding(rail, 7, 7, 8, 8)
    make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, rail)
    self.TabRail = rail

    local pages = make("Frame", {
        Name = "Pages",
        Position = UDim2.new(0, 160, 0, 10),
        Size = UDim2.new(1, -170, 1, -20),
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
    }, content)
    corner(pages, 10)
    self.Pages = pages

    local dragging, dragStart, startPos
    table.insert(self._connections, top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
        end
    end))
    table.insert(self._connections, Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    table.insert(self._connections, Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))

    topButton("—", -72, COLORS.Panel2, function()
        self._minimized = true
        root.Visible = false
        restore.Visible = true
    end)
    topButton("×", -38, Color3.fromRGB(130, 43, 65), function()
        self:Destroy()
    end)
    table.insert(self._connections, restore.Activated:Connect(function()
        if not self._destroyed then
            self._minimized = false
            root.Visible = true
            restore.Visible = false
        end
    end))

    function self:SetTitle(text)
        local label = top:FindFirstChild("Title")
        if label then label.Text = tostring(text) end
    end

    return self
end

-- ═══ KNI:AddTab ═══
function KNI:AddTab(name)
    assert(not self._destroyed, "La interfaz fue cerrada")
    local tab = {Name = name, _ui = self, _controls = {}}

    -- 👇 Tab button con tamaño adaptativo y texto completo
    local button = make("TextButton", {
        Name = "Tab_" .. tostring(name),
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = COLORS.Panel2,
        BorderSizePixel = 0,
        Text = tostring(name),
        TextColor3 = COLORS.Muted,
        TextSize = 10,                    -- 👈 reducido de 11 a 10
        TextScaled = false,               -- 👈 desactivado explícitamente
        TextWrapped = false,              -- 👈 sin wrap para que no se rompa
        TextTruncate = Enum.TextTruncate.None,  -- 👈 sin truncar
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = true,
    }, self.TabRail)
    corner(button, 8)

    local page = make("ScrollingFrame", {
        Name = "Page_" .. tostring(name),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ClipsDescendants = true,          -- 👈 evita que los dropdowns se salgan de la página
    }, self.Pages)
    padding(page, 10, 10, 10, 10)
    make("UIListLayout", {Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder}, page)

    local function activate()
        for _, item in ipairs(self._tabs) do
            item.Page.Visible = false
            item.Button.BackgroundColor3 = COLORS.Panel2
            item.Button.TextColor3 = COLORS.Muted
        end
        page.Visible = true
        button.BackgroundColor3 = COLORS.Accent2
        button.TextColor3 = COLORS.Text
    end
    table.insert(self._connections, button.Activated:Connect(activate))
    tab.Button, tab.Page = button, page
    table.insert(self._tabs, tab)
    if #self._tabs == 1 then activate() end

    local function row(height)
        local frame = make("Frame", {
            Size = UDim2.new(1, 0, 0, height or 34),
            BackgroundColor3 = COLORS.Panel2,
            BorderSizePixel = 0,
        }, page)
        corner(frame, 8)
        return frame
    end

    function tab:AddLabel(text)
        local r = row(28)
        r.BackgroundTransparency = 1
        local label = make("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = tostring(text),
            TextColor3 = COLORS.Muted,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
        }, r)
        local control = {Instance = label}
        function control:SetText(value) label.Text = tostring(value) end
        function control:Set(value) label.Text = tostring(value) end
        setmetatable(control, {
            __index = function(_, key) if key == "Text" then return label.Text end end,
            __newindex = function(t, key, value)
                if key == "Text" then label.Text = tostring(value) else rawset(t, key, value) end
            end,
        })
        return control
    end

    function tab:AddSection(text)
        local r = row(26)
        r.BackgroundTransparency = 1
        local label = make("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 1, 0),
            Text = tostring(text),
            TextColor3 = COLORS.Accent,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        make("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(40, 1),
            BackgroundColor3 = COLORS.Accent,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
        }, r)
        return {Instance = label}
    end

    function tab:AddButton(text, callback)
        local r = row(32)
        local b = make("TextButton", {
            Position = UDim2.fromOffset(4, 3),
            Size = UDim2.new(1, -8, 1, -6),
            BackgroundColor3 = COLORS.Accent2,
            BorderSizePixel = 0,
            Text = tostring(text),
            TextColor3 = COLORS.Text,
            TextSize = 11,
            Font = Enum.Font.GothamSemibold,
        }, r)
        corner(b, 7)
        table.insert(self._ui._connections, b.Activated:Connect(function()
            if callback then task.spawn(callback) end
        end))
        return b
    end

    function tab:AddSwitch(text, callback, default)
        local r = row(36)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -72, 1, 0),
            Text = tostring(text),
            TextColor3 = COLORS.Text,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        }, r)
        local b = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -7, 0.5, 0),
            Size = UDim2.fromOffset(48, 23),
            BackgroundColor3 = COLORS.Panel,
            BorderSizePixel = 0,
            Text = "OFF",
            TextColor3 = COLORS.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
        }, r)
        corner(b, 12)

        local control = {Value = default == true}

        local function render()
            b.Text = control.Value and "ON" or "OFF"
            b.BackgroundColor3 = control.Value and COLORS.Accent or COLORS.Panel
            b.TextColor3 = control.Value and COLORS.Text or COLORS.Muted
        end

        function control:Set(value, silent)
            control.Value = value == true
            render()
            if not silent and callback then
                local ok, err = pcall(callback, control.Value)
                if not ok then warn("[KNI] Switch error:", err) end
            end
        end

        function control:Get()
            return control.Value
        end

        render()
        table.insert(self._ui._connections, b.Activated:Connect(function()
            control:Set(not control.Value)
        end))
        return control
    end

    function tab:AddTextBox(text, callback, opts)
        local r = row(56)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(9, 2),
            Size = UDim2.new(1, -18, 0, 18),
            Text = tostring(text),
            TextColor3 = COLORS.Muted,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        local box = make("TextBox", {
            Position = UDim2.fromOffset(7, 24),
            Size = UDim2.new(1, -14, 0, 26),
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
            Text = "",
            PlaceholderText = "Escribe aquí…",
            ClearTextOnFocus = not (opts and opts.clear == false),
            TextColor3 = COLORS.Text,
            PlaceholderColor3 = COLORS.Muted,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        corner(box, 6)
        padding(box, 7, 7, 0, 0)
        table.insert(self._ui._connections, box.FocusLost:Connect(function(enter)
            if callback then
                local ok, err = pcall(callback, box.Text, enter)
                if not ok then warn("[KNI] TextBox error:", err) end
            end
        end))
        return box
    end

    function tab:AddSlider(text, min, max, default, callback)
        min, max = min or 0, max or 100
        default = math.clamp(default or min, min, max)

        local r = row(46)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(10, 2),
            Size = UDim2.new(1, -80, 0, 18),
            Text = tostring(text),
            TextColor3 = COLORS.Text,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, r)

        local valueLabel = make("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 2),
            Size = UDim2.fromOffset(60, 18),
            BackgroundTransparency = 1,
            Text = tostring(default),
            TextColor3 = COLORS.Accent,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, r)

        local track = make("Frame", {
            Position = UDim2.fromOffset(10, 26),
            Size = UDim2.new(1, -20, 0, 5),
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
        }, r)
        corner(track, 3)

        local fill = make("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = COLORS.Accent,
            BorderSizePixel = 0,
        }, track)
        corner(fill, 3)

        local currentValue = default
        local initRel = (default - min) / (max - min)
        fill.Size = UDim2.new(initRel, 0, 1, 0)

        local function updateFromX(x)
            local relX = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relX + 0.5)
            valueLabel.Text = tostring(currentValue)
            tween(fill, 0.06, { Size = UDim2.new(relX, 0, 1, 0) }, Enum.EasingStyle.Linear)
        end

        local function startDrag(input)
            updateFromX(input.Position.X)
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                    if callback then
                        local ok, err = pcall(callback, currentValue)
                        if not ok then warn("[KNI] Slider error:", err) end
                    end
                elseif input.UserInputState == Enum.UserInputState.Change then
                    updateFromX(input.Position.X)
                end
            end)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                startDrag(input)
            end
        end)

        return {
            Set = function(_, value)
                value = math.clamp(value, min, max)
                currentValue = value
                valueLabel.Text = tostring(value)
                local rel = (value - min) / (max - min)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                if callback then pcall(callback, value) end
            end,
            Get = function() return currentValue end,
        }
    end

    -- ═══════════════════════════════════════════════════════════════
    -- DROPDOWN MEJORADO (v2.1)
    --   • Altura máxima configurable (DROPDOWN_MAX_HEIGHT)
    --   • Se abre hacia arriba o abajo según espacio disponible
    --   • ZIndex elevado al abrir → no queda detrás de otros elementos
    --   • refresh() incremental (no destruye todo)
    --   • AddBulk() para cargar muchos items de una sola vez
    -- ═══════════════════════════════════════════════════════════════
    function tab:AddDropdown(text, callback, default)
        local control = {
            Items = {},
            Selected = default,
            _ui = self._ui,
            _itemButtons = {},
            _refreshQueued = false,
            _open = false,
        }

        local r = row(56)
        local b = make("TextButton", {
            Position = UDim2.fromOffset(7, 5),
            Size = UDim2.new(1, -14, 0, 24),
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
            Text = tostring(text) .. "  ▾",
            TextColor3 = COLORS.Text,
            TextSize = 10,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClipsDescendants = true,
        }, r)
        corner(b, 6)

        -- El menú se ancla al row (no al button) y se ajusta dinámicamente
        local menu = make("Frame", {
            Position = UDim2.new(0, 7, 0, 32),
            Size = UDim2.new(1, -14, 0, 0),
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
            Visible = false,
            ClipsDescendants = true,
            ZIndex = 50,
        }, r)
        corner(menu, 6)
        stroke(menu, COLORS.Border, 1, 0.3)

        local list = make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = COLORS.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ZIndex = 51,
            ClipsDescendants = true,
        }, menu)
        local listLayout = make("UIListLayout", {Padding = UDim.new(0, 2)}, list)
        make("UIPadding", {
            PaddingTop = UDim.new(0, 3),
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 3),
            PaddingRight = UDim.new(0, 3),
        }, list)

        -- ─── Refresh incremental: agrega solo los items nuevos ───
        local function ensureItemButton(item)
            if control._itemButtons[item] then return control._itemButtons[item] end
            local choice = make("TextButton", {
                Size = UDim2.new(1, 0, 0, DROPDOWN_ITEM_HEIGHT),
                BackgroundColor3 = COLORS.Panel2,
                BorderSizePixel = 0,
                Text = tostring(item),
                TextColor3 = COLORS.Text,
                TextSize = 10,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 52,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, list)
            corner(choice, 5)
            padding(choice, 6, 6, 0, 0)
            table.insert(self._ui._connections, choice.Activated:Connect(function()
                control.Selected = tostring(item)
                b.Text = tostring(text) .. ": " .. control.Selected .. "  ▾"
                control:_close()
                if callback then
                    local ok, err = pcall(callback, control.Selected)
                    if not ok then warn("[KNI] Dropdown error:", err) end
                end
            end))
            control._itemButtons[item] = choice
            return choice
        end

        local function queueRefresh()
            if control._refreshQueued then return end
            control._refreshQueued = true
            task.defer(function()
                control._refreshQueued = false
                if not menu.Parent then return end
                -- Eliminar botones huérfanos (items que ya no están)
                for item, btn in pairs(control._itemButtons) do
                    local exists = false
                    for _, v in ipairs(control.Items) do
                        if v == item then exists = true break end
                    end
                    if not exists then
                        btn:Destroy()
                        control._itemButtons[item] = nil
                    end
                end
                -- Crear botones para items nuevos
                for _, item in ipairs(control.Items) do
                    ensureItemButton(item)
                end
                -- Layout order para mantener orden visual
                for i, item in ipairs(control.Items) do
                    local btn = control._itemButtons[item]
                    if btn then btn.LayoutOrder = i end
                end
            end)
        end

        -- ─── Cálculo de altura y dirección de apertura ───
        local function computeMenuHeight()
            local totalHeight = #control.Items * (DROPDOWN_ITEM_HEIGHT + 2) + DROPDOWN_PADDING
            return math.min(totalHeight, DROPDOWN_MAX_HEIGHT)
        end

        -- Determina si el menú debe abrirse hacia arriba o hacia abajo
        -- según el espacio disponible en la pantalla y la posición del button.
        local function computeMenuPosition()
            local viewportHeight = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y or 600
            local buttonAbsoluteY = b.AbsolutePosition.Y
            local buttonHeight = b.AbsoluteSize.Y
            local desiredHeight = computeMenuHeight()
            local spaceBelow = viewportHeight - (buttonAbsoluteY + buttonHeight)
            local spaceAbove = buttonAbsoluteY

            -- Si hay más espacio abajo o el menú cabe abajo, abrir abajo
            if spaceBelow >= desiredHeight or spaceBelow >= spaceAbove then
                return UDim2.new(0, 7, 0, 32), desiredHeight  -- abajo
            else
                -- Abrir arriba (offset negativo hacia arriba)
                return UDim2.new(0, 7, 0, -(desiredHeight + 6)), desiredHeight  -- arriba
            end
        end

        function control:_open()
            control._open = true
            menu.Visible = true
            local pos, h = computeMenuPosition()
            menu.Position = pos
            menu.Size = UDim2.new(1, -14, 0, 0)
            tween(menu, 0.12, { Size = UDim2.new(1, -14, 0, h) }, Enum.EasingStyle.Quart)
        end

        function control:_close()
            control._open = false
            menu.Visible = false
            menu.Size = UDim2.new(1, -14, 0, 0)
        end

        function control:Add(item)
            table.insert(control.Items, tostring(item))
            queueRefresh()
        end

        -- 👇 Nuevo: agregar muchos items de una sola vez (mucho más rápido)
        function control:AddBulk(items)
            for _, item in ipairs(items or {}) do
                table.insert(control.Items, tostring(item))
            end
            queueRefresh()
        end

        function control:Remove(item)
            for i, v in ipairs(control.Items) do
                if v == item then
                    table.remove(control.Items, i)
                    break
                end
            end
            queueRefresh()
        end

        function control:SetOptions(items)
            control.Items = {}
            for _, item in ipairs(items or {}) do
                table.insert(control.Items, tostring(item))
            end
            queueRefresh()
        end

        function control:Set(value)
            control.Selected = tostring(value)
            b.Text = tostring(text) .. ": " .. control.Selected .. "  ▾"
        end

        function control:Get()
            return control.Selected
        end

        function control:Clear()
            control.Items = {}
            control.Selected = nil
            b.Text = tostring(text) .. "  ▾"
            queueRefresh()
        end

        table.insert(self._ui._connections, b.Activated:Connect(function()
            if control._open then
                control:_close()
            else
                control:_open()
            end
        end))

        queueRefresh()
        return control
    end

    function tab:Show()
        activate()
    end

    return tab
end

function KNI:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    for _, connection in ipairs(self._connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(self._connections)
    if self.Gui then self.Gui:Destroy() end
end

return KNI
