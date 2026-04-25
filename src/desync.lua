local DesyncModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

function DesyncModule.new(config)
    local self = {}
    local enabled = false
    local mode = "peek"
    local intensity = 3
    local jitter = false
    local jitterAmount = 0.3
    
    local desyncTypes = {
        peek = {type = "peek", delay = 0.05, offset = Vector3.new(0, 0, -2)},
        fake = {type = "fake", delay = 0.1, offset = Vector3.new(0, 0, 0)},
        fakewalk = {type = "fakewalk", delay = 0.08, offset = Vector3.new(0, 0, 0)},
        jitter = {type = "jitter", delay = 0.03, offset = Vector3.new(0, 0, 0)},
        silent = {type = "silent", delay = 0.06, offset = Vector3.new(0, 0, 0)},
        float = {type = "float", delay = 0.1, offset = Vector3.new(0, 1, 0)},
        teleport = {type = "teleport", delay = 0.02, offset = Vector3.new(0, 0, 0)},
    }
    
    local originalCFrame = nil
    local currentOffset = Vector3.new(0, 0, 0)
    local tickStarted = 0
    local isDesyncing = false
    
    local function startDesync()
        if not LocalPlayer.Character then return end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        tickStarted = tick()
        isDesyncing = true
        
        local settings = desyncTypes[mode]
        
        RunService.Heartbeat:Connect(function()
            if not enabled or not isDesyncing then return end
            
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = char.HumanoidRootPart
            local time = tick() - tickStarted
            local cycle = math.fmod(time, settings.delay * intensity * 2)
            
            if jitter then
                local jitterX = (math.random() - 0.5) * jitterAmount
                local jitterY = (math.random() - 0.5) * jitterAmount
                local jitterZ = (math.random() - 0.5) * jitterAmount
                currentOffset = Vector3.new(
                    settings.offset.X + jitterX,
                    settings.offset.Y + jitterY,
                    settings.offset.Z + jitterZ
                )
            else
                currentOffset = settings.offset
            end
            
            if cycle < settings.delay * intensity then
                hrp.CFrame = originalCFrame + currentOffset
            else
                hrp.CFrame = originalCFrame
            end
        end)
    end
    
    local function stopDesync()
        isDesyncing = false
        currentOffset = Vector3.new(0, 0, 0)
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool then
            startDesync()
        else
            stopDesync()
        end
    end
    
    function self:setMode(m)
        if desyncTypes[m] then
            mode = m
        end
    end
    
    function self:setIntensity(i)
        intensity = i
    end
    
    function self:setJitter(bool)
        jitter = bool
    end
    
    function self:setJitterAmount(a)
        jitterAmount = a
    end
    
    function self:getModeList()
        local list = {}
        for k, _ in pairs(desyncTypes) do
            table.insert(list, k)
        end
        return list
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                startDesync()
            end
        end)
    end
    
    return self
end

return DesyncModule