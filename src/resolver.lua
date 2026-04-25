local ResolverModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function ResolverModule.new(config)
    local self = {}
    local enabled = false
    local mode = "velocity"
    local autoResolve = true
    local preferBody = false
    
    local resolvedPlayers = {}
    local lastPositions = {}
    local resolveAttempts = {}
    
    local function predictPosition(player)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return nil
        end
        
        local hrp = player.Character.HumanoidRootPart
        local currentPos = hrp.Position
        local velocity = hrp.Velocity
        
        if not lastPositions[player.Name] then
            lastPositions[player.Name] = currentPos
            return currentPos
        end
        
        local lastPos = lastPositions[player.Name]
        local predictedPos = currentPos + (velocity * 0.1)
        
        lastPositions[player.Name] = currentPos
        
        return predictedPos
    end
    
    local function resolvePlayer(player)
        if not enabled then return end
        
        if not resolveAttempts[player.Name] then
            resolveAttempts[player.Name] = 0
        end
        
        resolveAttempts[player.Name] = resolveAttempts[player.Name] + 1
        
        if resolveAttempts[player.Name] > 3 then
            resolvedPlayers[player.Name] = true
            resolveAttempts[player.Name] = 0
        end
    end
    
    local function detectAntiResolve(player)
        if not player.Character then return false end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        
        local velocity = hrp.Velocity
        local speed = velocity.Magnitude
        
        if speed > 30 and math.abs(velocity.X) > math.abs(velocity.Z) then
            return true
        end
        
        if speed < 0.5 and hrp.Position ~= lastPositions[player.Name] then
            return true
        end
        
        return false
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setMode(m)
        mode = m
    end
    
    function self:setAutoResolve(bool)
        autoResolve = bool
    end
    
    function self:setPreferBody(bool)
        preferBody = bool
    end
    
    function self:getResolved(playerName)
        return resolvedPlayers[playerName] or false
    end
    
    function self:resolve(player)
        resolvePlayer(player)
    end
    
    function self:predict(player)
        return predictPosition(player)
    end
    
    function self:isAntiResolved(player)
        return detectAntiResolve(player)
    end
    
    function self:clear()
        resolvedPlayers = {}
        lastPositions = {}
        resolveAttempts = {}
    end
    
    function self:run()
        if autoResolve then
            RunService.Heartbeat:Connect(function()
                if not enabled then return end
                
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if detectAntiResolve(player) then
                            resolvePlayer(player)
                        end
                    end
                end
            end)
        end
    end
    
    return self
end

return ResolverModule