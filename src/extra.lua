local ExtraFeaturesModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

function ExtraFeaturesModule.new(config)
    local self = {}
    local enabled = false
    
    local features = {
        forcefield = false,
        godMode = false,
        infiniteAmmo = false,
        instaReload = false,
        noCooldown = false,
        autoReload = false,
        fireRate = 1,
        
        autoPickup = false,
        magnetRadius = 20,
        
        aimView = false,
        freeCam = false,
        thirdPerson = false,
        cameraOffset = Vector3.new(0, 2, 0),
        
        chatBypass = false,
        cmdsEnabled = false,
        
        autoWin = false,
        votekickBypass = false,
        
        antiReport = false,
        antiBan = false,
    }
    
    local function doGodMode()
        if features.godMode then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = math.min(humanoid.Health, 100)
                end
            end
        end
    end
    
    local function doNoCooldown()
        if features.noCooldown then
            for _, tbl in ipairs(getgc(true)) do
                if type(tbl) == "table" then
                    if rawget(tbl, "ShootCooldown") ~= nil then
                        tbl.ShootCooldown = 0
                    end
                    if rawget(tbl, "ReloadTime") ~= nil then
                        tbl.ReloadTime = 0
                    end
                    if rawget(tbl, "nextShot") ~= nil then
                        tbl.nextShot = 0
                    end
                end
            end
        end
    end
    
    local function doInfiniteAmmo()
        if features.infiniteAmmo then
            for _, tbl in ipairs(getgc(true)) do
                if type(tbl) == "table" then
                    if rawget(tbl, "Ammo") ~= nil then
                        tbl.Ammo = math.huge
                    end
                    if rawget(tbl, "currentAmmo") ~= nil then
                        tbl.currentAmmo = math.huge
                    end
                end
            end
        end
    end
    
    local function doAutoPickup()
        if features.autoPickup then
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local myPos = char.HumanoidRootPart.Position
            
            for _, item in ipairs(workspace:GetDescendants()) do
                if item:IsA("Tool") or item:IsA("Folder") then
                    if item:IsA("Tool") then
                        local dist = (item.Handle.Position - myPos).Magnitude
                        if dist < features.magnetRadius then
                            item.Handle.CFrame = CFrame.new(myPos)
                        end
                    end
                end
            end
        end
    end
    
    local function doChatBypass(text)
        if features.chatBypass then
            local bypassed = ""
            for i = 1, #text do
                local char = string.sub(text, i, i)
                if math.random(1, 3) == 1 then
                    bypassed = bypassed .. "`" .. char
                else
                    bypassed = bypassed .. char
                end
            end
            return bypassed
        end
        return text
    end
    
    local function handleCmd(cmd)
        if not features.cmdsEnabled then return end
        
        cmd = cmd:lower()
        local args = {}
        for word in string.gmatch(cmd, "%S+") do
            table.insert(args, word)
        end
        
        local command = args[1]
        
        if command == "!kill" then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        elseif command == "!god" then
            features.godMode = not features.godMode
            doGodMode()
        elseif command == "!fly" then
            features.forcefield = not features.forcefield
        elseif command == "!speed" then
            local speed = tonumber(args[2]) or 60
            settings.speedValue = speed
        elseif command == "!teleport" or command == "!tp" then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Name:lower():find(args[2]:lower()) then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                    break
                end
            end
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setGodMode(bool)
        features.godMode = bool
        doGodMode()
    end
    
    function self:setForcefield(bool)
        features.forcefield = bool
    end
    
    function self:setInfiniteAmmo(bool)
        features.infiniteAmmo = bool
        doInfiniteAmmo()
    end
    
    function self:setNoCooldown(bool)
        features.noCooldown = bool
        doNoCooldown()
    end
    
    function self:setFireRate(r)
        features.fireRate = r
    end
    
    function self:setAutoPickup(bool, radius)
        features.autoPickup = bool
        features.magnetRadius = radius or 20
    end
    
    function self:setChatBypass(bool)
        features.chatBypass = bool
    end
    
    function self:setCmdsEnabled(bool)
        features.cmdsEnabled = bool
    end
    
    function self:setAntiReport(bool)
        features.antiReport = bool
    end
    
    function self:executeCmd(cmd)
        handleCmd(cmd)
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                doNoCooldown()
                doInfiniteAmmo()
                doAutoPickup()
            end
        end)
        
        LocalPlayer.Chatted:Connect(function(msg)
            if features.cmdsEnabled then
                handleCmd(msg)
            end
        end)
    end
    
    return self
end

return ExtraFeaturesModule