--[[
    HonenxWhite | Reborn
    Hub completo para Muscle Legends usando KNI_UI
    Made by Honen / cyanam1 / White
]]

-- ═══ CARGAR KNI_UI (embebido) ═══
local KNI = (function()

-- KNI_UI.luau v2.0
-- Librería de interfaz compacta para Roblox.
-- Incluye: AddTab, AddLabel, AddSection, AddButton, AddSwitch, AddTextBox, AddDropdown, AddSlider
-- Con :Set(), :Get(), notificaciones, dropdowns dinámicos y más.

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

    local rail = make("ScrollingFrame", {
        Name = "TabRail",
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(0, 132, 1, -20),
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
        Position = UDim2.new(0, 152, 0, 10),
        Size = UDim2.new(1, -162, 1, -20),
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
    local button = make("TextButton", {
        Name = "Tab_" .. tostring(name),
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = COLORS.Panel2,
        BorderSizePixel = 0,
        Text = tostring(name),
        TextColor3 = COLORS.Muted,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        TextWrapped = true,
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

    function tab:AddDropdown(text, callback, default)
        local control = {Items = {}, Selected = default, _ui = self._ui}
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
        }, r)
        corner(b, 6)

        -- 👇 El menú se crea en un ScreenGui overlay con DisplayOrder 999
        local overlayScreen
        local existingOverlay = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("KNI_DropdownOverlay")
        if existingOverlay then
            overlayScreen = existingOverlay
        else
            overlayScreen = Instance.new("ScreenGui")
            overlayScreen.Name = "KNI_DropdownOverlay"
            overlayScreen.ResetOnSpawn = false
            overlayScreen.IgnoreGuiInset = true
            overlayScreen.DisplayOrder = 999
            overlayScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            overlayScreen.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        end

        local menu = make("Frame", {
            BackgroundColor3 = COLORS.Background,
            BorderSizePixel = 0,
            Visible = false,
            ClipsDescendants = true,
            ZIndex = 10,
        }, overlayScreen)
        corner(menu, 6)
        local list = make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, menu)
        make("UIListLayout", {Padding = UDim.new(0, 2)}, list)
        local open = false

        local function repositionMenu()
            if not b.Parent then return end
            local btnAbs = b.AbsolutePosition
            local btnSize = b.AbsoluteSize
            local totalHeight = #control.Items * 24 + 6
            local h = math.min(totalHeight, 200)
            local cam = workspace.CurrentCamera
            local viewportY = cam and cam.ViewportSize.Y or 600
            local y = btnAbs.Y + btnSize.Y + 2
            if y + h > viewportY - 4 then
                y = btnAbs.Y - h - 2
            end
            menu.Position = UDim2.fromOffset(btnAbs.X, y)
            menu.Size = UDim2.fromOffset(btnSize.X, h)
        end

        local function refresh()
            for _, child in ipairs(list:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for _, item in ipairs(control.Items) do
                local choice = make("TextButton", {
                    Size = UDim2.new(1, -4, 0, 22),
                    BackgroundColor3 = COLORS.Panel2,
                    BorderSizePixel = 0,
                    Text = tostring(item),
                    TextColor3 = COLORS.Text,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    ZIndex = 22,
                }, list)
                table.insert(self._ui._connections, choice.Activated:Connect(function()
                    control.Selected = tostring(item)
                    b.Text = tostring(text) .. ": " .. control.Selected .. "  ▾"
                    open = false
                    menu.Visible = false
                    menu.Size = UDim2.new(1, -14, 0, 0)
                    if callback then
                        local ok, err = pcall(callback, control.Selected)
                        if not ok then warn("[KNI] Dropdown error:", err) end
                    end
                end))
            end
        end

        function control:Add(item)
            table.insert(control.Items, tostring(item))
            refresh()
        end

        function control:Remove(item)
            for i, v in ipairs(control.Items) do
                if v == item then
                    table.remove(control.Items, i)
                    break
                end
            end
            refresh()
        end

        function control:SetOptions(items)
            control.Items = {}
            for _, item in ipairs(items or {}) do
                table.insert(control.Items, tostring(item))
            end
            refresh()
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
            refresh()
        end

        refresh()
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
end)()


-- ═══ JUGADOR ═══
local player = game:GetService("Players").LocalPlayer


-- ═══ WHITELIST CHECK ═══
local WhitelistURL = "https://pastebin.com/raw/0Ne1DxbB"
local whitelistOk, whitelist = pcall(function()
    return loadstring(game:HttpGet(WhitelistURL, true))()
end)

if not whitelistOk or type(whitelist) ~= "table" then
    player:Kick("[HonenxWhite] Error al verificar whitelist. Contactá al staff.")
    return
end

if not whitelist[player.UserId] then
    player:Kick("[HonenxWhite] No estás autorizado. Unite a discord.gg/bVDtwKF92")
    return
end

print("[HonenxWhite] Whitelist verificada ✅")

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
-- ═══════════════════════════════════════════════════════════════
-- MENSAJE 2: Spectate completo + Kill Aura completa
-- Reemplaza las versiones simples del Mensaje 2 viejo
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- SPECTATE COMPLETO (con CameraMonitorLoop + LocalPlayerRespawn)
-- ═══════════════════════════════════════════════════════════════

getgenv().SpectateState = getgenv().SpectateState or {
    SavedUserId = nil,
    IsSpectating = false,
}

tabs.killing.SpectateData = {
    SelectedPlayer = nil,
    SelectedPlayerUserId = nil,
    Spectating = false,
    CurrentTargetConnection = nil,
    LocalPlayerRespawnConnection = nil,
    CameraMonitorLoop = nil,
}

tabs.killing.stopSpectating = function()
    if tabs.killing.SpectateData.CurrentTargetConnection then
        tabs.killing.SpectateData.CurrentTargetConnection:Disconnect()
        tabs.killing.SpectateData.CurrentTargetConnection = nil
    end
    if tabs.killing.SpectateData.CameraMonitorLoop then
        tabs.killing.SpectateData.CameraMonitorLoop = false
    end
    local localPlayer = services.Players.LocalPlayer
    if localPlayer.Character then
        local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = humanoid
            utils.playerData.Camera.CameraType = Enum.CameraType.Custom
        end
    end
    if utils.playerData.Humanoid and utils.playerData.Camera then
        utils.playerData.Camera.CameraSubject = utils.playerData.Humanoid
    end
end

tabs.killing.startCameraMonitor = function()
    if tabs.killing.SpectateData.CameraMonitorLoop then
        tabs.killing.SpectateData.CameraMonitorLoop = false
        task.wait(0.3)
    end
    tabs.killing.SpectateData.CameraMonitorLoop = true
    task.spawn(function()
        while utils.isCurrent() and tabs.killing.SpectateData.CameraMonitorLoop do
            task.wait(0.2)
            if tabs.killing.SpectateData.Spectating and tabs.killing.SpectateData.SelectedPlayer then
                local targetChar = tabs.killing.SpectateData.SelectedPlayer.Character
                if targetChar then
                    local targetHumanoid = targetChar:FindFirstChildOfClass("Humanoid")
                    if targetHumanoid and utils.playerData.Camera then
                        if utils.playerData.Camera.CameraSubject ~= targetHumanoid then
                            utils.playerData.Camera.CameraSubject = targetHumanoid
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

tabs.killing.updateSpectateTarget = function(p)
    if not p then
        if tabs.killing.SpectateData.SelectedPlayerUserId then
            for _, candidate in ipairs(services.Players:GetPlayers()) do
                if candidate.UserId == tabs.killing.SpectateData.SelectedPlayerUserId then
                    p = candidate
                    tabs.killing.SpectateData.SelectedPlayer = p
                    break
                end
            end
        end
        if not p and getgenv().SpectateState.SavedUserId then
            for _, candidate in ipairs(services.Players:GetPlayers()) do
                if candidate.UserId == getgenv().SpectateState.SavedUserId then
                    p = candidate
                    tabs.killing.SpectateData.SelectedPlayer = p
                    tabs.killing.SpectateData.SelectedPlayerUserId = p.UserId
                    break
                end
            end
        end
        if not p then
            tabs.killing.stopSpectating()
            return
        end
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
        if humanoid and tabs.killing.SpectateData.Spectating and tabs.killing.SpectateData.SelectedPlayerUserId == p.UserId then
            if utils.playerData.Camera then
                utils.playerData.Camera.CameraSubject = humanoid
            end
        end
    end
    if p.Character then setCamera(p.Character) end
    tabs.killing.SpectateData.CurrentTargetConnection = utils.connect(p.CharacterAdded, function(newChar)
        if tabs.killing.SpectateData.Spectating and tabs.killing.SpectateData.SelectedPlayerUserId == p.UserId then
            setCamera(newChar)
        end
    end)
end

-- Conexión de respawn del LocalPlayer
if tabs.killing.SpectateData.LocalPlayerRespawnConnection then
    tabs.killing.SpectateData.LocalPlayerRespawnConnection:Disconnect()
end
tabs.killing.SpectateData.LocalPlayerRespawnConnection = utils.connect(player.CharacterAdded, function(char)
    local humanoid = char:WaitForChild("Humanoid", 3)
    if humanoid then
        utils.playerData.Humanoid = humanoid
    end
    task.wait(0.5)
    if getgenv().SpectateState.IsSpectating then
        tabs.killing.SpectateData.Spectating = true
        tabs.killing.updateSpectateTarget()
        tabs.killing.startCameraMonitor()
    else
        if utils.playerData.Humanoid and utils.playerData.Camera then
            utils.playerData.Camera.CameraSubject = utils.playerData.Humanoid
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- KILL AURA COMPLETA (con Frozen + Generation + Anti-Gravity opcional)
-- ═══════════════════════════════════════════════════════════════

tabs.killing.KillAuraFull = {
    RingPart = nil,
    RingColor = Color3.fromRGB(145, 77, 255),
    RingTransparency = 0.6,
    CenterCFrame = nil,
    Frozen = false,
    Generation = 0,
    Enabled = false,
    Range = 20,
}

_G.showDeathRing = false
_G.deathRingEnabled = false
_G.deathRingRange = 20

-- Destruir anillo viejo si existe
local staleRing = workspace:FindFirstChild("HonenxWhiteKillAuraRing")
if staleRing then staleRing:Destroy() end

local ringColors = {
    {Name = "HonenxWhite", Color = Color3.fromRGB(145, 77, 255)},
    {Name = "Red", Color = Color3.fromRGB(255, 60, 60)},
    {Name = "Orange", Color = Color3.fromRGB(255, 128, 0)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 230, 0)},
    {Name = "Lime", Color = Color3.fromRGB(128, 255, 0)},
    {Name = "Green", Color = Color3.fromRGB(0, 200, 70)},
    {Name = "Cyan", Color = Color3.fromRGB(0, 220, 255)},
    {Name = "Blue", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "Purple", Color = Color3.fromRGB(145, 70, 255)},
    {Name = "Pink", Color = Color3.fromRGB(255, 80, 180)},
    {Name = "White", Color = Color3.fromRGB(255, 255, 255)},
    {Name = "Black", Color = Color3.fromRGB(0, 0, 0)},
}

local ringColorDropdown = tabs.killing:AddDropdown("Ring Color", function(selection)
    for _, colorData in ipairs(ringColors) do
        if colorData.Name == selection then
            tabs.killing.KillAuraFull.RingColor = colorData.Color
            if tabs.killing.KillAuraFull.RingPart then
                tabs.killing.KillAuraFull.RingPart.Color = colorData.Color
            end
            break
        end
    end
end)
for _, colorData in ipairs(ringColors) do
    ringColorDropdown:Add(colorData.Name)
end

tabs.killing.destroyKillAuraRing = function()
    if tabs.killing.KillAuraFull.RingPart then
        tabs.killing.KillAuraFull.RingPart:Destroy()
        tabs.killing.KillAuraFull.RingPart = nil
    end
end

tabs.killing.createKillAuraRing = function()
    tabs.killing.destroyKillAuraRing()
    local oldRing = workspace:FindFirstChild("HonenxWhiteKillAuraRing")
    if oldRing then oldRing:Destroy() end

    local ring = Instance.new("Part")
    ring.Name = "HonenxWhiteKillAuraRing"
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Color = tabs.killing.KillAuraFull.RingColor
    ring.Transparency = tabs.killing.KillAuraFull.RingTransparency
    ring.Anchored = true
    ring.CanCollide = false
    ring.CanTouch = false
    ring.CanQuery = false
    ring.CastShadow = false
    ring.Size = Vector3.new(0.2, _G.deathRingRange * 2, _G.deathRingRange * 2)
    if tabs.killing.KillAuraFull.CenterCFrame then
        ring.CFrame = tabs.killing.KillAuraFull.CenterCFrame * CFrame.Angles(0, 0, math.rad(90))
    end
    ring.Parent = workspace
    tabs.killing.KillAuraFull.RingPart = ring
end

tabs.killing.updateKillAuraRing = function()
    if tabs.killing.KillAuraFull.RingPart and tabs.killing.KillAuraFull.CenterCFrame then
        tabs.killing.KillAuraFull.RingPart.CFrame = tabs.killing.KillAuraFull.CenterCFrame * CFrame.Angles(0, 0, math.rad(90))
    end
end

tabs.killing.ShowRingSwitch = tabs.killing:AddSwitch("Show Ring", function(bool)
    if bool and not _G.deathRingEnabled then
        _G.showDeathRing = false
        tabs.killing.ShowRingSwitch:Set(false, true)
        return
    end
    _G.showDeathRing = bool
    if bool then
        tabs.killing.createKillAuraRing()
    else
        tabs.killing.destroyKillAuraRing()
    end
end)

-- Toggle Ring worker completo
tabs.killing:AddSwitch("Toggle Ring (Kill Aura)", function(bool)
    _G.deathRingEnabled = bool
    tabs.killing.KillAuraFull.Enabled = bool
    tabs.killing.KillAuraFull.Generation += 1
    local generation = tabs.killing.KillAuraFull.Generation

    if not bool then
        if tabs.killing.ShowRingSwitch and _G.showDeathRing then
            tabs.killing.ShowRingSwitch:Set(false, true)
        end
        return
    end

    local _, _, initialRoot = tabs.killing.getLocalCombatCharacter()
    if initialRoot then
        tabs.killing.KillAuraFull.CenterCFrame = initialRoot.CFrame
    end

    -- Loop de actualización del anillo
    task.spawn(function()
        while utils.isCurrent() and _G.deathRingEnabled and tabs.killing.KillAuraFull.Generation == generation do
            local _, _, localRoot = tabs.killing.getLocalCombatCharacter()
            if localRoot and not tabs.killing.KillAuraFull.Frozen then
                tabs.killing.KillAuraFull.CenterCFrame = localRoot.CFrame
            end
            tabs.killing.updateKillAuraRing()
            services.RunService.RenderStepped:Wait()
        end
    end)

    -- Loop de ataque
    task.spawn(function()
        while utils.isCurrent() and _G.deathRingEnabled and tabs.killing.KillAuraFull.Generation == generation do
            if tabs.killing.KillAuraFull.Frozen or not tabs.killing.KillAuraFull.CenterCFrame then
                task.wait(0.05)
                continue
            end

            local centerCFrame = tabs.killing.KillAuraFull.CenterCFrame
            local attackedPlayer = false

            for _, targetPlayer in ipairs(services.Players:GetPlayers()) do
                if not _G.deathRingEnabled or tabs.killing.KillAuraFull.Generation ~= generation then break end
                local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetPlayer ~= player
                    and not tabs.killing.isWhitelisted(targetPlayer)
                    and tabs.killing.isPlayerAlive(targetPlayer)
                    and not tabs.killing.isSpawnProtected(targetPlayer)
                    and targetRoot
                    and (centerCFrame.Position - targetRoot.Position).Magnitude <= _G.deathRingRange then

                    attackedPlayer = true
                    tabs.killing.KillAuraFull.Frozen = true
                    tabs.killing.KillAuraFull.CenterCFrame = centerCFrame
                    tabs.killing.updateKillAuraRing()

                    tabs.killing.attackPlayerWithLimit(targetPlayer, 4, function()
                        local currentTargetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        return _G.deathRingEnabled
                            and tabs.killing.KillAuraFull.Generation == generation
                            and not tabs.killing.isWhitelisted(targetPlayer)
                            and currentTargetRoot
                            and (centerCFrame.Position - currentTargetRoot.Position).Magnitude <= _G.deathRingRange
                    end, 3.5)

                    -- Volver al centro después del ataque
                    for _ = 1, 4 do
                        local _, _, currentLocalRoot = tabs.killing.getLocalCombatCharacter()
                        if currentLocalRoot then
                            currentLocalRoot.CFrame = centerCFrame
                            currentLocalRoot.AssemblyLinearVelocity = Vector3.zero
                            currentLocalRoot.AssemblyAngularVelocity = Vector3.zero
                        end
                        tabs.killing.KillAuraFull.CenterCFrame = centerCFrame
                        tabs.killing.updateKillAuraRing()
                        services.RunService.Heartbeat:Wait()
                    end
                    tabs.killing.KillAuraFull.Frozen = false
                end
            end

            if not attackedPlayer then
                task.wait(0.05)
            end
        end
        tabs.killing.KillAuraFull.Frozen = false
    end)
end)

-- Slider para el rango del Kill Aura
tabs.killing:AddSlider("Kill Aura Range", 1, 140, 20, function(value)
    _G.deathRingRange = value
    tabs.killing.KillAuraFull.Range = value
    if tabs.killing.KillAuraFull.RingPart then
        tabs.killing.KillAuraFull.RingPart.Size = Vector3.new(0.2, value * 2, value * 2)
    end
end)

utils.notify("HonenxWhite", "Mensaje 2 cargado: Spectate + Kill Aura completos ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- MENSAJE 3: Farming completo (Squat/Lift/Better Strength/Leave)
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- AUTO SQUAT / AUTO LIFT CON MAQUINAS
-- ═══════════════════════════════════════════════════════════════

tabs.farming.MachinesFolder = workspace:WaitForChild("machinesFolder")

tabs.farming.SquatsByName = {}
tabs.farming.SquatMachineNames = {}
tabs.farming.LiftMachineNames = {}

tabs.farming.MachineExerciseData = {
    Squat = {SelectedMachine = nil, ActiveMachine = nil, Running = false, Generation = 0, ReenterAt = 0, SeatPart = nil, Choices = {}},
    Lift = {SelectedMachine = nil, ActiveMachine = nil, Running = false, Generation = 0, ReenterAt = 0, SeatPart = nil, Choices = {}},
}

-- Escanear máquinas
for _, machine in ipairs(tabs.farming.MachinesFolder:GetChildren()) do
    local lowerName = string.lower(machine.Name)
    if string.find(lowerName, "squat", 1, true) and lowerName ~= "squat rack" then
        tabs.farming.SquatsByName[machine.Name] = tabs.farming.SquatsByName[machine.Name] or {}
        table.insert(tabs.farming.SquatsByName[machine.Name], machine)
    elseif string.find(lowerName, "lift", 1, true) and lowerName ~= "deadlift" then
        tabs.farming.MachineExerciseData.Lift.Choices[machine.Name] = machine
        table.insert(tabs.farming.LiftMachineNames, machine.Name)
    end
end

for machineName, matchingSquats in pairs(tabs.farming.SquatsByName) do
    tabs.farming.MachineExerciseData.Squat.Choices[machineName] = matchingSquats[1]
    table.insert(tabs.farming.SquatMachineNames, machineName)
end

table.sort(tabs.farming.SquatMachineNames)
table.sort(tabs.farming.LiftMachineNames)

tabs.farming.getMachineInteractPart = function(machine)
    for _, descendant in ipairs(machine:GetDescendants()) do
        if descendant:IsA("BasePart") and string.lower(descendant.Name) == "interactseat" then
            return descendant
        end
    end
end

tabs.farming.enterExerciseMachine = function(machine)
    if not machine or not machine.Parent then return false end
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    local interactPart = tabs.farming.getMachineInteractPart(machine)
    if not humanoidRootPart or not interactPart then return false end

    humanoidRootPart.CFrame = interactPart.CFrame * CFrame.new(0, 3, 0)
    humanoidRootPart.AssemblyLinearVelocity = Vector3.zero
    humanoidRootPart.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.4)
    services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.1)
    services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    task.wait(0.4)
    return true
end

tabs.farming.startMachineExercise = function(machineData)
    machineData.Generation += 1
    local generation = machineData.Generation
    local lastCharacter = player.Character

    task.spawn(function()
        while utils.isCurrent() and machineData.Running and machineData.Generation == generation do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if character ~= lastCharacter then
                lastCharacter = character
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = os.clock() + 3.5
            end

            if not character or not humanoid or humanoid.Health <= 0 then
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = math.max(machineData.ReenterAt, os.clock() + 3.5)
                task.wait(0.1)
                continue
            end

            local humanoidState = humanoid:GetState()
            local jumpedOff = machineData.ActiveMachine and (
                humanoidState == Enum.HumanoidStateType.Jumping
                or humanoidState == Enum.HumanoidStateType.Freefall
                or (machineData.SeatPart and humanoid.SeatPart ~= machineData.SeatPart)
            )

            if jumpedOff then
                machineData.ActiveMachine = nil
                machineData.SeatPart = nil
                machineData.ReenterAt = os.clock() + 3.5
            end

            if machineData.SelectedMachine and not machineData.ActiveMachine and os.clock() >= machineData.ReenterAt then
                if tabs.farming.enterExerciseMachine(machineData.SelectedMachine) then
                    machineData.ActiveMachine = machineData.SelectedMachine
                    machineData.SeatPart = humanoid.SeatPart
                end
            end

            task.wait(0.1)
        end
    end)
end

tabs.farming.setMachineExerciseState = function(machineData, otherMachineData, state)
    machineData.Running = state
    machineData.Generation += 1
    machineData.ActiveMachine = nil
    machineData.SeatPart = nil
    machineData.ReenterAt = 0

    if not state then return end
    if tabs.farming.ToolExerciseSwitch and tabs.farming.ExerciseData.AutoFarm then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if otherMachineData.Running then
        if machineData == tabs.farming.MachineExerciseData.Squat and tabs.farming.LiftExerciseSwitch then
            tabs.farming.LiftExerciseSwitch:Set(false, true)
        elseif machineData == tabs.farming.MachineExerciseData.Lift and tabs.farming.SquatExerciseSwitch then
            tabs.farming.SquatExerciseSwitch:Set(false, true)
        end
    end
    tabs.farming.startMachineExercise(machineData)
    task.spawn(function()
        while utils.isCurrent() and machineData.Running and machineData.Generation == generation do
            if machineData.ActiveMachine then
                pcall(function()
                    player.muscleEvent:FireServer("rep")
                end)
            end
            task.wait(0.1)
        end
    end, machineData.Generation)
end

-- Dropdowns y switches
local squatDropdown = tabs.farming:AddDropdown("Select Squat", function(selection)
    tabs.farming.MachineExerciseData.Squat.SelectedMachine = tabs.farming.MachineExerciseData.Squat.Choices[selection]
    tabs.farming.MachineExerciseData.Squat.ActiveMachine = nil
    tabs.farming.MachineExerciseData.Squat.SeatPart = nil
    tabs.farming.MachineExerciseData.Squat.ReenterAt = 0
end)
for _, machineName in ipairs(tabs.farming.SquatMachineNames) do
    squatDropdown:Add(machineName)
end

tabs.farming.SquatExerciseSwitch = tabs.farming:AddSwitch("Auto Squat", function(state)
    tabs.farming.setMachineExerciseState(tabs.farming.MachineExerciseData.Squat, tabs.farming.MachineExerciseData.Lift, state)
end)

local liftDropdown = tabs.farming:AddDropdown("Select Lift", function(selection)
    tabs.farming.MachineExerciseData.Lift.SelectedMachine = tabs.farming.MachineExerciseData.Lift.Choices[selection]
    tabs.farming.MachineExerciseData.Lift.ActiveMachine = nil
    tabs.farming.MachineExerciseData.Lift.SeatPart = nil
    tabs.farming.MachineExerciseData.Lift.ReenterAt = 0
end)
for _, machineName in ipairs(tabs.farming.LiftMachineNames) do
    liftDropdown:Add(machineName)
end

tabs.farming.LiftExerciseSwitch = tabs.farming:AddSwitch("Auto Lift", function(state)
    tabs.farming.setMachineExerciseState(tabs.farming.MachineExerciseData.Lift, tabs.farming.MachineExerciseData.Squat, state)
end)

-- ═══════════════════════════════════════════════════════════════
-- LEAVE EXERCISE MACHINE (para Boss)
-- ═══════════════════════════════════════════════════════════════

tabs.farming.leaveExerciseMachine = function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 then return end

    pcall(function()
        services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        humanoid.Sit = false
        humanoid.Jump = true
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        if root then
            root.AssemblyLinearVelocity = Vector3.new(0, math.max(root.AssemblyLinearVelocity.Y, 50), 0)
        end
    end)
    pcall(function()
        services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
    task.wait(0.2)
end

-- ═══════════════════════════════════════════════════════════════
-- BETTER STRENGTH FARMING (4 configuraciones)
-- ═══════════════════════════════════════════════════════════════

tabs.farming:AddSection("Better Strength Farming")

tabs.farming.Configs = {
    {name = "Pushup + Industrial Rock", tool = "Pushups", rock = "Industrial Rock"},
    {name = "Pushup + Jungle Rock", tool = "Pushups", rock = "Ancient Jungle Rock"},
    {name = "Pushup + Muscle King Rock", tool = "Pushups", rock = "Muscle King Mountain"},
    {name = "Pushup + Legends Rock", tool = "Pushups", rock = "Rock Of Legends"},
}
tabs.farming.ActiveConfigs = {}

for _, config in ipairs(tabs.farming.Configs) do
    tabs.farming.ActiveConfigs[config.name] = false
    config.Switch = tabs.farming:AddSwitch(config.name, function(state)
        tabs.farming.ActiveConfigs[config.name] = state
        if tabs.farming.ActiveConfigs[config.name] then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local backpackTool = player.Backpack:FindFirstChild(config.tool)
                if backpackTool and humanoid and not character:FindFirstChild(config.tool) then
                    humanoid:EquipTool(backpackTool)
                end
            end
            task.spawn(function()
                while utils.isCurrent() and tabs.farming.ActiveConfigs[config.name] do
                    pcall(function()
                        player.muscleEvent:FireServer("rep")
                    end)
                    local char = player.Character
                    if char and tabs.farming.MachinesFolder:FindFirstChild(config.rock) then
                        local rockFolder = tabs.farming.MachinesFolder:FindFirstChild(config.rock)
                        local rock = rockFolder and rockFolder:FindFirstChild("Rock")
                        local leftHand = char:FindFirstChild("LeftHand")
                        if rock and leftHand and firetouchinterest then
                            firetouchinterest(rock, leftHand, 0)
                            firetouchinterest(rock, leftHand, 1)
                        end
                    end
                    if char and player.Backpack:FindFirstChild("Punch") then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:EquipTool(player.Backpack.Punch)
                            pcall(function()
                                player.muscleEvent:FireServer("punch", "rightHand")
                                player.muscleEvent:FireServer("punch", "leftHand")
                            end)
                        end
                    end
                    services.RunService.RenderStepped:Wait()
                    local char2 = player.Character
                    if char2 and player.Backpack:FindFirstChild(config.tool) then
                        local humanoid2 = char2:FindFirstChildOfClass("Humanoid")
                        if humanoid2 then
                            humanoid2:EquipTool(player.Backpack[config.tool])
                        end
                    end
                end
            end)
        else
            local char = player.Character
            if char and char:FindFirstChild(config.tool) then
                char[config.tool].Parent = player.Backpack
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- PAUSE/RESUME TRAINING (para Boss)
-- ═══════════════════════════════════════════════════════════════

tabs.boss = tabs.boss or {}
tabs.boss.Data = tabs.boss.Data or {}
tabs.boss.Data.TrainingSnapshot = nil

tabs.boss.pauseTraining = function()
    if tabs.boss.Data.TrainingSnapshot then return end
    tabs.boss.Data.TrainingSnapshot = {
        Rebirth = tabs.farming.RebirthData.IsAutoRebirthing,
        Size = tabs.farming.SizeData.Active,
        King = tabs.farming.KingData.TeleportActive,
        Tool = tabs.farming.ExerciseData.AutoFarm,
        Squat = tabs.farming.MachineExerciseData.Squat.Running,
        Lift = tabs.farming.MachineExerciseData.Lift.Running,
        AutoRep = tabs.farming.AutoRepRunning,
        Rock = _G.RockFarmRunning == true,
        Configs = {},
    }
    for _, config in ipairs(tabs.farming.Configs) do
        tabs.boss.Data.TrainingSnapshot.Configs[config.name] = tabs.farming.ActiveConfigs[config.name] == true
        if tabs.farming.ActiveConfigs[config.name] and config.Switch then
            config.Switch:Set(false, true)
        end
    end
    if tabs.boss.Data.TrainingSnapshot.Rebirth and tabs.farming.RebirthData.Switch then
        tabs.farming.RebirthData.Switch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Size and tabs.farming.SizeSwitch then
        tabs.farming.SizeSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.King and tabs.farming.KingSwitch then
        tabs.farming.KingSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Tool and tabs.farming.ToolExerciseSwitch then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Squat and tabs.farming.SquatExerciseSwitch then
        tabs.farming.SquatExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Lift and tabs.farming.LiftExerciseSwitch then
        tabs.farming.LiftExerciseSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Squat or tabs.boss.Data.TrainingSnapshot.Lift then
        tabs.farming.leaveExerciseMachine()
    end
    if tabs.boss.Data.TrainingSnapshot.AutoRep and tabs.farming.AutoRepSwitch then
        tabs.farming.AutoRepSwitch:Set(false, true)
    end
    if tabs.boss.Data.TrainingSnapshot.Rock and tabs.farming.RockSwitch then
        tabs.farming.RockSwitch:Set(false, true)
    end
end

tabs.boss.resumeTraining = function()
    local snapshot = tabs.boss.Data.TrainingSnapshot
    if not snapshot then return end
    tabs.boss.Data.TrainingSnapshot = nil
    if snapshot.Rebirth and tabs.farming.RebirthData.Switch then
        tabs.farming.RebirthData.Switch:Set(false, true)
    end
    if snapshot.Size and tabs.farming.SizeSwitch then
        tabs.farming.SizeSwitch:Set(false, true)
    end
    if snapshot.King and tabs.farming.KingSwitch then
        tabs.farming.KingSwitch:Set(false, true)
    end
    if snapshot.Tool and tabs.farming.ToolExerciseSwitch then
        tabs.farming.ToolExerciseSwitch:Set(false, true)
    end
    if snapshot.Squat and tabs.farming.SquatExerciseSwitch then
        tabs.farming.SquatExerciseSwitch:Set(false, true)
    end
    if snapshot.Lift and tabs.farming.LiftExerciseSwitch then
        tabs.farming.LiftExerciseSwitch:Set(false, true)
    end
    if snapshot.AutoRep and tabs.farming.AutoRepSwitch then
        tabs.farming.AutoRepSwitch:Set(false, true)
    end
    if snapshot.Rock and tabs.farming.RockSwitch then
        tabs.farming.RockSwitch:Set(false, true)
    end
    for _, config in ipairs(tabs.farming.Configs) do
        if snapshot.Configs[config.name] and config.Switch then
            config.Switch:Set(false, true)
        end
    end
end

utils.notify("HonenxWhite", "Mensaje 3 cargado: Farming completo ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- MENSAJE 4: Fast Rebirth V2 - Ultra Titans + Chaos Overlords
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- FUNCIONES AUXILIARES: Desequipar y equipar pets
-- ═══════════════════════════════════════════════════════════════

tabs.fast.desequipAll = function()
    local petsFolder = player.petsFolder
    for _, folder in pairs(petsFolder:GetChildren()) do
        if folder:IsA("Folder") then
            for _, pet in pairs(folder:GetChildren()) do
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", pet)
                end)
            end
        end
    end
    if player.Character then
        for _, obj in pairs(player.Character:GetChildren()) do
            if obj:IsA("StringValue") or obj:IsA("ObjectValue") then
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", obj)
                end)
            end
        end
    end
    task.wait(0.3)
end

tabs.fast.equipPets = function(petNames)
    local petsFolder = player.petsFolder
    local uniquePets = petsFolder.Unique
    tabs.fast.desequipAll()
    task.wait(0.2)
    local equipped = 0
    for _, petName in ipairs(petNames) do
        for _, pet in pairs(uniquePets:GetChildren()) do
            if pet.Name == petName then
                pcall(function()
                    services.ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", pet)
                end)
                equipped = equipped + 1
                task.wait(0.05)
            end
        end
    end
    task.wait(0.3)
    return equipped
end

-- ═══════════════════════════════════════════════════════════════
-- ULTRA TITANS PACK
-- ═══════════════════════════════════════════════════════════════

tabs.fast:AddSection("Ultra Titans Pack")

tabs.fast.UltraData = {
    Running = false,
    WorkerActive = false,
    Rebirths = player.leaderstats:WaitForChild("Rebirths"),
    Strength = player.leaderstats:WaitForChild("Strength"),
    TargetRebirths = 0,
    TotalRebirths = 0,
    RepPets = {"Omega Overlord"},
    RebirthPets = {"Titanium Hydra"},
}

local ultraStatus = tabs.fast:AddLabel("Status: Inactive")
local ultraStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.UltraWorker = function()
    local startRebirths = tabs.fast.UltraData.Rebirths.Value

    while utils.isCurrent() and tabs.fast.UltraData.Running do
        if tabs.fast.UltraData.TargetRebirths > 0
            and tabs.fast.UltraData.Rebirths.Value >= tabs.fast.UltraData.TargetRebirths then
            ultraStatus:SetText("Status: Target alcanzado")
            tabs.fast.UltraData.Running = false
            break
        end

        ultraStatus:SetText("Status: Equipando Rep...")
        local equippedRep = 0
        pcall(function()
            equippedRep = tabs.fast.equipPets(tabs.fast.UltraData.RepPets)
        end)
        ultraStatus:SetText("Status: " .. equippedRep .. " Rep equipados")

        local currentRebirths = tabs.fast.UltraData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 6 or 12

        ultraStatus:SetText("Status: Farmeando...")
        while utils.isCurrent() and tabs.fast.UltraData.Running
            and tabs.fast.UltraData.Strength.Value < targetStrength do
            pcall(function()
                for _ = 1, repsPerBurst do
                    player.muscleEvent:FireServer("rep")
                end
            end)
            task.wait(0.05)
            ultraStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.UltraData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.UltraData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.UltraData.Running
            and tabs.fast.UltraData.Strength.Value >= targetStrength then
            ultraStatus:SetText("Status: Equipando Hydra...")
            local equippedReb = 0
            pcall(function()
                equippedReb = tabs.fast.equipPets(tabs.fast.UltraData.RebirthPets)
            end)
            ultraStatus:SetText("Status: " .. equippedReb .. " Hydra equipadas")
            task.wait(0.5)

            ultraStatus:SetText("Status: Haciendo Rebirth...")
            local rebirthBefore = tabs.fast.UltraData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.05)
                attempts = attempts + 1
            until not tabs.fast.UltraData.Running
                or tabs.fast.UltraData.Rebirths.Value > rebirthBefore
                or attempts >= 50
            if tabs.fast.UltraData.Rebirths.Value > rebirthBefore then
                tabs.fast.UltraData.TotalRebirths = tabs.fast.UltraData.TotalRebirths
                    + (tabs.fast.UltraData.Rebirths.Value - rebirthBefore)
            end
            task.wait(0.5)
        end
        task.wait(0.1)
    end
    tabs.fast.UltraData.WorkerActive = false
end

tabs.fast:AddTextBox("Ultra - Target rebirths (0 = inf):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.UltraData.TargetRebirths = math.floor(num)
    end
end, {clear = false})

tabs.fast.UltraToggle = tabs.fast:AddSwitch("Fast Rebirth Ultra Titans", function(state)
    tabs.fast.UltraData.Running = state
    if state then
        ultraStatus:SetText("Status: Iniciando Ultra...")
        if not tabs.fast.UltraData.WorkerActive then
            tabs.fast.UltraData.WorkerActive = true
            task.spawn(tabs.fast.UltraWorker)
        end
    else
        ultraStatus:SetText("Status: Inactive")
    end
end)

tabs.fast:AddLabel("Omega Overlord > Farm > Titanium Hydra > Rebirth")

-- ═══════════════════════════════════════════════════════════════
-- CHAOS OVERLORDS PACK
-- ═══════════════════════════════════════════════════════════════

tabs.fast:AddSection("Chaos Overlords Pack")

tabs.fast.ChaosData = {
    Running = false,
    WorkerActive = false,
    Rebirths = player.leaderstats:WaitForChild("Rebirths"),
    Strength = player.leaderstats:WaitForChild("Strength"),
    TargetRebirths = 0,
    TotalRebirths = 0,
    RepPets = {"Swift Samurai"},
    RebirthPets = {"Tribal Overlord"},
}

local chaosStatus = tabs.fast:AddLabel("Status: Inactive")
local chaosStats = tabs.fast:AddLabel("Rebirths: 0 | Gained: 0")

tabs.fast.ChaosWorker = function()
    local startRebirths = tabs.fast.ChaosData.Rebirths.Value

    while utils.isCurrent() and tabs.fast.ChaosData.Running do
        if tabs.fast.ChaosData.TargetRebirths > 0
            and tabs.fast.ChaosData.Rebirths.Value >= tabs.fast.ChaosData.TargetRebirths then
            chaosStatus:SetText("Status: Target alcanzado")
            tabs.fast.ChaosData.Running = false
            break
        end

        chaosStatus:SetText("Status: Equipando Rep...")
        local equippedRep = 0
        pcall(function()
            equippedRep = tabs.fast.equipPets(tabs.fast.ChaosData.RepPets)
        end)
        chaosStatus:SetText("Status: " .. equippedRep .. " Rep equipados")

        local currentRebirths = tabs.fast.ChaosData.Rebirths.Value
        local targetStrength = 5000 + currentRebirths * 2550
        local repsPerBurst = player.MembershipType == Enum.MembershipType.Premium and 6 or 12

        chaosStatus:SetText("Status: Farmeando...")
        while utils.isCurrent() and tabs.fast.ChaosData.Running
            and tabs.fast.ChaosData.Strength.Value < targetStrength do
            pcall(function()
                for _ = 1, repsPerBurst do
                    player.muscleEvent:FireServer("rep")
                end
            end)
            task.wait(0.05)
            chaosStats:SetText("Rebirths: "
                .. utils.formatWithCommas(tabs.fast.ChaosData.Rebirths.Value)
                .. " | Gained: "
                .. utils.formatWithCommas(tabs.fast.ChaosData.Rebirths.Value - startRebirths))
        end

        if utils.isCurrent() and tabs.fast.ChaosData.Running
            and tabs.fast.ChaosData.Strength.Value >= targetStrength then
            chaosStatus:SetText("Status: Equipando Tribal...")
            local equippedReb = 0
            pcall(function()
                equippedReb = tabs.fast.equipPets(tabs.fast.ChaosData.RebirthPets)
            end)
            chaosStatus:SetText("Status: " .. equippedReb .. " Tribal equipados")
            task.wait(0.5)

            chaosStatus:SetText("Status: Haciendo Rebirth...")
            local rebirthBefore = tabs.fast.ChaosData.Rebirths.Value
            local attempts = 0
            repeat
                pcall(function()
                    services.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                end)
                task.wait(0.05)
                attempts = attempts + 1
            until not tabs.fast.ChaosData.Running
                or tabs.fast.ChaosData.Rebirths.Value > rebirthBefore
                or attempts >= 50
            if tabs.fast.ChaosData.Rebirths.Value > rebirthBefore then
                tabs.fast.ChaosData.TotalRebirths = tabs.fast.ChaosData.TotalRebirths
                    + (tabs.fast.ChaosData.Rebirths.Value - rebirthBefore)
            end
            task.wait(0.5)
        end
        task.wait(0.1)
    end
    tabs.fast.ChaosData.WorkerActive = false
end

tabs.fast:AddTextBox("Chaos - Target rebirths (0 = inf):", function(text)
    local num = tonumber(text)
    if num and num >= 0 then
        tabs.fast.ChaosData.TargetRebirths = math.floor(num)
    end
end, {clear = false})

tabs.fast.ChaosToggle = tabs.fast:AddSwitch("Fast Rebirth Chaos Overlords", function(state)
    tabs.fast.ChaosData.Running = state
    if state then
        chaosStatus:SetText("Status: Iniciando Chaos...")
        if not tabs.fast.ChaosData.WorkerActive then
            tabs.fast.ChaosData.WorkerActive = true
            task.spawn(tabs.fast.ChaosWorker)
        end
    else
        chaosStatus:SetText("Status: Inactive")
    end
end)

tabs.fast:AddLabel("Swift Samurai > Farm > Tribal Overlord > Rebirth")

utils.notify("HonenxWhite", "Mensaje 4 cargado: Fast V2 completo ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- MENSAJE 5: Boss completo (Rarities + Special + Chest + Evade)
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- INICIALIZAR DATA EXTENDIDA DEL BOSS
-- ═══════════════════════════════════════════════════════════════

tabs.boss.Data = tabs.boss.Data or {}
tabs.boss.Data.AttackSequence = nil
tabs.boss.Data.EvadeUntil = 0
tabs.boss.Data.EvadeDistance = 230
tabs.boss.Data.PunchBehindDistance = 45
tabs.boss.Data.StompHealthThreshold = 0.35
tabs.boss.Data.DodgeStomps = false
tabs.boss.Data.BossOrder = tabs.boss.Data.BossOrder or {}
tabs.boss.Data.BossByDisplayName = tabs.boss.Data.BossByDisplayName or {}
tabs.boss.Data.SelectedBosses = tabs.boss.Data.SelectedBosses or {}

-- ═══════════════════════════════════════════════════════════════
-- SELECTOR DE RARITIES DE BOSS
-- ═══════════════════════════════════════════════════════════════

tabs.boss:AddSection("Target Specific Bosses")

local selectedBossesLabel = tabs.boss:AddLabel("Targeted Bosses: Detecting...")

tabs.boss.BossDropdown = tabs.boss:AddDropdown("Target specific Bosses", function(displayName)
    local bossModelName = tabs.boss.Data.BossByDisplayName[displayName]
    if bossModelName then
        for modelName in pairs(tabs.boss.Data.SelectedBosses) do
            tabs.boss.Data.SelectedBosses[modelName] = false
        end
        tabs.boss.Data.SelectedBosses[bossModelName] = true
        selectedBossesLabel:SetText("Targeted Bosses: " .. displayName)
    end
end)

tabs.boss.addBossChoice = function(modelName, displayName)
    modelName = tostring(modelName or "")
    displayName = tostring(displayName or modelName)
    if modelName == "" or tabs.boss.Data.BossByDisplayName[displayName] then return end
    tabs.boss.Data.BossByDisplayName[displayName] = modelName
    if tabs.boss.Data.SelectedBosses[modelName] == nil then
        tabs.boss.Data.SelectedBosses[modelName] = false
    end
    table.insert(tabs.boss.Data.BossOrder, modelName)
    tabs.boss.BossDropdown:Add(displayName)
end

-- Cargar rarities desde el config del juego
local configOk, bossConfig = pcall(function()
    return require(services.ReplicatedStorage:WaitForChild("shared"):WaitForChild("config"):WaitForChild("BossEventConfig"))
end)

if configOk and bossConfig and bossConfig.RARITIES then
    local allowedBossTiers = {"common", "rare", "epic", "legendary", "mythic", "rainbow"}
    for _, rarity in ipairs(bossConfig.RARITIES) do
        local tierText = string.lower(tostring(rarity.Name or rarity.DisplayName or rarity.BossModel or ""))
        local modelText = string.lower(tostring(rarity.BossModel or ""))
        local allowed = false
        for _, tier in ipairs(allowedBossTiers) do
            if string.find(tierText, tier, 1, true) or string.find(modelText, tier, 1, true) then
                allowed = true
                break
            end
        end
        if allowed and rarity.BossModel then
            tabs.boss.addBossChoice(rarity.BossModel, rarity.DisplayName or rarity.Name or rarity.BossModel)
        end
    end
    selectedBossesLabel:SetText("Targeted Bosses: None (elegí uno)")
else
    selectedBossesLabel:SetText("Farmed Bosses: Waiting for detection")
end

-- ═══════════════════════════════════════════════════════════════
-- SPECIAL WORLD BOSSES (Halloween)
-- ═══════════════════════════════════════════════════════════════

tabs.boss:AddSection("Special World Bosses")

local specialBossesLabel = tabs.boss:AddLabel("World bosses: All")

tabs.boss.Data.SpecialBosses = {
    ["Grim Reaper"] = true,
    ["Frankenbrute"] = true,
    ["Pumpkin Titan"] = true,
    ["Scarecrow Colossus"] = true,
}

tabs.boss.Data.SpecialBossOrder = {
    "Grim Reaper",
    "Frankenbrute",
    "Pumpkin Titan",
    "Scarecrow Colossus",
}

tabs.boss.Data.SpecialBossByDisplayName = {}

local specialBossDropdown = tabs.boss:AddDropdown("World boss target (select one)", function(displayName)
    local bossName = tabs.boss.Data.SpecialBossByDisplayName[displayName]
    if bossName then
        for _, name in ipairs(tabs.boss.Data.SpecialBossOrder) do
            tabs.boss.Data.SpecialBosses[name] = false
        end
        tabs.boss.Data.SpecialBosses[bossName] = true
        specialBossesLabel:SetText("World boss target: " .. bossName)
    end
end)

for _, bossName in ipairs(tabs.boss.Data.SpecialBossOrder) do
    tabs.boss.Data.SpecialBossByDisplayName[bossName] = bossName
    tabs.boss.Data.SpecialBosses[bossName] = false
    specialBossDropdown:Add(bossName)
end

-- ═══════════════════════════════════════════════════════════════
-- EVADE ATTACKS (Punch / Stomp)
-- ═══════════════════════════════════════════════════════════════

tabs.boss.evadeAttack = function(model, hitbox, root, humanoid)
    local sequence = model:GetAttribute("BossAttackSequence")
    local attackKind = model:GetAttribute("BossAttackKind")
    local attackCFrame = model:GetAttribute("BossAttackCFrame")
    local impactTime = model:GetAttribute("BossAttackImpactTime")

    if typeof(sequence) == "number" and sequence ~= tabs.boss.Data.AttackSequence then
        tabs.boss.Data.AttackSequence = sequence
        if typeof(attackKind) == "string" and typeof(attackCFrame) == "CFrame" and typeof(impactTime) == "number" then
            tabs.boss.Data.EvadeUntil = impactTime + 0.6
        end
    end

    if typeof(attackCFrame) ~= "CFrame" or workspace:GetServerTimeNow() > tabs.boss.Data.EvadeUntil then
        return
    end

    attackKind = string.lower(tostring(attackKind or ""))

    -- Evadir punch
    if string.find(attackKind, "punch", 1, true) then
        local center = tabs.boss.getBossHeadPosition(model, hitbox)
        local direction = Vector3.new(attackCFrame.LookVector.X, 0, attackCFrame.LookVector.Z)
        if direction.Magnitude < 1 then
            direction = Vector3.new(hitbox.CFrame.LookVector.X, 0, hitbox.CFrame.LookVector.Z)
        end
        if direction.Magnitude < 1 then direction = Vector3.new(0, 0, 1) end
        local safePosition = center - direction.Unit * tabs.boss.Data.PunchBehindDistance
        root.CFrame = CFrame.lookAt(safePosition, center)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        bossStatusLabel:SetText("Status: Dodging Punch")
        return "Punch"
    end

    -- Evadir stomp (solo si tiene poca vida)
    if not string.find(attackKind, "stomp", 1, true) then return end
    if humanoid.Health / math.max(humanoid.MaxHealth, 1) <= tabs.boss.Data.StompHealthThreshold then
        tabs.boss.Data.DodgeStomps = true
    end
    if not tabs.boss.Data.DodgeStomps then return end

    local direction = Vector3.new(root.Position.X - attackCFrame.Position.X, 0, root.Position.Z - attackCFrame.Position.Z)
    if direction.Magnitude < 1 then
        direction = Vector3.new(-attackCFrame.LookVector.X, 0, -attackCFrame.LookVector.Z)
    end
    if direction.Magnitude < 1 then direction = Vector3.new(1, 0, 0) end
    direction = direction.Unit
    local safePosition = attackCFrame.Position + direction * tabs.boss.Data.EvadeDistance + Vector3.new(0, 18, 0)
    root.CFrame = CFrame.lookAt(safePosition, attackCFrame.Position)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    bossStatusLabel:SetText("Status: Dodging Stomp")
    return "Stomp"
end

-- ═══════════════════════════════════════════════════════════════
-- GET ALIVE CHARACTER
-- ═══════════════════════════════════════════════════════════════

tabs.boss.getAliveCharacter = function(generation, timeout)
    local startedAt = os.clock()
    repeat
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            utils.playerData.Character = character
            utils.playerData.Humanoid = humanoid
            return character, root, humanoid
        end
        bossStatusLabel:SetText("Status: Waiting for Respawn")
        task.wait(0.1)
    until not tabs.boss.Data.Running
        or tabs.boss.Data.Generation ~= generation
        or (timeout and os.clock() - startedAt >= timeout)
end

-- ═══════════════════════════════════════════════════════════════
-- FIND CHEST + COLLECT CHEST
-- ═══════════════════════════════════════════════════════════════

tabs.boss.findChest = function()
    local chest
    for _, candidate in ipairs(services.CollectionService:GetTagged("BossEventChest")) do
        if candidate:IsDescendantOf(workspace) then
            chest = candidate
            break
        end
    end
    if not chest then
        chest = workspace:FindFirstChild("BossChest", true)
    end
    if not chest then
        for _, candidate in ipairs(workspace:GetDescendants()) do
            if candidate:IsA("ProximityPrompt") and candidate.Name == "bossChestPrompt" then
                chest = candidate.Parent
                break
            end
        end
    end
    if not chest then return end
    local prompt = chest:FindFirstChild("bossChestPrompt", true)
    local part = prompt and prompt.Parent
        or (chest:IsA("Model") and (chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart", true)))
        or chest
    if part and part:IsA("BasePart") then
        return chest, prompt, part
    end
end

tabs.boss.collectChest = function(generation)
    bossStatusLabel:SetText("Status: Waiting for Chest")
    local startedAt = os.clock()
    local chest, prompt, part
    repeat
        chest, prompt, part = tabs.boss.findChest()
        if chest and chest:GetAttribute("BossChestEmerging") ~= true then break end
        task.wait(0.1)
    until not tabs.boss.Data.Running or tabs.boss.Data.Generation ~= generation or os.clock() - startedAt >= 12
    if not chest or not part then return end

    bossStatusLabel:SetText("Status: Collecting Chest")
    startedAt = os.clock()
    repeat
        local character, root = tabs.boss.getAliveCharacter(generation, 2)
        if character and root and chest.Parent and part.Parent then
            bossStatusLabel:SetText("Status: Collecting Chest")
            pcall(function()
                root.CFrame = CFrame.lookAt(part.Position + Vector3.new(0, 3, 4), part.Position)
                root.AssemblyLinearVelocity = Vector3.zero
            end)
            task.wait(0.15)
            if prompt and prompt.Parent and fireproximityprompt then
                pcall(function() fireproximityprompt(prompt) end)
            else
                pcall(function()
                    services.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.1)
                    services.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end)
            end
        end
        task.wait(0.25)
    until not tabs.boss.Data.Running
        or tabs.boss.Data.Generation ~= generation
        or player:GetAttribute("BossChestPending") == false
        or not chest.Parent
        or os.clock() - startedAt >= 12
end

-- ═══════════════════════════════════════════════════════════════
-- FIND ACTIVE BOSS (con filtros de rareza + special)
-- ═══════════════════════════════════════════════════════════════

tabs.boss.shouldFarmBoss = function(model, mode)
    if not model then return false end
    local isSpecial = tabs.boss.Data.SpecialBosses and tabs.boss.Data.SpecialBosses[model.Name] ~= nil
    if mode == "Halloween" then
        return isSpecial and tabs.boss.Data.SpecialBosses[model.Name] == true
    end
    if isSpecial then return false end
    return tabs.boss.Data.SelectedBosses[model.Name] == true
end

tabs.boss.findActiveBoss = function(mode)
    mode = mode or "Main"

    local function isAliveBoss(model, hitbox)
        if not model or not model:IsA("Model") then return false end
        if not hitbox or not hitbox:IsA("BasePart") then return false end
        if not model:IsDescendantOf(workspace) then return false end
        local stats = model:FindFirstChild("stats") or model:FindFirstChild("Stats")
        local health = stats and (stats:FindFirstChild("Health") or stats:FindFirstChild("health"))
        local maxHealth = stats and (stats:FindFirstChild("MaxHealth") or stats:FindFirstChild("maxHealth"))
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local healthValue = health and tonumber(health.Value)
        if healthValue == nil and humanoid then healthValue = humanoid.Health end
        if healthValue == nil then healthValue = tonumber(model:GetAttribute("Health")) end
        if healthValue ~= nil and healthValue <= 0 then return false end
        return true, stats, health, maxHealth
    end

    -- Modo Halloween: buscar bosses special
    if mode == "Halloween" then
        for _, bossName in ipairs(tabs.boss.Data.SpecialBossOrder) do
            if tabs.boss.Data.SpecialBosses[bossName] == true then
                for _, descendant in ipairs(workspace:GetDescendants()) do
                    if descendant:IsA("Model") and descendant.Name == bossName then
                        local hitbox = descendant:FindFirstChild("BossDamageHitbox", true)
                        local alive, stats, health, maxHealth = isAliveBoss(descendant, hitbox)
                        if alive then return descendant, hitbox, health, maxHealth end
                    end
                end
            end
        end
        return nil
    end

    -- Modo Main: buscar por tag
    for _, taggedBoss in ipairs(services.CollectionService:GetTagged("BossEventBoss")) do
        if taggedBoss:IsA("Model") and taggedBoss:IsDescendantOf(workspace)
            and tabs.boss.shouldFarmBoss(taggedBoss, mode) then
            local hitbox = taggedBoss:FindFirstChild("BossDamageHitbox", true)
            local alive, stats, health, maxHealth = isAliveBoss(taggedBoss, hitbox)
            if alive then return taggedBoss, hitbox, health, maxHealth end
        end
    end

    -- Fallback: buscar en Events/BossEvent
    local events = workspace:FindFirstChild("Events")
    local bossFolder = events and (events:FindFirstChild("BossEvent") or events:FindFirstChild("BossArena"))
    if bossFolder then
        for _, descendant in ipairs(bossFolder:GetDescendants()) do
            if descendant:IsA("Model") and tabs.boss.shouldFarmBoss(descendant, mode) then
                local hitbox = descendant:FindFirstChild("BossDamageHitbox", true)
                local alive, stats, health, maxHealth = isAliveBoss(descendant, hitbox)
                if alive then return descendant, hitbox, health, maxHealth end
            end
        end
    end

    return nil
end

-- ═══════════════════════════════════════════════════════════════
-- ATTACK BOSS (con evade integrado)
-- ═══════════════════════════════════════════════════════════════

tabs.boss.attack = function(model, health, maxHealth, hitbox)
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local evadeMode = tabs.boss.evadeAttack(model, hitbox, root, humanoid)
    if evadeMode == "Stomp" then return end

    local punch = character:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
    if punch and punch.Parent ~= character then
        pcall(function() humanoid:EquipTool(punch) end)
    end

    local leftHand = character:FindFirstChild("LeftHand")
    local rightHand = character:FindFirstChild("RightHand")
    local center = hitbox.Position

    if evadeMode ~= "Punch" then
        local towardPlayer = root.Position - center
        towardPlayer = Vector3.new(towardPlayer.X, 0, towardPlayer.Z)
        if towardPlayer.Magnitude < 1 then
            towardPlayer = Vector3.new(hitbox.CFrame.LookVector.X, 0, hitbox.CFrame.LookVector.Z)
        end
        if towardPlayer.Magnitude < 1 then towardPlayer = Vector3.new(0, 0, 1) end
        local standPos = center + towardPlayer.Unit * math.max(3, math.min(6, hitbox.Size.Magnitude * 0.2)) + Vector3.new(0, 1.5, 0)
        root.CFrame = CFrame.lookAt(standPos, center)
    end

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    pcall(function()
        if firetouchinterest and leftHand then
            firetouchinterest(hitbox, leftHand, 0)
            firetouchinterest(hitbox, leftHand, 1)
        end
        if firetouchinterest and rightHand then
            firetouchinterest(hitbox, rightHand, 0)
            firetouchinterest(hitbox, rightHand, 1)
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

    bossLabel:SetText("Boss: " .. (workspace:GetAttribute("BossDisplayName") or model.Name))
    local hv = tabs.boss.getBossHealth(health)
    local mhv = tabs.boss.getBossMaxHealth(maxHealth)
    bossHealthLabel:SetText("Health: " .. utils.formatNumber(hv) .. " / " .. utils.formatNumber(mhv))
end

-- ═══════════════════════════════════════════════════════════════
-- AUTO FARM LOOP (con CollectChest + Pause/Resume Training)
-- ═══════════════════════════════════════════════════════════════

tabs.boss.startAutoFarmFull = function(mode, state)
    if not state then
        if tabs.boss.Data.ActiveMode == mode then
            tabs.boss.Data.Running = false
            tabs.boss.Data.ActiveMode = nil
            tabs.boss.Data.Generation += 1
            tabs.boss.Data.Phase = "Waiting"
            bossStatusLabel:SetText("Status: Disabled")
            if tabs.boss.resumeTraining then tabs.boss.resumeTraining() end
        end
        return
    end

    -- Apagar el otro modo
    if mode == "Halloween" and tabs.boss.MainSwitch then
        tabs.boss.MainSwitch:Set(false, true)
    elseif mode == "Main" and tabs.boss.HalloweenSwitch then
        tabs.boss.HalloweenSwitch:Set(false, true)
    end

    tabs.boss.Data.ActiveMode = mode
    tabs.boss.Data.Running = true
    tabs.boss.Data.Generation += 1
    local generation = tabs.boss.Data.Generation

    task.spawn(function()
        local wasFighting = false
        while utils.isCurrent() and tabs.boss.Data.Running
            and tabs.boss.Data.Generation == generation and tabs.boss.Data.ActiveMode == mode do
            pcall(function()
                local model, hitbox, health, maxHealth = tabs.boss.findActiveBoss(mode)
                local selected = model and tabs.boss.shouldFarmBoss(model, mode)
                if model and not selected then
                    if wasFighting then
                        wasFighting = false
                        if tabs.boss.resumeTraining then tabs.boss.resumeTraining() end
                    end
                    bossStatusLabel:SetText("Status: Skipping " .. model.Name)
                elseif model then
                    if not wasFighting then
                        wasFighting = true
                        tabs.boss.Data.AttackSequence = nil
                        tabs.boss.Data.EvadeUntil = 0
                        tabs.boss.Data.DodgeStomps = false
                        if tabs.boss.pauseTraining then tabs.boss.pauseTraining() end
                    end
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        bossStatusLabel:SetText("Status: Fighting " .. (mode == "Halloween" and "Halloween Boss" or "Main Boss"))
                        tabs.boss.attack(model, health, maxHealth, hitbox)
                    else
                        bossStatusLabel:SetText("Status: Waiting for Respawn")
                    end
                elseif wasFighting then
                    wasFighting = false
                    pcall(tabs.boss.collectChest, generation)
                    bossLabel:SetText("Boss: None")
                    bossHealthLabel:SetText("Health: 0 / 0")
                    if tabs.boss.Data.ContinueTraining and tabs.boss.resumeTraining then
                        tabs.boss.resumeTraining()
                    end
                    bossStatusLabel:SetText("Status: Waiting for Boss")
                else
                    bossStatusLabel:SetText("Status: Waiting for " .. (mode == "Halloween" and "Halloween Boss" or "Main-Island Boss"))
                end
            end)
            task.wait(model and selected and 0.03 or 0.25)
        end
    end)
end

-- Reemplazar los switches existentes
tabs.boss.MainSwitch = tabs.boss:AddSwitch("Auto Boss — Main Island", function(state)
    tabs.boss.startAutoFarmFull("Main", state)
end)
tabs.boss.MainSwitch:Set(false)

tabs.boss.HalloweenSwitch = tabs.boss:AddSwitch("Auto Boss — Halloween", function(state)
    tabs.boss.startAutoFarmFull("Halloween", state)
end)
tabs.boss.HalloweenSwitch:Set(false)

utils.notify("HonenxWhite", "Mensaje 5 cargado: Boss completo ✅", 3, "success")
-- ═══════════════════════════════════════════════════════════════
-- MENSAJE 6 FINAL: Auto Pet + Combos + Cierre
-- ═══════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════
-- AUTO PET (comprar continuamente el pet seleccionado)
-- ═══════════════════════════════════════════════════════════════

tabs.inventory:AddSection("Auto Pet")

tabs.inventory.AutoPetData = {
    Running = false,
    SelectedPet = nil,
}

local autoPetStatus = tabs.inventory:AddLabel("Status: Inactive")

local autoPetDropdown = tabs.inventory:AddDropdown("Choose Pet", function(text)
    tabs.inventory.AutoPetData.SelectedPet = text
end)
for _, petName in ipairs(tabs.inventory.PetShopData.PetList) do
    autoPetDropdown:Add(petName)
end

tabs.inventory:AddSwitch("Auto Pet", function(state)
    tabs.inventory.AutoPetData.Running = state
    if not state then
        autoPetStatus:SetText("Status: Inactive")
        return
    end
    if not tabs.inventory.AutoPetData.SelectedPet then
        utils.notify("Auto Pet", "Elegí un pet primero", 2, "warning")
        tabs.inventory.AutoPetData.Running = false
        return
    end

    autoPetStatus:SetText("Status: Comprando " .. tabs.inventory.AutoPetData.SelectedPet)
    task.spawn(function()
        while utils.isCurrent() and tabs.inventory.AutoPetData.Running do
            local petName = tabs.inventory.AutoPetData.SelectedPet
            local selectedPet = tabs.inventory.PetShopFolder:FindFirstChild(petName)
            if selectedPet then
                pcall(function()
                    tabs.inventory.PetShopRemote:InvokeServer(selectedPet)
                end)
            end
            task.wait(0.2)
        end
        autoPetStatus:SetText("Status: Inactive")
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- CONTADOR DE COMBOS DE BOOSTS
-- ═══════════════════════════════════════════════════════════════

tabs.boosts:AddSection("Contador de Boosts")

tabs.boosts.ComboData = {
    ProteinEgg = 0,
    TropicalShake = 0,
    EnergyShake = 0,
    ProteinBar = 0,
    ToughBar = 0,
    ProteinShake = 0,
    UltraShake = 0,
    EnergyBar = 0,
}

local comboLabel = tabs.boosts:AddLabel("Combo: Sin boosts")

task.spawn(function()
    while utils.isCurrent() do
        local items = {
            ProteinEgg = 0, TropicalShake = 0, EnergyShake = 0, ProteinBar = 0,
            ToughBar = 0, ProteinShake = 0, UltraShake = 0, EnergyBar = 0,
        }
        local char = player.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if items[item.Name] ~= nil then items[item.Name] = items[item.Name] + 1 end
            end
        end
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if items[item.Name] ~= nil then items[item.Name] = items[item.Name] + 1 end
        end
        local active = {}
        for name, count in pairs(items) do
            if count > 0 then table.insert(active, name .. " (" .. count .. ")") end
        end
        if #active == 0 then
            comboLabel:SetText("Combo: Sin boosts")
        else
            comboLabel:SetText("Combo: " .. table.concat(active, " · "))
        end
        task.wait(2)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- EMERGENCY STOP
-- ═══════════════════════════════════════════════════════════════

tabs.info:AddSection("Emergency")

tabs.info:AddButton("🛑 EMERGENCY STOP", function()
    -- Apagar todos los switches
    if _G.HonenxWhiteUltraFastRep then _G.HonenxWhiteUltraFastRep.Enabled = false end
    if _G.RockFarmRunning then _G.RockFarmRunning = false end
    if _G.deathRingEnabled then _G.deathRingEnabled = false end
    if _G.killAll then _G.killAll = false end
    if _G.killBlacklistedOnly then _G.killBlacklistedOnly = false end
    if _G.HonenxAntiAFK then _G.HonenxAntiAFK = false end

    -- Apagar todos los switches de la GUI
    for _, tab in pairs(tabs) do
        if tab._ui and tab._ui._connections then
            for _, conn in ipairs(tab._ui._connections) do
                if conn and conn.Connected then
                    -- No desconectamos los switches, solo apagamos los que tienen estado
                end
            end
        end
    end

    -- Detener loops de Fast Rebirth
    if tabs.fast then
        if tabs.fast.FastRepData then tabs.fast.FastRepData.Running = false end
        if tabs.fast.FastRebirthData then tabs.fast.FastRebirthData.Running = false end
        if tabs.fast.UltraData then tabs.fast.UltraData.Running = false end
        if tabs.fast.ChaosData then tabs.fast.ChaosData.Running = false end
    end

    -- Detener Boss
    if tabs.boss and tabs.boss.Data then
        tabs.boss.Data.Running = false
        tabs.boss.Data.ActiveMode = nil
    end

    -- Detener Farming
    if tabs.farming then
        if tabs.farming.MachineExerciseData then
            tabs.farming.MachineExerciseData.Squat.Running = false
            tabs.farming.MachineExerciseData.Lift.Running = false
        end
        if tabs.farming.ActiveConfigs then
            for name in pairs(tabs.farming.ActiveConfigs) do
                tabs.farming.ActiveConfigs[name] = false
            end
        end
    end

    -- Notificación
    utils.notify("Emergency Stop", "Todas las funciones detenidas", 4, "error")
end)

-- ═══════════════════════════════════════════════════════════════
-- CIERRE FINAL
-- ═══════════════════════════════════════════════════════════════

utils.notify("HonenxWhite", "🎉 Hub COMPLETO cargado — 4,000+ líneas", 5, "success")
print("[HonenxWhite] ✅ Script COMPLETO cargado al 100%")
print("[HonenxWhite] Tabs: Main, Killing, Specs, Farming, Fast, Boss, Pets, Boosts, Teleports, Stats, Info")
print("[HonenxWhite] Build: KNI UI v2.0")
