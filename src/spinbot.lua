local SpinModule = {}
local _RunService = game:GetService('RunService')
local _LocalPlayer = game.Players.LocalPlayer

function SpinModule.new()
    local self = {}
    self.Enabled = false
    self.Speed = 25
    self.Connection = nil
    self.Character = nil

    function self:start()
        self.Character = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()
        local hrp = self.Character:FindFirstChild('HumanoidRootPart')
        if not hrp then return end

        self.Connection = _RunService.Heartbeat:Connect(function()
            if self.Character and self.Character:FindFirstChild('HumanoidRootPart') then
                self.Character.HumanoidRootPart.CFrame = self.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(self.Speed), 0)
            end
        end)
    end

    function self:stop()
        if self.Connection then
            self.Connection:Disconnect()
            self.Connection = nil
        end
    end

    function self:enable(enabled)
        self.Enabled = enabled
        if enabled then
            self:start()
        else
            self:stop()
        end
    end

    function self:setSpeed(speed)
        self.Speed = speed
    end

    _LocalPlayer.CharacterAdded:Connect(function(char)
        self.Character = char
        if self.Enabled then
            task.wait(0.5)
            self:start()
        end
    end)

    return self
end

return SpinModule