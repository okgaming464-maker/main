local DamageESPModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

function DamageESPModule.new(config)
    local self = {}
    local enabled = false
    local showDamage = true
    local showHealing = true
    local showMock = true
    local showTextAbove = true
    local fadeTime = 1
    local position = "above"
    
    local damageTexts = {}
    
    local function showDamageNumber(target, damage, isHeal)
        if not enabled or not showTextAbove then return end
        
        local char = target.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = char.HumanoidRootPart
        local cam = workspace.CurrentCamera
        
        local pos, onScreen = cam:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
        if not onScreen then return end
        
        local text = tostring(math.floor(damage))
        if isHeal then
            text = "+" .. text
        else
            text = "-" .. text
        end
        
        local color = isHeal and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        
        local screenText = Drawing.new("Text")
        screenText.Text = text
        screenText.Size = 24
        screenText.Font = Enum.Font.Code
        screenText.Color = color
        screenText.Outline = true
        screenText.OutlineColor = Color3.new(0, 0, 0)
        screenText.Position = Vector2.new(pos.X, pos.Y)
        screenText.Visible = true
        
        local startTime = tick()
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= fadeTime then
                screenText.Visible = false
                screenText:Remove()
                connection:Disconnect()
            else
                screenText.Position = screenText.Position - Vector2.new(0, 1)
                screenText.Transparency = 1 - (elapsed / fadeTime)
            end
        end)
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setShowDamage(bool)
        showDamage = bool
    end
    
    function self:setShowHealing(bool)
        showHealing = bool
    end
    
    function self:setShowTextAbove(bool)
        showTextAbove = bool
    end
    
    function self:setFadeTime(t)
        fadeTime = t
    end
    
    function self:setDamage(target, damage)
        if showDamage then
            showDamageNumber(target, damage, false)
        end
    end
    
    function self:setHeal(target, amount)
        if showHealing then
            showDamageNumber(target, amount, true)
        end
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function()
                        if player.Character then
                            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                            if humanoid then
                                local health = humanoid.Health
                                local prevHealth = humanoid:FindFirstChild("PreviousHealth") or health
                                
                                if prevHealth ~= health then
                                    local diff = prevHealth - health
                                    if diff > 0 and showDamage then
                                        showDamageNumber(player, diff, false)
                                    elseif diff < 0 and showHealing then
                                        showDamageNumber(player, -diff, true)
                                    end
                                    humanoid:SetAttribute("PreviousHealth", health)
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
    
    return self
end

return DamageESPModule