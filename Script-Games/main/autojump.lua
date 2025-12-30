-- Auto Jump GUI + Keybind X
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Status
local autoJump = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoJumpGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 60)
frame.Position = UDim2.new(0, 20, 0.5, -30)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.Text = "AUTO JUMP : OFF"
button.TextColor3 = Color3.fromRGB(255, 80, 80)
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.Font = Enum.Font.GothamBold
button.TextSize = 16

-- Toggle Function
local function toggleAutoJump()
	autoJump = not autoJump
	if autoJump then
		button.Text = "AUTO JUMP : ON"
		button.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		button.Text = "AUTO JUMP : OFF"
		button.TextColor3 = Color3.fromRGB(255, 80, 80)
	end
end

-- Button Click
button.MouseButton1Click:Connect(toggleAutoJump)

-- Keybind X
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.X then
		toggleAutoJump()
	end
end)

-- Auto Jump Loop
RunService.RenderStepped:Connect(function()
	if autoJump and humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
