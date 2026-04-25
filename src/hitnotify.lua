local HitNotifyModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

function HitNotifyModule.new(config)
    local self = {}
    local enabled = false
    local showDamage = true
    local showKill = true
    local soundEnabled = true
    local position = "right"
    local maxNotifications = 5
    local selectedSound = "default"
    
    local notifications = {}
    local notificationContainer = nil
    
    local hitSounds = {
        default = "rbxassetid://12221967",
        neverlose = "rbxassetid://5365514973",
        bubble = "rbxassetid://12221967",
        skeet = "rbxassetid://6674151731",
        rust = "rbxassetid://1250926703",
        minecraft = "rbxassetid::164465132",
        baim = "rbxassetid://6674151731",
        oof = "rbxassetid://12221967",
        pop = "rbxassetid://6674151731",
        click = "rbxassetid://5365514973",
        anime = "rbxassetid://6674151731",
        discord = "rbxassetid://12221967",
        meme = "rbxassetid://5365514973",
    }
    
    local function createNotifyFrame()
        local gui = Instance.new("ScreenGui")
        gui.Name = "HitNotifyGui"
        gui.Parent = game.CoreGui
        
        notificationContainer = Instance.new("Frame")
        notificationContainer.Size = UDim2.new(0, 200, 0, 250)
        notificationContainer.BackgroundTransparency = 1
        notificationContainer.Parent = gui
        
        if position == "right" then
            notificationContainer.Position = UDim2.new(1, -220, 0.5, -125)
        else
            notificationContainer.Position = UDim2.new(0, 20, 0.5, -125)
        end
        
        return gui
    end
    
    local function playSound(soundName)
        if not soundEnabled then return end
        
        local soundId = hitSounds[soundName] or hitSounds.default
        
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = soundId
            sound.Volume = 0.5
            sound.Parent = SoundService
            sound:Play()
            task.wait(1)
            sound:Destroy()
        end)
    end
    
    local function showNotification(text, color, duration)
        if not enabled or not notificationContainer then return end
        
        local idx = #notifications + 1
        if idx > maxNotifications then return end
        
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(1, 0, 0, 30)
        notif.Position = UDim2.new(0, 0, 0, (idx - 1) * 35)
        notif.BackgroundTransparency = 1
        notif.Text = text
        notif.TextColor3 = color or Color3.new(1, 1, 1)
        notif.TextStrokeTransparency = 0
        notif.TextStrokeColor3 = Color3.new(0, 0, 0)
        notif.Font = Enum.Font.Code
        notif.TextSize = 18
        notif.TextXAlignment = Enum.TextXAlignment.Left
        notif.Parent = notificationContainer
        
        table.insert(notifications, notif)
        
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = hitSounds[selectedSound] or hitSounds.default
            sound.Volume = 0.5
            sound.Parent = SoundService
            sound:Play()
            task.wait(1)
            sound:Destroy()
        end)
        
        task.wait(duration or 2)
        
        if notif and notif.Parent then
            pcall(function()
                notif:TweenPosition(UDim2.new(0, 0, 0, (idx - 1) * 35 + 30), "In", "Quad", 0.3)
            end)
            task.wait(0.3)
            notif:Destroy()
            table.remove(notifications, idx)
        end
    end
    
    local lastTarget = nil
    local lastDamage = 0
    
    function self:registerHit(targetPlayer, damage)
        if not enabled or not targetPlayer then return end
        
        lastTarget = targetPlayer
        lastDamage = damage
        
        if showDamage and damage > 0 then
            showNotification(
                targetPlayer.Name .. " -" .. damage .. "hp",
                Color3.new(1, 0.3, 0.3),
                1.5
            )
            playSound(selectedSound)
        end
    end
    
    function self:registerKill(targetPlayer)
        if not enabled or not targetPlayer then return end
        
        if showKill then
            showNotification(
                "KILL: " .. targetPlayer.Name,
                Color3.new(1, 0, 0),
                3
            )
            playSound(selectedSound)
        end
    end
    
    function self:registerHeadshot()
        if not enabled then return end
        showNotification(
            "HEADSHOT!",
            Color3.new(1, 0.8, 0),
            2
        )
        playSound(selectedSound)
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool and not notificationContainer then
            createNotifyFrame()
        end
    end
    
    function self:setShowDamage(bool)
        showDamage = bool
    end
    
    function self:setShowKill(bool)
        showKill = bool
    end
    
    function self:setShowHeadshot(bool)
        showKill = bool
    end
    
    function self:setSound(bool)
        soundEnabled = bool
    end
    
    function self:setSoundByName(name)
        selectedSound = name
    end
    
    function self:getSoundList()
        local list = {}
        for k, _ in pairs(hitSounds) do
            table.insert(list, k)
        end
        return list
    end
    
    function self:setPosition(pos)
        position = pos
        if notificationContainer then
            if pos == "right" then
                notificationContainer.Position = UDim2.new(1, -220, 0.5, -125)
            else
                notificationContainer.Position = UDim2.new(0, 20, 0.5, -125)
            end
        end
    end
    
    function self:setMaxNotifications(num)
        maxNotifications = num
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and humanoid.Health <= 0 and lastTarget == player and lastDamage > 0 then
                        self:registerKill(player)
                        lastTarget = nil
                        lastDamage = 0
                    end
                end
            end
        end)
    end
    
    return self
end

return HitNotifyModule