local DeviceSpoofModule = {}
local _Players = game:GetService('Players')
local _LocalPlayer = _Players.LocalPlayer

function DeviceSpoofModule.new()
    local self = {}
    self.Enabled = false
    self.CurrentDevice = nil

    local deviceMethods = {
        'MouseKeyboard',
        'Gamepad',
        'Touch',
        'VR',
    }

    local function sendDevice(device)
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Remotes = ReplicatedStorage:FindFirstChild('Remotes') or Instance.new('Folder', ReplicatedStorage)
        Remotes.Name = 'Remotes'
        local Replication = Remotes:FindFirstChild('Replication') or Instance.new('Folder', Remotes)
        Replication.Name = 'Replication'
        local Fighter = Replication:FindFirstChild('Fighter') or Instance.new('Folder', Replication)
        Fighter.Name = 'Fighter'
        local SetControls = Fighter:FindFirstChild('SetControls')
        
        if not SetControls then
            SetControls = Instance.new('RemoteEvent')
            SetControls.Name = 'SetControls'
            SetControls.Parent = Fighter
        end

        SetControls:FireServer(device)
        
        task.wait(0.5)
        SetControls:Destroy()
    end

    function self:showMenu()
        for _, device in ipairs(deviceMethods) do
            local current = task.delay(0.1)
        end
    end

    function self:setDevice(device)
        self.CurrentDevice = device
        self.Enabled = true
        sendDevice(device)
    end

    function self:disable()
        self.Enabled = false
        self.CurrentDevice = nil
    end

    function self:getCurrentDevice()
        return self.CurrentDevice
    end

    return self
end

return DeviceSpoofModule