--// Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// Settings
local Settings = {
    Aimbot = false,
    SilentAim = false,
    POVLock = false,
    TeamCheck = true,

    FOV = 150,
    Smoothness = 0.15,
    TargetPart = "Head",
    Priority = "Closest Crosshair"
}

--// FOV CIRCLE (FIXED)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Radius = Settings.FOV
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0,255,0)
FOVCircle.Transparency = 1

--// UI
local Window = Rayfield:CreateWindow({
    Name = "Rayfield Combat FIXED",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Bug Fixed",
    ConfigurationSaving = {Enabled = false}
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Aimbot",
    Callback = function(v) Settings.Aimbot = v end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    Callback = function(v) Settings.SilentAim = v end
})

CombatTab:CreateToggle({
    Name = "POV Lock",
    Callback = function(v) Settings.POVLock = v end
})

CombatTab:CreateSlider({
    Name = "FOV",
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
    Callback = function(v) Settings.Smoothness = v end
})

--// TARGET CHECK
local function ValidTarget(plr)
    if plr == LocalPlayer then return false end
    if Settings.TeamCheck and plr.Team == LocalPlayer.Team then return false end
    if not plr.Character then return false end

    local hum = plr.Character:FindFirstChild("Humanoid")
    local part = plr.Character:FindFirstChild(Settings.TargetPart)
    return hum and hum.Health > 0 and part
end

--// GET TARGET
local function GetTarget()
    local best, bestVal = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _,plr in pairs(Players:GetPlayers()) do
        if ValidTarget(plr) then
            local part = plr.Character[Settings.TargetPart]
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local dist = (Vector2.new(pos.X,pos.Y) - mousePos).Magnitude
            if dist > Settings.FOV then continue end

            if dist < bestVal then
                bestVal = dist
                best = part
            end
        end
    end
    return best
end

--// SILENT AIM (ONLY RAY)
local old
old = hookmetamethod(game,"__namecall",function(self,...)
    local args = {...}
    if Settings.SilentAim and getnamecallmethod()=="FindPartOnRayWithIgnoreList" then
        local t = GetTarget()
        if t then
            args[1] = Ray.new(Camera.CFrame.Position,(t.Position-Camera.CFrame.Position).Unit*1000)
            return old(self,unpack(args))
        end
    end
    return old(self,...)
end)

--// RENDER LOOP (FIXED)
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos

    local target = GetTarget()

    -- AIMBOT WORK EVEN IF SILENT AIM ON
    if Settings.Aimbot and target then
        local cf = CFrame.new(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(cf, Settings.Smoothness)
    end

    -- POV LOCK FORCE
    if Settings.POVLock and target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
    end
end)
