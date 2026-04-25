local PlayerModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")

function PlayerModule.new(config)
    local self = {}
    local speedEnabled = false
    local speedValue = 60
    local jumpEnabled = false
    local noclipEnabled = false
    local thirdPersonEnabled = false
    local cameraOffset = Vector3.new(0, 5, 10)
    
    local function setNoclip(enabled)
        noclipEnabled = enabled
        if enabled then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end
    
    local function setThirdPerson(enabled)
        thirdPersonEnabled = enabled
        pcall(function()
            local cam = workspace.CurrentCamera
            if enabled then
                cam.CameraType = Enum.CameraType.Custom
                cameraOffset = Vector3.new(0, 5, 10)
            else
                cam.CameraType = Enum.CameraType.Custom
                cameraOffset = Vector3.new(0, 2, 0)
            end
        end)
    end
    
    local originalJump = LocalPlayer.Character.Humanoid.Jump
    
    local function setInfiniteJump(enabled)
        jumpEnabled = enabled
        if enabled then
            pcall(function()
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Jump = true
                end
            end)
        end
    end
    
    InputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and jumpEnabled then
            if input.KeyCode == Enum.KeyCode.Space then
                pcall(function()
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                    end
                end)
            end
        end
    end)
    
    if config then
        if config.WalkSpeed then
            speedValue = config.WalkSpeed
        end
    end
    
    function self:setSpeedHack(enabled, value)
        speedEnabled = enabled
        if value then speedValue = value end
        
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = enabled and speedValue or 16
            end
        end)
    end
    
    function self:setInfiniteJump(enabled)
        setInfiniteJump(enabled)
    end
    
    function self:setNoClip(enabled)
        setNoclip(enabled)
    end
    
    function self:setThirdPerson(enabled)
        setThirdPerson(enabled)
    end
    
    function self:setCameraOffset(offset)
        cameraOffset = offset
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if speedEnabled then
                pcall(function()
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speedValue
                    end
                end)
            end
            
            if thirdPersonEnabled then
                pcall(function()
                    local cam = workspace.CurrentCamera
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hrp = char.HumanoidRootPart
                        cam.CFrame = CFrame.new(hrp.Position + cameraOffset) * CFrame.lookAt(hrp.Position, hrp.Position + hrp.CFrame.LookVector)
                    end
                end)
            end
        end)
        
        RunService.RenderStepped:Connect(function()
            if jumpEnabled then
                pcall(function()
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.GetState and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                        humanoid.Jump = true
                    end
                end)
            end
        end)
        
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            if speedEnabled then
                pcall(function()
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speedValue
                    end
                end)
            end
            
            if thirdPersonEnabled then
                setThirdPerson(true)
            end
        end)
    end
    
    return self
end

return PlayerModule