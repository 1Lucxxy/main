--==================================
-- RAYFIELD LOAD
--==================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--==================================
-- SERVICES
--==================================
local Players = game:GetService("Players")
local TeamsService = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================
-- WINDOW & TABS
--==================================
local Window = Rayfield:CreateWindow({
    Name = "ESP Highlight (Ultimate)",
    LoadingTitle = "ESP System",
    LoadingSubtitle = "Final Stable Build",
    ConfigurationSaving = { Enabled = false }
})

local ESPTab    = Window:CreateTab("ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local MiscTab   = Window:CreateTab("Misc", 4483362458)

--==================================
-- HIGHLIGHT SYSTEM (SAFE)
--==================================
local Highlights = {}

local function addHighlight(obj, color, category)
    if not obj or Highlights[obj] then return end
    local h = Instance.new("Highlight")
    h.Adornee = obj
    h.FillColor = color
    h.FillTransparency = 0.8
    h.OutlineTransparency = 1
    h.Parent = obj
    Highlights[obj] = {h=h, cat=category}
end

local function removeCategory(category)
    for obj,data in pairs(Highlights) do
        if data.cat == category then
            data.h:Destroy()
            Highlights[obj] = nil
        end
    end
end

--==================================
-- PLAYER ESP (SURVIVOR / KILLER)
--==================================
local PlayerESPEnabled = false

task.spawn(function()
    while task.wait(1) do
        if not PlayerESPEnabled then continue end
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
            and plr.Team
            and plr.Character
            and plr.Character:FindFirstChild("HumanoidRootPart") then
                local t = string.lower(plr.Team.Name)
                if t == "killer" then
                    addHighlight(plr.Character, Color3.fromRGB(255,0,0), "Player")
                elseif t == "survivors" then
                    addHighlight(plr.Character, Color3.fromRGB(0,255,0), "Player")
                end
            end
        end
    end
end)

ESPTab:CreateToggle({
    Name="Highlight Survivor & Killer",
    Callback=function(v)
        PlayerESPEnabled = v
        if not v then removeCategory("Player") end
    end
})

--==================================
-- OBJECT ESP
--==================================
local ObjectESP = {
    Generator=false,
    Hook=false,
    Window=false,
    Gift=false
}

local ObjColor = {
    Generator=Color3.fromRGB(255,255,0),
    Hook=Color3.fromRGB(255,0,255),
    Window=Color3.fromRGB(0,170,255),
    Gift=Color3.fromRGB(255,140,0)
}

local function scanObjects()
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and ObjectESP[v.Name] then
            addHighlight(v, ObjColor[v.Name], v.Name)
        end
    end
end

for name,_ in pairs(ObjectESP) do
    ESPTab:CreateToggle({
        Name="Highlight "..name,
        Callback=function(v)
            ObjectESP[name] = v
            if v then scanObjects() else removeCategory(name) end
        end
    })
end

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("Model") and ObjectESP[v.Name] then
        addHighlight(v, ObjColor[v.Name], v.Name)
    end
end)

--==================================
-- CROSSHAIR
--==================================
local Crosshair = Drawing.new("Circle")
Crosshair.Radius = 2
Crosshair.Filled = true
Crosshair.Visible = false

ESPTab:CreateToggle({
    Name="Crosshair Dot",
    Callback=function(v) Crosshair.Visible = v end
})

RunService.RenderStepped:Connect(function()
    if Crosshair.Visible then
        Crosshair.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
end)

--==================================
-- WALKSPEED (NO SLIDER)
--==================================
local WalkSpeedEnabled = false

PlayerTab:CreateToggle({
    Name="WalkSpeed 64",
    Callback=function(v) WalkSpeedEnabled = v end
})

RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = WalkSpeedEnabled and 64 or 16
    end
end)

--==================================
-- INVISIBLE (NON VISUAL, LOGIC)
--==================================
local InvisibleManual = false
local InvisibleAuto = false
local AutoInvisible = false
local KillerRadius = 25

local function applyInvisible()
    local char = LocalPlayer.Character
    if not char then return end
    local state = InvisibleManual or InvisibleAuto

    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
            v.CanTouch   = not state
            v.CanQuery   = not state
        end
    end
end

PlayerTab:CreateToggle({
    Name="Invisible (Logic)",
    Callback=function(v)
        InvisibleManual = v
        applyInvisible()
    end
})

PlayerTab:CreateToggle({
    Name="Auto Invisible (Killer Near)",
    Callback=function(v)
        AutoInvisible = v
        if not v then
            InvisibleAuto = false
            applyInvisible()
        end
    end
})

task.spawn(function()
    while task.wait(0.4) do
        if not AutoInvisible then continue end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local near = false
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer
            and plr.Team
            and string.lower(plr.Team.Name)=="killer"
            and plr.Character
            and plr.Character:FindFirstChild("HumanoidRootPart") then
                if (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude <= KillerRadius then
                    near = true
                    break
                end
            end
        end

        if near ~= InvisibleAuto then
            InvisibleAuto = near
            applyInvisible()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyInvisible()
end)

--==================================
-- MISC : CEK TEAM
--==================================
MiscTab:CreateButton({
    Name="Cek Team (Map)",
    Callback=function()
        local result="Team di map:\n"
        local teams=TeamsService:GetTeams()
        if #teams==0 then
            result="Tidak ada TeamService"
        else
            for _,t in ipairs(teams) do
                local c=0
                for _,p in ipairs(Players:GetPlayers()) do
                    if p.Team==t then c+=1 end
                end
                result..="- "..t.Name.." : "..c.." player\n"
            end
        end
        Rayfield:Notify({Title="Cek Team",Content=result,Duration=8})
    end
})

--==================================
-- MISC : CEK MODEL 5 STUDS
--==================================
MiscTab:CreateButton({
    Name="Cek Model Sekitar (5 studs)",
    Callback=function()
        local hrp=LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local found={}
        local result="Model sekitar (5 studs):\n"
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.PrimaryPart then
                if (v.PrimaryPart.Position-hrp.Position).Magnitude<=5 and not found[v.Name] then
                    found[v.Name]=true
                    result..="- "..v.Name.."\n"
                end
            end
        end

        if result=="Model sekitar (5 studs):\n" then
            result..="Tidak ada model"
        end

        Rayfield:Notify({Title="Cek Model Sekitar",Content=result,Duration=8})
    end
})
