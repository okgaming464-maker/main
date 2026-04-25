local DoubleTapModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function DoubleTapModule.new(config)
    local self = {}
    local enabled = false
    local mode = "hit"
    local speed = 1
    local delay = 0.05
    local requireKey = true
    local keyBind = Enum.KeyCode.E
    
    local doubleTapping = false
    local lastTap = 0
    local tapCount = 0
    
    local function performDoubleTap()
        if not enabled then return end
        
        doubleTapping = true
        
        pcall(function()
            for _, tbl in ipairs(getgc(true)) do
                if type(tbl) == "table" then
                    if rawget(tbl, "ShootCooldown") ~= nil then
                        tbl.ShootCooldown = 0
                    end
                    if rawget(tbl, "nextShot") ~= nil then
                        tbl.nextShot = 0
                    end
                    if rawget(tbl, "lastShot") ~= nil then
                        tbl.lastShot = 0
                    end
                end
            end
        end)
        
        task.wait(delay)
        
        doubleTapping = false
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setMode(m)
        mode = m
    end
    
    function self:setSpeed(s)
        speed = s
    end
    
    function self:setDelay(d)
        delay = d
    end
    
    function self:setKeyBind(key)
        keyBind = key
    end
    
    function self:isDoubleTapping()
        return doubleTapping
    end
    
    function self:run()
        if requireKey then
            local InputService = game:GetService("UserInputService")
            
            InputService.InputBegan:Connect(function(input)
                if input.KeyCode == keyBind and enabled then
                    performDoubleTap()
                end
            end)
        else
            RunService.Heartbeat:Connect(function()
                if enabled then
                    local time = tick()
                    if time - lastTap > (1 / speed) then
                        performDoubleTap()
                        lastTap = time
                    end
                end
            end)
        end
    end
    
    return self
end

return DoubleTapModule