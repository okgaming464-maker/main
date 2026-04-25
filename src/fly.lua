-- SIMPLE FLY (works)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local FlyModule = {}

function FlyModule.new()
    local enabled = false
    local speed = 50
    local gyro = nil
    local vel = nil
    local connection = nil
    local dirs = {F=0, B=0, L=0, R=0, Up=0}
    
    local function start()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        
        gyro = Instance.new("BodyGyro")
        gyro.P = 90000
        gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.Parent = hrp
        
        vel = Instance.new("BodyVelocity")
        vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        vel.Velocity = Vector3.new(0, 0, 0)
        vel.Parent = hrp
        
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = true
        end
        
        connection = RunService.Heartbeat:Connect(function()
            local cam = workspace.CurrentCamera
            vel.Velocity = (cam.CFrame.LookVector * (dirs.F + dirs.B) + ((cam.CFrame * CFrame.new(dirs.L + dirs.R, dirs.Up, 0)).p - cam.CFrame.p)) * speed
            gyro.CFrame = cam.CFrame
        end)
    end
    
    local function stop()
        if connection then connection:Disconnect() connection = nil end
        if gyro then gyro:Destroy() gyro = nil end
        if vel then vel:Destroy() vel = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
    
    local started = UserInput.InputBegan:Connect(function(key)
        local k = key.KeyCode
        if k == Enum.KeyCode.W then dirs.F = 1
        elseif k == Enum.KeyCode.S then dirs.B = -1
        elseif k == Enum.KeyCode.A then dirs.L = -1
        elseif k == Enum.KeyCode.D then dirs.R = 1
        elseif k == Enum.KeyCode.Space then dirs.Up = 1 end
    end)
    
    local ended = UserInput.InputEnded:Connect(function(key)
        local k = key.KeyCode
        if k == Enum.KeyCode.W then dirs.F = 0
        elseif k == Enum.KeyCode.S then dirs.B = 0
        elseif k == Enum.KeyCode.A then dirs.L = 0
        elseif k == Enum.KeyCode.D then dirs.R = 0
        elseif k == Enum.KeyCode.Space then dirs.Up = 0 end
    end)
    
    local self = {}
    
    function self:enable(bool)
        enabled = bool
        if bool then start() else stop() end
    end
    
    function self:setSpeed(s)
        speed = s
    end
    
    return self
end

return FlyModule