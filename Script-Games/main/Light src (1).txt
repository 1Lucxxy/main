-- SKID HUB (AI)
local P=game:GetService("Players").LocalPlayer
local R=game:GetService("ReplicatedStorage")
local W=game:GetService("Workspace")
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local V=Vector3.new
local C=Color3.fromRGB

--== GUI TOGGLE =================================================
local tog=Instance.new("ScreenGui")tog.Name="-SKID"tog.ZIndexBehavior=Enum.ZIndexBehavior.Sibling tog.Parent=P:WaitForChild("PlayerGui")
local tf=Instance.new("Frame",tog)tf.Size=UDim2.new(0,50,0,50)tf.Position=UDim2.new(1,-60,0,10)tf.BackgroundColor3=C(0,0,0)tf.BorderSizePixel=0
Instance.new("UICorner",tf).CornerRadius=UDim.new(0,12)
local st=Instance.new("UIStroke",tf)st.Color=C(80,80,80)st.Thickness=3 st.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
local tl=Instance.new("TextLabel",tf)tl.Size=UDim2.new(1,0,1,0)tl.BackgroundTransparency=1 tl.Text="SH"tl.TextColor3=C(255,255,255)tl.TextSize=18 tl.Font=Enum.Font.GothamBold
local togBtn=Instance.new("TextButton",tf)togBtn.Size=UDim2.new(1,0,1,0)togBtn.BackgroundTransparency=1 togBtn.Text=""

--== MAIN GUI ===================================================
local gui=Instance.new("ScreenGui")gui.Name="-SKID"gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.Enabled=false gui.Parent=P:WaitForChild("PlayerGui")
local main=Instance.new("Frame",gui)main.Size=UDim2.new(0,200,0,270)main.Position=UDim2.new(.5,-100,.5,-135)main.BackgroundTransparency=1 main.Active=true main.Draggable=true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,8)

local top=Instance.new("Frame",main)top.Size=UDim2.new(1,0,0,35)top.BackgroundTransparency=1
Instance.new("UICorner",top).CornerRadius=UDim.new(0,8)
local title=Instance.new("TextLabel",top)title.Size=UDim2.new(1,0,1,0)title.BackgroundTransparency=1 title.Text="FUCKED BY CLOUD"title.TextColor3=C(255,255,255)title.TextTransparency=1 title.TextSize=17 title.Font=Enum.Font.GothamBold

local cont=Instance.new("Frame",main)cont.Size=UDim2.new(1,-16,1,-70)cont.Position=UDim2.new(0,8,0,45)cont.BackgroundTransparency=1
local disc=Instance.new("TextLabel",main)disc.Size=UDim2.new(1,-16,0,20)disc.Position=UDim2.new(0,8,1,-60)disc.BackgroundTransparency=1 disc.Text="discord.gg/skidhub"disc.TextColor3=C(150,150,150)disc.TextTransparency=1 disc.TextSize=12 disc.Font=Enum.Font.Gotham disc.TextXAlignment=Enum.TextXAlignment.Center

--== PAGES ======================================================
local pages={Instance.new("Frame",cont),Instance.new("Frame",cont),Instance.new("Frame",cont)}
for _,f in ipairs(pages)do f.Size=UDim2.new(1,0,1,0)f.BackgroundTransparency=1 end
pages[1].Visible=true

--== BUTTON CREATOR =============================================
local function btn(par,txt,pos,func)
 local b=Instance.new("TextButton",par)b.Size=UDim2.new(1,0,0,35)b.Position=pos b.BackgroundColor3=C(35,35,35)b.BackgroundTransparency=.03 b.Text=txt b.TextColor3=C(180,180,180)b.TextSize=15 b.Font=Enum.Font.GothamBold b.AutoButtonColor=false b.TextXAlignment=Enum.TextXAlignment.Center
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
 local dot=Instance.new("TextLabel",b)dot.Size=UDim2.new(0,15,0,15)dot.Position=UDim2.new(0,6,.5,-7)dot.BackgroundTransparency=1 dot.Text="•"dot.TextColor3=C(120,120,120)dot.TextSize=22 dot.Font=Enum.Font.GothamBold
 b.MouseButton1Click:Connect(func)
 return b
end

--== PAGE 1 ----------------------------------------------------
local desync=false
btn(pages[1],"DESYNC",UDim2.new(0,0,0,0),function()
 desync=not desync
 local chr=P.Character or P.CharacterAdded:Wait()
 local hum=chr:WaitForChild("Humanoid")
 hum:ChangeState(desync and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end)

btn(pages[1],"INVISIBLE",UDim2.new(0,0,0,40),function()
 local chr=P.Character or P.CharacterAdded:Wait()
 for _,v in ipairs(chr:GetDescendants())do if v:IsA("BasePart")then v.Transparency=v.Transparency==1 and 0 or 1 end end
end)

btn(pages[1],"AIMBOT SHOOTER",UDim2.new(0,0,0,80),function()
 local cam=workspace.CurrentCamera
 local function aim()
  local closest,dist=nil,math.huge
  for _,pl in ipairs(game.Players:GetPlayers())do
   if pl~=P and pl.Character and pl.Character:FindFirstChild("Head")then
    local head=pl.Character.Head
    local screen,vis=cam:WorldToViewportPoint(head.Position)
    if vis then
     local d=(Vector2.new(screen.X,screen.Y)-Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)).Magnitude
     if d<dist then dist,closest=d,head end
    end
   end
  end
  if closest then cam.CFrame=CFrame.new(cam.CFrame.Position,closest.Position) end
 end
 spawn(function()while wait()do if _G.aim then aim()end end end)
 _G.aim=true
end)

btn(pages[1],"FLY TO BASE",UDim2.new(0,0,0,120),function()
 local bases={V(-343.2,22,-101),V(-342.6,22,4.2),V(-342.2,21.9,111.6),V(-341.7,22,221.1),
              V(-476.4,22,224.7),V(-476.6,22,116.1),V(-476.4,22,6.3),V(-477,22,-99.4)}
 local chr=P.Character or P.CharacterAdded:Wait()
 local hrp=chr:WaitForChild("HumanoidRootPart")
 local target=bases[math.random(1,#bases)]
 hrp.CFrame=CFrame.new(target)
end)

--== PAGE 2 ----------------------------------------------------
btn(pages[2],"MAIN ESP",UDim2.new(0,0,0,0),function()
 for _,pl in ipairs(game.Players:GetPlayers())do
  if pl~=P and pl.Character then
   local hl=Instance.new("Highlight",pl.Character)hl.FillColor=C(255,0,0)hl.OutlineColor=C(255,255,255)
  end
 end
end)

btn(pages[2],"GO TO HIGHEST",UDim2.new(0,0,0,40),function()
 local chr=P.Character or P.CharacterAdded:Wait()
 local hrp=chr:WaitForChild("HumanoidRootPart")
 local highest=-math.huge
 local target
 for _,part in ipairs(W:GetDescendants())do
  if part:IsA("BasePart") and part.Position.Y>highest then highest,target=part.Position.Y,part.Position end
 end
 if target then hrp.CFrame=CFrame.new(target+Vector3.new(0,5,0)) end
end)

btn(pages[2],"AUTO JOINER",UDim2.new(0,0,0,80),function()
 spawn(function()
  while wait(30)do
   if #game.Players:GetPlayers()<game.Players.MaxPlayers then
    game:GetService("TeleportService"):Teleport(game.PlaceId,P)
   end
  end
 end)
end)

btn(pages[2],"WEBSLING KILL",UDim2.new(0,0,0,120),function()
 local chr=P.Character or P.CharacterAdded:Wait()
 local tool=chr:FindFirstChildOfClass("Tool")or R:FindFirstChild("WebSling") and R.WebSling:Clone()
 if tool then tool.Parent=chr
  firetouchinterest(tool.Handle,game.Players:GetPlayers()[2].Character.HumanoidRootPart,0)
 end
end)

--== PAGE 3 ----------------------------------------------------
btn(pages[3],"XRAY",UDim2.new(0,0,0,0),function()
 for _,v in ipairs(W:GetDescendants())do
  if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then v.Transparency=v.Transparency==0.7 and 0 or 0.7 end
 end
end)

local inf=false
btn(pages[3],"INF JUMP",UDim2.new(0,0,0,40),function()
 inf=not inf
 if inf then
  U.JumpRequest:Connect(function()P.Character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)end)
 end
end)

btn(pages[3],"KILL TURRETS",UDim2.new(0,0,0,80),function()
 for _,t in ipairs(W:GetDescendants())do
  if t.Name:find("Turret") and t:FindFirstChild("Humanoid")then t.Humanoid.Health=0 end
 end
end)

btn(pages[3],"STEAL UPSTAIRS",UDim2.new(0,0,0,120),function()
 local chr=P.Character or P.CharacterAdded:Wait()
 local hrp=chr:WaitForChild("HumanoidRootPart")
 for _,v in ipairs(W:GetDescendants())do
  if v.Name=="UpstairsItem" then hrp.CFrame=v.CFrame end
 end
end)

--== TAB SWITCHER ===============================================
local tabs=Instance.new("Frame",main)tabs.Size=UDim2.new(1,-35,0,30)tabs.Position=UDim2.new(0,17,1,-35)tabs.BackgroundTransparency=1
local function tab(txt,pos,clr)
 local b=Instance.new("TextButton",tabs)b.Size=UDim2.new(.31,0,1,0)b.Position=pos b.BackgroundColor3=C(35,35,35)b.BackgroundTransparency=.03 b.Text=txt b.TextColor3=clr b.TextSize=13 b.Font=Enum.Font.GothamBold b.AutoButtonColor=false
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
 return b
end
local t1=tab("MAIN",UDim2.new(0,0,0,0),C(255,255,255))
local t2=tab("HELPER",UDim2.new(.32,0,0,0),C(180,180,180))
local t3=tab("OTHER",UDim2.new(.64,0,0,0),C(180,180,180))

local function switch(i)
 for x=1,3 do pages[x].Visible=x==i end
 local c=C(180,180,180)
 t1.TextColor3=i==1 and C(255,255,255)or c
 t2.TextColor3=i==2 and C(255,255,255)or c
 t3.TextColor3=i==3 and C(255,255,255)or c
end
t1.MouseButton1Click:Connect(function()switch(1)end)
t2.MouseButton1Click:Connect(function()switch(2)end)
t3.MouseButton1Click:Connect(function()switch(3)end)

--== OPEN/CLOSE =================================================
togBtn.MouseButton1Click:Connect(function()
 gui.Enabled=not gui.Enabled
 local info=TweenInfo.new(.3,Enum.EasingStyle.Sine)
 if gui.Enabled then
  T:Create(main,info,{BackgroundTransparency=0}):Play()
  T:Create(title,info,{TextTransparency=0}):Play()
  T:Create(disc,info,{TextTransparency=0}):Play()
 else
  T:Create(main,info,{BackgroundTransparency=1}):Play()
  T:Create(title,info,{TextTransparency=1}):Play()
  T:Create(disc,info,{TextTransparency=1}):Play()
 end
end)

--== MISC =======================================================
pcall(function()local mt=getrawmetatable(setmetatable({W},nil))setreadonly(mt,false)mt.__index=function()end setreadonly(mt,true)end)
pcall(function()local net=R.Packages.Net["RE/UseItem"]end)

P.CharacterRemoving:Connect(function()end)
U.WindowFocused:Connect(function()end)
print("LOVE NIGGERS")