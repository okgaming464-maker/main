--[[
╔══════════════════════════════════════════════════════════════╗
║                     BankrollLib v2.0                         ║
║              bankroll.su inspired UI Library                 ║
║                   for Roblox / Lua 5.1                       ║
╚══════════════════════════════════════════════════════════════╝

QUICK START:
    local Window = BankrollLib:CreateWindow({
        Title    = "bankroll mafia",
        SubTitle = "v1.0",
        Size     = UDim2.new(0, 560, 0, 360),
    })

    local Tab = Window:CreateTab("enemy")

    local Sec = Tab:CreateSection("enemy esp", "left")
    Sec:AddToggle("box",    { Default = false, Callback = function(v) end })
    Sec:AddSlider("health", { Min = 0, Max = 100, Default = 100, Callback = function(v) end })
    Sec:AddDropdown("style", { Options = {"flat","textured","gradient"}, Default = "flat", Callback = function(v) end })
    Sec:AddColorBox("color", { Default = Color3.fromRGB(255,60,100), Callback = function(v) end })
    Sec:AddButton("reset", { Callback = function() end })
    Sec:AddKeybind("toggle key", { Default = Enum.KeyCode.Insert, Callback = function(k) end })

    local Sec2 = Tab:CreateSection("enemy chams", "right")
    Sec2:AddToggle("visible",  { Default = false })
    Sec2:AddToggle("occluded", { Default = false })
    Sec2:AddToggle("history",  { Default = false })
    Sec2:AddColorBox("visible color",  { Default = Color3.fromRGB(255,60,100) })
    Sec2:AddColorBox("occluded color", { Default = Color3.fromRGB(30,80,255)  })

    Window:CreateTab("aim")
    Window:CreateTab("visuals")
    Window:CreateTab("world")
    Window:CreateTab("misc")
    Window:CreateTab("config")

    Window:Notify("loaded successfully", 3)
]]

-- ══════════════════════════════════════════════════════════════
--  SERVICES
-- ══════════════════════════════════════════════════════════════
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local TextService        = game:GetService("TextService")

local LocalPlayer        = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════
--  THEME
-- ══════════════════════════════════════════════════════════════
local T = {
    BG              = Color3.fromRGB(13, 12, 13),
    BG2             = Color3.fromRGB(17, 16, 17),
    BG3             = Color3.fromRGB(21, 19, 21),
    BG4             = Color3.fromRGB(26, 24, 26),
    BG5             = Color3.fromRGB(30, 28, 30),
    Header          = Color3.fromRGB(10, 9, 10),
    TabBar          = Color3.fromRGB(10, 9, 10),
    SectionHeader   = Color3.fromRGB(15, 13, 15),
    Border          = Color3.fromRGB(38, 34, 38),
    BorderLight     = Color3.fromRGB(50, 46, 50),
    BorderAccent    = Color3.fromRGB(180, 40, 75),
    Accent          = Color3.fromRGB(210, 50, 90),
    AccentHover     = Color3.fromRGB(230, 70, 110),
    AccentDark      = Color3.fromRGB(100, 20, 45),
    AccentGlow      = Color3.fromRGB(255, 80, 120),
    TextBright      = Color3.fromRGB(220, 218, 220),
    TextNormal      = Color3.fromRGB(170, 165, 170),
    TextDim         = Color3.fromRGB(100, 96, 100),
    TextDisabled    = Color3.fromRGB(60, 57, 60),
    TextAccent      = Color3.fromRGB(210, 50, 90),
    ToggleOff       = Color3.fromRGB(38, 34, 38),
    ToggleOn        = Color3.fromRGB(210, 50, 90),
    SliderBG        = Color3.fromRGB(30, 27, 30),
    SliderFill      = Color3.fromRGB(210, 50, 90),
    SliderThumb     = Color3.fromRGB(240, 80, 120),
    InputBG         = Color3.fromRGB(20, 18, 20),
    DropdownBG      = Color3.fromRGB(18, 16, 18),
    DropdownHover   = Color3.fromRGB(28, 26, 28),
    KeybindBG       = Color3.fromRGB(24, 22, 24),
    ButtonBG        = Color3.fromRGB(30, 27, 30),
    ButtonHover     = Color3.fromRGB(50, 20, 35),
    ButtonActive    = Color3.fromRGB(210, 50, 90),
    TabActive       = Color3.fromRGB(210, 50, 90),
    TabInactive     = Color3.fromRGB(10, 9, 10),
    TabTextActive   = Color3.fromRGB(235, 232, 235),
    TabTextInactive = Color3.fromRGB(90, 85, 90),
    TabHover        = Color3.fromRGB(22, 20, 22),
    NotifyBG        = Color3.fromRGB(20, 18, 20),
    NotifyAccent    = Color3.fromRGB(210, 50, 90),
    ScrollThumb     = Color3.fromRGB(50, 46, 50),
}

-- ══════════════════════════════════════════════════════════════
--  CONFIG
-- ══════════════════════════════════════════════════════════════
local CFG = {
    Font            = Enum.Font.Code,
    FontBold        = Enum.Font.Code,
    TextSize        = 11,
    TextSizeSmall   = 10,
    TextSizeLarge   = 12,
    ElemHeight      = 20,
    SectionPadH     = 7,
    SectionPadV     = 5,
    ElemSpacing     = 3,
    ToggleW         = 28,
    ToggleH         = 14,
    ToggleThumb     = 10,
    SliderH         = 4,
    TitleH          = 24,
    TabH            = 22,
    BorderRadius    = 3,
    TweenSpeed      = 0.10,
    TweenSpeedFast  = 0.06,
    TweenSpeedSlow  = 0.20,
}

-- ══════════════════════════════════════════════════════════════
--  UTILITY
-- ══════════════════════════════════════════════════════════════
local Util = {}

function Util.Tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or CFG.TweenSpeed, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

function Util.Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    for _, c in ipairs(children or {}) do if c then c.Parent = obj end end
    return obj
end

function Util.Corner(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or CFG.BorderRadius)
    c.Parent = parent
    return c
end

function Util.Stroke(color, thick, parent)
    local s = Instance.new("UIStroke")
    s.Color = color or T.Border
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function Util.Padding(l, r, t, b, parent)
    local p = Instance.new("UIPadding")
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.Parent = parent
    return p
end

function Util.ListLayout(dir, halign, valign, spacing, parent)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir    or Enum.FillDirection.Vertical
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = valign or Enum.VerticalAlignment.Top
    l.Padding             = UDim.new(0, spacing or 0)
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

function Util.Label(props, parent)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font           = props.Font     or CFG.Font
    lbl.TextSize       = props.TextSize or CFG.TextSize
    lbl.TextColor3     = props.Color    or T.TextNormal
    lbl.Text           = props.Text     or ""
    lbl.TextXAlignment = props.AlignX   or Enum.TextXAlignment.Left
    lbl.TextYAlignment = props.AlignY   or Enum.TextYAlignment.Center
    lbl.Size           = props.Size     or UDim2.new(1, 0, 1, 0)
    lbl.Position       = props.Position or UDim2.new(0, 0, 0, 0)
    lbl.ZIndex         = props.ZIndex   or 2
    lbl.RichText       = props.RichText or false
    lbl.TextTruncate   = props.Truncate or Enum.TextTruncate.AtEnd
    lbl.Parent = parent
    return lbl
end

function Util.Draggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local d = inp.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

local function MakeRow(parent, height)
    return Util.Create("Frame", {
        Size                   = UDim2.new(1, 0, 0, height or CFG.ElemHeight),
        BackgroundTransparency = 1,
        Parent                 = parent,
    })
end

-- ══════════════════════════════════════════════════════════════
--  LIBRARY
-- ══════════════════════════════════════════════════════════════
local BankrollLib = {}
BankrollLib.__index = BankrollLib

function BankrollLib:CreateWindow(config)
    config = config or {}
    local title    = config.Title    or "bankroll"
    local subtitle = config.SubTitle or ""
    local size     = config.Size     or UDim2.new(0, 560, 0, 360)
    local pos      = config.Position or UDim2.new(0.5, -280, 0.5, -180)

    local guiParent
    pcall(function() guiParent = game:GetService("CoreGui") end)
    if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

    local ScreenGui = Util.Create("ScreenGui", {
        Name           = "BankrollLib_" .. tostring(math.random(1000,9999)),
        ResetOnSpawn   = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999,
        IgnoreGuiInset = true,
        Parent         = guiParent,
    })

    -- ── Main Frame ──────────────────────────────────────────
    local Main = Util.Create("Frame", {
        Name             = "Main",
        Size             = size,
        Position         = pos,
        BackgroundColor3 = T.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = false,
        Parent           = ScreenGui,
    })
    Util.Corner(4, Main)
    Util.Stroke(T.Border, 1, Main)

    -- shadow
    Util.Create("ImageLabel", {
        Name                 = "Shadow",
        Size                 = UDim2.new(1, 30, 1, 30),
        Position             = UDim2.new(0, -15, 0, -5),
        BackgroundTransparency = 1,
        Image                = "rbxassetid://6014261993",
        ImageColor3          = Color3.fromRGB(0,0,0),
        ImageTransparency    = 0.5,
        ScaleType            = Enum.ScaleType.Slice,
        SliceCenter          = Rect.new(49,49,450,450),
        ZIndex               = 0,
        Parent               = Main,
    })

    -- ── Title Bar ───────────────────────────────────────────
    local TitleBar = Util.Create("Frame", {
        Name             = "TitleBar",
        Size             = UDim2.new(1, 0, 0, CFG.TitleH),
        BackgroundColor3 = T.Header,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = Main,
    })
    Util.Corner(4, TitleBar)
    -- cover bottom corners
    Util.Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 4),
        Position         = UDim2.new(0, 0, 1, -4),
        BackgroundColor3 = T.Header,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TitleBar,
    })
    -- bottom border line
    Util.Create("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 4,
        Parent           = TitleBar,
    })
    -- left accent dot
    Util.Create("Frame", {
        Size             = UDim2.new(0, 3, 0, 3),
        Position         = UDim2.new(0, 8, 0.5, -1),
        BackgroundColor3 = T.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 4,
        Parent           = TitleBar,
    })

    Util.Label({
        Text     = title,
        Color    = T.TextNormal,
        TextSize = CFG.TextSizeLarge,
        Font     = CFG.FontBold,
        Size     = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        ZIndex   = 4,
    }, TitleBar)

    if subtitle ~= "" then
        Util.Label({
            Text     = subtitle,
            Color    = T.TextDim,
            TextSize = CFG.TextSizeSmall,
            Size     = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 130, 0, 0),
            ZIndex   = 4,
        }, TitleBar)
    end

    local function MakeWinBtn(symbol, xOff, normalColor, hoverColor, action)
        local btn = Util.Create("TextButton", {
            Text                   = symbol,
            Font                   = CFG.FontBold,
            TextSize               = 14,
            TextColor3             = normalColor,
            BackgroundTransparency = 1,
            Size                   = UDim2.new(0, 20, 1, 0),
            Position               = UDim2.new(1, xOff, 0, 0),
            ZIndex                 = 5,
            AutoButtonColor        = false,
            Parent                 = TitleBar,
        })
        btn.MouseEnter:Connect(function() Util.Tween(btn, {TextColor3 = hoverColor}) end)
        btn.MouseLeave:Connect(function() Util.Tween(btn, {TextColor3 = normalColor}) end)
        btn.MouseButton1Click:Connect(action)
        return btn
    end

    local minimized = false
    local ContentHolder

    MakeWinBtn("×", -22, T.TextDim, T.AccentGlow, function() ScreenGui:Destroy() end)
    MakeWinBtn("−", -44, T.TextDim, T.TextBright, function()
        minimized = not minimized
        if ContentHolder then
            ContentHolder.Visible = not minimized
            Util.Tween(Main, {
                Size = minimized and UDim2.new(size.X.Scale, size.X.Offset, 0, CFG.TitleH) or size
            }, CFG.TweenSpeedSlow)
        end
    end)

    Util.Draggable(Main, TitleBar)

    -- ── Content Holder ──────────────────────────────────────
    ContentHolder = Util.Create("Frame", {
        Name             = "ContentHolder",
        Size             = UDim2.new(1, 0, 1, -(CFG.TitleH + CFG.TabH)),
        Position         = UDim2.new(0, 0, 0, CFG.TitleH),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex           = 2,
        Parent           = Main,
    })

    -- ── Tab Bar ─────────────────────────────────────────────
    local TabBar = Util.Create("Frame", {
        Name             = "TabBar",
        Size             = UDim2.new(1, 0, 0, CFG.TabH),
        Position         = UDim2.new(0, 0, 1, -CFG.TabH),
        BackgroundColor3 = T.TabBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = Main,
    })
    Util.Corner(4, TabBar)
    Util.Create("Frame", { -- cover top corners
        Size             = UDim2.new(1, 0, 0, 4),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = T.TabBar,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TabBar,
    })
    Util.Create("Frame", { -- top border
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        ZIndex           = 3,
        Parent           = TabBar,
    })
    Util.ListLayout(Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center, 0, TabBar)

    -- ── Notification holder ──────────────────────────────────
    local NotifHolder = Util.Create("Frame", {
        Name             = "NotifHolder",
        Size             = UDim2.new(0, 220, 1, 0),
        Position         = UDim2.new(1, 10, 0, 0),
        BackgroundTransparency = 1,
        ZIndex           = 20,
        Parent           = Main,
    })
    Util.ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Bottom, 4, NotifHolder)

    -- ── Window Object ────────────────────────────────────────
    local Window = {
        ScreenGui     = ScreenGui,
        Main          = Main,
        TabBar        = TabBar,
        ContentHolder = ContentHolder,
        Tabs          = {},
        ActiveTab     = nil,
    }

    function Window:Notify(text, duration)
        duration = duration or 3
        local nf = Util.Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.NotifyBG,
            BorderSizePixel  = 0,
            ZIndex           = 21,
            ClipsDescendants = true,
            Parent           = NotifHolder,
        })
        Util.Corner(3, nf)
        Util.Stroke(T.Border, 1, nf)

        Util.Create("Frame", { -- accent bar
            Size             = UDim2.new(0, 2, 1, 0),
            BackgroundColor3 = T.Accent,
            BorderSizePixel  = 0,
            ZIndex           = 22,
            Parent           = nf,
        })

        Util.Label({
            Text     = text,
            Color    = T.TextNormal,
            TextSize = CFG.TextSizeSmall,
            Size     = UDim2.new(1, -10, 1, -4),
            Position = UDim2.new(0, 8, 0, 2),
            ZIndex   = 22,
        }, nf)

        local progBG = Util.Create("Frame", {
            Size             = UDim2.new(1, 0, 0, 2),
            Position         = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = T.Border,
            BorderSizePixel  = 0,
            ZIndex           = 22,
            Parent           = nf,
        })
        local prog = Util.Create("Frame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = T.Accent,
            BorderSizePixel  = 0,
            ZIndex           = 23,
            Parent           = progBG,
        })
        Util.Tween(prog, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

        task.delay(duration, function()
            Util.Tween(nf, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35)
            nf:Destroy()
        end)
    end

    function Window:_SelectTab(tab)
        for _, t in ipairs(self.Tabs) do
            t.Frame.Visible = false
            Util.Tween(t.Button, {BackgroundColor3 = T.TabInactive, TextColor3 = T.TabTextInactive})
            if t._ind then Util.Tween(t._ind, {BackgroundTransparency = 1}) end
        end
        tab.Frame.Visible = true
        Util.Tween(tab.Button, {BackgroundColor3 = T.TabActive, TextColor3 = T.TabTextActive})
        if tab._ind then Util.Tween(tab._ind, {BackgroundTransparency = 0}) end
        self.ActiveTab = tab
    end

    function Window:CreateTab(name)
        local tab = { Name = name, Sections = {}, _colIdx = 0 }

        local textW = TextService:GetTextSize(name, CFG.TextSizeSmall, CFG.Font, Vector2.new(999,999)).X
        local btnW  = math.max(textW + 20, 55)

        local btn = Util.Create("TextButton", {
            Text             = name,
            Font             = CFG.Font,
            TextSize         = CFG.TextSizeSmall,
            TextColor3       = T.TabTextInactive,
            BackgroundColor3 = T.TabInactive,
            BorderSizePixel  = 0,
            Size             = UDim2.new(0, btnW, 1, 0),
            AutoButtonColor  = false,
            ZIndex           = 4,
            Parent           = TabBar,
        })

        local ind = Util.Create("Frame", { -- top active indicator line
            Size                   = UDim2.new(1, 0, 0, 2),
            Position               = UDim2.new(0, 0, 0, 0),
            BackgroundColor3       = T.AccentGlow,
            BorderSizePixel        = 0,
            BackgroundTransparency = 1,
            ZIndex                 = 5,
            Parent                 = btn,
        })
        tab._ind = ind
        tab.Button = btn

        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= tab then
                Util.Tween(btn, {BackgroundColor3 = T.TabHover, TextColor3 = T.TextDim})
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= tab then
                Util.Tween(btn, {BackgroundColor3 = T.TabInactive, TextColor3 = T.TabTextInactive})
            end
        end)
        btn.MouseButton1Click:Connect(function() self:_SelectTab(tab) end)

        local frame = Util.Create("Frame", {
            Name             = name .. "_Frame",
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible          = false,
            ZIndex           = 2,
            Parent           = ContentHolder,
        })
        tab.Frame = frame

        -- center divider
        Util.Create("Frame", {
            Size             = UDim2.new(0, 1, 1, 0),
            Position         = UDim2.new(0.5, 0, 0, 0),
            BackgroundColor3 = T.Border,
            BorderSizePixel  = 0,
            ZIndex           = 2,
            Parent           = frame,
        })

        local function MakeScrollCol(xPos)
            local sc = Util.Create("ScrollingFrame", {
                Size                  = UDim2.new(0.5, -1, 1, 0),
                Position              = UDim2.new(xPos, xPos == 0 and 0 or 1, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel       = 0,
                ScrollBarThickness    = 2,
                ScrollBarImageColor3  = T.ScrollThumb,
                CanvasSize            = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize   = Enum.AutomaticSize.Y,
                ZIndex                = 2,
                Parent                = frame,
            })
            Util.ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top, 1, sc)
            return sc
        end

        tab.LeftScroll  = MakeScrollCol(0)
        tab.RightScroll = MakeScrollCol(0.5)

        -- ── CreateSection ────────────────────────────────────
        function tab:CreateSection(sName, side)
            local col
            if side == "left" then
                col = self.LeftScroll
            elseif side == "right" then
                col = self.RightScroll
            else
                self._colIdx = self._colIdx + 1
                col = (self._colIdx % 2 == 1) and self.LeftScroll or self.RightScroll
            end

            local section = {}

            local Wrapper = Util.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel  = 0,
                ZIndex           = 2,
                Parent           = col,
            })

            -- section header
            local HeaderRow = Util.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 18),
                BackgroundColor3 = T.SectionHeader,
                BorderSizePixel  = 0,
                ZIndex           = 2,
                Parent           = Wrapper,
            })
            Util.Create("Frame", { -- left accent bar
                Size             = UDim2.new(0, 2, 0, 10),
                Position         = UDim2.new(0, 0, 0.5, -5),
                BackgroundColor3 = T.Accent,
                BorderSizePixel  = 0,
                ZIndex           = 3,
                Parent           = HeaderRow,
            })
            Util.Label({
                Text     = sName,
                Color    = T.TextDim,
                TextSize = CFG.TextSizeSmall,
                Font     = CFG.FontBold,
                Size     = UDim2.new(1, -8, 1, 0),
                Position = UDim2.new(0, 7, 0, 0),
                ZIndex   = 3,
            }, HeaderRow)

            -- section body
            local Body = Util.Create("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundColor3 = T.BG2,
                BorderSizePixel  = 0,
                ZIndex           = 2,
                Parent           = Wrapper,
            })
            Util.Padding(CFG.SectionPadH, CFG.SectionPadH, CFG.SectionPadV, CFG.SectionPadV, Body)
            Util.ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top, CFG.ElemSpacing, Body)

            -- ══════════════════════════════════════════════════
            --  TOGGLE
            -- ══════════════════════════════════════════════════
            function section:AddToggle(label, config)
                config   = config or {}
                local val      = config.Default  == true
                local cb       = config.Callback or function() end
                local disabled = config.Disabled or false

                local Row = MakeRow(Body)

                Util.Label({
                    Text     = label,
                    Color    = disabled and T.TextDisabled or T.TextNormal,
                    TextSize = CFG.TextSize,
                    Size     = UDim2.new(1, -(CFG.ToggleW + 6), 1, 0),
                    ZIndex   = 3,
                }, Row)

                local TglBG = Util.Create("Frame", {
                    Size             = UDim2.new(0, CFG.ToggleW, 0, CFG.ToggleH),
                    Position         = UDim2.new(1, -CFG.ToggleW, 0.5, -CFG.ToggleH/2),
                    BackgroundColor3 = val and T.ToggleOn or T.ToggleOff,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = Row,
                })
                Util.Corner(CFG.ToggleH/2, TglBG)
                Util.Stroke(val and T.AccentDark or T.Border, 1, TglBG)

                local thumbX = val and (CFG.ToggleW - CFG.ToggleThumb - 2) or 2
                local Thumb  = Util.Create("Frame", {
                    Size             = UDim2.new(0, CFG.ToggleThumb, 0, CFG.ToggleThumb),
                    Position         = UDim2.new(0, thumbX, 0.5, -CFG.ToggleThumb/2),
                    BackgroundColor3 = val and Color3.new(1,1,1) or T.TextDim,
                    BorderSizePixel  = 0,
                    ZIndex           = 4,
                    Parent           = TglBG,
                })
                Util.Corner(CFG.ToggleThumb/2, Thumb)

                local toggle = { Value = val }

                local function Refresh()
                    local on = toggle.Value
                    Util.Tween(TglBG, {BackgroundColor3 = on and T.ToggleOn or T.ToggleOff})
                    Util.Tween(Thumb, {
                        Position         = UDim2.new(0, on and (CFG.ToggleW - CFG.ToggleThumb - 2) or 2, 0.5, -CFG.ToggleThumb/2),
                        BackgroundColor3 = on and Color3.new(1,1,1) or T.TextDim,
                    })
                    local stroke = TglBG:FindFirstChildOfClass("UIStroke")
                    if stroke then Util.Tween(stroke, {Color = on and T.AccentDark or T.Border}) end
                end

                if not disabled then
                    local Btn = Util.Create("TextButton", {
                        Text                   = "",
                        BackgroundTransparency = 1,
                        Size                   = UDim2.new(1, 0, 1, 0),
                        ZIndex                 = 5,
                        Parent                 = Row,
                    })
                    Btn.MouseButton1Click:Connect(function()
                        toggle.Value = not toggle.Value
                        Refresh()
                        cb(toggle.Value)
                    end)
                    Row.MouseEnter:Connect(function()
                        if not toggle.Value then Util.Tween(TglBG, {BackgroundColor3 = T.BG4}) end
                    end)
                    Row.MouseLeave:Connect(function()
                        if not toggle.Value then Util.Tween(TglBG, {BackgroundColor3 = T.ToggleOff}) end
                    end)
                end

                function toggle:Set(v) self.Value = v; Refresh(); cb(v) end
                return toggle
            end

            -- ══════════════════════════════════════════════════
            --  SLIDER
            -- ══════════════════════════════════════════════════
            function section:AddSlider(label, config)
                config = config or {}
                local minV    = config.Min     or 0
                local maxV    = config.Max     or 100
                local default = math.clamp(config.Default or minV, minV, maxV)
                local suffix  = config.Suffix  or ""
                local step    = config.Step    or 1
                local cb      = config.Callback or function() end

                local Container = Util.Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, CFG.ElemHeight + 12),
                    BackgroundTransparency = 1,
                    ZIndex           = 3,
                    Parent           = Body,
                })

                Util.Label({
                    Text     = label,
                    Color    = T.TextNormal,
                    TextSize = CFG.TextSize,
                    Size     = UDim2.new(1, -50, 0, CFG.ElemHeight),
                    ZIndex   = 3,
                }, Container)

                local ValLbl = Util.Label({
                    Text     = tostring(default) .. suffix,
                    Color    = T.TextAccent,
                    TextSize = CFG.TextSize,
                    Size     = UDim2.new(0, 46, 0, CFG.ElemHeight),
                    Position = UDim2.new(1, -46, 0, 0),
                    AlignX   = Enum.TextXAlignment.Right,
                    ZIndex   = 3,
                }, Container)

                local Track = Util.Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, CFG.SliderH),
                    Position         = UDim2.new(0, 0, 0, CFG.ElemHeight + 4),
                    BackgroundColor3 = T.SliderBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = Container,
                })
                Util.Corner(CFG.SliderH/2, Track)

                local pct = (default - minV) / (maxV - minV)

                local Fill = Util.Create("Frame", {
                    Size             = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = T.SliderFill,
                    BorderSizePixel  = 0,
                    ZIndex           = 4,
                    Parent           = Track,
                })
                Util.Corner(CFG.SliderH/2, Fill)

                local Thumb = Util.Create("Frame", {
                    Size             = UDim2.new(0, 8, 0, 8),
                    Position         = UDim2.new(pct, -4, 0.5, -4),
                    BackgroundColor3 = T.SliderThumb,
                    BorderSizePixel  = 0,
                    ZIndex           = 5,
                    Parent           = Track,
                })
                Util.Corner(4, Thumb)
                Util.Stroke(T.AccentDark, 1, Thumb)

                local slider  = { Value = default }
                local sliding = false

                local function CalcVal(inputX)
                    local rel = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                    local raw = minV + (maxV - minV) * rel
                    return math.clamp(math.round(raw / step) * step, minV, maxV), rel
                end

                local function SetVal(v, rel)
                    rel = rel or (v - minV) / (maxV - minV)
                    slider.Value  = v
                    Fill.Size     = UDim2.new(rel, 0, 1, 0)
                    Thumb.Position= UDim2.new(rel, -4, 0.5, -4)
                    ValLbl.Text   = tostring(v) .. suffix
                    cb(v)
                end

                Track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        local v, r = CalcVal(inp.Position.X)
                        SetVal(v, r)
                    end
                end)

                Track.MouseEnter:Connect(function()
                    Util.Tween(Thumb, {Size = UDim2.new(0, 10, 0, 10)})
                end)
                Track.MouseLeave:Connect(function()
                    if not sliding then Util.Tween(Thumb, {Size = UDim2.new(0, 8, 0, 8)}) end
                end)

                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local v, r = CalcVal(inp.Position.X)
                        SetVal(v, r)
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
                end)

                function slider:Set(v)
                    v = math.clamp(v, minV, maxV)
                    SetVal(v, (v - minV) / (maxV - minV))
                end

                return slider
            end

            -- ══════════════════════════════════════════════════
            --  DROPDOWN
            -- ══════════════════════════════════════════════════
            function section:AddDropdown(label, config)
                config = config or {}
                local opts    = config.Options  or {}
                local default = config.Default  or (opts[1] or "")
                local cb      = config.Callback or function() end

                local Container = Util.Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, CFG.ElemHeight),
                    BackgroundTransparency = 1,
                    ZIndex           = 3,
                    ClipsDescendants = false,
                    Parent           = Body,
                })

                if label and label ~= "" then
                    Util.Label({
                        Text     = label,
                        Color    = T.TextDim,
                        TextSize = CFG.TextSizeSmall,
                        Size     = UDim2.new(1, 0, 0, 13),
                        Position = UDim2.new(0, 0, 0, -13),
                        ZIndex   = 3,
                    }, Container)
                end

                local Display = Util.Create("Frame", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = T.InputBG,
                    BorderSizePixel  = 0,
                    ZIndex           = 3,
                    Parent           = Container,
                })
                Util.Corner(CFG.BorderRadius, Display)
                Util.Stroke(T.Border, 1, Display)

                local SelLabel = Util.Label({
                    Text     = default,
                    Color    = T.TextAccent,
                    TextSize = CFG.TextSize,
                    Size     = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 6, 0, 0),
                    ZIndex   = 4,
                }, Display)

                local Arrow = Util.Label({
                    Text     = "▾",
                    Color    = T.TextDim,
                    TextSize = 10,
                    Size     = UDim2.new(0, 16, 1, 0),
                    Position = UDim2.new(1, -16, 0, 0),
                    AlignX   = Enum.TextXAlignment.Center,
                    ZIndex   = 4,
                }, Display)

                local ListFrame = Util.Create("Frame", {
                    Size             = UDim2.new(1, 0, 0, math.min(#opts, 6) * 18 + 6),
                    Position         = UDim2.new(0, 0, 1, 3),
                    BackgroundColor3 = T.DropdownBG,
                    BorderSizePixel  = 0,
                    Visible          = false,
                    ZIndex           = 20,
                    ClipsDescendants = true,
                    Parent           = Container,
                })
                Util.Corner(CFG.BorderRadius, ListFrame)
                Util.Stroke(T.BorderLight, 1, ListFrame)
                Util.Padding(3, 3, 3, 3, ListFrame)
                Util.ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top, 0, ListFrame)

                local dropdown = { Value = default, Open = false, OptButtons = {} }

                for _, opt in ipairs(opts) do
                    local isSel = (opt == default)
                    local OptBtn = Util.Create("TextButton", {
                        Text             = opt,
                        Font             = CFG.Font,
                        TextSize         = CFG.TextSize,
                        TextColor3       = isSel and T.TextAccent or T.TextNormal,
                        BackgroundColor3 = isSel and T.DropdownHover or T.DropdownBG,
                        BorderSizePixel  = 0,
                        Size             = UDim2.new(1, 0, 0, 18),
                        TextXAlignment   = Enum.TextXAlignment.Left,
                        AutoButtonColor  = false,
                        ZIndex           = 21,
                        Parent           = ListFrame,
                    })
                    Util.Corner(2, OptBtn)
                    Util.Padding(5, 5, 0, 0, OptBtn)

                    OptBtn.MouseEnter:Connect(function()
                        if opt ~= dropdown.Value then Util.Tween(OptBtn, {BackgroundColor3 = T.DropdownHover}) end
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        if opt ~= dropdown.Value then Util.Tween(OptBtn, {BackgroundColor3 = T.DropdownBG}) end
                    end)
                    OptBtn.MouseButton1Click:Connect(function()
                        for _, b in ipairs(dropdown.OptButtons) do
                            b.TextColor3 = T.TextNormal; b.BackgroundColor3 = T.DropdownBG
                        end
                        OptBtn.TextColor3 = T.TextAccent; OptBtn.BackgroundColor3 = T.DropdownHover
                        dropdown.Value = opt; SelLabel.Text = opt
                        ListFrame.Visible = false; dropdown.Open = false; Arrow.Text = "▾"
                        cb(opt)
                    end)
                    table.insert(dropdown.OptButtons, OptBtn)
                end

                local TogBtn = Util.Create("TextButton", {
                    Text = "", BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 5, Parent = Display,
                })
                TogBtn.MouseButton1Click:Connect(function()
                    dropdown.Open = not dropdown.Open
                    ListFrame.Visible = dropdown.Open
                    Arrow.Text = dropdown.Open and "▴" or "▾"
                end)
                Display.MouseEnter:Connect(function() Util.Tween(Display, {BackgroundColor3 = T.BG4}) end)
                Display.MouseLeave:Connect(function() Util.Tween(Display, {BackgroundColor3 = T.InputBG}) end)

                function dropdown:Set(v)
                    self.Value = v; SelLabel.Text = v
                    for _, b in ipairs(self.OptButtons) do
                        local isV = (b.Text == v)
                        b.TextColor3 = isV and T.TextAccent or T.TextNormal
                        b.BackgroundColor3 = isV and T.DropdownHover or T.DropdownBG
                    end
                    cb(v)
                end

                return dropdown
            end

            -- ══════════════════════════════════════════════════
            --  COLOR BOX
            -- ══════════════════════════════════════════════════
            function section:AddColorBox(label, config)
                config = config or {}
                local val = config.Default or Color3.fromRGB(255, 60, 100)
                local cb  = config.Callback or function() end

                local Row = MakeRow(Body)

                Util.Label({
                    Text = label, Color = T.TextNormal,
                    TextSize = CFG.TextSize,
                    Size = UDim2.new(1, -50, 1, 0), ZIndex = 3,
                }, Row)

                local BoxHolder = Util.Create("Frame", {
                    Size = UDim2.new(0, 46, 0, 12),
                    Position = UDim2.new(1, -46, 0.5, -6),
                    BackgroundTransparency = 1, ZIndex = 3, Parent = Row,
                })
                Util.ListLayout(Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Center, 2, BoxHolder)

                local function MakeBox(color)
                    local b = Util.Create("Frame", {
                        Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = color,
                        BorderSizePixel = 0, ZIndex = 4, Parent = BoxHolder,
                    })
                    Util.Corner(2, b); Util.Stroke(T.Border, 1, b)
                    return b
                end

                local r, g, bv = val.R*255, val.G*255, val.B*255
                local mainBox = MakeBox(val)
                MakeBox(Color3.fromRGB(math.clamp(r*0.6,0,255), math.clamp(g*0.6,0,255), math.clamp(bv*0.6,0,255)))
                MakeBox(Color3.fromRGB(math.clamp(r*1.3,0,255), math.clamp(g*1.3,0,255), math.clamp(bv*1.3,0,255)))

                local colorbox  = { Value = val }
                local pickerOpen = false
                local PickerFrame

                local Btn = Util.Create("TextButton", {
                    Text = "", BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0), ZIndex = 5, Parent = Row,
                })

                Btn.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    if PickerFrame then PickerFrame:Destroy(); PickerFrame = nil end
                    if not pickerOpen then return end

                    PickerFrame = Util.Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 86), Position = UDim2.new(0, 0, 1, 4),
                        BackgroundColor3 = T.BG3, BorderSizePixel = 0, ZIndex = 30, Parent = Row,
                    })
                    Util.Corner(3, PickerFrame); Util.Stroke(T.BorderLight, 1, PickerFrame)
                    Util.Padding(6, 6, 6, 6, PickerFrame)
                    Util.ListLayout(Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top, 4, PickerFrame)

                    local channels = {colorbox.Value.R*255, colorbox.Value.G*255, colorbox.Value.B*255}
                    local chLabels = {"R", "G", "B"}

                    local function RebuildColor()
                        colorbox.Value = Color3.fromRGB(
                            math.clamp(channels[1],0,255),
                            math.clamp(channels[2],0,255),
                            math.clamp(channels[3],0,255)
                        )
                        mainBox.BackgroundColor3 = colorbox.Value
                        cb(colorbox.Value)
                    end

                    for i = 1, 3 do
                        local slRow = Util.Create("Frame", {
                            Size = UDim2.new(1, 0, 0, 18),
                            BackgroundTransparency = 1, ZIndex = 31, Parent = PickerFrame,
                        })
                        Util.Label({
                            Text = chLabels[i], Color = T.TextDim, TextSize = CFG.TextSizeSmall,
                            Size = UDim2.new(0, 12, 1, 0), ZIndex = 31,
                        }, slRow)

                        local slTrack = Util.Create("Frame", {
                            Size = UDim2.new(1, -40, 0, 4), Position = UDim2.new(0, 14, 0.5, -2),
                            BackgroundColor3 = T.SliderBG, BorderSizePixel = 0, ZIndex = 31, Parent = slRow,
                        })
                        Util.Corner(2, slTrack)

                        local slFill = Util.Create("Frame", {
                            Size = UDim2.new(channels[i]/255, 0, 1, 0),
                            BackgroundColor3 = T.SliderFill, BorderSizePixel = 0, ZIndex = 32, Parent = slTrack,
                        })
                        Util.Corner(2, slFill)

                        local valLbl = Util.Label({
                            Text = tostring(math.floor(channels[i])), Color = T.TextDim,
                            TextSize = CFG.TextSizeSmall, Size = UDim2.new(0, 24, 1, 0),
                            Position = UDim2.new(1, -24, 0, 0), AlignX = Enum.TextXAlignment.Right, ZIndex = 31,
                        }, slRow)

                        local idx = i
                        local slSliding = false

                        slTrack.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                                slSliding = true
                                local rel = math.clamp((inp.Position.X - slTrack.AbsolutePosition.X) / slTrack.AbsoluteSize.X, 0, 1)
                                channels[idx] = math.floor(rel * 255)
                                slFill.Size = UDim2.new(rel, 0, 1, 0)
                                valLbl.Text = tostring(channels[idx])
                                RebuildColor()
                            end
                        end)
                        UserInputService.InputChanged:Connect(function(inp)
                            if slSliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                                local rel = math.clamp((inp.Position.X - slTrack.AbsolutePosition.X) / slTrack.AbsoluteSize.X, 0, 1)
                                channels[idx] = math.floor(rel * 255)
                                slFill.Size = UDim2.new(rel, 0, 1, 0)
                                valLbl.Text = tostring(channels[idx])
                                RebuildColor()
                            end
                        end)
                        UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then slSliding = false end
                        end)
                    end
                end)

                function colorbox:Set(color) self.Value = color; mainBox.BackgroundColor3 = color; cb(color) end
                return colorbox
            end

            -- ══════════════════════════════════════════════════
            --  BUTTON
            -- ══════════════════════════════════════════════════
            function section:AddButton(label, config)
                config = config or {}
                local cb = config.Callback or function() end

                local Btn = Util.Create("TextButton", {
                    Text = label, Font = CFG.Font, TextSize = CFG.TextSize,
                    TextColor3 = T.TextNormal, BackgroundColor3 = T.ButtonBG,
                    BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, CFG.ElemHeight),
                    AutoButtonColor = false, ZIndex = 3, Parent = Body,
                })
                Util.Corner(CFG.BorderRadius, Btn); Util.Stroke(T.Border, 1, Btn)

                Btn.MouseEnter:Connect(function() Util.Tween(Btn, {BackgroundColor3 = T.ButtonHover, TextColor3 = T.TextBright}) end)
                Btn.MouseLeave:Connect(function() Util.Tween(Btn, {BackgroundColor3 = T.ButtonBG, TextColor3 = T.TextNormal}) end)
                Btn.MouseButton1Down:Connect(function() Util.Tween(Btn, {BackgroundColor3 = T.ButtonActive}) end)
                Btn.MouseButton1Up:Connect(function() Util.Tween(Btn, {BackgroundColor3 = T.ButtonHover}); cb() end)

                return Btn
            end

            -- ══════════════════════════════════════════════════
            --  KEYBIND
            -- ══════════════════════════════════════════════════
            function section:AddKeybind(label, config)
                config = config or {}
                local default   = config.Default  or Enum.KeyCode.Unknown
                local cb        = config.Callback or function() end

                local Row = MakeRow(Body)

                Util.Label({
                    Text = label, Color = T.TextNormal, TextSize = CFG.TextSize,
                    Size = UDim2.new(1, -70, 1, 0), ZIndex = 3,
                }, Row)

                local KeyDisplay = Util.Create("TextButton", {
                    Text = default.Name, Font = CFG.Font, TextSize = CFG.TextSizeSmall,
                    TextColor3 = T.TextAccent, BackgroundColor3 = T.KeybindBG,
                    BorderSizePixel = 0, Size = UDim2.new(0, 64, 0, 14),
                    Position = UDim2.new(1, -64, 0.5, -7), AutoButtonColor = false,
                    ZIndex = 3, Parent = Row,
                })
                Util.Corner(2, KeyDisplay); Util.Stroke(T.Border, 1, KeyDisplay)

                local keybind   = { Value = default }
                local listening = false

                KeyDisplay.MouseButton1Click:Connect(function()
                    listening = true
                    KeyDisplay.Text = "..."; KeyDisplay.TextColor3 = T.TextDim
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if listening and not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
                        keybind.Value = inp.KeyCode
                        KeyDisplay.Text = inp.KeyCode.Name; KeyDisplay.TextColor3 = T.TextAccent
                        listening = false; cb(inp.KeyCode)
                    end
                end)

                function keybind:Set(key) self.Value = key; KeyDisplay.Text = key.Name; cb(key) end
                return keybind
            end

            -- ══════════════════════════════════════════════════
            --  TEXT BOX
            -- ══════════════════════════════════════════════════
            function section:AddTextBox(label, config)
                config = config or {}
                local default     = config.Default     or ""
                local placeholder = config.Placeholder or "..."
                local cb          = config.Callback    or function() end

                local Container = Util.Create("Frame", {
                    Size = UDim2.new(1, 0, 0, CFG.ElemHeight + (label ~= "" and 14 or 0)),
                    BackgroundTransparency = 1, ZIndex = 3, Parent = Body,
                })

                if label and label ~= "" then
                    Util.Label({
                        Text = label, Color = T.TextDim, TextSize = CFG.TextSizeSmall,
                        Size = UDim2.new(1, 0, 0, 13), Position = UDim2.new(0, 0, 0, 0), ZIndex = 3,
                    }, Container)
                end

                local Box = Util.Create("TextBox", {
                    Text = default, PlaceholderText = placeholder,
                    PlaceholderColor3 = T.TextDisabled, Font = CFG.Font,
                    TextSize = CFG.TextSize, TextColor3 = T.TextNormal,
                    BackgroundColor3 = T.InputBG, BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, CFG.ElemHeight),
                    Position = UDim2.new(0, 0, 0, label ~= "" and 14 or 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false, ZIndex = 3, Parent = Container,
                })
                Util.Corner(CFG.BorderRadius, Box); Util.Stroke(T.Border, 1, Box); Util.Padding(6, 6, 0, 0, Box)

                Box.Focused:Connect(function()
                    Util.Tween(Box, {BackgroundColor3 = T.BG4})
                    local s = Box:FindFirstChildOfClass("UIStroke")
                    if s then Util.Tween(s, {Color = T.BorderAccent}) end
                end)
                Box.FocusLost:Connect(function()
                    Util.Tween(Box, {BackgroundColor3 = T.InputBG})
                    local s = Box:FindFirstChildOfClass("UIStroke")
                    if s then Util.Tween(s, {Color = T.Border}) end
                    cb(Box.Text)
                end)

                local textbox = { Value = default }
                function textbox:Set(v) self.Value = v; Box.Text = v; cb(v) end
                return textbox
            end

            -- ══════════════════════════════════════════════════
            --  LABEL
            -- ══════════════════════════════════════════════════
            function section:AddLabel(text, color)
                Util.Label({
                    Text = text, Color = color or T.TextDim,
                    TextSize = CFG.TextSizeSmall,
                    Size = UDim2.new(1, 0, 0, CFG.ElemHeight), ZIndex = 3,
                }, Body)
            end

            -- ══════════════════════════════════════════════════
            --  SEPARATOR
            -- ══════════════════════════════════════════════════
            function section:AddSeparator()
                Util.Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = T.Border,
                    BorderSizePixel = 0, ZIndex = 3, Parent = Body,
                })
            end

            return section
        end -- CreateSection

        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then self:_SelectTab(tab) end
        return tab
    end -- CreateTab

    function Window:Destroy() ScreenGui:Destroy() end

    return Window
end -- CreateWindow

return BankrollLib
