local BulletTracerModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function BulletTracerModule.new(config)
    local self = {}
    local enabled = false
    local color = Color3.new(1, 0.2, 0.2)
    local thickness = 2
    local fade = true
    local fadeTime = 0.3
    local showTeam = false
    local showEnemy = true
    local length = 20
    
    local activeTracers = {}
    local tracerCount = 0
    local maxTracers = 50
    
    local function createTracer(startPos, endPos, isEnemy)
        if tracerCount >= maxTracers then
            for i, tracer in ipairs(activeTracers) do
                if tracer and tracer.line then
                    tracer.line:Remove()
                end
                table.remove(activeTracers, i)
                tracerCount = tracerCount - 1
                break
            end
        end
        
        local line = Drawing.new("Line")
        line.From = startPos
        line.To = endPos
        line.Thickness = thickness
        line.Color = isEnemy and color or color
        line.Transparency = 1
        line.Visible = true
        
        local tracer = {
            line = line,
            startTime = tick(),
            startPos = startPos,
            endPos = endPos,
            isEnemy = isEnemy
        }
        
        table.insert(activeTracers, tracer)
        tracerCount = tracerCount + 1
        
        if fade then
            task.spawn(function()
                local elapsed = 0
                while elapsed < fadeTime do
                    task.wait(0.01)
                    elapsed = tick() - tracer.startTime
                    local alpha = 1 - (elapsed / fadeTime)
                    line.Transparency = alpha
                end
                line:Remove()
                tracerCount = tracerCount - 1
            end)
        end
        
        return tracer
    end
    
    local function simulateShot(targetPlayer)
        if not enabled then return end
        if not targetPlayer or not targetPlayer.Character then return end
        
        local myChar = LocalPlayer.Character
        local targetChar = targetPlayer.Character
        
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return end
        
        local myHRP = myChar.HumanoidRootPart
        local targetHRP = targetChar.HumanoidRootPart
        
        local startPos = myHRP.Position + Vector3.new(0, 1.5, 0)
        local endPos = targetHRP.Position + Vector3.new(0, 1.5, 0)
        
        local isEnemy = targetPlayer.Team ~= LocalPlayer.Team
        
        if isEnemy and not showEnemy then return end
        if not isEnemy and not showTeam then return end
        
        createTracer(startPos, endPos, isEnemy)
    end
    
    local function fireTracer(direction)
        if not enabled then return end
        
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        local myHRP = myChar.HumanoidRootPart
        
        local startPos = myHRP.Position + Vector3.new(0, 1.5, 0)
        local endPos = startPos + (direction.Unit * length * 3)
        
        createTracer(startPos, endPos, true)
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setColor(c)
        color = c
    end
    
    function self:setThickness(t)
        thickness = t
    end
    
    function self:setFade(bool)
        fade = bool
    end
    
    function self:setFadeTime(t)
        fadeTime = t
    end
    
    function self:setShowTeam(bool)
        showTeam = bool
    end
    
    function self:setShowEnemy(bool)
        showEnemy = bool
    end
    
    function self:setLength(l)
        length = l
    end
    
    function self:shootAt(targetPlayer)
        simulateShot(targetPlayer)
    end
    
    function self:fire(direction)
        fireTracer(direction)
    end
    
    function self:clear()
        for _, tracer in ipairs(activeTracers) do
            if tracer and tracer.line then
                tracer.line:Remove()
            end
        end
        activeTracers = {}
        tracerCount = 0
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled and tracerCount > 0 then
                for i = #activeTracers, 1, -1 do
                    local tracer = activeTracers[i]
                    if not tracer or not tracer.line or not tracer.line.Visible then
                        table.remove(activeTracers, i)
                    end
                end
            end
        end)
    end
    
    return self
end

return BulletTracerModule