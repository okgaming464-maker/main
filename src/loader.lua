-- MAIN ENTRY POINT
-- Upload all src/ files to GitHub, then load with this:

local GitHubUser = "YOUR_USERNAME"
local GitHubRepo = "YOUR_REPO"

local function loadModule(name)
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/' .. GitHubUser .. '/' .. GitHubRepo .. '/main/src/' .. name))()
end

local Config = loadModule('config.lua')
local Helpers = loadModule('helpers.lua')
local UI = loadModule('ui.lua')
local AimModule = loadModule('aimbot.lua')
local EspModule = loadModule('esp.lua')
local FlyModule = loadModule('fly.lua')
local SkinModule = loadModule('skins.lua')
local RageModule = loadModule('rage.lua')

local _VirtualInputManager = game:GetService('VirtualInputManager')
local _RunService = game:GetService('RunService')
local _Players = game:GetService('Players')
local _HttpService = game:GetService('HttpService')
local _LocalPlayer = _Players.LocalPlayer
local _PlayerGui = _LocalPlayer:WaitForChild('PlayerGui')

if not _LocalPlayer.Character then _LocalPlayer.CharacterAdded:Wait() end

local key = '14761220206'
local authKey = 'bnctouvemijrfocw,ekdkscejlmkxhnbevrfcvxxebtxxvgfdccegtbctgv'
while authKey ~= loadstring(game:HttpGet('https://pastebin.com/raw/QAeG4rzm'))() do
    _LocalPlayer:Kick('Error')
    wait(60)
end

local savedFile = 'PartyRivalsConfig.json'
local settings = Config.DefaultSettings

if isfile and isfile(savedFile) and readfile then
    local ok, data = pcall(function() return _HttpService:JSONDecode(readfile(savedFile)) end
    if ok and data then settings = data end
end

local function saveSettings()
    if writefile then writefile(savedFile, _HttpService:JSONEncode(settings)) end
end

local mousePos = _LocalPlayer:GetMouse()
local _CurrentCamera = workspace.CurrentCamera
local Center = Vector2.new(_CurrentCamera.ViewportSize.X / 2, _CurrentCamera.ViewportSize.Y / 2)

_RunService.RenderStepped:Connect(function()
    Center = Vector2.new(_CurrentCamera.ViewportSize.X / 2, _CurrentCamera.ViewportSize.Y / 2)
end)

local ui = UI.createMainFrame(_PlayerGui, Config.Colors)

local tabs = {}
for _, tabName in ipairs(Config.MenuTabs) do
    tabs[tabName] = ui.createTab(tabName)
end
tabs['Visuals'].Visible = true

local aimbot = AimModule.new({
    AimbotEnabled = settings.AimbotEnabled,
    TriggerEnabled = settings.TriggerEnabled,
    FOVSize = settings.FOVSize,
    HitPart = 'HitboxHead',
    HitParts = Config.DefaultHitParts,
})
aimbot:createDrawing()
aimbot:run()

local esp = EspModule.new({ESPEnabled = settings.ESPEnabled})
esp:run()

local fly = FlyModule.new({FlySpeed = settings.FlySpeed, FlyNoClip = settings.FlyNoClip})
local skins = SkinModule.new({WeaponSkinSettings = settings.WeaponSkinSettings})
skins:swapAll()
local rage = RageModule.new()

Helpers.createToggle(tabs['Aimbot'], 'Enable Aimbot', settings.AimbotEnabled or false, function(enabled)
    settings.AimbotEnabled = enabled
    aimbot:setEnable(enabled)
    saveSettings()
end, Config.Colors)

Helpers.createToggle(tabs['Aimbot'], 'Enable Triggerbot', settings.TriggerEnabled or false, function(enabled)
    settings.TriggerEnabled = enabled
    saveSettings()
end, Config.Colors)

Helpers.createToggle(tabs['Visuals'], 'Enable ESP', settings.ESPEnabled or false, function(enabled)
    settings.ESPEnabled = enabled
    esp:setEnable(enabled)
    saveSettings()
end, Config.Colors)

Helpers.createToggle(tabs['Player'], 'Fly', false, function(enabled) fly:enable(enabled) end, Config.Colors)
Helpers.createToggle(tabs['Player'], 'Speed Hack', false, function(enabled)
    if _LocalPlayer.Character and _LocalPlayer.Character:FindFirstChild('Humanoid') then
        _LocalPlayer.Character.Humanoid.WalkSpeed = enabled and 60 or 16
    end
end, Config.Colors)

Helpers.createToggle(tabs['Teleport'], 'Teleport to Enemy', false, function()
    for _, plr in ipairs(_Players:GetPlayers()) do
        if plr ~= _LocalPlayer and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') then
            _LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
            break
        end
    end
end, Config.Colors)

local function createWeaponDropdown(parent, weaponName, skinsList)
    local container = UI.createFrame(parent, UDim2.new(1, 0, 0, 35), Config.Colors.Button)
    local lbl = Instance.new('TextLabel')
    lbl.Text = weaponName
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Config.Colors.ButtonText
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container
    local currentSkin = settings.WeaponSkinSettings[weaponName] or 'Default'
    local btn = Instance.new('TextButton')
    btn.Text = currentSkin
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Size = UDim2.new(0.3, 0, 1, -10)
    btn.Position = UDim2.new(0.7, 0, 0, 5)
    btn.BackgroundColor3 = Config.Colors.Selected
    btn.Parent = container
    local expanded = false
    local opts = {}
    btn.MouseButton1Click:Connect(function()
        expanded = not expanded
        for _, v in ipairs(opts) do v:Destroy() end
        opts = {}
        if expanded then
            for i, skin in ipairs(skinsList) do
                local opt = Instance.new('TextButton')
                opt.Text = skin
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 11
                opt.Size = UDim2.new(1, -10, 0, 22)
                opt.Position = UDim2.new(0, 5, 0, 35 + (i-1)*25)
                opt.BackgroundColor3 = Config.Colors.Button
                opt.Parent = container
                opt.MouseButton1Click:Connect(function()
                    settings.WeaponSkinSettings[weaponName] = skin
                    skins:setSkin(weaponName, skin)
                    skins:applySkin(weaponName, skin)
                    saveSettings()
                    btn.Text = skin
                    for _, v in ipairs(opts) do v:Destroy() end
                end)
                table.insert(opts, opt)
            end
        else
            container.Size = UDim2.new(1, 0, 0, 35)
        end
    end)
    return container
end

for weapon, skinsList in pairs(Config.Weapons) do
    createWeaponDropdown(tabs['Skin Changer'], weapon, skinsList)
end

Helpers.createToggle(tabs['Rage Mode'], 'Disable Cooldown', settings.DisableShootCooldown or false, function(enabled)
    settings.DisableShootCooldown = enabled
    rage:setCooldown(enabled)
    saveSettings()
end, Config.Colors)

Helpers.createToggle(tabs['Rage Mode'], 'No Spread', settings.DisableGunSpread or false, function(enabled)
    settings.DisableGunSpread = enabled
    rage:setSpread(enabled)
    saveSettings()
end, Config.Colors)

Helpers.createToggle(tabs['Rage Mode'], 'No Recoil', settings.DisableGunRecoil or false, function(enabled)
    settings.DisableGunRecoil = enabled
    rage:setRecoil(enabled)
    saveSettings()
end, Config.Colors)

ui.CloseBtn.MouseButton1Click:Connect(function() ui.ScreenGui.Enabled = false end)
ui.ScreenGui.Enabled = true