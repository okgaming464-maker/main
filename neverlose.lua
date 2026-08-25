local _zzzConfig = shared.zzz and shared.zzz.Foundations and shared.zzz.Foundations.Extras and shared.zzz.Foundations.Extras['Avatar Spoofer Customization']

local CONFIG = {
    target = _zzzConfig and _zzzConfig['Avatar'] and _zzzConfig['Avatar']['UserId'] or "Mqy1",
    zjqfhm = {
        enabled    = _zzzConfig and _zzzConfig['Character'] and (_zzzConfig['Character']['Scaling'] ~= '') or true,
        width      = (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Skinny') and 0.52 or (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Fat') and 1.5 or 1.0,
        depth      = (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Skinny') and 0.52 or (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Fat') and 1.5 or 1.0,
        height     = (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Fat') and 1.2 or 1.0,
        head       = (_zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Scaling'] == 'Fat') and 1.2 or 1.0,
        proportion = 0.00,
        bodyType   = 0.00,
        enforceIntervalSeconds = 0.8,
    },
    headless = {
        enabled = _zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Headless'] or false,
        enforceIntervalSeconds = 0.8,
    },
    korblox = {
        enabled = _zzzConfig and _zzzConfig['Character'] and _zzzConfig['Character']['Korblox'] or false,
        enforceIntervalSeconds = 0.8,
    },
}

do
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")

local localPlayer  = Players.LocalPlayer
local targetUserId = nil
local appearanceChildConn  = nil
local appearanceScaleValueConns = {}
local characterAddedConn   = nil
local applySerial  = 0
local fghqtm       = 0

local AVATAR_CACHE_TTL_SECONDS   = 20
local RESOLVED_USERID_TTL_SECONDS = 600
local faceTextureCache    = {}  
local faceTextureCacheTime = {}  
local descriptionCache    = {}
local appearanceModelCache = {}
local appearanceInfoCache  = {}
local resolvedUserIdCache  = {}
local resolvedUserIdCacheTime = {}
local CACHE_MAX_ENTRIES = {
    faceTexture     = 80,
    description     = 40,
    appearanceModel = 24,
    appearanceInfo  = 60,
    resolvedUserId  = 120,
    animationSet    = 64,
    emoteData       = 80,
}

local okEnv, env = pcall(function() return getgenv() end)
local stateKey   = "__CopyOutfitState"
local prevState  = nil
if okEnv and env then
    prevState = env[stateKey]
    if prevState and type(prevState.teardown) == "function" then
        pcall(prevState.teardown)
    end
end
local runtimeState = {
    currentUserId  = nil,
    active         = true,
    teardown       = nil,
    colorSnapshot  = nil,
}
if okEnv and env then
    env[stateKey] = runtimeState
end

local function korbloxBackendLegAssetId()
    if okEnv and env then
        local v = env.KorbloxRightLegAssetId
        if type(v) == "number" then
            return v
        end
    end
    return nil
end

local COPY_CLASSES = { "Shirt", "Pants", "ShirtGraphic", "Accessory", "Hat", "BodyColors", "CharacterMesh" }
local COPY_CLASS_SET = {}
for _, cls in ipairs(COPY_CLASSES) do COPY_CLASS_SET[cls] = true end

local SCALE_VALUE_NAMES = {
    "BodyHeightScale","BodyWidthScale","BodyDepthScale",
    "HeadScale","BodyTypeScale","BodyProportionScale",
}

local SCALE_VALUE_SET = {}
for _, scaleName in ipairs(SCALE_VALUE_NAMES) do
    SCALE_VALUE_SET[scaleName] = true
end

local COPY_ANIMATION_FIELDS = {
    "ClimbAnimation","FallAnimation","IdleAnimation",
    "JumpAnimation","RunAnimation","SwimAnimation","WalkAnimation",
}

local BODY_PART_NAMES = {
    "Head",
    "Torso","UpperTorso","LowerTorso",
    "LeftArm","RightArm","LeftLeg","RightLeg",
    "LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot",
}

local function disconnectAppearanceHooks()
    if appearanceChildConn  then appearanceChildConn:Disconnect();  appearanceChildConn  = nil end
    for i = #appearanceScaleValueConns, 1, -1 do
        local conn = appearanceScaleValueConns[i]
        if conn and conn.Connected then conn:Disconnect() end
        appearanceScaleValueConns[i] = nil
    end
end

local function isCopyClass(className)      return COPY_CLASS_SET[className] == true end
local function shouldCloneClass(className) return isCopyClass(className) and className ~= "BodyColors" end
local function isAccessoryClass(className) return className == "Accessory" or className == "Hat" end

local function buildBasePartMap(model)
    local out = {}
    if not model then return out end
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("BasePart") then
            out[child.Name] = child
        end
    end
    return out
end

local function buildAttachmentCarrierMap(partMap)
    local carrier = {}
    for partName, part in pairs(partMap or {}) do
        for _, child in ipairs(part:GetChildren()) do
            if child:IsA("Attachment") then
                local prev = carrier[child.Name]
                if prev == nil then
                    carrier[child.Name] = partName
                elseif prev ~= partName then
                    carrier[child.Name] = false
                end
            end
        end
    end
    return carrier
end

local countMapEntries
local pruneTimestampedCache
local prunePairedTimestampCache
local cacheGetTimed
local cacheSetTimed
local cacheGetEntry
local cacheSetEntry

local function firstDecalTextureFromHead(head)
    if not head then return nil end
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") and child.Face == Enum.NormalId.Front and child.Texture ~= "" then
            return child.Texture
        end
    end
    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") and child.Texture ~= "" then return child.Texture end
    end
    return nil
end

local function cacheFaceTexture(userId, texture)
    if texture and texture ~= "" then
        cacheSetTimed(faceTextureCache, faceTextureCacheTime, userId, texture, CACHE_MAX_ENTRIES.faceTexture)
    end
    return texture
end

local function resolveFaceFromAssetId(assetId, userId)
    local okAsset, assetModel = pcall(function() return InsertService:LoadAsset(assetId) end)
    if okAsset and assetModel then
        local foundTexture = nil
        for _, inst in ipairs(assetModel:GetDescendants()) do
            if inst:IsA("Decal") and inst.Texture ~= "" then
                foundTexture = inst.Texture
                break
            end
        end
        assetModel:Destroy()
        if foundTexture then return cacheFaceTexture(userId, foundTexture) end
    end
    return cacheFaceTexture(userId, "rbxassetid://" .. tostring(assetId))
end

countMapEntries = function(map)
    local count = 0
    for _ in pairs(map) do count = count + 1 end
    return count
end

pruneTimestampedCache = function(cache, maxEntries, onEvict)
    local count = countMapEntries(cache)
    while count > maxEntries do
        local oldestKey, oldestTs = nil, math.huge
        for k, entry in pairs(cache) do
            local ts = (entry and entry.timestamp) or 0
            if ts < oldestTs then
                oldestTs = ts
                oldestKey = k
            end
        end
        if oldestKey == nil then break end
        local evicted = cache[oldestKey]
        cache[oldestKey] = nil
        if onEvict then onEvict(oldestKey, evicted) end
        count = count - 1
    end
end

prunePairedTimestampCache = function(valueCache, timeCache, maxEntries)
    local count = countMapEntries(valueCache)
    while count > maxEntries do
        local oldestKey, oldestTs = nil, math.huge
        for k in pairs(valueCache) do
            local ts = timeCache[k] or 0
            if ts < oldestTs then
                oldestTs = ts
                oldestKey = k
            end
        end
        if oldestKey == nil then break end
        valueCache[oldestKey] = nil
        timeCache[oldestKey] = nil
        count = count - 1
    end
end

local function cacheGetTimedNow(valueCache, timeCache, key, ttlSeconds)
    local value = valueCache[key]
    local ts = timeCache[key]
    if value ~= nil and ts and os.clock() - ts <= ttlSeconds then
        return value
    end
    if value ~= nil then valueCache[key] = nil end
    if ts ~= nil then timeCache[key] = nil end
    return nil
end

local function cacheSetTimedNow(valueCache, timeCache, key, value, maxEntries)
    valueCache[key] = value
    timeCache[key] = os.clock()
    prunePairedTimestampCache(valueCache, timeCache, maxEntries)
    return value
end

local function cacheGetEntryNow(cache, key, ttlSeconds, onExpire)
    local entry = cache[key]
    if not entry then return nil end
    if os.clock() - (entry.timestamp or 0) <= ttlSeconds then return entry end
    if onExpire then onExpire(entry) end
    cache[key] = nil
    return nil
end

local function cacheSetEntryNow(cache, key, entry, maxEntries, onEvict)
    cache[key] = entry
    pruneTimestampedCache(cache, maxEntries, onEvict)
    return entry
end

cacheGetTimed = cacheGetTimedNow
cacheSetTimed = cacheSetTimedNow
cacheGetEntry = cacheGetEntryNow
cacheSetEntry = cacheSetEntryNow

local function getCharacterAppearanceModel(userId)
    local entry = cacheGetEntry(appearanceModelCache, userId, AVATAR_CACHE_TTL_SECONDS, function(expired)
        if expired and expired.model then
            pcall(function() expired.model:Destroy() end)
        end
    end)
    if entry and entry.model then
        local okClone, clone = pcall(function() return entry.model:Clone() end)
        if okClone and clone then return clone end
    end

    local ok, model = false, nil
    for attempt = 1, 2 do
        local okAttempt, result = pcall(function() return Players:GetCharacterAppearanceAsync(userId) end)
        if okAttempt and result then
            ok, model = true, result
            break
        end
        if attempt == 1 then task.wait(0.15) end
    end
    if not (ok and model) then
        return nil
    end

    local okClone, stored = pcall(function() return model:Clone() end)
    if okClone and stored then
        local prev = appearanceModelCache[userId]
        if prev and prev.model then pcall(function() prev.model:Destroy() end) end
        cacheSetEntry(appearanceModelCache, userId, { model = stored, timestamp = os.clock() }, CACHE_MAX_ENTRIES.appearanceModel, function(_, entry)
            if entry and entry.model then
                pcall(function() entry.model:Destroy() end)
            end
        end)
    end
    return model
end

local function getTargetDescriptionCached(userId)
    local entry = cacheGetEntry(descriptionCache, userId, AVATAR_CACHE_TTL_SECONDS, function(expired)
        if expired and expired.desc then
            pcall(function() expired.desc:Destroy() end)
        end
    end)
    if entry and entry.desc then
        local okClone, clone = pcall(function() return entry.desc:Clone() end)
        if okClone and clone then return clone end
    end

    local okDesc, desc = pcall(function() return Players:GetHumanoidDescriptionFromUserId(userId) end)
    if not okDesc or not desc then
        return nil
    end

    local okStore, stored = pcall(function() return desc:Clone() end)
    if okStore and stored then
        local prev = descriptionCache[userId]
        if prev and prev.desc then pcall(function() prev.desc:Destroy() end) end
        cacheSetEntry(descriptionCache, userId, { desc = stored, timestamp = os.clock() }, CACHE_MAX_ENTRIES.description, function(_, entry)
            if entry and entry.desc then
                pcall(function() entry.desc:Destroy() end)
            end
        end)
    end

    local okRet, ret = pcall(function() return desc:Clone() end)
    return (okRet and ret) or desc
end

local function getCharacterAppearanceInfoCached(userId)
    local entry = cacheGetEntry(appearanceInfoCache, userId, AVATAR_CACHE_TTL_SECONDS)
    if entry and entry.info then return entry.info end

    local ok, info = pcall(function() return Players:GetCharacterAppearanceInfoAsync(userId) end)
    if ok and info then
        cacheSetEntry(appearanceInfoCache, userId, { info = info, timestamp = os.clock() }, CACHE_MAX_ENTRIES.appearanceInfo)
        return info
    end
    return nil
end

local function clearAvatarCaches()
    for userId, entry in pairs(descriptionCache) do
        if entry and entry.desc then pcall(function() entry.desc:Destroy() end) end
        descriptionCache[userId] = nil
    end
    for userId, entry in pairs(appearanceModelCache) do
        if entry and entry.model then pcall(function() entry.model:Destroy() end) end
        appearanceModelCache[userId] = nil
    end
    for userId in pairs(appearanceInfoCache)    do appearanceInfoCache[userId]    = nil end
    for userId in pairs(faceTextureCache)       do
        faceTextureCache[userId]     = nil
        faceTextureCacheTime[userId] = nil
    end
    for cacheKey in pairs(resolvedUserIdCacheTime) do
        resolvedUserIdCache[cacheKey] = nil
        resolvedUserIdCacheTime[cacheKey] = nil
    end
end

local function clearCopyChildren(char)
    for _, inst in ipairs(char:GetChildren()) do
        if isCopyClass(inst.ClassName) then pcall(function() inst:Destroy() end) end
    end
end

local function hasAnySourceBodyPart(model)
    for _, partName in ipairs(BODY_PART_NAMES) do
        if model:FindFirstChild(partName) then return true end
    end
    return false
end

local function normalizeForLookup(value)
    local v = string.lower(tostring(value or ""))
    v = string.gsub(v, "^@", "")
    v = string.gsub(v, "%s+", "")
    v = string.gsub(v, "_+", "")
    return v
end

local function findUserIdInServerByNameOrDisplay(inputText)
    local rawInput   = tostring(inputText or ""):gsub("^%s+",""):gsub("%s+$","")
    local needleRaw  = string.lower(rawInput)
    local needleNorm = normalizeForLookup(rawInput)
    if needleNorm == "" then return nil end

    local exactNameUserId    = nil
    local exactDisplayUserId = nil
    local exactDisplayCount  = 0
    local prefixCandidates   = {}

    for _, player in ipairs(Players:GetPlayers()) do
        local nameRaw    = string.lower(player.Name)
        local displayRaw = string.lower(player.DisplayName)
        local nameNorm   = normalizeForLookup(player.Name)
        local displayNorm= normalizeForLookup(player.DisplayName)

        if nameRaw == needleRaw or nameNorm == needleNorm then
            exactNameUserId = player.UserId
            break
        end
        if displayRaw == needleRaw or displayNorm == needleNorm then
            exactDisplayUserId = player.UserId
            exactDisplayCount  = exactDisplayCount + 1
        end
        local namePrefix    = (needleRaw ~= "" and string.sub(nameRaw,    1, #needleRaw)    == needleRaw)
                           or string.sub(nameNorm,    1, #needleNorm)    == needleNorm
        local displayPrefix = (needleRaw ~= "" and string.sub(displayRaw, 1, #needleRaw)    == needleRaw)
                           or string.sub(displayNorm, 1, #needleNorm)    == needleNorm
        if namePrefix or displayPrefix then
            prefixCandidates[#prefixCandidates + 1] = player.UserId
        end
    end

    if exactNameUserId               then return exactNameUserId    end
    if exactDisplayCount == 1        then return exactDisplayUserId end
    if #prefixCandidates > 0         then return prefixCandidates[1] end
    if exactDisplayUserId            then return exactDisplayUserId end
    return nil
end

local function resolveUserToId(userInput)
    if userInput == nil then return nil end
    if type(userInput) == "number" then return math.floor(userInput) end
    if type(userInput) ~= "string" then return nil end

    local trimmed = userInput:gsub("^%s+",""):gsub("%s+$","")
    if trimmed == "" then return nil end

    local numeric = tonumber(trimmed)
    if numeric then return math.floor(numeric) end

    local username = trimmed:gsub("^@","")
    if username == "" then return nil end

    local cacheKey = normalizeForLookup(username)
    if cacheKey == "" then return nil end

    local cachedUserId = cacheGetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, cacheKey, RESOLVED_USERID_TTL_SECONDS)
    if cachedUserId then return cachedUserId end

    local inServer = findUserIdInServerByNameOrDisplay(username)
    if inServer then
        return cacheSetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, cacheKey, inServer, CACHE_MAX_ENTRIES.resolvedUserId)
    end

    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if ok and uid then
        return cacheSetTimed(resolvedUserIdCache, resolvedUserIdCacheTime, cacheKey, uid, CACHE_MAX_ENTRIES.resolvedUserId)
    end
    return nil
end

if okEnv and env then
    env.__ResolveUserToIdShared = resolveUserToId
end

local function getDefaultTargetUserId()
    return resolveUserToId(CONFIG.target)
end

local function destroyColorSnapshot(snapshot)
    if not snapshot then return end
    if snapshot.bodyColors then
        pcall(function() snapshot.bodyColors:Destroy() end)
        snapshot.bodyColors = nil
    end
end

local function teardown()
    fghqtm = fghqtm + 1
    local previousSnapshot = runtimeState.colorSnapshot
    runtimeState.active       = false
    applySerial               = applySerial + 1
    runtimeState.currentUserId = nil
    destroyColorSnapshot(previousSnapshot)
    runtimeState.colorSnapshot = nil
    targetUserId = nil
    disconnectAppearanceHooks()
    if characterAddedConn then characterAddedConn:Disconnect(); characterAddedConn = nil end
    clearAvatarCaches()
    if okEnv and env then
        if env.__CopyOutfitColorSnapshot and env.__CopyOutfitColorSnapshot ~= previousSnapshot then
            destroyColorSnapshot(env.__CopyOutfitColorSnapshot)
        end
        env.__CopyOutfitColorSnapshot = nil
        if env[stateKey] == runtimeState then env[stateKey] = nil end
    end
end
runtimeState.teardown = teardown

local function snapshotCharacterColors(char)
    if not char then return nil end
    local snapshot = { bodyColors = nil, partColors = {} }
    local bc = char:FindFirstChildOfClass("BodyColors")
    if bc then snapshot.bodyColors = bc:Clone() end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("BasePart") then
            snapshot.partColors[child.Name] = child.BrickColor
        end
    end
    return snapshot
end

local function publishColorSnapshot(char)
    destroyColorSnapshot(runtimeState.colorSnapshot)
    local snapshot = snapshotCharacterColors(char)
    runtimeState.colorSnapshot = snapshot
    if okEnv and env then env.__CopyOutfitColorSnapshot = snapshot end
end

local function isApplyStillCurrent(applyToken)
    return runtimeState.active and applyToken == applySerial
end

local function applyFaceTexture(char, texture)
    local head = char:FindFirstChild("Head")
    if not head then return end

    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") and (child.Name == "face" or child.Face == Enum.NormalId.Front) then
            child:Destroy()
        end
    end

    if not texture or texture == "" then return end
    local decal = Instance.new("Decal")
    decal.Name    = "face"
    decal.Face    = Enum.NormalId.Front
    decal.Texture = texture
    decal.Parent  = head
end

local function resolveFaceTexture(userId, appearanceModel, targetDesc)
    local cached = cacheGetTimed(faceTextureCache, faceTextureCacheTime, userId, AVATAR_CACHE_TTL_SECONDS)
    if cached then return cached end

    local appearanceHead = appearanceModel and appearanceModel:FindFirstChild("Head")
    local direct = firstDecalTextureFromHead(appearanceHead)
    if direct then return cacheFaceTexture(userId, direct) end

    if targetDesc and targetDesc.Face and targetDesc.Face ~= 0 then
        return resolveFaceFromAssetId(targetDesc.Face, userId)
    end

    local info = getCharacterAppearanceInfoCached(userId)
    if info and info.assets then
        for _, asset in ipairs(info.assets) do
            if asset.assetType and asset.assetType.id == 18 and asset.id then
                return resolveFaceFromAssetId(asset.id, userId)
            end
        end
    end

    local okModel, tempModel = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
    if okModel and tempModel then
        local tempHead = tempModel:FindFirstChild("Head")
        local tempTexture = firstDecalTextureFromHead(tempHead)
        tempModel:Destroy()
        if tempTexture then return cacheFaceTexture(userId, tempTexture) end
    end

    return nil
end

local function buildSourcePartSizeMap(srcModel)
    local sizes = {}
    for _, part in ipairs(srcModel:GetChildren()) do
        if part:IsA("BasePart") then sizes[part.Name] = part.Size end
    end
    return sizes
end

local function scaleAccessoryOnce(acc, char, sourcePartSizeMap, charPartMap, attachmentCarrierMap)
    local handle = acc:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return end

    local matchedPartName = nil
    for _, hChild in ipairs(handle:GetChildren()) do
        if hChild:IsA("Attachment") then
            local carrier = attachmentCarrierMap and attachmentCarrierMap[hChild.Name] or nil
            if type(carrier) == "string" then
                matchedPartName = carrier
                break
            end
            if carrier == false then
                local scanMap = charPartMap or buildBasePartMap(char)
                for partName, bodyPart in pairs(scanMap) do
                    if bodyPart and bodyPart:IsA("BasePart") and bodyPart:FindFirstChild(hChild.Name) then
                        matchedPartName = partName
                        break
                    end
                end
            end
        end
        if matchedPartName then break end
    end

    if not handle:GetAttribute("_cpBaseSizeX") then
        handle:SetAttribute("_cpBaseSizeX", handle.Size.X)
        handle:SetAttribute("_cpBaseSizeY", handle.Size.Y)
        handle:SetAttribute("_cpBaseSizeZ", handle.Size.Z)
        for _, hChild in ipairs(handle:GetChildren()) do
            if hChild:IsA("Attachment") then
                hChild:SetAttribute("_cpBasePosX", hChild.Position.X)
                hChild:SetAttribute("_cpBasePosY", hChild.Position.Y)
                hChild:SetAttribute("_cpBasePosZ", hChild.Position.Z)
            end
        end
        local sm0 = handle:FindFirstChildOfClass("SpecialMesh")
        if sm0 then
            sm0:SetAttribute("_cpBaseScaleX", sm0.Scale.X)
            sm0:SetAttribute("_cpBaseScaleY", sm0.Scale.Y)
            sm0:SetAttribute("_cpBaseScaleZ", sm0.Scale.Z)
        end
    end

    local scale = nil
    if matchedPartName then
        local srcSize = sourcePartSizeMap[matchedPartName]
        local dstPart = char:FindFirstChild(matchedPartName)
        if srcSize and dstPart and dstPart:IsA("BasePart") then
            local sx = math.max(srcSize.X, 0.001)
            local sy = math.max(srcSize.Y, 0.001)
            local sz = math.max(srcSize.Z, 0.001)
            scale = (dstPart.Size.X/sx + dstPart.Size.Y/sy + dstPart.Size.Z/sz) / 3
        end
    end

    local function applyScale(s)
        local bx = handle:GetAttribute("_cpBaseSizeX")
        local by = handle:GetAttribute("_cpBaseSizeY")
        local bz = handle:GetAttribute("_cpBaseSizeZ")
        if bx and by and bz then
            pcall(function() handle.Size = Vector3.new(bx*s, by*s, bz*s) end)
        end
        for _, hChild in ipairs(handle:GetChildren()) do
            if hChild:IsA("Attachment") then
                local apx = hChild:GetAttribute("_cpBasePosX")
                local apy = hChild:GetAttribute("_cpBasePosY")
                local apz = hChild:GetAttribute("_cpBasePosZ")
                if apx and apy and apz then
                    pcall(function() hChild.Position = Vector3.new(apx*s, apy*s, apz*s) end)
                end
            end
        end
        local sm = handle:FindFirstChildOfClass("SpecialMesh")
        if sm then
            local msx = sm:GetAttribute("_cpBaseScaleX")
            local msy = sm:GetAttribute("_cpBaseScaleY")
            local msz = sm:GetAttribute("_cpBaseScaleZ")
            pcall(function()
                if msx and msy and msz then
                    sm.Scale = Vector3.new(msx*s, msy*s, msz*s)
                else
                    sm.Scale = sm.Scale * s
                end
            end)
        end
    end

    if scale and math.abs(scale - 1) > 0.01 then
        applyScale(scale)
    else
        applyScale(1)
    end
end

local function scaleAllAccessories(char, sourcePartSizeMap, charPartMap, attachmentCarrierMap)
    for _, child in ipairs(char:GetChildren()) do
        if isAccessoryClass(child.ClassName) then
            scaleAccessoryOnce(child, char, sourcePartSizeMap, charPartMap, attachmentCarrierMap)
        end
    end
end

local function applyBodyFromDescription(targetDesc, char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not targetDesc then return false end
    for _, fieldName in ipairs(COPY_ANIMATION_FIELDS) do
        pcall(function() targetDesc[fieldName] = 0 end)
    end
    local okApply = pcall(function() hum:ApplyDescription(targetDesc) end)
    return okApply
end

local function toColor3(value)
    local kind = typeof(value)
    if kind == "Color3"    then return value end
    if kind == "BrickColor"then return value.Color end
    if kind == "number"    then
        local ok, brick = pcall(function() return BrickColor.new(value) end)
        if ok and brick then return brick.Color end
    end
    return nil
end

local function enforceSkinColorFromDescription(targetDesc, char, sourceModel, preferredSnapshot)
    if not char then return end
    local bodyColors = char:FindFirstChildOfClass("BodyColors")
    if not bodyColors then
        bodyColors = Instance.new("BodyColors")
        bodyColors.Parent = char
    end

    local preferredBodyColors = preferredSnapshot and preferredSnapshot.bodyColors or nil
    local sourceBodyColors = sourceModel and sourceModel:FindFirstChildOfClass("BodyColors")

    local headColor      = (preferredBodyColors and preferredBodyColors.HeadColor3)      or (targetDesc and toColor3(targetDesc.HeadColor))      or (sourceBodyColors and sourceBodyColors.HeadColor3)
    local leftArmColor   = (preferredBodyColors and preferredBodyColors.LeftArmColor3)   or (targetDesc and toColor3(targetDesc.LeftArmColor))   or (sourceBodyColors and sourceBodyColors.LeftArmColor3)
    local rightArmColor  = (preferredBodyColors and preferredBodyColors.RightArmColor3)  or (targetDesc and toColor3(targetDesc.RightArmColor))  or (sourceBodyColors and sourceBodyColors.RightArmColor3)
    local torsoColor     = (preferredBodyColors and preferredBodyColors.TorsoColor3)     or (targetDesc and toColor3(targetDesc.TorsoColor))     or (sourceBodyColors and sourceBodyColors.TorsoColor3)
    local leftLegColor   = (preferredBodyColors and preferredBodyColors.LeftLegColor3)   or (targetDesc and toColor3(targetDesc.LeftLegColor))   or (sourceBodyColors and sourceBodyColors.LeftLegColor3)
    local rightLegColor  = (preferredBodyColors and preferredBodyColors.RightLegColor3)  or (targetDesc and toColor3(targetDesc.RightLegColor))  or (sourceBodyColors and sourceBodyColors.RightLegColor3)

    local preferredPartColors = preferredSnapshot and preferredSnapshot.partColors or nil
    local function pickPartColor(partName, fallbackColor)
        if preferredPartColors then
            local preferred = toColor3(preferredPartColors[partName])
            if preferred then return preferred end
        end
        return fallbackColor
    end

    if headColor     then bodyColors.HeadColor3      = headColor     end
    if leftArmColor  then bodyColors.LeftArmColor3   = leftArmColor  end
    if rightArmColor then bodyColors.RightArmColor3  = rightArmColor end
    if torsoColor    then bodyColors.TorsoColor3     = torsoColor    end
    if leftLegColor  then bodyColors.LeftLegColor3   = leftLegColor  end
    if rightLegColor then bodyColors.RightLegColor3  = rightLegColor end

    local partColorMap = {
        Head          = pickPartColor("Head", headColor),
        LeftArm       = pickPartColor("LeftArm", leftArmColor),      RightArm       = pickPartColor("RightArm", rightArmColor),
        ["Left Arm"]  = pickPartColor("Left Arm", leftArmColor),    ["Right Arm"]  = pickPartColor("Right Arm", rightArmColor),
        LeftUpperArm  = pickPartColor("LeftUpperArm", leftArmColor), LeftLowerArm   = pickPartColor("LeftLowerArm", leftArmColor), LeftHand   = pickPartColor("LeftHand", leftArmColor),
        RightUpperArm = pickPartColor("RightUpperArm", rightArmColor), RightLowerArm  = pickPartColor("RightLowerArm", rightArmColor), RightHand  = pickPartColor("RightHand", rightArmColor),
        Torso         = pickPartColor("Torso", torsoColor),          UpperTorso     = pickPartColor("UpperTorso", torsoColor),    LowerTorso = pickPartColor("LowerTorso", torsoColor),
        LeftLeg       = pickPartColor("LeftLeg", leftLegColor),      LeftUpperLeg   = pickPartColor("LeftUpperLeg", leftLegColor), LeftLowerLeg  = pickPartColor("LeftLowerLeg", leftLegColor), LeftFoot  = pickPartColor("LeftFoot", leftLegColor),
        ["Left Leg"]  = pickPartColor("Left Leg", leftLegColor),    ["Right Leg"]  = pickPartColor("Right Leg", rightLegColor),
        RightLeg      = pickPartColor("RightLeg", rightLegColor),    RightUpperLeg  = pickPartColor("RightUpperLeg", rightLegColor), RightLowerLeg = pickPartColor("RightLowerLeg", rightLegColor),RightFoot = pickPartColor("RightFoot", rightLegColor),
    }
    for partName, color3 in pairs(partColorMap) do
        if color3 then
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                pcall(function() part.Color = color3 end)
            end
        end
    end
end


local pqzlwt = 0

local function kfdkdl(character)
    local cfg = CONFIG and CONFIG.zjqfhm
    if not cfg or cfg.enabled == false then return end
    if not character or not character.Parent then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local map = {
        BodyWidthScale      = cfg.width,
        BodyDepthScale      = cfg.depth,
        BodyHeightScale     = cfg.height,
        HeadScale           = cfg.head,
        BodyProportionScale = cfg.proportion,
        BodyTypeScale       = cfg.bodyType,
    }
    for name, value in pairs(map) do
        if type(value) == "number" then
            local nv = hum:FindFirstChild(name)
            if nv and nv:IsA("NumberValue") then
                if math.abs(nv.Value - value) > 0.001 then
                    pcall(function() nv.Value = value end)
                end
            end
        end
    end
end

local whklsd = { char = nil, head = nil, transparency = nil, decalBackup = nil }
local kblxbf = { char = nil, rightLeg = nil }

local function wqplhs_applyHeadless(character)
    if not character or not character.Parent then return end
    local cfg = CONFIG and CONFIG.headless
    local head = character:FindFirstChild("Head")
    if not (head and head:IsA("BasePart")) then
        whklsd = { char = nil, head = nil, transparency = nil, decalBackup = nil }
        return
    end
    if whklsd.char ~= character then
        whklsd = { char = character, head = nil, transparency = nil, decalBackup = nil }
    end
    if not cfg or cfg.enabled == false then
        if whklsd.head == head and whklsd.transparency ~= nil then
            pcall(function() head.Transparency = whklsd.transparency end)
            for _, rec in ipairs(whklsd.decalBackup or {}) do
                if rec and rec.inst and rec.inst.Parent == head and rec.inst:IsA("Decal") then
                    pcall(function() rec.inst.Transparency = rec.t end)
                end
            end
        end
        whklsd = { char = nil, head = nil, transparency = nil, decalBackup = nil }
        return
    end
    if whklsd.head ~= head or whklsd.transparency == nil then
        whklsd.head = head
        whklsd.transparency = head.Transparency
        whklsd.decalBackup = {}
        for _, ch in ipairs(head:GetChildren()) do
            if ch:IsA("Decal") then
                whklsd.decalBackup[#whklsd.decalBackup + 1] = { inst = ch, t = ch.Transparency }
            end
        end
    end
    pcall(function() head.Transparency = 1 end)
    for _, ch in ipairs(head:GetChildren()) do
        if ch:IsA("Decal") then
            pcall(function() ch.Transparency = 1 end)
        end
    end
end

local function wqplkx_applyKorblox(character)
    if not character or not character.Parent then return end
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hum then
        kblxbf = { char = nil, rightLeg = nil }
        return
    end
    local cfg = CONFIG and CONFIG.korblox
    if kblxbf.char ~= character then
        kblxbf = { char = character, rightLeg = nil }
    end
    if not cfg or cfg.enabled == false then
        if kblxbf.char == character and kblxbf.rightLeg ~= nil then
            pcall(function()
                local d = hum:GetAppliedDescription()
                if d then
                    d.RightLeg = kblxbf.rightLeg
                    if hum.ApplyDescriptionClientServer then
                        hum:ApplyDescriptionClientServer(d)
                    else
                        hum:ApplyDescription(d)
                    end
                end
            end)
        end
        kblxbf = { char = nil, rightLeg = nil }
        return
    end
    local assetId = korbloxBackendLegAssetId()
    if not assetId then
        return
    end
    local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
    if not ok or not desc then return end
    if kblxbf.rightLeg == nil then
        kblxbf.rightLeg = desc.RightLeg
    end
    if desc.RightLeg == assetId then return end
    pcall(function()
        desc.RightLeg = assetId
        if hum.ApplyDescriptionClientServer then
            hum:ApplyDescriptionClientServer(desc)
        else
            hum:ApplyDescription(desc)
        end
    end)
end

local function wqplnr_enforceClientCosmetics(character)
    wqplhs_applyHeadless(character)
    wqplkx_applyKorblox(character)
end

local function qvxmlnStartCosmeticWatch()
    fghqtm = fghqtm + 1
    local myToken = fghqtm
    local function intervalSec()
        local a = (CONFIG and CONFIG.headless and tonumber(CONFIG.headless.enforceIntervalSeconds)) or 0.8
        local b = (CONFIG and CONFIG.korblox and tonumber(CONFIG.korblox.enforceIntervalSeconds)) or 0.8
        if a <= 0 then a = 0.8 end
        if b <= 0 then b = 0.8 end
        return math.min(a, b)
    end
    task.spawn(function()
        while myToken == fghqtm do
            task.wait(intervalSec())
            if myToken ~= fghqtm then return end
            local char = localPlayer.Character
            if char and char.Parent then
                wqplnr_enforceClientCosmetics(char)
            end
        end
    end)
end

local function xmvnrp(character)
    pqzlwt = pqzlwt + 1
    local myToken = pqzlwt
    local cfg = CONFIG and CONFIG.zjqfhm
    local interval = (cfg and tonumber(cfg.enforceIntervalSeconds)) or 0.8
    task.spawn(function()
        while myToken == pqzlwt do
            task.wait(interval)
            if myToken ~= pqzlwt then return end
            local curChar = localPlayer.Character
            if not curChar or not curChar.Parent then
                character = nil
            else
                character = curChar
            end
            if character then
                kfdkdl(character)
            end
        end
    end)
end

if okEnv and env then
    env.nxhbtc = {
        Set = function(opts)
            if type(opts) ~= "table" then return end
            for k, v in pairs(opts) do
                if CONFIG.zjqfhm[k] ~= nil then CONFIG.zjqfhm[k] = v end
            end
            kfdkdl(localPlayer.Character)
        end,
        Enable = function()
            CONFIG.zjqfhm.enabled = true
            kfdkdl(localPlayer.Character)
            xmvnrp(localPlayer.Character)
        end,
        Disable = function()
            CONFIG.zjqfhm.enabled = false
            pqzlwt = pqzlwt + 1 
        end,
        Reapply = function()
            kfdkdl(localPlayer.Character)
        end,
    }
    env.wqplnm = {
        Reapply = function()
            wqplnr_enforceClientCosmetics(localPlayer.Character)
        end,
        Set = function(opts)
            if type(opts) ~= "table" then return end
            if type(opts.headless) == "table" then
                for k, v in pairs(opts.headless) do
                    if CONFIG.headless[k] ~= nil then CONFIG.headless[k] = v end
                end
            end
            if type(opts.korblox) == "table" then
                for k, v in pairs(opts.korblox) do
                    if CONFIG.korblox[k] ~= nil then CONFIG.korblox[k] = v end
                end
            end
            wqplnr_enforceClientCosmetics(localPlayer.Character)
            qvxmlnStartCosmeticWatch()
        end,
    }
end

local function applyAppearance(userId, char, applyToken)
    if not isApplyStillCurrent(applyToken) then return end

    local model = getCharacterAppearanceModel(userId)
    if not model then return end

    if not isApplyStillCurrent(applyToken) then model:Destroy(); return end

    clearCopyChildren(char)

    local sourceModel  = model
    local humModel     = nil
    local bodyModel    = nil
    local hasHead      = sourceModel:FindFirstChild("Head") ~= nil
    local hasAnyPart   = hasAnySourceBodyPart(sourceModel)

    if not hasHead or not hasAnyPart then
        local ok, created = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
        if ok and created then
            humModel = created
            sourceModel = humModel
        end
    end

    if not isApplyStillCurrent(applyToken) then
        if humModel then humModel:Destroy() end
        model:Destroy(); return
    end

    local targetDesc = getTargetDescriptionCached(userId)

    local bodyApplied = applyBodyFromDescription(targetDesc, char)
    task.wait()

    local postDescriptionColorSnapshot = nil
    if bodyApplied then
        postDescriptionColorSnapshot = snapshotCharacterColors(char)
    end

    local delayedSkinSnapshot = nil
    if postDescriptionColorSnapshot and postDescriptionColorSnapshot.bodyColors then
        delayedSkinSnapshot = {
            bodyColors = postDescriptionColorSnapshot.bodyColors:Clone(),
            partColors = {},
        }
        for partName, brickColor in pairs(postDescriptionColorSnapshot.partColors or {}) do
            delayedSkinSnapshot.partColors[partName] = brickColor
        end
    end

    if not isApplyStillCurrent(applyToken) then
        destroyColorSnapshot(postDescriptionColorSnapshot)
        destroyColorSnapshot(delayedSkinSnapshot)
        if bodyModel then bodyModel:Destroy() end
        if humModel then humModel:Destroy() end
        model:Destroy(); return
    end

    if bodyApplied and not bodyModel then
        local okBody, createdBody = pcall(function() return Players:CreateHumanoidModelFromUserId(userId) end)
        if okBody and createdBody then
            bodyModel = createdBody
        end
    end

    local bodySourceModel     = bodyModel or sourceModel
    local desiredFaceTexture  = resolveFaceTexture(userId, bodySourceModel, targetDesc)
    local sourcePartSizeMap   = buildSourcePartSizeMap(bodySourceModel)
    local charPartMap         = buildBasePartMap(char)
    local attachmentCarrierMap = buildAttachmentCarrierMap(charPartMap)

    for _, partName in ipairs(BODY_PART_NAMES) do
        if bodyApplied then
            if partName == "Head" then
                applyFaceTexture(char, desiredFaceTexture)
            end
        else
            local src  = bodySourceModel:FindFirstChild(partName) or sourceModel:FindFirstChild(partName)
            local dest = char:FindFirstChild(partName)
            if src and dest then
                dest.Transparency = src.Transparency

                local sm = src:FindFirstChildOfClass("SpecialMesh")
                local dm = dest:FindFirstChildOfClass("SpecialMesh")
                if sm then
                    if not dm then
                        dm = sm:Clone(); dm.Parent = dest
                    else
                        dm.MeshId = sm.MeshId; dm.TextureId = sm.TextureId
                        dm.Scale  = sm.Scale;  dm.Offset    = sm.Offset
                    end
                elseif dm then
                    dm:Destroy()
                end

                pcall(function()
                    if src:IsA("MeshPart") and dest:IsA("MeshPart") then
                        dest.MeshId   = src.MeshId
                        dest.TextureID = src.TextureID
                    end
                end)

                for _, att in ipairs(src:GetChildren()) do
                    if att:IsA("Attachment") then
                        local existing = dest:FindFirstChild(att.Name)
                        if existing then
                            existing.Position    = att.Position
                            existing.Orientation = att.Orientation
                        else
                            att:Clone().Parent = dest
                        end
                    end
                end

                if partName == "Head" then
                    applyFaceTexture(char, desiredFaceTexture)
                end
            end
        end
    end

    if not isApplyStillCurrent(applyToken) then
        destroyColorSnapshot(postDescriptionColorSnapshot)
        if bodyModel then bodyModel:Destroy() end
        if humModel then humModel:Destroy() end
        model:Destroy(); return
    end

    for _, inst in ipairs(sourceModel:GetChildren()) do
        if shouldCloneClass(inst.ClassName) then
            if bodyApplied and inst.ClassName == "CharacterMesh" then
            else
            local clone = inst:Clone()
            clone.Parent = char
            if isAccessoryClass(clone.ClassName) then
                scaleAccessoryOnce(clone, char, sourcePartSizeMap, charPartMap, attachmentCarrierMap)
            end
            end
        end
    end

    local rigRefreshToken = 0
    local function requestRigAndFaceRefresh(delaySeconds)
        rigRefreshToken = rigRefreshToken + 1
        local token = rigRefreshToken
        task.delay(delaySeconds or 0, function()
            if token ~= rigRefreshToken then return end
            if not isApplyStillCurrent(applyToken) then return end
            if not char.Parent then return end
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then pcall(function() h:BuildRigFromAttachments() end) end
            applyFaceTexture(char, desiredFaceTexture)
        end)
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:BuildRigFromAttachments() end) end

    if not isApplyStillCurrent(applyToken) then
        destroyColorSnapshot(postDescriptionColorSnapshot)
        destroyColorSnapshot(delayedSkinSnapshot)
        if bodyModel then bodyModel:Destroy() end
        if humModel then humModel:Destroy() end
        model:Destroy(); return
    end

    enforceSkinColorFromDescription(targetDesc, char, bodySourceModel, postDescriptionColorSnapshot)
    destroyColorSnapshot(postDescriptionColorSnapshot)
    applyFaceTexture(char, desiredFaceTexture)
    publishColorSnapshot(char)

   
    kfdkdl(char)
    wqplnr_enforceClientCosmetics(char)

    task.defer(function()
        local retryDelays = { 0.1, 0.28, 0.55 }
        for _, dt in ipairs(retryDelays) do
            task.wait(dt)
            if not isApplyStillCurrent(applyToken) then
                destroyColorSnapshot(delayedSkinSnapshot)
                return
            end
            if not char.Parent then
                destroyColorSnapshot(delayedSkinSnapshot)
                return
            end
            if delayedSkinSnapshot then
                if delayedSkinSnapshot.bodyColors then
                    local okClone, bcClone = pcall(function() return delayedSkinSnapshot.bodyColors:Clone() end)
                    if okClone and bcClone then
                        pcall(function()
                            local currentBC = char:FindFirstChildOfClass("BodyColors")
                            if currentBC then currentBC:Destroy() end
                            bcClone.Parent = char
                        end)
                    end
                end
                for partName, brickColor in pairs(delayedSkinSnapshot.partColors or {}) do
                    local part = char:FindFirstChild(partName)
                    if part and part:IsA("BasePart") and brickColor then
                        pcall(function() part.BrickColor = brickColor end)
                    end
                end
                enforceSkinColorFromDescription(nil, char, nil, delayedSkinSnapshot)
            else
                enforceSkinColorFromDescription(targetDesc, char, nil, nil)
            end

            kfdkdl(char)
            wqplnr_enforceClientCosmetics(char)
        end
        destroyColorSnapshot(delayedSkinSnapshot)
    end)

    disconnectAppearanceHooks()
    appearanceChildConn = char.ChildAdded:Connect(function(child)
        if isAccessoryClass(child.ClassName) then
            task.defer(function()
                if not isApplyStillCurrent(applyToken) then return end
                if not char.Parent then return end
                local livePartMap = buildBasePartMap(char)
                local liveCarrierMap = buildAttachmentCarrierMap(livePartMap)
                scaleAccessoryOnce(child, char, sourcePartSizeMap, livePartMap, liveCarrierMap)
                requestRigAndFaceRefresh(0.03)
            end)
        elseif child.Name == "Head" or child:IsA("Decal") then
            requestRigAndFaceRefresh(0.02)
        end
    end)

    task.spawn(function()
        local pulseDelays = { 0.05, 0.12, 0.24, 0.4, 0.65, 0.95 }
        for _, dt in ipairs(pulseDelays) do
            task.wait(dt)
            if not isApplyStillCurrent(applyToken) then return end
            if not char.Parent then return end
            requestRigAndFaceRefresh(0.02)
        end
    end)

    local scaleRefreshScheduled = false
    local scaleRefreshQueued = false
    local function scheduleScaleRefresh()
        if scaleRefreshScheduled then
            scaleRefreshQueued = true
            return
        end
        scaleRefreshScheduled = true
        task.delay(0.03, function()
            scaleRefreshScheduled = false
            if not isApplyStillCurrent(applyToken) then disconnectAppearanceHooks(); return end
            if not char.Parent then disconnectAppearanceHooks(); return end
            local livePartMap = buildBasePartMap(char)
            local liveCarrierMap = buildAttachmentCarrierMap(livePartMap)
            scaleAllAccessories(char, sourcePartSizeMap, livePartMap, liveCarrierMap)
            requestRigAndFaceRefresh(0.02)
            if scaleRefreshQueued then
                scaleRefreshQueued = false
                scheduleScaleRefresh()
            end
        end)
    end

    local function onScaleValueChanged()
        scheduleScaleRefresh()
    end

    local hScale = char:FindFirstChildOfClass("Humanoid")
    if hScale then
        local function tryBindScaleValue(nv)
            if not nv or not nv:IsA("NumberValue") then return end
            if not SCALE_VALUE_SET[nv.Name] then return end
            local conn = nv:GetPropertyChangedSignal("Value"):Connect(onScaleValueChanged)
            appearanceScaleValueConns[#appearanceScaleValueConns + 1] = conn
        end

        for _, child in ipairs(hScale:GetChildren()) do
            tryBindScaleValue(child)
        end

        local childAddedConn = hScale.ChildAdded:Connect(function(child)
            tryBindScaleValue(child)
        end)
        appearanceScaleValueConns[#appearanceScaleValueConns + 1] = childAddedConn
    end

    task.delay(0.2, onScaleValueChanged)

    if bodyModel then bodyModel:Destroy() end
    if humModel then humModel:Destroy() end
    model:Destroy()
end

local function cleanupForSwitch(char)
    disconnectAppearanceHooks()
    if not char then return end
    clearCopyChildren(char)
end

local function apply(userId)
    if not runtimeState.active then return end
    local char = localPlayer.Character
    if not char then return end

    applySerial               = applySerial + 1
    local thisApply           = applySerial
    targetUserId              = userId
    runtimeState.currentUserId = userId

    cleanupForSwitch(char)

    task.spawn(function()
        if not runtimeState.active then return end
        if thisApply ~= applySerial then return end
        applyAppearance(userId, char, thisApply)
    end)
end

if okEnv and env then
    local function setTarget(newTarget)
        local uid = resolveUserToId(newTarget)
        if not uid then return end
        targetUserId               = uid
        runtimeState.currentUserId = uid
        apply(uid)
    end
    local function reapplyTarget()
        local uid = runtimeState.currentUserId or targetUserId or getDefaultTargetUserId()
        if uid then apply(uid) end
    end
    local function useDefaultTarget()
        runtimeState.currentUserId = nil
        targetUserId = nil
        local uid = getDefaultTargetUserId()
        if uid then apply(uid) end
    end
    env.OutfitCopy = {
        SetTarget         = setTarget,
        SetTargetUserId   = setTarget,
        SetTargetUsername = setTarget,
        Reapply           = reapplyTarget,
        UseDefaultTarget  = useDefaultTarget,
        Cleanup           = teardown,
    }
    env.CopySetUserId        = setTarget
    env.CopyReapplyOutfit    = reapplyTarget
    env.CopyUseDefaultTarget = useDefaultTarget
    env.CopyOutfitCleanup    = teardown
end

characterAddedConn = localPlayer.CharacterAdded:Connect(function(char)
    if not runtimeState.active then return end
    local respawnToken = applySerial
    disconnectAppearanceHooks()
    local uid = runtimeState.currentUserId or targetUserId or getDefaultTargetUserId()
    if not uid then return end
    local hum = char:WaitForChild("Humanoid", 10)
    if not hum then return end
    task.wait(0.5)
    if not runtimeState.active or respawnToken ~= applySerial or not char.Parent then return end
    apply(uid)

    kfdkdl(char)
    wqplnr_enforceClientCosmetics(char)
    xmvnrp(char)
    qvxmlnStartCosmeticWatch()
end)

if localPlayer.Character then
    local hum = localPlayer.Character:WaitForChild("Humanoid", 10)
    if hum then
        local startupUserId = runtimeState.currentUserId or getDefaultTargetUserId()
        if startupUserId then apply(startupUserId) end
        kfdkdl(localPlayer.Character)
        wqplnr_enforceClientCosmetics(localPlayer.Character)
        xmvnrp(localPlayer.Character)
        qvxmlnStartCosmeticWatch()
    end
end

local LOCAL_PLAYER = localPlayer

local R15_FALLBACK_ANIMATIONS = {
    climb = "rbxassetid://507765644",
    fall  = "rbxassetid://507765000",
    jump  = "rbxassetid://507765000",
    run   = "rbxassetid://913376220",
    walk  = "rbxassetid://913402848",
    swim  = "rbxassetid://913384386",
    idle1 = "rbxassetid://507766388",
    idle2 = "rbxassetid://507766666",
}

local SLOT_SPECS = {
    { folder = "climb", fallback = R15_FALLBACK_ANIMATIONS.climb },
    { folder = "fall",  fallback = R15_FALLBACK_ANIMATIONS.fall  },
    { folder = "jump",  fallback = R15_FALLBACK_ANIMATIONS.jump  },
    { folder = "run",   fallback = R15_FALLBACK_ANIMATIONS.run   },
    { folder = "walk",  fallback = R15_FALLBACK_ANIMATIONS.walk  },
    { folder = "swim",  fallback = R15_FALLBACK_ANIMATIONS.swim  },
}

if env and env.__AnimationMimicState and env.__AnimationMimicState.cleanup then
    pcall(env.__AnimationMimicState.cleanup)
end

local animState = {
    connections              = {},
    originalByCharacter      = {},
    directControllerByChar   = {},
    lastTargetInput          = CONFIG.target,
    pinnedTargetUserId       = nil,
    lastSourceUserId         = nil,
    applyToken               = 0,
    animationSetCache        = {},
    active                   = true,
    settings = {
        autoApplyOnRespawn        = true,
        useFallbackWhenMissing    = true,
        useDirectTrackFallback    = true,
        cacheTtlSeconds           = 22,
        minLiveCoverage           = 1,
        replicateDescriptionToOthers = false,
        invalidateAnimationCacheOnTargetSwitch = false,
    },
}
if env then env.__AnimationMimicState = animState end

local function normalizeAnimationId(rawId)
    if rawId == nil then return nil end
    local numeric = tostring(rawId):match("%d+")
    if not numeric then return nil end
    if (tonumber(numeric) or 0) <= 0 then return nil end
    return "rbxassetid://" .. numeric
end

local function numericIdFromContentId(rawId)
    if not rawId then return nil end
    local numeric = tostring(rawId):match("%d+")
    return numeric and tonumber(numeric) or nil
end

local FALLBACK_ANIMATION_NUMERIC_IDS = {
    climb = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.climb),
    fall  = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.fall),
    jump  = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.jump),
    run   = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.run),
    walk  = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.walk),
    swim  = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.swim),
    idle1 = numericIdFromContentId(R15_FALLBACK_ANIMATIONS.idle1),
}

local function getLocalRigType()
    local character = LOCAL_PLAYER.Character
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.RigType or Enum.HumanoidRigType.R15
end

local function isCharacterR15(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid ~= nil and humanoid.RigType == Enum.HumanoidRigType.R15
end

local function normalizeAvatarType(rawType)
    if rawType == nil then return nil end
    local s = tostring(rawType):upper()
    if s:find("R15") or s == "2" then return "R15" end
    if s:find("R6")  or s == "1" then return "R6"  end
    return nil
end

local function getUserAvatarType(userId)
    local info = getCharacterAppearanceInfoCached(userId)
    return normalizeAvatarType(info and (info.playerAvatarType or info.PlayerAvatarType))
end

local function resolveTargetToUserId(target)
    return resolveUserToId(target)
end

local function rememberOriginal(character, animationObject)
    if not character or not animationObject then return end
    if not animState.originalByCharacter[character] then
        animState.originalByCharacter[character] = {}
    end
    if animState.originalByCharacter[character][animationObject] == nil then
        animState.originalByCharacter[character][animationObject] = animationObject.AnimationId
    end
end

local function resetCharacterAnimations(character)
    local saved = animState.originalByCharacter[character]
    if not saved then return false end
    for animationObject, originalId in pairs(saved) do
        if animationObject and animationObject.Parent then
            animationObject.AnimationId = originalId
        end
    end
    animState.originalByCharacter[character] = nil
    return true
end

local function extractFolderAnimationData(animate, folderName)
    local folder = animate and animate:FindFirstChild(folderName)
    if not folder then return nil end
    local data = { byName = {}, ordered = {}, first = nil }
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Animation") then
            local id = normalizeAnimationId(child.AnimationId)
            if id then
                if not data.first then data.first = id end
                data.byName[child.Name]             = id
                data.ordered[#data.ordered + 1]     = id
            end
        end
    end
    return data
end

local function buildAnimationSetFromAnimate(animate)
    if not animate then return nil end
    return {
        climb = extractFolderAnimationData(animate, "climb"),
        fall  = extractFolderAnimationData(animate, "fall"),
        jump  = extractFolderAnimationData(animate, "jump"),
        run   = extractFolderAnimationData(animate, "run"),
        walk  = extractFolderAnimationData(animate, "walk"),
        swim  = extractFolderAnimationData(animate, "swim"),
        idle  = extractFolderAnimationData(animate, "idle"),
    }
end

local function resolveIdFromFolderData(folderData, childName, index)
    local chosen
    if folderData then
        chosen = folderData.byName[childName] or folderData.ordered[index] or folderData.first
    end
    return normalizeAnimationId(chosen)
end

local function resolveIdFromFolderDataWithFallback(folderData, childName, index, fallbackId)
    if animState.settings.useFallbackWhenMissing then
        return resolveIdFromFolderData(folderData, childName, index) or normalizeAnimationId(fallbackId)
    end
    return resolveIdFromFolderData(folderData, childName, index)
end

local function makeSingleAnimationData(name, rawId)
    local cleaned = normalizeAnimationId(rawId)
    if not cleaned then return nil end
    return { byName = { [name] = cleaned }, ordered = { cleaned }, first = cleaned }
end

local function makeIdleAnimationData(rawIdleId)
    local cleaned = normalizeAnimationId(rawIdleId)
    if not cleaned then return nil end
    return {
        byName  = { Animation1 = cleaned, Animation2 = cleaned },
        ordered = { cleaned, cleaned },
        first   = cleaned,
    }
end

local ANIM_KEYS = { "climb","fall","jump","run","walk","swim","idle" }

local function hasAnimationFolderData(fd)
    return fd ~= nil and fd.first ~= nil
end

local function countAnimationSetCoverage(animationSet)
    if not animationSet then return 0 end
    local covered = 0
    for _, k in ipairs(ANIM_KEYS) do
        if hasAnimationFolderData(animationSet[k]) then covered = covered + 1 end
    end
    return covered
end

local function getCachedAnimationSet(userId)
    local entry = cacheGetEntry(animState.animationSetCache, userId, animState.settings.cacheTtlSeconds)
    if not entry then return nil end
    return entry.set
end

local function setCachedAnimationSet(userId, set)
    if not userId or not set then return end
    cacheSetEntry(animState.animationSetCache, userId, { set = set, timestamp = os.clock() }, CACHE_MAX_ENTRIES.animationSet)
end

local function getAnimationSetFromLivePlayer(userId)
    local ok, player = pcall(function() return Players:GetPlayerByUserId(userId) end)
    if not ok or not player then return nil end
    local character = player.Character
    if not character then return nil end
    local animate = character:FindFirstChild("Animate")
    if not animate then return nil end
    local set = buildAnimationSetFromAnimate(animate)
    return (countAnimationSetCoverage(set) > 0) and set or nil
end

local function getAnimationSetFromDescription(userId)
    local desc = getTargetDescriptionCached(userId)
    if not desc then return nil end
    return {
        climb = makeSingleAnimationData("ClimbAnim", desc.ClimbAnimation),
        fall  = makeSingleAnimationData("FallAnim",  desc.FallAnimation),
        jump  = makeSingleAnimationData("JumpAnim",  desc.JumpAnimation),
        run   = makeSingleAnimationData("RunAnim",   desc.RunAnimation),
        walk  = makeSingleAnimationData("WalkAnim",  desc.WalkAnimation),
        swim  = makeSingleAnimationData("Swim",      desc.SwimAnimation),
        idle  = makeIdleAnimationData(desc.IdleAnimation),
    }
end

local function getAnimationSetFromTempRig(userId)
    local rigType = getLocalRigType()
    local ok, rig = pcall(function() return Players:CreateHumanoidModelFromUserId(userId, rigType) end)
    if not ok or not rig then
        return nil
    end
    rig.Name = "AnimationMimicTempRig"
    local animate = rig:FindFirstChild("Animate") or rig:WaitForChild("Animate", 5)
    if not animate then rig:Destroy(); return nil end
    local set = buildAnimationSetFromAnimate(animate)
    rig:Destroy()
    return set
end

local function getAnimationSetFromUserId(userId)
    local cached = getCachedAnimationSet(userId)
    if cached then return cached end

    local fromLive = getAnimationSetFromLivePlayer(userId)
    local liveCoverage = countAnimationSetCoverage(fromLive)
    if liveCoverage >= (animState.settings.minLiveCoverage or 1) and liveCoverage > 0 then
        setCachedAnimationSet(userId, fromLive)
        return fromLive
    end

    local fromDesc = getAnimationSetFromDescription(userId)
    local fromRig  = getAnimationSetFromTempRig(userId)

    local function pickBetter(currentBest, candidate)
        if not candidate then return currentBest end
        local coverage = countAnimationSetCoverage(candidate.set)
        if coverage <= 0 then return currentBest end
        if not currentBest then
            return { set = candidate.set, coverage = coverage, priority = candidate.priority }
        end
        if coverage > currentBest.coverage then
            return { set = candidate.set, coverage = coverage, priority = candidate.priority }
        end
        if coverage == currentBest.coverage and candidate.priority > currentBest.priority then
            return { set = candidate.set, coverage = coverage, priority = candidate.priority }
        end
        return currentBest
    end

    local best = nil
    best = pickBetter(best, { set = fromLive, priority = 3 })
    best = pickBetter(best, { set = fromRig,  priority = 2 })
    best = pickBetter(best, { set = fromDesc, priority = 1 })

    if not best or not best.set then return nil end
    setCachedAnimationSet(userId, best.set)
    return best.set
end

local function getAnimationSetFromUserIdWithRetry(userId, attempts)
    attempts = attempts or 2
    for i = 1, attempts do
        local set = getAnimationSetFromUserId(userId)
        if set then return set end
        if i < attempts then task.wait(0.12) end
    end
    return nil
end

local function applyAnimationSetToDescriptionFields(desc, animationSet)
    if not desc or not animationSet then return false end
    local function resolveNumeric(folder, childName, idx, fb)
        return numericIdFromContentId(resolveIdFromFolderDataWithFallback(animationSet[folder], childName, idx, fb))
    end
    desc.ClimbAnimation = resolveNumeric("climb","ClimbAnim",1,R15_FALLBACK_ANIMATIONS.climb) or FALLBACK_ANIMATION_NUMERIC_IDS.climb
    desc.FallAnimation  = resolveNumeric("fall", "FallAnim", 1,R15_FALLBACK_ANIMATIONS.fall)  or FALLBACK_ANIMATION_NUMERIC_IDS.fall
    desc.JumpAnimation  = resolveNumeric("jump", "JumpAnim", 1,R15_FALLBACK_ANIMATIONS.jump)  or FALLBACK_ANIMATION_NUMERIC_IDS.jump
    desc.RunAnimation   = resolveNumeric("run",  "RunAnim",  1,R15_FALLBACK_ANIMATIONS.run)   or FALLBACK_ANIMATION_NUMERIC_IDS.run
    desc.WalkAnimation  = resolveNumeric("walk", "WalkAnim", 1,R15_FALLBACK_ANIMATIONS.walk)  or FALLBACK_ANIMATION_NUMERIC_IDS.walk
    desc.SwimAnimation  = resolveNumeric("swim", "Swim",     1,R15_FALLBACK_ANIMATIONS.swim)  or FALLBACK_ANIMATION_NUMERIC_IDS.swim
    desc.IdleAnimation  = resolveNumeric("idle", "Animation1",1,R15_FALLBACK_ANIMATIONS.idle1) or FALLBACK_ANIMATION_NUMERIC_IDS.idle1
    return true
end

local function getCurrentScaleValues(humanoid)
    if not humanoid then return nil end
    local function readSV(name, fallback)
        local nv = humanoid:FindFirstChild(name)
        return (nv and nv:IsA("NumberValue") and nv.Value) or fallback
    end
    local okDesc, desc = pcall(function() return humanoid:GetAppliedDescription() end)
    return {
        height     = readSV("BodyHeightScale",  okDesc and desc and desc.HeightScale     or 1),
        width      = readSV("BodyWidthScale",   okDesc and desc and desc.WidthScale      or 1),
        depth      = readSV("BodyDepthScale",   okDesc and desc and desc.DepthScale      or 1),
        head       = readSV("HeadScale",        okDesc and desc and desc.HeadScale       or 1),
        bodyType   = readSV("BodyTypeScale",    okDesc and desc and desc.BodyTypeScale   or 0),
        proportion = readSV("BodyProportionScale", okDesc and desc and desc.ProportionScale or 0),
    }
end

local destroyBodyColorSnapshot = destroyColorSnapshot

local function restoreCharacterColors(character, snapshot)
    if not character or not snapshot then return end
    if snapshot.bodyColors then
        local src = snapshot.bodyColors
        local ok, clone = pcall(function() return src:Clone() end)
        if ok and clone then
            local current = character:FindFirstChildOfClass("BodyColors")
            if current then pcall(function() current:Destroy() end) end
            local applied = pcall(function() clone.Parent = character end)
            if not applied then
                pcall(function() clone:Destroy() end)
                task.defer(function()
                    task.wait(0.12)
                    if not character.Parent then return end
                    local ok2, clone2 = pcall(function() return src:Clone() end)
                    if not ok2 or not clone2 then return end
                    pcall(function()
                        local bc = character:FindFirstChildOfClass("BodyColors")
                        if bc then bc:Destroy() end
                        clone2.Parent = character
                    end)
                end)
            end
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("BasePart") then
            local saved = snapshot.partColors[child.Name]
            if saved then child.BrickColor = saved end
        end
    end
end

local function replicateAnimationStateForOthers(character, animationSet)
    if not animState.settings.replicateDescriptionToOthers then return true end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local liveColorSnapshot = snapshotCharacterColors(character)
    local scales = getCurrentScaleValues(humanoid)
    local ok, currentDesc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not ok or not currentDesc then
        destroyBodyColorSnapshot(liveColorSnapshot)
        return false
    end
    if scales then
        currentDesc.HeightScale     = scales.height
        currentDesc.WidthScale      = scales.width
        currentDesc.DepthScale      = scales.depth
        currentDesc.HeadScale       = scales.head
        currentDesc.BodyTypeScale   = scales.bodyType
        currentDesc.ProportionScale = scales.proportion
    end
    if not applyAnimationSetToDescriptionFields(currentDesc, animationSet) then
        destroyBodyColorSnapshot(liveColorSnapshot)
        return false
    end
    if humanoid.ApplyDescriptionClientServer then
        local okCS = pcall(function() humanoid:ApplyDescriptionClientServer(currentDesc) end)
        if okCS then
            restoreCharacterColors(character, liveColorSnapshot)
            task.defer(function()
                task.wait(0.08)
                restoreCharacterColors(character, liveColorSnapshot)
                destroyBodyColorSnapshot(liveColorSnapshot)
            end)
            return true
        end
    end
    destroyBodyColorSnapshot(liveColorSnapshot)
    return false
end

local function applyAnimationSetViaDescription(humanoid, animationSet)
    if not humanoid or not animationSet then return false end
    local ok, currentDesc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not ok or not currentDesc then return false end
    if not applyAnimationSetToDescriptionFields(currentDesc, animationSet) then return false end
    if humanoid.ApplyDescriptionClientServer then
        local okCS = pcall(function() humanoid:ApplyDescriptionClientServer(currentDesc) end)
        if okCS then return true end
    end
    local okApply = pcall(function() humanoid:ApplyDescription(currentDesc) end)
    return okApply
end

local function stopDirectController(character)
    if not character then return end
    local controller = animState.directControllerByChar[character]
    if not controller then return end
    if controller.connection and controller.connection.Connected then
        controller.connection:Disconnect()
    end
    if controller.tracks then
        for _, track in pairs(controller.tracks) do
            pcall(function() track:Stop(0.08) end)
        end
    end
    if controller.animations then
        for _, animation in pairs(controller.animations) do
            pcall(function() animation:Destroy() end)
        end
    end
    animState.directControllerByChar[character] = nil
end

local function stopAllDirectControllers()
    local chars = {}
    for c in pairs(animState.directControllerByChar) do chars[#chars+1] = c end
    for _, c in ipairs(chars) do stopDirectController(c) end
    animState.directControllerByChar = {}
end

local function pruneStaleCharacterAnimationState(currentCharacter)
    for character in pairs(animState.originalByCharacter) do
        if character ~= currentCharacter and (not character.Parent or character ~= LOCAL_PLAYER.Character) then
            resetCharacterAnimations(character)
            animState.originalByCharacter[character] = nil
        end
    end

    for character in pairs(animState.directControllerByChar) do
        if character ~= currentCharacter and (not character.Parent or character ~= LOCAL_PLAYER.Character) then
            stopDirectController(character)
        end
    end
end

local function startDirectController(character, animationSet)
    if not animState.settings.useDirectTrackFallback then return false end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not animationSet then return false end

    stopDirectController(character)

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        local ok, a = pcall(function() return Instance.new("Animator") end)
        if ok and a then a.Parent = humanoid; animator = a end
    end
    if not animator then return false end

    local function getAnimId(folder, childName, idx, fb)
        return resolveIdFromFolderDataWithFallback(animationSet[folder], childName, idx, fb)
    end
    local idMap = {
        idle  = getAnimId("idle",  "Animation1", 1, R15_FALLBACK_ANIMATIONS.idle1),
        run   = getAnimId("run",   "RunAnim",    1, R15_FALLBACK_ANIMATIONS.run),
        walk  = getAnimId("walk",  "WalkAnim",   1, R15_FALLBACK_ANIMATIONS.walk),
        jump  = getAnimId("jump",  "JumpAnim",   1, R15_FALLBACK_ANIMATIONS.jump),
        fall  = getAnimId("fall",  "FallAnim",   1, R15_FALLBACK_ANIMATIONS.fall),
        climb = getAnimId("climb", "ClimbAnim",  1, R15_FALLBACK_ANIMATIONS.climb),
        swim  = getAnimId("swim",  "Swim",       1, R15_FALLBACK_ANIMATIONS.swim),
    }

    local tracks, animations = {}, {}
    local createdAny = false
    for stateName, animId in pairs(idMap) do
        if animId then
            local animation = Instance.new("Animation")
            animation.Name        = "Mimic_" .. stateName
            animation.AnimationId = animId
            animations[stateName] = animation
            local okT, track = pcall(function() return animator:LoadAnimation(animation) end)
            if okT and track then
                track.Priority = (stateName == "idle") and Enum.AnimationPriority.Idle or Enum.AnimationPriority.Movement
                track.Looped   = (stateName ~= "jump" and stateName ~= "fall")
                tracks[stateName] = track
                createdAny = true
            end
        end
    end

    if not createdAny then
        for _, a in pairs(animations) do pcall(function() a:Destroy() end) end
        return false
    end

    local controller = { tracks = tracks, animations = animations, connection = nil, active = nil, nextUpdateAt = 0 }
    animState.directControllerByChar[character] = controller

    local function playState(nextState)
        if controller.active == nextState then
            local t = controller.tracks[nextState]
            if t and not t.IsPlaying then pcall(function() t:Play(0.08,1,1) end) end
            return
        end
        controller.active = nextState
        for name, track in pairs(controller.tracks) do
            if name == nextState then
                pcall(function() if not track.IsPlaying then track:Play(0.08,1,1) end end)
            else
                pcall(function() if track.IsPlaying then track:Stop(0.08) end end)
            end
        end
    end

    controller.connection = RunService.Heartbeat:Connect(function()
        if not animState.active or not character.Parent then
            stopDirectController(character); return
        end
        local now = os.clock()
        if now < controller.nextUpdateAt then return end
        controller.nextUpdateAt = now + 0.03

        local moveMag  = humanoid.MoveDirection.Magnitude
        local humState = humanoid:GetState()

        if humState == Enum.HumanoidStateType.Freefall then
            if tracks.fall then playState("fall") elseif tracks.jump then playState("jump") end; return
        end
        if humState == Enum.HumanoidStateType.Jumping   and tracks.jump  then playState("jump");  return end
        if humState == Enum.HumanoidStateType.Climbing  and tracks.climb then playState("climb"); return end
        if humState == Enum.HumanoidStateType.Swimming  and tracks.swim  then playState("swim");  return end
        if moveMag > 0.08 then
            if tracks.run then playState("run") elseif tracks.walk then playState("walk") end; return
        end
        if tracks.idle then playState("idle") end
    end)

    return true
end

local function applyFolderDataToFolder(character, folder, folderData, shouldRemember)
    if not folder then return 0 end
    local changed = 0
    local idx = 0
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Animation") then
            idx = idx + 1
            local resolvedId = resolveIdFromFolderData(folderData, child.Name, idx)
            if resolvedId then
                if shouldRemember then rememberOriginal(character, child) end
                child.AnimationId = resolvedId
                changed = changed + 1
            end
        end
    end
    return changed
end

local function getFirstAnimationInFolder(folder)
    if not folder then return nil end
    for _, child in ipairs(folder:GetChildren()) do
        if child:IsA("Animation") then return child end
    end
    return nil
end

local function applySlotFromSet(character, animate, animationSet, folderName, fallbackId, shouldRemember)
    local folder  = animate:FindFirstChild(folderName)
    local setData = animationSet and animationSet[folderName]
    if applyFolderDataToFolder(character, folder, setData, shouldRemember) > 0 then return true end
    local firstAnim = getFirstAnimationInFolder(folder)
    if not firstAnim or not animState.settings.useFallbackWhenMissing then return false end
    local fallback = normalizeAnimationId(fallbackId)
    if not fallback then return false end
    if shouldRemember then rememberOriginal(character, firstAnim) end
    firstAnim.AnimationId = fallback
    return true
end

local function applyIdleFromSet(character, animate, idleData, shouldRemember)
    local idleFolder = animate:FindFirstChild("idle")
    if not idleFolder then return false end
    local applied = 0
    local idx = 0
    for _, child in ipairs(idleFolder:GetChildren()) do
        if child:IsA("Animation") then
            idx = idx + 1
            local fb = nil
            if animState.settings.useFallbackWhenMissing then
                fb = (child.Name == "Animation2") and R15_FALLBACK_ANIMATIONS.idle2 or R15_FALLBACK_ANIMATIONS.idle1
            end
            local resolvedIdle = resolveIdFromFolderDataWithFallback(idleData, child.Name, idx, fb)
            if resolvedIdle then
                if shouldRemember then rememberOriginal(character, child) end
                child.AnimationId = resolvedIdle
                applied = applied + 1
            end
        end
    end
    return applied > 0
end

local function hardResetAnimator(humanoid)
    if not humanoid then return end
    local tracks = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(tracks) do track:Stop(0) end
end

local function flushAnimationState(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local tracks = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(tracks) do track:Stop(0) end
end

local function refreshAnimate(character)
    local animate  = character and character:FindFirstChild("Animate")
    if animate and animate:IsA("LocalScript") then
        animate.Disabled = true
        task.wait()
        animate.Disabled = false
    end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local tracks = humanoid:GetPlayingAnimationTracks()
        for _, track in ipairs(tracks) do track:Stop(0) end
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function forceAnimationKick(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid:Move(Vector3.new(0, 0, 0), true)
    humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    task.wait()
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    task.defer(function()
        if not character.Parent then return end
        local playingTracks = humanoid:GetPlayingAnimationTracks()
        if #playingTracks > 0 then return end
        humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        task.wait()
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end)
end

local function scrubTracksForDuration(character, seconds)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local tracksStart = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(tracksStart) do track:Stop(0) end
    task.wait(seconds or 0.2)
    local tracksEnd = humanoid:GetPlayingAnimationTracks()
    for _, track in ipairs(tracksEnd) do track:Stop(0) end
end

local function applyAnimationSetToCharacter(character, animationSet)
    if not character or not animationSet then return false end
    local animate  = character:FindFirstChild("Animate")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    hardResetAnimator(humanoid)

    local applied = 0
    if animate then
        for _, spec in ipairs(SLOT_SPECS) do
            if applySlotFromSet(character, animate, animationSet, spec.folder, spec.fallback, true) then
                applied = applied + 1
            end
        end
        if applyIdleFromSet(character, animate, animationSet.idle, true) then
            applied = applied + 1
        end
    end

    if applied > 0 then
        stopDirectController(character)
        refreshAnimate(character)
    else
        local descApplied = applyAnimationSetViaDescription(humanoid, animationSet)
        if descApplied then
            stopDirectController(character)
        else
            if not startDirectController(character, animationSet) then return false end
        end
    end

    forceAnimationKick(character)
    replicateAnimationStateForOthers(character, animationSet)
    task.defer(function()
        if not animState.active then return end
        if not (env and env.EmoteMimic and type(env.EmoteMimic.Reapply) == "function") then return end
        pcall(function() env.EmoteMimic.Reapply() end)
    end)
    return true
end

local function restoreOwnAnimationsHard(character)
    if not character then return false end
    local ownSet = getAnimationSetFromUserId(LOCAL_PLAYER.UserId)
    if not ownSet then return false end
    local animate  = character:FindFirstChild("Animate")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    hardResetAnimator(humanoid)

    local applied = 0
    if animate then
        for _, spec in ipairs(SLOT_SPECS) do
            if applySlotFromSet(character, animate, ownSet, spec.folder, spec.fallback, false) then
                applied = applied + 1
            end
        end
        if applyIdleFromSet(character, animate, ownSet.idle, false) then
            applied = applied + 1
        end
    end

    if applied > 0 then
        stopDirectController(character)
        refreshAnimate(character)
    else
        if applyAnimationSetViaDescription(humanoid, ownSet) then
            stopDirectController(character)
        else
            if not animState.active then return false end
            if not startDirectController(character, ownSet) then return false end
        end
    end

    forceAnimationKick(character)
    replicateAnimationStateForOthers(character, ownSet)
    task.defer(function()
        if not animState.active then return end
        if not (env and env.EmoteMimic and type(env.EmoteMimic.Reapply) == "function") then return end
        pcall(function() env.EmoteMimic.Reapply() end)
    end)
    return true
end

local function mimicAnimationsFromUserId(userId, forceApply)
    if not animState.active then return false end
    forceApply = forceApply ~= false and forceApply or false

    local numericUserId = tonumber(userId)
    if not numericUserId then return false end


    local character = LOCAL_PLAYER.Character
    if not character then return false end
    if not isCharacterR15(character) then return false end

    pruneStaleCharacterAnimationState(character)

    if not forceApply and animState.lastSourceUserId == numericUserId then
        return true
    end

    animState.applyToken = animState.applyToken + 1
    local applyToken = animState.applyToken


    local targetAvatarType = getUserAvatarType(numericUserId)
    if targetAvatarType == "R6" then
        animState.lastSourceUserId = nil
        restoreOwnAnimationsHard(character)
        flushAnimationState(character)
        return false
    end

    local animationSet = getAnimationSetFromUserIdWithRetry(numericUserId, 3)
    if not animationSet then
        animState.lastSourceUserId = nil
        return false
    end

    if applyToken ~= animState.applyToken then return false end

    local switchedTarget = animState.lastSourceUserId and animState.lastSourceUserId ~= numericUserId
    if switchedTarget then
        restoreOwnAnimationsHard(character)
        flushAnimationState(character)
        scrubTracksForDuration(character, 0.18)
        if applyToken ~= animState.applyToken then return false end
    end

    animState.lastSourceUserId = numericUserId
    animState.pinnedTargetUserId = numericUserId

    local ok = applyAnimationSetToCharacter(character, animationSet)
    if not ok then return false end

    task.defer(function()
        task.wait(0.2)
        if applyToken ~= animState.applyToken then return end
        if not character.Parent then return end
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if #hum:GetPlayingAnimationTracks() == 0 then
            restoreOwnAnimationsHard(character)
            applyAnimationSetToCharacter(character, animationSet)
        end
    end)

    return ok
end

local function mimicAnimationsFromTarget(target)
    if not animState.active then return false end
    local userId = resolveTargetToUserId(target)
    if not userId then return false end
    animState.lastTargetInput = target
    animState.pinnedTargetUserId = userId
    if animState.settings.invalidateAnimationCacheOnTargetSwitch then
        animState.animationSetCache[userId] = nil
    end
    return mimicAnimationsFromUserId(userId, true)
end

local function disconnectAllConnections()
    for _, conn in ipairs(animState.connections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    animState.connections = {}
end

local function clearRuntimeCaches()
    animState.animationSetCache = {}
end

local function restoreCharacterToSelf(character)
    if not character then return false end
    resetCharacterAnimations(character)
    local restored = restoreOwnAnimationsHard(character)
    flushAnimationState(character)
    return restored
end

local function animCleanup()
    if not animState.active then return end
    animState.active           = false
    animState.lastSourceUserId = nil
    animState.pinnedTargetUserId = nil
    animState.lastTargetInput  = nil
    animState.applyToken       = animState.applyToken + 1
    disconnectAllConnections()
    local character = LOCAL_PLAYER.Character
    stopAllDirectControllers()
    restoreCharacterToSelf(character)
    flushAnimationState(character)
    animState.originalByCharacter = {}
    clearRuntimeCaches()
end
animState.cleanup = animCleanup

if env then
    env.CloneAnimationsFromTarget = mimicAnimationsFromTarget
    env.AnimationMimicCleanup     = animCleanup
end

if env and env.__EmoteMimicState and type(env.__EmoteMimicState.cleanup) == "function" then
    pcall(env.__EmoteMimicState.cleanup)
end

local function deepCopyTable(value, seen)
    if type(value) ~= "table" then return value end
    seen = seen or {}
    if seen[value] then return seen[value] end
    local out = {}
    seen[value] = out
    for k, v in pairs(value) do
        out[deepCopyTable(k, seen)] = deepCopyTable(v, seen)
    end
    return out
end

local emoteState = {
    active          = true,
    targetInput     = CONFIG.target,
    currentUserId   = nil,
    applyToken      = 0,
    connections     = {},
    emoteCache      = {},
    cacheTtlSeconds = 20,
    cleanup         = nil,
    settings = {
        autoApplyOnRespawn = true,
    },
}

if env then env.__EmoteMimicState = emoteState end

local function disconnectEmoteConnections()
    for _, conn in ipairs(emoteState.connections) do
        if conn and conn.Connected then conn:Disconnect() end
    end
    emoteState.connections = {}
end

local function clearEmoteCaches()
    emoteState.emoteCache = {}
end

local function getEmoteDataFromDescription(desc)
    if not desc then return nil end
    local emotes = nil
    local equipped = nil

    if type(desc.GetEmotes) == "function" then
        local ok, value = pcall(function() return desc:GetEmotes() end)
        if ok and type(value) == "table" then emotes = deepCopyTable(value) end
    end
    if type(desc.GetEquippedEmotes) == "function" then
        local ok, value = pcall(function() return desc:GetEquippedEmotes() end)
        if ok and type(value) == "table" then equipped = deepCopyTable(value) end
    end

    if emotes == nil then
        local ok, value = pcall(function() return desc.Emotes end)
        if ok and type(value) == "table" then emotes = deepCopyTable(value) end
    end
    if equipped == nil then
        local ok, value = pcall(function() return desc.EquippedEmotes end)
        if ok and type(value) == "table" then equipped = deepCopyTable(value) end
    end

    if type(emotes) ~= "table" then emotes = {} end
    if type(equipped) ~= "table" then equipped = {} end

    return { emotes = emotes, equipped = equipped }
end

local function hasAnyTableEntries(value)
    return type(value) == "table" and next(value) ~= nil
end

local function hasUsableEmotePayload(emoteData)
    if type(emoteData) ~= "table" then return false end
    return hasAnyTableEntries(emoteData.emotes) or hasAnyTableEntries(emoteData.equipped)
end

local function getEmoteDataFromLivePlayer(userId)
    local okPlayer, player = pcall(function() return Players:GetPlayerByUserId(userId) end)
    if not okPlayer or not player then return nil end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local okDesc, desc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not okDesc or not desc then return nil end
    return getEmoteDataFromDescription(desc)
end

local function getEmoteDataFromUserId(userId)
    local entry = cacheGetEntry(emoteState.emoteCache, userId, emoteState.cacheTtlSeconds)
    if entry and entry.data then
        return {
            emotes = deepCopyTable(entry.data.emotes),
            equipped = deepCopyTable(entry.data.equipped),
        }
    end

    local data = getEmoteDataFromLivePlayer(userId)
    if not data then
        local desc = getTargetDescriptionCached(userId)
        if desc then
            data = getEmoteDataFromDescription(desc)
        end
    end
    if not data or not hasUsableEmotePayload(data) then return nil end

    cacheSetEntry(emoteState.emoteCache, userId, { data = data, timestamp = os.clock() }, CACHE_MAX_ENTRIES.emoteData)
    return data
end

local function applyScaleValuesToDescription(desc, scales)
    if not desc or not scales then return end
    desc.HeightScale     = scales.height
    desc.WidthScale      = scales.width
    desc.DepthScale      = scales.depth
    desc.HeadScale       = scales.head
    desc.BodyTypeScale   = scales.bodyType
    desc.ProportionScale = scales.proportion
end

local function restoreCharacterColorsSafely(character, colorSnapshot)
    if not colorSnapshot then return end
    restoreCharacterColors(character, colorSnapshot)
    task.defer(function()
        task.wait(0.06)
        if character and character.Parent then
            restoreCharacterColors(character, colorSnapshot)
        end
    end)
    task.defer(function()
        task.wait(0.2)
        if character and character.Parent then
            restoreCharacterColors(character, colorSnapshot)
        end
        destroyBodyColorSnapshot(colorSnapshot)
    end)
end

local function applyEmotesToHumanoid(humanoid, emoteData)
    if not humanoid or not emoteData then return false end
    if not hasUsableEmotePayload(emoteData) then return false end

    local character = humanoid.Parent
    local colorSnapshot = snapshotCharacterColors(character)
    local scaleSnapshot = getCurrentScaleValues(humanoid)

    local okDesc, currentDesc = pcall(function() return humanoid:GetAppliedDescription() end)
    if not okDesc or not currentDesc then return false end

    local setAny = false
    if type(currentDesc.SetEmotes) == "function" then
        local ok = pcall(function() currentDesc:SetEmotes(deepCopyTable(emoteData.emotes)) end)
        setAny = setAny or ok
    else
        local ok = pcall(function() currentDesc.Emotes = deepCopyTable(emoteData.emotes) end)
        setAny = setAny or ok
    end

    if type(currentDesc.SetEquippedEmotes) == "function" then
        local ok = pcall(function() currentDesc:SetEquippedEmotes(deepCopyTable(emoteData.equipped)) end)
        setAny = setAny or ok
    else
        local ok = pcall(function() currentDesc.EquippedEmotes = deepCopyTable(emoteData.equipped) end)
        setAny = setAny or ok
    end

    if not setAny then
        return false
    end

    applyScaleValuesToDescription(currentDesc, scaleSnapshot)

    if humanoid.ApplyDescriptionClientServer then
        local okCS = pcall(function() humanoid:ApplyDescriptionClientServer(currentDesc) end)
        if okCS then
            restoreCharacterColorsSafely(character, colorSnapshot)
            return true
        end
    end

    local okApply = pcall(function() humanoid:ApplyDescription(currentDesc) end)
    restoreCharacterColorsSafely(character, colorSnapshot)
    return okApply
end

local function mimicEmotesFromUserId(userId)
    if not emoteState.active then return false end
    local numericUserId = tonumber(userId)
    if not numericUserId then return false end

    local character = LOCAL_PLAYER.Character
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end

    emoteState.applyToken = emoteState.applyToken + 1
    local applyToken = emoteState.applyToken

    local emoteData = getEmoteDataFromUserId(numericUserId)
    if not emoteData then return false end
    if applyToken ~= emoteState.applyToken or not emoteState.active then return false end

    local ok = false
    for attempt = 1, 3 do
        ok = applyEmotesToHumanoid(humanoid, emoteData)
        if ok then break end
        if attempt < 3 then task.wait(0.12) end
    end
    if ok then
        emoteState.currentUserId = numericUserId
    end
    return ok
end

local function mimicEmotesFromTarget(target)
    if not emoteState.active then return false end
    local userId = resolveTargetToUserId(target)
    if not userId then return false end
    emoteState.targetInput = target
    return mimicEmotesFromUserId(userId)
end

local function reapplyEmotes()
    if emoteState.currentUserId then
        return mimicEmotesFromUserId(emoteState.currentUserId)
    end
    return mimicEmotesFromTarget(emoteState.targetInput or CONFIG.target)
end

local function useDefaultEmoteTarget()
    emoteState.currentUserId = nil
    return mimicEmotesFromTarget(CONFIG.target)
end

local function applyCurrentEmoteSelection()
    if emoteState.currentUserId then
        return mimicEmotesFromUserId(emoteState.currentUserId)
    end
    return mimicEmotesFromTarget(emoteState.targetInput or CONFIG.target)
end

local function emoteCleanup()
    if not emoteState.active then return end
    emoteState.active = false
    emoteState.applyToken = emoteState.applyToken + 1
    disconnectEmoteConnections()
    clearEmoteCaches()
    if env and env.__EmoteMimicState == emoteState then
        env.__EmoteMimicState = nil
    end
end
emoteState.cleanup = emoteCleanup

if emoteState.settings.autoApplyOnRespawn then
    local conn = LOCAL_PLAYER.CharacterAdded:Connect(function(char)
        if not emoteState.active then return end
        emoteState.applyToken = emoteState.applyToken + 1
        local respawnToken = emoteState.applyToken
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum or respawnToken ~= emoteState.applyToken or not emoteState.active then return end
        task.spawn(function()
            local delays = { 0.2, 0.45, 0.8 }
            for _, delayTime in ipairs(delays) do
                if not emoteState.active or respawnToken ~= emoteState.applyToken or not char.Parent then return end
                task.wait(delayTime)
                if not emoteState.active or respawnToken ~= emoteState.applyToken or not char.Parent then return end
                if applyCurrentEmoteSelection() then break end
            end
            task.wait(0.9)
            if not emoteState.active or respawnToken ~= emoteState.applyToken or not char.Parent then return end
            applyCurrentEmoteSelection()
        end)
    end)
    table.insert(emoteState.connections, conn)
end

if env then
    env.EmoteMimic = {
        SetTarget         = mimicEmotesFromTarget,
        SetTargetUserId   = mimicEmotesFromUserId,
        Reapply           = reapplyEmotes,
        UseDefaultTarget  = useDefaultEmoteTarget,
        Cleanup           = emoteCleanup,
    }
    env.CloneEmotesFromTarget = mimicEmotesFromTarget
    env.CloneEmotesFromUserId = mimicEmotesFromUserId
    env.EmoteMimicCleanup     = emoteCleanup
end

task.defer(function()
    if not emoteState.active then return end
    mimicEmotesFromTarget(CONFIG.target)
end)

local function switchTargetSafe(target)
    if target == nil then return false end
    local outfitTriggered = false
    local outfitApi = env and env.OutfitCopy
    if outfitApi and type(outfitApi.SetTarget) == "function" then
        local ok = pcall(function() outfitApi.SetTarget(target) end)
        outfitTriggered = ok
    elseif env and type(env.CopySetUserId) == "function" then
        local ok = pcall(function() env.CopySetUserId(target) end)
        outfitTriggered = ok
    end
    task.defer(function()
        if animState.active then
            mimicAnimationsFromTarget(target)
        end
        if emoteState.active then
            mimicEmotesFromTarget(target)
        end
    end)
    return outfitTriggered
end

local function fullComboCleanup()
    pcall(teardown)
    pcall(animCleanup)
    pcall(emoteCleanup)
end

if env then
    env.SwitchTargetSafe = switchTargetSafe
    env.SetTargetSafe    = switchTargetSafe
    env.FullComboCleanup = fullComboCleanup
    env.CloneFullCleanup = fullComboCleanup
end

task.defer(function()
    if not animState.active then return end
    if animState.pinnedTargetUserId then
        mimicAnimationsFromUserId(animState.pinnedTargetUserId)
    elseif animState.lastSourceUserId then
        mimicAnimationsFromUserId(animState.lastSourceUserId)
    elseif animState.lastTargetInput ~= nil then
        mimicAnimationsFromTarget(animState.lastTargetInput)
    else
        mimicAnimationsFromTarget(CONFIG.target)
    end
end)

if animState.settings.autoApplyOnRespawn then
    local conn = LOCAL_PLAYER.CharacterAdded:Connect(function(newCharacter)
        if not animState.active then return end
        animState.applyToken = animState.applyToken + 1
        local respawnToken = animState.applyToken
        pruneStaleCharacterAnimationState(newCharacter)
        local hum = newCharacter:WaitForChild("Humanoid", 10)
        if not hum or respawnToken ~= animState.applyToken or not animState.active then return end
        task.wait(0.15)
        if respawnToken ~= animState.applyToken or not animState.active or not newCharacter.Parent then return end
        task.spawn(function()
            local backoff = 0.25
            for _ = 1, 4 do
                if not animState.active or respawnToken ~= animState.applyToken or not newCharacter.Parent then return end
                if animState.pinnedTargetUserId and mimicAnimationsFromUserId(animState.pinnedTargetUserId, true) then return end
                if animState.lastSourceUserId and mimicAnimationsFromUserId(animState.lastSourceUserId, true) then return end
                if animState.lastTargetInput ~= nil and mimicAnimationsFromTarget(animState.lastTargetInput) then return end
                task.wait(backoff)
                if not animState.active or respawnToken ~= animState.applyToken then return end
                backoff = math.min(backoff * 2, 2)
            end
        end)
    end)
    table.insert(animState.connections, conn)
end

end
