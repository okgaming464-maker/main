local ReachModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function ReachModule.new(config)
    local self = {}
    local enabled = false
    local reachValue = 2
    local reachEnabled = false
    local hitboxExtend = false
    local hitboxSize = Vector3.new(2, 2, 2)
    
    local function applyReach()
        if not enabled then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local currentSize = hrp.Size
        
        if reachEnabled then
            if hitboxExtend then
                hrp.Size = hitboxSize
                hrp.CustomIdleAnimation = Enum.HumanoidRootPartOperationTheme.I
            else
                hrp.Size = Vector3.new(reachValue, reachValue, reachValue)
            end
        else
            hrp.Size = Vector3.new(2, 2, 2)
        end
        
        local scale = hitboxSize.X / currentSize.X
        hrp.Size = hrp.Size * scale
    end
    
    local function resetReach()
        local char = LocalPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Size = Vector3.new(2, 2, 2)
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool then
            applyReach()
        else
            resetReach()
        end
    end
    
    function self:setReach(value)
        reachValue = value
        if enabled and reachEnabled then
            applyReach()
        end
    end
    
    function self:setReachEnabled(bool)
        reachEnabled = bool
        if enabled then
            applyReach()
        end
    end
    
    function self:setHitboxExtend(bool)
        hitboxExtend = bool
        if enabled then
            applyReach()
        end
    end
    
    function self:setHitboxSize(size)
        hitboxSize = size
        if enabled and hitboxExtend then
            applyReach()
        end
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                applyReach()
            end
        end)
        
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            if enabled then
                applyReach()
            end
        end)
    end
    
    return self
end

return ReachModule