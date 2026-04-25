local EffectsModule = {}
local _ReplicatedStorage = game:GetService('ReplicatedStorage')
local _LocalPlayer = game.Players.LocalPlayer
local _UserInputService = game:GetService('UserInputService')

function EffectsModule.new()
    local self = {}
    self.DisableFlashbang = false
    self.DisableSmoke = false
    self.DisablePaintball = false
    self.AntiAFK = false
    self.Connection = nil

    function self:setDisableFlashbang(enabled)
        self.DisableFlashbang = enabled
        if enabled then
            self:removeFlashbang()
        end
    end

    function self:removeFlashbang()
        local UserInterface = _LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('UserInterface')
        local flashbangGui = UserInterface:FindFirstChild('FlashbangGui')
        if flashbangGui then
            flashbangGui:Destroy()
        end
    end

    function self:setDisableSmoke(enabled)
        self.DisableSmoke = enabled
        if enabled then
            self:removeSmoke()
        end
    end

    function self:removeSmoke()
        local Misc = _LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('Assets'):WaitForChild('Misc')
        local SmokeClouds = Misc:FindFirstChild('SmokeClouds')
        if SmokeClouds then
            SmokeClouds:Destroy()
        end
    end

    function self:setDisablePaintball(enabled)
        self.DisablePaintball = enabled
        if enabled then
            self:removePaintball()
        end
    end

    function self:removePaintball()
        local UserInterface = _LocalPlayer:WaitForChild('PlayerScripts'):WaitForChild('UserInterface')
        local paintballGui = UserInterface:FindFirstChild('paintballGui')
        if paintballGui then
            paintballGui:Destroy()
        end
    end

    function self:setAntiAFK(enabled)
        self.AntiAFK = enabled
        if enabled then
            self:enableAntiAFK()
        end
    end

    function self:enableAntiAFK()
        local cg = coroutine.wrap(function()
            while self.AntiAFK and task.wait(0.5) do
                local metrics = _LocalPlayer:GetNetwork()
                if metrics then
                    metrics:setattribute('AutoJumpEnabled', true)
                end
                _VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.End, false, game)
                task.wait(0.1)
                _VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.End, false, game)
            end
        end)
        cg()
    end

    return self
end

return EffectsModule