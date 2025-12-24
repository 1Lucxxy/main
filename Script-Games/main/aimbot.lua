-- Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local Settings = {
    Aimbot = false,
    POVTarget = false,
    TeamCheck = true,
    FOV = 150,
    Smoothness = 0.3,
    TargetPart = "Head",
    Priority = "Closest Crosshair"
}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Filled = false
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Transparency = 1
FOVCircle.Radius = Settings.FOV

-- UI
local Window = Rayfield:CreateWindow({
    Name = "Rayfield Aimbot FULL",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Complete Version",
    ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Toggles
CombatTab:CreateToggle({
    Name = "Aimbot",
    Callback = function(v)
        Settings.Aimbot = v
    end
})

CombatTab:CreateToggle({
    Name = "POV Target",
    Callback = function(v)
        Settings.POVTarget = v
    end
})

-- Sliders
CombatTab:CreateSlider({
    Name = "Smooth Aim",
    Range = {0,1},
    Increment = 0.05,
    CurrentValue = Settings.Smoothness,
    Callback = function(v)
        Settings.Smoothness = v
    end
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50,500},
    Increment = 10,
    CurrentValue = Settings.FOV,
    Callback = function(v)
        Settings.FOV = v
        FOVCircle.Radius = v
    end
})

-- Dropdowns
CombatTab:CreateDropdown({
    Name = "Target Part (Active only if POV Target ON)",
    Options = {"Head","HumanoidRootPart"},
    CurrentOption = Settings.TargetPart,
    Callback = function(v)
        if Settings.POVTarget then
            Settings.TargetPart = v
        end
    end
})

CombatTab:CreateDropdown({
    Name = "Target Priority (Active only if POV Target ON)",
    Options = {"Closest Crosshair","Closest Distance","Lowest Health"},
    CurrentOption = Settings.Priority,
    Callback = function(v)
        if Settings.POVTarget then
            Settings.Priority = v
        end
    end
})

-- Functions
local function ValidTarget(plr)
    if plr == LocalPlayer then return false end
    if Settings.TeamCheck and plr.Team == LocalPlayer.Team then return false end
    if not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChild("Humanoid")
    local part = plr.Character:FindFirstChild(Settings.TargetPart)
    return humanoid and humanoid.Health > 0 and part
end

local function GetTarget()
    if not Settings.POVTarget then return nil end
    local best, bestVal = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _,plr in pairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local part = plr.Character[Settings.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local dist
            if Settings.Priority == "Closest Crosshair" then
                dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            elseif Settings.Priority == "Closest Distance" then
                dist = (Camera.CFrame.Position - part.Position).Magnitude
            elseif Settings.Priority == "Lowest Health" then
                dist = plr.Character.Humanoid.Health
            end

            if dist < bestVal then
                bestVal = dist
                best = part
            end
        end
    end

    return best
end

-- Render loop
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Visible = true -- Force show

    if Settings.Aimbot then
        local target = GetTarget()
        if target then
            local newCF = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(newCF, Settings.Smoothness)
        end
    end
end)
