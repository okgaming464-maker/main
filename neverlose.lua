local NeverLoseUI   = {}
NeverLoseUI.__index = NeverLoseUI

local VERSION = "3.0.0"

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")

local THEMES = {
    Midnight = {
        Background   = Color3.fromRGB(15,  15,  20),
        Surface      = Color3.fromRGB(24,  24,  32),
        SurfaceAlt   = Color3.fromRGB(32,  32,  42),
        Border       = Color3.fromRGB(45,  45,  60),
        Accent       = Color3.fromRGB(99,  102, 241),
        TextPrimary  = Color3.fromRGB(250, 250, 255),
        TextSecondary= Color3.fromRGB(160, 160, 175),
        TitleBar     = Color3.fromRGB(20,  20,  26),
        Sidebar      = Color3.fromRGB(18,  18,  24),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
    Crimson = {
        Background   = Color3.fromRGB(16,  10,  10),
        Surface      = Color3.fromRGB(24,  16,  16),
        SurfaceAlt   = Color3.fromRGB(32,  22,  22),
        Border       = Color3.fromRGB(50,  30,  30),
        Accent       = Color3.fromRGB(220, 38,  38),
        TextPrimary  = Color3.fromRGB(255, 240, 240),
        TextSecondary= Color3.fromRGB(180, 140, 140),
        TitleBar     = Color3.fromRGB(22,  12,  12),
        Sidebar      = Color3.fromRGB(20,  14,  14),
        Danger       = Color3.fromRGB(248, 113, 113),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(250, 204, 21),
    },
    Emerald = {
        Background   = Color3.fromRGB(10,  16,  12),
        Surface      = Color3.fromRGB(16,  24,  18),
        SurfaceAlt   = Color3.fromRGB(22,  32,  24),
        Border       = Color3.fromRGB(35,  50,  40),
        Accent       = Color3.fromRGB(16,  185, 129),
        TextPrimary  = Color3.fromRGB(240, 255, 245),
        TextSecondary= Color3.fromRGB(140, 180, 150),
        TitleBar     = Color3.fromRGB(12,  20,  16),
        Sidebar      = Color3.fromRGB(14,  22,  18),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(52,  211, 153),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
    Amethyst = {
        Background   = Color3.fromRGB(14,  10,  18),
        Surface      = Color3.fromRGB(22,  16,  28),
        SurfaceAlt   = Color3.fromRGB(30,  22,  38),
        Border       = Color3.fromRGB(45,  30,  55),
        Accent       = Color3.fromRGB(168, 85,  247),
        TextPrimary  = Color3.fromRGB(250, 240, 255),
        TextSecondary= Color3.fromRGB(170, 150, 180),
        TitleBar     = Color3.fromRGB(18,  12,  22),
        Sidebar      = Color3.fromRGB(20,  14,  26),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
    Ocean = {
        Background   = Color3.fromRGB(10,  15,  20),
        Surface      = Color3.fromRGB(16,  22,  30),
        SurfaceAlt   = Color3.fromRGB(22,  30,  40),
        Border       = Color3.fromRGB(30,  45,  60),
        Accent       = Color3.fromRGB(6,   182, 212),
        TextPrimary  = Color3.fromRGB(240, 250, 255),
        TextSecondary= Color3.fromRGB(140, 170, 190),
        TitleBar     = Color3.fromRGB(12,  18,  24),
        Sidebar      = Color3.fromRGB(14,  20,  28),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
    Sunset = {
        Background   = Color3.fromRGB(20,  14,  10),
        Surface      = Color3.fromRGB(30,  20,  16),
        SurfaceAlt   = Color3.fromRGB(40,  28,  22),
        Border       = Color3.fromRGB(60,  40,  30),
        Accent       = Color3.fromRGB(249, 115, 22),
        TextPrimary  = Color3.fromRGB(255, 245, 240),
        TextSecondary= Color3.fromRGB(190, 160, 140),
        TitleBar     = Color3.fromRGB(24,  16,  12),
        Sidebar      = Color3.fromRGB(26,  18,  14),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(250, 204, 21),
    },
    Rose = {
        Background   = Color3.fromRGB(18,  10,  14),
        Surface      = Color3.fromRGB(28,  16,  22),
        SurfaceAlt   = Color3.fromRGB(38,  24,  30),
        Border       = Color3.fromRGB(55,  30,  45),
        Accent       = Color3.fromRGB(236, 72,  153),
        TextPrimary  = Color3.fromRGB(255, 240, 248),
        TextSecondary= Color3.fromRGB(180, 150, 165),
        TitleBar     = Color3.fromRGB(22,  12,  18),
        Sidebar      = Color3.fromRGB(24,  14,  20),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
    Monochrome = {
        Background   = Color3.fromRGB(12,  12,  12),
        Surface      = Color3.fromRGB(20,  20,  20),
        SurfaceAlt   = Color3.fromRGB(28,  28,  28),
        Border       = Color3.fromRGB(45,  45,  45),
        Accent       = Color3.fromRGB(240, 240, 240),
        TextPrimary  = Color3.fromRGB(250, 250, 250),
        TextSecondary= Color3.fromRGB(150, 150, 150),
        TitleBar     = Color3.fromRGB(16,  16,  16),
        Sidebar      = Color3.fromRGB(18,  18,  18),
        Danger       = Color3.fromRGB(239, 68,  68),
        Success      = Color3.fromRGB(34,  197, 94),
        Warning      = Color3.fromRGB(234, 179, 8),
    },
}

local THEME_PRESETS = {
    "Midnight","Crimson","Emerald","Amethyst",
    "Ocean","Sunset","Rose","Monochrome",
}

local FONT      = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold
local FONT_SEMI = Enum.Font.Gotham

local function Tween(obj, props, time, style, dir)
    TweenService:Create(
        obj,
        TweenInfo.new(
            time  or 0.15,
            style or Enum.EasingStyle.Quad,
            dir   or Enum.EasingDirection.Out
        ),
        props
    ):Play()
end

local function Spring(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        props
    ):Play()
end

local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Corner(radius)
    return Create("UICorner", { CornerRadius = UDim.new(0, radius or 4) })
end

local function MakeStroke(color, thickness)
    return Create("UIStroke", { Color = color, Thickness = thickness or 1 })
end

local function Padding(t, b, l, r)
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingRight  = UDim.new(0, r or 0),
    })
end

local function ColorToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

local function HexToColor(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return Color3.new(1,1,1) end
    local r = tonumber("0x"..hex:sub(1,2))
    local g = tonumber("0x"..hex:sub(3,4))
    local b = tonumber("0x"..hex:sub(5,6))
    if not (r and g and b) then return Color3.new(1,1,1) end
    return Color3.fromRGB(r, g, b)
end

local function MakeDraggable(frame, handle)
    handle = handle or frame

    local dragging    = false
    local dragInput   = nil
    local dragStart   = nil
    local startPos    = nil
    local momentum    = Vector2.new(0, 0)
    local lastMousePos= Vector2.new(0, 0)
    local DAMPING     = 0.82
    local MAX_MOM     = 40

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            momentum  = Vector2.new(0, 0)

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
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            local raw = Vector2.new(
                input.Position.X - lastMousePos.X,
                input.Position.Y - lastMousePos.Y
            )
            momentum = Vector2.new(
                math.clamp(raw.X, -MAX_MOM, MAX_MOM),
                math.clamp(raw.Y, -MAX_MOM, MAX_MOM)
            )
            lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not dragging and (math.abs(momentum.X) > 0.05 or math.abs(momentum.Y) > 0.05) then
            momentum = momentum * DAMPING
            local p  = frame.Position
            frame.Position = UDim2.new(
                p.X.Scale, p.X.Offset + momentum.X,
                p.Y.Scale, p.Y.Offset + momentum.Y
            )
        end
    end)
end

local KeyNames = {
    [Enum.KeyCode.RightShift]   = "RShift",
    [Enum.KeyCode.LeftShift]    = "LShift",
    [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftControl]  = "LCtrl",
    [Enum.KeyCode.RightAlt]     = "RAlt",
    [Enum.KeyCode.LeftAlt]      = "LAlt",
    [Enum.KeyCode.Insert]       = "Ins",
    [Enum.KeyCode.Delete]       = "Del",
    [Enum.KeyCode.Backspace]    = "Bksp",
    [Enum.KeyCode.Escape]       = "Esc",
    [Enum.UserInputType.MouseButton1] = "MB1",
    [Enum.UserInputType.MouseButton2] = "MB2",
    [Enum.UserInputType.MouseButton3] = "MB3",
}

local function GetKeyName(key)
    if not key then return "None" end
    if KeyNames[key] then return KeyNames[key] end
    return typeof(key) == "EnumItem" and key.Name or "None"
end

function NeverLoseUI:CreateWindow(config)
    config = config or {}

    local Window = {
        Title             = config.Title     or "NeverLoseUI",
        Tabs              = {},
        ActiveTab         = nil,
        Elements          = {},
        Keybinds          = {},
        Binding           = false,
        _BindTarget       = nil,
        CurrentTheme      = config.Theme     or "Midnight",
        CurrentThemeColors= table.clone(THEMES[config.Theme or "Midnight"] or THEMES.Midnight),
        ToggleKey         = config.ToggleKey or Enum.KeyCode.RightShift,
        ConfigData        = {},
        Opacity           = 1,
        FontSize          = 1,
        GuiVisible        = true,
    }
    setmetatable(Window, { __index = NeverLoseUI })

    Window.Gui = Create("ScreenGui", {
        Name            = "NeverLoseUI_v3",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        DisplayOrder    = 100,
    })
    pcall(function() Window.Gui.Parent = CoreGui end)
    if not Window.Gui.Parent then
        Window.Gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    Window.GlowFrame = Create("ImageLabel", {
        Name               = "Glow",
        AnchorPoint        = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position           = UDim2.new(0.5, 0, 0.5, 0),
        Size               = UDim2.new(0, 660, 0, 480),
        ZIndex             = 0,
        Image              = "rbxassetid://5028857084",
        ImageColor3        = Color3.new(0, 0, 0),
        ImageTransparency  = 0.45,
        ScaleType          = Enum.ScaleType.Slice,
        SliceCenter        = Rect.new(24, 24, 276, 276),
        Parent             = Window.Gui,
    })

    Window.Main = Create("Frame", {
        Name             = "Main",
        Size             = UDim2.new(0, 620, 0, 440),
        Position         = UDim2.new(0.5, -310, 0.5, -220),
        BackgroundColor3 = Window.CurrentThemeColors.Background,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Parent           = Window.Gui,
    }, { Corner(8) })

    Window.MainStroke = MakeStroke(Window.CurrentThemeColors.Border, 1)
    Window.MainStroke.Parent = Window.Main

    Window.Main:GetPropertyChangedSignal("Position"):Connect(function()
        Window.GlowFrame.Position = UDim2.new(
            Window.Main.Position.X.Scale,
            Window.Main.Position.X.Offset + Window.Main.AbsoluteSize.X / 2,
            Window.Main.Position.Y.Scale,
            Window.Main.Position.Y.Offset + Window.Main.AbsoluteSize.Y / 2
        )
    end)

    Window.TitleBar = Create("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Window.CurrentThemeColors.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        Parent           = Window.Main,
    }, { Corner(8) })

    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Window.CurrentThemeColors.TitleBar,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        Parent           = Window.TitleBar,
    })

    Window.AccentBar = Create("Frame", {
        Name             = "AccentBar",
        Size             = UDim2.new(1, 0, 0, 2),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel  = 0,
        ZIndex           = 4,
        Parent           = Window.TitleBar,
    }, {
        Corner(2),
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Window.CurrentThemeColors.Accent),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1,   Window.CurrentThemeColors.Accent),
            })
        }),
    })

    Window.TitleText = Create("TextLabel", {
        Size              = UDim2.new(0, 300, 1, 0),
        Position          = UDim2.new(0, 18, 0, 0),
        BackgroundTransparency = 1,
        Text              = Window.Title:upper(),
        TextColor3        = Window.CurrentThemeColors.TextPrimary,
        TextSize          = 13,
        Font              = FONT_BOLD,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ZIndex            = 3,
        Parent            = Window.TitleBar,
    })

    Create("TextLabel", {
        Size              = UDim2.new(0, 60, 0, 16),
        Position          = UDim2.new(0, 18, 0.5, 2),
        BackgroundColor3  = Window.CurrentThemeColors.SurfaceAlt,
        BackgroundTransparency = 0,
        Text              = "v"..VERSION,
        TextColor3        = Window.CurrentThemeColors.TextSecondary,
        TextSize          = 9,
        Font              = FONT_SEMI,
        TextXAlignment    = Enum.TextXAlignment.Center,
        ZIndex            = 4,
        Parent            = Window.TitleBar,
    }, { Corner(3) })

    MakeDraggable(Window.Main, Window.TitleBar)

    Window.Sidebar = Create("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 148, 1, -42),
        Position         = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        ClipsDescendants = true,
        Parent           = Window.Main,
    }, { Corner(8) })

    Create("Frame", {
        Size             = UDim2.new(0, 8, 1, 0),
        Position         = UDim2.new(1, -8, 0, 0),
        BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        Parent           = Window.Sidebar,
    })
    Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 8),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
        BorderSizePixel  = 0,
        ZIndex           = 2,
        Parent           = Window.Sidebar,
    })

    Window.SidebarLine = Create("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Window.CurrentThemeColors.Border,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = Window.Sidebar,
    })

    Create("ImageLabel", {
        Size               = UDim2.new(1, 0, 0, 32),
        Position           = UDim2.new(0, 0, 1, -32),
        BackgroundTransparency = 1,
        Image              = "rbxassetid://1316045217",
        ImageColor3        = Window.CurrentThemeColors.Sidebar,
        ScaleType          = Enum.ScaleType.Stretch,
        ZIndex             = 5,
        Parent             = Window.Sidebar,
    })

    Window.SearchBarBox = Create("TextBox", {
        Name              = "SearchBar",
        Size              = UDim2.new(1, -20, 0, 26),
        Position          = UDim2.new(0, 10, 0, 10),
        BackgroundColor3  = Window.CurrentThemeColors.SurfaceAlt,
        Text              = "",
        PlaceholderText   = "🔍 Search...",
        PlaceholderColor3 = Window.CurrentThemeColors.TextSecondary,
        TextColor3        = Window.CurrentThemeColors.TextPrimary,
        TextSize          = 10,
        Font              = FONT,
        ZIndex            = 4,
        Parent            = Window.Sidebar,
    }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })

    Window.SearchBarBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = Window.SearchBarBox.Text:lower()
        for _, tab in ipairs(Window.Tabs) do
            for _, sec in ipairs(tab.Sections) do
                local anyMatch = false
                for _, child in ipairs(sec.Frame:GetChildren()) do
                    if child:IsA("GuiObject")
                    and child.ClassName ~= "UIListLayout"
                    and child.ClassName ~= "UIPadding"
                    and child.ClassName ~= "UICorner"
                    and child.ClassName ~= "UIStroke"
                    and child ~= sec.Header
                    and child ~= sec.Underline then
                        local lbl = child:FindFirstChildWhichIsA("TextLabel", true)
                        if lbl and lbl.Text:lower():find(q, 1, true) then
                            child.Visible = true
                            anyMatch = true
                        else
                            child.Visible = q == ""
                        end
                    end
                end
                sec.Frame.Visible = anyMatch or q == ""
            end
        end
    end)

    Window.TabList = Create("ScrollingFrame", {
        Name                  = "TabList",
        Size                  = UDim2.new(1, 0, 1, -46),
        Position              = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency= 1,
        BorderSizePixel       = 0,
        ScrollBarThickness    = 0,
        CanvasSize            = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize   = Enum.AutomaticSize.Y,
        ZIndex                = 3,
        Parent                = Window.Sidebar,
    }, {
        Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
        Padding(4, 8, 0, 0),
    })

    Window.Content = Create("Frame", {
        Name                  = "Content",
        Size                  = UDim2.new(1, -148, 1, -42),
        Position              = UDim2.new(0, 148, 0, 42),
        BackgroundTransparency= 1,
        ZIndex                = 2,
        Parent                = Window.Main,
    })

    Window.Resizer = Create("TextButton", {
        Name                  = "Resizer",
        Size                  = UDim2.new(0, 20, 0, 20),
        Position              = UDim2.new(1, -20, 1, -20),
        BackgroundTransparency= 1,
        Text                  = "",
        ZIndex                = 15,
        Parent                = Window.Main,
    })

    Create("ImageLabel", {
        Size                  = UDim2.new(0, 14, 0, 14),
        Position              = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency= 1,
        Image                 = "rbxassetid://6031094667",
        ImageColor3           = Window.CurrentThemeColors.Border,
        ZIndex                = 16,
        Parent                = Window.Resizer,
    })

    do
        local rDrag, rStartSize, rStartPos = false, nil, nil
        local MIN_W, MIN_H = 420, 300

        Window.Resizer.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                rDrag     = true
                rStartSize= Window.Main.AbsoluteSize
                rStartPos = i.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if rDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - rStartPos
                Window.Main.Size = UDim2.new(
                    0, math.max(rStartSize.X + d.X, MIN_W),
                    0, math.max(rStartSize.Y + d.Y, MIN_H)
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                rDrag = false
            end
        end)
    end

    function Window:RegisterThemeElement(inst, prop, themeKey)
        table.insert(self.Elements, {
            Instance = inst,
            Property = prop,
            ThemeKey = themeKey,
        })
    end

    Window:RegisterThemeElement(Window.Main,       "BackgroundColor3", "Background")
    Window:RegisterThemeElement(Window.MainStroke, "Color",            "Border")
    Window:RegisterThemeElement(Window.TitleBar,   "BackgroundColor3", "TitleBar")
    Window:RegisterThemeElement(Window.TitleText,  "TextColor3",       "TextPrimary")
    Window:RegisterThemeElement(Window.Sidebar,    "BackgroundColor3", "Sidebar")
    Window:RegisterThemeElement(Window.SidebarLine,"BackgroundColor3", "Border")

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
                ColorSequenceKeypoint.new(0,   self.CurrentThemeColors.Accent),
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1,   self.CurrentThemeColors.Accent),
            })
        end

        for _, data in ipairs(self.Elements) do
            if data.Instance and data.Instance.Parent then
                local col = self.CurrentThemeColors[data.ThemeKey]
                if col then
                    Tween(data.Instance, { [data.Property] = col }, 0.2)
                end
            end
        end

        local op = 1 - self.Opacity
        Window.Main.BackgroundTransparency    = op
        Window.Sidebar.BackgroundTransparency = op
        Window.TitleBar.BackgroundTransparency= op
    end

    function Window:ToggleUI(state)
        if state == nil then state = not self.GuiVisible end
        self.GuiVisible = state

        if state then
            self.Main.Visible = true
            Tween(self.Main, { Size = UDim2.new(0, 620, 0, 440) }, 0.25, Enum.EasingStyle.Back)
            Tween(self.GlowFrame, { ImageTransparency = 0.45 }, 0.25)
        else
            Tween(self.Main, { Size = UDim2.new(0, 620, 0, 0) }, 0.2)
            Tween(self.GlowFrame, { ImageTransparency = 1 }, 0.2)
            task.delay(0.22, function()
                if not self.GuiVisible then self.Main.Visible = false end
            end)
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)

        if Window.Binding then
            local isKey   = input.UserInputType == Enum.UserInputType.Keyboard
            local isMouse = input.UserInputType.Name:find("MouseButton")
            if isKey or isMouse then
                local k = (input.KeyCode ~= Enum.KeyCode.Unknown)
                    and input.KeyCode
                    or  input.UserInputType

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

        local k = (input.KeyCode ~= Enum.KeyCode.Unknown)
            and input.KeyCode
            or  input.UserInputType

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

    Window.ToastContainer = Create("Frame", {
        Name                  = "ToastContainer",
        Size                  = UDim2.new(0, 260, 1, -60),
        Position              = UDim2.new(1, -278, 0, 20),
        BackgroundTransparency= 1,
        ZIndex                = 100,
        Parent                = Window.Gui,
    })
    Create("UIListLayout", {
        SortOrder         = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding           = UDim.new(0, 8),
        Parent            = Window.ToastContainer,
    })

    function Window:Notify(title, text, duration, notifType)
        notifType = notifType or "info"
        local accentCol = Window.CurrentThemeColors.Accent
        if notifType == "success" then accentCol = Window.CurrentThemeColors.Success
        elseif notifType == "warning" then accentCol = Window.CurrentThemeColors.Warning
        elseif notifType == "danger"  then accentCol = Window.CurrentThemeColors.Danger
        end

        local Toast = Create("Frame", {
            Size                  = UDim2.new(1, 0, 0, 64),
            BackgroundColor3      = Window.CurrentThemeColors.Surface,
            BackgroundTransparency= 1,
            BorderSizePixel       = 0,
            ZIndex                = 100,
            ClipsDescendants      = true,
            Parent                = Window.ToastContainer,
        }, { Corner(6) })

        local ToastStroke = MakeStroke(Window.CurrentThemeColors.Border, 1)
        ToastStroke.Transparency = 1
        ToastStroke.Parent = Toast

        local AccentBar = Create("Frame", {
            Size                  = UDim2.new(0, 3, 1, 0),
            BackgroundColor3      = accentCol,
            BackgroundTransparency= 1,
            BorderSizePixel       = 0,
            ZIndex                = 101,
            Parent                = Toast,
        }, { Corner(2) })

        local TitleLbl = Create("TextLabel", {
            Size                  = UDim2.new(1, -22, 0, 22),
            Position              = UDim2.new(0, 14, 0, 8),
            BackgroundTransparency= 1,
            Text                  = title,
            TextColor3            = Window.CurrentThemeColors.TextPrimary,
            TextTransparency      = 1,
            TextSize              = 12,
            Font                  = FONT_BOLD,
            TextXAlignment        = Enum.TextXAlignment.Left,
            ZIndex                = 101,
            Parent                = Toast,
        })

        local TextLbl = Create("TextLabel", {
            Size                  = UDim2.new(1, -22, 0, 20),
            Position              = UDim2.new(0, 14, 0, 30),
            BackgroundTransparency= 1,
            Text                  = text,
            TextColor3            = Window.CurrentThemeColors.TextSecondary,
            TextTransparency      = 1,
            TextSize              = 10,
            Font                  = FONT,
            TextXAlignment        = Enum.TextXAlignment.Left,
            TextWrapped           = true,
            ZIndex                = 101,
            Parent                = Toast,
        })

        Window:RegisterThemeElement(Toast,      "BackgroundColor3", "Surface")
        Window:RegisterThemeElement(ToastStroke,"Color",            "Border")
        Window:RegisterThemeElement(TitleLbl,   "TextColor3",       "TextPrimary")
        Window:RegisterThemeElement(TextLbl,    "TextColor3",       "TextSecondary")

        Tween(Toast,       { BackgroundTransparency = 0   }, 0.25)
        Tween(ToastStroke, { Transparency = 0            }, 0.25)
        Tween(AccentBar,   { BackgroundTransparency = 0   }, 0.25)
        Tween(TitleLbl,    { TextTransparency = 0         }, 0.25)
        Tween(TextLbl,     { TextTransparency = 0         }, 0.25)

        task.delay(duration or 3, function()
            Tween(Toast,       { BackgroundTransparency = 1 }, 0.25)
            Tween(ToastStroke, { Transparency = 1           }, 0.25)
            Tween(AccentBar,   { BackgroundTransparency = 1 }, 0.25)
            Tween(TitleLbl,    { TextTransparency = 1       }, 0.25)
            Tween(TextLbl,     { TextTransparency = 1       }, 0.25)
            task.delay(0.3, function() Toast:Destroy() end)
        end)
    end

    function Window:Dialog(cfg)
        local Title    = cfg.Title    or "Dialog"
        local Content  = cfg.Content  or "Are you sure?"
        local Buttons  = cfg.Buttons  or {"Confirm", "Cancel"}
        local Callback = cfg.Callback or function() end

        local Overlay = Create("TextButton", {
            Size                  = UDim2.new(1, 0, 1, 0),
            BackgroundColor3      = Color3.new(0, 0, 0),
            BackgroundTransparency= 0.5,
            Text                  = "",
            ZIndex                = 999,
            Parent                = Window.Main,
        }, { Corner(8) })

        local Dlg = Create("Frame", {
            Size             = UDim2.new(0, 260, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            Position         = UDim2.new(0.5, -130, 0.5, -60),
            BackgroundColor3 = Window.CurrentThemeColors.Background,
            BorderSizePixel  = 0,
            ZIndex           = 1000,
            Parent           = Overlay,
        }, { Corner(8), MakeStroke(Window.CurrentThemeColors.Border, 1), Padding(10, 12, 12, 12) })

        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding   = UDim.new(0, 8),
            Parent    = Dlg,
        })

        Create("TextLabel", {
            Size                  = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency= 1,
            Text                  = Title,
            TextColor3            = Window.CurrentThemeColors.TextPrimary,
            TextSize              = 13,
            Font                  = FONT_BOLD,
            TextXAlignment        = Enum.TextXAlignment.Center,
            ZIndex                = 1001,
            LayoutOrder           = 1,
            Parent                = Dlg,
        })

        Create("TextLabel", {
            Size                  = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency= 1,
            Text                  = Content,
            TextColor3            = Window.CurrentThemeColors.TextSecondary,
            TextSize              = 11,
            Font                  = FONT,
            TextWrapped           = true,
            TextXAlignment        = Enum.TextXAlignment.Center,
            ZIndex                = 1001,
            LayoutOrder           = 2,
            Parent                = Dlg,
        })

        local BtnRow = Create("Frame", {
            Size                  = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency= 1,
            ZIndex                = 1001,
            LayoutOrder           = 3,
            Parent                = Dlg,
        }, {
            Create("UIListLayout", {
                SortOrder     = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding       = UDim.new(0, 8),
            }),
        })

        local function closeDialog()
            Tween(Overlay, { BackgroundTransparency = 1 }, 0.2)
            task.delay(0.2, function() Overlay:Destroy() end)
        end

        for i, label in ipairs(Buttons) do
            local btnW = math.floor((236 - (8 * (#Buttons - 1))) / #Buttons)
            local btn = Create("TextButton", {
                Size             = UDim2.new(0, btnW, 1, 0),
                BackgroundColor3 = Window.CurrentThemeColors.Surface,
                Text             = label,
                TextColor3       = Window.CurrentThemeColors.TextPrimary,
                TextSize         = 11,
                Font             = FONT,
                ZIndex           = 1002,
                LayoutOrder      = i,
                Parent           = BtnRow,
            }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })

            btn.MouseEnter:Connect(function()
                Tween(btn, { BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt }, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                Tween(btn, { BackgroundColor3 = Window.CurrentThemeColors.Surface }, 0.15)
            end)
            btn.MouseButton1Click:Connect(function()
                closeDialog()
                Callback(label)
            end)
        end

        Spring(Dlg, { Position = UDim2.new(0.5, -130, 0.5, -55) }, 0.35)
    end

    function Window:SelectTab(tab)
        if self.ActiveTab == tab then return end
        if self.ActiveTab then
            Tween(self.ActiveTab.Btn, { BackgroundColor3 = Window.CurrentThemeColors.Sidebar }, 0.2)
            Tween(self.ActiveTab.Bar, { BackgroundTransparency = 1 }, 0.2)
            self.ActiveTab.Page.Visible = false
        end
        self.ActiveTab = tab
        Tween(tab.Btn, { BackgroundColor3 = Window.CurrentThemeColors.Surface }, 0.2)
        Tween(tab.Bar, { BackgroundTransparency = 0 }, 0.2)
        tab.Page.Visible = true
    end

    function Window:AddTab(config)
        local tcfg = config or {}
        local Name  = tcfg.Name or "Tab"

        local Tab = {
            Name     = Name,
            Window   = self,
            Sections = {},
        }

        Tab.Btn = Create("TextButton", {
            Size             = UDim2.new(1, -8, 0, 34),
            Position         = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Window.CurrentThemeColors.Sidebar,
            BorderSizePixel  = 0,
            Text             = "",
            Parent           = Window.TabList,
        }, { Corner(6) })
        Window:RegisterThemeElement(Tab.Btn, "BackgroundColor3", "Sidebar")

        Tab.Bar = Create("Frame", {
            Size                  = UDim2.new(0, 3, 0.55, 0),
            Position              = UDim2.new(0, 5, 0.225, 0),
            BackgroundColor3      = Window.CurrentThemeColors.Accent,
            BackgroundTransparency= 1,
            BorderSizePixel       = 0,
            Parent                = Tab.Btn,
        }, { Corner(3) })
        Window:RegisterThemeElement(Tab.Bar, "BackgroundColor3", "Accent")

        Tab.Text = Create("TextLabel", {
            Size                  = UDim2.new(1, -22, 1, 0),
            Position              = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency= 1,
            Text                  = Name,
            TextColor3            = Window.CurrentThemeColors.TextPrimary,
            TextSize              = 12,
            Font                  = FONT_BOLD,
            TextXAlignment        = Enum.TextXAlignment.Left,
            Parent                = Tab.Btn,
        })
        Window:RegisterThemeElement(Tab.Text, "TextColor3", "TextPrimary")

        Tab.Page = Create("ScrollingFrame", {
            Size                  = UDim2.new(1, -16, 1, -14),
            Position              = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency= 1,
            BorderSizePixel       = 0,
            ScrollBarThickness    = 2,
            ScrollBarImageColor3  = Window.CurrentThemeColors.Border,
            CanvasSize            = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize   = Enum.AutomaticSize.Y,
            Visible               = false,
            Parent                = Window.Content,
        }, {
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 8),
            }),
        })
        Window:RegisterThemeElement(Tab.Page, "ScrollBarImageColor3", "Border")

        Tab.Btn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(Tab.Btn, { BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt }, 0.15)
            end
        end)
        Tab.Btn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(Tab.Btn, { BackgroundColor3 = Window.CurrentThemeColors.Sidebar }, 0.15)
            end
        end)
        Tab.Btn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        table.insert(self.Tabs, Tab)
        if not Window.ActiveTab then Window:SelectTab(Tab) end

        function Tab:AddSection(scfg)
            local sName = (scfg and scfg.Name) or "Section"

            local Section = {
                Name     = sName,
                Elements = {},
            }

            Section.Frame = Create("Frame", {
                Size          = UDim2.new(1, 0, 0, 10),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Window.CurrentThemeColors.Surface,
                BorderSizePixel  = 0,
                Parent           = Tab.Page,
            }, {
                Corner(8),
                MakeStroke(Window.CurrentThemeColors.Border, 1),
                Padding(6, 8, 6, 6),
            })

            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding   = UDim.new(0, 5),
                Parent    = Section.Frame,
            })

            Window:RegisterThemeElement(Section.Frame, "BackgroundColor3", "Surface")
            Window:RegisterThemeElement(
                Section.Frame:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
            )

            Section.Header = Create("Frame", {
                Size                  = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency= 1,
                Parent                = Section.Frame,
            })

            Create("Frame", {
                Size             = UDim2.new(0, 3, 0, 14),
                Position         = UDim2.new(0, 0, 0.5, -7),
                BackgroundColor3 = Window.CurrentThemeColors.Accent,
                BorderSizePixel  = 0,
                Parent           = Section.Header,
            }, { Corner(2) })

            Create("TextLabel", {
                Size                  = UDim2.new(1, -12, 1, 0),
                Position              = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency= 1,
                Text                  = sName:upper(),
                TextColor3            = Window.CurrentThemeColors.TextPrimary,
                TextSize              = 10,
                Font                  = FONT_BOLD,
                TextXAlignment        = Enum.TextXAlignment.Left,
                Parent                = Section.Header,
            })

            Section.Underline = Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Window.CurrentThemeColors.Border,
                BorderSizePixel  = 0,
                Parent           = Section.Header,
            })
            Window:RegisterThemeElement(Section.Underline, "BackgroundColor3", "Border")

            local function makeKeybindUI(parent, defaultKey, callback, xOffset)
                xOffset = xOffset or -44
                local kbBtn = Create("TextButton", {
                    Size             = UDim2.new(0, 40, 0, 18),
                    Position         = UDim2.new(1, xOffset, 0.5, -9),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Text             = GetKeyName(defaultKey),
                    TextColor3       = Window.CurrentThemeColors.TextSecondary,
                    TextSize         = 9,
                    Font             = FONT,
                    BorderSizePixel  = 0,
                    Parent           = parent,
                }, { Corner(3), MakeStroke(Window.CurrentThemeColors.Border, 1) })

                Window:RegisterThemeElement(kbBtn, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(kbBtn, "TextColor3",       "TextSecondary")
                Window:RegisterThemeElement(
                    kbBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local kbObj = { Key = defaultKey, Callback = callback }
                table.insert(Window.Keybinds, kbObj)

                kbBtn.MouseButton1Click:Connect(function()
                    kbBtn.Text    = "..."
                    Window.Binding = true
                    Window._BindTarget = {
                        UpdateKey = function(k)
                            kbObj.Key   = k
                            kbBtn.Text  = GetKeyName(k)
                        end
                    }
                end)
                kbBtn.MouseButton2Click:Connect(function()
                    kbObj.Key  = nil
                    kbBtn.Text = "None"
                end)

                return kbBtn, kbObj
            end

            function Section:AddToggle(cfg)
                local name = cfg.Name    or "Toggle"
                local def  = cfg.Default or false
                local cb   = cfg.Callback or function() end
                local key  = cfg.Keybind

                local val = def

                local Toggle = Create("TextButton", {
                    Size                  = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency= 1,
                    Text                  = "",
                    Parent                = Section.Frame,
                })

                local Lbl = Create("TextLabel", {
                    Size                  = UDim2.new(1, -70, 1, 0),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = val
                        and Window.CurrentThemeColors.TextPrimary
                        or  Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = Toggle,
                })
                Window:RegisterThemeElement(Lbl, "TextColor3", val and "TextPrimary" or "TextSecondary")

                local Switch = Create("Frame", {
                    Size             = UDim2.new(0, 36, 0, 20),
                    Position         = UDim2.new(1, -44, 0.5, -10),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Parent           = Toggle,
                }, { Corner(10), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(Switch, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(
                    Switch:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local Dot = Create("Frame", {
                    Size             = UDim2.new(0, 14, 0, 14),
                    Position         = UDim2.new(0, val and 20 or 3, 0.5, -7),
                    BackgroundColor3 = val
                        and Window.CurrentThemeColors.Accent
                        or  Window.CurrentThemeColors.TextSecondary,
                    Parent           = Switch,
                }, { Corner(7) })
                Window:RegisterThemeElement(Dot, "BackgroundColor3", val and "Accent" or "TextSecondary")

                if key then
                    makeKeybindUI(Toggle, key, function() Toggle.MouseButton1Click:Fire() end, -90)
                end

                local function set(v)
                    val = v
                    Tween(Dot, {
                        Position         = UDim2.new(0, v and 20 or 3, 0.5, -7),
                        BackgroundColor3 = v
                            and Window.CurrentThemeColors.Accent
                            or  Window.CurrentThemeColors.TextSecondary,
                    }, 0.18)
                    Tween(Switch, {
                        BackgroundColor3 = v
                            and Color3.fromRGB(
                                math.floor(Window.CurrentThemeColors.Accent.R * 255 * 0.25),
                                math.floor(Window.CurrentThemeColors.Accent.G * 255 * 0.25),
                                math.floor(Window.CurrentThemeColors.Accent.B * 255 * 0.25)
                            )
                            or Window.CurrentThemeColors.SurfaceAlt,
                    }, 0.18)
                    Tween(Lbl, {
                        TextColor3 = v
                            and Window.CurrentThemeColors.TextPrimary
                            or  Window.CurrentThemeColors.TextSecondary,
                    }, 0.18)
                    cb(v)
                    Window.ConfigData[name] = v
                end

                Toggle.MouseButton1Click:Connect(function() set(not val) end)

                Window.ConfigData[name] = def
                return {
                    Set = set,
                    Get = function() return val end,
                }
            end

            function Section:AddSlider(cfg)
                local name   = cfg.Name    or "Slider"
                local min    = cfg.Min     or 0
                local max    = cfg.Max     or 100
                local def    = cfg.Default or min
                local suffix = cfg.Suffix  or ""
                local step   = cfg.Step
                local cb     = cfg.Callback or function() end

                local val = def

                local Slider = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 46),
                    BackgroundTransparency= 1,
                    Parent                = Section.Frame,
                })

                local Lbl = Create("TextLabel", {
                    Size                  = UDim2.new(1, -70, 0, 20),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = Slider,
                })
                Window:RegisterThemeElement(Lbl, "TextColor3", "TextSecondary")

                local ValLbl = Create("TextLabel", {
                    Size                  = UDim2.new(0, 60, 0, 20),
                    Position              = UDim2.new(1, -68, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = tostring(val)..suffix,
                    TextColor3            = Window.CurrentThemeColors.Accent,
                    TextSize              = 11,
                    Font                  = FONT_BOLD,
                    TextXAlignment        = Enum.TextXAlignment.Right,
                    Parent                = Slider,
                })
                Window:RegisterThemeElement(ValLbl, "TextColor3", "Accent")

                local Track = Create("TextButton", {
                    Size             = UDim2.new(1, -16, 0, 6),
                    Position         = UDim2.new(0, 8, 0, 30),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Text             = "",
                    AutoButtonColor  = false,
                    Parent           = Slider,
                }, { Corner(3) })
                Window:RegisterThemeElement(Track, "BackgroundColor3", "SurfaceAlt")

                local pct  = math.clamp((val - min) / (max - min), 0, 1)
                local Fill = Create("Frame", {
                    Size             = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = Window.CurrentThemeColors.Accent,
                    Parent           = Track,
                }, { Corner(3) })
                Window:RegisterThemeElement(Fill, "BackgroundColor3", "Accent")

                local Thumb = Create("Frame", {
                    Size             = UDim2.new(0, 12, 0, 12),
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(pct, 0, 0.5, 0),
                    BackgroundColor3 = Window.CurrentThemeColors.Accent,
                    ZIndex           = 2,
                    Parent           = Track,
                }, { Corner(6), MakeStroke(Window.CurrentThemeColors.Background, 2) })
                Window:RegisterThemeElement(Thumb, "BackgroundColor3", "Accent")

                local function set(v)
                    if step then
                        v = math.floor(v / step + 0.5) * step
                    else
                        v = math.floor(v * 10 + 0.5) / 10
                    end
                    v   = math.clamp(v, min, max)
                    val = v
                    local p = (v - min) / (max - min)
                    Tween(Fill,  { Size = UDim2.new(p, 0, 1, 0) }, 0.08)
                    Tween(Thumb, { Position = UDim2.new(p, 0, 0.5, 0) }, 0.08)
                    ValLbl.Text = tostring(val)..suffix
                    cb(val)
                    Window.ConfigData[name] = val
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

                Window.ConfigData[name] = def
                return {
                    Set = set,
                    Get = function() return val end,
                }
            end

            function Section:AddButton(cfg)
                local name  = cfg.Name     or "Button"
                local cb    = cfg.Callback or function() end
                local key   = cfg.Keybind
                local color = cfg.Color

                local baseCol = Window.CurrentThemeColors.SurfaceAlt
                local textCol = Window.CurrentThemeColors.TextPrimary
                if color == "accent"  then
                    baseCol = Window.CurrentThemeColors.Accent
                    textCol = Color3.new(1,1,1)
                elseif color == "danger" then
                    baseCol = Window.CurrentThemeColors.Danger
                    textCol = Color3.new(1,1,1)
                elseif color == "success" then
                    baseCol = Window.CurrentThemeColors.Success
                    textCol = Color3.new(1,1,1)
                end

                local Btn = Create("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = baseCol,
                    Text             = name,
                    TextColor3       = textCol,
                    TextSize         = 11,
                    Font             = FONT_BOLD,
                    Parent           = Section.Frame,
                }, { Corner(6), MakeStroke(Window.CurrentThemeColors.Border, 1) })

                if not color then
                    Window:RegisterThemeElement(Btn, "BackgroundColor3", "SurfaceAlt")
                    Window:RegisterThemeElement(Btn, "TextColor3",       "TextPrimary")
                end
                Window:RegisterThemeElement(
                    Btn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local hoverCol = color
                    and baseCol:Lerp(Color3.new(1,1,1), 0.12)
                    or  Window.CurrentThemeColors.Border

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, { BackgroundColor3 = hoverCol }, 0.15)
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, { BackgroundColor3 = baseCol  }, 0.15)
                end)

                Btn.MouseButton1Click:Connect(function()

                    local rip = Create("Frame", {
                        Size                  = UDim2.new(0, 0, 0, 0),
                        Position              = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint           = Vector2.new(0.5, 0.5),
                        BackgroundColor3      = Color3.new(1, 1, 1),
                        BackgroundTransparency= 0.65,
                        ZIndex                = 5,
                        Parent                = Btn,
                    }, { Corner(100) })
                    Tween(rip, { Size = UDim2.new(1, 40, 1, 40), BackgroundTransparency = 1 }, 0.4)
                    task.delay(0.42, function() rip:Destroy() end)
                    cb()
                end)

                if key then makeKeybindUI(Btn, key, cb) end
            end

            function Section:AddDropdown(cfg)
                local name = cfg.Name    or "Dropdown"
                local opts = cfg.Options or {}
                local def  = cfg.Default or opts[1]
                local cb   = cfg.Callback or function() end

                local selected = def

                local Drop = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency= 1,
                    ZIndex                = 5,
                    Parent                = Section.Frame,
                })

                Create("TextLabel", {
                    Size                  = UDim2.new(0.45, 0, 1, 0),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = Drop,
                })

                local DropBtn = Create("TextButton", {
                    Size             = UDim2.new(0.55, -12, 0, 24),
                    Position         = UDim2.new(0.45, 4, 0.5, -12),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Text             = tostring(selected or "Select...").." ▾",
                    TextColor3       = Window.CurrentThemeColors.TextPrimary,
                    TextSize         = 10,
                    Font             = FONT,
                    ZIndex           = 6,
                    Parent           = Drop,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(DropBtn, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(DropBtn, "TextColor3",       "TextPrimary")
                Window:RegisterThemeElement(
                    DropBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local List = Create("Frame", {
                    BackgroundColor3 = Window.CurrentThemeColors.Surface,
                    Visible          = false,
                    ZIndex           = 20,
                    Parent           = DropBtn,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(List, "BackgroundColor3", "Surface")
                Window:RegisterThemeElement(
                    List:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local ll = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent    = List,
                })

                local open = false

                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    List.Visible = open
                    DropBtn.Text = tostring(selected or "Select...")..(open and " ▴" or " ▾")
                end)

                local function setOptions(newOpts)
                    opts = newOpts
                    for _, c in ipairs(List:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    List.Size = UDim2.new(1, 0, 0, math.min(#opts, 6) * 22 + 4)
                    List.Position = UDim2.new(0, 0, 1, 4)

                    for i, o in ipairs(opts) do
                        local ob = Create("TextButton", {
                            Size                  = UDim2.new(1, 0, 0, 22),
                            BackgroundTransparency= 1,
                            Text                  = "  "..tostring(o),
                            TextColor3            = Window.CurrentThemeColors.TextSecondary,
                            TextSize              = 10,
                            Font                  = FONT,
                            TextXAlignment        = Enum.TextXAlignment.Left,
                            ZIndex                = 21,
                            LayoutOrder           = i,
                            Parent                = List,
                        })
                        ob.MouseEnter:Connect(function()
                            Tween(ob, { TextColor3 = Window.CurrentThemeColors.Accent }, 0.15)
                            ob.BackgroundTransparency = 0.85
                        end)
                        ob.MouseLeave:Connect(function()
                            Tween(ob, { TextColor3 = Window.CurrentThemeColors.TextSecondary }, 0.15)
                            ob.BackgroundTransparency = 1
                        end)
                        ob.MouseButton1Click:Connect(function()
                            selected = o
                            DropBtn.Text = tostring(o).." ▾"
                            List.Visible = false
                            open = false
                            cb(o)
                            Window.ConfigData[name] = o
                        end)
                    end
                end

                setOptions(opts)
                Window.ConfigData[name] = def

                return {
                    Set        = function(v) selected = v; DropBtn.Text = tostring(v).." ▾"; cb(v); Window.ConfigData[name] = v end,
                    Get        = function() return selected end,
                    SetOptions = setOptions,
                }
            end

            function Section:AddKeybind(cfg)
                local name = cfg.Name     or "Keybind"
                local def  = cfg.Default
                local cb   = cfg.Callback or function() end

                local KbFrame = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency= 1,
                    Parent                = Section.Frame,
                })

                Create("TextLabel", {
                    Size                  = UDim2.new(1, -60, 1, 0),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = KbFrame,
                })

                local _, kbObj = makeKeybindUI(KbFrame, def, cb)

                return kbObj
            end

            function Section:AddColorPicker(cfg)
                local name = cfg.Name    or "Color"
                local def  = cfg.Default or Color3.new(1, 1, 1)
                local cb   = cfg.Callback or function() end

                local val = def

                local CPFrame = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency= 1,
                    Parent                = Section.Frame,
                })

                Create("TextLabel", {
                    Size                  = UDim2.new(1, -80, 1, 0),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = CPFrame,
                })

                local Disp = Create("Frame", {
                    Size             = UDim2.new(0, 20, 0, 20),
                    Position         = UDim2.new(1, -76, 0.5, -10),
                    BackgroundColor3 = val,
                    Parent           = CPFrame,
                }, { Corner(4), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(
                    Disp:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local HexInput = Create("TextBox", {
                    Size              = UDim2.new(0, 52, 0, 20),
                    Position          = UDim2.new(1, -52, 0.5, -10),
                    BackgroundColor3  = Window.CurrentThemeColors.SurfaceAlt,
                    Text              = ColorToHex(val),
                    TextColor3        = Window.CurrentThemeColors.TextPrimary,
                    TextSize          = 10,
                    Font              = FONT,
                    ClearTextOnFocus  = false,
                    Parent            = CPFrame,
                }, { Corner(4), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(HexInput, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(HexInput, "TextColor3",       "TextPrimary")
                Window:RegisterThemeElement(
                    HexInput:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local function set(v)
                    val = v
                    Disp.BackgroundColor3 = val
                    HexInput.Text = ColorToHex(val)
                    cb(val)
                    Window.ConfigData[name] = ColorToHex(val)
                end

                HexInput.FocusLost:Connect(function()
                    pcall(function() set(HexToColor(HexInput.Text)) end)
                end)

                Window.ConfigData[name] = ColorToHex(def)
                return {
                    Set = set,
                    Get = function() return val end,
                }
            end

            function Section:AddTextBox(cfg)
                local name        = cfg.Name        or "TextBox"
                local def         = cfg.Default     or ""
                local placeholder = cfg.Placeholder or ""
                local cb          = cfg.Callback    or function() end

                local val = def

                local TBFrame = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 48),
                    BackgroundTransparency= 1,
                    Parent                = Section.Frame,
                })

                local Lbl = Create("TextLabel", {
                    Size                  = UDim2.new(1, -16, 0, 20),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = TBFrame,
                })
                Window:RegisterThemeElement(Lbl, "TextColor3", "TextSecondary")

                local Input = Create("TextBox", {
                    Size              = UDim2.new(1, -16, 0, 24),
                    Position          = UDim2.new(0, 8, 0, 22),
                    BackgroundColor3  = Window.CurrentThemeColors.SurfaceAlt,
                    Text              = def,
                    PlaceholderText   = placeholder,
                    PlaceholderColor3 = Window.CurrentThemeColors.TextSecondary,
                    TextColor3        = Window.CurrentThemeColors.TextPrimary,
                    TextSize          = 10,
                    Font              = FONT,
                    ClearTextOnFocus  = false,
                    Parent            = TBFrame,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(Input, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(Input, "TextColor3",       "TextPrimary")
                Window:RegisterThemeElement(
                    Input:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                Input.Focused:Connect(function()
                    Tween(Input:FindFirstChildWhichIsA("UIStroke"),
                        { Color = Window.CurrentThemeColors.Accent }, 0.15)
                end)
                Input.FocusLost:Connect(function()
                    Tween(Input:FindFirstChildWhichIsA("UIStroke"),
                        { Color = Window.CurrentThemeColors.Border }, 0.15)
                    val = Input.Text
                    cb(val)
                    Window.ConfigData[name] = val
                end)

                Window.ConfigData[name] = def
                return {
                    Set = function(v) val = v; Input.Text = v; cb(v) end,
                    Get = function() return val end,
                }
            end

            function Section:AddMultiDropdown(cfg)
                local name    = cfg.Name    or "MultiSelect"
                local opts    = cfg.Options or {}
                local defList = cfg.Default or {}
                local cb      = cfg.Callback or function() end

                local selected = {}
                for _, v in ipairs(defList) do selected[v] = true end

                local Drop = Create("Frame", {
                    Size                  = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency= 1,
                    ZIndex                = 5,
                    Parent                = Section.Frame,
                })

                Create("TextLabel", {
                    Size                  = UDim2.new(0.45, 0, 1, 0),
                    Position              = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency= 1,
                    Text                  = name,
                    TextColor3            = Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 11,
                    Font                  = FONT,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = Drop,
                })

                local DropBtn = Create("TextButton", {
                    Size             = UDim2.new(0.55, -12, 0, 24),
                    Position         = UDim2.new(0.45, 4, 0.5, -12),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Text             = "None ▾",
                    TextColor3       = Window.CurrentThemeColors.TextPrimary,
                    TextSize         = 10,
                    Font             = FONT,
                    ZIndex           = 6,
                    Parent           = Drop,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(DropBtn, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(DropBtn, "TextColor3",       "TextPrimary")
                Window:RegisterThemeElement(
                    DropBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local List = Create("Frame", {
                    BackgroundColor3 = Window.CurrentThemeColors.Surface,
                    Visible          = false,
                    ZIndex           = 20,
                    Parent           = DropBtn,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(List, "BackgroundColor3", "Surface")
                Window:RegisterThemeElement(
                    List:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )
                Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = List })

                local open = false
                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    List.Visible = open
                end)

                local function renderText()
                    local t = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(t, tostring(k)) end
                    end
                    DropBtn.Text = (#t > 0 and table.concat(t, ", ") or "None").." ▾"
                end

                local function setOptions(newOpts)
                    opts = newOpts
                    for _, c in ipairs(List:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    List.Size     = UDim2.new(1, 0, 0, math.min(#opts, 6) * 22 + 4)
                    List.Position = UDim2.new(0, 0, 1, 4)

                    for i, o in ipairs(opts) do
                        local ob = Create("TextButton", {
                            Size                  = UDim2.new(1, 0, 0, 22),
                            BackgroundTransparency= 1,
                            Text                  = "  "..tostring(o),
                            TextColor3            = selected[o]
                                and Window.CurrentThemeColors.Accent
                                or  Window.CurrentThemeColors.TextSecondary,
                            TextSize              = 10,
                            Font                  = FONT,
                            TextXAlignment        = Enum.TextXAlignment.Left,
                            ZIndex                = 21,
                            LayoutOrder           = i,
                            Parent                = List,
                        })
                        ob.MouseEnter:Connect(function()
                            if not selected[o] then
                                Tween(ob, { TextColor3 = Window.CurrentThemeColors.TextPrimary }, 0.12)
                            end
                        end)
                        ob.MouseLeave:Connect(function()
                            Tween(ob, {
                                TextColor3 = selected[o]
                                    and Window.CurrentThemeColors.Accent
                                    or  Window.CurrentThemeColors.TextSecondary
                            }, 0.12)
                        end)
                        ob.MouseButton1Click:Connect(function()
                            selected[o] = not selected[o]
                            Tween(ob, {
                                TextColor3 = selected[o]
                                    and Window.CurrentThemeColors.Accent
                                    or  Window.CurrentThemeColors.TextSecondary
                            }, 0.12)
                            renderText()
                            cb(selected)
                        end)
                    end
                    renderText()
                end

                setOptions(opts)
                Window.ConfigData[name] = selected

                return {
                    Set        = function(v) selected = v; setOptions(opts); cb(selected) end,
                    Get        = function() return selected end,
                    SetOptions = setOptions,
                }
            end

            function Section:AddFolder(cfg)
                local fname = (cfg and cfg.Name) or "Folder"

                local FolderBtn = Create("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Window.CurrentThemeColors.SurfaceAlt,
                    Text             = "  ▸  "..fname,
                    TextColor3       = Window.CurrentThemeColors.TextPrimary,
                    TextSize         = 11,
                    Font             = FONT_BOLD,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    Parent           = Section.Frame,
                }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
                Window:RegisterThemeElement(FolderBtn, "BackgroundColor3", "SurfaceAlt")
                Window:RegisterThemeElement(FolderBtn, "TextColor3",       "TextPrimary")
                Window:RegisterThemeElement(
                    FolderBtn:FindFirstChildWhichIsA("UIStroke"), "Color", "Border"
                )

                local Container = Create("Frame", {
                    Size          = UDim2.new(1, -10, 0, 0),
                    Position      = UDim2.new(0, 10, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Visible       = false,
                    Parent        = Section.Frame,
                }, {
                    Create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding   = UDim.new(0, 4),
                    }),
                    Padding(0, 0, 8, 0),
                })

                local folderOpen = false
                FolderBtn.MouseButton1Click:Connect(function()
                    folderOpen = not folderOpen
                    Container.Visible = folderOpen
                    FolderBtn.Text = "  "..(folderOpen and "▾" or "▸").."  "..fname
                end)

                local pseudo = { Frame = Container }
                setmetatable(pseudo, { __index = Section })
                return pseudo
            end

            function Section:AddLabel(cfg)
                local text  = (cfg and cfg.Text)  or ""
                local color = (cfg and cfg.Color) or "TextSecondary"

                local Lbl = Create("TextLabel", {
                    Size                  = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency= 1,
                    Text                  = text,
                    TextColor3            = Window.CurrentThemeColors[color] or Window.CurrentThemeColors.TextSecondary,
                    TextSize              = 10,
                    Font                  = FONT_SEMI,
                    TextXAlignment        = Enum.TextXAlignment.Left,
                    Parent                = Section.Frame,
                })
                Window:RegisterThemeElement(Lbl, "TextColor3", color)
                return Lbl
            end

            function Section:AddSeparator()
                local Sep = Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Window.CurrentThemeColors.Border,
                    BorderSizePixel  = 0,
                    Parent           = Section.Frame,
                })
                Window:RegisterThemeElement(Sep, "BackgroundColor3", "Border")
            end

            table.insert(Tab.Sections, Section)
            return Section
        end

        return Tab
    end

    function Window:AddWatermark(cfg)
        local wtext = (cfg and cfg.Name) or "NeverLoseUI"

        local WM = Create("Frame", {
            Size             = UDim2.new(0, 270, 0, 28),
            Position         = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Window.CurrentThemeColors.Surface,
            BorderSizePixel  = 0,
            Parent           = Window.Gui,
        }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
        Window:RegisterThemeElement(WM, "BackgroundColor3", "Surface")

        Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 2),
            BackgroundColor3 = Window.CurrentThemeColors.Accent,
            Parent           = WM,
        }, { Corner(2) })
        Window:RegisterThemeElement(WM:FindFirstChild("Frame") or WM, "BackgroundColor3", "Accent")

        local Lbl = Create("TextLabel", {
            Size                  = UDim2.new(1, -16, 1, 0),
            Position              = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency= 1,
            TextColor3            = Window.CurrentThemeColors.TextPrimary,
            TextSize              = 11,
            Font                  = FONT_BOLD,
            TextXAlignment        = Enum.TextXAlignment.Left,
            Parent                = WM,
        })
        Window:RegisterThemeElement(Lbl, "TextColor3", "TextPrimary")

        MakeDraggable(WM)

        local fpsSmooth = 60
        local fpsAlpha  = 0.1
        RunService.RenderStepped:Connect(function(dt)
            fpsSmooth = fpsSmooth + (1/dt - fpsSmooth) * fpsAlpha
            local ping = "?"
            pcall(function()
                ping = tostring(math.floor(
                    game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                ))
            end)
            Lbl.Text = wtext.." | "..os.date("%H:%M:%S").." | "
                ..math.floor(fpsSmooth).." FPS | "..ping.."ms"
        end)

        return WM
    end

    function Window:AddKeybindList(cfg)
        local KL = Create("Frame", {
            Size             = UDim2.new(0, 170, 0, 0),
            AutomaticSize    = Enum.AutomaticSize.Y,
            Position         = UDim2.new(0, 20, 0, 60),
            BackgroundColor3 = Window.CurrentThemeColors.Surface,
            BorderSizePixel  = 0,
            Parent           = Window.Gui,
        }, { Corner(5), MakeStroke(Window.CurrentThemeColors.Border, 1) })
        Window:RegisterThemeElement(KL, "BackgroundColor3", "Surface")

        local Layout = Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent    = KL,
        })

        local Header = Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency= 1,
            LayoutOrder       = 0,
            Parent            = KL,
        })
        Create("TextLabel", {
            Size                  = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency= 1,
            Text                  = "Keybinds",
            TextColor3            = Window.CurrentThemeColors.TextPrimary,
            TextSize              = 11,
            Font                  = FONT_BOLD,
            TextXAlignment        = Enum.TextXAlignment.Center,
            Parent                = Header,
        })
        Window:RegisterThemeElement(Header:FindFirstChild("TextLabel"), "TextColor3", "TextPrimary")

        MakeDraggable(KL, Header)

        local function refresh()
            for _, c in ipairs(KL:GetChildren()) do
                if c:IsA("Frame") and c.LayoutOrder > 0 then c:Destroy() end
            end
            local order = 1
            for _, bind in ipairs(Window.Keybinds) do
                if bind.Key then
                    order = order + 1
                    local row = Create("Frame", {
                        Size                  = UDim2.new(1, 0, 0, 20),
                        BackgroundTransparency= 1,
                        LayoutOrder           = order,
                        Parent                = KL,
                    })
                    Create("TextLabel", {
                        Size                  = UDim2.new(0.6, 0, 1, 0),
                        Position              = UDim2.new(0, 6, 0, 0),
                        BackgroundTransparency= 1,
                        Text                  = "•",
                        TextColor3            = Window.CurrentThemeColors.TextSecondary,
                        TextSize              = 10,
                        Font                  = FONT,
                        TextXAlignment        = Enum.TextXAlignment.Left,
                        Parent                = row,
                    })
                    Create("TextLabel", {
                        Size                  = UDim2.new(0.4, -6, 1, 0),
                        Position              = UDim2.new(0.6, 0, 0, 0),
                        BackgroundTransparency= 1,
                        Text                  = GetKeyName(bind.Key),
                        TextColor3            = Window.CurrentThemeColors.Accent,
                        TextSize              = 10,
                        Font                  = FONT_BOLD,
                        TextXAlignment        = Enum.TextXAlignment.Right,
                        Parent                = row,
                    })
                end
            end
        end
        refresh()
        return KL
    end

    local SettingsTab = Window:AddTab({ Name = "⚙ Settings" })

    local ThemeSec = SettingsTab:AddSection({ Name = "Theme Editor" })

    ThemeSec:AddDropdown({
        Name     = "Theme Preset",
        Options  = THEME_PRESETS,
        Default  = Window.CurrentTheme,
        Callback = function(v) Window:UpdateTheme(v) end,
    })

    ThemeSec:AddColorPicker({
        Name     = "Accent Color",
        Default  = Window.CurrentThemeColors.Accent,
        Callback = function(v) Window:UpdateTheme(Window.CurrentTheme, { Accent = v }) end,
    })

    ThemeSec:AddColorPicker({
        Name     = "Background Color",
        Default  = Window.CurrentThemeColors.Background,
        Callback = function(v) Window:UpdateTheme(Window.CurrentTheme, { Background = v }) end,
    })

    ThemeSec:AddSlider({
        Name     = "Window Opacity",
        Min      = 0.4, Max = 1, Default = 1,
        Suffix   = "%",
        Callback = function(v)
            Window.Opacity = v
            Window:UpdateTheme(Window.CurrentTheme)
        end,
    })

    ThemeSec:AddSlider({
        Name     = "Font Size Scale",
        Min      = 0.8, Max = 1.3, Default = 1,
        Callback = function(v) Window.FontSize = v end,
    })

    local UISec = SettingsTab:AddSection({ Name = "Core" })

    local tglBind = UISec:AddKeybind({
        Name     = "Toggle UI",
        Default  = Window.ToggleKey,
        Callback = function() end,
    })

    RunService.Heartbeat:Connect(function()
        if tglBind.Key and tglBind.Key ~= Window.ToggleKey then
            Window.ToggleKey = tglBind.Key
        end
    end)

    local ConfigSec = SettingsTab:AddSection({ Name = "Config Manager" })
    local configName = "default"

    ConfigSec:AddTextBox({
        Name        = "Config Name",
        Default     = "default",
        Placeholder = "Enter config name...",
        Callback    = function(v) configName = v end,
    })

    local cfgFuncs = {}
    pcall(function()
        cfgFuncs.write = writefile
        cfgFuncs.read  = readfile
        cfgFuncs.list  = listfiles
        cfgFuncs.mk    = makefolder
        cfgFuncs.isf   = isfolder
    end)

    local cfgList = {}
    pcall(function()
        if cfgFuncs.isf and not cfgFuncs.isf("NeverLoseUI_Configs") then
            cfgFuncs.mk("NeverLoseUI_Configs")
        end
        if cfgFuncs.list then
            for _, f in ipairs(cfgFuncs.list("NeverLoseUI_Configs")) do
                local n = f:match("([^/\\]+)%.json$") or f
                table.insert(cfgList, n)
            end
        end
    end)

    local cfgDrop = ConfigSec:AddDropdown({
        Name     = "Load Config",
        Options  = cfgList,
        Callback = function(v) configName = v end,
    })

    ConfigSec:AddButton({
        Name     = "Save Config",
        Color    = "accent",
        Callback = function()
            pcall(function()
                if cfgFuncs.isf and not cfgFuncs.isf("NeverLoseUI_Configs") then
                    cfgFuncs.mk("NeverLoseUI_Configs")
                end
                local data = HttpService:JSONEncode(Window.ConfigData)
                cfgFuncs.write("NeverLoseUI_Configs/"..configName..".json", data)
                Window:Notify("Saved!", "Config '"..configName.."' saved.", 3, "success")

                cfgList = {}
                for _, f in ipairs(cfgFuncs.list("NeverLoseUI_Configs")) do
                    local n = f:match("([^/\\]+)%.json$") or f
                    table.insert(cfgList, n)
                end
                cfgDrop.SetOptions(cfgList)
            end)
        end,
    })

    ConfigSec:AddButton({
        Name     = "Load Config",
        Callback = function()
            pcall(function()
                local data   = cfgFuncs.read("NeverLoseUI_Configs/"..configName..".json")
                local parsed = HttpService:JSONDecode(data)
                for k, v in pairs(parsed) do Window.ConfigData[k] = v end
                Window:Notify("Loaded!", "'"..configName.."' applied.", 3, "info")
            end)
        end,
    })

    ConfigSec:AddButton({
        Name     = "Delete Config",
        Color    = "danger",
        Callback = function()
            Window:Dialog({
                Title   = "Delete Config",
                Content = "Delete '"..configName.."'? This cannot be undone.",
                Buttons = {"Delete", "Cancel"},
                Callback= function(choice)
                    if choice == "Delete" then
                        pcall(function()

                            if delfile then delfile("NeverLoseUI_Configs/"..configName..".json") end
                            Window:Notify("Deleted", configName.." removed.", 3, "warning")
                        end)
                    end
                end,
            })
        end,
    })

    Window:UpdateTheme(Window.CurrentTheme)

    Window.Main.Visible                = true
    Window.Main.Size                   = UDim2.new(0, 620, 0, 440)
    Window.Main.Position               = UDim2.new(0.5, -310, 0.5, -220)
    Window.Main.BackgroundTransparency = 0
    Window.GuiVisible                  = true

    Window.ActiveTab.Page.Visible = false
    Window.ActiveTab              = nil

    return Window
end

return NeverLoseUI
