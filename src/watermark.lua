local WatermarkModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

function WatermarkModule.new(config)
    local self = {}
    local enabled = false
    local showFPS = true
    local showPing = true
    local showTime = true
    local showServer = true
    local showKills = false
    local position = "top-left"
    local textColor = Color3.new(1, 1, 1)
    local bgColor = Color3.new(0, 0, 0, 0.5)
    
    local watermarkGui = nil
    local fpsCounter = 0
    local lastTick = tick()
    local currentFPS = 0
    local currentPing = 0
    
    local function createWatermark()
        local gui = Instance.new("ScreenGui")
        gui.Name = "WatermarkGui"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0, 180, 0, 25)
        bg.BackgroundColor3 = Color3.new(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.BorderSizePixel = 0
        bg.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = bg
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = "Rivals"
        text.TextColor3 = textColor
        text.TextStrokeTransparency = 0
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.Font = Enum.Font.Code
        text.TextSize = 14
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = bg
        
        if position == "top-left" then
            bg.Position = UDim2.new(0, 10, 0, 10)
        elseif position == "top-right" then
            bg.Position = UDim2.new(1, -190, 0, 10)
        elseif position == "bottom-left" then
            bg.Position = UDim2.new(0, 10, 1, -35)
        else
            bg.Position = UDim2.new(1, -190, 1, -35)
        end
        
        watermarkGui = {gui = gui, bg = bg, text = text}
    end
    
    local function getPing()
        local success, result = pcall(function()
            return LocalPlayer:GetNetworkIngestStats()
        end)
        if success and result then
            return math.floor(result.Inbound / 1000)
        end
        return 0
    end
    
    local function getTime()
        local time = os.date("*t")
        return string.format("%02d:%02d:%02d", time.hour, time.min, time.sec)
    end
    
    local function update()
        fpsCounter = fpsCounter + 1
        
        if tick() - lastTick >= 1 then
            currentFPS = fpsCounter
            fpsCounter = 0
            lastTick = tick()
            currentPing = getPing()
        end
        
        if not watermarkGui or not watermarkGui.text then return end
        
        local parts = {}
        if showFPS then table.insert(parts, currentFPS .. " FPS") end
        if showPing then table.insert(parts, currentPing .. "ms") end
        if showTime then table.insert(parts, getTime()) end
        if showServer then table.insert(parts, "Rivals") end
        if showKills then table.insert(parts, "0K") end
        
        watermarkGui.text.Text = table.concat(parts, " | ")
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool and not watermarkGui then
            createWatermark()
        end
        if watermarkGui then
            watermarkGui.bg.Visible = bool
        end
    end
    
    function self:setShowFPS(bool)
        showFPS = bool
    end
    
    function self:setShowPing(bool)
        showPing = bool
    end
    
    function self:setShowTime(bool)
        showTime = bool
    end
    
    function self:setShowServer(bool)
        showServer = bool
    end
    
    function self:setShowKills(bool)
        showKills = bool
    end
    
    function self:setPosition(pos)
        position = pos
        if watermarkGui and watermarkGui.bg then
            if pos == "top-left" then
                watermarkGui.bg.Position = UDim2.new(0, 10, 0, 10)
            elseif pos == "top-right" then
                watermarkGui.bg.Position = UDim2.new(1, -190, 0, 10)
            elseif pos == "bottom-left" then
                watermarkGui.bg.Position = UDim2.new(0, 10, 1, -35)
            else
                watermarkGui.bg.Position = UDim2.new(1, -190, 1, -35)
            end
        end
    end
    
    function self:setTextColor(color)
        textColor = color
        if watermarkGui and watermarkGui.text then
            watermarkGui.text.TextColor3 = color
        end
    end
    
    function self:run()
        RunService.Heartbeat:Connect(update)
    end
    
    return self
end

return WatermarkModule