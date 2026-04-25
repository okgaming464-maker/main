local TeleportModule = {}
local _Players = game:GetService('Players')
local _LocalPlayer = _Players.LocalPlayer
local _RunService = game:GetService('RunService')
local _VirtualInputManager = game:GetService('VirtualInputManager')

function TeleportModule.new()
    local self = {}
    self.Enabled = false
    self.Target = nil
    self.BehindOffset = Vector3.new(0, 0, -5)

    function self:setEnabled(enabled)
        self.Enabled = enabled
    end

    function self:teleportToEnemy()
        for _, plr in ipairs(_Players:GetPlayers()) do
            if plr ~= _LocalPlayer and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') then
                if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                    _LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 0)
                end
                break
            end
        end
    end

    function self:teleportBehind(targetPart)
        if not targetPart then return end
        local char = _LocalPlayer.Character
        if char and char:FindFirstChild('HumanoidRootPart') then
            char.HumanoidRootPart.CFrame = targetPart.CFrame + (targetPart.CFrame.LookVector * -5)
        end
    end

    function self:run()
        _RunService.Heartbeat:Connect(function()
            if self.Enabled and self.Target then
                local target = self.Target
                local char = _LocalPlayer.Character
                if target and target:FindFirstChild('HumanoidRootPart') and char and char:FindFirstChild('HumanoidRootPart') then
                    self:teleportBehind(target.HumanoidRootPart)
                end
            end
        end)
    end

    function self:setTarget(player)
        self.Target = player
    end

    return self
end

return TeleportModule