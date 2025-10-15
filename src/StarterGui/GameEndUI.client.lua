-- src/StarterGui/GameEndUI.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local gameEndEvent = ReplicatedStorage:WaitForChild("GameEndEvent")

-- CREACIÓN DE LA INTERFAZ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameEndGUI"
screenGui.ResetOnSpawn = false
-- No lo emparentamos todavía

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 31)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(80, 80, 80)
stroke.Thickness = 1

local resultLabel = Instance.new("TextLabel")
resultLabel.Name = "ResultLabel"
resultLabel.Size = UDim2.new(1, 0, 0.2, 0)
resultLabel.Text = "¡LOS ESCONDIDOS GANAN!"
resultLabel.Font = Enum.Font.SourceSansBold
resultLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resultLabel.TextSize = 36
resultLabel.BackgroundTransparency = 1
resultLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "SurvivorList"
scrollingFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 41)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
local scrollingFrameCorner = Instance.new("UICorner", scrollingFrame)
scrollingFrameCorner.CornerRadius = UDim.new(0, 8)
local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.Padding = UDim.new(0, 5)

-- LÓGICA
local function populateSurvivors(survivorIds)
	for _, child in ipairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	for _, userId in ipairs(survivorIds) do
		local thumbType = Enum.ThumbnailType.HeadShot
		local thumbSize = Enum.ThumbnailSize.Size48x48
		local success, contentId = pcall(Players.GetUserThumbnailAsync, Players, userId, thumbType, thumbSize)
		local displayName = Players:GetNameFromUserIdAsync(userId)

		local playerFrame = Instance.new("Frame")
		playerFrame.Name = displayName
		playerFrame.Size = UDim2.new(1, 0, 0, 50)
		playerFrame.BackgroundColor3 = Color3.fromRGB(55, 57, 61)
		playerFrame.Parent = scrollingFrame
		local frameCorner = Instance.new("UICorner", playerFrame)
		frameCorner.CornerRadius = UDim.new(0, 8)

		local playerImage = Instance.new("ImageLabel", playerFrame)
		playerImage.Size = UDim2.new(0, 40, 0, 40)
		playerImage.Position = UDim2.new(0, 5, 0.5, -20)
		playerImage.BackgroundColor3 = Color3.fromRGB(35, 37, 41)
		if success then
			playerImage.Image = contentId
		end
		local imageCorner = Instance.new("UICorner", playerImage)
		imageCorner.CornerRadius = UDim.new(0, 6)

		local playerNameLabel = Instance.new("TextLabel", playerFrame)
		playerNameLabel.Size = UDim2.new(1, -55, 1, 0)
		playerNameLabel.Position = UDim2.new(0, 50, 0, 0)
		playerNameLabel.Text = displayName
		playerNameLabel.Font = Enum.Font.SourceSans
		playerNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		playerNameLabel.TextSize = 18
		playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		playerNameLabel.BackgroundTransparency = 1
	end
end

gameEndEvent.OnClientEvent:Connect(function(reason, survivors)
	scrollingFrame.Visible = false

	if reason == "SeekerWins" then
		resultLabel.Text = "¡ENCONTRARON A TODOS!"
	elseif reason == "HidersWin" then
		resultLabel.Text = "¡LOS ESCONDIDOS GANAN!"
		if #survivors > 0 then
			scrollingFrame.Visible = true
			populateSurvivors(survivors)
		end
	end
	
	mainFrame.Visible = true
	task.wait(10)
	mainFrame.Visible = false
end)

-- >> LÍNEA CLAVE AÑADIDA: El script se hace hijo de la GUI para no ser destruido
script.Parent = screenGui
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")