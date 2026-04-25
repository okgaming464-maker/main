local AnimationModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function AnimationModule.new(config)
    local self = {}
    local enabled = false
    local currentAnimation = "default"
    local speed = 1
    local overrideAll = false
    
    local animations = {
        default = "rbxassetid://507771023",
        anime = "rbxassetid://507771951",
        idle = "rbxassetid://507766498",
        walk = "rbxassetid://507768233",
        run = "rbxassetid://507768375",
        jump = "rbxassetid://507765866",
        fall = "rbxassetid://507765784",
        tool = "rbxassetid://507825548",
        peace = "rbxassetid://507826519",
        sit = "rbxassetid://507767139",
        dance = "rbxassetid://507771023",
        dance2 = "rbxassetid://507771200",
        god = "rbxassetid://4616809583",
        superhero = "rbxassetid::4616809583",
        casual = "rbxassetid://507766498",
        tough = "rbxassetid://507825548",
        friendly = "rbxassetid://507766498",
robot = "rbxassetid://4616809583",
        zombie = "rbxassetid://4616809583",
        pirate = "rbxassetid://4616809583",
        ninja = "rbxassetid://4616809583",
        loop = "rbxassetid://507771023",
        flair = "rbxassetid://507768375",
    }
    
    local activeTracks = {}
    local humanoid = nil
    
    local function findAnimator()
        if not LocalPlayer.Character then return nil end
        return LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    end
    
    local function loadAnimation(animId)
        local hum = findAnimator()
        if not hum then return nil end
        
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        
        local ok, track = pcall(function()
            return hum:LoadAnimation(anim)
        end)
        
        if ok and track then
            return track
        end
        return nil
    end
    
    local function playAnimation(animName)
        if not enabled then return end
        
        local animId = animations[animName]
        if not animId then return end
        
        local track = loadAnimation(animId)
        if track then
            track:Play()
            track:AdjustSpeed(speed)
            activeTracks[animName] = track
        end
    end
    
    local function stopAllAnimations()
        for name, track in pairs(activeTracks) do
            pcall(function()
                track:Stop()
            end)
        end
        activeTracks = {}
    end
    
    local function applyToCharacter()
        if overrideAll then
            playAnimation(currentAnimation)
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        if not bool then
            stopAllAnimations()
        end
    end
    
    function self:setAnimation(name)
        currentAnimation = name
        if enabled then
            playAnimation(name)
        end
    end
    
    function self:setSpeed(s)
        speed = s
        for _, track in pairs(activeTracks) do
            pcall(function()
                track:AdjustSpeed(speed)
            end)
        end
    end
    
    function self:setOverrideAll(bool)
        overrideAll = bool
    end
    
    function self:getAnimationList()
        local list = {}
        for k, _ in pairs(animations) do
            table.insert(list, k)
        end
        return list
    end
    
    function self:getCurrentAnimation()
        return currentAnimation
    end
    
    function self:run()
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if enabled and overrideAll then
                applyToCharacter()
            end
        end)
        
        if enabled then
            applyToCharacter()
        end
    end
    
    return self
end

return AnimationModule