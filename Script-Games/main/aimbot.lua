--// RAYFIELD LIBRARY
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = "Visual ESP",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "Visual System",
    ConfigurationSaving = {
        Enabled = false
    }
})

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// SETTINGS
local Settings = {
    Enabled = false,
    Box = false,
    Line = false,
    Name = false,
    HealthBar = false,
    Color = Color3.fromRGB(255,0,0)
}

local Drawings = {}

--// CLEAR
local function ClearESP()
    for _, d in pairs(Drawings) do
        pcall(function()
            d:Remove()
        end)
    end
    table.clear(Drawings)
end

--// NEW DRAWING
local function New(type, props)
    local d = Drawing.new(type)
    for i,v in pairs(props) do
        d[i] = v
    end
    table.insert(Drawings, d)
    return d
end

--// MAIN LOOP
RunService.RenderStepped:Connect(function()
    ClearESP()
    if not Settings.Enabled then return end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart")
        and plr.Character:FindFirstChild("Humanoid") then

            local hrp = plr.Character.HumanoidRootPart
            local hum = plr.Character.Humanoid

            local pos, onscreen = Camera:WorldToViewportPoint(hrp.Position)
            if not onscreen then continue end

            local screenPos = Vector2.new(pos.X, pos.Y)
            local boxSize = Vector2.new(40, 60)

            -- BOX
            if Settings.Box then
                New("Square", {
                    Position = screenPos - boxSize/2,
                    Size = boxSize,
                    Color = Settings.Color,
                    Thickness = 2,
                    Filled = false,
                    Visible = true
                })
            end

            -- LINE
            if Settings.Line then
                New("Line", {
                    From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y),
                    To = screenPos,
                    Color = Settings.Color,
                    Thickness = 2,
                    Visible = true
                })
            end

            -- NAME
            if Settings.Name then
                New("Text", {
                    Text = plr.Name,
                    Position = screenPos - Vector2.new(0,35),
                    Size = 16,
                    Center = true,
                    Outline = true,
                    Color = Settings.Color,
                    Visible = true
                })
            end

            -- HEALTH BAR
            if Settings.HealthBar then
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barHeight = boxSize.Y * hp

                -- background
                New("Square", {
                    Position = screenPos + Vector2.new(-30, -boxSize.Y/2),
                    Size = Vector2.new(4, boxSize.Y),
                    Color = Color3.fromRGB(40,40,40),
                    Filled = true,
                    Visible = true
                })

                -- hp
                New("Square", {
                    Position = screenPos + Vector2.new(-30, boxSize.Y/2 - barHeight),
                    Size = Vector2.new(4, barHeight),
                    Color = Color3.fromRGB(0,255,0),
                    Filled = true,
                    Visible = true
                })
            end
        end
    end
end)

--// TAB VISUAL
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(v)
        Settings.Enabled = v
        if not v then ClearESP() end
    end
})

VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Callback = function(v)
        Settings.Box = v
    end
})

VisualTab:CreateToggle({
    Name = "Line ESP",
    CurrentValue = false,
    Callback = function(v)
        Settings.Line = v
    end
})

VisualTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,
    Callback = function(v)
        Settings.Name = v
    end
})

VisualTab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Callback = function(v)
        Settings.HealthBar = v
    end
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Settings.Color,
    Callback = function(v)
        Settings.Color = v
    end
})
