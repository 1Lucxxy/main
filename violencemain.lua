--==================================================
-- RAYFIELD
--==================================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- WINDOW
--==================================================
local Window = Rayfield:CreateWindow({
    Name = "ESP FINAL LENGKAP",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Stable & No FPS Drop",
    ConfigurationSaving = {Enabled = false}
})

local ESPTab    = Window:CreateTab("ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab   = Window:CreateTab("Misc", 4483362458)

--==================================================
-- PLAYER ESP (SURVIVOR & KILLER)
--==================================================
local PlayerESPEnabled = false
local PlayerHighlights = {}

local function clearPlayerESP()
    for _,h in pairs(PlayerHighlights) do
        if h then h:Destroy() end
    end
    table.clear(PlayerHighlights)
end

local function applyESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not plr.Team then return end

    if PlayerHighlights[plr] then
        PlayerHighlights[plr]:Destroy()
    end

    local teamName = string.lower(plr.Team.Name)
    local color

    if teamName == "killer" then
        color = Color3.fromRGB(255,0,0)
    elseif teamName == "survivors" then
        color = Color3.fromRGB(0,255,0)
    else
        return
    end

    local h = Instance.new("Highlight")
    h.Adornee = plr.Character
    h.FillColor = color
    h.FillTransparency = 0.8
    h.OutlineTransparency = 1
    h.Parent = plr.Character

    PlayerHighlights[plr] = h
end

local function refreshESP()
    clearPlayerESP()
    for _,p in ipairs(Players:GetPlayers()) do
        applyESP(p)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.3)
        if PlayerESPEnabled then applyESP(p) end
    end)
end)

ESPTab:CreateToggle({
    Name = "ESP Survivor & Killer",
    Callback = function(v)
        PlayerESPEnabled = v
        if v then
            refreshESP()
        else
            clearPlayerESP()
        end
    end
})

--==================================================
-- OBJECT ESP
--==================================================
local ObjectESP = {
    Generator = {Color=Color3.fromRGB(255,255,0), Items={}},
    Hook      = {Color=Color3.fromRGB(255,0,255), Items={}},
    Window    = {Color=Color3.fromRGB(0,170,255), Items={}},
    Gift      = {Color=Color3.fromRGB(255,165,0), Items={}}
}

local function clearObject(name)
    for _,h in ipairs(ObjectESP[name].Items) do
        if h then h:Destroy() end
    end
    ObjectESP[name].Items = {}
end

local function scanObject(name)
    clearObject(name)
    for _,v in ipairs(workspace:GetDescendants()) do
        if (v:IsA("Model") or v:IsA("MeshPart")) and v.Name == name then
            local h = Instance.new("Highlight")
            h.Adornee = v
            h.FillColor = ObjectESP[name].Color
            h.FillTransparency = 0.8
            h.OutlineTransparency = 1
            h.Parent = v
            table.insert(ObjectESP[name].Items, h)
        end
    end
end

ESPTab:CreateToggle({Name="Generator",Callback=function(v) if v then scanObject("Generator") else clearObject("Generator") end end})
ESPTab:CreateToggle({Name="Hook",Callback=function(v) if v then scanObject("Hook") else clearObject("Hook") end end})
ESPTab:CreateToggle({Name="Window",Callback=function(v) if v then scanObject("Window") else clearObject("Window") end end})
ESPTab:CreateToggle({Name="Event / Gift",Callback=function(v) if v then scanObject("Gift") else clearObject("Gift") end end})

--==================================================
-- CROSSHAIR DOT
--==================================================
local Crosshair = Drawing.new("Circle")
Crosshair.Radius = 2
Crosshair.Filled = true
Crosshair.Color = Color3.fromRGB(255,255,255)
Crosshair.Visible = false
local CrosshairEnabled = false

ESPTab:CreateToggle({
    Name="Crosshair Dot",
    Callback=function(v)
        CrosshairEnabled=v
        Crosshair.Visible=v
    end
})

RunService.RenderStepped:Connect(function()
    if CrosshairEnabled then
        Crosshair.Position = Vector2.new(
            Camera.ViewportSize.X/2,
            Camera.ViewportSize.Y/2
        )
    end
end)

--==================================================
-- WALKSPEED 64 (ANTI RESET)
--==================================================
local SpeedConn
PlayerTab:CreateToggle({
    Name="WalkSpeed 64",
    Callback=function(v)
        if SpeedConn then SpeedConn:Disconnect() SpeedConn=nil end
        if v then
            SpeedConn = RunService.Heartbeat:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 64 end
            end)
        else
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

--==================================================
-- NOCLIP
--==================================================
MiscTab:CreateToggle({
    Name="Noclip",
    Callback=function(v)
        RunService.Stepped:Connect(function()
            if v and LocalPlayer.Character then
                for _,p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide=false end
                end
            end
        end)
    end
})

--==================================================
-- MISC : CEK TEAM
--==================================================
MiscTab:CreateButton({
    Name="Cek Team di Map",
    Callback=function()
        local txt="Team di map:\n"
        for _,t in ipairs(Teams:GetTeams()) do
            txt.."- "..t.Name.."\n"
        end
        Rayfield:Notify({Title="Team Info",Content=txt,Duration=6})
    end
})

--==================================================
-- MISC : CEK MODEL SEKITAR
--==================================================
MiscTab:CreateButton({
    Name="Cek Model Sekitar (5 studs)",
    Callback=function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local txt="Model sekitar:\n"
        for _,v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") and v.PrimaryPart then
                if (v.PrimaryPart.Position-hrp.Position).Magnitude<=5 then
                    txt.."- "..v.Name.."\n"
                end
            end
        end
        Rayfield:Notify({Title="Nearby",Content=txt,Duration=6})
    end
})
