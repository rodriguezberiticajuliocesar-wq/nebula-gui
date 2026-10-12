-- KNI_UI.luau
-- Librería de interfaz compacta para Roblox Studio (ModuleScript).
-- Sin librerías remotas. Incluye minimizar, restaurar, cerrar, pestañas y controles básicos.

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

local function stroke(parent, color, thickness)
    make("UIStroke", {Color = color or COLORS.Border, Thickness = thickness or 1, Transparency = 0.15}, parent)
end

local function padding(parent, left, right, top, bottom)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, left or 10),
        PaddingRight = UDim.new(0, right or 10),
        PaddingTop = UDim.new(0, top or 8),
        PaddingBottom = UDim.new(0, bottom or 8),
    }, parent)
end

function KNI.new(options)
    options = options or {}
    local player = game:GetService("Players").LocalPlayer
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
        IgnoreGuiInset = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 50,
    }, guiParent)
    self.Gui = gui

    local root = make("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(options.Width or 560, options.Height or 390),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
    }, gui)
    root.ClipsDescendants = true
    corner(root, 14)
    stroke(root, COLORS.Border, 1.2)
    self.Root = root

    local top = make("Frame", {
        Name = "TopBar", Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = COLORS.Panel, BorderSizePixel = 0,
    }, root)
    self.TopBar = top
    corner(top, 14)
    make("Frame", {
        Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = COLORS.Panel, BorderSizePixel = 0,
    }, top)

    make("TextLabel", {
        Name = "Title", BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -150, 1, 0),
        Font = Enum.Font.GothamBold, Text = options.Title or "KNI | Muscle Legends",
        TextColor3 = COLORS.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
    }, top)

    local function topButton(text, x, color, callback)
        local b = make("TextButton", {
            Size = UDim2.fromOffset(28, 26), Position = UDim2.new(1, x, 0, 8),
            BackgroundColor3 = color, BorderSizePixel = 0, Text = text,
            TextColor3 = COLORS.Text, TextSize = 16, Font = Enum.Font.GothamBold,
            AutoButtonColor = true,
        }, top)
        corner(b, 8)
        table.insert(self._connections, b.Activated:Connect(callback))
        return b
    end

    local restore = make("TextButton", {
        Name = "RestoreButton", AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18), Size = UDim2.fromOffset(52, 52),
        BackgroundColor3 = COLORS.Accent, BorderSizePixel = 0, Text = "KNI",
        TextColor3 = COLORS.Text, TextSize = 15, Font = Enum.Font.GothamBlack,
        Visible = false, ZIndex = 100,
    }, gui)
    corner(restore, 18)
    stroke(restore, COLORS.Text, 1)
    self.RestoreButton = restore

    local content = make("Frame", {
        Name = "Content", Position = UDim2.fromOffset(0, 42),
        Size = UDim2.new(1, 0, 1, -42), BackgroundTransparency = 1,
    }, root)
    self.Content = content

    local rail = make("ScrollingFrame", {
        Name = "TabRail", Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(0, 132, 1, -20), BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, content)
    corner(rail, 10)
    padding(rail, 7, 7, 8, 8)
    make("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, rail)
    self.TabRail = rail

    local pages = make("Frame", {
        Name = "Pages", Position = UDim2.new(0, 152, 0, 10),
        Size = UDim2.new(1, -162, 1, -20), BackgroundColor3 = COLORS.Panel,
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
    table.insert(self._connections, game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    table.insert(self._connections, game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
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

function KNI:AddTab(name)
    assert(not self._destroyed, "La interfaz fue cerrada")
    local tab = {Name = name, _ui = self, _controls = {}}
    local button = make("TextButton", {
        Name = "Tab_" .. tostring(name), Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = COLORS.Panel2, BorderSizePixel = 0,
        Text = tostring(name), TextColor3 = COLORS.Muted, TextSize = 11,
        Font = Enum.Font.GothamSemibold, TextWrapped = true,
    }, self.TabRail)
    corner(button, 8)

    local page = make("ScrollingFrame", {
        Name = "Page_" .. tostring(name), Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
        ScrollBarThickness = 4, ScrollBarImageColor3 = COLORS.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
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
            BackgroundColor3 = COLORS.Panel2, BorderSizePixel = 0,
        }, page)
        corner(frame, 8)
        return frame
    end

    function tab:AddLabel(text)
        local r = row(30)
        r.BackgroundTransparency = 1
        local label = make("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
            Text = tostring(text), TextColor3 = COLORS.Muted, TextSize = 11,
            Font = Enum.Font.Gotham, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        local control = {Instance = label}
        function control:SetText(value) label.Text = tostring(value) end
        setmetatable(control, {__index = function(_, key) if key == "Text" then return label.Text end end,
            __newindex = function(t, key, value) if key == "Text" then label.Text = tostring(value) else rawset(t, key, value) end end})
        return control
    end

    function tab:AddButton(text, callback)
        local r = row(34)
        local b = make("TextButton", {
            Position = UDim2.fromOffset(4, 3), Size = UDim2.new(1, -8, 1, -6),
            BackgroundColor3 = COLORS.Accent2, BorderSizePixel = 0,
            Text = tostring(text), TextColor3 = COLORS.Text, TextSize = 11,
            Font = Enum.Font.GothamSemibold,
        }, r)
        corner(b, 7)
        table.insert(self._ui._connections, b.Activated:Connect(function()
            if callback then task.spawn(callback) end
        end))
        return b
    end

    function tab:AddSwitch(text, callback)
        local r = row(38)
        local label = make("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0),
            Size = UDim2.new(1, -72, 1, 0), Text = tostring(text),
            TextColor3 = COLORS.Text, TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        }, r)
        local b = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7, 0.5, 0),
            Size = UDim2.fromOffset(48, 23), BackgroundColor3 = COLORS.Panel,
            BorderSizePixel = 0, Text = "OFF", TextColor3 = COLORS.Muted,
            TextSize = 10, Font = Enum.Font.GothamBold,
        }, r)
        corner(b, 12)
        local control = {Value = false}
        function control:Set(value)
            control.Value = value == true
            b.Text = control.Value and "ON" or "OFF"
            b.BackgroundColor3 = control.Value and COLORS.Accent or COLORS.Panel
            b.TextColor3 = COLORS.Text
            if callback then callback(control.Value) end
        end
        table.insert(self._ui._connections, b.Activated:Connect(function() control:Set(not control.Value) end))
        return control
    end

    function tab:AddTextBox(text, callback, opts)
        local r = row(58)
        make("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(9, 2),
            Size = UDim2.new(1, -18, 0, 19), Text = tostring(text),
            TextColor3 = COLORS.Muted, TextSize = 10, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        local box = make("TextBox", {
            Position = UDim2.fromOffset(7, 25), Size = UDim2.new(1, -14, 0, 26),
            BackgroundColor3 = COLORS.Background, BorderSizePixel = 0,
            Text = "", PlaceholderText = "Escribe aquí…", ClearTextOnFocus = not (opts and opts.clear == false),
            TextColor3 = COLORS.Text, PlaceholderColor3 = COLORS.Muted, TextSize = 11,
            Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        corner(box, 6)
        padding(box, 7, 7, 0, 0)
        table.insert(self._ui._connections, box.FocusLost:Connect(function()
            if callback then callback(box.Text) end
        end))
        return box
    end

    function tab:AddDropdown(text, callback)
        local control = {Items = {}, Selected = nil}
        local r = row(58)
        local b = make("TextButton", {
            Position = UDim2.fromOffset(7, 5), Size = UDim2.new(1, -14, 0, 24),
            BackgroundColor3 = COLORS.Background, BorderSizePixel = 0,
            Text = tostring(text) .. "  ▾", TextColor3 = COLORS.Text, TextSize = 10,
            Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
        }, r)
        corner(b, 6)
        local menu = make("Frame", {
            Position = UDim2.new(0, 7, 0, 32), Size = UDim2.new(1, -14, 0, 0),
            BackgroundColor3 = COLORS.Background, BorderSizePixel = 0, Visible = false,
            ClipsDescendants = true, ZIndex = 20,
        }, r)
        corner(menu, 6)
        local list = make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 21,
        }, menu)
        make("UIListLayout", {Padding = UDim.new(0, 2)}, list)
        local open = false
        local function refresh()
            for _, child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            for _, item in ipairs(control.Items) do
                local choice = make("TextButton", {
                    Size = UDim2.new(1, -4, 0, 24), BackgroundColor3 = COLORS.Panel2,
                    BorderSizePixel = 0, Text = tostring(item), TextColor3 = COLORS.Text,
                    TextSize = 10, Font = Enum.Font.Gotham, ZIndex = 22,
                }, list)
                table.insert(self._ui._connections, choice.Activated:Connect(function()
                    control.Selected = tostring(item)
                    b.Text = tostring(text) .. ": " .. control.Selected .. "  ▾"
                    open = false
                    menu.Visible = false
                    menu.Size = UDim2.new(1, -14, 0, 0)
                    if callback then callback(control.Selected) end
                end))
            end
        end
        function control:Add(item)
            table.insert(control.Items, tostring(item))
            refresh()
        end
        function control:Remove(item)
            for i, v in ipairs(control.Items) do
                if v == item then table.remove(control.Items, i); break end
            end
            refresh()
        end
        table.insert(self._ui._connections, b.Activated:Connect(function()
            open = not open
            menu.Visible = open
            menu.Size = open and UDim2.new(1, -14, 0, 100) or UDim2.new(1, -14, 0, 0)
        end))
        return control
    end

    return tab
end

function KNI:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    for _, connection in ipairs(self._connections) do pcall(function() connection:Disconnect() end) end
    table.clear(self._connections)
    if self.Gui then self.Gui:Destroy() end
end

return KNI
