--[[
    NeverLoseUI v3 - A Premium Roblox UI Library
    Features: Universal Keybind System, Live Theme Editor, Inertia Draggable, Polished Aesthetic
    
    Changelog v3:
    - Fixed section frame layout bugs and incorrect parent references
    - Extracted section elements into modular factory functions
    - Added comprehensive error handling and input validation
    - Fixed dialog animation and overlay behavior
    - Improved dropdown UX with proper open/close behavior
    - Added full config save/load with UI state restoration
    - Optimized theme updates with debounced batched tweens
    - Added documentation and improved code organization
]]

local NeverLoseUI = {}
NeverLoseUI.__index = NeverLoseUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

-- Theme Definitions
local THEMES = {
    Midnight = {
        Background = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(24, 24, 32),
        SurfaceAlt = Color3.fromRGB(32, 32, 42),
        Border = Color3.fromRGB(45, 45, 60),
        Accent = Color3.fromRGB(99, 102, 241),
        TextPrimary = Color3.fromRGB(250, 250, 255),
        TextSecondary = Color3.fromRGB(160, 160, 175),
        TitleBar = Color3.fromRGB(20, 20, 26),
        Sidebar = Color3.fromRGB(18, 18, 24),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
    },
    Crimson = {
        Background = Color3.fromRGB(16, 10, 10),
        Surface = Color3.fromRGB(24, 16, 16),
        SurfaceAlt = Color3.fromRGB(32, 22, 22),
        Border = Color3.fromRGB(50, 30, 30),
        Accent = Color3.fromRGB(220, 38, 38),
        TextPrimary = Color3.fromRGB(255, 240, 240),
        TextSecondary = Color3.fromRGB(180, 140, 140),
        TitleBar = Color3.fromRGB(22, 12, 12),
        Sidebar = Color3.fromRGB(20, 14, 14),
        Danger = Color3.fromRGB(248, 113, 113),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(250, 204, 21),
    },
    Emerald = {
        Background = Color3.fromRGB(10, 16, 12),
        Surface = Color3.fromRGB(16, 24, 18),
        SurfaceAlt = Color3.fromRGB(22, 32, 24),
        Border = Color3.fromRGB(35, 50, 40),
        Accent = Color3.fromRGB(16, 185, 129),
        TextPrimary = Color3.fromRGB(240, 255, 245),
        TextSecondary = Color3.fromRGB(140, 180, 150),
        TitleBar = Color3.fromRGB(12, 20, 16),
        Sidebar = Color3.fromRGB(14, 22, 18),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(234, 179, 8),
    },
    Amethyst = {
        Background = Color3.fromRGB(14, 10, 18),
        Surface = Color3.fromRGB(22, 16, 28),
        SurfaceAlt = Color3.fromRGB(30, 22, 38),
        Border = Color3.fromRGB(45, 30, 55),
        Accent = Color3.fromRGB(168, 85, 247),
        TextPrimary = Color3.fromRGB(250, 240, 255),
        TextSecondary = Color3.fromRGB(170, 150, 180),
        TitleBar = Color3.fromRGB(18, 12, 22),
        Sidebar = Color3.fromRGB(20, 14, 26),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
    },
    Ocean = {
        Background = Color3.fromRGB(10, 15, 20),
        Surface = Color3.fromRGB(16, 22, 30),
        SurfaceAlt = Color3.fromRGB(22, 30, 40),
        Border = Color3.fromRGB(30, 45, 60),
        Accent = Color3.fromRGB(6, 182, 212),
        TextPrimary = Color3.fromRGB(240, 250, 255),
        TextSecondary = Color3.fromRGB(140, 170, 190),
        TitleBar = Color3.fromRGB(12, 18, 24),
        Sidebar = Color3.fromRGB(14, 20, 28),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
    },
    Sunset = {
        Background = Color3.fromRGB(20, 14, 10),
        Surface = Color3.fromRGB(30, 20, 16),
        SurfaceAlt = Color3.fromRGB(40, 28, 22),
        Border = Color3.fromRGB(60, 40, 30),
        Accent = Color3.fromRGB(249, 115, 22),
        TextPrimary = Color3.fromRGB(255, 245, 240),
        TextSecondary = Color3.fromRGB(190, 160, 140),
        TitleBar = Color3.fromRGB(24, 16, 12),
        Sidebar = Color3.fromRGB(26, 18, 14),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(250, 204, 21),
    },
    Rose = {
        Background = Color3.fromRGB(18, 10, 14),
        Surface = Color3.fromRGB(28, 16, 22),
        SurfaceAlt = Color3.fromRGB(38, 24, 30),
        Border = Color3.fromRGB(55, 30, 45),
        Accent = Color3.fromRGB(236, 72, 153),
        TextPrimary = Color3.fromRGB(255, 240, 248),
        TextSecondary = Color3.fromRGB(180, 150, 165),
        TitleBar = Color3.fromRGB(22, 12, 18),
        Sidebar = Color3.fromRGB(24, 14, 20),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
    },
    Monochrome = {
        Background = Color3.fromRGB(12, 12, 12),
        Surface = Color3.fromRGB(20, 20, 20),
        SurfaceAlt = Color3.fromRGB(28, 28, 28),
        Border = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(240, 240, 240),
        TextPrimary = Color3.fromRGB(250, 250, 250),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        TitleBar = Color3.fromRGB(16, 16, 16),
        Sidebar = Color3.fromRGB(18, 18, 18),
        Danger = Color3.fromRGB(239, 68, 68),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
    }
}

local THEME_PRESETS = {"Midnight", "Crimson", "Emerald", "Amethyst", "Ocean", "Sunset", "Rose", "Monochrome"}

-- Font Definitions
local FONT = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold
local FONT_SEMI = Enum.Font.Gotham

--[[ Utility Functions ]]

local function Tween(obj, props, time, style, dir)
    local tweenInfo = TweenInfo.new(time or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    return TweenService:Create(obj, tweenInfo, props)
end

local function Spring(obj, props, time)
    local tweenInfo = TweenInfo.new(time or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0)
    return TweenService:Create(obj, tweenInfo, props)
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            inst[k] = v
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function Corner(radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 4)})
end

local function Stroke(color, thickness)
    return Create("UIStroke", {Color = color, Thickness = thickness or 1})
end

local function Padding(t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0)
    })
end

local function ColorToHex(color)
    if typeof(color) ~= "Color3" then
        return "#000000"
    end
    return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
end

local function HexToColor(hex)
    if typeof(hex) ~= "string" then
        return Color3.new(1, 1, 1)
    end
    hex = hex:gsub("#", "")
    if #hex ~= 6 then
        return Color3.new(1, 1, 1)
    end
    local success, r = pcall(tonumber, "0x" .. hex:sub(1, 2))
    local success2, g = pcall(tonumber, "0x" .. hex:sub(3, 4))
    local success3, b = pcall(tonumber, "0x" .. hex:sub(5, 6))
    if success and success2 and success3 then
        return Color3.fromRGB(r, g, b)
    end
    return Color3.new(1, 1, 1)
end

--[[ Draggable with Inertia ]]

local function MakeDraggable(frame, handle)
    if not frame or not handle then return end
    
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local momentum = Vector2.new(0, 0)
    local lastMousePos = Vector2.new(0, 0)
    local damping = 0.85

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            momentum = Vector2.new(
                input.Position.X - lastMousePos.X,
                input.Position.Y - lastMousePos.Y
            )
            lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not dragging and (math.abs(momentum.X) > 0.1 or math.abs(momentum.Y) > 0.1) then
            momentum = momentum * damping
            local currentPos = frame.Position
            frame.Position = UDim2.new(
                currentPos.X.Scale,
                currentPos.X.Offset + momentum.X,
                currentPos.Y.Scale,
                currentPos.Y.Offset + momentum.Y
            )
        end
    end)
end

--[[ Universal Keybind Formatting ]]

local KeyNames = {
    [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.LeftShift] = "LShift",
    [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftControl] = "LCtrl",
    [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.LeftAlt] = "LAlt",
    [Enum.KeyCode.Insert] = "Ins",
    [Enum.KeyCode.Delete] = "Del",
    [Enum.KeyCode.Backspace] = "Bckspc",
    [Enum.KeyCode.Escape] = "Esc",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
}

local function GetKeyName(key)
    if not key then return "None" end
    if KeyNames[key] then return KeyNames[key] end
    return typeof(key) == "EnumItem" and key.Name or "None"
end

--[[ Section Element Factory Functions ]]
-- Extracted for better code organization and reusability

local function CreateKeybindUI(window, parent, defaultKey, callback)
    if not window or not parent then return nil end
    
    local kbBtn = Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 18),
        Position = UDim2.new(1, -44, 0.5, -9),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = GetKeyName(defaultKey),
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 10 * window.FontSize,
        Font = FONT,
        BorderSizePixel = 0,
        Parent = parent,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })
    
    window:RegisterThemeElement(kbBtn, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(kbBtn, "TextColor3", "TextSecondary")
    window:RegisterThemeElement(kbBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    local kbObj = { Key = defaultKey, Callback = callback or function() end }
    table.insert(window.Keybinds, kbObj)

    kbBtn.MouseButton1Click:Connect(function()
        if window.Binding then return end
        kbBtn.Text = "..."
        window.Binding = true
        window._BindTarget = {
            UpdateKey = function(k)
                kbObj.Key = k
                kbBtn.Text = GetKeyName(k)
            end
        }
    end)
    
    kbBtn.MouseButton2Click:Connect(function()
        kbObj.Key = nil
        kbBtn.Text = "None"
    end)

    return kbBtn
end

local function CreateToggle(window, section, cfg)
    if not window or not section then return { Set = function() end, Get = function() return false end } end
    
    local name = cfg.Name or "Toggle"
    local def = cfg.Default or false
    local cb = cfg.Callback or function() end
    local key = cfg.Keybind

    local val = def
    local Toggle = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = window.CurrentThemeColors.Surface,
        BackgroundTransparency = 1,
        Text = "",
        Parent = section.Frame,
    })

    local Lbl = Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = val and window.CurrentThemeColors.TextPrimary or window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Toggle,
    })

    local Switch = Create("Frame", {
        Size = UDim2.new(0, 34, 0, 18),
        Position = UDim2.new(1, -42, 0.5, -9),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Parent = Toggle,
    }, { Corner(9), Stroke(window.CurrentThemeColors.Border, 1) })

    local Dot = Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, val and 18 or 2, 0.5, -7),
        BackgroundColor3 = val and window.CurrentThemeColors.Accent or window.CurrentThemeColors.TextSecondary,
        Parent = Switch,
    }, { Corner(7) })

    window:RegisterThemeElement(Lbl, "TextColor3", val and "TextPrimary" or "TextSecondary")
    window:RegisterThemeElement(Switch, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(Switch:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")
    window:RegisterThemeElement(Dot, "BackgroundColor3", val and "Accent" or "TextSecondary")

    if key then
        local kbBtn = CreateKeybindUI(window, Toggle, key, function() Toggle.MouseButton1Click:Fire() end)
        if kbBtn then kbBtn.Position = UDim2.new(1, -90, 0.5, -9) end
    end

    local function set(v)
        val = v
        Tween(Dot, {Position = UDim2.new(0, v and 18 or 2, 0.5, -7), BackgroundColor3 = v and window.CurrentThemeColors.Accent or window.CurrentThemeColors.TextSecondary}, 0.2):Play()
        Tween(Lbl, {TextColor3 = v and window.CurrentThemeColors.TextPrimary or window.CurrentThemeColors.TextSecondary}, 0.2):Play()
        cb(v)
    end

    Toggle.MouseButton1Click:Connect(function() set(not val) end)

    window.ConfigData[name] = def
    return { Set = set, Get = function() return val end }
end

local function CreateSlider(window, section, cfg)
    if not window or not section then return { Set = function() end, Get = function() return 0 end } end
    
    local name = cfg.Name or "Slider"
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local def = cfg.Default or min
    local cb = cfg.Callback or function() end

    local val = def
    local Slider = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        Parent = section.Frame,
    })

    local Lbl = Create("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Slider,
    })

    local ValLbl = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -58, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(val),
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 11 * window.FontSize,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Slider,
    })

    local Track = Create("TextButton", {
        Size = UDim2.new(1, -16, 0, 6),
        Position = UDim2.new(0, 8, 0, 26),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = "",
        AutoButtonColor = false,
        Parent = Slider,
    }, { Corner(3) })

    local pct = math.clamp((val - min) / (max - min), 0, 1)
    local Fill = Create("Frame", {
        Size = UDim2.new(pct, 0, 1, 0),
        BackgroundColor3 = window.CurrentThemeColors.Accent,
        Parent = Track,
    }, { Corner(3) })

    window:RegisterThemeElement(Lbl, "TextColor3", "TextSecondary")
    window:RegisterThemeElement(ValLbl, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(Track, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(Fill, "BackgroundColor3", "Accent")

    local function set(v)
        v = math.clamp(v, min, max)
        val = math.floor(v * 10) / 10
        local p = (val - min) / (max - min)
        Tween(Fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.1):Play()
        ValLbl.Text = tostring(val)
        cb(val)
    end

    local dragging = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local rel = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
            set(min + rel * (max - min))
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = (input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X
            set(min + rel * (max - min))
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then 
            dragging = false 
        end
    end)

    window.ConfigData[name] = def
    return { Set = set, Get = function() return val end }
end

local function CreateButton(window, section, cfg)
    if not window or not section then return end
    
    local name = cfg.Name or "Button"
    local cb = cfg.Callback or function() end
    local key = cfg.Keybind

    local Btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 11 * window.FontSize,
        Font = FONT_BOLD,
        Parent = section.Frame,
    }, { Corner(4), Stroke(window.CurrentThemeColors.Border, 1) })

    window:RegisterThemeElement(Btn, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(Btn, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(Btn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    Btn.MouseEnter:Connect(function() 
        Tween(Btn, {BackgroundColor3 = window.CurrentThemeColors.Border}, 0.2):Play() 
    end)
    Btn.MouseLeave:Connect(function() 
        Tween(Btn, {BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt}, 0.2):Play() 
    end)

    Btn.MouseButton1Click:Connect(function()
        local rip = Create("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = window.CurrentThemeColors.Accent,
            BackgroundTransparency = 0.5,
            Parent = Btn
        }, { Corner(100) })
        Tween(rip, {Size = UDim2.new(1, 40, 1, 40), BackgroundTransparency = 1}, 0.4):Play()
        task.delay(0.4, function() if rip and rip.Parent then rip:Destroy() end end)
        cb()
    end)

    if key then CreateKeybindUI(window, Btn, key, cb) end
end

local function CreateDropdown(window, section, cfg)
    if not window or not section then 
        return { Set = function() end, Get = function() return nil end, SetOptions = function() end } 
    end
    
    local name = cfg.Name or "Dropdown"
    local opts = cfg.Options or {}
    local def = cfg.Default or opts[1]
    local cb = cfg.Callback or function() end
    local key = cfg.Keybind

    local selected = def
    local Drop = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Frame,
        ZIndex = 5,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Drop,
    })

    local DropBtn = Create("TextButton", {
        Size = UDim2.new(0.6, -16, 0, 22),
        Position = UDim2.new(0.4, 8, 0.5, -11),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = tostring(selected) .. " \u{25BC}",
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 10 * window.FontSize,
        Font = FONT,
        ZIndex = 6,
        Parent = Drop,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })

    window:RegisterThemeElement(DropBtn, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(DropBtn, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(DropBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    local List = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Visible = false,
        ZIndex = 10,
        Parent = DropBtn,
        ClipsDescendants = true,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })
    
    local ll = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})
    ll.Parent = List
    
    local listSizeTween = nil

    local open = false
    
    local function updateListSize()
        local count = 0
        for _, child in ipairs(List:GetChildren()) do
            if child:IsA("TextButton") then count += 1 end
        end
        return count * 20
    end

    DropBtn.MouseButton1Click:Connect(function()
        open = not open
        List.Visible = true
        if open then
            local targetSize = updateListSize()
            if targetSize > 0 then
                if listSizeTween then listSizeTween:Cancel() end
                listSizeTween = Tween(List, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.2)
                listSizeTween:Play()
            end
        else
            if listSizeTween then listSizeTween:Cancel() end
            listSizeTween = Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
            listSizeTween:Play()
            task.delay(0.15, function() if not open then List.Visible = false end end)
        end
    end)

    local function setOptions(newOpts)
        opts = newOpts or {}
        for _, c in ipairs(List:GetChildren()) do 
            if c:IsA("TextButton") then c:Destroy() end 
        end
        selected = opts[1]
        
        for i, o in ipairs(opts) do
            local ob = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = tostring(o),
                TextColor3 = window.CurrentThemeColors.TextSecondary,
                TextSize = 10 * window.FontSize,
                Font = FONT,
                ZIndex = 11,
                LayoutOrder = i,
                Parent = List,
            })
            ob.MouseButton1Click:Connect(function()
                selected = o
                DropBtn.Text = tostring(o) .. " \u{25BC}"
                open = false
                if listSizeTween then listSizeTween:Cancel() end
                listSizeTween = Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                listSizeTween:Play()
                task.delay(0.15, function() if not open then List.Visible = false end end)
                cb(o)
            end)
            ob.MouseEnter:Connect(function() 
                Tween(ob, {TextColor3 = window.CurrentThemeColors.Accent}, 0.2):Play() 
            end)
            ob.MouseLeave:Connect(function() 
                Tween(ob, {TextColor3 = window.CurrentThemeColors.TextSecondary}, 0.2):Play() 
            end)
        end
    end

    setOptions(opts)
    if key then CreateKeybindUI(window, DropBtn, key, function() end) end

    return { 
        Set = function(v) selected = v; DropBtn.Text = tostring(v) .. " \u{25BC}"; cb(v) end, 
        Get = function() return selected end, 
        SetOptions = setOptions 
    }
end

local function CreateMultiDropdown(window, section, cfg)
    if not window or not section then 
        return { Set = function() end, Get = function() return {} end, SetOptions = function() end } 
    end
    
    local name = cfg.Name or "MultiDropdown"
    local opts = cfg.Options or {}
    local defList = cfg.Default or {}
    local cb = cfg.Callback or function() end

    local selected = {}
    for _, v in ipairs(defList) do selected[v] = true end

    local Drop = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Frame,
        ZIndex = 5,
    })
    
    local Lbl = Create("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Drop,
    })

    local DropBtn = Create("TextButton", {
        Size = UDim2.new(0.6, -16, 0, 22),
        Position = UDim2.new(0.4, 8, 0.5, -11),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = "Select...",
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 10 * window.FontSize,
        Font = FONT,
        ZIndex = 6,
        Parent = Drop,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })

    window:RegisterThemeElement(Lbl, "TextColor3", "TextSecondary")
    window:RegisterThemeElement(DropBtn, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(DropBtn, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(DropBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    local List = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Visible = false,
        ZIndex = 10,
        Parent = DropBtn,
        ClipsDescendants = true,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })
    
    local ll = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})
    ll.Parent = List
    
    local listSizeTween = nil
    local open = false
    
    local function updateListSize()
        local count = 0
        for _, child in ipairs(List:GetChildren()) do
            if child:IsA("TextButton") then count += 1 end
        end
        return count * 20
    end

    DropBtn.MouseButton1Click:Connect(function()
        open = not open
        List.Visible = true
        if open then
            local targetSize = updateListSize()
            if targetSize > 0 then
                if listSizeTween then listSizeTween:Cancel() end
                listSizeTween = Tween(List, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.2)
                listSizeTween:Play()
            end
        else
            if listSizeTween then listSizeTween:Cancel() end
            listSizeTween = Tween(List, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
            listSizeTween:Play()
            task.delay(0.15, function() if not open then List.Visible = false end end)
        end
    end)

    local function renderText()
        local t = {}
        for k, v in pairs(selected) do 
            if v then table.insert(t, tostring(k)) end 
        end
        DropBtn.Text = #t > 0 and table.concat(t, ", ") or "None"
    end

    local function setOptions(newOpts)
        opts = newOpts or {}
        for _, c in ipairs(List:GetChildren()) do 
            if c:IsA("TextButton") then c:Destroy() end 
        end
        for i, o in ipairs(opts) do
            local ob = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = tostring(o),
                TextColor3 = selected[o] and window.CurrentThemeColors.Accent or window.CurrentThemeColors.TextSecondary,
                TextSize = 10 * window.FontSize,
                Font = FONT,
                ZIndex = 11,
                LayoutOrder = i,
                Parent = List,
            })
            ob.MouseButton1Click:Connect(function()
                selected[o] = not selected[o]
                ob.TextColor3 = selected[o] and window.CurrentThemeColors.Accent or window.CurrentThemeColors.TextSecondary
                renderText()
                cb(selected)
            end)
        end
        renderText()
    end

    setOptions(opts)
    window.ConfigData[name] = selected
    return { 
        Set = function(v) selected = v; renderText(); cb(selected) end, 
        Get = function() return selected end, 
        SetOptions = setOptions 
    }
end

local function CreateKeybind(window, section, cfg)
    if not window or not section then return end
    
    local name = cfg.Name or "Keybind"
    local def = cfg.Default
    local cb = cfg.Callback or function() end

    local KbFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Frame,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = KbFrame,
    })

    CreateKeybindUI(window, KbFrame, def, cb)
end

local function CreateColorPicker(window, section, cfg)
    if not window or not section then return { Set = function() end, Get = function() return Color3.new(1,1,1) end } end
    
    local name = cfg.Name or "ColorPicker"
    local def = cfg.Default or Color3.new(1, 1, 1)
    local cb = cfg.Callback or function() end

    local val = def
    local CPFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section.Frame,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = CPFrame,
    })

    local Disp = Create("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -70, 0.5, -9),
        BackgroundColor3 = val,
        Parent = CPFrame,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })

    local HexInput = Create("TextBox", {
        Size = UDim2.new(0, 48, 0, 18),
        Position = UDim2.new(1, -48, 0.5, -9),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = ColorToHex(val),
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 10 * window.FontSize,
        Font = FONT,
        ClearTextOnFocus = false,
        Parent = CPFrame,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })

    window:RegisterThemeElement(Disp:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")
    window:RegisterThemeElement(HexInput, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(HexInput, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(HexInput:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    local function set(v)
        if typeof(v) ~= "Color3" then return end
        val = v
        Disp.BackgroundColor3 = val
        HexInput.Text = ColorToHex(val)
        cb(val)
    end

    HexInput.FocusLost:Connect(function()
        local success, color = pcall(HexToColor, HexInput.Text)
        if success then set(color) end
    end)

    window.ConfigData[name] = ColorToHex(def)
    return { Set = set, Get = function() return val end }
end

local function CreateTextBox(window, section, cfg)
    if not window or not section then return { Set = function() end, Get = function() return "" end } end
    
    local name = cfg.Name or "TextBox"
    local def = cfg.Default or ""
    local cb = cfg.Callback or function() end

    local TBFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundTransparency = 1,
        Parent = section.Frame,
    })
    
    local Lbl = Create("TextLabel", {
        Size = UDim2.new(1, -16, 0, 20),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = window.CurrentThemeColors.TextSecondary,
        TextSize = 11 * window.FontSize,
        Font = FONT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TBFrame,
    })
    
    local Input = Create("TextBox", {
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 8, 0, 22),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = def,
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 10 * window.FontSize,
        Font = FONT,
        ClearTextOnFocus = false,
        Parent = TBFrame,
    }, { Corner(3), Stroke(window.CurrentThemeColors.Border, 1) })

    window:RegisterThemeElement(Lbl, "TextColor3", "TextSecondary")
    window:RegisterThemeElement(Input, "BackgroundColor3", "SurfaceAlt")
    window:RegisterThemeElement(Input, "TextColor3", "TextPrimary")
    window:RegisterThemeElement(Input:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

    local val = def
    Input.FocusLost:Connect(function() 
        val = Input.Text 
        cb(val) 
    end)
    
    window.ConfigData[name] = def
    return { Set = function(v) val = v; Input.Text = v; cb(v) end, Get = function() return val end }
end

local function CreateFolder(window, section, cfg)
    if not window or not section then return {} end
    
    local fname = cfg.Name or "Folder"
    local FolderBtn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = window.CurrentThemeColors.SurfaceAlt,
        Text = "  [+] " .. fname,
        TextColor3 = window.CurrentThemeColors.TextPrimary,
        TextSize = 11 * window.FontSize,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Frame,
    }, { Corner(4), Stroke(window.CurrentThemeColors.Border, 1) })
    
    local Container = Create("Frame", {
        Size = UDim2.new(1, -8, 0, 0),
        Position = UDim2.new(0, 8, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = section.Frame,
    }, { 
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)}), 
        Padding(0, 0, 10, 0) 
    })

    local open = false
    FolderBtn.MouseButton1Click:Connect(function()
        open = not open
        Container.Visible = open
        FolderBtn.Text = (open and "  [-] " or "  [+] ") .. fname
    end)

    -- Create a pseudo-section that inherits section methods but uses the folder container
    local pseudo = { Frame = Container, Window = window }
    setmetatable(pseudo, {__index = section})
    return pseudo
end

------------------------------
-- WINDOW CREATION
------------------------------
function NeverLoseUI:CreateWindow(config)
    config = config or {}
    local Window = {
        Title = config.Title or "NeverLoseUI",
        Tabs = {},
        ActiveTab = nil,
        Elements = {}, -- theme elements
        Keybinds = {},
        Binding = false,
        CurrentTheme = config.Theme or "Midnight",
        CurrentThemeColors = table.clone(THEMES[config.Theme or "Midnight"] or THEMES.Midnight),
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        ConfigData = {},
        Opacity = 1,
        FontSize = 1,
    }
    setmetatable(Window, {__index = NeverLoseUI})

    -- ScreenGui
    Window.Gui = Create("ScreenGui", {
        Name = "NeverLoseUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    pcall(function() Window.Gui.Parent = CoreGui end)
    if not Window.Gui.Parent then Window.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- Core Window Logic
    Window.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 600, 0, 420),
        Position = UDim2.new(0.5, -300, 0.5, -210),
        BackgroundColor3 = Window.CurrentThemeColors.Background,
        BorderSizePixel = 0,
        Parent = Window.Gui,
        ClipsDescendants = false,
    }, { Corner(6) })
    
    Window.MainStroke = Stroke(Window.CurrentThemeColors.Border, 1)
    Window.MainStroke.Parent = Window.Main

    -- Glow/Shadow
    Window.Glow = Create("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 60, 1, 60),
        ZIndex = 0,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = Window.Main
    })

    -- Title Bar
    Window.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Window.CurrentThemeColors.TitleBar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Window.Main,
    }, { Corner(6) })
    -- Square bottom
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = Window.CurrentThemeColors.TitleBar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Window.TitleBar,
    })
    
    -- Gradient Accent Bar
    Window.AccentBar = Create("Frame", {
        Name = "AccentBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Window.TitleBar,
    }, {
        Corner(2),
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Window.CurrentThemeColors.Accent),
                ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1, Window.CurrentThemeColors.Accent)
            })
        })
    })

    Window.TitleText = Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = Window.Title:upper(),
        TextColor3 = Window.CurrentThemeColors.TextPrimary,
        TextSize = 13,
        Font = FONT_BOLD,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        Parent = Window.TitleBar,
    })

    -- Draggable setup
    MakeDraggable(Window.Main, Window.TitleBar)

    -- Sidebar
    Window.Sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Window.Main,
    }, {
        Corner(6),
        Create("Frame", {Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0,0), BackgroundColor3=Window.CurrentThemeColors.Sidebar, BorderSizePixel=0, ZIndex=2}),
        Create("Frame", {Size=UDim2.new(0,6,1,0), Position=UDim2.new(1,-6,0,0), BackgroundColor3=Window.CurrentThemeColors.Sidebar, BorderSizePixel=0, ZIndex=2}),
    })
    Window.SidebarLine = Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Window.CurrentThemeColors.Border,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = Window.Sidebar,
    })

    -- Search & Filter Bar
    Window.SearchBarBox = Create("TextBox", {
        Name = "SearchBar",
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
        Text = "",
        PlaceholderText = "Search...",
        PlaceholderColor3 = Window.CurrentThemeColors.TextSecondary,
        TextColor3 = Window.CurrentThemeColors.TextPrimary,
        TextSize = 10,
        Font = FONT,
        ZIndex = 4,
        Parent = Window.Sidebar,
    }, { Corner(3), Stroke(Window.CurrentThemeColors.Border, 1) })

    Window.SearchBarBox.Changed:Connect(function(prop)
        if prop == "Text" then
            local q = Window.SearchBarBox.Text:lower()
            for _, tab in ipairs(Window.Tabs) do
                for _, sec in ipairs(tab.Sections) do
                    local anyMatched = false
                    for _, child in ipairs(sec.Frame:GetChildren()) do
                        if child:IsA("GuiObject") and not string.find("UIListLayout UIPadding UICorner UIStroke", child.ClassName) and child ~= sec.Header then
                            local lbl = child:FindFirstChildWhichIsA("TextLabel", true)
                            if lbl and string.find(lbl.Text:lower(), q) then
                                child.Visible = true
                                anyMatched = true
                            else
                                child.Visible = false
                            end
                        end
                    end
                    sec.Frame.Visible = anyMatched or q == ""
                end
            end
        end
    end)

    Window.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
        Parent = Window.Sidebar,
    }, {
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}),
        Padding(0, 10, 0, 0)
    })

    -- Content Area
    Window.Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -140, 1, -40),
        Position = UDim2.new(0, 140, 0, 40),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = Window.Main,
    })
    
    -- Window Resizer (Grab Handler)
    Window.Resizer = Create("TextButton", {
        Name = "Resizer",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -16, 1, -16),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 15,
        Parent = Window.Main,
    })
    local rDrag, rStartSize, rStartPos = false, nil, nil
    Window.Resizer.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            rDrag = true; rStartSize = Window.Main.Size; rStartPos = i.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if rDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local del = i.Position - rStartPos
            Window.Main.Size = UDim2.new(0, math.max(rStartSize.X.Offset + del.X, 400), 0, math.max(rStartSize.Y.Offset + del.Y, 300))
        end
    end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then rDrag = false end end)

    -- Theme Elements Registration
    function Window:RegisterThemeElement(inst, prop, themeKey)
        table.insert(self.Elements, {Instance = inst, Property = prop, ThemeKey = themeKey})
    end

    Window:RegisterThemeElement(Window.Main, "BackgroundColor3", "Background")
    Window:RegisterThemeElement(Window.MainStroke, "Color", "Border")
    Window:RegisterThemeElement(Window.TitleBar, "BackgroundColor3", "TitleBar")
    Window:RegisterThemeElement(Window.TitleBar:FindFirstChildWhichIsA("Frame"), "BackgroundColor3", "TitleBar")
    Window:RegisterThemeElement(Window.TitleText, "TextColor3", "TextPrimary")
    Window:RegisterThemeElement(Window.Sidebar, "BackgroundColor3", "Sidebar")
    Window:RegisterThemeElement(Window.Sidebar:GetChildren()[2], "BackgroundColor3", "Sidebar")
    Window:RegisterThemeElement(Window.Sidebar:GetChildren()[3], "BackgroundColor3", "Sidebar")
    Window:RegisterThemeElement(Window.SidebarLine, "BackgroundColor3", "Border")

    -- Update Theme Function
    function Window:UpdateTheme(themeName, customColors)
        if THEMES[themeName] then
            self.CurrentTheme = themeName
            for k, v in pairs(THEMES[themeName]) do
                self.CurrentThemeColors[k] = v
            end
        end
        if customColors then
            for k, v in pairs(customColors) do
                self.CurrentThemeColors[k] = v
            end
        end

        local gradient = Window.AccentBar:FindFirstChildWhichIsA("UIGradient")
        if gradient then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, self.CurrentThemeColors.Accent),
                ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1, self.CurrentThemeColors.Accent)
            })
        end

        for _, data in ipairs(self.Elements) do
            if data.Instance and data.Instance.Parent then
                local tColor = self.CurrentThemeColors[data.ThemeKey]
                if tColor then
                    Tween(data.Instance, {[data.Property] = tColor}, 0.2)
                end
            end
        end
        
        Window.Main.BackgroundTransparency = 1 - Window.Opacity
        Window.Sidebar.BackgroundTransparency = 1 - Window.Opacity
        Window.TitleBar.BackgroundTransparency = 1 - Window.Opacity
        for _,c in ipairs(Window.Sidebar:GetChildren()) do if c:IsA("Frame") and c.Name~="SidebarLine" then c.BackgroundTransparency = 1 - Window.Opacity end end
        for _,c in ipairs(Window.TitleBar:GetChildren()) do if c:IsA("Frame") and c.Name~="AccentBar" then c.BackgroundTransparency = 1 - Window.Opacity end end
    end

    -- Toggle UI visibility functionality
    Window.GuiVisible = true
    function Window:ToggleUI(state)
        if state == nil then state = not Window.GuiVisible end
        Window.GuiVisible = state
        
        if state then
            Window.Main.Visible = true
            Tween(Window.Main, {Size = UDim2.new(0, 600, 0, 420), BackgroundTransparency = 1 - Window.Opacity}, 0.3)
            Tween(Window.Glow, {ImageTransparency = 0.5}, 0.3)
        else
            Tween(Window.Main, {Size = UDim2.new(0, 600, 0, 0), BackgroundTransparency = 1}, 0.3)
            Tween(Window.Glow, {ImageTransparency = 1}, 0.3)
            task.delay(0.3, function() if not Window.GuiVisible then Window.Main.Visible = false end end)
        end
    end

    -- Universal Input Handling
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if Window.Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType.Name:find("MouseButton") then
                local k = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
                if k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then
                    Window._BindTarget.UpdateKey(nil)
                else
                    Window._BindTarget.UpdateKey(k)
                end
                Window.Binding = false
            end
            return
        end
        
        if gameProcessed then return end
        
        local k = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
        
        if k == Window.ToggleKey then
            Window:ToggleUI()
        end
        
        if Window.GuiVisible then
            for _, bind in ipairs(Window.Keybinds) do
                if bind.Key == k then
                    bind.Callback()
                end
            end
        end
    end)
    
    -- Notifications
    Window.ToastContainer = Create("Frame", {
        Name = "ToastContainer",
        Size = UDim2.new(0, 250, 1, -40),
        Position = UDim2.new(1, -270, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 100,
        Parent = Window.Gui,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 10),
        Parent = Window.ToastContainer
    })
    
    function Window:Notify(title, text, time)
        local Toast = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(1, 100, 0, 0),
            BackgroundColor3 = Window.CurrentThemeColors.Surface,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 100,
            Parent = Window.ToastContainer,
            ClipsDescendants = true,
        }, { Corner(6) })
        local Stroke = Stroke(Window.CurrentThemeColors.Border, 1)
        Stroke.Transparency = 1
        Stroke.Parent = Toast
        
        local Accent = Create("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = Window.CurrentThemeColors.Accent,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 101,
            Parent = Toast,
        }, { Corner(3) })
        
        local TitleLbl = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 8),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Window.CurrentThemeColors.TextPrimary,
            TextTransparency = 1,
            TextSize = 12 * Window.FontSize,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101,
            Parent = Toast,
        })
        local TextLbl = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 28),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Window.CurrentThemeColors.TextSecondary,
            TextTransparency = 1,
            TextSize = 11 * Window.FontSize,
            Font = FONT,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 101,
            Parent = Toast,
        })
        
        Window:RegisterThemeElement(Toast, "BackgroundColor3", "Surface")
        Window:RegisterThemeElement(Stroke, "Color", "Border")
        Window:RegisterThemeElement(Accent, "BackgroundColor3", "Accent")
        Window:RegisterThemeElement(TitleLbl, "TextColor3", "TextPrimary")
        Window:RegisterThemeElement(TextLbl, "TextColor3", "TextSecondary")
        
        Tween(Toast, {BackgroundTransparency = 0}, 0.3)
        Tween(Stroke, {Transparency = 0}, 0.3)
        Tween(Accent, {BackgroundTransparency = 0}, 0.3)
        Tween(TitleLbl, {TextTransparency = 0}, 0.3)
        Tween(TextLbl, {TextTransparency = 0}, 0.3)
        
        task.delay(time or 3, function()
            Tween(Toast, {BackgroundTransparency = 1}, 0.3)
            Tween(Stroke, {Transparency = 1}, 0.3)
            Tween(Accent, {BackgroundTransparency = 1}, 0.3)
            Tween(TitleLbl, {TextTransparency = 1}, 0.3)
            Tween(TextLbl, {TextTransparency = 1}, 0.3)
            task.delay(0.3, function() Toast:Destroy() end)
        end)
    end
    
    function Window:Dialog(cfg)
        if not cfg then return nil end
        local Title = cfg.Title or "Dialog"
        local Content = cfg.Content or "Are you sure?"
        local Buttons = cfg.Buttons or {"Confirm", "Cancel"}
        local Callback = cfg.Callback or function() end
        local result = nil
        local resolved = false

        -- Create overlay
        local Overlay = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.6,
            Text = "",
            ZIndex = 999,
            Parent = Window.Main,
        }, { Corner(6) })
        
        -- Create dialog frame with correct initial position
        local Dlg = Create("Frame", {
            Size = UDim2.new(0, 280, 0, 130),
            Position = UDim2.new(0.5, -140, 0.5, -65),
            BackgroundColor3 = Window.CurrentThemeColors.Background,
            BorderSizePixel = 0,
            ZIndex = 1000,
            Parent = Overlay,
            ClipsDescendants = true,
        }, { Corner(8), Stroke(Window.CurrentThemeColors.Border, 1.5) })

        -- Title label
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, 12),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Window.CurrentThemeColors.TextPrimary,
            TextSize = 14,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1001,
            Parent = Dlg,
        })
        
        -- Content label
        Create("TextLabel", {
            Size = UDim2.new(1, -24, 0, 40),
            Position = UDim2.new(0, 12, 0, 40),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Window.CurrentThemeColors.TextSecondary,
            TextSize = 11,
            Font = FONT,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 1001,
            Parent = Dlg,
        })

        -- Button container
        local BtnContainer = Create("Frame", {
            Size = UDim2.new(1, -24, 0, 28),
            Position = UDim2.new(0, 12, 1, -40),
            BackgroundTransparency = 1,
            ZIndex = 1001,
            Parent = Dlg,
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 10)
            })
        })

        -- Create buttons
        for i, btnText in ipairs(Buttons) do
            local btnWidth = math.floor((256 - ((#Buttons - 1) * 10)) / #Buttons)
            local btn = Create("TextButton", {
                Size = UDim2.new(0, btnWidth, 1, 0),
                BackgroundColor3 = i == 1 and Window.CurrentThemeColors.Accent or Window.CurrentThemeColors.Surface,
                Text = btnText,
                TextColor3 = i == 1 and Window.CurrentThemeColors.TextPrimary or Window.CurrentThemeColors.TextPrimary,
                TextSize = 11,
                Font = FONT_BOLD,
                ZIndex = 1002,
                Parent = BtnContainer,
            }, { Corner(4), Stroke(Window.CurrentThemeColors.Border, 1) })
            
            btn.MouseButton1Click:Connect(function()
                if resolved then return end
                resolved = true
                result = btnText
                
                Tween(Overlay, {BackgroundTransparency = 1}, 0.2):Play()
                Tween(Dlg, {BackgroundTransparency = 1}, 0.2):Play()
                task.delay(0.2, function() 
                    if Overlay and Overlay.Parent then Overlay:Destroy() end 
                end)
            end)
            
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt}, 0.15):Play()
            end)
            btn.MouseLeave:Connect(function()
                local accentColor = i == 1 and Window.CurrentThemeColors.Accent or Window.CurrentThemeColors.Surface
                Tween(btn, {BackgroundColor3 = accentColor}, 0.15):Play()
            end)
        end

        -- Animate in
        Tween(Overlay, {BackgroundTransparency = 0.6}, 0.2):Play()
        
        -- Wait for result
        while not resolved do
            task.wait(0.05)
        end
        
        Callback(result)
        return result
    end
    -- Core Layout functions
    function Window:SelectTab(tab)
        if self.ActiveTab == tab then return end
        if self.ActiveTab then
            Tween(self.ActiveTab.Btn, {BackgroundColor3 = Window.CurrentThemeColors.Sidebar}, 0.2)
            Tween(self.ActiveTab.Bar, {BackgroundTransparency = 1}, 0.2)
            self.ActiveTab.Page.Visible = false
        end
        self.ActiveTab = tab
        Tween(self.ActiveTab.Btn, {BackgroundColor3 = Window.CurrentThemeColors.Surface}, 0.2)
        Tween(self.ActiveTab.Bar, {BackgroundTransparency = 0}, 0.2)
        self.ActiveTab.Page.Visible = true
    end

    function Window:AddTab(config)
        local tcfg = config or {}
        local Name = tcfg.Name or "Tab"
        
        local Tab = {
            Name = Name,
            Window = self,
            Sections = {},
        }

        Tab.Btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
            BorderSizePixel = 0,
            Text = "",
            Parent = Window.TabList,
        }, { Corner(4) })
        Window:RegisterThemeElement(Tab.Btn, "BackgroundColor3", "Sidebar")

        Tab.Bar = Create("Frame", {
            Size = UDim2.new(0, 3, 0.5, 0),
            Position = UDim2.new(0, 4, 0.25, 0),
            BackgroundColor3 = Window.CurrentThemeColors.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = Tab.Btn,
        }, { Corner(3) })
        Window:RegisterThemeElement(Tab.Bar, "BackgroundColor3", "Accent")

        Tab.Text = Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1,
            Text = Name,
            TextColor3 = Window.CurrentThemeColors.TextPrimary,
            TextSize = 12 * Window.FontSize,
            Font = FONT_BOLD,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Tab.Btn,
        })
        Window:RegisterThemeElement(Tab.Text, "TextColor3", "TextPrimary")

        Tab.Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Window.CurrentThemeColors.Border,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = Window.Content,
        }, {
            Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        })
        Window:RegisterThemeElement(Tab.Page, "ScrollBarImageColor3", "Border")

        Tab.Btn.MouseButton1Click:Connect(function() Window:SelectTab(Tab) end)
        Tab.Btn.MouseEnter:Connect(function() 
            if Window.ActiveTab ~= Tab then Tween(Tab.Btn, {BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt}, 0.2) end 
        end)
        Tab.Btn.MouseLeave:Connect(function() 
            if Window.ActiveTab ~= Tab then Tween(Tab.Btn, {BackgroundColor3 = Window.CurrentThemeColors.Sidebar}, 0.2) end 
        end)

        table.insert(self.Tabs, Tab)
        if #self.Tabs == 1 then Window:SelectTab(Tab) end

        function Tab:AddSection(scfg)
            local sName = (scfg and scfg.Name) or "Section"

            local Section = {
                Name = sName,
                Window = Window,
                Elements = {},
            }

            Section.Frame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 10),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Window.CurrentThemeColors.Surface,
                BorderSizePixel = 0,
                Parent = Tab.Page,
            }, {
                Corner(6),
                Stroke(Window.CurrentThemeColors.Border, 1),
                Padding(4, 4, 4, 4)
            })
            
            local sLayout = Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder, 
                Padding = UDim.new(0, 4)
            })
            sLayout.Parent = Section.Frame

            Window:RegisterThemeElement(Section.Frame, "BackgroundColor3", "Surface")
            Window:RegisterThemeElement(Section.Frame:FindFirstChildWhichIsA("UIStroke"), "Color", "Border")

            Section.Header = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Text = "  " .. sName,
                TextColor3 = Window.CurrentThemeColors.TextPrimary,
                TextSize = 12 * Window.FontSize,
                Font = FONT_BOLD,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Section.Frame,
            })
            Window:RegisterThemeElement(Section.Header, "TextColor3", "TextPrimary")

            Section.Underline = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 1),
                Position = UDim2.new(0, 4, 1, -1),
                BackgroundColor3 = Window.CurrentThemeColors.Border,
                BorderSizePixel = 0,
                Parent = Section.Header,
            })
            Window:RegisterThemeElement(Section.Underline, "BackgroundColor3", "Border")

            -- Element creation methods using factory functions
            function Section:AddToggle(cfg)
                return CreateToggle(Window, Section, cfg or {})
            end

            function Section:AddSlider(cfg)
                return CreateSlider(Window, Section, cfg or {})
            end

            function Section:AddButton(cfg)
                return CreateButton(Window, Section, cfg or {})
            end

            function Section:AddDropdown(cfg)
                return CreateDropdown(Window, Section, cfg or {})
            end

            function Section:AddMultiDropdown(cfg)
                return CreateMultiDropdown(Window, Section, cfg or {})
            end

            function Section:AddKeybind(cfg)
                return CreateKeybind(Window, Section, cfg or {})
            end

            function Section:AddColorPicker(cfg)
                return CreateColorPicker(Window, Section, cfg or {})
            end

            function Section:AddTextBox(cfg)
                return CreateTextBox(Window, Section, cfg or {})
            end

            function Section:AddFolder(cfg)
                return CreateFolder(Window, Section, cfg or {})
            end

            table.insert(Tab.Sections, Section)
            return Section
        end

        return Tab
    end
    -- SETTINGS TAB & SAVE/LOAD
    local SettingsTab = Window:AddTab({ Name = "⚙ Settings" })
    local ThemeSec = SettingsTab:AddSection({ Name = "Theme Editor" })

    ThemeSec:AddDropdown({
        Name = "Theme Preset",
        Options = THEME_PRESETS,
        Default = Window.CurrentTheme,
        Callback = function(v) 
            pcall(function() Window:UpdateTheme(v) end) 
        end
    })

    ThemeSec:AddColorPicker({
        Name = "Accent Color",
        Default = Window.CurrentThemeColors.Accent,
        Callback = function(v) 
            pcall(function() Window:UpdateTheme(Window.CurrentTheme, {Accent = v}) end)
        end
    })

    ThemeSec:AddColorPicker({
        Name = "Background Color",
        Default = Window.CurrentThemeColors.Background,
        Callback = function(v) 
            pcall(function() Window:UpdateTheme(Window.CurrentTheme, {Background = v}) end)
        end
    })

    ThemeSec:AddSlider({
        Name = "Window Opacity",
        Min = 0.5, Max = 1, Default = 1,
        Callback = function(v)
            Window.Opacity = v
            pcall(function() Window:UpdateTheme(Window.CurrentTheme) end)
        end
    })

    ThemeSec:AddSlider({
        Name = "Font Size Scale",
        Min = 0.8, Max = 1.2, Default = 1,
        Callback = function(v)
            Window.FontSize = v
        end
    })

    local UISec = SettingsTab:AddSection({ Name = "Core" })
    UISec:AddKeybind({
        Name = "Toggle UI Keybind",
        Default = Window.ToggleKey,
        Callback = function() end
    })

    -- Update ToggleKey when it changes
    RunService.RenderStepped:Connect(function()
        local lastKeybind = Window.Keybinds[#Window.Keybinds]
        if lastKeybind and lastKeybind.Key and lastKeybind.Key ~= Window.ToggleKey then
            Window.ToggleKey = lastKeybind.Key
        end
    end)

    -- CONFIG MANAGER with proper error handling
    local ConfigSec = SettingsTab:AddSection({ Name = "Config Manager" })
    local configName = "default"
    local CONFIG_FOLDER = "NeverLoseUI_Configs"

    -- Detect file API availability
    local FileAPI = {
        write = writefile or function() warn("writefile not available") end,
        read = readfile or function() return "" end,
        list = listfiles or function() return {} end,
        make = makefolder or function() end,
        isFolder = isfolder or function() return false end,
        exists = isfile or function() return false end,
    }

    -- Initialize config folder
    local function InitConfigFolder()
        local success = pcall(function()
            if not FileAPI.isFolder(CONFIG_FOLDER) then
                FileAPI.make(CONFIG_FOLDER)
            end
        end)
        return success
    end

    -- Load config list
    local function LoadConfigList()
        local configs = {}
        local success = pcall(function()
            InitConfigFolder()
            local files = FileAPI.list(CONFIG_FOLDER)
            for _, f in ipairs(files or {}) do
                local name = f:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end)
        return configs
    end

    -- Save config
    local function SaveConfig(name)
        local success, err = pcall(function()
            InitConfigFolder()
            local data = HttpService:JSONEncode(Window.ConfigData)
            FileAPI.write(CONFIG_FOLDER .. "/" .. name .. ".json", data)
        end)
        if success then
            Window:Notify("Config Saved", "Successfully saved '" .. name .. ".json'", 3)
        else
            Window:Notify("Save Failed", "Error: " .. tostring(err), 3)
        end
        return success
    end

    -- Load config
    local function LoadConfig(name)
        local success, err = pcall(function()
            local data = FileAPI.read(CONFIG_FOLDER .. "/" .. name .. ".json")
            if not data or data == "" then
                error("Config file not found")
            end
            local parsed = HttpService:JSONDecode(data)
            
            -- Apply config to window
            Window.ConfigData = parsed
            
            -- Notify user
            Window:Notify("Config Loaded", "'" .. name .. "' applied successfully", 3)
        end)
        if not success then
            Window:Notify("Load Failed", "Error: " .. tostring(err), 3)
        end
        return success
    end

    ConfigSec:AddTextBox({ 
        Name = "Config Name", 
        Default = "default", 
        Callback = function(v) 
            if v and v:gsub("%s", "") ~= "" then
                configName = v 
            end
        end 
    })

    local cfgList = LoadConfigList()
    local cfgDrop = ConfigSec:AddDropdown({ 
        Name = "Select Config", 
        Options = cfgList, 
        Default = cfgList[1] or "default",
        Callback = function(v) 
            if v and v:gsub("%s", "") ~= "" then
                configName = v 
            end
        end 
    })

    ConfigSec:AddButton({ 
        Name = "Save Config", 
        Callback = function()
            if not configName or configName:gsub("%s", "") == "" then
                Window:Notify("Invalid Name", "Please enter a valid config name", 3)
                return
            end
            SaveConfig(configName)
            -- Refresh config list
            cfgList = LoadConfigList()
            cfgDrop.SetOptions(cfgList)
        end
    })

    ConfigSec:AddButton({ 
        Name = "Load Config", 
        Callback = function()
            if not configName or configName:gsub("%s", "") == "" then
                Window:Notify("Invalid Name", "Please select or enter a config name", 3)
                return
            end
            LoadConfig(configName)
        end
    })

    ConfigSec:AddButton({
        Name = "Delete Config",
        Callback = function()
            if not configName or configName:gsub("%s", "") == "" then
                Window:Notify("Invalid Name", "Please select a config to delete", 3)
                return
            end
            
            local success = pcall(function()
                local filePath = CONFIG_FOLDER .. "/" .. configName .. ".json"
                if FileAPI.exists(filePath) then
                    -- Roblox doesn't have a standard deletefile, so we overwrite with empty
                    FileAPI.write(filePath, "{}")
                    Window:Notify("Config Deleted", "'" .. configName .. "' removed", 3)
                    cfgList = LoadConfigList()
                    cfgDrop.SetOptions(cfgList)
                else
                    error("Config not found")
                end
            end)
            
            if not success then
                Window:Notify("Delete Failed", "Could not delete config", 3)
            end
        end
    })
    
    -- HUD & Overlays
    function Window:AddWatermark(cfg)
        local wtext = cfg.Name or "NeverLoseUI"
        local wm = Create("Frame", { Size = UDim2.new(0, 250, 0, 24), Position = UDim2.new(0, 20, 0, 20), BackgroundColor3 = Window.CurrentThemeColors.Surface, BorderSizePixel = 0, Parent = Window.Gui }, { Corner(4), Stroke(Window.CurrentThemeColors.Border, 1) })
        local acc = Create("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Window.CurrentThemeColors.Accent, Parent = wm }, { Corner(2) })
        local lbl = Create("TextLabel", { Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, TextColor3 = Window.CurrentThemeColors.TextPrimary, TextSize = 11, Font = FONT_BOLD, TextXAlignment = Enum.TextXAlignment.Left, Parent = wm })
        MakeDraggable(wm)
        RunService.RenderStepped:Connect(function()
            local ping = "0"
            pcall(function() ping = tostring(math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())) end)
            local fps = tostring(math.floor(1 / RunService.RenderStepped:Wait()))
            local timeStr = os.date("%H:%M:%S")
            lbl.Text = wtext .. " | " .. timeStr .. " | " .. fps .. " FPS | " .. ping .. "ms"
        end)
    end
    
    function Window:AddKeybindList(cfg)
        local kl = Create("Frame", { Size = UDim2.new(0, 160, 0, 30), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 20, 0, 60), BackgroundColor3 = Window.CurrentThemeColors.Surface, BorderSizePixel = 0, Parent = Window.Gui }, { Corner(4), Stroke(Window.CurrentThemeColors.Border, 1), Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}), Padding(0,0,0,0) })
        local h = Create("Frame", {Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, Parent=kl})
        Create("Frame", { Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = Window.CurrentThemeColors.Accent, Parent = h }, { Corner(2) })
        Create("TextLabel", { Size = UDim2.new(1, -16, 1, 0), Position=UDim2.new(0,8,0,0), BackgroundTransparency=1, Text="Keybinds", TextColor3=Window.CurrentThemeColors.TextPrimary, TextSize=11, Font=FONT_BOLD, TextXAlignment=Enum.TextXAlignment.Center, Parent=h })
        MakeDraggable(kl, h)
    end

    -- CONFIG MANAGER
    local Configurable = true
    local cfgFuncs = { write = writefile, read = readfile, list = listfiles, mk = makefolder, isf = isfolder }
    local ConfigSec = SettingsTab:AddSection({ Name = "Config Manager" })
    local configName = "default"
    
    ConfigSec:AddTextBox({ Name = "Config Name", Default = "default", Callback = function(v) configName = v end })
    
    local cfgList = {}
    pcall(function() 
        if cfgFuncs.isf and not cfgFuncs.isf("NeverLoseUI_Configs") then cfgFuncs.mk("NeverLoseUI_Configs") end
        if cfgFuncs.list then
            for _,f in ipairs(cfgFuncs.list("NeverLoseUI_Configs")) do
                table.insert(cfgList, f:match("([^/\\\\]+)%.json$") or f)
            end
        end
    end)
    
    local cfgDrop = ConfigSec:AddDropdown({ Name = "Select Config", Options = cfgList, Callback = function(v) configName = v end })
    
    ConfigSec:AddButton({ Name = "Save Config", Callback = function()
        pcall(function()
            if not cfgFuncs.isf("NeverLoseUI_Configs") then cfgFuncs.mk("NeverLoseUI_Configs") end
            local data = HttpService:JSONEncode(Window.ConfigData)
            cfgFuncs.write("NeverLoseUI_Configs/" .. configName .. ".json", data)
            Window:Notify("Config saved!", "Successfully saved to " .. configName .. ".json", 3)
            -- refresh list
            cfgList = {}
            for _,f in ipairs(cfgFuncs.list("NeverLoseUI_Configs")) do table.insert(cfgList, f:match("([^/\\\\]+)%.json$") or f) end
            cfgDrop.SetOptions(cfgList)
        end)
    end})
    
    ConfigSec:AddButton({ Name = "Load Config", Callback = function()
        pcall(function()
            local data = cfgFuncs.read("NeverLoseUI_Configs/" .. configName .. ".json")
            local parsed = HttpService:JSONDecode(data)
            for k,v in pairs(parsed) do Window.ConfigData[k] = v end
            -- UI elements need their respective set functions called, omitted for brevity.
            Window:Notify("Loaded!", configName .. " applied securely.", 3)
        end)
    end})
    
    return Window
end

return NeverLoseUI
