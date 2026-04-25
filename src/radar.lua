local RadarModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

function RadarModule.new(config)
    local self = {}
    local enabled = false
    local size = 180
    local range = 100
    local zoom = 1.2
    local showEnemies = true
    local showTeam = true
    local showNames = true
    local showDistance = true
    local showHealth = false
    local position = "right"
    local bgOpacity = 0.7
    local enemyColor = Color3.new(1, 0.2, 0.2)
    local teamColor = Color3.new(0.2, 0.8, 0.2)
    local gridColor = Color3.new(1, 1, 1)
    
    local radarGui = nil
    local dots = {}
    
    local function createRadar()
        local gui = Instance.new("ScreenGui")
        gui.Name = "CustomRadar"
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 100
        gui.Parent = game.CoreGui
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0, size, 0, size)
        bg.BackgroundColor3 = Color3.new(0.05, 0.05, 0.1)
        bg.BackgroundTransparency = 1 - bgOpacity
        bg.BorderSizePixel = 0
        bg.Parent = gui
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(1, 0)
        bgCorner.Parent = bg
        
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 45
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.1, 0.2)),
            ColorSequenceKeypoint.new(1, Color3.new(0.05, 0.05, 0.1))
        }
        gradient.Parent = bg
        
        local ringOuter = Drawing.new("Circle")
        ringOuter.Radius = size/2 - 5
        ringOuter.NumSides = 64
        ringOuter.Thickness = 2
        ringOuter.Color = gridColor
        ringOuter.Visible = true
        
        local ringMid = Drawing.new("Circle")
        ringMid.Radius = size/3 - 5
        ringMid.NumSides = 48
        ringMid.Thickness = 1
        ringMid.Color = gridColor
        ringMid.Transparency = 0.5
        ringMid.Visible = true
        
        local ringInner = Drawing.new("Circle")
        ringInner.Radius = size/6 - 5
        ringInner.NumSides = 32
        ringInner.Thickness = 1
        ringInner.Color = gridColor
        ringInner.Transparency = 0.7
        ringInner.Visible = true
        
        local crossH = Drawing.new("Line")
        crossH.Start = Vector2.new(0, size/2 - 10)
        crossH.End = Vector2.new(0, -size/2 + 10)
        crossH.Thickness = 1
        crossH.Color = gridColor
        crossH.Transparency = 0.3
        crossH.Visible = true
        
        local crossV = Drawing.new("Line")
        crossV.Start = Vector2.new(size/2 - 10, 0)
        crossV.End = Vector2.new(-size/2 + 10, 0)
        crossV.Thickness = 1
        crossV.Color = gridColor
        crossV.Transparency = 0.3
        crossV.Visible = true
        
        local direction = Drawing.new("Line")
        direction.Start = Vector2.new(0, -size/2 + 15)
        direction.End = Vector2.new(0, -size/2 + 30)
        direction.Thickness = 2
        direction.Color = Color3.new(1, 1, 1)
        direction.Visible = true
        
        local centerDot = Drawing.new("Circle")
        centerDot.Radius = 4
        centerDot.Filled = true
        centerDot.Color = Color3.new(1, 1, 1)
        centerDot.Visible = true
        
        local arrow = Drawing.new("Triangle")
        arrow.Filled = true
        arrow.Color = Color3.new(1, 1, 1)
        arrow.Visible = true
        
        if position == "right" then
            bg.Position = UDim2.new(1, -size - 30, 0.5, -size/2)
        else
            bg.Position = UDim2.new(0, 30, 0.5, size/2)
        end
        
        radarGui = {
            gui = gui, bg = bg,
            ringOuter = ringOuter, ringMid = ringMid, ringInner = ringInner,
            crossH = crossH, crossV = crossV, direction = direction,
            centerDot = centerDot, arrow = arrow
        }
    end
    
    local function worldToRadar(worldPos)
        if not LocalPlayer.Character then return nil, 0 end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil, 0 end
        
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local relPos = worldPos - myPos
        
        local camLook = Camera.CFrame.LookVector
        local angle = math.atan2(camLook.X, camLook.Z)
        local cosA = math.cos(angle)
        local sinA = math.sin(angle)
        
        local rotX = relPos.X * cosA - relPos.Z * sinA
        local rotZ = relPos.X * sinA + relPos.Z * cosA
        
        local dist = math.sqrt(rotX^2 + rotZ^2)
        if dist > range then return nil, dist end
        
        local scale = (size / 2 - 20) / range
        local screenX = (size / 2) + rotX * scale * zoom
        local screenY = (size / 2) + rotZ * scale * zoom
        
        return Vector2.new(screenX, screenY), dist
    end
    
    local function update()
        if not enabled or not radarGui then return end
        
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X, 0)
        
        if position == "right" then
            center = Vector2.new(cam.ViewportSize.X - size - 30, cam.ViewportSize.Y / 2)
        else
            center = Vector2.new(30 + size, cam.ViewportSize.Y / 2)
        end
        
        local cy, cx = math.modf(size / 2)
        
        radarGui.ringOuter.Position = center
        radarGui.ringMid.Position = center
        radarGui.ringInner.Position = center
        radarGui.crossH.From = Vector2.new(center.X, center.Y - cx + 10)
        radarGui.crossH.To = Vector2.new(center.X, center.Y + cx - 10)
        radarGui.crossV.From = Vector2.new(center.X - cx + 10, center.Y)
        radarGui.crossV.To = Vector2.new(center.X + cx - 10, center.Y)
        radarGui.direction.From = Vector2.new(center.X, center.Y - cx + 15)
        radarGui.direction.To = Vector2.new(center.X, center.Y - cx + 25)
        radarGui.centerDot.Position = center
        
        radarGui.arrow.PointA = Vector2.new(center.X, center.Y - cx + 10)
        radarGui.arrow.PointB = Vector2.new(center.X - 5, center.Y - cx + 20)
        radarGui.arrow.PointC = Vector2.new(center.X + 5, center.Y - cx + 20)
        
        for player, dot in pairs(dots) do
            if dot then
                if dot.frame and dot.frame.Parent then dot.frame:Destroy() end
                if dot.label and dot.label.Parent then dot.label:Destroy() end
                if dot.health and dot.health.Parent then dot.health:Destroy() end
            end
            dots[player] = nil
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
            
            local isEnemy = player.Team ~= LocalPlayer.Team
            if not showEnemies and isEnemy then continue end
            if not showTeam and not isEnemy then continue end
            
            local pos, dist = worldToRadar(player.Character.HumanoidRootPart.Position)
            if not pos then continue end
            
            local dotColor = isEnemy and enemyColor or teamColor
            
            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, isEnemy and 8 or 6, 0, isEnemy and 8 or 6)
            dot.Position = UDim2.new(0, center.X + pos.X - (isEnemy and 4 or 3), 0, center.Y + pos.Y - (isEnemy and 4 or 3))
            dot.BackgroundColor3 = dotColor
            dot.BorderSizePixel = 0
            dot.Parent = radarGui.bg
            
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot
            
            local dotGlow = Instance.new("Frame")
            dotGlow.Size = UDim2.new(0, isEnemy and 14 or 10, 0, isEnemy and 14 or 10)
            dotGlow.Position = UDim2.new(0, -3, 0, -3)
            dotGlow.BackgroundColor3 = dotColor
            dotGlow.BackgroundTransparency = 0.7
            dotGlow.BorderSizePixel = 0
            dotGlow.ZIndex = -1
            dotGlow.Parent = dot
            
            local healthText = nil
            if showHealth then
                local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                healthText = humanoid and math.floor(humanoid.Health) or 100
            end
            
            local label = nil
            if showNames then
                label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 60, 0, 12)
                label.Position = UDim2.new(0, center.X + pos.X + 8, 0, center.Y + pos.Y - 6)
                label.BackgroundTransparency = 1
                label.Text = player.Name .. (showDistance and " [" .. math.floor(dist) .. "m]" or "")
                label.TextColor3 = dotColor
                label.TextSize = 10
                label.Font = Enum.Font.Code
                label.Parent = radarGui.bg
            end
            
            dots[player] = {frame = dot, label = label, health = healthText}
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool and not radarGui then
            createRadar()
        end
        if radarGui then
            radarGui.ringOuter.Visible = bool
            radarGui.ringMid.Visible = bool and showEnemies
            radarGui.ringInner.Visible = bool and showTeam
            radarGui.crossH.Visible = bool
            radarGui.crossV.Visible = bool
            radarGui.direction.Visible = bool
            radarGui.centerDot.Visible = bool
            radarGui.arrow.Visible = bool
            radarGui.bg.Visible = bool
        end
    end
    
    function self:setSize(s)
        size = s
        if radarGui then
            radarGui.bg.Size = UDim2.new(0, size, 0, size)
        end
    end
    
    function self:setRange(r)
        range = r
    end
    
    function self:setZoom(z)
        zoom = z
    end
    
    function self:setShowEnemies(bool)
        showEnemies = bool
    end
    
    function self:setShowTeam(bool)
        showTeam = bool
    end
    
    function self:setShowNames(bool)
        showNames = bool
    end
    
    function self:setShowDistance(bool)
        showDistance = bool
    end
    
    function self:setShowHealth(bool)
        showHealth = bool
    end
    
    function self:setEnemyColor(c)
        enemyColor = c
    end
    
    function self:setTeamColor(c)
        teamColor = c
    end
    
    function self:setGridColor(c)
        gridColor = c
    end
    
    function self:setOpacity(o)
        bgOpacity = o
        if radarGui then
            radarGui.bg.BackgroundTransparency = 1 - bgOpacity
        end
    end
    
    function self:setPosition(pos)
        position = pos
    end
    
    function self:run()
        RunService.Heartbeat:Connect(update)
    end
    
    return self
end

return RadarModule