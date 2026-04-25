local CameraModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function CameraModule.new(config)
    local self = {}
    local baseFOV = 70
    local currentFOV = 70
    local targetFOV = 70
    local minZoom = 0.1
    local maxZoom = 100
    local origZoom = 70
    local smooth = 5
    
    local camera = workspace.CurrentCamera
    
    local function applyFOV(fov)
        if camera then
            local clamped = math.clamp(fov, minZoom, maxZoom)
            camera.FieldOfView = clamped
            currentFOV = clamped
        end
    end
    
    local function setZoom(value)
        targetFOV = value
    end
    
    function self:setFOV(value)
        applyFOV(value)
    end
    
    function self:resetFOV()
        applyFOV(origZoom)
    end
    
    function self:setMinZoom(value)
        minZoom = value
    end
    
    function self:setMaxZoom(value)
        maxZoom = value
    end
    
    function self:getFOV()
        return currentFOV
    end
    
    function self:getOriginalFOV()
        return origZoom
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if currentFOV ~= targetFOV then
                local diff = targetFOV - currentFOV
                if math.abs(diff) < 0.1 then
                    currentFOV = targetFOV
                else
                    currentFOV = currentFOV + (diff / smooth)
                end
                applyFOV(currentFOV)
            end
        end)
    end
    
    return self
end

return CameraModule