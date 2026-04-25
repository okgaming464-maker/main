local WorldModule = {}
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

function WorldModule.new(config)
    local self = {}
    local enabled = false
    
    local settings = {
        fogEnabled = false,
        fogColor = Color3.new(0.7, 0.7, 0.7),
        fogDensity = 0.5,
        fogStart = 0,
        fogEnd = 200,
        
        skyEnabled = false,
        skyColor = Color3.new(0.5, 0.7, 1),
        
        lightingEnabled = false,
        ambient = Color3.new(0.5, 0.5, 0.5),
        brightness = 1,
        timeOfDay = "12:00",
        
        globalShadows = false,
        exposure = 1,
        colorShift = Color3.new(0, 0, 0),
        
        weatherEnabled = false,
        weatherType = "none",
        weatherIntensity = 0.5,
    }
    
    local originalSettings = {}
    local skyBox = nil
    
    local function backupOriginal()
        originalSettings = {
            fogEnabled = Lighting.FogEnabled,
            fogColor = Lighting.FogColor,
            fogDensity = Lighting.FogDensity,
            fogStart = Lighting.FogStart,
            fogEnd = Lighting.FogEnd,
            ambient = Lighting.Ambient,
            brightness = Lighting.Brightness,
            timeOfDay = Lighting.TimeOfDay,
            globalShadows = Lighting.GlobalShadows,
            exposure = Lighting.ExposureCompensation,
        }
    end
    
    local function setFog()
        if settings.fogEnabled then
            Lighting.FogEnabled = true
            Lighting.FogColor = settings.fogColor
            Lighting.FogDensity = settings.fogDensity
            Lighting.FogStart = settings.fogStart
            Lighting.FogEnd = settings.fogEnd
        else
            if originalSettings.fogEnabled ~= nil then
                Lighting.FogEnabled = originalSettings.fogEnabled
                Lighting.FogColor = originalSettings.fogColor
                Lighting.FogDensity = originalSettings.fogDensity
                Lighting.FogStart = originalSettings.fogStart
                Lighting.FogEnd = originalSettings.fogEnd
            else
                Lighting.FogEnabled = false
            end
        end
    end
    
    local function setSky()
        if settings.skyEnabled then
            if not skyBox then
                skyBox = ReplicatedStorage:FindFirstChild("Sky")
                if not skyBox then
                    skyBox = Instance.new("Sky")
                    skyBox.Name = "CustomSky"
                    skyBox.Parent = ReplicatedStorage
                end
            end
            skyBox.SkyboxBk = settings.skyColor
            skyBox.SkyboxFt = settings.skyColor
            skyBox.SkyboxLft = settings.skyColor
            skyBox.SkyboxRt = settings.skyColor
            skyBox.SkyboxUp = settings.skyColor
            skyBox.SkyboxDn = settings.skyColor
            Lighting.CustomSky = skyBox
        else
            if skyBox then
                skyBox:Destroy()
                skyBox = nil
            end
        end
    end
    
    local function setLighting()
        if settings.lightingEnabled then
            Lighting.Ambient = settings.ambient
            Lighting.Brightness = settings.brightness
            if settings.timeOfDay ~= "default" then
                local hour = tonumber(string.split(settings.timeOfDay, ":")[1]) or 12
                Lighting.TimeOfDay = tostring(hour * 360)
            end
            Lighting.GlobalShadows = settings.globalShadows
            Lighting.ExposureCompensation = settings.exposure
        else
            if originalSettings.ambient then
                Lighting.Ambient = originalSettings.ambient
                Lighting.Brightness = originalSettings.brightness
                Lighting.TimeOfDay = originalSettings.timeOfDay
                Lighting.GlobalShadows = originalSettings.globalShadows
                Lighting.ExposureCompensation = originalSettings.exposure
            end
        end
    end
    
    local function setWeather()
        if not settings.weatherEnabled then return end
        
        local weatherTypes = {
            none = {particles = 0, sound = nil},
            rain = {particles = 100, sound = "rbxassetid://154639267"},
            snow = {particles = 50, sound = nil},
            fog = {particles = 200, sound = nil},
            storm = {particles = 150, sound = "rbxassetid://154639267"},
        }
        
        local weather = weatherTypes[settings.weatherType]
        if weather then
            pcall(function()
                local ps = game:GetService("ParticlesService")
            end)
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        backupOriginal()
        setFog()
        setSky()
        setLighting()
    end
    
    function self:setFogEnabled(bool)
        settings.fogEnabled = bool
        setFog()
    end
    
    function self:setFogColor(color)
        settings.fogColor = color
        setFog()
    end
    
    function self:setFogDensity(d)
        settings.fogDensity = d
        setFog()
    end
    
    function self:setSkyEnabled(bool)
        settings.skyEnabled = bool
        setSky()
    end
    
    function self:setSkyColor(color)
        settings.skyColor = color
        setSky()
    end
    
    function self:setLightingEnabled(bool)
        settings.lightingEnabled = bool
        setLighting()
    end
    
    function self:setAmbient(color)
        settings.ambient = color
        setLighting()
    end
    
    function self:setBrightness(b)
        settings.brightness = b
        setLighting()
    end
    
    function self:setTimeOfDay(time)
        settings.timeOfDay = time
        setLighting()
    end
    
    function self:setWeatherEnabled(bool)
        settings.weatherEnabled = bool
        setWeather()
    end
    
    function self:setWeatherType(type)
        settings.weatherType = type
        setWeather()
    end
    
    function self:setWeatherIntensity(i)
        settings.weatherIntensity = i
        setWeather()
    end
    
    function self:getSettings()
        return settings
    end
    
    function self:reset()
        Lighting.FogEnabled = originalSettings.fogEnabled or false
        Lighting.FogColor = originalSettings.fogColor or Color3.new(0.7, 0.7, 0.7)
        Lighting.FogDensity = originalSettings.fogDensity or 0.5
        Lighting.Ambient = originalSettings.ambient or Color3.new(0.5, 0.5, 0.5)
        Lighting.Brightness = originalSettings.brightness or 1
        Lighting.TimeOfDay = originalSettings.timeOfDay or "12:00"
        if skyBox then skyBox:Destroy() skyBox = nil end
    end
    
    function self:run()
        RunService.Heartbeat:Connect(function()
            if enabled then
                setFog()
            end
        end)
    end
    
    return self
end

return WorldModule