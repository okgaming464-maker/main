local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local InputService = game:GetService("UserInputService")

local EspModule = {}
local cache = {}
local enabled = false

local settings = {
    boxEnabled = true,
    chamEnabled = true,
    nameEnabled = true,
    healthEnabled = true,
    distanceEnabled = true,
    tracerEnabled = false,
    skullEnabled = false,
    healthBarPosition = "left",
}

local function makeText()
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0, 100, 0, 20)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.TextStrokeTransparency = 0
    txt.TextStrokeColor3 = Color3.new(0, 0, 0)
    txt.Font = Enum.Font.Code
    txt.TextSize = 14
    return txt
end

local function createPlayerElements(player)
    if player == LocalPlayer then return end
    
    local elements = {}
    
    elements.boxOutline = Drawing.new("Square")
    elements.boxOutline.Thickness = 3
    elements.boxOutline.Filled = false
    elements.boxOutline.Color = Color3.new(0, 0, 0)
    
    elements.boxFill = Drawing.new("Square")
    elements.boxFill.Thickness = 1
    elements.boxFill.Filled = false
    elements.boxFill.Color = Color3.new(0, 1, 0)
    
    elements.chamHighlight = Instance.new("Highlight")
    elements.chamHighlight.Name = "Cham"
    elements.chamHighlight.FillColor = Color3.new(0, 1, 0)
    elements.chamHighlight.FillTransparency = 0.5
    elements.chamHighlight.OutlineColor = Color3.new(0, 0.5, 0)
    elements.chamHighlight.OutlineTransparency = 0
    elements.chamHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    elements.tracerLine = Drawing.new("Line")
    elements.tracerLine.Thickness = 1
    elements.tracerLine.Color = Color3.new(0, 1, 0)
    elements.tracerLine.Visible = false
    
    elements.skullText = makeText()
    elements.skullText.Text = "💀"
    elements.skullText.TextSize = 16
    elements.skullText.Visible = false
    
    elements.name = makeText()
    elements.name.Parent = game.CoreGui
    
    elements.distance = makeText()
    elements.distance.Parent = game.CoreGui
    
    local healthGui = Instance.new("ScreenGui")
    healthGui.Name = player.Name .. "_Health"
    healthGui.Parent = game.CoreGui
    
    local healthOutline = Instance.new("Frame")
    healthOutline.Size = UDim2.new(0, 6, 0, 50)
    healthOutline.BackgroundColor3 = Color3.new(0, 0, 0)
    healthOutline.BorderSizePixel = 0
    healthOutline.Parent = healthGui
    
    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.new(0, 1, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthOutline
    healthFill.AutomaticSize = Enum.AutomaticSize.Y
    
    elements.healthGui = healthGui
    elements.healthOutline = healthOutline
    elements.healthFill = healthFill
    
    cache[player] = elements
end

local function clearPlayerElements(player)
    if cache[player] then
        local e = cache[player]
        if e.boxOutline then e.boxOutline:Remove() end
        if e.boxFill then e.boxFill:Remove() end
        if e.tracerLine then e.tracerLine:Remove() end
        if e.skullText then e.skullText:Destroy() end
        if e.chamHighlight and e.chamHighlight.Parent then e.chamHighlight:Destroy() end
        if e.name and e.name.Parent then e.name:Destroy() end
        if e.distance and e.distance.Parent then e.distance:Destroy() end
        if e.healthGui then e.healthGui:Destroy() end
        cache[player] = nil
    end
end

local function update()
    if not enabled then return end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        
        if not hrp or not humanoid then
            clearPlayerElements(player)
            continue
        end
        
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen or pos.Z < 0 then
            clearPlayerElements(player)
            continue
        end
        
        local head = char:FindFirstChild("Head")
        local headPos = head and Camera:WorldToViewportPoint(head.Position) or pos
        local feetPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        
        local height = math.abs(headPos.Y - feetPos.Y)
        local width = height * 0.6
        local centerPos = Vector2.new(pos.X, headPos.Y + height/2)
        
        if not cache[player] then
            createPlayerElements(player)
        end
        
        local e = cache[player]
        
        -- Box ESP
        if settings.boxEnabled then
            e.boxOutline.Visible = true
            e.boxOutline.Position = centerPos - Vector2.new(width/2 + 2, height/2 + 2)
            e.boxOutline.Size = Vector2.new(width + 4, height + 4)
            
            e.boxFill.Visible = true
            e.boxFill.Position = centerPos - Vector2.new(width/2, height/2)
            e.boxFill.Size = Vector2.new(width, height)
        else
            e.boxOutline.Visible = false
            e.boxFill.Visible = false
        end
        
        -- Chams
        if settings.chamEnabled then
            if not e.chamHighlight.Parent then
                e.chamHighlight.Parent = char
            end
            e.chamHighlight.Enabled = true
        else
            e.chamHighlight.Enabled = false
        end
        
        -- Tracers
        if settings.tracerEnabled then
            e.tracerLine.Visible = true
            e.tracerLine.From = Vector2.new(screenCenter.X, screenCenter.Y)
            e.tracerLine.To = Vector2.new(centerPos.X, centerPos.Y + height/2)
        else
            e.tracerLine.Visible = false
        end
        
        -- Skull ESP
        if settings.skullEnabled then
            e.skullText.Visible = true
            e.skullText.Position = UDim2.new(0, centerPos.X - 10, 0, headPos.Y - 25)
        else
            e.skullText.Visible = false
        end
        
        -- Name
        if settings.nameEnabled then
            e.name.Visible = true
            e.name.Text = player.Name
            e.name.Position = UDim2.new(0, centerPos.X - 50, 0, headPos.Y - 20)
        else
            e.name.Visible = false
        end
        
        -- Distance
        if settings.distanceEnabled then
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude * 0.28)
            e.distance.Visible = true
            e.distance.Text = "[" .. dist .. "m]"
            e.distance.Position = UDim2.new(0, centerPos.X - 30, 0, headPos.Y + height + 5)
        else
            e.distance.Visible = false
        end
        
        -- Health Bar
        if settings.healthEnabled then
            local healthPct = humanoid.Health / humanoid.MaxHealth
            e.healthOutline.Visible = true
            local hpX = settings.healthBarPosition == "left" and centerPos.X - width/2 - 10 or centerPos.X + width/2 + 4
            e.healthOutline.Position = UDim2.new(0, hpX, 0, headPos.Y)
            
            e.healthFill.Visible = true
            e.healthFill.Size = UDim2.new(1, 0, healthPct, 0)
            e.healthFill.BackgroundColor3 = Color3.new(1 - healthPct, healthPct, 0)
        else
            e.healthOutline.Visible = false
            e.healthFill.Visible = false
        end
    end
end

function EspModule.new(config)
    local self = {}
    if config then
        for k, v in pairs(config) do
            settings[k] = v
        end
    end
    
    function self:setEnabled(bool)
        enabled = bool
        if not bool then
            for player, _ in pairs(cache) do
                clearPlayerElements(player)
            end
        end
    end
    
    function self:setBox(bool)
        settings.boxEnabled = bool
    end
    
    function self:setCham(bool)
        settings.chamEnabled = bool
    end
    
    function self:setName(bool)
        settings.nameEnabled = bool
    end
    
    function self:setHealth(bool)
        settings.healthEnabled = bool
    end
    
    function self:setDistance(bool)
        settings.distanceEnabled = bool
    end
    
    function self:setTracer(bool)
        settings.tracerEnabled = bool
    end
    
    function self:setSkull(bool)
        settings.skullEnabled = bool
    end
    
    function self:setHealthPosition(pos)
        settings.healthBarPosition = pos
    end
    
    function self:run()
        RunService.Heartbeat:Connect(update)
        
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if enabled then createPlayerElements(player) end
            end)
        end)
        
        Players.PlayerRemoving:Connect(clearPlayerElements)
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if enabled then createPlayerElements(player) end
                end)
            end
        end
    end
    
    return self
end

return EspModule