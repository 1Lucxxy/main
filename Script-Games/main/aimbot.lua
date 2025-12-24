-- // Lucxx Hub V2 Full
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local vim = game:GetService("VirtualInputManager")

-- // Window
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Lucxx Hub V2 Full",
    LoadingTitle = "LHub",
    LoadingSubtitle = "by Lucxxy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LucxxHub",
        FileName = "Config"
    },
    Discord = { Enabled = false }
})

-- // Combat Tab
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- ======================================================
-- VARIABLES
-- ======================================================
local TeamCheck = false
local AimLockEnabled = false
local WallCheckEnabled = false
local TracerEnabled = false
local FOVRadius = 100
local AimlockRange = 200
local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
local DrawingESP = {}

-- POV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = FOVRadius
FOVCircle.NumSides = 64
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0,255,0)
FOVCircle.Visible = false

-- ======================================================
-- Combat Tab UI
-- ======================================================
CombatTab:CreateSlider({
    Name = "FOV Circle Radius",
    Range = {100,300},
    Increment = 1,
    CurrentValue = FOVRadius,
    Callback = function(Value)
        FOVRadius = Value
        FOVCircle.Radius = Value
    end
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(Value) TeamCheck = Value end
})

CombatTab:CreateToggle({
    Name = "Aim Lock",
    CurrentValue = false,
    Callback = function(Value)
        AimLockEnabled = Value
        FOVCircle.Visible = Value
    end
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(Value) WallCheckEnabled = Value end
})

CombatTab:CreateToggle({
    Name = "Tracer",
    CurrentValue = false,
    Callback = function(Value) TracerEnabled = Value end
})

CombatTab:CreateSlider({
    Name = "Aimlock Range",
    Range = {50,1000},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = AimlockRange,
    Callback = function(Value) AimlockRange = Value end
})

-- ======================================================
-- MAIN LOOP
-- ======================================================
RunService.RenderStepped:Connect(function()
    screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Position = screenCenter

    -- Aimlock
    if AimLockEnabled then
        local nearestPlayer
        local nearestDistance = AimlockRange
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 1 then
                    if not TeamCheck or (TeamCheck and plr.Team ~= LocalPlayer.Team) then
                        local headPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                        if onScreen then
                            local dist = (Vector2.new(headPos.X,headPos.Y) - screenCenter).Magnitude
                            if dist <= FOVRadius and dist < nearestDistance then
                                nearestDistance = dist
                                nearestPlayer = plr
                            end
                        end
                    end
                end
            end
        end

        if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("Head") then
            local headPos = nearestPlayer.Character.Head.Position
            local canSee = true
            if WallCheckEnabled then
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, nearestPlayer.Character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                local rayResult = workspace:Raycast(Camera.CFrame.Position, (headPos - Camera.CFrame.Position), rayParams)
                if rayResult then canSee = false end
            end
            if canSee then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
            end
        end
    end

    -- Tracer
    if TracerEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local head = plr.Character.Head
                if hum and hum.Health > 1 then
                    if not DrawingESP[plr] then DrawingESP[plr] = {} end
                    if not DrawingESP[plr].Tracer then
                        DrawingESP[plr].Tracer = Drawing.new("Line")
                        DrawingESP[plr].Tracer.Thickness = 1.5
                        DrawingESP[plr].Tracer.Color = Color3.fromRGB(0,255,255)
                    end
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        DrawingESP[plr].Tracer.From = screenCenter
                        DrawingESP[plr].Tracer.To = Vector2.new(pos.X,pos.Y)
                        DrawingESP[plr].Tracer.Visible = true
                    else
                        DrawingESP[plr].Tracer.Visible = false
                    end
                end
            elseif DrawingESP[plr] and DrawingESP[plr].Tracer then
                DrawingESP[plr].Tracer.Visible = false
            end
        end
    else
        for _, plr in pairs(DrawingESP) do
            if plr.Tracer then plr.Tracer.Visible = false end
        end
    end
end)
