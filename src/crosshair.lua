local CrosshairModule = {}
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

function CrosshairModule.new(config)
    local self = {}
    local enabled = false
    local style = "cross"
    local size = 10
    local gap = 5
    local thickness = 2
    local color = Color3.new(1, 1, 1)
    local outlineColor = Color3.new(0, 0, 0)
    local outline = true
    local dynamic = false
    local followMouse = false
    local autoSnap = false
    local snapFOV = 50
    
    local elements = {}
    local mouseOffset = Vector2.new(0, 0)
    
    local function createCrosshair()
        local gui = Instance.new("ScreenGui")
        gui.Name = "CustomCrosshair"
        gui.ResetOnSpawn = false
        gui.Parent = game.CoreGui
        
        local elements = {
            gui = gui,
            lines = {},
            shapes = {},
            outline = {}
        }
        
        return elements
    end
    
    local function clearElements()
        if not elements.gui then return end
        
        for _, line in ipairs(elements.lines) do
            if line then line:Remove() end
        end
        for _, shape in ipairs(elements.shapes) do
            if shape then shape:Remove() end
        end
        for _, out in ipairs(elements.outline) do
            if out then out:Remove() end
        end
        
        elements.lines = {}
        elements.shapes = {}
        elements.outline = {}
    end
    
    local function updatePosition()
        local cam = workspace.CurrentCamera
        local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        
        if followMouse then
            center = center + mouseOffset
        end
        
        clearElements()
        
        local baseSize = size
        local baseGap = gap
        local baseThick = thickness
        
        style = style:lower()
        
        if style == "cross" then
            local h1 = Drawing.new("Line")
            h1.From = Vector2.new(center.X - baseSize - baseGap, center.Y)
            h1.To = Vector2.new(center.X - baseGap - 1, center.Y)
            h1.Thickness = baseThick
            h1.Color = color
            
            local h2 = Drawing.new("Line")
            h2.From = Vector2.new(center.X + baseGap + 1, center.Y)
            h2.To = Vector2.new(center.X + baseSize + baseGap, center.Y)
            h2.Thickness = baseThick
            h2.Color = color
            
            local v1 = Drawing.new("Line")
            v1.From = Vector2.new(center.X, center.Y - baseSize - baseGap)
            v1.To = Vector2.new(center.X, center.Y - baseGap - 1)
            v1.Thickness = baseThick
            v1.Color = color
            
            local v2 = Drawing.new("Line")
            v2.From = Vector2.new(center.X, center.Y + baseGap + 1)
            v2.To = Vector2.new(center.X, center.Y + baseSize + baseGap)
            v2.Thickness = baseThick
            v2.Color = color
            
            table.insert(elements.lines, h1)
            table.insert(elements.lines, h2)
            table.insert(elements.lines, v1)
            table.insert(elements.lines, v2)
            
        elseif style == "dot" then
            local circle = Drawing.new("Circle")
            circle.Radius = 3
            circle.Filled = true
            circle.Color = color
            circle.Position = center
            
            table.insert(elements.shapes, circle)
            
        elseif style == "circle" then
            local outer = Drawing.new("Circle")
            outer.Radius = baseSize
            outer.Thickness = baseThick
            outer.Filled = false
            outer.Color = color
            outer.Position = center
            
            table.insert(elements.shapes, outer)
            
        elseif style == "circlefilled" then
            local fill = Drawing.new("Circle")
            fill.Radius = baseSize
            fill.Filled = true
            fill.Color = color
            fill.Position = center
            
            local outline = Drawing.new("Circle")
            outline.Radius = baseSize + 2
            outline.Thickness = 1
            outline.Filled = false
            outline.Color = outlineColor
            outline.Position = center
            
            table.insert(elements.shapes, fill)
            table.insert(elements.outline, outline)
            
        elseif style == "t" then
            local h = Drawing.new("Line")
            h.From = Vector2.new(center.X - baseSize, center.Y)
            h.To = Vector2.new(center.X + baseSize, center.Y)
            h.Thickness = baseThick
            h.Color = color
            
            local v = Drawing.new("Line")
            v.From = Vector2.new(center.X, center.Y)
            v.To = Vector2.new(center.X, center.Y + baseSize)
            v.Thickness = baseThick
            v.Color = color
            
            table.insert(elements.lines, h)
            table.insert(elements.lines, v)
            
        elseif style == "plus" then
            local h = Drawing.new("Line")
            h.From = Vector2.new(center.X - baseSize, center.Y)
            h.To = Vector2.new(center.X + baseSize, center.Y)
            h.Thickness = baseThick
            h.Color = color
            
            local v = Drawing.new("Line")
            v.From = Vector2.new(center.X, center.Y - baseSize)
            v.To = Vector2.new(center.X, center.Y + baseSize)
            v.Thickness = baseThick
            v.Color = color
            
            table.insert(elements.lines, h)
            table.insert(elements.lines, v)
            
        elseif style == "gap" then
            local h1 = Drawing.new("Line")
            h1.From = Vector2.new(0, center.Y)
            h1.To = Vector2.new(center.X - baseGap - 1, center.Y)
            h1.Thickness = baseThick
            h1.Color = color
            
            local h2 = Drawing.new("Line")
            h2.From = Vector2.new(center.X + baseGap + 1, center.Y)
            h2.To = Vector2.new(cam.ViewportSize.X, center.Y)
            h2.Thickness = baseThick
            h2.Color = color
            
            local v1 = Drawing.new("Line")
            v1.From = Vector2.new(center.X, 0)
            v1.To = Vector2.new(center.X, center.Y - baseGap - 1)
            v1.Thickness = baseThick
            v1.Color = color
            
            local v2 = Drawing.new("Line")
            v2.From = Vector2.new(center.X, center.Y + baseGap + 1)
            v2.To = Vector2.new(center.X, cam.ViewportSize.Y)
            v2.Thickness = baseThick
            v2.Color = color
            
            table.insert(elements.lines, h1)
            table.insert(elements.lines, h2)
            table.insert(elements.lines, v1)
            table.insert(elements.lines, v2)
            
        elseif style == "swastika" or style == "nazi" then
            local cx, cy = center.X, center.Y
            local s = baseSize
            
            local arm1 = Drawing.new("Line")
            arm1.From = Vector2.new(cx - s, cy - s)
            arm1.To = Vector2.new(cx + s, cy + s)
            arm1.Thickness = baseThick
            arm1.Color = color
            
            local arm2 = Drawing.new("Line")
            arm2.From = Vector2.new(cx + s, cy - s)
            arm2.To = Vector2.new(cx - s, cy + s)
            arm2.Thickness = baseThick
            arm2.Color = color
            
            local arm3 = Drawing.new("Line")
            arm3.From = Vector2.new(cx, cy - s)
            arm3.To = Vector2.new(cx, cy + s)
            arm3.Thickness = baseThick
            arm3.Color = color
            
            local arm4 = Drawing.new("Line")
            arm4.From = Vector2.new(cx - s, cy)
            arm4.To = Vector2.new(cx + s, cy)
            arm4.Thickness = baseThick
            arm4.Color = color
            
            table.insert(elements.lines, arm1)
            table.insert(elements.lines, arm2)
            table.insert(elements.lines, arm3)
            table.insert(elements.lines, arm4)
            
        elseif style == "star" then
            local cx, cy = center.X, center.Y
            local s = baseSize
            
            for i = 0, 4 do
                local angle1 = (i * 72 - 90) * math.pi / 180
                local angle2 = ((i + 1) * 72 - 90) * math.pi / 180
                local angle3 = ((i + 2) * 72 - 90) * math.pi / 180
                
                local line1 = Drawing.new("Line")
                line1.From = Vector2.new(cx + math.cos(angle1) * s, cy + math.sin(angle1) * s)
                line1.To = Vector2.new(cx + math.cos(angle3) * s, cy + math.sin(angle3) * s)
                line1.Thickness = baseThick
                line1.Color = color
                
                table.insert(elements.lines, line1)
            end
            
        elseif style == "heart" then
            local cx, cy = center.X, center.Y
            local s = baseSize
            
            local left = Drawing.new("Circle")
            left.Radius = s * 0.4
            left.Filled = true
            left.Color = color
            left.Position = Vector2.new(cx - s * 0.3, cy - s * 0.2)
            
            local right = Drawing.new("Circle")
            right.Radius = s * 0.4
            right.Filled = true
            right.Color = color
            right.Position = Vector2.new(cx + s * 0.3, cy - s * 0.2)
            
            local bottom = Drawing.new("Triangle")
            bottom.Filled = true
            bottom.Color = color
            bottom.PointA = Vector2.new(cx - s * 0.35, cy + s * 0.1)
            bottom.PointB = Vector2.new(cx + s * 0.35, cy + s * 0.1)
            bottom.PointC = Vector2.new(cx, cy + s * 0.7)
            
            table.insert(elements.shapes, left)
            table.insert(elements.shapes, right)
            table.insert(elements.shapes, bottom)
            
        elseif style == "skull" then
            local cx, cy = center.X, center.Y
            local s = baseSize
            
            local skull = Drawing.new("Circle")
            skull.Radius = s
            skull.Filled = true
            skull.Color = color
            skull.Position = center
            
            local leftEye = Drawing.new("Circle")
            leftEye.Radius = s * 0.25
            leftEye.Filled = true
            leftEye.Color = outlineColor
            leftEye.Position = Vector2.new(cx - s * 0.3, cy - s * 0.2)
            
            local rightEye = Drawing.new("Circle")
            rightEye.Radius = s * 0.25
            rightEye.Filled = true
            rightEye.Color = outlineColor
            rightEye.Position = Vector2.new(cx + s * 0.3, cy - s * 0.2)
            
            local mouth = Drawing.new("Line")
            mouth.From = Vector2.new(cx - s * 0.4, cy + s * 0.4)
            mouth.To = Vector2.new(cx + s * 0.4, cy + s * 0.4)
            mouth.Thickness = baseThick
            mouth.Color = outlineColor
            
            table.insert(elements.shapes, skull)
            table.insert(elements.shapes, leftEye)
            table.insert(elements.shapes, rightEye)
            table.insert(elements.lines, mouth)
            
        elseif style == "dollar" then
            local cx, cy = center.X, center.Y
            local s = baseSize
            
            local line1 = Drawing.new("Line")
            line1.From = Vector2.new(cx, cy - s)
            line1.To = Vector2.new(cx, cy + s)
            line1.Thickness = baseThick
            line1.Color = color
            
            local curve = Drawing.new("Circle")
            curve.Radius = s * 0.5
            curve.Thickness = baseThick
            curve.Filled = false
            curve.Color = color
            curve.Position = Vector2.new(cx, cy - s * 0.3)
            
            table.insert(elements.lines, line1)
            table.insert(elements.shapes, curve)
        end
        
        if outline and #elements.shapes > 0 then
            for _, shape in ipairs(elements.shapes) do
                if shape and shape.Visible ~= false then
                    local out = Drawing.new("Circle")
                    out.Radius = (shape.Radius or 10) + 2
                    out.Thickness = 1
                    out.Filled = false
                    out.Color = outlineColor
                    out.Position = shape.Position
                    table.insert(elements.outline, out)
                end
            end
        end
        
        elements.gui.Enabled = enabled
    end
    
    function self:setEnable(bool)
        enabled = bool
        if bool and not elements.gui then
            elements = createCrosshair()
        end
        if elements.gui then
            elements.gui.Enabled = bool
        end
        if bool then
            updatePosition()
        end
    end
    
    function self:setStyle(s)
        style = s
        updatePosition()
    end
    
    function self:setSize(s)
        size = s
        updatePosition()
    end
    
    function self:setGap(g)
        gap = g
        updatePosition()
    end
    
    function self:setThickness(t)
        thickness = t
        updatePosition()
    end
    
    function self:setColor(c)
        color = c
        updatePosition()
    end
    
    function self:setOutlineColor(c)
        outlineColor = c
        updatePosition()
    end
    
    function self:setOutline(bool)
        outline = bool
        updatePosition()
    end
    
    function self:setFollowMouse(bool)
        followMouse = bool
    end
    
    function self:setDynamic(bool)
        dynamic = bool
    end
    
    function self:getStyleList()
        return {"cross", "dot", "circle", "circlefilled", "t", "plus", "gap", "swastika", "nazi", "star", "heart", "skull", "dollar"}
    end
    
    function self:run()
        if dynamic or followMouse then
            RunService.RenderStepped:Connect(function()
                local mouse = UserInputService:GetMouseLocation()
                mouseOffset = mouse - Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
                
                if dynamic or followMouse then
                    updatePosition()
                end
            end)
        end
    end
    
    return self
end

return CrosshairModule