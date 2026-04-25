local WeaponModModule = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function WeaponModModule.new(config)
    local self = {}
    local enabled = false
    local fireRate = 1
    local spread = 0
    local recoil = 0
    local reloadSpeed = 1
    local damage = 1
    local range = 1
    local magazineSize = 1
    
    local originalValues = {}
    local active = false
    
    local function findGunTable()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "ShootCooldown") ~= nil then
                    return tbl
                end
            end
        end
        return nil
    end
    
    local function backupOriginal()
        local gun = findGunTable()
        if gun then
            originalValues = {
                ShootCooldown = rawget(gun, "ShootCooldown"),
                ShootSpread = rawget(gun, "ShootSpread"),
                ShootRecoil = rawget(gun, "ShootRecoil"),
            }
        end
    end
    
    local function applyMods()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "ShootCooldown") ~= nil then
                    tbl.ShootCooldown = (tbl.ShootCooldown or 0.1) / fireRate
                end
                if rawget(tbl, "ShootSpread") ~= nil then
                    tbl.ShootSpread = (tbl.ShootSpread or 0) * spread
                end
                if rawget(tbl, "ShootRecoil") ~= nil then
                    tbl.ShootRecoil = (tbl.ShootRecoil or 0) * recoil
                end
            end
        end
    end
    
    local function removeMods()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if originalValues.ShootCooldown and rawget(tbl, "ShootCooldown") ~= nil then
                    tbl.ShootCooldown = originalValues.ShootCooldown
                end
                if originalValues.ShootSpread and rawget(tbl, "ShootSpread") ~= nil then
                    tbl.ShootSpread = originalValues.ShootSpread
                end
                if originalValues.ShootRecoil and rawget(tbl, "ShootRecoil") ~= nil then
                    tbl.ShootRecoil = originalValues.ShootRecoil
                end
            end
        end
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool then
            backupOriginal()
            applyMods()
            active = true
        else
            removeMods()
            active = false
        end
    end
    
    function self:setFireRate(val)
        fireRate = val
        if active then applyMods() end
    end
    
    function self:setSpread(val)
        spread = val
        if active then applyMods() end
    end
    
    function self:setRecoil(val)
        recoil = val
        if active then applyMods() end
    end
    
    function self:setReloadSpeed(val)
        reloadSpeed = val
    end
    
    function self:setDamage(val)
        damage = val
    end
    
    function self:setRange(val)
        range = val
    end
    
    function self:getFireRate()
        return fireRate
    end
    
    function self:getSpread()
        return spread
    end
    
    function self:getRecoil()
        return recoil
    end
    
    function self:run()
        if enabled then
            RunService.Heartbeat:Connect(function()
                if active then
                    applyMods()
                end
            end)
        end
    end
    
    return self
end

return WeaponModModule