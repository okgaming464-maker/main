local function trackConn(conn) return conn end

shared.Lucent = {
    ["Global"] = {
        ["Mod Detector"] = false,
        ["Key"] = "keyhere"
    },
    ["Binds"] = {
        ["Select"]        = "C",   -- keybind to select/deselect target (Select mode only)
        ["Camera Aimbot"] = "C",   -- keybind for camera aimbot (Toggle/Hold mode)
        ["Triggerbot"]    = "T",   -- keybind for triggerbot (Toggle/Hold mode)
        ["Speed"]         = "V",   -- keybind to toggle speed modifications
        ["ESP"]           = "P",   -- keybind to toggle ESP
        ["Super Jump"]    = "Z",   -- keybind to toggle super jump
    },
    ["Select Only Features"] = {
        ["Force Hit"]     = false, -- always aim at head regardless of hitpart
        ["Force Trigger"] = false  -- triggerbot fires regardless of FOV
    },
    ["Targeting"] = {
        ["Target Mode"] = "Automatic" -- "Automatic" (closest to you) | "Select" (press keybind to lock)
    },
    ["Checks"] = {
        ["Visible Check"]    = true,  -- only target players you can see
        ["Knock Check"]      = true,  -- skip knocked players
        ["Crew Check"]       = true,  -- skip crewmates
        ["Self Knock Check"] = true,  -- stop aimbot when you're knocked
        ["Forcefield Check"] = true   -- skip players with forcefield
    },
    ["Silent Aimbot"] = {
        ["Enabled"] = true,
        ["HitPart"] = "Closest Point", -- "Closest Point" | "Closest Part" | "Nearest Point" | "Head" | "UpperTorso"
        ["Closest Point"] = {
            ["Mode"]    = "Advanced",  -- "Basic" | "Advanced"
            ["Scale"]   = 0.12,        -- how far in from part edge (0 = edge, 1 = center)
            ["Density"] = 3            -- grid resolution (higher = more accurate, more CPU)
        },
        ["Prediction"] = { ["X"] = 0, ["Y"] = 0, ["Z"] = 0 }, -- written by Ping Prediction automatically
        ["Client Bullet Redirection"] = {
            ["Enabled"] = false,
            ["Prediction"] = { ["X"] = 0, ["Y"] = 0, ["Z"] = 0 },
            ["Weapons"] = {}
        },
        ["Bullet Projection"] = {
            ["Enabled"]  = false,      -- projects aim point forward along bullet travel direction
            ["Distance"] = 2.0         -- studs to project forward (helps with fast-moving targets)
        },
        ["Clamp Y"] = {
            ["Enabled"]       = true,  -- prevents bullets going underground
            ["Dynamic"]       = true,  -- adjusts clamp based on target velocity
            ["Value"]         = 0.5,   -- static clamp offset (used when Dynamic = false)
            ["Smooth"]        = true,  -- smooth the correction instead of snapping
            ["Smooth Factor"] = 0.60
        },
        ["Distance Check"] = { ["Enabled"] = true, ["Max Distance"] = 350 },
        ["FOV"] = {
            ["Show FOV"] = false,
            ["X Left"]  = 3, ["X Right"]  = 3,
            ["Y Upper"] = 2, ["Y Lower"]  = 2,
            ["Z Left"]  = 2, ["Z Right"]  = 2
        },
        ["Weapon Configuration"] = { ["Enabled"] = false }
    },
    ["Anti Curve"] = {
        ["Enabled"] = false,
        ["Angle"]   = 0.9,
        ["Weapon Configuration"] = {
            ["Enabled"]    = true,
            ["Shotguns"]   = { ["Angle"] = 1.5 },
            ["Pistols"]    = { ["Angle"] = 1.0 },
            ["Automatics"] = { ["Angle"] = 1.2 },
            ["Rifles"]     = { ["Angle"] = 0.8 },
            ["Others"]     = { ["Angle"] = 0.9 }
        }
    },
    ["Camera Aimbot"] = {
        ["Enabled"] = false,
        ["Mode"]    = "Always",        -- "Always" | "Toggle" | "Hold"
        ["HitPart"] = "Closest Point",          -- "Head" | "UpperTorso" | "Closest Point" | "Closest Part"
        ["Closest Point"] = { ["Mode"] = "Advanced", ["Scale"] = 0.09, ["Density"] = 4 },
        ["Smoothing"] = { ["X"] = 0.699, ["Y"] = 0.699 },
        ["Range Smoothing"] = {
            ["Enabled"] = true,
            ["Close"]   = { ["X"] = 0.635, ["Y"] = 0.669 }, -- <= 30 studs
            ["Medium"]  = { ["X"] = 0.645, ["Y"] = 0.689 }, -- <= 80 studs
            ["Far"]     = { ["X"] = 0.699, ["Y"] = 0.699 }  -- > 80 studs
        },
        ["Humanize"]  = { ["Bezier"] = false, ["Enabled"] = false, ["Scale"] = 0.25 },
        ["Prediction"] = { ["X"] = 0, ["Y"] = 0, ["Z"] = 0 },
        ["Camera Aimbot Conditions"] = {
            ["First Person"] = true,   -- active in first person
            ["Third Person"] = true,   -- active in third person / shift lock
        },
        ["FOV"] = {
            ["Show FOV"] = false,
            ["Radius"]   = "80",
            ["X Left"]  = 1, ["X Right"]  = 1,
            ["Y Upper"] = 1, ["Y Lower"]  = 1,
            ["Z Left"]  = 1, ["Z Right"]  = 1
        }
    },
    ["Trigger Bot"] = {
        ["Enabled"] = true,
        ["Settings"] = {
            ["Mode"] = "Toggle",         -- "Always" | "Toggle" | "Hold"
            ["Type"] = "FOV"           -- "FOV" | "Hitbox"
        },
        ["Delay Settings"] = {
            ["Delay Toggle"] = true,
            ["Delay"] = 0.06,
            ["Weapon Configuration"] = {
                ["Enabled"]    = true,
                ["Shotguns"]   = { ["Delay"] = 0.09 },
                ["Pistols"]    = { ["Delay"] = 0.05 },
                ["Automatics"] = { ["Delay"] = 0.03 },
                ["Rifles"]     = { ["Delay"] = 0.05 },
                ["Others"]     = { ["Delay"] = 0.06 }
            }
        },
        ["Prediction"] = { ["X"] = 0, ["Y"] = 0, ["Z"] = 0 },
        ["Distance Check"] = { ["Enabled"] = true, ["Max Distance"] = 350 },
        ["FOV"] = {
            ["Show FOV"] = false,
            ["Size"] = {
                ["X Left"]  = 5, ["X Right"]  = 5,
                ["Y Upper"] = 3, ["Y Lower"]  = 3,
                ["Z Left"]  = 2, ["Z Right"]  = 2
            },
            ["Weapon Configuration"] = { ["Enabled"] = false }
        }
    },
    ["Rapid Fire"] = {
        ["Enabled"] = false,
        ["Delay"]   = 0,     -- seconds between shots (0 = as fast as possible)
        ["Weapons"] = {}     -- empty = all weapons, list names to restrict
    },
    ["Ping Prediction"] = {
        ["Enabled"]   = false,
        ["Y Scale"]   = 0.42, -- vertical prediction scale (lower = less Y lead)
        ["Smoothing"] = 0.09  -- lerp speed for prediction values
    },
    ["Spread Modifications"] = {
        ["Enabled"] = false,
        ["Mode"]    = "Fixed", -- "Fixed" (always same) | "Randomized" (between min/max)
        ["Double-Barrel SG"] = { ["Fixed"] = 0, ["Min"] = 0, ["Max"] = 0 },
        ["TacticalShotgun"]  = { ["Fixed"] = 0, ["Min"] = 0, ["Max"] = 0 },
        ["Shotgun"]          = { ["Fixed"] = 0, ["Min"] = 0, ["Max"] = 0 },
        ["DrumShotgun"]      = { ["Fixed"] = 0, ["Min"] = 0, ["Max"] = 0 },
    },
    ["Speed Modifications"] = {
        ["Enabled"] = false,
        ["Normal"]     = { ["Multiplier"] = 35 },
        ["Low Health"] = { ["Health Threshold"] = 35, ["Multiplier"] = 35 }
    },
    ["Hitbox Expander"] = {
        ["Enabled"] = false,
        ["Size"] = 8,
    },
    ["Super Jump"] = {
        ["Enabled"] = false,
        ["Jump Power"] = 300,
    },
    ["ESP"] = {
        ["Enabled"]           = true,
        ["Show Display Name"] = true,
        ["Show Username"]     = false,
        ["Name Above"]        = false,  -- true = above head, false = below feet
        ["Font Size"]         = 13,
        ["Color"]             = Color3.fromRGB(135, 206, 235),
        ["Target Color"]      = Color3.fromRGB(255, 255, 255),
        ["Username Color"]    = Color3.fromRGB(180, 180, 180),
        ["Target Line"] = {
            ["Enabled"]      = false,
            ["Thickness"]    = 1.0,
            ["Color"]        = Color3.fromRGB(255, 255, 255),
            ["Transparency"] = 1.0,
            ["Origin"]       = "Mouse", -- "Bottom" | "Center" | "Mouse"
        },
    },
    ["Skins"] = {
        ["Enabled"] = false,
        ["Weapons"] = {
            ["[Double-Barrel SG]"] = "Golden Age",
            ["[Revolver]"] = "Golden Age",
            ["[TacticalShotgun]"] = "Patriot",
            ["[Knife]"] = "GPO-Knife Prestige",
        },
    },
}


getgenv().Lucent = shared.Lucent
getgenv().lucent = shared.Lucent

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local mouse = localPlayer:GetMouse()

-- Skin Changer Data
local knifeData = {}
local toolRegistry = {}

local knifeSkins = {
    ["Golden Age Tanto"] = {soundid = "rbxassetid://5917819099", animationid = "rbxassetid://13473404819", positionoffset = Vector3.new(0, -0.20, -1.2), rotationoffset = Vector3.new(90, 263.7, 180)},
    ["GPO-Knife"] = {soundid = "rbxassetid://4604390759", animationid = "rbxassetid://14014278925", positionoffset = Vector3.new(0.00, -0.32, -1.07), rotationoffset = Vector3.new(90, -97.4, 90)},
    ["GPO-Knife Prestige"] = {soundid = "rbxassetid://4604390759", animationid = "rbxassetid://14014278925", positionoffset = Vector3.new(0.00, -0.32, -1.07), rotationoffset = Vector3.new(90, -97.4, 90)},
    ["Heaven"] = {soundid = "rbxassetid://14489860007", animationid = "rbxassetid://14500266726", positionoffset = Vector3.new(-0.02, -0.82, 0.20), rotationoffset = Vector3.new(64.42, 3.79, 0.00)},
    ["Love Kukri"] = {soundid = "", animationid = "", positionoffset = Vector3.new(-0.14, 0.14, -1.62), rotationoffset = Vector3.new(-90.00, 180.00, -4.97), particle = true, textureid = "rbxassetid://12124159284"},
    ["Purple Dagger"] = {soundid = "rbxassetid://17822743153", animationid = "rbxassetid://17824999722", positionoffset = Vector3.new(-0.13, -0.24, -1.80), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Blue Dagger"] = {soundid = "rbxassetid://17822737046", animationid = "rbxassetid://17824995184", positionoffset = Vector3.new(-0.13, -0.24, -1.80), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Green Dagger"] = {soundid = "rbxassetid://17822741762", animationid = "rbxassetid://17825004320", positionoffset = Vector3.new(-0.13, -0.24, -1.07), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Red Dagger"] = {soundid = "rbxassetid://17822952417", animationid = "rbxassetid://17825008844", positionoffset = Vector3.new(-0.13, -0.24, -1.07), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Portal"] = {soundid = "rbxassetid://16058846352", animationid = "rbxassetid://16058633881", positionoffset = Vector3.new(-0.13, -0.35, -0.57), rotationoffset = Vector3.new(89.05, 96.63, 180.00)},
    ["Emerald Butterfly"] = {soundid = "rbxassetid://14931902491", animationid = "rbxassetid://14918231706", positionoffset = Vector3.new(-0.02, -0.30, -0.65), rotationoffset = Vector3.new(180.00, 90.95, 180.00)},
    ["Boy"] = {soundid = "rbxassetid://18765078331", animationid = "rbxassetid://18789158908", positionoffset = Vector3.new(-0.02, -0.09, -0.73), rotationoffset = Vector3.new(89.05, -88.11, 180.00)},
    ["Girl"] = {soundid = "rbxassetid://18765078331", animationid = "rbxassetid://18789162944", positionoffset = Vector3.new(-0.02, -0.16, -0.73), rotationoffset = Vector3.new(89.05, -88.11, 180.00)},
    ["Dragon"] = {soundid = "rbxassetid://14217789230", animationid = "rbxassetid://14217804400", positionoffset = Vector3.new(-0.02, -0.32, -0.98), rotationoffset = Vector3.new(89.05, 90.95, 180.00)},
    ["Void"] = {soundid = "rbxassetid://14756591763", animationid = "rbxassetid://14774699952", positionoffset = Vector3.new(-0.02, -0.22, -0.85), rotationoffset = Vector3.new(180.00, 90.95, 180.00)},
    ["Wild West"] = {soundid = "rbxassetid://16058689026", animationid = "rbxassetid://16058148839", positionoffset = Vector3.new(-0.02, -0.24, -1.15), rotationoffset = Vector3.new(-91.89, 90.95, 180.00)},
    ["Iced Out"] = {soundid = "rbxassetid://14924261405", animationid = "rbxassetid://18465353361", positionoffset = Vector3.new(0.02, -0.08, 0.99), rotationoffset = Vector3.new(180.00, -90.95, -180.00)},
    ["Reptile"] = {soundid = "rbxassetid://18765103349", animationid = "rbxassetid://18788955930", positionoffset = Vector3.new(-0.03, -0.06, -0.92), rotationoffset = Vector3.new(168.63, 90.00, -180.00)},
    ["Emerald"] = {soundid = "", animationid = "", positionoffset = Vector3.new(-0.03, -0.06, -0.92), rotationoffset = Vector3.new(168.63, 90.00, 108.00)},
    ["Ribbon"] = {soundid = "rbxassetid://130974579277249", animationid = "rbxassetid://124102609796063", positionoffset = Vector3.new(0.02, -0.25, -0.05), rotationoffset = Vector3.new(90.00, 0.00, 180.00)},
}

local function clearMesh(tool, exclude)
    local children = tool:GetChildren()
    for i = 1, #children do
        local v = children[i]
        if v:IsA("MeshPart") and v ~= exclude then
            v:Destroy()
        end
    end
end

local function applyGun(tool, name)
    local orig = tool:FindFirstChildOfClass("MeshPart")
    if not orig then return end

    local skinmodules = ReplicatedStorage:FindFirstChild("SkinModules")
    if not skinmodules then return end

    local ok, skinmodulesreq = pcall(function()
        return require(skinmodules)
    end)
    if not ok or not skinmodulesreq then return end

    local info = skinmodulesreq[tool.Name] and skinmodulesreq[tool.Name][name]
    if not info then return end

    clearMesh(tool, orig)

    local skinpart = info.TextureID
    if typeof(skinpart) == "Instance" then
        local clone = skinpart:Clone()
        clone.Parent = tool
        clone.CFrame = orig.CFrame
        clone.Name = "CurrentSkin"

        local w = Instance.new("Weld")
        w.Part0 = clone
        w.Part1 = orig
        w.C0 = info.CFrame:Inverse()
        w.Parent = clone

        orig.Transparency = 1
    else
        orig.TextureID = skinpart
        orig.Transparency = 0
    end

    local handle = tool:FindFirstChild("Handle")
    if not handle then return end

    local shoot = handle:FindFirstChild("ShootSound")
    if shoot then
        local skinassets = ReplicatedStorage:FindFirstChild("SkinAssets")
        if skinassets then
            local gunsounds = skinassets:FindFirstChild("GunShootSounds")
            if gunsounds then
                local sounds = gunsounds:FindFirstChild(tool.Name)
                local obj = sounds and sounds:FindFirstChild(name)
                if obj then
                    shoot.SoundId = obj.Value
                end
            end
        end
    end

    local skinassets = ReplicatedStorage:FindFirstChild("SkinAssets")
    if skinassets then
        local particlefolder = skinassets:FindFirstChild("GunHandleParticle")
        if particlefolder then
            local particlesource = particlefolder:FindFirstChild(name)
            if particlesource then
                local pe = particlesource:FindFirstChild("ParticleEmitter")
                if pe then
                    for _, existing in ipairs(handle:GetChildren()) do
                        if existing:IsA("ParticleEmitter") then
                            existing:Destroy()
                        end
                    end
                    pe:Clone().Parent = handle
                end
            end
        end
    end

    handle:SetAttribute("SkinName", name)
end

local function cleanKnife(tool)
    local data = knifeData[tool]
    if data then
        if data.track then
            data.track:Stop()
            data.track:Destroy()
            data.track = nil
        end
        if data.welds then
            for _, w in ipairs(data.welds) do
                if w then w:Destroy() end
            end
        end
        if data.sounds then
            for _, s in ipairs(data.sounds) do
                if s and s.Parent then s:Destroy() end
            end
        end
    end

    local mesh = tool:FindFirstChild("Default")
    if mesh then
        local children = mesh:GetChildren()
        for i = 1, #children do
            local v = children[i]
            if v.Name == "Handle.R" or v:IsA("Model") or (v:IsA("BasePart") and v.Name ~= "Default") then
                v:Destroy()
            end
        end
        mesh.Transparency = 0
    end

    knifeData[tool] = nil
end

local function applyKnife(char, tool, skin)
    local skincfg = knifeSkins[skin]
    if not skincfg then return end

    local hum = char:FindFirstChild("Humanoid")
    local rhand = char:FindFirstChild("RightHand")
    if not hum or not rhand then return end

    cleanKnife(tool)
    knifeData[tool] = {track = nil, welds = {}, sounds = {}}
    local data = knifeData[tool]

    local mesh = tool:FindFirstChild("Default")
    if not mesh then return end
    mesh.Transparency = 1

    local skinmodules = ReplicatedStorage:FindFirstChild("SkinModules")
    if not skinmodules then return end
    local knives = skinmodules:FindFirstChild("Knives")
    if not knives then return end

    local skinmodel = knives:FindFirstChild(skin)
    if not skinmodel then return end
    local clone = skinmodel:Clone()
    clone.Name = skin

    local handr = Instance.new("Part")
    handr.Name = "Handle.R"
    handr.Transparency = 1
    handr.CanCollide = false
    handr.Anchored = false
    handr.Size = Vector3.new(0.001, 0.001, 0.001)
    handr.Massless = true
    handr.Parent = mesh

    local m6d = Instance.new("Motor6D")
    m6d.Name = "Handle.R"
    m6d.Part0 = rhand
    m6d.Part1 = handr
    m6d.Parent = handr

    local offset = CFrame.new(skincfg.positionoffset) * CFrame.Angles(math.rad(skincfg.rotationoffset.X), math.rad(skincfg.rotationoffset.Y), math.rad(skincfg.rotationoffset.Z))

    if clone:IsA("Model") then
        if not clone.PrimaryPart then
            local children = clone:GetChildren()
            for i = 1, #children do
                local c = children[i]
                if c:IsA("BasePart") then
                    clone.PrimaryPart = c
                    break
                end
            end
        end
        if clone.PrimaryPart then
            local descendants = clone:GetDescendants()
            for i = 1, #descendants do
                local p = descendants[i]
                if p:IsA("BasePart") then
                    p.CanCollide = false
                    p.Massless = true
                    p.Anchored = false
                    local w = Instance.new("Weld")
                    w.Part0 = handr
                    w.Part1 = p
                    w.C0 = offset
                    w.C1 = p.CFrame:ToObjectSpace(clone.PrimaryPart.CFrame)
                    w.Parent = p
                    table.insert(data.welds, w)
                end
            end
        end
        clone.Parent = mesh
    elseif clone:IsA("BasePart") then
        clone.CanCollide = false
        clone.Massless = true
        clone.Anchored = false

        if clone:IsA("MeshPart") and skincfg.textureid then
            clone.TextureID = skincfg.textureid
        end

        if skincfg.particle then
            local skinassets = ReplicatedStorage:FindFirstChild("SkinAssets")
            if skinassets then
                local particlefolder = skinassets:FindFirstChild("GunHandleParticle")
                if particlefolder then
                    local particlesource = particlefolder:FindFirstChild(skin)
                    if particlesource then
                        local pe = particlesource:FindFirstChild("ParticleEmitter")
                        if pe then
                            pe:Clone().Parent = clone
                        end
                    end
                end
            end
        end

        clone.Parent = mesh
        local w = Instance.new("Weld")
        w.Part0 = handr
        w.Part1 = clone
        w.C0 = offset
        w.Parent = clone
        table.insert(data.welds, w)
    end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    if skincfg.animationid and skincfg.animationid ~= "" then
        local anim = Instance.new("Animation")
        anim.AnimationId = skincfg.animationid
        local track = animator:LoadAnimation(anim)
        track.Looped = false
        track:Play()
        data.track = track
        anim:Destroy()
        track.Ended:Once(function()
            if data.track == track then
                data.track = nil
            end
            track:Destroy()
        end)
    end
    if skincfg.soundid and skincfg.soundid ~= "" then
        local snd = Instance.new("Sound")
        snd.SoundId = skincfg.soundid
        snd.Parent = Workspace
        snd:Play()
        table.insert(data.sounds, snd)
        snd.Ended:Connect(function()
            snd:Destroy()
        end)
    end

    tool:SetAttribute("CurrentKnifeSkin", skin)
end

local function setupTool(tool)
    if not tool:IsA("Tool") then return end
    if toolRegistry[tool] then return end
    toolRegistry[tool] = true

    tool.Equipped:Connect(function()
        if not getgenv().Lucent['Skins']['Enabled'] then return end

        local char = tool.Parent
        if char ~= localPlayer.Character then return end

        local skin = getgenv().Lucent['Skins']['Weapons'][tool.Name]
        if not skin or skin == "" then return end

        if tool.Name == "[Knife]" then
            applyKnife(char, tool, skin)
        else
            applyGun(tool, skin)
        end
    end)

    tool.Unequipped:Connect(function()
        if tool.Name == "[Knife]" then
            local data = knifeData[tool]
            if not data then return end
            if data.welds then
                for _, w in ipairs(data.welds) do
                    if w then w:Destroy() end
                end
                data.welds = {}
            end
            if data.sounds then
                for _, s in ipairs(data.sounds) do
                    if s and s.Parent then s:Destroy() end
                end
                data.sounds = {}
            end
            local mesh = tool:FindFirstChild("Default")
            if mesh then
                local children = mesh:GetChildren()
                for i = 1, #children do
                    local v = children[i]
                    if v.Name == "Handle.R" or v:IsA("Model") or (v:IsA("MeshPart") and v.Name ~= "Default") then
                        v:Destroy()
                    end
                end
                mesh.Transparency = 0
            end
        end
    end)

    if tool.Parent == localPlayer.Character then
        if not getgenv().Lucent['Skins']['Enabled'] then return end

        local skin = getgenv().Lucent['Skins']['Weapons'][tool.Name]
        if skin and skin ~= "" then
            if tool.Name == "[Knife]" then
                task.spawn(function()
                    applyKnife(localPlayer.Character, tool, skin)
                end)
            else
                task.spawn(function()
                    applyGun(tool, skin)
                end)
            end
        end
    end
end

local function watchChar(char)
    if not char then return end
    local children = char:GetChildren()
    for i = 1, #children do
        local v = children[i]
        if v:IsA("Tool") then
            setupTool(v)
        end
    end
    char.ChildAdded:Connect(function(v)
        if v:IsA("Tool") then
            setupTool(v)
        end
    end)
end

-- Setup skins on backpack tools
local backpackTools = localPlayer.Backpack:GetChildren()
for i = 1, #backpackTools do
    local v = backpackTools[i]
    if v:IsA("Tool") then
        setupTool(v)
    end
end

localPlayer.Backpack.ChildAdded:Connect(function(v)
    if v:IsA("Tool") then
        setupTool(v)
    end
end)

if localPlayer.Character then
    watchChar(localPlayer.Character)
end

trackConn(localPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    watchChar(char)
end))

local triggerBotActive = false
local triggerHold = false
local lastTriggerTime = 0
local lastCamUpdate = 0
local CAM_UPDATE_RATE = 1/60
local lastVisualUpdate = 0
local VISUAL_UPDATE_RATE = 1/60
local currentTargetPlayer = nil
local leftCtrlHeld = false
local targetPlayer = nil
local camLockActive = false

local _pingPredX = 0.12
local _pingPredY = 0.06
local _pingPredZ = 0.12

local function getRealPing()
    local ok, ping = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(ping) == "number" and ping > 0 then return ping end
    ok, ping = pcall(function()
        return Players.LocalPlayer:GetNetworkPing() * 1000
    end)
    if ok and type(ping) == "number" and ping > 0 then return ping end
    return 60
end

trackConn(RunService.Heartbeat:Connect(function()
    local cfg = getgenv().Lucent['Ping Prediction']
    if not cfg or not cfg['Enabled'] then return end
    local ping    = getRealPing()
    local pingSec = math.clamp(ping, 10, 600) / 1000
    local smooth  = cfg['Smoothing'] or 0.08
    local yScale  = cfg['Y Scale']   or 0.45
    local targetX = pingSec
    local targetY = pingSec * yScale
    local targetZ = pingSec
    _pingPredX = _pingPredX + (targetX - _pingPredX) * smooth
    _pingPredY = _pingPredY + (targetY - _pingPredY) * smooth
    _pingPredZ = _pingPredZ + (targetZ - _pingPredZ) * smooth
    getgenv().Lucent['Silent Aimbot']['Prediction']['X'] = _pingPredX
    getgenv().Lucent['Silent Aimbot']['Prediction']['Y'] = _pingPredY
    getgenv().Lucent['Silent Aimbot']['Prediction']['Z'] = _pingPredZ
    getgenv().Lucent['Camera Aimbot']['Prediction']['X'] = _pingPredX
    getgenv().Lucent['Camera Aimbot']['Prediction']['Y'] = _pingPredY
    getgenv().Lucent['Camera Aimbot']['Prediction']['Z'] = _pingPredZ
    getgenv().Lucent['Trigger Bot']['Prediction']['X']   = _pingPredX
    getgenv().Lucent['Trigger Bot']['Prediction']['Y']   = _pingPredY
    getgenv().Lucent['Trigger Bot']['Prediction']['Z']   = _pingPredZ
end))

local camLockHold = false
local camLockTarget = nil
local camLockPart = nil
local rightClickHeld = false
local espLabels = {}

local targetLine = Drawing.new("Line")
targetLine.Visible      = false
targetLine.Thickness    = 1.5
targetLine.Transparency = 1
targetLine.ZIndex       = 999

local ShotgunNames   = { ["Double-Barrel SG"]=true, ["TacticalShotgun"]=true, ["Shotgun"]=true, ["DrumShotgun"]=true }
local PistolNames    = { ["Revolver"]=true, ["Silencer"]=true, ["Glock"]=true }
local AutomaticNames = { ["AK-47"]=true, ["AR"]=true, ["Silencer AR"]=true, ["Drum Gun"]=true }
local RifleNames     = { ["AUG"]=true, ["P90"]=true, ["Rifle"]=true }

local targetCache = {
    Player = nil, Root = nil, Hitbox = nil, Box = nil,
    Trigger = nil, TriggerBox = nil,
    SilentFOV = {}, TriggerFOV = {}
}

local R15_PARTS = {
    "Head","UpperTorso","LowerTorso",
    "LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot"
}

task.spawn(function()
    local CommunityID = 17215700
    local function checkMod(Player)
        if getgenv().Lucent and getgenv().Lucent.Global and getgenv().Lucent.Global["Mod Detector"] then
            if Player ~= localPlayer and Player:IsInGroup(CommunityID) then
                localPlayer:Kick("A moderator has joined the game!")
                return true
            end
        end
        return false
    end
    for _, Player in ipairs(Players:GetPlayers()) do
        if checkMod(Player) then break end
    end
    Players.PlayerAdded:Connect(function(Player)
        task.wait()
        checkMod(Player)
    end)
end)

local function applyPrediction(rootPart, predX, predY, predZ)
    local velocity = rootPart.Velocity
    return CFrame.new(rootPart.Position + Vector3.new(velocity.X * predX, velocity.Y * predY, velocity.Z * predZ))
end

local function getWeaponCategory()
    local tool = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return "Others" end
    local name = tool.Name:gsub("[%[%]]", "")
    if ShotgunNames[name] then return "Shotguns"
    elseif PistolNames[name] then return "Pistols"
    elseif AutomaticNames[name] then return "Automatics"
    elseif RifleNames[name] then return "Rifles"
    else return "Others" end
end

local function getTriggerbotDelay()
    local cfg = getgenv().Lucent['Trigger Bot']['Delay Settings']
    if not cfg['Delay Toggle'] then return 0 end
    local defaultDelay = cfg['Delay'] or 0.095
    local wc = cfg['Weapon Configuration']
    if not wc or not wc.Enabled then return defaultDelay end
    local category = getWeaponCategory()
    local weaponCfg = wc[category] or wc.Others
    return weaponCfg['Delay'] or defaultDelay
end

local function getCameraSmoothness(distance)
    local cfg = getgenv().Lucent['Camera Aimbot']['Range Smoothing']
    if not cfg.Enabled then
        return getgenv().Lucent['Camera Aimbot']['Smoothing'].X, getgenv().Lucent['Camera Aimbot']['Smoothing'].Y
    end
    if distance <= 30 then return cfg.Close.X, cfg.Close.Y
    elseif distance <= 80 then return cfg.Medium.X, cfg.Medium.Y
    else return cfg.Far.X, cfg.Far.Y end
end

local function getSplitFOV(section)
    local fovData = getgenv().Lucent[section].FOV
    local size = fovData.Size or fovData
    local cfg = {
        xLeft  = size["X Right"],  xRight = size["X Left"],
        yUpper = size["Y Upper"],  yLower = size["Y Lower"],
        zLeft  = size["Z Right"],  zRight = size["Z Left"]
    }
    local wc = fovData["Weapon Configuration"]
    if wc and wc.Enabled then
        local cat = getWeaponCategory()
        local weaponCfg = wc[cat] or wc.Others
        cfg.xLeft  = weaponCfg["X Right"] or cfg.xLeft
        cfg.xRight = weaponCfg["X Left"]  or cfg.xRight
        cfg.yUpper = weaponCfg["Y Upper"] or cfg.yUpper
        cfg.yLower = weaponCfg["Y Lower"] or cfg.yLower
        cfg.zLeft  = weaponCfg["Z Right"] or cfg.zLeft
        cfg.zRight = weaponCfg["Z Left"]  or cfg.zRight
    end
    return cfg
end

local function isMouseInSilentFOV()
    if not targetPlayer or not targetPlayer.Character then return false end
    local char = targetPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local upperTorso = char:FindFirstChild("UpperTorso")
    if not hrp then return false end
    local fovData = getgenv().Lucent['Silent Aimbot'].FOV
    local xL  = fovData["X Left"]  or 12
    local xR  = fovData["X Right"] or 12
    local yU  = fovData["Y Upper"] or 12
    local yLo = fovData["Y Lower"] or 12
    local wc = fovData["Weapon Configuration"]
    if wc and wc.Enabled then
        local wcfg = wc[getWeaponCategory()] or wc.Others
        if wcfg then
            xL  = wcfg["X Left"]  or xL
            xR  = wcfg["X Right"] or xR
            yU  = wcfg["Y Upper"] or yU
            yLo = wcfg["Y Lower"] or yLo
        end
    end
    local basePos = (upperTorso or hrp).Position
    local sp = camera:WorldToViewportPoint(basePos)
    if sp.Z <= 0 then return false end
    local mousePos  = UserInputService:GetMouseLocation()
    local targetPos = Vector2.new(sp.X, sp.Y)
    local vp    = camera.ViewportSize
    local scale = vp.Y / (2 * math.tan(math.rad(camera.FieldOfView / 2)))
    local dist3D = (camera.CFrame.Position - basePos).Magnitude
    local pixW = ((xL + xR) / 2) * scale / dist3D
    local pixH = ((yU + yLo) / 2) * scale / dist3D
    local dx = (mousePos.X - targetPos.X) / pixW
    local dy = (mousePos.Y - targetPos.Y) / pixH
    return (dx * dx + dy * dy) <= 1
end

local function isMouseInTriggerFOV()
    if not targetPlayer or not targetPlayer.Character then return false end
    local char = targetPlayer.Character
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    local upperTorso = char:FindFirstChild("UpperTorso")
    if not hrp then return false end
    local fovData = getgenv().Lucent['Trigger Bot'].FOV
    if fovData['Mode'] == '2D' then
        local screenPos = camera:WorldToViewportPoint(hrp.Position)
        if screenPos.Z <= 0 then return false end
        local mousePos = UserInputService:GetMouseLocation()
        return (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude <= (fovData['Radius'] or 150)
    end
    local size = fovData.Size or fovData
    local xL  = size["X Left"]  or 12
    local xR  = size["X Right"] or 12
    local yU  = size["Y Upper"] or 12
    local yLo = size["Y Lower"] or 12
    local zL  = size["Z Left"]  or 12
    local zR  = size["Z Right"] or 12
    local wc = fovData["Weapon Configuration"]
    if wc and wc.Enabled then
        local wcfg = wc[getWeaponCategory()] or wc.Others
        xL=wcfg["X Left"] or xL; xR=wcfg["X Right"] or xR
        yU=wcfg["Y Upper"] or yU; yLo=wcfg["Y Lower"] or yLo
        zL=wcfg["Z Left"] or zL; zR=wcfg["Z Right"] or zR
    end
    local basePos = (upperTorso or hrp).Position
    local look    = hrp.CFrame.LookVector
    local facing  = CFrame.lookAt(Vector3.new(), Vector3.new(look.X, 0, look.Z))
    local pred = getgenv().Lucent['Trigger Bot'].Prediction
    if hrp.Velocity.Magnitude > 1 and (pred.X ~= 0 or pred.Y ~= 0 or pred.Z ~= 0) then
        basePos = basePos + hrp.Velocity * Vector3.new(pred.X, pred.Y, pred.Z)
    end
    local boxSize   = Vector3.new(xL+xR, yU+yLo, zL+zR)
    local boxOffset = facing:VectorToWorldSpace(Vector3.new((xR-xL)/2,(yU-yLo)/2,(zR-zL)/2))
    local boxCF     = CFrame.new(basePos + boxOffset) * facing
    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local lo  = boxCF:PointToObjectSpace(ray.Origin)
    local ld  = boxCF:VectorToObjectSpace(ray.Direction).Unit
    local half = boxSize / 2
    local tmin, tmax = -math.huge, math.huge
    for _, axis in ipairs({"X","Y","Z"}) do
        local o, d, s = lo[axis], ld[axis], half[axis]
        if math.abs(d) < 1e-6 then
            if o < -s or o > s then return false end
        else
            local t1, t2 = (-s-o)/d, (s-o)/d
            if t1 > t2 then t1, t2 = t2, t1 end
            tmin = math.max(tmin, t1)
            tmax = math.min(tmax, t2)
            if tmin > tmax then return false end
        end
    end
    return tmax >= 0
end

local function isVisible(origin, targetPart, targetCharacter)
    if not getgenv().Lucent.Checks['Visible Check'] then return true end
    if not (targetPart and targetPart:IsA("BasePart")) then return false end
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = { localPlayer.Character, targetCharacter }
    rayParams.IgnoreWater = true
    local result = Workspace:Raycast(origin, direction, rayParams)
    return not result or result.Instance:IsDescendantOf(targetCharacter)
end

local function isSameCrew(target)
    if not getgenv().Lucent.Checks['Crew Check'] then return false end
    local localCrew = localPlayer:GetAttribute("CrewID")
    local targetCrew = target:GetAttribute("CrewID")
    return localCrew and targetCrew and localCrew == targetCrew
end

local function isSelfKnocked()
    local bodyEffects = localPlayer.Character and localPlayer.Character:FindFirstChild("BodyEffects")
    local ko = bodyEffects and bodyEffects:FindFirstChild("K.O")
    return ko and ko.Value
end

local function triggerbot()
    if isSelfKnocked() then return end
    local char = localPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or not tool:IsDescendantOf(char) then return end
    if tool.Name == '[Knife]' then return end
    -- fire multiple times in same frame to catch VF game server checks
    tool:Activate()
    task.defer(function() tool:Activate() end)
end

local function basicpoint(part)
    if not part then return nil end
    local mouseRay = mouse.UnitRay
    mouseRay = mouseRay.Origin + (mouseRay.Direction * (part.Position - mouseRay.Origin).Magnitude)
    local point = (mouseRay.Y >= (part.Position - part.Size / 2).Y and mouseRay.Y <= (part.Position + part.Size / 2).Y)
                  and (part.Position + Vector3.new(0, -part.Position.Y + mouseRay.Y, 0))
                  or part.Position
    local check = RaycastParams.new()
    check.FilterType = Enum.RaycastFilterType.Whitelist
    check.FilterDescendantsInstances = {part}
    local ray = Workspace:Raycast(mouseRay, (point - mouseRay), check)
    if mouse.Target == part then return mouse.Hit.Position end
    if ray then return ray.Position end
    return mouse.Hit.Position
end

local pointCache = {}

local LOWER_BODY = {
    LeftFoot=true, RightFoot=true,
    LeftLowerLeg=true, RightLowerLeg=true,
}

local UPPER_BODY_PARTS = {
    "Head","UpperTorso","LowerTorso",
    "LeftUpperArm","RightUpperArm",
    "LeftLowerArm","RightLowerArm",
    "LeftHand","RightHand",
    "LeftUpperLeg","RightUpperLeg",
}

local function getClosestPoint(character, isCamlock)
    if not (character and character.Parent) then return nil end

    local mp  = UserInputService:GetMouseLocation()
    local mx, my = mp.X, mp.Y
    local cam = camera
    local cfg = isCamlock and getgenv().Lucent['Camera Aimbot']['Closest Point']
                           or getgenv().Lucent['Silent Aimbot']['Closest Point']
    local scale   = math.clamp(cfg['Scale'] or 0.12, 0, 1)
    local hrp     = character:FindFirstChild("HumanoidRootPart")
    local groundY = hrp and (hrp.Position.Y - 1.2) or -math.huge

    local parts = {}
    for _, name in ipairs(UPPER_BODY_PARTS) do
        if not LOWER_BODY[name] then
            local p = character:FindFirstChild(name)
            if p and p:IsA("BasePart") then table.insert(parts, p) end
        end
    end
    if #parts == 0 then
        local torso = character:FindFirstChild("UpperTorso") or hrp
        return torso and { Part = torso, Position = torso.Position }
    end

    -- Cast a ray from camera through the mouse cursor into world space
    local ray    = cam:ViewportPointToRay(mx, my)
    local rayDir = ray.Direction  -- already unit length from Roblox

    local bestScreenDist = 1e9
    local bestPart, bestPos

    for _, part in ipairs(parts) do
        repeat
            local cf   = part.CFrame
            local half = part.Size * 0.5 * (1 - scale)  -- shrink bounds inward

            -- Transform ray to part's local space (no allocation overhead)
            local lo = cf:PointToObjectSpace(ray.Origin)
            local ld = cf:VectorToObjectSpace(rayDir)

            -- Closest point on infinite ray to the OBB center (local origin)
            -- t = dot(center - origin, dir) / dot(dir, dir)
            local t = math.max(0, (-lo):Dot(ld) / ld:Dot(ld))
            local onRay = lo + ld * t

            -- Clamp to box extents to get nearest point inside/on the box
            local cx = math.clamp(onRay.X, -half.X, half.X)
            local cy = math.clamp(onRay.Y, -half.Y, half.Y)
            local cz = math.clamp(onRay.Z, -half.Z, half.Z)

            local worldPos = cf:PointToWorldSpace(Vector3.new(cx, cy, cz))
            if worldPos.Y < groundY then break end

            local sp = cam:WorldToViewportPoint(worldPos)
            if sp.Z <= 0 then break end

            local d = (sp.X - mx)^2 + (sp.Y - my)^2
            if d < bestScreenDist then
                bestScreenDist = d
                bestPart = part
                bestPos  = worldPos
            end
        until true
    end

    if not bestPart then
        local torso = character:FindFirstChild("UpperTorso") or hrp
        return torso and { Part = torso, Position = torso.Position }
    end
    return { Part = bestPart, Position = bestPos }
end


local function getClosestPart(character)
    if not character then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    local bestDist = 1e9; local bestPart
    for _, name in ipairs(UPPER_BODY_PARTS) do
        if not LOWER_BODY[name] then
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                local sp = camera:WorldToViewportPoint(part.Position)
                if sp.Z > 0 then
                    local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                    if dist < bestDist then bestDist=dist; bestPart=part end
                end
            end
        end
    end
    if bestPart then return { Part = bestPart, Position = bestPart.Position } end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    return hrp and { Part = hrp, Position = hrp.Position }
end

local function getNearestPoint(character)
    if not character then return nil end
    local origin = camera.CFrame.Position
    local bestDist = 1e9; local bestPart, bestPos
    for _, name in ipairs(UPPER_BODY_PARTS) do
        if not LOWER_BODY[name] then
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                local local0 = part.CFrame:PointToObjectSpace(origin)
                local half   = part.Size * 0.5
                local clamped = Vector3.new(
                    math.clamp(local0.X,-half.X,half.X),
                    math.clamp(local0.Y,-half.Y,half.Y),
                    math.clamp(local0.Z,-half.Z,half.Z)
                )
                local worldClamped = part.CFrame:PointToWorldSpace(clamped)
                local dist = (worldClamped - origin).Magnitude
                if dist < bestDist then bestDist=dist; bestPart=part; bestPos=worldClamped end
            end
        end
    end
    if bestPart then return { Part = bestPart, Position = bestPos } end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    return hrp and { Part = hrp, Position = hrp.Position }
end

local function getClosestBodyPart(character)
    if not character then return nil end
    local hitpart = getgenv().Lucent['Silent Aimbot'].HitPart
    if hitpart == "Closest Point" then return getClosestPoint(character, false)
    elseif hitpart == "Closest Part" then return getClosestPart(character)
    elseif hitpart == "Nearest Point" then return getNearestPoint(character) end
    local part = character:FindFirstChild(hitpart)
    if part and part:IsA("BasePart") then return { Part = part, Position = part.Position } end
    return getClosestPoint(character, false)
end

local function getCamlockBodyPart(character)
    if not character then return nil end
    local hitpart = getgenv().Lucent['Camera Aimbot'].HitPart
    if hitpart == "Closest Point" then return getClosestPoint(character, true)
    elseif hitpart == "Closest Part" then return getClosestPart(character)
    elseif hitpart == "Nearest Point" then return getNearestPoint(character) end
    local part = character:FindFirstChild(hitpart)
    if part and part:IsA("BasePart") then return { Part = part, Position = part.Position } end
    return getClosestPoint(character, true)
end

local function isSelfKnocked()
    local bodyEffects = localPlayer.Character and localPlayer.Character:FindFirstChild("BodyEffects")
    local ko = bodyEffects and bodyEffects:FindFirstChild("K.O")
    return ko and ko.Value
end

local function getBestTarget()
    local closestPlayer, closestDist = nil, math.huge
    local cam   = Workspace.CurrentCamera
    local myChar = localPlayer.Character
    local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local camPos = cam.CFrame.Position
    local mp     = UserInputService:GetMouseLocation()

    -- read camera aimbot FOV radius as the targeting radius
    local fovRadius = tonumber(getgenv().Lucent['Camera Aimbot'].FOV['Radius']) or 80
    local vp    = cam.ViewportSize

    for _, player in ipairs(Players:GetPlayers()) do
        repeat
            if player == localPlayer then break end
            local char = player.Character
            if not char or not char.Parent then break end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum  = char:FindFirstChildOfClass("Humanoid")
            if not root then break end
            if hum and hum.Health <= 0 then break end
            local be      = char:FindFirstChild("BodyEffects")
            local ko      = be and be:FindFirstChild("K.O")
            local knocked = be and be:FindFirstChild("Knocked")
            local grabbed = be and be:FindFirstChild("Grabbed")
            local ff      = char:FindFirstChildOfClass("ForceField")
            if getgenv().Lucent.Checks['Knock Check'] and ((ko and ko.Value) or (knocked and knocked.Value)) then break end
            if getgenv().Lucent.Checks['Forcefield Check'] and ff then break end
            if getgenv().Lucent.Checks['Crew Check'] and isSameCrew(player) then break end
            local head = char:FindFirstChild("Head")
            if getgenv().Lucent.Checks['Visible Check'] and head then
                if not isVisible(camPos, head, char) then break end
            end
            local screenPos = cam:WorldToViewportPoint(root.Position)
            if screenPos.Z <= 0 then break end
            -- screen FOV gate: only consider players within radius pixels of mouse
            local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mp).Magnitude
            if screenDist > fovRadius then break end
            local dist3D = myHRP and (myHRP.Position - root.Position).Magnitude or math.huge
            if dist3D < closestDist then closestDist=dist3D; closestPlayer=player end
        until true
    end
    return closestPlayer
end

local function clearTargetIfInvalid()
    if not targetPlayer or not targetPlayer.Character then
        targetPlayer=nil; camLockTarget=nil; camLockPart=nil; camLockActive=false
        pcall(function()
            if targetCache.Hitbox then targetCache.Hitbox:Destroy() end
            if targetCache.Box then targetCache.Box:Destroy() end
            if targetCache.Trigger then targetCache.Trigger:Destroy() end
            if targetCache.TriggerBox then targetCache.TriggerBox:Destroy() end
        end)
        return true
    end
    local char    = targetPlayer.Character
    local root    = char:FindFirstChild("HumanoidRootPart")
    local head    = char:FindFirstChild("Head")
    local hum     = char:FindFirstChildOfClass("Humanoid")
    local be      = char:FindFirstChild("BodyEffects")
    local ko      = be and be:FindFirstChild("K.O")
    local knocked = be and be:FindFirstChild("Knocked")
    local grabbed = be and be:FindFirstChild("Grabbed")
    local ff      = char:FindFirstChildOfClass("ForceField")
    local dead    = hum and hum.Health <= 0
    local checks  = getgenv().Lucent.Checks
    local invalid = not root or dead
        or (checks['Knock Check']      and ((ko and ko.Value) or (knocked and knocked.Value)))
        or (checks['Forcefield Check'] and ff)
        or (checks['Crew Check']       and isSameCrew(targetPlayer))
        or (checks['Visible Check']    and head and not isVisible(camera.CFrame.Position, head, char))
    if invalid then
        targetPlayer=nil; camLockTarget=nil; camLockPart=nil; camLockActive=false
        pcall(function()
            if targetCache.Hitbox then targetCache.Hitbox:Destroy() end
            if targetCache.Box then targetCache.Box:Destroy() end
            if targetCache.Trigger then targetCache.Trigger:Destroy() end
            if targetCache.TriggerBox then targetCache.TriggerBox:Destroy() end
        end)
        return true
    end
    return false
end

local function applySpeed()
    local cfg = getgenv().Lucent["Speed Modifications"]
    if not cfg or not cfg.Enabled then return end
    local hum = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local health = hum.Health
    local speed = 16
    if cfg["Low Health"] and health <= cfg["Low Health"]["Health Threshold"] then
        speed = speed * cfg["Low Health"]["Multiplier"]
    else
        speed = speed * cfg.Normal["Multiplier"]
    end
    hum.WalkSpeed = speed
end

local function hookHumanoid(humanoid)
    applySpeed()
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if getgenv().Lucent["Speed Modifications"].Enabled then applySpeed() end
    end)
    humanoid.HealthChanged:Connect(applySpeed)
end

trackConn(localPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then hookHumanoid(hum) end
end))
if localPlayer.Character then
    local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hookHumanoid(hum) end
end

local function espMakeLabel(size, zindex)
    local t = Drawing.new("Text")
    t.Size=size; t.Center=true; t.Outline=true
    t.OutlineColor=Color3.fromRGB(0,0,0); t.Color=Color3.fromRGB(255,255,255)
    t.Font=Drawing.Fonts.Plex; t.Visible=false; t.ZIndex=zindex
    return t
end

local function espAdd(player)
    if player == localPlayer then return end
    if espLabels[player.UserId] then return end
    local cfg = getgenv().Lucent['ESP']
    espLabels[player.UserId] = {
        player  = player,
        nametag = espMakeLabel(cfg['Font Size'],     1000),
        subtag  = espMakeLabel(cfg['Font Size'] - 2, 999),
    }
end

local function espRemove(player)
    local e = espLabels[player.UserId]
    if not e then return end
    e.nametag:Remove(); e.subtag:Remove()
    espLabels[player.UserId] = nil
end

local function espRefresh()
    local cfg = getgenv().Lucent['ESP']
    if not cfg['Enabled'] then
        for _, e in pairs(espLabels) do e.nametag.Visible=false; e.subtag.Visible=false end
        targetLine.Visible = false
        return
    end
    for userid, e in pairs(espLabels) do
        repeat
            local player = e.player
            if not player or not player.Parent then
                e.nametag:Remove(); e.subtag:Remove(); espLabels[userid]=nil; break
            end
            local char = player.Character
            if not char or not char.Parent then e.nametag.Visible=false; e.subtag.Visible=false; break end
            local hrp  = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")
            local hum  = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not head then e.nametag.Visible=false; e.subtag.Visible=false; break end
            if hum and hum.Health <= 0 then e.nametag.Visible=false; e.subtag.Visible=false; break end
            local worldpos = cfg['Name Above']
                and (head.Position + Vector3.new(0,1.5,0))
                or  (hrp.Position  - Vector3.new(0,2.8,0))
            local sp = camera:WorldToViewportPoint(worldpos)
            if sp.Z <= 0 then e.nametag.Visible=false; e.subtag.Visible=false; break end
            local pos2d    = Vector2.new(sp.X, sp.Y)
            local istarget = targetPlayer and targetPlayer == player
            local col      = istarget and cfg['Target Color'] or cfg['Color']
            if cfg['Show Display Name'] then
                e.nametag.Text=player.DisplayName; e.nametag.Color=col
                e.nametag.Position=pos2d; e.nametag.Visible=true
            else e.nametag.Visible=false end
            if cfg['Show Username'] then
                local offset = cfg['Show Display Name'] and (cfg['Font Size']+2) or 0
                e.subtag.Text="@"..player.Name; e.subtag.Color=cfg['Username Color']
                e.subtag.Position=Vector2.new(pos2d.X, pos2d.Y+offset); e.subtag.Visible=true
            else e.subtag.Visible=false end
        until true
    end
    local tlCfg = cfg['Target Line']
    if tlCfg and tlCfg['Enabled'] and targetPlayer and targetPlayer.Character then
        local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sp = camera:WorldToViewportPoint(hrp.Position)
            if sp.Z > 0 then
                local vp = camera.ViewportSize
                local origin
                local orig = tlCfg['Origin'] or "Bottom"
                if orig == "Center" then origin = Vector2.new(vp.X/2, vp.Y/2)
                elseif orig == "Mouse" then origin = UserInputService:GetMouseLocation()
                else origin = Vector2.new(vp.X/2, vp.Y) end
                targetLine.From=origin; targetLine.To=Vector2.new(sp.X, sp.Y)
                targetLine.Color=tlCfg['Color'] or Color3.fromRGB(255,255,255)
                targetLine.Thickness=tlCfg['Thickness'] or 1.5
                targetLine.Transparency=tlCfg['Transparency'] or 0.5
                targetLine.Visible=true
            else targetLine.Visible=false end
        else targetLine.Visible=false end
    else targetLine.Visible=false end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then espAdd(player) end
    trackConn(player.CharacterAdded:Connect(function(char)
        espRemove(player); char:WaitForChild("HumanoidRootPart"); task.wait(0.1); espAdd(player)
    end))
    trackConn(player.CharacterRemoving:Connect(function() espRemove(player) end))
end
trackConn(Players.PlayerAdded:Connect(function(player)
    if player == localPlayer then return end
    trackConn(player.CharacterAdded:Connect(function(char)
        espRemove(player); char:WaitForChild("HumanoidRootPart"); task.wait(0.1); espAdd(player)
    end))
    trackConn(player.CharacterRemoving:Connect(function() espRemove(player) end))
end))
trackConn(Players.PlayerRemoving:Connect(function(player) espRemove(player) end))

local selectPressed = false
local camPressed = false
local triggerPressed = false
local speedPressed = false
local superJumpEnabled = false

trackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    local selectBind  = getgenv().Lucent["Binds"].Select
    local camBind     = getgenv().Lucent["Binds"]["Camera Aimbot"]
    local triggerBind = getgenv().Lucent["Binds"].Triggerbot
    local speedBind   = getgenv().Lucent["Binds"].Speed
    local targetMode  = getgenv().Lucent['Targeting']['Target Mode']
    if key == Enum.KeyCode.LeftControl then leftCtrlHeld = true return end
    if key == Enum.KeyCode[selectBind] and targetMode == 'Select' then
        if not selectPressed then
            selectPressed = true
            if targetPlayer then
                targetPlayer = nil
                pcall(function()
                    if targetCache.Hitbox then targetCache.Hitbox:Destroy() end
                    if targetCache.Box then targetCache.Box:Destroy() end
                    if targetCache.Trigger then targetCache.Trigger:Destroy() end
                    if targetCache.TriggerBox then targetCache.TriggerBox:Destroy() end
                end)
            else
                targetPlayer = getBestTarget()
            end
        end
    end
    if key == Enum.KeyCode[camBind] then
        if not camPressed then
            camPressed = true
            local mode = getgenv().Lucent['Camera Aimbot'].Mode
            if mode == "Toggle" then
                camLockActive = not camLockActive
                if camLockActive then
                    camLockTarget = targetPlayer
                    if camLockTarget and camLockTarget.Character then
                        camLockPart = getCamlockBodyPart(camLockTarget.Character)
                    end
                else camLockTarget=nil; camLockPart=nil end
            elseif mode == "Hold" then
                camLockHold=true; camLockActive=true; camLockTarget=targetPlayer
                if camLockTarget and camLockTarget.Character then
                    camLockPart = getCamlockBodyPart(camLockTarget.Character)
                end
            end
        end
    end
    if key == Enum.KeyCode[triggerBind] then
        if not triggerPressed then
            triggerPressed = true
            local mode = getgenv().Lucent['Trigger Bot'].Settings.Mode
            if mode == "Toggle" then triggerBotActive = not triggerBotActive
            elseif mode == "Hold" then triggerHold = true end
        end
    end
    if key == Enum.KeyCode[speedBind] then
        if not speedPressed then
            speedPressed = true
            local cfg = getgenv().Lucent["Speed Modifications"]
            cfg.Enabled = not cfg.Enabled
            applySpeed()
        end
    end
    local superJumpBind = getgenv().Lucent["Binds"]["Super Jump"]
    if superJumpBind and key == Enum.KeyCode[superJumpBind] then
        if getgenv().Lucent["Super Jump"]["Enabled"] then
            superJumpEnabled = not superJumpEnabled
        end
    end
    local espBind = getgenv().Lucent['Binds']['ESP']
    if espBind and key == Enum.KeyCode[espBind] then
        getgenv().Lucent['ESP']['Enabled'] = not getgenv().Lucent['ESP']['Enabled']
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then rightClickHeld = true end
end))

trackConn(UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then leftCtrlHeld = false end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then rightClickHeld = false end
    local camBind = getgenv().Lucent["Binds"]["Camera Aimbot"]
    local mode = getgenv().Lucent['Camera Aimbot'].Mode
    if input.KeyCode == Enum.KeyCode[camBind] then
        camPressed = false
        if mode == "Hold" then camLockHold=false; camLockActive=false; camLockTarget=nil; camLockPart=nil end
    end
    if input.KeyCode == Enum.KeyCode[getgenv().Lucent["Binds"].Triggerbot] then
        if getgenv().Lucent['Trigger Bot'].Settings.Mode == "Hold" then triggerHold = false end
        triggerPressed = false
    end
    if input.KeyCode == Enum.KeyCode[getgenv().Lucent["Binds"].Select]    then selectPressed = false end
    if input.KeyCode == Enum.KeyCode[getgenv().Lucent["Binds"].Speed]     then speedPressed  = false end
end))

local lastTargetUpdate = 0
trackConn(RunService.RenderStepped:Connect(function()
    local mode = getgenv().Lucent['Targeting']['Target Mode']
    if mode == "Automatic" then
        -- drop target if they leave FOV
        if targetPlayer and targetPlayer.Character then
            local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local sp = camera:WorldToViewportPoint(root.Position)
                local mp = UserInputService:GetMouseLocation()
                local fovRadius = tonumber(getgenv().Lucent['Camera Aimbot'].FOV['Radius']) or 80
                if sp.Z <= 0 or (Vector2.new(sp.X, sp.Y) - mp).Magnitude > fovRadius then
                    targetPlayer = nil; camLockTarget = nil; camLockPart = nil; camLockActive = false
                end
            end
        end
        local now = tick()
        if now - lastTargetUpdate >= 0.1 then
            lastTargetUpdate = now
            local best = getBestTarget()
            if best ~= targetPlayer then targetPlayer = best end
        end
    end
    if clearTargetIfInvalid() then currentTargetPlayer=nil; return end
    if targetPlayer ~= currentTargetPlayer then
        currentTargetPlayer = targetPlayer
        pcall(function()
            if targetCache.Hitbox then targetCache.Hitbox:Destroy(); targetCache.Hitbox=nil end
            if targetCache.Box    then targetCache.Box:Destroy();    targetCache.Box=nil    end
            if targetCache.Trigger    then targetCache.Trigger:Destroy();    targetCache.Trigger=nil    end
            if targetCache.TriggerBox then targetCache.TriggerBox:Destroy(); targetCache.TriggerBox=nil end
        end)
    end
    if not targetPlayer or not targetPlayer.Character then return end
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local upperTorso = targetPlayer.Character:FindFirstChild("UpperTorso")
    local basePos = upperTorso and upperTorso.Position or root.Position
    local look = root.CFrame.LookVector
    local facing = CFrame.lookAt(Vector3.new(), Vector3.new(look.X, 0, look.Z))
    local showSilent  = getgenv().Lucent['Silent Aimbot'].FOV['Show FOV']
    local showTrigger = getgenv().Lucent['Trigger Bot'].FOV['Show FOV']
    local silentFOV  = getSplitFOV('Silent Aimbot')
    local triggerFOV = getSplitFOV('Trigger Bot')

    if showSilent then
        if not targetCache.Hitbox then
            targetCache.Hitbox = Instance.new("Part")
            targetCache.Hitbox.Name="SilentHitbox_"..targetPlayer.Name
            targetCache.Hitbox.Anchored=true; targetCache.Hitbox.CanCollide=false
            targetCache.Hitbox.Transparency=1; targetCache.Hitbox.CanQuery=false
            targetCache.Hitbox.Parent=Workspace
        end
        local size = Vector3.new(silentFOV.xLeft+silentFOV.xRight, silentFOV.yUpper+silentFOV.yLower, silentFOV.zLeft+silentFOV.zRight)
        local offset = facing:VectorToWorldSpace(Vector3.new((silentFOV.xRight-silentFOV.xLeft)/2,(silentFOV.yUpper-silentFOV.yLower)/2,(silentFOV.zRight-silentFOV.zLeft)/2))
        targetCache.Hitbox.Size=size; targetCache.Hitbox.CFrame=CFrame.new(basePos+offset)*facing
        if not targetCache.Box then
            targetCache.Box=Instance.new("BoxHandleAdornment")
            targetCache.Box.Adornee=targetCache.Hitbox; targetCache.Box.AlwaysOnTop=true
            targetCache.Box.ZIndex=10; targetCache.Box.Transparency=0.7; targetCache.Box.Size=size
            targetCache.Box.Parent=targetCache.Hitbox
        end
        targetCache.Box.Color3 = isMouseInSilentFOV() and Color3.new(0,1,0) or Color3.new(1,0,0)
    else
        if targetCache.Hitbox then targetCache.Hitbox:Destroy(); targetCache.Hitbox=nil end
        if targetCache.Box    then targetCache.Box:Destroy();    targetCache.Box=nil    end
    end

    if showTrigger then
        if not targetCache.Trigger then
            targetCache.Trigger=Instance.new("Part")
            targetCache.Trigger.Name="TriggerHitbox_"..targetPlayer.Name
            targetCache.Trigger.Anchored=true; targetCache.Trigger.CanCollide=false
            targetCache.Trigger.Transparency=1; targetCache.Trigger.CanQuery=false
            targetCache.Trigger.Parent=Workspace
        end
        local pred = getgenv().Lucent['Trigger Bot'].Prediction
        local predPos = root.Position
        if root.Velocity.Magnitude > 1 then
            predPos = predPos + root.Velocity * Vector3.new(pred.X, pred.Y, pred.Z)
        end
        local size = Vector3.new(triggerFOV.xLeft+triggerFOV.xRight, triggerFOV.yUpper+triggerFOV.yLower, triggerFOV.zLeft+triggerFOV.zRight)
        local offset = facing:VectorToWorldSpace(Vector3.new((triggerFOV.xRight-triggerFOV.xLeft)/2,(triggerFOV.yUpper-triggerFOV.yLower)/2,(triggerFOV.zRight-triggerFOV.zLeft)/2))
        local upperPos = upperTorso and upperTorso.Position or predPos
        targetCache.Trigger.Size=size; targetCache.Trigger.CFrame=CFrame.new(upperPos+offset)*facing
        if not targetCache.TriggerBox then
            targetCache.TriggerBox=Instance.new("BoxHandleAdornment")
            targetCache.TriggerBox.Adornee=targetCache.Trigger; targetCache.TriggerBox.AlwaysOnTop=true
            targetCache.TriggerBox.ZIndex=10; targetCache.TriggerBox.Transparency=0.7; targetCache.TriggerBox.Size=size
            targetCache.TriggerBox.Parent=targetCache.Trigger
        end
        targetCache.TriggerBox.Color3 = isMouseInTriggerFOV() and Color3.new(0,1,0) or Color3.new(1,1,1)
    else
        if targetCache.Trigger    then targetCache.Trigger:Destroy();    targetCache.Trigger=nil    end
        if targetCache.TriggerBox then targetCache.TriggerBox:Destroy(); targetCache.TriggerBox=nil end
    end

    if getgenv().Lucent['Trigger Bot'].Enabled and not leftCtrlHeld then
        local cfg = getgenv().Lucent['Trigger Bot'].Settings
        local isSelectMode = (mode == "Select")
        local forceTrigger = isSelectMode and getgenv().Lucent['Select Only Features']['Force Trigger']
        local active = forceTrigger or (cfg.Mode=="Always") or (cfg.Mode=="Hold" and triggerHold) or (cfg.Mode=="Toggle" and triggerBotActive)
        if active then
            local now = tick()
            local delay = getTriggerbotDelay()
            if delay > 0 and (now - lastTriggerTime) < delay then return end
            local distCheck = getgenv().Lucent['Trigger Bot']['Distance Check']
            if distCheck and distCheck['Enabled'] and not forceTrigger then
                local myChar = localPlayer.Character
                local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local tgtHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and tgtHRP and (myHRP.Position-tgtHRP.Position).Magnitude > distCheck['Max Distance'] then return end
            end
            local inRange = forceTrigger or targetMode == "Automatic" or isMouseInTriggerFOV()
            if inRange then triggerbot(); lastTriggerTime=now end
        end
    end
end))

trackConn(RunService.RenderStepped:Connect(function() espRefresh() end))

local camFOVCircle = nil
trackConn(RunService.Heartbeat:Connect(function(dt)
    local camcfg = getgenv().Lucent['Camera Aimbot']
    if not camcfg.Enabled then
        if camFOVCircle then camFOVCircle:Remove(); camFOVCircle=nil end
        return
    end
    if camcfg.Mode == "Always" then
        if targetPlayer and targetPlayer.Character then
            camLockActive=true; camLockTarget=targetPlayer
            camLockPart=getCamlockBodyPart(targetPlayer.Character)
        else camLockActive=false; camLockTarget=nil; camLockPart=nil end
    end
    if not (camLockActive and camLockTarget and camLockTarget.Character) then
        if camFOVCircle then camFOVCircle:Remove(); camFOVCircle=nil end
        return
    end
    if clearTargetIfInvalid() then return end
    local root = camLockTarget.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if getgenv().Lucent.Checks["Self Knock Check"] and isSelfKnocked() then return end
    local zoom = (camera.CFrame.Position - camera.Focus.Position).Magnitude
    local isFP       = zoom < 0.6 or camera.CameraType == Enum.CameraType.Track
    local isShiftLock = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    local isTP       = not isFP and not isShiftLock

    local cond = camcfg['Camera Aimbot Conditions'] or {}
    local allowed = (cond['First Person'] == nil or cond['First Person'] and isFP)
                 or (cond['Third Person'] == nil or cond['Third Person'] and (isTP or isShiftLock))
    if not allowed then return end
    local newPart = getCamlockBodyPart(camLockTarget.Character)
    if not newPart then return end
    local fov = camcfg.FOV
    local inFOV = false
    local radius = tonumber(fov.Radius) or 155
    -- skip FOV gate entirely in Automatic mode
    if getgenv().Lucent['Targeting']['Target Mode'] == "Automatic" then
        inFOV = true
    elseif fov["X Left"] then
        local char=camLockTarget.Character; local hrp=char:FindFirstChild("HumanoidRootPart"); local ut=char:FindFirstChild("UpperTorso")
        if hrp then
            local xL=fov["X Left"] or 10; local xR=fov["X Right"] or 10
            local yU=fov["Y Upper"] or 10; local yLo=fov["Y Lower"] or 10
            local zL=fov["Z Left"] or 10; local zR=fov["Z Right"] or 10
            local bPos=(ut or hrp).Position; local lk=hrp.CFrame.LookVector
            local fc=CFrame.lookAt(Vector3.new(),Vector3.new(lk.X,0,lk.Z))
            local bs=Vector3.new(xL+xR,yU+yLo,zL+zR)
            local bo=fc:VectorToWorldSpace(Vector3.new((xR-xL)/2,(yU-yLo)/2,(zR-zL)/2))
            local bCF=CFrame.new(bPos+bo)*fc
            local mp=UserInputService:GetMouseLocation(); local ray=camera:ViewportPointToRay(mp.X,mp.Y)
            local lo=bCF:PointToObjectSpace(ray.Origin); local ld=bCF:VectorToObjectSpace(ray.Direction).Unit
            local half=bs/2; local tmin,tmax=-math.huge,math.huge
            for _,ax in ipairs({"X","Y","Z"}) do
                local o,d,s=lo[ax],ld[ax],half[ax]
                if math.abs(d)<1e-6 then if o<-s or o>s then tmax=-1 break end
                else local t1,t2=(-s-o)/d,(s-o)/d; if t1>t2 then t1,t2=t2,t1 end
                    tmin=math.max(tmin,t1); tmax=math.min(tmax,t2) end
            end
            inFOV = tmax >= 0 and tmin <= tmax
        end
    else
        local mousePos=UserInputService:GetMouseLocation(); local sp=camera:WorldToViewportPoint(newPart.Position)
        inFOV = sp.Z>0 and (Vector2.new(sp.X,sp.Y)-mousePos).Magnitude<=radius
    end
    if not inFOV then return end
    camLockPart = newPart
    if tick() - lastCamUpdate < CAM_UPDATE_RATE then return end
    lastCamUpdate = tick()
    local targetPos = camLockPart.Position
    local distance = (camera.CFrame.Position - root.Position).Magnitude
    local smoothX, smoothY = getCameraSmoothness(distance)
    local humanize = camcfg.Humanize
    local targetCF = CFrame.new(camera.CFrame.Position, targetPos)
    if humanize.Bezier and humanize.Enabled then
        local scale=math.clamp(humanize.Scale or 0.25,0,1); local chaos=scale*15
        local control=camera.CFrame.Position:Lerp(targetPos,0.5)+Vector3.new(math.random(-chaos,chaos),math.random(-chaos,chaos),math.random(-chaos,chaos))
        local t=(tick()%1); local bez=camera.CFrame.Position:Lerp(control,t):Lerp(targetPos,t)
        targetCF=CFrame.new(camera.CFrame.Position,bez)
        smoothX=smoothX*(1-scale*0.6); smoothY=smoothY*(1-scale*0.6)
    end
    local factorX=1-math.exp(-smoothX*dt*60); local factorY=1-math.exp(-smoothY*dt*60)
    camera.CFrame = camera.CFrame:Lerp(targetCF, math.max(factorX, factorY))
    if camcfg.FOV['Show FOV'] then
        if not camFOVCircle then
            camFOVCircle=Drawing.new("Circle"); camFOVCircle.Thickness=1.5
            camFOVCircle.Filled=false; camFOVCircle.Transparency=1
            camFOVCircle.Color=Color3.new(1,1,1); camFOVCircle.Visible=true
        end
        local ml=UserInputService:GetMouseLocation()
        camFOVCircle.Position=Vector2.new(ml.X,ml.Y); camFOVCircle.Radius=radius
    elseif camFOVCircle then camFOVCircle:Remove(); camFOVCircle=nil end
end))

-- Pre-compute every RenderStepped so the hook does zero heavy work
local _silentAimPos  = nil
local _silentAimPart = nil
local _silentActive  = false
local _silentFrame   = 0
local _silentHitCache = nil

trackConn(RunService.RenderStepped:Connect(function()
    _silentAimPos  = nil
    _silentAimPart = nil
    _silentActive  = false
    _silentFrame   = _silentFrame + 1

    local sa = getgenv().Lucent['Silent Aimbot']
    if not sa.Enabled then return end
    if not targetPlayer or not targetPlayer.Character then _silentHitCache=nil; return end

    -- FOV gate (skip in Automatic mode)
    local targetMode = getgenv().Lucent['Targeting']['Target Mode']
    local isSelectMode = targetMode == "Select"
    local forceHit = isSelectMode and getgenv().Lucent['Select Only Features']['Force Hit']
    if not forceHit and targetMode ~= "Automatic" and not isMouseInSilentFOV() then return end

    -- distance check
    local distCheck = sa['Distance Check']
    if distCheck and distCheck['Enabled'] then
        local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        local tHRP  = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP and tHRP and (myHRP.Position - tHRP.Position).Magnitude > distCheck['Max Distance'] then return end
    end

    -- get hit data every frame for accuracy
    local hitData
    if forceHit then
        local head = targetPlayer.Character:FindFirstChild("Head")
        if head and head:IsA("BasePart") then hitData = { Part=head, Position=head.Position } end
    else
        hitData = getClosestBodyPart(targetPlayer.Character)
    end
    if not hitData or not hitData.Part then _silentHitCache=nil; return end
    _silentHitCache = hitData

    local pos  = hitData.Position
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local pred = sa.Prediction

    -- prediction
    if root and (pred.X ~= 0 or pred.Y ~= 0 or pred.Z ~= 0) then
        pos = pos + root.Velocity * Vector3.new(pred.X, pred.Y, pred.Z)
    end

    -- bullet projection
    local bp = sa['Bullet Projection']
    if bp and bp['Enabled'] and bp['Distance'] and bp['Distance'] > 0 then
        local dir = pos - camera.CFrame.Position
        if dir.Magnitude > 0.01 then pos = pos + dir.Unit * bp['Distance'] end
    end

    -- clamp Y
    if root then
        local cc = sa['Clamp Y']
        if cc and cc['Enabled'] then
            local vel = root.Velocity
            local pingMs = 60
            pcall(function() pingMs = localPlayer:GetNetworkPing() * 1000 end)
            local travelTime = math.clamp(pingMs/1000, 0.02, 0.3)
            local halfH = root.Size.Y * 0.5
            local minY
            if cc['Dynamic'] then
                if math.abs(vel.Y) > 4 then
                    minY = math.min(root.Position.Y, root.Position.Y + vel.Y*travelTime) - halfH - 0.5
                else
                    minY = root.Position.Y - halfH - 0.15
                end
            else
                minY = root.Position.Y - halfH - (cc['Value'] or 0.5)
            end
            if pos.Y < minY then
                if cc['Smooth'] then
                    local f = math.clamp(cc['Smooth Factor'] or 0.65, 0, 1)
                    pos = Vector3.new(pos.X, pos.Y + (minY + 0.1 - pos.Y) * (1 - f), pos.Z)
                else
                    pos = Vector3.new(pos.X, minY + 0.1, pos.Z)
                end
            end
        end
    end

    -- anti curve
    local acCfg = getgenv().Lucent['Anti Curve']
    if acCfg and acCfg['Enabled'] then
        local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local myVel   = myHRP.Velocity
            local mySpeed = Vector3.new(myVel.X, 0, myVel.Z).Magnitude
            if mySpeed > 1 then
                local angle = acCfg['Angle'] or 0.9
                local wc = acCfg['Weapon Configuration']
                if wc and wc['Enabled'] then
                    local wcfg = wc[getWeaponCategory()] or wc['Others']
                    if wcfg then angle = wcfg['Angle'] or angle end
                end
                pos = pos - (Vector3.new(myVel.X,0,myVel.Z).Unit * (mySpeed/16) * angle)
            end
        end
    end

    _silentAimPos  = pos
    _silentAimPart = hitData.Part
    _silentActive  = true
end))

local originalIndex
originalIndex = hookmetamethod(game, "__index", function(t, k)
    if not rawequal(t, mouse) then return originalIndex(t, k) end
    if k ~= "Hit" and k ~= "Target" and k ~= "UnitRay" then return originalIndex(t, k) end
    if not _silentActive or not _silentAimPos then return originalIndex(t, k) end
    if k == "Target"  then return _silentAimPart end
    if k == "Hit"     then return CFrame.new(_silentAimPos) end
    if k == "UnitRay" then
        local cp = camera.CFrame.Position
        return Ray.new(cp, (_silentAimPos - cp).Unit * 1000)
    end
    return originalIndex(t, k)
end)

local originalRandom = math.random
originalRandom = hookfunction(math.random, function(...)
    local args = { ... }
    if checkcaller() then return originalRandom(...) end
    local isSpreadCall = false
    if #args == 0 then
        isSpreadCall = true
    elseif #args == 2 and type(args[1]) == "number" and type(args[2]) == "number" then
        local a, b = args[1], args[2]
        if (a == -0.1 and b == 0.05) or (a >= -0.15 and a <= -0.05 and b >= 0.03 and b <= 0.07) then
            isSpreadCall = true
        end
    elseif #args == 1 and type(args[1]) == "number" then
        local a = args[1]
        if a == -0.1 or a == -0.05 or (a >= -0.15 and a <= -0.03) then isSpreadCall = true end
    end
    if not isSpreadCall then return originalRandom(...) end
    local spreadMods = getgenv().Lucent and getgenv().Lucent['Spread Modifications']
    if not spreadMods or not spreadMods.Enabled then return originalRandom(...) end
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local tool = character:FindFirstChildOfClass("Tool")
    local toolName = tool and tool.Name or ""
    toolName = toolName:gsub("%[",""):gsub("%]","")
    local weaponConfig = spreadMods[toolName]
    if not weaponConfig then return originalRandom(...) end
    local multiplier = 1
    if spreadMods.Mode == "Randomized" then
        local min = math.clamp(tonumber(weaponConfig.Min) or 0, 0, 1)
        local max = math.clamp(tonumber(weaponConfig.Max) or 1, 0, 1)
        if min > max then min,max=max,min end
        multiplier = min + (originalRandom() * (max - min))
    else
        multiplier = math.clamp(tonumber(weaponConfig.Fixed) or 1, 0, 1)
    end
    return originalRandom(...) * multiplier
end)

local rfLastFire = 0
local rfFiring   = false
local rfPatched  = {}  -- cache so we never patch same tool twice

local function rfPatchTool(tool)
    if rfPatched[tool] then return end
    rfPatched[tool] = true
    pcall(function()
        for _, conn in ipairs(getconnections(tool.Activated)) do
            repeat
                local ok, info = pcall(debug.getinfo, conn.Function)
                if not ok or not info then break end
                for i = 1, info.nups do
                    local ok2, val = pcall(debug.getupvalue, conn.Function, i)
                    if ok2 and type(val) == "number" and val >= 0.05 and val <= 3.0 then
                        pcall(debug.setupvalue, conn.Function, i, 0)
                    end
                end
            until true
        end
    end)
end

local function rfAllowed(tool)
    if not tool or tool.Name == '[Knife]' then return false end
    local cfg = getgenv().Lucent['Rapid Fire']
    if not cfg or not cfg['Enabled'] then return false end
    local weapons = cfg['Weapons']
    if weapons and #weapons > 0 then
        for _, w in ipairs(weapons) do if tool.Name==w then return true end end
        return false
    end
    return true
end

local function rfWatchChar(char)
    if not char then return end
    char.ChildAdded:Connect(function(obj)
        if not obj:IsA("Tool") then return end
        task.wait(0.05)
        if rfAllowed(obj) then rfPatchTool(obj) end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    rfFiring = true
    task.spawn(function()
        while rfFiring do
            local char = localPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if rfAllowed(tool) then
                local delay = getgenv().Lucent['Rapid Fire']['Delay'] or 0
                local now = tick()
                if now - rfLastFire >= delay then pcall(function() tool:Activate() end); rfLastFire=now end
                task.wait(delay > 0 and delay or 0.03)
            else task.wait(0.05) end
        end
    end)
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then rfFiring = false end
end)

if localPlayer.Character then rfWatchChar(localPlayer.Character) end
trackConn(localPlayer.CharacterAdded:Connect(rfWatchChar))
for _, tool in ipairs(localPlayer.Backpack:GetChildren()) do
    if rfAllowed(tool) then task.spawn(rfPatchTool, tool) end
end
trackConn(localPlayer.Backpack.ChildAdded:Connect(function(tool)
    if not tool:IsA("Tool") then return end
    task.wait(0.05)
    if rfAllowed(tool) then rfPatchTool(tool) end
end))

-- Hitbox Expander
trackConn(RunService.Heartbeat:Connect(function()
    local cfg = getgenv().Lucent['Hitbox Expander']
    if not cfg or not cfg['Enabled'] then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(cfg['Size'], cfg['Size'], cfg['Size'])
                hrp.Transparency = 1
            end
        end
    end
end))

-- Super Jump
trackConn(RunService.RenderStepped:Connect(function()
    if superJumpEnabled and getgenv().Lucent['Super Jump']['Enabled'] then
        local hum = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            if hum.JumpPower ~= getgenv().Lucent['Super Jump']['Jump Power'] then
                hum.JumpPower = getgenv().Lucent['Super Jump']['Jump Power']
            end
        end
    end
end))

-- Advanced Adonis Anti-Cheat Bypass
task.spawn(function()
    pcall(function()
        -- Disable detection by hiding executor signs
        _G.ExecutorDetected = false
        getgenv().ExecutorDetected = false
        
        -- Hide in environment
        local oldGetEnv = getfenv
        getfenv = function(...) 
            local env = oldGetEnv(...)
            if env then
                env.Adonis = nil
                env.Admin = nil
            end
            return env
        end
        
        -- Anti teleport detection
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        if localPlayer and localPlayer.Character then
            local rootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CanCollide = true
                rootPart.CanQuery = true
            end
        end
        
        -- Block admin commands from executing
        local scriptInProgress = {}
        local function preventExecution()
            local env = getfenv(1)
            while env do
                env.script = nil
                env.owner = nil
                env.Command = nil
                env = getfenv(2)
                if env == getfenv(1) then break end
            end
        end
        
        preventExecution()
    end)
end)
