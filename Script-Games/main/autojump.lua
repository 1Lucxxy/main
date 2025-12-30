-- ==============================
-- AUTO BUNNYHOP + AUTO RELOAD
-- AUTO RESPAWN LOADER (XENO)
-- ==============================

-- AUTO RELOAD SCRIPT ON RESPAWN
local Players = game:GetService("Players")
local player = Players.LocalPlayer

if getgenv()._AUTO_SCRIPT_LOADED then return end
getgenv()._AUTO_SCRIPT_LOADED = true

player.CharacterAdded:Connect(function()
	task.wait(1)
	loadstring(game:HttpGet("https://pastebin.com/raw/REPLACE_THIS"))()
end)

-------------------------------------------------
-- MAIN SCRIPT
-------------------------------------------------

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- SETTINGS
local bunnyHop = false
local autoReload = true
local canJump = true

-------------------------------------------------
-- GUI
-------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 190, 0, 80)
frame.Position = UDim2.new(0, 20, 0.45, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -10, 1, -10)
btn.Position = UDim2.new(0, 5, 0, 5)
btn.Text = "BUNNYHOP : OFF"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.TextColor3 = Color3.fromRGB(255,80,80)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)

-------------------------------------------------
-- TOGGLE
-------------------------------------------------
local function toggle()
	bunnyHop = not bunnyHop
	if bunnyHop then
		btn.Text = "BUNNYHOP : ON"
		btn.TextColor3 = Color3.fromRGB(80,255,80)
	else
		btn.Text = "BUNNYHOP : OFF"
		btn.TextColor3 = Color3.fromRGB(255,80,80)
	end
end

btn.MouseButton1Click:Connect(toggle)

UserInputService.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.X then
		toggle()
	end
end)

-------------------------------------------------
-- BUNNYHOP SYSTEM
-------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not bunnyHop then return end
	if humanoid.FloorMaterial ~= Enum.Material.Air and canJump then
		canJump = false
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		task.delay(0.15, function()
			canJump = true
		end)
	end
end)
