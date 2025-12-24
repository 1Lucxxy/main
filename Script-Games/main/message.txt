local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

local camlockState = false
local Prediction = 0.16
local enemy = nil

local function FindNearestEnemy()
    local closestDistance, closestPlayer = math.huge, nil
    local centerPosition = Vector2.new(GuiService:GetScreenResolution().X / 2, GuiService:GetScreenResolution().Y / 2)
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (centerPosition - Vector2.new(pos.X, pos.Y)).Magnitude
                    if dist < closestDistance then
                        closestDistance = dist
                        closestPlayer = root
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.Heartbeat:Connect(function()
    if camlockState and enemy then
        if enemy.Parent and enemy.Parent:FindFirstChild("Humanoid") and enemy.Parent.Humanoid.Health > 0 then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, enemy.Position + enemy.Velocity * Prediction)
        else
            enemy = FindNearestEnemy()
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 190, 0, 56)
frame.Position = UDim2.new(0, 15, 0, 15)
frame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", frame).Thickness = 2.5
Instance.new("UIStroke", frame).Color = Color3.fromRGB(255, 255, 255)
Instance.new("UIStroke", frame).Transparency = 0.3

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 44, 0, 44)
avatar.Position = UDim2.new(0, 8, 0, 6)
avatar.BackgroundTransparency = 1
avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
avatar.Parent = frame
Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 124, 0, 44)
button.Position = UDim2.new(0, 58, 0, 6)
button.BackgroundTransparency = 1
button.Text = "Toggle Aimbot"
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextXAlignment = Enum.TextXAlignment.Left
button.Parent = frame

local function toggle()
    camlockState = not camlockState
    if camlockState then enemy = FindNearestEnemy() else enemy = nil end
end

button.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.T then toggle() end
end)

local dragging, dragStart, startPos
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

button.InputEnded:Connect(function()
    dragging = false
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)



      
