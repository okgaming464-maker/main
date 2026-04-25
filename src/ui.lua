-- Rivals Aimbot UI - LinoriaLib based
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Rivals',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Legit = Window:AddTab('Legit'),
    Semi = Window:AddTab('Semi'),
    Blatant = Window:AddTab('Blatant'),
    Rage = Window:AddTab('Rage'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Extra = Window:AddTab('Extra'),
    Settings = Window:AddTab('Settings'),
}

-- ===== LEGIT TAB =====

Tabs.Legit:AddLeftGroupbox('Aimbot'):AddToggle('LegitAimbot', {
    Text = 'Enable Aimbot',
    Default = false,
})

Tabs.Legit:AddRightGroupbox('Settings'):AddSlider('LegitFOV', {
    Text = 'FOV',
    Default = 100,
    Min = 50,
    Max = 300,
    Rounding = 0,
})

Tabs.Legit:AddRightGroupbox('Settings'):AddSlider('LegitSmooth', {
    Text = 'Smoothness',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
})

-- ===== SEMI TAB =====

Tabs.Semi:AddLeftGroupbox('Aimbot'):AddToggle('SemiAimbot', {
    Text = 'Enable Aimbot',
    Default = false,
})

Tabs.Semi:AddLeftGroupbox('Aimbot'):AddToggle('SilentAim', {
    Text = 'Silent Aim',
    Default = false,
})

Tabs.Semi:AddLeftGroupbox('Aimbot'):AddSlider('SemiFOV', {
    Text = 'FOV',
    Default = 150,
    Min = 50,
    Max = 500,
    Rounding = 0,
})

Tabs.Semi:AddRightGroupbox('Trigger'):AddToggle('Triggerbot', {
    Text = 'Triggerbot',
    Default = false,
})

Tabs.Semi:AddRightGroupbox('Trigger'):AddSlider('TriggerDelay', {
    Text = 'Delay',
    Default = 0.1,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

Tabs.Semi:AddRightGroupbox('Trigger'):AddKeyPicker('TriggerKey', {
    Default = 'MouseButton2',
    Text = 'Key',
})

-- ===== BLATANT TAB =====

Tabs.Blatant:AddLeftGroupbox('Movement'):AddToggle('Fly', {
    Text = 'Fly',
    Default = false,
})

Tabs.Blatant:AddLeftGroupbox('Movement'):AddToggle('NoClip', {
    Text = 'No Clip',
    Default = false,
})

Tabs.Blatant:AddLeftGroupbox('Movement'):AddSlider('FlySpeed', {
    Text = 'Speed',
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 0,
})

Tabs.Blatant:AddRightGroupbox('Teleport'):AddToggle('TeleportBehind', {
    Text = 'Behind Target',
    Default = false,
})

Tabs.Blatant:AddRightGroupbox('Teleport'):AddButton('To Enemy', function()
    -- function
end)

Tabs.Blatant:AddRightGroupbox('Teleport'):AddToggle('SpinBot', {
    Text = 'Spin Bot',
    Default = false,
})

Tabs.Blatant:AddRightGroupbox('Teleport'):AddSlider('SpinSpeed', {
    Text = 'Speed',
    Default = 25,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

-- ===== RAGE TAB =====

Tabs.Rage:AddLeftGroupbox('AntiAim'):AddToggle('AntiAim', {
    Text = 'Enable',
    Default = false,
})

Tabs.Rage:AddLeftGroupbox('AntiAim'):AddDropdown('AAMode', {
    Values = {'spin', 'jitter', 'fake', 'sidespin', 'edge', 'reverse', 'zero'},
    Default = 1,
    Text = 'Mode',
})

Tabs.Rage:AddLeftGroupbox('AntiAim'):AddDropdown('AAPitch', {
    Values = {'down', 'up', 'zero', 'jitter'},
    Default = 1,
    Text = 'Pitch',
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('Desync', {
    Text = 'Desync',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddDropdown('DesyncMode', {
    Values = {'peek', 'fake', 'jitter', 'fakewalk'},
    Default = 1,
    Text = 'Mode',
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('DoubleTap', {
    Text = 'Double Tap',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('Resolver', {
    Text = 'Resolver',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('Reach', {
    Text = 'Reach',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddSlider('ReachValue', {
    Text = 'Value',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('NoRecoil', {
    Text = 'No Recoil',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('NoSpread', {
    Text = 'No Spread',
    Default = false,
})

Tabs.Rage:AddRightGroupbox('Exploits'):AddToggle('NoCooldown', {
    Text = 'No Cooldown',
    Default = false,
})

-- ===== VISUALS TAB =====

local ESP = Tabs.Visuals:AddLeftGroupbox('ESP')
ESP:AddToggle('Box', { Text = 'Box', Default = false })
ESP:AddToggle('Chams', { Text = 'Chams', Default = false })
ESP:AddToggle('Name', { Text = 'Name', Default = false })
ESP:AddToggle('Distance', { Text = 'Distance', Default = false })
ESP:AddToggle('Health', { Text = 'Health', Default = false })
ESP:AddToggle('Tracers', { Text = 'Tracers', Default = false })
ESP:AddToggle('Skull', { Text = 'Skull', Default = false })
ESP:AddToggle('TeamCheck', { Text = 'Team Check', Default = true })

local World = Tabs.Visuals:AddRightGroupbox('World')
World:AddToggle('Fog', { Text = 'Fog', Default = false })
World:AddColorPicker('FogColor', { Default = Color3.new(0.7, 0.7, 0.7), Text = 'Color' })
World:AddSlider('FogDensity', { Text = 'Density', Default = 0.5, Min = 0, Max = 1, Rounding = 2 })

local Crosshair = Tabs.Visuals:AddRightGroupbox('Crosshair')
Crosshair:AddToggle('Enable', { Text = 'Enable', Default = false })
Crosshair:AddDropdown('Style', { Values = {'cross', 'dot', 'circle', 't', 'plus', 'gap', 'star', 'heart', 'skull'}, Default = 1, Text = 'Style' })
Crosshair:AddSlider('Size', { Text = 'Size', Default = 10, Min = 5, Max = 50, Rounding = 0 })

local Radar = Tabs.Visuals:AddLeftGroupbox('Radar')
Radar:AddToggle('Enable', { Text = 'Enable', Default = false })
Radar:AddSlider('Range', { Text = 'Range', Default = 100, Min = 50, Max = 500, Rounding = 0 })

local Watermark = Tabs.Visuals:AddRightGroupbox('Watermark')
Watermark:AddToggle('Enable', { Text = 'Enable', Default = false })
Watermark:AddToggle('FPS', { Text = 'FPS', Default = true })
Watermark:AddToggle('Ping', { Text = 'Ping', Default = true })

-- ===== MOVEMENT TAB =====

Tabs.Movement:AddLeftGroupbox('BHop'):AddToggle('Enable', { Text = 'BHop', Default = false })
Tabs.Movement:AddLeftGroupbox('BHop'):AddSlider('Speed', { Text = 'Speed', Default = 16, Min = 10, Max = 50, Rounding = 0 })
Tabs.Movement:AddLeftGroupbox('BHop'):AddToggle('AutoStrafe', { Text = 'Auto Strafe', Default = false })

Tabs.Movement:AddRightGroupbox('Speed'):AddToggle('SpeedHack', { Text = 'Speed Hack', Default = false })
Tabs.Movement:AddRightGroupbox('Speed'):AddSlider('SpeedValue', { Text = 'Value', Default = 60, Min = 16, Max = 150, Rounding = 0 })
Tabs.Movement:AddRightGroupbox('Speed'):AddToggle('InfiniteJump', { Text = 'Infinite Jump', Default = false })
Tabs.Movement:AddRightGroupbox('Speed'):AddToggle('NoSlow', { Text = 'No Slow', Default = false })
Tabs.Movement:AddRightGroupbox('Speed'):AddToggle('NoFall', { Text = 'No Fall Dmg', Default = false })

-- ===== EXTRA TAB =====

Tabs.Extra:AddLeftGroupbox('Stats'):AddToggle('HitNotify', { Text = 'Hit Notify', Default = false })
Tabs.Extra:AddLeftGroupbox('Stats'):AddToggle('KillFeed', { Text = 'Kill Feed', Default = false })
Tabs.Extra:AddLeftGroupbox('Stats'):AddToggle('DamageESP', { Text = 'Damage', Default = false })
Tabs.Extra:AddLeftGroupbox('Stats'):AddToggle('BulletTracer', { Text = 'Bullet', Default = false })

Tabs.Extra:AddRightGroupbox('Extras'):AddToggle('GodMode', { Text = 'God Mode', Default = false })
Tabs.Extra:AddRightGroupbox('Extras'):AddToggle('InfAmmo', { Text = 'Inf Ammo', Default = false })
Tabs.Extra:AddRightGroupbox('Extras'):AddToggle('AutoReload', { Text = 'Auto Reload', Default = false })
Tabs.Extra:AddRightGroupbox('Extras'):AddToggle('AutoPickup', { Text = 'Auto Pickup', Default = false })
Tabs.Extra:AddRightGroupbox('Extras'):AddToggle('AntiAFK', { Text = 'Anti-AFK', Default = false })

Tabs.Extra:AddRightGroupbox('Effects'):AddToggle('NoFlash', { Text = 'No Flash', Default = false })
Tabs.Extra:AddRightGroupbox('Effects'):AddToggle('NoSmoke', { Text = 'No Smoke', Default = false })
Tabs.Extra:AddRightGroupbox('Effects'):AddToggle('NoPaint', { Text = 'No Paint', Default = false })

-- ===== SETTINGS TAB =====

Tabs.Settings:AddLeftGroupbox('Camera'):AddSlider('FOV', { Text = 'FOV', Default = 70, Min = 30, Max = 120, Rounding = 0 })

Tabs.Settings:AddLeftGroupbox('SkinChanger'):AddButton('Open', function() end)

Tabs.Settings:AddLeftGroupbox('Config'):AddButton('Save', function() SaveManager:Save() end)
Tabs.Settings:AddLeftGroupbox('Config'):AddButton('Load', function() SaveManager:Load() end)

local MenuGroup = Tabs.Settings:AddRightGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Keybind'):AddKeyPicker('Keybind', { Default = 'End', Text = 'Menu', NoUI = true })

Library.ToggleKeybind = Options.Keybind

-- Addons Setup
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'Keybind' })
ThemeManager:SetFolder('Rivals')
SaveManager:SetFolder('Rivals')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- Watermark
Library:SetWatermarkVisibility(true)
Library:SetWatermark('Rivals')

-- Unload
Library:OnUnload(function()
    Library.Unloaded = true
end)

return { Library = Library, Tabs = Tabs, Options = Options, Toggles = Toggles }