local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AimModule = {}

function AimModule.new(config)
    local self = {}
    local enabled = false
    local trigger = false
    local fov = config.FOVSize or 100
    local hitPart = config.HitPart or "HitboxHead"
    local hitParts = config.HitParts or {"Head", "HitboxHead", "HitboxBody", "HumanoidRootPart"}
    local smooth = 0
    local prediction = 0
    local wallCheck = true
    local center = Vector2.new(0, 0)
    local currentTarget = nil
    local isLocked = false
    
    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Thickness = 2
    fovCircle.NumSides = 64
    fovCircle.Radius = fov
    fovCircle.Color = Color3.new(1, 1, 1)
    fovCircle.Filled = false
    
    local lockDot = Drawing.new("Circle")
    lockDot.Visible = false
    lockDot.Radius = 5
    lockDot.Color = Color3.new(1, 0, 0)
    lockDot.Filled = true
    lockDot.Thickness = 1
    
    local function raycastToTarget(targetPart)
        local origin = Camera.CFrame.Position
        local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
        
        local result = workspace:FindPartOnRayWithIgnoreList(
            Ray.new(origin, direction),
            {LocalPlayer.Character, Camera}
        )
        
        return result and result:IsDescendantOf(targetPart.Parent)
    end
    
    local function findBestTarget()
        center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        fovCircle.Position = center
        
        local closest = fov
        local bestTarget = nil
        local bestPart = nil
        local bestVisible = false
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer or player.Team == LocalPlayer.Team then continue end
            if not player.Character then continue end
            
            local char = player.Character
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health <= 0 then continue end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("TeammateLabel") then continue end
            
            for _, partName in ipairs(hitParts) do
                local part = char:FindFirstChild(partName)
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and pos.Z > 0 then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        
                        local visible = true
                        if wallCheck then
                            visible = raycastToTarget(part)
                        end
                        
                        if visible and dist < closest then
                            closest = dist
                            bestTarget = player
                            bestPart = part
                            bestVisible = visible
                        end
                    end
                end
            end
        end
        
        return bestTarget, bestPart, bestVisible
    end
    
    local function predictPosition(part, velocity)
        if not part or not prediction or prediction == 0 then
            return part and part.WorldPosition or Vector3.zero
        end
        
        local predictedPos = part.WorldPosition
        if velocity and velocity.Magnitude > 0 then
            predictedPos = predictedPos + (velocity * prediction)
        end
        return predictedPos
    end
    
    local function aimAt(targetPart)
        if not targetPart then return end
        
        local worldPos = predictPosition(targetPart, Vector3.zero)
        local aimPos = Camera:WorldToViewportPoint(worldPos)
        
        if aimPos.Z > 0 then
            local mousePos = Vector2.new(aimPos.X, aimPos.Y)
            
            if smooth > 0 then
                local current = LocalPlayer:GetMouse().Position
                local newX = current.X + (mousePos.X - current.X) / smooth
                local newY = current.Y + (mousePos.Y - current.Y) / smooth
                VirtualInput:SendMouseMoveEvent(newX, newY)
            else
                VirtualInput:SendMouseMoveEvent(mousePos.X, mousePos.Y)
            end
            
            lockDot.Position = mousePos
            lockDot.Visible = true
        end
    end
    
    local function setFOV(size)
        fov = size
        fovCircle.Radius = size
    end
    
    function self:setEnable(bool)
        enabled = bool
        fovCircle.Visible = bool
        if not bool then
            isLocked = false
            currentTarget = nil
            lockDot.Visible = false
        end
    end
    
    function self:setTrigger(bool)
        trigger = bool
    end
    
    function self:setFOV(size)
        fov = size
        fovCircle.Radius = size
    end
    
    function self:setSmooth(val)
        smooth = val
    end
    
    function self:setPrediction(val)
        prediction = val
    end
    
    function self:setHitPart(part)
        hitPart = part
    end
    
    function self:setWallCheck(enabled)
        wallCheck = enabled
    end
    
    function self:getTarget()
        return currentTarget
    end
    
    function self:getFOV()
        return fov
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            
            local target, targetPart, visible = findBestTarget()
            
            if target and targetPart then
                isLocked = true
                currentTarget = target
                
                if trigger then
                    VirtualInput:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 0)
                    task.wait(0.03)
                    VirtualInput:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 0)
                end
                
                aimAt(targetPart)
            else
                isLocked = false
                currentTarget = nil
                lockDot.Visible = false
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            fovCircle.Position = center
        end)
    end
    
    return self
end

return AimModule