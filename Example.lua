--[[
    AZIC UI - COMPLETE SHOWCASE
    File: Example.lua

    Required files in the same GitHub repository:
      Library.lua
      LoadingScreen.lua

    This is a clean UI-library showcase.
    It demonstrates interface components only; it does not automate gameplay.
]]

local REPO = "https://raw.githubusercontent.com/Azic46/AzicUI/main/"

--==============================================================
-- 1. STANDALONE LOADING SCREEN
--==============================================================

local Loader
local loadingOK, LoadingModule = pcall(function()
    local source = game:HttpGet(REPO .. "LoadingScreen.lua")
    local chunk, err = loadstring(source)
    assert(chunk, tostring(err))
    return chunk()
end)

if loadingOK and type(LoadingModule) == "table" and LoadingModule.new then
    local ok, result = pcall(function()
        return LoadingModule.new({
            Title = "AZIC UI",
            Subtitle = "VERSION 2.1  /  INITIALIZING",
            Footer = "A precise interface. Nothing unnecessary.",
            Accent = Color3.fromRGB(139, 92, 255)
        })
    end)
    if ok then Loader = result end
end

local function Progress(value, message)
    if Loader then
        pcall(function()
            Loader:SetProgress(value, message)
        end)
    end
end

Progress(0.12, "Loading core library...")

--==============================================================
-- 2. LOAD LIBRARY
--==============================================================

local Library
local loadOK, result = pcall(function()
    local source = game:HttpGet(REPO .. "Library.lua")
    assert(type(source) == "string" and #source > 0, "Library source is empty")
    local chunk, err = loadstring(source)
    assert(chunk, tostring(err))
    return chunk()
end)

if not loadOK then
    warn("[AZIC] Library load failed:", result)
    if Loader then
        Loader:SetStatus("Library failed to load. Check the console.")
    end
    return
end

Library = result
assert(type(Library) == "table", "Invalid Library return value")

local Options = Library.Options
local Toggles = Library.Toggles

Progress(0.35, "Applying visual system...")

--==============================================================
-- 3. DESIGN SYSTEM
--==============================================================

local Accent = Color3.fromRGB(139, 92, 255)

local Palette = {
    Background = Color3.fromRGB(13, 13, 19),
    Panel = Color3.fromRGB(20, 20, 29),
    Element = Color3.fromRGB(29, 29, 42),
    ElementHover = Color3.fromRGB(40, 40, 58),
    Outline = Color3.fromRGB(46, 46, 66),
    Text = Color3.fromRGB(236, 236, 245),
    Muted = Color3.fromRGB(148, 163, 184),
    Control = Color3.fromRGB(100, 116, 139),
    Accent = Accent,
    AccentText = Color3.fromRGB(180, 149, 255),
    Risk = Color3.fromRGB(255, 85, 95)
}

for key, color in pairs(Palette) do
    Library.Theme[key] = color
end

Library.Themes.Amethyst = Accent
Library.Themes.Ice = Color3.fromRGB(116, 190, 255)
Library.Themes.Silver = Color3.fromRGB(190, 198, 215)

Library.IgnoreIndexes = { "MenuKeybind" }
Library.NotifySide = "Right"
Library.AnimationSpeed = 1
Library.ReducedMotion = false
Library.AmbientEffects = true
Library.GlowEnabled = true
Library.ShineEnabled = true

local function Notify(title, description, kind)
    Library:Notify({
        Type = kind or "Success",
        Title = title or "Azic UI",
        Description = description or "",
        Time = 4
    })
end

local function SafeBuild(name, callback)
    local ok, err = xpcall(callback, debug.traceback)
    if not ok then
        warn("[AZIC] Could not build " .. name .. ":")
        warn(err)
    else
        print("[AZIC] Built:", name)
    end
    return ok
end

Progress(0.52, "Creating main window...")

--==============================================================
-- 4. MAIN WINDOW
--==============================================================

local Window = Library:CreateWindow({
    Title = "Azic UI",
    Subtitle = "Control Center",
    MatrixWord = "AZIC",
    Matrix = true,
    Resizable = true,
    Launcher = true,
    NotifySide = "Right",
    AutoShow = false
})

Library:SetAccent(Accent)

Progress(0.65, "Building dashboard and media...")

-- Built-in pages from the library.
SafeBuild("Dashboard", function()
    Library:BuildDashboardTab(Window)
end)

SafeBuild("Music", function()
    Library:BuildMusicTab(Window)
end)

--==============================================================
-- 5. CONTROL CENTER
--==============================================================

SafeBuild("Control Center", function()

    local Category = Window:AddCategory("Control Center", "game")

    -- Main settings page
    local Main = Category:AddTab("Main", "home")

    local Overview = Main:AddLeftGroupbox(
        "Interface Overview",
        "A clean collection of the core controls"
    )

    Overview:AddLabel("AZIC UI", true)
    Overview:AddLabel("Version " .. tostring(Library.Version))
    Overview:AddDivider()

    Overview:AddToggle("Demo_Enabled", {
        Text = "Example feature",
        Default = true,
        Tooltip = "A demonstration toggle",
        Callback = function(value)
            print("[AZIC] Example feature:", value)
        end
    })

    Overview:AddSlider("Demo_Intensity", {
        Text = "Intensity",
        Default = 55,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Suffix = "%",
        Callback = function(value)
            print("[AZIC] Intensity:", value)
        end
    })

    Overview:AddButton({
        Text = "Test notification",
        Func = function()
            Notify("Azic UI", "The notification system is working.")
        end
    })

    local Profile = Main:AddRightGroupbox(
        "Session",
        "Live session information"
    )

    Profile:AddProfile()
    Profile:AddDivider()
    Profile:AddStat("Library", "Azic UI")
    Profile:AddStat("Version", Library.Version)
    Profile:AddStat("Place ID", game.PlaceId)
    Profile:AddStat("Players", #game:GetService("Players"):GetPlayers())

    -- Input & selection page
    local Inputs = Category:AddTab("Inputs", "bolt")

    local InputGroup = Inputs:AddLeftGroupbox(
        "Text & Number Inputs"
    )

    InputGroup:AddInput("Demo_Text", {
        Text = "Text field",
        Placeholder = "Enter a value...",
        Default = "",
        MaxLength = 48,
        Callback = function(value)
            print("[AZIC] Text:", value)
        end
    })

    InputGroup:AddInput("Demo_Number", {
        Text = "Numeric field",
        Placeholder = "Enter a number...",
        Numeric = true,
        MaxLength = 12
    })

    local SelectGroup = Inputs:AddRightGroupbox(
        "Selection Controls"
    )

    SelectGroup:AddDropdown("Demo_Choice", {
        Text = "Single selection",
        Values = { "Default", "Compact", "Comfortable", "Expanded" },
        Default = "Default",
        Searchable = true,
        Callback = function(value)
            print("[AZIC] Layout:", value)
        end
    })

    SelectGroup:AddDropdown("Demo_Multi", {
        Text = "Multi selection",
        Values = { "Dashboard", "Controls", "Inputs", "Appearance", "Settings" },
        Multi = true,
        Searchable = true,
        Default = { "Dashboard", "Controls" }
    })

    -- Appearance page
    local Appearance = Category:AddTab("Appearance", "eye")

    local ThemeGroup = Appearance:AddLeftGroupbox(
        "Accent & Color",
        "Switch the single interface accent"
    )

    ThemeGroup:AddDropdown("Demo_Accent", {
        Text = "Accent preset",
        Values = { "Amethyst", "Ice", "Silver", "Violet" },
        Default = "Amethyst",
        Callback = function(value)
            local colors = {
                Amethyst = Color3.fromRGB(139, 92, 255),
                Ice = Color3.fromRGB(116, 190, 255),
                Silver = Color3.fromRGB(190, 198, 215),
                Violet = Color3.fromRGB(139, 92, 255)
            }
            local color = colors[value]
            if color then
                Library:SetAccent(color)
            end
        end
    })

    ThemeGroup:AddLabel("Custom accent"):AddColorPicker("Demo_CustomAccent", {
        Default = Accent,
        Title = "Choose accent",
        Callback = function(color)
            Library:SetAccent(color)
        end
    })

    local Effects = Appearance:AddRightGroupbox(
        "Motion & Effects",
        "Keep effects subtle and adjustable"
    )

    Effects:AddToggle("Demo_Matrix", {
        Text = "Matrix background",
        Default = true,
        Callback = function(value)
            Window.Matrix:SetEnabled(value)
        end
    })

    Effects:AddToggle("Demo_Glow", {
        Text = "Window glow",
        Default = true,
        Callback = function(value)
            Library.GlowEnabled = value
        end
    })

    Effects:AddToggle("Demo_Shine", {
        Text = "Shine effects",
        Default = true,
        Callback = function(value)
            Library.ShineEnabled = value
        end
    })

    Effects:AddToggle("Demo_Ambient", {
        Text = "Ambient effects",
        Default = true,
        Callback = function(value)
            Library.AmbientEffects = value
        end
    })

    Effects:AddToggle("Demo_ReducedMotion", {
        Text = "Reduce motion",
        Default = false,
        Callback = function(value)
            Library.ReducedMotion = value
        end
    })

    Effects:AddSlider("Demo_AnimationSpeed", {
        Text = "Animation speed",
        Default = 1,
        Min = 0.25,
        Max = 2,
        Rounding = 2,
        Suffix = "x",
        Callback = function(value)
            Library.AnimationSpeed = value
        end
    })

    -- Layout and dependency examples
    local Layout = Category:AddTab("Layout", "matrix")

    local Dependencies = Layout:AddLeftGroupbox(
        "Conditional Settings",
        "Controls can depend on another control"
    )

    Dependencies:AddToggle("Demo_ShowAdvanced", {
        Text = "Show advanced options",
        Default = false
    })

    local DepBox = Dependencies:AddDependencyBox()

    DepBox:AddSlider("Demo_AdvancedValue", {
        Text = "Advanced value",
        Default = 5,
        Min = 0,
        Max = 10,
        Rounding = 0
    })

    DepBox:AddToggle("Demo_AdvancedSwitch", {
        Text = "Advanced switch",
        Default = true
    })

    DepBox:SetupDependencies({
        { Toggles.Demo_ShowAdvanced, true }
    })

    local Tabs = Layout:AddRightTabbox()
    local TabA = Tabs:AddTab("General")
    local TabB = Tabs:AddTab("Details")

    TabA:AddLabel("A compact tabbox example.", true)
    TabA:AddToggle("Demo_TabToggle", {
        Text = "Tabbox toggle",
        Default = true
    })

    TabB:AddLabel("Additional controls.", true)
    TabB:AddSlider("Demo_TabSlider", {
        Text = "Tabbox slider",
        Default = 40,
        Min = 0,
        Max = 100,
        Rounding = 0
    })

    -- Viewport
    local View = Category:AddTab("3D Preview", "game")

    local ViewGroup = View:AddRightGroupbox(
        "Model Preview",
        "A simple 3D viewport example"
    )

    local sample = Instance.new("Part")
    sample.Name = "AzicPreviewModel"
    sample.Size = Vector3.new(3, 3, 3)
    sample.Anchored = true
    sample.Material = Enum.Material.Metal
    sample.Color = Accent

    ViewGroup:AddViewport(nil, {
        Height = 230,
        Model = sample
    })

    Library:OnUnload(function()
        if sample and sample.Parent then
            sample:Destroy()
        end
    end)

    ViewGroup:AddLabel(
        "The viewport renders a model without using a blurry image asset.",
        true
    )

end)

Progress(0.84, "Building settings and configuration...")

--==============================================================
-- 6. SETTINGS
--==============================================================

SafeBuild("Settings", function()

    local Settings = Window:AddTab("Settings", "gear")

    local Menu = Settings:AddLeftGroupbox(
        "Menu",
        "Navigation and session controls"
    )

    Menu:AddLabel("Toggle menu key"):AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        Mode = "Toggle",
        NoUI = true,
        Text = "Menu key"
    })

    Library.ToggleKeybind = Options.MenuKeybind

    Menu:AddButton({
        Text = "Show notification",
        Func = function()
            Notify("Azic UI", "Settings are working.")
        end
    })

    Menu:AddButton({
        Text = "Unload library",
        DoubleClick = true,
        Func = function()
            Library:Unload()
        end
    })

    local Visual = Settings:AddLeftGroupbox(
        "Appearance",
        "Built-in theme and effect controls"
    )

    Library:BuildThemeSection(Visual)

    local Configs = Settings:AddRightGroupbox(
        "Configurations",
        "Save and restore your settings"
    )

    Library:BuildConfigSection(Configs)

    local About = Settings:AddRightGroupbox(
        "About",
        "Library information"
    )

    About:AddLabel("Azic UI", true)
    About:AddLabel("Version " .. tostring(Library.Version))
    About:AddLabel("Design: Dark / Low-glare")
    About:AddLabel("Accent: Amethyst")
    About:AddLabel("Rendering: Vector UI")

end)

--==============================================================
-- 7. SHOW WINDOW AND FINISH LOADING
--==============================================================

Library:SetWatermark("AZIC UI  /  " .. tostring(Library.Version))
Library:SetWatermarkVisibility(true)

Window:SetSubtitle("Control Center")
Window:SetVisible(true)

Progress(1, "Ready")

if Loader then
    Loader:Finish("Interface ready", 0.55)
end

Library:Notify({
    Type = "Success",
    Title = "Azic UI ready",
    Description = "Control Center initialized.",
    Time = 5
})

print("==========================================")
print("[AZIC] AZIC UI SHOWCASE READY")
print("[AZIC] Version:", Library.Version)
print("[AZIC] Loading screen: separate module")
print("[AZIC] Dashboard / Music / Controls / Settings")
print("[AZIC] Responsive window sizing enabled")
print("==========================================")
