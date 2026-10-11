--[[
    ═══════════════════════════════════════════════════════════════
    NebulaGUI v1.0 — Librería de interfaz para Roblox
    Repositorio: github.com/rodriguezberiticajuliocesar-wq/nebula-gui
    Made by Honen
    ═══════════════════════════════════════════════════════════════
]]

local NebulaGUI = {}
NebulaGUI.__index = NebulaGUI

local Services = {
    Players             = game:GetService("Players"),
    RunService          = game:GetService("RunService"),
    UserInputService    = game:GetService("UserInputService"),
    TweenService        = game:GetService("TweenService"),
    CoreGui             = game:GetService("CoreGui"),
    StarterGui          = game:GetService("StarterGui"),
    ReplicatedStorage   = game:GetService("ReplicatedStorage"),
    VirtualUser         = game:GetService("VirtualUser"),
    Lighting            = game:GetService("Lighting"),
    Stats               = game:GetService("Stats"),
    HttpService         = game:GetService("HttpService"),
}
local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Theme = {
    Background   = Color3.fromRGB(14, 10, 22),
    Panel        = Color3.fromRGB(20, 15, 32),
    PanelLight   = Color3.fromRGB(28, 22, 42),
    Row          = Color3.fromRGB(24, 18, 38),
    RowHover     = Color3.fromRGB(36, 26, 55),
    Accent       = Color3.fromRGB(155, 70, 255),
    AccentLight  = Color3.fromRGB(190, 120, 255),
    Success      = Color3.fromRGB(80, 220, 140),
    Warning      = Color3.fromRGB(255, 200, 80),
    Danger       = Color3.fromRGB(255, 80, 110),
    Text         = Color3.fromRGB(240, 235, 255),
    TextDim      = Color3.fromRGB(160, 150, 190),
    Border       = Color3.fromRGB(70, 50, 110),
    BorderBright = Color3.fromRGB(155, 70, 255),
}

local Fonts = {
    Title   = Enum.Font.GothamBold,
    Heading = Enum.Font.GothamBold,
    Body    = Enum.Font.Gotham,
    Small   = Enum.Font.Gotham,
}

local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
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

local function isMobile()
    local touch = Services.UserInputService.TouchEnabled
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    return touch or vp.X < 900
end

-- ═══ NOTIFICACIONES ═══
local Notify = {}
local notifyContainer = nil

local function ensureNotifyContainer()
    if notifyContainer and notifyContainer.Parent then return notifyContainer end
    local screen = create("ScreenGui", {
        Name = "NebulaNotify",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 9999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)
    local holder = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.fromOffset(300, 500),
        BackgroundTransparency = 1,
    }, screen)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, holder)
    notifyContainer = holder
    return holder
end

function Notify.show(title, text, duration, kind)
    local holder = ensureNotifyContainer()
    duration = duration or 4
    kind = kind or "info"
    local color = Theme.Accent
    if kind == "success" then color = Theme.Success
    elseif kind == "warning" then color = Theme.Warning
    elseif kind == "error" then color = Theme.Danger end

    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, holder)
    corner(card, 10)
    stroke(card, color, 1.2, 0.3)

    create("Frame", {
        Size = UDim2.fromOffset(3, 40),
        Position = UDim2.new(0, 8, 0.5, -20),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
    }, card)

    create("TextLabel", {
        Size = UDim2.new(1, -26, 0, 18),
        Position = UDim2.fromOffset(18, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = color,
        Font = Fonts.Heading,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    create("TextLabel", {
        Size = UDim2.new(1, -26, 0, 26),
        Position = UDim2.fromOffset(18, 26),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.TextDim,
        Font = Fonts.Body,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    }, card)

    card.Position = UDim2.new(1, 320, 0, 0)
    tween(card, 0.28, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Back)

    task.delay(duration, function()
        if card and card.Parent then
            tween(card, 0.2, { Position = UDim2.new(1, 320, 0, 0) })
            task.wait(0.25)
            card:Destroy()
        end
    end)
end

NebulaGUI.Notify = Notify

-- ═══ CLASE TAB ═══
local Tab = {}
Tab.__index = Tab

function Tab:_nextOrder()
    self._order = self._order + 1
    return self._order
end

function Tab:AddLabel(text, icon)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.TextDim,
        Font = Fonts.Body,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
end

function Tab:AddSection(text, icon)
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
    create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.fromOffset(6, 0),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.AccentLight,
        Font = Fonts.Heading,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)
    create("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(1, -4, 0.5, 0),
        Size = UDim2.fromOffset(30, 1),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
    }, holder)
    return holder
end

function Tab:AddSwitch(text, callback, default, icon)
    local row = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Row,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
    corner(row, 8)
    stroke(row, Theme.Border, 1, 0.7)

    create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.Text,
        Font = Fonts.Body,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)

    local track = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(42, 22),
        BackgroundColor3 = Color3.fromRGB(30, 24, 40),
        BorderSizePixel = 0,
    }, row)
    corner(track, 11)
    local trackStroke = stroke(track, Theme.Border, 1, 0.4)

    local knob = create("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.TextDim,
        BorderSizePixel = 0,
    }, track)
    corner(knob, 8)

    local state = default == true

    local function render(animated)
        if state then
            if animated then
                tween(track, 0.2, { BackgroundColor3 = Theme.Accent })
                tween(knob, 0.2, { Position = UDim2.fromOffset(23, 3), BackgroundColor3 = Theme.Text }, Enum.EasingStyle.Back)
                tween(trackStroke, 0.2, { Color = Theme.AccentLight, Transparency = 0 })
            else
                track.BackgroundColor3 = Theme.Accent
                knob.Position = UDim2.fromOffset(23, 3)
                knob.BackgroundColor3 = Theme.Text
                trackStroke.Color = Theme.AccentLight
                trackStroke.Transparency = 0
            end
        else
            if animated then
                tween(track, 0.2, { BackgroundColor3 = Color3.fromRGB(30, 24, 40) })
                tween(knob, 0.2, { Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Theme.TextDim })
                tween(trackStroke, 0.2, { Color = Theme.Border, Transparency = 0.4 })
            else
                track.BackgroundColor3 = Color3.fromRGB(30, 24, 40)
                knob.Position = UDim2.fromOffset(3, 3)
                knob.BackgroundColor3 = Theme.TextDim
                trackStroke.Color = Theme.Border
                trackStroke.Transparency = 0.4
            end
        end
    end

    render(false)

    row.MouseEnter:Connect(function()
        tween(row, 0.12, { BackgroundColor3 = Theme.RowHover, BackgroundTransparency = 0.1 })
    end)
    row.MouseLeave:Connect(function()
        tween(row, 0.12, { BackgroundColor3 = Theme.Row, BackgroundTransparency = 0.2 })
    end)

    row.MouseButton1Click:Connect(function()
        state = not state
        render(true)
        if callback then
            local ok, err = pcall(callback, state)
            if not ok then warn("[NebulaGUI] Switch error:", err) end
        end
    end)

    return {
        Set = function(_, value, silent)
            state = value == true
            render(true)
            if not silent and callback then pcall(callback, state) end
        end,
        Get = function() return state end,
    }
end

function Tab:AddButton(text, callback, icon)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.Text,
        Font = Fonts.Heading,
        TextSize = 12,
        AutoButtonColor = false,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
    corner(btn, 8)
    local btnStroke = stroke(btn, Theme.AccentLight, 1, 0.3)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.12, { BackgroundTransparency = 0.05 })
        tween(btnStroke, 0.12, { Transparency = 0 })
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, 0.12, { BackgroundTransparency = 0.2 })
        tween(btnStroke, 0.12, { Transparency = 0.3 })
    end)

    btn.MouseButton1Click:Connect(function()
        tween(btn, 0.08, { BackgroundTransparency = 0.4 })
        task.delay(0.12, function()
            tween(btn, 0.2, { BackgroundTransparency = 0.2 })
        end)
        if callback then
            local ok, err = pcall(callback, btn)
            if not ok then warn("[NebulaGUI] Button error:", err) end
        end
    end)

    return btn
end

function Tab:AddTextBox(placeholder, callback, default)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Row,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
    corner(row, 8)
    local rowStroke = stroke(row, Theme.Border, 1, 0.7)

    local box = create("TextBox", {
        Size = UDim2.new(1, -20, 1, -8),
        Position = UDim2.new(0, 10, 0.5, -13),
        BackgroundTransparency = 1,
        Text = default or "",
        PlaceholderText = placeholder or "Escribí algo...",
        PlaceholderColor3 = Theme.TextDim,
        TextColor3 = Theme.Text,
        Font = Fonts.Body,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, row)

    box.Focused:Connect(function()
        tween(rowStroke, 0.15, { Color = Theme.AccentLight, Transparency = 0 })
    end)
    box.FocusLost:Connect(function(enterPressed)
        tween(rowStroke, 0.15, { Color = Theme.Border, Transparency = 0.7 })
        if callback then pcall(callback, box.Text, enterPressed) end
    end)

    return box
end

function Tab:AddSlider(text, min, max, default, callback, icon)
    min, max = min or 0, max or 100
    default = math.clamp(default or min, min, max)

    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Row,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        LayoutOrder = self:_nextOrder(),
    }, self.Page)
    corner(row, 8)
    stroke(row, Theme.Border, 1, 0.7)

    create("TextLabel", {
        Size = UDim2.new(1, -90, 0, 18),
        Position = UDim2.fromOffset(12, 4),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.Text,
        Font = Fonts.Body,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local valueLbl = create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 4),
        Size = UDim2.fromOffset(70, 18),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Theme.AccentLight,
        Font = Fonts.Heading,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, row)

    local track = create("Frame", {
        Position = UDim2.fromOffset(12, 28),
        Size = UDim2.new(1, -24, 0, 6),
        BackgroundColor3 = Color3.fromRGB(25, 20, 38),
        BorderSizePixel = 0,
    }, row)
    corner(track, 3)

    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, track)
    corner(fill, 3)

    local knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Theme.Text,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, track)
    corner(knob, 7)

    local currentValue = default

    local function updateFromX(x)
        local relX = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * relX + 0.5)
        valueLbl.Text = tostring(currentValue)
        tween(fill, 0.08, { Size = UDim2.new(relX, 0, 1, 0) }, Enum.EasingStyle.Linear)
        tween(knob, 0.08, { Position = UDim2.new(relX, 0, 0.5, 0) }, Enum.EasingStyle.Linear)
    end

    local initRel = (default - min) / (max - min)
    fill.Size = UDim2.new(initRel, 0, 1, 0)
    knob.Position = UDim2.new(initRel, 0, 0.5, 0)

    local function startDrag(input)
        updateFromX(input.Position.X)
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                conn:Disconnect()
                if callback then pcall(callback, currentValue) end
            elseif input.UserInputState == Enum.UserInputState.Change then
                updateFromX(input.Position.X)
            end
        end)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)

    return {
        Set = function(_, value)
            value = math.clamp(value, min, max)
            currentValue = value
            valueLbl.Text = tostring(value)
            local rel = (value - min) / (max - min)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            if callback then pcall(callback, value) end
        end,
        Get = function() return currentValue end,
    }
end

function Tab:AddDropdown(text, options, callback, default, icon)
    options = options or {}
    local selected = default

    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Theme.Row,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        LayoutOrder = self:_nextOrder(),
        ZIndex = 10,
    }, self.Page)
    corner(holder, 8)
    stroke(holder, Theme.Border, 1, 0.7)

    local header = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 11,
    }, holder)

    create("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text = (icon and icon .. "  " or "") .. tostring(text),
        TextColor3 = Theme.Text,
        Font = Fonts.Body,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, header)

    local valueLbl = create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -36, 0.5, 0),
        Size = UDim2.fromOffset(140, 20),
        BackgroundTransparency = 1,
        Text = selected and tostring(selected) or "Seleccionar",
        TextColor3 = Theme.AccentLight,
        Font = Fonts.Heading,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 11,
    }, header)

    local arrow = create("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Theme.AccentLight,
        Font = Fonts.Body,
        TextSize = 10,
        ZIndex = 11,
    }, header)

    local screenGui = self.Page
    while screenGui and not screenGui:IsA("ScreenGui") do
        screenGui = screenGui.Parent
    end
    if not screenGui then screenGui = PlayerGui end

    local dropdownPanel = create("Frame", {
        Name = "DropdownPanel_" .. text,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.02,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 500,
    }, screenGui)
    corner(dropdownPanel, 8)
    stroke(dropdownPanel, Theme.AccentLight, 1.2, 0.2)

    local optionsList = create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.fromOffset(4, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 501,
    }, dropdownPanel)
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    }, optionsList)

    local isOpen = false
    local optionButtons = {}

    local function renderOptions()
        for _, b in ipairs(optionButtons) do b:Destroy() end
        optionButtons = {}
        for i, opt in ipairs(options) do
            local optBtn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundColor3 = Theme.PanelLight,
                BackgroundTransparency = (opt == selected) and 0.2 or 0.6,
                BorderSizePixel = 0,
                Text = tostring(opt),
                TextColor3 = (opt == selected) and Theme.Text or Theme.TextDim,
                Font = Fonts.Body,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = i,
                ZIndex = 502,
            }, optionsList)
            corner(optBtn, 6)
            create("UIPadding", { PaddingLeft = UDim.new(0, 8) }, optBtn)

            optBtn.MouseEnter:Connect(function()
                tween(optBtn, 0.1, { BackgroundTransparency = 0.1, BackgroundColor3 = Theme.RowHover })
            end)
            optBtn.MouseLeave:Connect(function()
                tween(optBtn, 0.1, {
                    BackgroundTransparency = (opt == selected) and 0.2 or 0.6,
                    BackgroundColor3 = Theme.PanelLight,
                })
            end)
            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                valueLbl.Text = tostring(opt)
                renderOptions()
                setOpen(false)
                if callback then pcall(callback, opt) end
            end)
            table.insert(optionButtons, optBtn)
        end
        local layout = optionsList:FindFirstChildOfClass("UIListLayout")
        if layout then
            optionsList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
        end
    end

    function setOpen(open)
        isOpen = open
        if isOpen then
            local count = math.min(#options, 6)
            local panelHeight = count * 28 + 10
            dropdownPanel.Size = UDim2.fromOffset(holder.AbsoluteSize.X, panelHeight)
            dropdownPanel.Position = UDim2.fromOffset(
                holder.AbsolutePosition.X,
                holder.AbsolutePosition.Y + holder.AbsoluteSize.Y + 2
            )
            dropdownPanel.Visible = true
            tween(arrow, 0.15, { Rotation = 180 })
        else
            dropdownPanel.Visible = false
            tween(arrow, 0.15, { Rotation = 0 })
        end
    end

    header.MouseButton1Click:Connect(function()
        setOpen(not isOpen)
    end)

    Services.UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if isOpen then
                local mx, my = input.Position.X, input.Position.Y
                local panelPos = dropdownPanel.AbsolutePosition
                local panelSize = dropdownPanel.AbsoluteSize
                local inPanel = mx >= panelPos.X and mx <= panelPos.X + panelSize.X
                    and my >= panelPos.Y and my <= panelPos.Y + panelSize.Y
                local holderPos = holder.AbsolutePosition
                local holderSize = holder.AbsoluteSize
                local inHolder = mx >= holderPos.X and mx <= holderPos.X + holderSize.X
                    and my >= holderPos.Y and my <= holderPos.Y + holderSize.Y
                if not inPanel and not inHolder then
                    setOpen(false)
                end
            end
        end
    end)

    renderOptions()

    return {
        Set = function(_, value)
            selected = value
            valueLbl.Text = tostring(value)
            renderOptions()
        end,
        Get = function() return selected end,
        SetOptions = function(_, newOptions)
            options = newOptions
            renderOptions()
        end,
    }
end

-- ═══ CLASE WINDOW ═══
local Window = {}
Window.__index = Window

function NebulaGUI:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Nebula Hub"
    local subtitle = opts.Subtitle or "Made by Honen"
    local size = opts.Size or UDim2.fromOffset(isMobile() and 340 or 820, isMobile() and 420 or 520)

    local screen = create("ScreenGui", {
        Name = "NebulaHub",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)

    local root = create("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = size,
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
    }, screen)
    corner(root, 14)
    local rootStroke = stroke(root, Theme.BorderBright, 1.4, 0.4)

    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Background),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 28)),
            ColorSequenceKeypoint.new(1, Theme.Background),
        }),
        Rotation = 45,
    }, root)

    local header = create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
    }, root)
    corner(header, 14)
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
    }, header)

    create("TextLabel", {
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.fromOffset(14, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        Font = Fonts.Title,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    create("TextLabel", {
        Size = UDim2.new(1, -100, 0, 14),
        Position = UDim2.fromOffset(14, 24),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Theme.TextDim,
        Font = Fonts.Small,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, header)

    local btnContainer = create("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(60, 24),
        BackgroundTransparency = 1,
    }, header)

    local function makeHeaderBtn(text, color)
        local b = create("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = Theme.Text,
            Font = Fonts.Heading,
            TextSize = 14,
            AutoButtonColor = false,
        }, btnContainer)
        corner(b, 6)
        return b
    end

    local minimizeBtn = makeHeaderBtn("–", Theme.Accent)
    minimizeBtn.Position = UDim2.fromOffset(0, 0)
    local closeBtn = makeHeaderBtn("✕", Theme.Danger)
    closeBtn.Position = UDim2.fromOffset(30, 0)

    local tabBar = create("ScrollingFrame", {
        Name = "TabBar",
        Position = UDim2.fromOffset(0, 42),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, root)
    create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
    }, tabBar)
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
    }, tabBar)

    local content = create("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(0, 76),
        Size = UDim2.new(1, 0, 1, -76),
        BackgroundTransparency = 1,
    }, root)

    local self = setmetatable({
        Screen = screen,
        Root = root,
        Header = header,
        TabBar = tabBar,
        Content = content,
        Tabs = {},
        ActiveTab = nil,
        Minimized = false,
        Size = size,
        _tabCounter = 0,
        _bubbleMoved = false,
    }, Window)

    local dragging = false
    local dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            tween(root, 0.08, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, Enum.EasingStyle.Linear)
        end
    end)

    local bubble = create("TextButton", {
        Name = "Bubble",
        Size = UDim2.fromOffset(56, 56),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        Text = "",
        Visible = false,
        AutoButtonColor = false,
        ZIndex = 999,
    }, screen)
    corner(bubble, 28)
    stroke(bubble, Theme.BorderBright, 1.5, 0.2)

    create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "🌌",
        TextColor3 = Theme.Text,
        Font = Fonts.Title,
        TextSize = 26,
    }, bubble)

    local bDragging, bDragStart, bStartPos
    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            bDragging = true
            bDragStart = input.Position
            bStartPos = bubble.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    bDragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if not bDragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - bDragStart
            bubble.Position = UDim2.new(
                bStartPos.X.Scale, bStartPos.X.Offset + delta.X,
                bStartPos.Y.Scale, bStartPos.Y.Offset + delta.Y
            )
            self._bubbleMoved = true
        end
    end)

    local clickGuard = false
    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            local startTime = tick()
            local startPosClick = input.Position
            local conn
            conn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                    local dist = (input.Position - startPosClick).Magnitude
                    if dist < 8 and tick() - startTime < 0.3 and not clickGuard then
                        clickGuard = true
                        self:SetMinimized(false)
                        task.wait(0.1)
                        clickGuard = false
                    end
                end
            end)
        end
    end)

    function self:SetMinimized(minimized)
        self.Minimized = minimized
        if minimized then
            tween(root, 0.2, { Size = UDim2.fromOffset(56, 56), BackgroundTransparency = 1 })
            tween(rootStroke, 0.2, { Transparency = 1 })
            tween(header, 0.2, { BackgroundTransparency = 1 })
            tween(tabBar, 0.2, { BackgroundTransparency = 1 })
            tween(content, 0.2, { BackgroundTransparency = 1 })
            if not self._bubbleMoved then
                bubble.Position = root.Position
            end
            bubble.Visible = true
            task.delay(0.15, function()
                if self.Minimized then
                    root.Visible = false
                    bubble.Visible = true
                end
            end)
        else
            bubble.Visible = false
            root.Visible = true
            -- IMPORTANTE: fijar color y transparencia ANTES de los tweens
            root.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
            root.BackgroundTransparency = 0
            root.Size = self.Size
            rootStroke.Transparency = 0.4
            header.BackgroundTransparency = 0.3
            tabBar.BackgroundTransparency = 0.6
            content.BackgroundTransparency = 0
            -- Resetear el gradiente
            local grad = root:FindFirstChildOfClass("UIGradient")
            if grad then
                grad.Enabled = true
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 10, 22)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 28)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 10, 22)),
                })
            end
            -- NO hacemos tween de BackgroundColor3 ni BackgroundTransparency
            -- Solo animamos el tamaño
            local scaleIn = tween(root, 0.25, { Size = self.Size }, Enum.EasingStyle.Back)
        end
    end

    function self:Destroy()
        screen:Destroy()
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        self:SetMinimized(not self.Minimized)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    function self:AddTab(name, icon)
        self._tabCounter = self._tabCounter + 1
        local order = self._tabCounter

        local btn = create("TextButton", {
            Name = "Tab_" .. name,
            Size = UDim2.fromOffset(isMobile() and 62 or 72, 22),
            BackgroundColor3 = Theme.PanelLight,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Text = (icon and icon .. " " or "") .. name,
            TextColor3 = Theme.TextDim,
            Font = Fonts.Heading,
            TextSize = 11,
            AutoButtonColor = false,
            LayoutOrder = order,
        }, tabBar)
        corner(btn, 6)
        stroke(btn, Theme.Border, 1, 0.7)

        local page = create("ScrollingFrame", {
            Name = "Page_" .. name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            ScrollBarImageTransparency = 0.2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
        }, content)
        create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 14),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        }, page)
        local pageLayout = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        }, page)

        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 24)
        end)

        local tabObj = setmetatable({
            Name = name,
            Button = btn,
            Page = page,
            Layout = pageLayout,
            _order = 0,
        }, Tab)

        btn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)
        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= name then
                tween(btn, 0.12, { BackgroundColor3 = Theme.RowHover, BackgroundTransparency = 0.1 })
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= name then
                tween(btn, 0.12, { BackgroundColor3 = Theme.PanelLight, BackgroundTransparency = 0.2 })
            end
        end)

        self.Tabs[name] = tabObj
        if not self.ActiveTab then
            self:SelectTab(name)
        end
        return tabObj
    end

    function self:SelectTab(name)
        for tabName, tab in pairs(self.Tabs) do
            local active = (tabName == name)
            tab.Page.Visible = active
            tween(tab.Button, 0.15, {
                BackgroundColor3 = active and Theme.Accent or Theme.PanelLight,
                BackgroundTransparency = active and 0.1 or 0.2,
                TextColor3 = active and Theme.Text or Theme.TextDim,
            })
        end
        self.ActiveTab = name
    end

    return self
end

return NebulaGUI
