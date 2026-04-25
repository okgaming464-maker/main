local Helpers = {}

function Helpers.createToggle(parent, label, default, callback, colors)
    local frame = Instance.new('Frame')
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = colors.Button
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local lbl = Instance.new('TextLabel')
    lbl.Text = label
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = colors.ButtonText
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggleBg = Instance.new('Frame')
    toggleBg.Size = UDim2.new(0, 50, 0, 25)
    toggleBg.Position = UDim2.new(1, -60, 0, 7.5)
    toggleBg.BackgroundColor3 = default and colors.ToggleOn or colors.ToggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame

    local toggleCorner = Instance.new('UICorner')
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBg

    local toggleCircle = Instance.new('Frame')
    toggleCircle.Size = UDim2.new(0, 22, 0, 22)
    toggleCircle.Position = default and UDim2.new(1, -22, 0, 0) or UDim2.new(0, 1, 0, 0)
    toggleCircle.BackgroundColor3 = colors.ToggleCircle
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg

    local circleCorner = Instance.new('UICorner')
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local nowOn = toggleBg.BackgroundColor3 == colors.ToggleOn
            toggleBg.BackgroundColor3 = nowOn and colors.ToggleOff or colors.ToggleOn
            toggleCircle.Position = nowOn and UDim2.new(0, 1, 0, 1) or UDim2.new(1, -22, 0, 1)
            callback(not nowOn)
        end
    end)

    return frame
end

function Helpers.createFrame(parent, size, color)
    local frame = Instance.new('Frame')
    frame.Size = size or UDim2.new(1, -20, 0, 0)
    frame.BackgroundColor3 = color or Color3.fromRGB(40, 40, 45)
    frame.BorderSizePixel = 0
    if parent then frame.Parent = parent end

    local corner = Instance.new('UICorner')
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    return frame
end

function Helpers.createSection(parent, title, colors)
    local section = Helpers.createFrame(parent, UDim2.new(1, -20, 0, 40), colors.ContentFrame)
    section.BackgroundTransparency = 1

    local lbl = Instance.new('TextLabel')
    lbl.Text = title
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.TextColor3 = colors.TitleText
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -20, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section

    return section
end

function Helpers.decodeJSON(jsonStr)
    local ok, result = pcall(game.GetService(game, 'HttpService').JSONDecode, game.GetService(game, 'HttpService'), jsonStr)
    return ok and result or nil
end

function Helpers.encodeJSON(table)
    return game.GetService(game, 'HttpService'):JSONEncode(table)
end

function Helpers.getConfig()
    return {
        hitPart = 'HitboxHead',
        triggerKey = Enum.KeyCode.P,
    }
end

return Helpers