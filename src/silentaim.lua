local SilentAimModule = {}
local _Players = game:GetService('Players')
local _LocalPlayer = _Players.LocalPlayer
local _RunService = game:GetService('RunService')
local _VirtualInputManager = game:GetService('VirtualInputManager')

function SilentAimModule.new(config)
    local self = {}
    self.Settings = {
        Enable = false,
        FOVSize = config.FOVSize or 150,
        HitPart = 'HitboxHead',
    }
    self.LockColor = Color3.fromRGB(255, 0, 0)
    self.FovColor = Color3.fromRGB(255, 255, 255)
    self.OriginalCFrame = nil
    self.LookAtTarget = false
    self.TargetPlayer = nil
    
    local fovCircle = Drawing.new('Circle')
    fovCircle.Thickness = 2
    fovCircle.NumSides = 64
    fovCircle.Radius = self.Settings.FOVSize
    fovCircle.Color = self.FovColor
    fovCircle.Filled = false
    fovCircle.Visible = false
    
    local lockIndicator = Drawing.new('Circle')
    lockIndicator.Thickness = 3
    lockIndicator.Radius = 8
    lockIndicator.Color = self.LockColor
    lockIndicator.Filled = true
    lockIndicator.Visible = false

    local function findTarget()
        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        local closest = self.Settings.FOVSize
        local target = nil
        
        for _, plr in ipairs(_Players:GetPlayers()) do
            if plr ~= _LocalPlayer and plr.Character then
                local part = plr.Character:FindFirstChild(self.Settings.HitPart)
                if not part then
                    part = plr.Character:FindFirstChild('Head') or plr.Character:FindFirstChild('HitboxBody')
                end
                if part then
                    local pos = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                    if pos.Z > 0 then
                        local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if dist < closest then
                            closest = dist
                            target = plr
                        end
                    end
                end
            end
        end
        return target
    end
    
    local function updateDrawing()
        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        fovCircle.Position = center
        fovCircle.Radius = self.Settings.FOVSize
        
        if self.TargetPlayer and self.TargetPlayer.Character then
            local part = self.TargetPlayer.Character:FindFirstChild(self.Settings.HitPart)
            if not part then
                part = self.TargetPlayer.Character:FindFirstChild('Head')
            end
            if part then
                local pos = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if pos.Z > 0 then
                    lockIndicator.Position = Vector2.new(pos.X, pos.Y)
                    lockIndicator.Visible = true
                else
                    lockIndicator.Visible = false
                end
            end
        else
            lockIndicator.Visible = false
        end
    end

    function self:run()
        _RunService.Heartbeat:Connect(function()
            updateDrawing()
            if not self.Settings.Enable then
                self.TargetPlayer = nil
                self.LookAtTarget = false
                return
            end
            
            local target = findTarget()
            if target and target.Character then
                self.TargetPlayer = target
                self.LookAtTarget = true
            else
                self.TargetPlayer = nil
                self.LookAtTarget = false
            end
        end)
    end

    function self:setEnable(enabled)
        self.Settings.Enable = enabled
        fovCircle.Visible = enabled
        if not enabled then
            lockIndicator.Visible = false
            self.TargetPlayer = nil
        end
    end

    function self:setFOV(size)
        self.Settings.FOVSize = size
        fovCircle.Radius = size
    end

    function self:setHitPart(part)
        self.Settings.HitPart = part
    end
    
    function self:getTarget()
        return self.TargetPlayer
    end

    return self
end

return SilentAimModule