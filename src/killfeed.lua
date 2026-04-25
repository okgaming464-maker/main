local KillFeedModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

function KillFeedModule.new(config)
    local self = {}
    local enabled = false
    local maxEntries = 10
    local showIcon = true
    local showTime = true
    local duration = 5
    local position = "right"
    
    local entries = {}
    local feedContainer = nil
    
    local icons = {
        headshot = "🔫",
        melee = "🔪",
        explosion = "💥",
        fall = "⬇️",
        weapon = "🔫",
        default = "💀"
    }
    
    local function createFeedContainer()
        local gui = Instance.new("ScreenGui")
        gui.Name = "KillFeed"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 250, 0, 300)
        container.BackgroundTransparency = 1
        container.Parent = gui
        
        if position == "right" then
            container.Position = UDim2.new(1, -270, 0.5, -150)
        else
            container.Position = UDim2.new(0, 20, 0.5, -150)
        end
        
        feedContainer = {gui = gui, container = container}
    end
    
    local function addEntry(killer, victim, method)
        if not enabled or not feedContainer then return end
        
        if #entries >= maxEntries then
            local oldest = table.remove(entries, 1)
            if oldest and oldest.frame then
                oldest.frame:Destroy()
            end
        end
        
        local icon = icons[method] or icons.default
        local entryText = icon .. " " .. killer.Name .. " killed " .. victim.Name
        
        if showTime then
            entryText = entryText .. " [" .. os.date("%H:%M") .. "]"
        end
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.BackgroundTransparency = 0.7
        frame.BorderSizePixel = 0
        frame.Parent = feedContainer.container
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = entryText
        text.TextColor3 = Color3.new(1, 1, 1)
        text.TextSize = 14
        text.Font = Enum.Font.Code
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = frame
        
        table.insert(entries, {frame = frame, text = text, time = tick()})
        
        task.spawn(function()
            task.wait(duration)
            if frame and frame.Parent then
                frame:TweenPosition(UDim2.new(0, 0, 1, 0), "In", "Quad", 0.3)
                task.wait(0.3)
                if frame and frame.Parent then
                    frame:Destroy()
                end
            end
            for i, entry in ipairs(entries) do
                if entry.frame == frame then
                    table.remove(entries, i)
                    break
                end
            end
        end)
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool and not feedContainer then
            createFeedContainer()
        end
    end
    
    function self:setMaxEntries(m)
        maxEntries = m
    end
    
    function self:setShowIcon(bool)
        showIcon = bool
    end
    
    function self:setShowTime(bool)
        showTime = bool
    end
    
    function self:setDuration(d)
        duration = d
    end
    
    function self:setPosition(pos)
        position = pos
        if feedContainer then
            if pos == "right" then
                feedContainer.container.Position = UDim2.new(1, -270, 0.5, -150)
            else
                feedContainer.container.Position = UDim2.new(0, 20, 0.5, -150)
            end
        end
    end
    
    function self:addKill(killer, victim, method)
        addEntry(killer, victim, method or "default")
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                    local hasDied = player:FindFirstChild("Died")
                    
                    if humanoid and humanoid.Health <= 0 and hasDied then
                        hasDied:Destroy()
                    end
                end
            end
        end)
    end
    
    return self
end

return KillFeedModule