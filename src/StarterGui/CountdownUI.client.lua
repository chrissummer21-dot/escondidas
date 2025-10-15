-- src/StarterGui/CountdownUI.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local gameState = ReplicatedStorage:WaitForChild("GameState")
local gameTimer = ReplicatedStorage:WaitForChild("GameTimer")

-- CREACIÓN DE LA INTERFAZ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CountdownGUI"
screenGui.ResetOnSpawn = false
-- No lo emparentamos todavía

local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.Size = UDim2.new(0.25, 0, 0.1, 0)
timerFrame.AnchorPoint = Vector2.new(0.5, 0)
timerFrame.Position = UDim2.new(0.5, 0, 0, 10)
timerFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 31)
timerFrame.BackgroundTransparency = 0.2
timerFrame.Visible = false
timerFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner", timerFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0.4, 0)
statusLabel.Text = "A ESCONDERSE"
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 24
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = timerFrame

local timeLabel = Instance.new("TextLabel")
timeLabel.Name = "TimeLabel"
timeLabel.Size = UDim2.new(1, 0, 0.6, 0)
timeLabel.Position = UDim2.new(0, 0, 0.4, 0)
timeLabel.Text = "1:00"
timeLabel.Font = Enum.Font.SourceSansBold
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.TextSize = 40
timeLabel.BackgroundTransparency = 1
timeLabel.Parent = timerFrame

-- LÓGICA PARA ACTUALIZAR LA INTERFAZ
local function updateTimerDisplay(timeInSeconds)
	local minutes = math.floor(timeInSeconds / 60)
	local seconds = timeInSeconds % 60
	timeLabel.Text = string.format("%d:%02d", minutes, seconds)
	
	if timeInSeconds <= 10 then
		timeLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	else
		timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end

gameState:GetPropertyChangedSignal("Value"):Connect(function()
	if gameState.Value == "Hiding" or gameState.Value == "Seeking" then
		statusLabel.Text = (gameState.Value == "Hiding" and "A ESCONDERSE") or "¡QUE NO TE ENCUENTREN!"
		timerFrame.Visible = true
	else
		timerFrame.Visible = false
	end
end)

gameTimer:GetPropertyChangedSignal("Value"):Connect(function()
	updateTimerDisplay(gameTimer.Value)
end)

-- >> LÍNEA CLAVE AÑADIDA: El script se hace hijo de la GUI para no ser destruido
script.Parent = screenGui
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")