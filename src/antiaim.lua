local AntiAimModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function AntiAimModule.new(config)
    local self = {}
    local enabled = false
    local mode = "static"
    local pitchMode = "down"
    local yawMode = "spin"
    local spinSpeed = 20
    local jitter = false
    local jitterRange = 90
    local fake = false
    local fakeValue = 180
    
    local aimModes = {
        static = {type = "static", speed = 0},
        spin = {type = "spin", speed = 20},
        fastspin = {type = "fastspin", speed = 45},
        jitter = {type = "jitter", speed = 0},
        sidespin = {type = "sidespin", speed = 15},
        fake = {type = "fake", speed = 0},
        flip = {type = "flip", speed = 0},
        edge = {type = "edge", speed = 0},
        reverse = {type = "reverse", speed = 10},
        zero = {type = "zero", speed = 0},
    }
    
    local pitchModes = {
        down = {value = 90},
        up = {value = -90},
        zero = {value = 0},
        jitter = {value = 90},
        fakeup = {value = -90},
    }
    
    local tickStarted = 0
    local currentYaw = 0
    
    local function applyAntiAim()
        if not enabled then return end
        if not LocalPlayer.Character then return end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local time = tick() - tickStarted
        local settings = aimModes[mode]
        
        local newYaw = 0
        local newPitch = pitchModes[pitchMode].value
        
        if mode == "static" then
            newYaw = 0
        elseif mode == "spin" then
            newYaw = settings.speed * time
        elseif mode == "fastspin" then
            newYaw = settings.speed * time * 2
        elseif mode == "jitter" then
            local cycle = math.fmod(time * 5, 1)
            if cycle < 0.5 then
                newYaw = -jitterRange
            else
                newYaw = jitterRange
            end
        elseif mode == "sidespin" then
            newYaw = math.sin(time * settings.speed) * 90
        elseif mode == "fake" then
            newYaw = fakeValue
        elseif mode == "flip" then
            newYaw = math.sin(time * 3) * 180
        elseif mode == "edge" then
            local cycle = math.fmod(time * 2, 1)
            if cycle < 0.5 then
                newYaw = 90
            else
                newYaw = -90
            end
        elseif mode == "reverse" then
            newYaw = -settings.speed * time
        elseif mode == "zero" then
            newYaw = 0
        end
        
        currentYaw = newYaw
        
        local newCFrame = CFrame.Angles(
            math.rad(newPitch),
            math.rad(newYaw),
            0
        )
        
        hrp.CFrame = CFrame.new(hrp.Position) * newCFrame
    end
    
    local function applyPitchOnly()
        if not enabled then return end
        if not LocalPlayer.Character then return end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local pitchValue = pitchModes[pitchMode].value
        
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(math.rad(pitchValue), 0, 0)
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool then
            tickStarted = tick()
        end
    end
    
    function self:setMode(m)
        if aimModes[m] then
            mode = m
        end
    end
    
    function self:setPitchMode(p)
        if pitchModes[p] then
            pitchMode = p
        end
    end
    
    function self:setYawMode(m)
        mode = m
    end
    
    function self:setSpinSpeed(s)
        spinSpeed = s
    end
    
    function self:setJitter(bool)
        jitter = bool
    end
    
    function self:setJitterRange(r)
        jitterRange = r
    end
    
    function self:setFake(bool)
        fake = bool
        if bool then
            fakeValue = 180
        end
    end
    
    function self:setFakeValue(v)
        fakeValue = v
    end
    
    function self:getModeList()
        local list = {}
        for k, _ in pairs(aimModes) do
            table.insert(list, k)
        end
        return list
    end
    
    function self:getPitchList()
        local list = {}
        for k, _ in pairs(pitchModes) do
            table.insert(list, k)
        end
        return list
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                applyAntiAim()
            end
        end)
    end
    
    return self
end

return AntiAimModule