--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// SETTINGS
local Settings = {
    Aimbot = false,
    POVTarget = false,
    TeamCheck = true,

    FOV = 150,
    Smoothness = 0.15,
    TargetPart = "Head",
    Priority = "Closest Crosshair"
}

--// POV / FOV CIRCLE (100% FORCE SHOW)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Filled = false
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(0,255,0)
FOVCircle.Transparency = 1
FOVCircle.Radius = Settings.FOV

--// UI
local Window = Rayfield:CreateWindow({
    Name = "Rayfield Combat FIX",
    LoadingTitle = "Loading",
    LoadingSubtitle = "POV Fixed",
    ConfigurationSaving = {Enabled = false}
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Aimbot",
    Callback = function(v)
        Settings.Aimbot = v
    end
})

CombatTab:CreateToggle({
    Name = "POV Target (Enable Targeting)",
    Callback = function(v)
        Settings.POVTarget = v
    end
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50,500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v)
        Settings.FOV = v
        FOVCircle.Radius = v
    end
})

CombatTab:CreateSlider({
    Name = "Smooth Aim",
    Range = {0,1},
    Increment = 0.05,
    CurrentValue = 0.15,
    Callback = function(v)
        Settings.Smoothness = v
    end
})

CombatTab:CreateDropdown({
    Name = "Target Part (Active only if POV Target ON)",
    Options = {"Head","HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(v)
        if Settings.POVTarget then
            Settings.TargetPart = v
        end
    end
})

CombatTab:CreateDropdown({
    Name = "Target Priority (Active only if POV Target ON)",
    Options = {"Closest Crosshair","Closest Distance","Lowest Health"},
    CurrentOption = "Closest Crosshair",
    Callback = function(v)
        if Settings.POVTarget then
            Settings.Priority = v
        end
    end
})

--// VALID TARGET CHECK
local function ValidTarget(plr)
    if plr == LocalPlayer then return false end
    if Settings.TeamCheck and plr.Team == LocalPlayer.Team then return false end
    if not plr.Character then return false end

    local hum = plr.Character:FindFirstChild("Humanoid")
    local part = plr.Character:FindFirstChild(Settings.TargetPart)
    return hum and hum.Health > 0 and part
end

--// GET TARGET (ONLY IF POVTarget ON)
local function GetTarget()
    if not Settings.POVTarget then return nil end

    local best, bestVal = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _,plr in pairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local part = plr.Character[Settings.TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local dist = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude
            if dist > Settings.FOV then continue end

            local value = dist
            if Settings.Priority == "Closest Distance" then
                value = (Camera.CFrame.Position - part.Position).Magnitude
            elseif Settings.Priority == "Lowest Health" then
                value = plr.Character.Humanoid.Health
            end

            if value < bestVal then
                bestVal = value
                best = part
            end
        end
    end

    return best
end

--// RENDER LOOP (FIX POV CIRCLE)
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Visible = true -- FORCE

    if Settings.Aimbot then
        local target = GetTarget()
        if target then
            local aimCF = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(aimCF, Settings.Smoothness)
        end
    end
end)
