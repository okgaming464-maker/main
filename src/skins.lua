local SkinModule = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getAssetId(skinName)
    local skinMap = {
        ['Compound Bow'] = 12102541,
        ['Raven Bow'] = 12102543,
        ['Dream Bow'] = 12102545,
        ['Bat Bow'] = 12102547,
        ['Frostbite Bow'] = 12102549,
        ['Key Bow'] = 12102551,
        ['AKEY-47'] = 12102553,
        ['AK-47'] = 12102555,
        ['Boneclaw Rifle'] = 12102557,
        ['Phoenix Rifle'] = 12102559,
        ['Blobsaw'] = 12102561,
        ['Mega Drill'] = 12102563,
        ['Buzzsaw'] = 12102565,
        ['Nuke Launcher'] = 12102567,
        ['RPKEY'] = 12102569,
        ['Spaceship Launcher'] = 12102571,
        ['Aqua Burst'] = 12102573,
        ['Electro Rifle'] = 12102575,
        ['FAMAS'] = 12102577,
        ['Singularity'] = 12102579,
        ['Wondergun'] = 12102581,
        ['Ray Gun'] = 12102583,
        ['Boxing Gloves'] = 12102585,
        ['Brass Knuckles'] = 12102587,
        ['Lamethrower'] = 12102589,
        ['Pixel Flamethrower'] = 12102591,
        ['Dynamite Gun'] = 12102593,
        ['Firework Gun'] = 12102595,
        ['Bubble Ray'] = 12102597,
        ['Temporal Ray'] = 12102599,
        ['Water Balloon'] = 12102601,
        ['Dynamite'] = 12102603,
        ['Soul Grenade'] = 12102605,
        ['Swashbuckler'] = 12102607,
        ['Uranium Launcher'] = 12102609,
        ['Hand Gun'] = 12102611,
        ['Pixel Handgun'] = 12102613,
        ['Blaster'] = 12102615,
        ['Stealth Handgun'] = 12102617,
        ['Lightning Bolt'] = 12102619,
        ['Saber'] = 12102621,
        ['Stellar Katana'] = 12102623,
        ['Keytana'] = 12102625,
        ['Lasergun 3000'] = 12102627,
        ['Pixel Minigun'] = 12102629,
        ['Fighter Jet'] = 12102631,
        ['Boba Gun'] = 12102633,
        ['Slime Gun'] = 12102635,
        ['Ketchup Gun'] = 12102637,
        ['Sheriff'] = 12102639,
        ['Desert Eagle'] = 12102641,
        ['Peppergun'] = 12102643,
        ['Keyvolver'] = 12102645,
        ['Goalpost'] = 12102647,
        ['Stick'] = 12102649,
        ['Harp'] = 12102651,
        ["Don't Press"] = 12102653,
        ['Spring'] = 12102655,
        ['DIY Tripmine'] = 12102657,
        ['Electro Uzi'] = 12102659,
        ['Water Uzi'] = 12102661,
        ['Money Gun'] = 12102663,
        ['Keyzi'] = 12102665,
        ['Pixel Sniper'] = 12102667,
        ['Hyper Sniper'] = 12102669,
        ['Event Horizon'] = 12102671,
        ['Keyper'] = 12102673,
        ['Karambit'] = 12102675,
        ['Chancla'] = 12102677,
        ['Balisong'] = 12102679,
        ['Machete'] = 12102681,
        ['Pixel Crossbow'] = 12102683,
        ['Harpoon Crossbow'] = 12102685,
        ['Hacker Rifle'] = 12102687,
        ['Hydro Rifle'] = 12102689,
        ['Void Rifle'] = 12102691,
        ['Apex Rifle'] = 12102693,
        ['Hyper Gunblade'] = 12102695,
        ['Crude Gunblade'] = 12102697,
        ['Gunsaw'] = 12102699,
        ['Balloon Shotgun'] = 12102701,
        ['Hyper Shotgun'] = 12102703,
        ['Cactus Shotgun'] = 12102705,
        ['Shotkey'] = 12102707,
        ['Aces'] = 12102709,
        ['Paper Planes'] = 12102711,
        ['Shurikens'] = 12102713,
        ['Cookies'] = 12102715,
        ['Hacker Pistols'] = 12102717,
        ['Void Pistols'] = 12102719,
        ['Hydro Pistols'] = 12102721,
        ['Apex Pistols'] = 12102723,
        ['Not So Shorty'] = 12102725,
        ['Lovely Shorty'] = 12102727,
        ['Balloon Shorty'] = 12102729,
        ['Demon Shorty'] = 12102731,
        ['Too Shorty'] = 12102733,
        ['Lovely Spray'] = 12102735,
        ['Nailgun'] = 12102737,
        ['Spray Bottle'] = 12102739,
        ['The Shred'] = 12102741,
        ['Ban Axe'] = 12102743,
        ['Cerulean Axe'] = 12102745,
        ['Nordic Axe'] = 12102747,
        ['Door'] = 12102749,
        ['Energy Shield'] = 12102751,
        ['Masterpiece'] = 12102753,
        ['Sled'] = 12102755,
        ['Scythe of Death'] = 12102757,
        ['Anchor'] = 12102759,
        ['Sakura Scythe'] = 12102761,
        ['Bat Scythe'] = 12102763,
        ['Cryo Scythe'] = 12102765,
        ['Keythe'] = 12102767,
        ['Bug Net'] = 12102769,
        ['Plastic Shovel'] = 12102771,
        ['Garden Shovel'] = 12102773,
        ['Paintbrush'] = 12102775,
        ['Pumpkin Carver'] = 12102777,
        ['Snow Shovel'] = 12102779,
        ['Disco ball'] = 12102781,
        ['Camera'] = 12102783,
        ['Lightbulb'] = 12102785,
        ['Skullbang'] = 12102787,
        ['Shining Star'] = 12102789,
        ['Pixel Flashbang'] = 12102791,
        ['Trampoline'] = 12102793,
        ['Bounce House'] = 12102795,
        ['Shady Chicken Sandwich'] = 12102797,
        ['Sandwich'] = 12102799,
        ['Laptop'] = 12102801,
        ['Medkitty'] = 12102803,
        ['Bucket of Candy'] = 12102805,
        ['Milk & Cookies'] = 12102807,
        ['Briefcase'] = 12102809,
        ['Coffee'] = 12102811,
        ['Torch'] = 12102813,
        ['Lava Lamp'] = 12102815,
        ['Vexed Candle'] = 12102817,
        ['Hot Coals'] = 12102819,
        ['Advanced Satchel'] = 12102821,
        ['Notebook Satchel'] = 12102823,
        ["Bag O' Money"] = 12102825,
        ['Suspicious Gift'] = 12102827,
        ['Emoji Cloud'] = 12102829,
        ['Balance'] = 12102831,
        ['Hourglass'] = 12102833,
        ['Eyeball'] = 12102835,
        ['Snowglobe'] = 12102837,
        ['Trumpet'] = 12102839,
        ['Megaphone'] = 12102841,
        ['Air Horn'] = 12102843,
        ['Mammoth Horn'] = 12102845,
    }
    return skinMap[skinName]
end

function SkinModule.new(config)
    local self = {}
    local settings = config.WeaponSkinSettings or {}
    
    local function findWeaponContainer()
        local ps = LocalPlayer:WaitForChild("PlayerScripts")
        local assets = ps:FindFirstChild("Assets")
        if not assets then return nil end
        local vm = assets:FindFirstChild("ViewModels")
        if not vm then return nil end
        return vm
    end
    
    local function applySkinToModel(model, skinName)
        local assetId = getAssetId(skinName)
        if not assetId then return end
        
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA("Accessory") or child:IsA("Tool") then
                local handle = child:FindFirstChild("Handle")
                if handle then
                    for _, part in ipairs(handle:GetChildren()) do
                        if part:IsA("Texture") or part:IsA("Decal") then
                            local ok, res = pcall(function()
                                local id = "rbxassetid://" .. assetId
                                if part:IsA("Texture") then
                                    part.Texture = id
                                else
                                    part.Texture = id
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
    
    local function applyWeaponSkin(weaponName, skinName)
        local vm = findWeaponContainer()
        if not vm then return end
        
        local weapons = vm:FindFirstChild("Weapons")
        if not weapons then return end
        
        local weapon = weapons:FindFirstChild(weaponName)
        if not weapon then return end
        
        local skinId = getAssetId(skinName)
        if not skinId then return end
        
        pcall(function()
            for _, child in ipairs(weapon:GetDescendants()) do
                if child:IsA("Texture") or child:IsA("Decal") then
                    child.Texture = "rbxassetid://" .. skinId
                end
            end
        end)
    end
    
    function self:applySkin(weaponName, skinName)
        settings[weaponName] = skinName
        applyWeaponSkin(weaponName, skinName)
    end
    
    function self:swapAll()
        for weapon, skin in pairs(settings) do
            applyWeaponSkin(weapon, skin)
        end
    end
    
    function self:setSkin(weapon, skin)
        settings[weapon] = skin
    end
    
    function self:getSettings()
        return settings
    end
    
    function self:clearSkin(weaponName)
        settings[weaponName] = nil
    end
    
    return self
end

return SkinModule