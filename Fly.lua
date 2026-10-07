-- LocalScript
-- Put in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local speed = 100
local velocity

local gui = Instance.new("ScreenGui")
gui.Name = "MobileFly"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(190, 170)
frame.Position = UDim2.new(0, 15, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(35, 20, 65)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local function makeButton(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 42)
	b.Position = UDim2.fromOffset(10, y)
	b.Text = text
	b.TextSize = 17
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(120, 50, 220)
	b.Parent = frame
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	return b
end

local fly = makeButton("🪽 FLY: OFF", 10)
local faster = makeButton("⚡ SPEED: 100", 60)
local slower = makeButton("➖ SLOWER", 110)

fly.Activated:Connect(function()
	flying = not flying
	fly.Text = flying and "🪽 FLY: ON" or "🪽 FLY: OFF"

	local root = player.Character
		and player.Character:FindFirstChild("HumanoidRootPart")

	if flying and root then
		velocity = Instance.new("BodyVelocity")
		velocity.MaxForce = Vector3.new(1e7,1e7,1e7)
		velocity.Velocity = Vector3.zero
		velocity.Parent = root
	elseif velocity then
		velocity:Destroy()
		velocity = nil
	end
end)

faster.Activated:Connect(function()
	speed = math.min(speed + 100, 1000)
	faster.Text = "⚡ SPEED: "..speed
end)

slower.Activated:Connect(function()
	speed = math.max(speed - 100, 100)
	faster.Text = "⚡ SPEED: "..speed
end)

-- Mobile movement:
-- Hold the normal Roblox thumbstick to fly.
RunService.RenderStepped:Connect(function()
	if not flying or not velocity then return end

	local char = player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local camera = workspace.CurrentCamera

	if not humanoid then return end

	local move = humanoid.MoveDirection

	if move.Magnitude > 0 then
		velocity.Velocity = move.Unit * speed
	else
		-- STOP immediately instead of continuing forward
		velocity.Velocity = Vector3.zero
	end
end)
