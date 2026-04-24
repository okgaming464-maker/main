--[[
    BankrollLib - Roblox UI Library
    Style: bankroll.su inspired (dark, compact, pink/red accents)
    
    USAGE EXAMPLE:
    
    local BankrollLib = loadstring(game:HttpGet("your_url_here"))()
    
    local Window = BankrollLib:CreateWindow({
        Title = "bankroll mafia",
        Size = UDim2.new(0, 500, 0, 340),
    })
    
    local EnemyTab = Window:CreateTab("enemy")
    local VisualsSection = EnemyTab:CreateSection("enemy esp")
    
    VisualsSection:AddToggle("box", {
        Default = false,
        Callback = function(v) print("box:", v) end
    })
    
    VisualsSection:AddSlider("health", {
        Min = 0, Max = 100, Default = 50,
        Callback = function(v) print("health:", v) end
    })
    
    VisualsSection:AddDropdown("text, bar, gradient", {
        Options = {"text", "bar", "gradient"},
        Default = "gradient",
        Callback = function(v) print("style:", v) end
    })
    
    VisualsSection:AddToggle("animated", {
        Default = true,
        Callback = function(v) end
    })
    
    VisualsSection:AddToggle("out of view indicator", {
        Default = false,
        Callback = function(v) end
    })
]]

local BankrollLib = {}
BankrollLib.__index = BankrollLib

-- [ CONSTANTS ] --
local COLORS = {
    Background   = Color3.fromRGB(18, 16, 18),
    Panel        = Color3.fromRGB(24, 22, 24),
    Section      = Color3.fromRGB(20, 18, 20),
    Header       = Color3.fromRGB(14, 12, 14),
    Accent       = Color3.fromRGB(210, 60, 100),
    AccentDim    = Color3.fromRGB(140, 30, 60),
    AccentPink   = Color3.fromRGB(220, 100, 140),
    Text         = Color3.fromRGB(200, 195, 200),
    TextDim      = Color3.fromRGB(120, 115, 120),
    TextHeader   = Color3.fromRGB(160, 155, 160),
    Toggle_On    = Color3.fromRGB(210, 60, 100),
    Toggle_Off   = Color3.fromRGB(50, 46, 50),
    Slider_Fill  = Color3.fromRGB(210, 60, 100),
    Slider_BG    = Color3.fromRGB(40, 36, 40),
    Dropdown_BG  = Color3.fromRGB(28, 26, 28),
    Separator    = Color3.fromRGB(35, 32, 35),
    TabActive    = Color3.fromRGB(210, 60, 100),
    TabInactive  = Color3.fromRGB(30, 28, 30),
    TabText      = Color3.fromRGB(160, 155, 160),
    TabTextActive= Color3.fromRGB(240, 235, 240),
}

local FONT        = Enum.Font.Code
local FONT_BOLD   = Enum.Font.Code
local TEXT_SIZE   = 11
local ELEM_HEIGHT = 18
local PADDING     = 6
local TOGGLE_SIZE = 10

-- [ SERVICES ] --
local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- [ UTILITY ] --
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad), props):Play()
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- [ LIBRARY ] --

function BankrollLib:CreateWindow(config)
    config = config or {}
    local title = config.Title or "bankroll"
    local size  = config.Size  or UDim2.new(0, 500, 0, 340)

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name            = "BankrollLib",
        ResetOnSpawn    = false,
        ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
        Parent          = PlayerGui,
    })

    -- Main Frame
    local MainFrame = Create("Frame", {
        Name            = "MainFrame",
        Size            = size,
        Position        = UDim2.new(0.5, -250, 0.5, -170),
        BackgroundColor3= COLORS.Background,
        BorderSizePixel = 0,
        ClipsDescendants= true,
        Parent          = ScreenGui,
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = MainFrame})
    Create("UIStroke", {Color = COLORS.Separator, Thickness = 1, Parent = MainFrame})

    -- Title Bar
    local TitleBar = Create("Frame", {
        Name            = "TitleBar",
        Size            = UDim2.new(1, 0, 0, 22),
        BackgroundColor3= COLORS.Header,
        BorderSizePixel = 0,
        Parent          = MainFrame,
    })
    Create("TextLabel", {
        Text            = title,
        Font            = FONT_BOLD,
        TextSize        = 11,
        TextColor3      = COLORS.TextDim,
        BackgroundTransparency = 1,
        Size            = UDim2.new(1, -10, 1, 0),
        Position        = UDim2.new(0, 8, 0, 0),
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = TitleBar,
    })

    -- Close button
    local CloseBtn = Create("TextButton", {
        Text            = "×",
        Font            = FONT_BOLD,
        TextSize        = 14,
        TextColor3      = COLORS.TextDim,
        BackgroundTransparency = 1,
        Size            = UDim2.new(0, 22, 1, 0),
        Position        = UDim2.new(1, -22, 0, 0),
        Parent          = TitleBar,
    })
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {TextColor3 = COLORS.Accent})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {TextColor3 = COLORS.TextDim})
    end)

    MakeDraggable(MainFrame, TitleBar)

    -- Tab Bar (bottom)
    local TabBar = Create("Frame", {
        Name            = "TabBar",
        Size            = UDim2.new(1, 0, 0, 22),
        Position        = UDim2.new(0, 0, 1, -22),
        BackgroundColor3= COLORS.Header,
        BorderSizePixel = 0,
        Parent          = MainFrame,
    })
    Create("UIListLayout", {
        FillDirection   = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment   = Enum.VerticalAlignment.Center,
        Padding         = UDim.new(0, 0),
        Parent          = TabBar,
    })

    -- Content area (between title bar and tab bar)
    local ContentArea = Create("Frame", {
        Name            = "ContentArea",
        Size            = UDim2.new(1, 0, 1, -44),
        Position        = UDim2.new(0, 0, 0, 22),
        BackgroundTransparency = 1,
        Parent          = MainFrame,
    })

    -- Window object
    local Window = {
        ScreenGui   = ScreenGui,
        MainFrame   = MainFrame,
        TabBar      = TabBar,
        ContentArea = ContentArea,
        Tabs        = {},
        ActiveTab   = nil,
    }

    function Window:CreateTab(name)
        local tab = {
            Name     = name,
            Button   = nil,
            Frame    = nil,
            Sections = {},
        }

        -- Tab button
        local btn = Create("TextButton", {
            Text            = name,
            Font            = FONT,
            TextSize        = 10,
            TextColor3      = COLORS.TabText,
            BackgroundColor3= COLORS.TabInactive,
            BorderSizePixel = 0,
            Size            = UDim2.new(0, 60, 1, 0),
            Parent          = TabBar,
        })

        -- Tab frame (full content area)
        local frame = Create("Frame", {
            Name            = name,
            Size            = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible         = false,
            Parent          = ContentArea,
        })

        -- Two columns
        local LeftCol = Create("Frame", {
            Name            = "LeftCol",
            Size            = UDim2.new(0.5, -1, 1, 0),
            Position        = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Parent          = frame,
        })
        Create("UIListLayout", {
            FillDirection   = Enum.FillDirection.Vertical,
            Padding         = UDim.new(0, 1),
            Parent          = LeftCol,
        })

        local RightCol = Create("Frame", {
            Name            = "RightCol",
            Size            = UDim2.new(0.5, -1, 1, 0),
            Position        = UDim2.new(0.5, 1, 0, 0),
            BackgroundTransparency = 1,
            Parent          = frame,
        })
        Create("UIListLayout", {
            FillDirection   = Enum.FillDirection.Vertical,
            Padding         = UDim.new(0, 1),
            Parent          = RightCol,
        })

        -- Divider line
        Create("Frame", {
            Size            = UDim2.new(0, 1, 1, 0),
            Position        = UDim2.new(0.5, -1, 0, 0),
            BackgroundColor3= COLORS.Separator,
            BorderSizePixel = 0,
            Parent          = frame,
        })

        tab.Button   = btn
        tab.Frame    = frame
        tab.LeftCol  = LeftCol
        tab.RightCol = RightCol
        tab._colIndex = 0 -- 0=left, 1=right

        btn.MouseButton1Click:Connect(function()
            Window:_SelectTab(tab)
        end)

        table.insert(self.Tabs, tab)
        if #self.Tabs == 1 then
            Window:_SelectTab(tab)
        end

        -- Section creator
        function tab:CreateSection(sectionName, side)
            -- side: "left" or "right", defaults to alternating
            local col
            if side == "right" then
                col = RightCol
            elseif side == "left" then
                col = LeftCol
            else
                -- auto alternate
                self._colIndex = self._colIndex + 1
                col = (self._colIndex % 2 == 1) and LeftCol or RightCol
            end

            local section = {
                Elements = {},
            }

            -- Section header
            local Header = Create("Frame", {
                Size            = UDim2.new(1, 0, 0, 18),
                BackgroundColor3= COLORS.Header,
                BorderSizePixel = 0,
                Parent          = col,
            })
            Create("TextLabel", {
                Text            = sectionName,
                Font            = FONT,
                TextSize        = 10,
                TextColor3      = COLORS.TextDim,
                BackgroundTransparency = 1,
                Size            = UDim2.new(1, -8, 1, 0),
                Position        = UDim2.new(0, 8, 0, 0),
                TextXAlignment  = Enum.TextXAlignment.Left,
                Parent          = Header,
            })

            -- Section body
            local Body = Create("Frame", {
                Size            = UDim2.new(1, 0, 0, 0),
                AutomaticSize   = Enum.AutomaticSize.Y,
                BackgroundColor3= COLORS.Section,
                BorderSizePixel = 0,
                Parent          = col,
            })
            Create("UIPadding", {
                PaddingLeft   = UDim.new(0, 8),
                PaddingRight  = UDim.new(0, 8),
                PaddingTop    = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
                Parent        = Body,
            })
            Create("UIListLayout", {
                FillDirection   = Enum.FillDirection.Vertical,
                Padding         = UDim.new(0, 2),
                Parent          = Body,
            })

            -- [ TOGGLE ] --
            function section:AddToggle(label, config)
                config = config or {}
                local val = config.Default or false
                local cb  = config.Callback or function() end

                local Row = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, ELEM_HEIGHT),
                    BackgroundTransparency = 1,
                    Parent          = Body,
                })

                Create("TextLabel", {
                    Text            = label,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.Text,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, -(TOGGLE_SIZE + 6), 1, 0),
                    Position        = UDim2.new(0, 0, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = Row,
                })

                local ToggleBG = Create("Frame", {
                    Size            = UDim2.new(0, TOGGLE_SIZE, 0, TOGGLE_SIZE),
                    Position        = UDim2.new(1, -(TOGGLE_SIZE), 0.5, -TOGGLE_SIZE/2),
                    BackgroundColor3= val and COLORS.Toggle_On or COLORS.Toggle_Off,
                    BorderSizePixel = 0,
                    Parent          = Row,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = ToggleBG})

                local toggle = {Value = val}

                local function UpdateVisual()
                    Tween(ToggleBG, {BackgroundColor3 = toggle.Value and COLORS.Toggle_On or COLORS.Toggle_Off}, 0.1)
                end

                local Btn = Create("TextButton", {
                    Text            = "",
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, 0, 1, 0),
                    Parent          = Row,
                })
                Btn.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    UpdateVisual()
                    cb(toggle.Value)
                end)

                function toggle:Set(v)
                    self.Value = v
                    UpdateVisual()
                    cb(v)
                end

                return toggle
            end

            -- [ SLIDER ] --
            function section:AddSlider(label, config)
                config = config or {}
                local min = config.Min or 0
                local max = config.Max or 100
                local val = config.Default or min
                local cb  = config.Callback or function() end

                local Container = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, ELEM_HEIGHT + 10),
                    BackgroundTransparency = 1,
                    Parent          = Body,
                })

                Create("TextLabel", {
                    Text            = label,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.Text,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, -30, 0, 14),
                    Position        = UDim2.new(0, 0, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = Container,
                })

                local ValLabel = Create("TextLabel", {
                    Text            = tostring(val),
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.AccentPink,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(0, 28, 0, 14),
                    Position        = UDim2.new(1, -28, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = Container,
                })

                local SliderBG = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 4),
                    Position        = UDim2.new(0, 0, 0, 16),
                    BackgroundColor3= COLORS.Slider_BG,
                    BorderSizePixel = 0,
                    Parent          = Container,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = SliderBG})

                local Fill = Create("Frame", {
                    Size            = UDim2.new((val - min) / (max - min), 0, 1, 0),
                    BackgroundColor3= COLORS.Slider_Fill,
                    BorderSizePixel = 0,
                    Parent          = SliderBG,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = Fill})

                local slider = {Value = val}
                local sliding = false

                local function UpdateSlider(input)
                    local relX = math.clamp(
                        (input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X,
                        0, 1
                    )
                    local newVal = math.floor(min + (max - min) * relX)
                    slider.Value = newVal
                    Fill.Size = UDim2.new(relX, 0, 1, 0)
                    ValLabel.Text = tostring(newVal)
                    cb(newVal)
                end

                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        UpdateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)

                function slider:Set(v)
                    v = math.clamp(v, min, max)
                    self.Value = v
                    local pct = (v - min) / (max - min)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValLabel.Text = tostring(v)
                    cb(v)
                end

                return slider
            end

            -- [ DROPDOWN ] --
            function section:AddDropdown(label, config)
                config = config or {}
                local options = config.Options or {}
                local val     = config.Default or (options[1] or "")
                local cb      = config.Callback or function() end

                local Container = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, ELEM_HEIGHT),
                    BackgroundTransparency = 1,
                    ClipsDescendants= false,
                    Parent          = Body,
                })

                Create("TextLabel", {
                    Text            = label,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.TextDim,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, 0, 0, 14),
                    Position        = UDim2.new(0, 0, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = Container,
                })

                -- Arrow indicator
                local Arrow = Create("TextLabel", {
                    Text            = "▾",
                    Font            = FONT,
                    TextSize        = 10,
                    TextColor3      = COLORS.AccentPink,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(0, 12, 0, 14),
                    Position        = UDim2.new(1, -12, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = Container,
                })

                local SelectedLabel = Create("TextLabel", {
                    Text            = val,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.AccentPink,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, -16, 0, 14),
                    Position        = UDim2.new(0, 0, 0, 0),
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = Container,
                })

                -- Dropdown list (rendered above/below)
                local DropList = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, #options * 16 + 4),
                    Position        = UDim2.new(0, 0, 1, 2),
                    BackgroundColor3= COLORS.Dropdown_BG,
                    BorderSizePixel = 0,
                    Visible         = false,
                    ZIndex          = 10,
                    Parent          = Container,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = DropList})
                Create("UIStroke", {Color = COLORS.Separator, Thickness = 1, Parent = DropList})
                Create("UIListLayout", {
                    FillDirection   = Enum.FillDirection.Vertical,
                    Padding         = UDim.new(0, 0),
                    Parent          = DropList,
                })
                Create("UIPadding", {
                    PaddingTop    = UDim.new(0, 2),
                    PaddingBottom = UDim.new(0, 2),
                    PaddingLeft   = UDim.new(0, 6),
                    PaddingRight  = UDim.new(0, 6),
                    Parent        = DropList,
                })

                local dropdown = {Value = val, Open = false}

                for _, opt in ipairs(options) do
                    local OptBtn = Create("TextButton", {
                        Text            = opt,
                        Font            = FONT,
                        TextSize        = TEXT_SIZE,
                        TextColor3      = opt == val and COLORS.AccentPink or COLORS.Text,
                        BackgroundTransparency = 1,
                        Size            = UDim2.new(1, 0, 0, 16),
                        TextXAlignment  = Enum.TextXAlignment.Left,
                        ZIndex          = 11,
                        Parent          = DropList,
                    })
                    OptBtn.MouseEnter:Connect(function()
                        if opt ~= dropdown.Value then
                            Tween(OptBtn, {TextColor3 = COLORS.TextHeader})
                        end
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        if opt ~= dropdown.Value then
                            Tween(OptBtn, {TextColor3 = COLORS.Text})
                        end
                    end)
                    OptBtn.MouseButton1Click:Connect(function()
                        dropdown.Value = opt
                        SelectedLabel.Text = opt
                        -- reset all colors
                        for _, child in ipairs(DropList:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = COLORS.Text
                            end
                        end
                        OptBtn.TextColor3 = COLORS.AccentPink
                        DropList.Visible = false
                        dropdown.Open = false
                        cb(opt)
                    end)
                end

                local ToggleBtn = Create("TextButton", {
                    Text            = "",
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, 0, 1, 0),
                    ZIndex          = 5,
                    Parent          = Container,
                })
                ToggleBtn.MouseButton1Click:Connect(function()
                    dropdown.Open = not dropdown.Open
                    DropList.Visible = dropdown.Open
                    Arrow.Text = dropdown.Open and "▴" or "▾"
                end)

                function dropdown:Set(v)
                    self.Value = v
                    SelectedLabel.Text = v
                    cb(v)
                end

                return dropdown
            end

            -- [ BUTTON ] --
            function section:AddButton(label, config)
                config = config or {}
                local cb = config.Callback or function() end

                local Btn = Create("TextButton", {
                    Text            = label,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.Text,
                    BackgroundColor3= COLORS.Toggle_Off,
                    BorderSizePixel = 0,
                    Size            = UDim2.new(1, 0, 0, ELEM_HEIGHT),
                    AutoButtonColor = false,
                    Parent          = Body,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Btn})

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = COLORS.AccentDim, TextColor3 = COLORS.TabTextActive})
                end)
                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = COLORS.Toggle_Off, TextColor3 = COLORS.Text})
                end)
                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, {BackgroundColor3 = COLORS.Accent})
                    task.delay(0.15, function()
                        Tween(Btn, {BackgroundColor3 = COLORS.AccentDim})
                    end)
                    cb()
                end)

                return Btn
            end

            -- [ LABEL ] --
            function section:AddLabel(text)
                Create("TextLabel", {
                    Text            = text,
                    Font            = FONT,
                    TextSize        = TEXT_SIZE,
                    TextColor3      = COLORS.TextDim,
                    BackgroundTransparency = 1,
                    Size            = UDim2.new(1, 0, 0, ELEM_HEIGHT),
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = Body,
                })
            end

            -- [ SEPARATOR ] --
            function section:AddSeparator()
                Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3= COLORS.Separator,
                    BorderSizePixel = 0,
                    Parent          = Body,
                })
            end

            return section
        end

        return tab
    end

    function Window:_SelectTab(tab)
        -- Hide all
        for _, t in ipairs(self.Tabs) do
            t.Frame.Visible = false
            Tween(t.Button, {
                BackgroundColor3 = COLORS.TabInactive,
                TextColor3       = COLORS.TabText,
            })
        end
        -- Show selected
        tab.Frame.Visible = true
        Tween(tab.Button, {
            BackgroundColor3 = COLORS.TabActive,
            TextColor3       = COLORS.TabTextActive,
        })
        self.ActiveTab = tab
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

return BankrollLib
