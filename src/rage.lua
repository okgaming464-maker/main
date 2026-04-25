local RageModule = {}
local _RunService = game:GetService('RunService')

function RageModule.new()
    local self = {}
    local enabled = false
    local cooldownEnabled = false
    local spreadEnabled = false
    local recoilEnabled = false
    
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
    
    local function findTableField(targetField)
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                for field, _ in pairs(tbl) do
                    if string.find(string.lower(field), string.lower(targetField)) then
                        return tbl, field
                    end
                end
            end
        end
        return nil, nil
    end
    
    local function applyCooldown()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "ShootCooldown") ~= nil then
                    tbl.ShootCooldown = 0
                end
                if rawget(tbl, "nextShot") ~= nil then
                    tbl.nextShot = 0
                end
                if rawget(tbl, "lastShot") ~= nil then
                    tbl.lastShot = 0
                end
            end
        end
    end
    
    local function applySpread()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "ShootSpread") ~= nil then
                    tbl.ShootSpread = 0
                end
                if rawget(tbl, "spread") ~= nil then
                    tbl.spread = 0
                end
                if rawget(tbl, "currentSpread") ~= nil then
                    tbl.currentSpread = 0
                end
            end
        end
    end
    
    local function applyRecoil()
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "ShootRecoil") ~= nil then
                    tbl.ShootRecoil = 0
                end
                if rawget(tbl, "recoil") ~= nil then
                    tbl.recoil = 0
                end
                if rawget(tbl, "currentRecoil") ~= nil then
                    tbl.currentRecoil = 0
                end
                if rawget(tbl, "aimRecoil") ~= nil then
                    tbl.aimRecoil = 0
                end
            end
        end
    end
    
    local function applyAll()
        if cooldownEnabled then applyCooldown() end
        if spreadEnabled then applySpread() end
        if recoilEnabled then applyRecoil() end
    end
    
    local connection = nil
    
    function self:enable(bool)
        enabled = bool
        if enabled then
            if not connection then
                connection = _RunService.Heartbeat:Connect(applyAll)
            end
            applyAll()
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
        end
    end
    
    function self:setCooldown(enabled)
        cooldownEnabled = enabled
        if enabled then applyCooldown() end
    end
    
    function self:setSpread(enabled)
        spreadEnabled = enabled
        if enabled then applySpread() end
    end
    
    function self:setRecoil(enabled)
        recoilEnabled = enabled
        if enabled then applyRecoil() end
    end
    
    function self:setBulletTracers(enabled)
        -- Tracer manipulation would go here
    end
    
    function self:setInstantHit(enabled)
        for _, tbl in ipairs(getgc(true)) do
            if type(tbl) == "table" then
                if rawget(tbl, "bulletSpeed") ~= nil then
                    tbl.bulletSpeed = 10000
                end
                if rawget(tbl, "projectileSpeed") ~= nil then
                    tbl.projectileSpeed = 10000
                end
            end
        end
    end
    
    function self:getEnabled()
        return enabled
    end
    
    return self
end

return RageModule