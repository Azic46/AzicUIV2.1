--[[
    AZIC UI - STANDALONE LOADING SCREEN
    File: LoadingScreen.lua
    Returns a small module used by Example.lua.
    No image assets, no blur effect, no external dependencies.
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LoadingScreen = {}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props or {}) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

function LoadingScreen.new(config)
    config = config or {}

    local accent = config.Accent or Color3.fromRGB(139, 92, 255)
    local background = config.Background or Color3.fromRGB(9, 10, 15)
    local panel = config.Panel or Color3.fromRGB(18, 19, 28)
    local textColor = config.Text or Color3.fromRGB(239, 240, 248)
    local muted = config.Muted or Color3.fromRGB(143, 149, 169)

    local gui = Instance.new("ScreenGui")
    gui.Name = "AzicLoadingScreen"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 100000
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local parented = pcall(function()
        gui.Parent = CoreGui
    end)

    if not parented then
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")
        if not playerGui then
            gui:Destroy()
            error("Azic LoadingScreen could not access CoreGui or PlayerGui")
        end
        gui.Parent = playerGui
    end

    local shade = make("Frame", {
        Name = "Shade",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = background,
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0
    }, gui)

    local center = make("Frame", {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(430, 228),
        BackgroundColor3 = panel,
        BorderSizePixel = 0
    }, shade)
    Instance.new("UICorner", center).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(48, 48, 67)
    stroke.Thickness = 1
    stroke.Transparency = 0.12
    stroke.Parent = center

    local scale = Instance.new("UIScale")
    scale.Scale = 0.94
    scale.Parent = center

    local topLine = make("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = accent,
        BorderSizePixel = 0
    }, center)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, accent:Lerp(Color3.new(1, 1, 1), 0.18)),
        ColorSequenceKeypoint.new(0.5, accent),
        ColorSequenceKeypoint.new(1, accent:Lerp(Color3.new(1, 1, 1), 0.18))
    })
    gradient.Parent = topLine

    local brand = make("TextLabel", {
        Name = "Brand",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(28, 28),
        Size = UDim2.new(1, -56, 0, 38),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "AZIC UI",
        TextColor3 = textColor,
        TextSize = 25,
        TextXAlignment = Enum.TextXAlignment.Left
    }, center)

    local edition = make("TextLabel", {
        Name = "Edition",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(29, 67),
        Size = UDim2.new(1, -58, 0, 18),
        Font = Enum.Font.GothamMedium,
        Text = config.Subtitle or "INITIALIZING INTERFACE",
        TextColor3 = muted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, center)

    local status = make("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(29, 119),
        Size = UDim2.new(1, -58, 0, 22),
        Font = Enum.Font.GothamMedium,
        Text = "Preparing components...",
        TextColor3 = textColor,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, center)

    local percent = make("TextLabel", {
        Name = "Percent",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -29, 0, 119),
        Size = UDim2.fromOffset(55, 22),
        Font = Enum.Font.RobotoMono,
        Text = "0%",
        TextColor3 = accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    }, center)

    local track = make("Frame", {
        Name = "ProgressTrack",
        Position = UDim2.fromOffset(29, 153),
        Size = UDim2.new(1, -58, 0, 4),
        BackgroundColor3 = Color3.fromRGB(43, 44, 59),
        BorderSizePixel = 0
    }, center)
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = make("Frame", {
        Name = "ProgressFill",
        Size = UDim2.fromScale(0, 1),
        BackgroundColor3 = accent,
        BorderSizePixel = 0
    }, track)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local foot = make("TextLabel", {
        Name = "Footer",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(29, 177),
        Size = UDim2.new(1, -58, 0, 16),
        Font = Enum.Font.Gotham,
        Text = config.Footer or "A precise interface. Nothing unnecessary.",
        TextColor3 = muted,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, center)

    local self = {
        Gui = gui,
        Panel = center,
        StatusLabel = status,
        PercentLabel = percent,
        Fill = fill,
        Destroyed = false
    }

    function self:SetProgress(value, message)
        if self.Destroyed then return end
        value = math.clamp(tonumber(value) or 0, 0, 1)
        if message then status.Text = tostring(message) end
        percent.Text = tostring(math.floor(value * 100 + 0.5)) .. "%"
        TweenService:Create(fill, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(value, 1)
        }):Play()
    end

    function self:SetStatus(message)
        if self.Destroyed then return end
        status.Text = tostring(message or "")
    end

    function self:Finish(message, duration)
        if self.Destroyed then return end
        self:SetProgress(1, message or "Ready")
        task.delay(duration or 0.45, function()
            if self.Destroyed then return end
            self:Destroy()
        end)
    end

    function self:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        local fade = TweenService:Create(center, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        local shadeFade = TweenService:Create(shade, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        fade:Play()
        shadeFade:Play()
        task.delay(0.24, function()
            if gui and gui.Parent then gui:Destroy() end
        end)
    end

    center.BackgroundTransparency = 1
    TweenService:Create(center, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(scale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    return self
end

return LoadingScreen
