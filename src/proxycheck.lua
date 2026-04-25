local ProxyCheckModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function ProxyCheckModule.new(config)
    local self = {}
    local enabled = false
    local checkPing = true
    local checkHealth = true
    local checkDistance = true
    local checkTeam = true
    local checkResolver = true
    local maxPing = 150
    local minHealth = 1
    local maxDistance = 1000
    
    local invalidTargets = {}
    local showNotifications = true
    
    local function isValidTarget(player)
        if not player then return false end
        if player == LocalPlayer then return false end
        if not player.Character then return false end
        if not player.Character:FindFirstChild("HumanoidRootPart") then return false end
        
        if checkTeam then
            if player.Team == LocalPlayer.Team then return false end
        end
        
        if checkPing then
            local success, ping = pcall(function()
                return player:GetNetworkPing()
            end)
            if success and (ping > maxPing or ping <= 0) then
                if showNotifications then
                    warn("[ProxyCheck] " .. player.Name .. " has high ping: " .. ping)
                end
                return false
            end
        end
        
        if checkHealth then
            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
            if not humanoid or humanoid.Health < minHealth then
                return false
            end
        end
        
        if checkDistance then
            local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist > maxDistance then
                if showNotifications then
                    warn("[ProxyCheck] " .. player.Name .. " is too far: " .. dist)
                end
                return false
            end
        end
        
        if checkResolver then
            local hrp = player.Character.HumanoidRootPart
            local velocity = hrp.Velocity
            local speed = velocity.Magnitude
            
            if speed > 100 then
                if showNotifications then
                    warn("[ProxyCheck] " .. player.Name .. " has high velocity: " .. speed)
                end
                invalidTargets[player.Name] = tick()
            end
        end
        
        return true
    end
    
    local function clearOldInvalid()
        local now = tick()
        for name, t in pairs(invalidTargets) do
            if now - t > 5 then
                invalidTargets[name] = nil
            end
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setCheckPing(bool)
        checkPing = bool
    end
    
    function self:setCheckHealth(bool)
        checkHealth = bool
    end
    
    function self:setCheckDistance(bool)
        checkDistance = bool
    end
    
    function self:setCheckTeam(bool)
        checkTeam = bool
    end
    
    function self:setCheckResolver(bool)
        checkResolver = bool
    end
    
    function self:setMaxPing(p)
        maxPing = p
    end
    
    function self:setMinHealth(h)
        minHealth = h
    end
    
    function self:setMaxDistance(d)
        maxDistance = d
    end
    
    function self:setShowNotifications(bool)
        showNotifications = bool
    end
    
    function self:isValid(player)
        return isValidTarget(player)
    end
    
    function self:getInvalidList()
        return invalidTargets
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                clearOldInvalid()
            end
        end)
    end
    
    return self
end

return ProxyCheckModule