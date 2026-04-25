local MovementModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function MovementModule.new(config)
    local self = {}
    local enabled = false
    
    local settings = {
        bhopEnabled = false,
        bhopSpeed = 16,
        autostrafeEnabled = false,
        autostrafeSpeed = 20,
        flyEnabled = false,
        flyNoClip = false,
        
        airjumpEnabled = false,
        infinityJump = false,
        multiJump = false,
        jumpCount = 1,
        
        speedEnabled = false,
        speedValue = 60,
        
        noSlowDown = false,
        noFallDamage = false,
        noStun = false,
        
        movement = {
            forward = false,
            backward = false,
            left = false,
            right = false,
            jump = false,
        }
    }
    
    local keysPressed = {}
    local jumpPressed = false
    
    local function doBhop()
        if not settings.bhopEnabled then return end
        if not LocalPlayer.Character then return end
        
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end
        
        local isMoving = UserInputService:IsKeyDown(Enum.KeyCode.W) or
                        UserInputService:IsKeyDown(Enum.KeyCode.A) or
                        UserInputService:IsKeyDown(Enum.KeyCode.S) or
                        UserInputService:IsKeyDown(Enum.KeyCode.D)
        
        local isGrounded = humanoid.FloorMaterial ~= Enum.Material.Air
        
        if isMoving and isGrounded then
            humanoid.WalkSpeed = settings.bhopSpeed
        else
            humanoid.WalkSpeed = 16
        end
    end
    
    local function doAutostrafe()
        if not settings.autostrafeEnabled then return end
        if not LocalPlayer.Character then return end
        
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end
        
        if humanoid.FloorMaterial == Enum.Material.Air then
            local keys = {"A", "D", "W", "S"}
            local randKey = keys[math.random(1, #keys)]
            local key = Enum.KeyCode[randKey]
            
            if key == Enum.KeyCode.A then
                humanoid.AutoRotate = false
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(-settings.autostrafeSpeed), 0)
                end
            elseif key == Enum.KeyCode.D then
                humanoid.AutoRotate = false
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(settings.autostrafeSpeed), 0)
                end
            end
        end
    end
    
    local function doInfiniteJump()
        if not settings.infinityJump then return end
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                if humanoid and humanoid.FloorMaterial == Enum.Material.Air and not jumpPressed then
                    humanoid.Jump = true
                    jumpPressed = true
                    task.wait(0.1)
                    jumpPressed = false
                elseif humanoid then
                    humanoid.Jump = true
                end
            end
        end)
    end
    
    local function doNoSlowDown()
        if not settings.noSlowDown then return end
        
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CustomIdleAnimation = Enum.HumanoidRootPartOperationTheme.Invalid
                    end
                end
            end
        end)
    end
    
    local function doNoFallDamage()
        if not settings.noFallDamage then return end
        
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.JumpPower = 0
            humanoid.JumpHeight = 0
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
    end
    
    function self:setBhopEnabled(bool)
        settings.bhopEnabled = bool
    end
    
    function self:setBhopSpeed(s)
        settings.bhopSpeed = s
    end
    
    function self:setAutostrafeEnabled(bool)
        settings.autostrafeEnabled = bool
    end
    
    function self:setAutostrafeSpeed(s)
        settings.autostrafeSpeed = s
    end
    
    function self:setInfiniteJump(bool)
        settings.infinityJump = bool
        doInfiniteJump()
    end
    
    function self:setMultiJump(bool, count)
        settings.multiJump = bool
        settings.jumpCount = count or 2
    end
    
    function self:setSpeedEnabled(bool, value)
        settings.speedEnabled = bool
        settings.speedValue = value or 60
        
        local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = bool and settings.speedValue or 16
        end
    end
    
    function self:setNoSlowDown(bool)
        settings.noSlowDown = bool
    end
    
    function self:setNoFallDamage(bool)
        settings.noFallDamage = bool
    end
    
    function self:setNoStun(bool)
        settings.noStun = bool
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                doBhop()
                doAutostrafe()
            end
        end)
        
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            if settings.speedEnabled then
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = settings.speedValue
                end
            end
        end)
    end
    
    return self
end

return MovementModule