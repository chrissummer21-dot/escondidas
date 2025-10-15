-- src/StarterGui/PlayerStatusUI.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local gameState = ReplicatedStorage:WaitForChild("GameState")
local playersFound = ReplicatedStorage:WaitForChild("PlayersFound")
local totalPlayersInRound = ReplicatedStorage:WaitForChild("TotalPlayersInRound")

-- CREACIÓN DE LA INTERFAZ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerStatusGUI"
screenGui.ResetOnSpawn = false
-- No lo emparentamos todavía

local statusTextLabel = Instance.new("TextLabel")
statusTextLabel.Name = "StatusTextLabel"
statusTextLabel.Size = UDim2.new(0, 350, 0, 100)
statusTextLabel.AnchorPoint = Vector2.new(0, 0.5)
statusTextLabel.Position = UDim2.new(0, 30, 0.5, 0)
statusTextLabel.BackgroundTransparency = 1
statusTextLabel.Font = Enum.Font.SourceSansBold
statusTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusTextLabel.TextSize = 32
statusTextLabel.TextXAlignment = Enum.TextXAlignment.Left
statusTextLabel.TextYAlignment = Enum.TextYAlignment.Center
statusTextLabel.RichText = true
statusTextLabel.Text = ""
statusTextLabel.Visible = false
statusTextLabel.Parent = screenGui

local textStroke = Instance.new("UIStroke")
textStroke.Color = Color3.fromRGB(0, 0, 0)
textStroke.Thickness = 2
textStroke.Parent = statusTextLabel

-- LÓGICA PARA ACTUALIZAR LA INTERFAZ
local function updatePlayerCount()
	local found = playersFound.Value
	local total = totalPlayersInRound.Value - 1
	
	local titleText = "<font size='20'>JUGADORES ENCONTRADOS</font>"
	local countText = tostring(found) .. " / " .. tostring(total)
	
	statusTextLabel.Text = titleText .. "\n" .. countText
end

gameState:GetPropertyChangedSignal("Value"):Connect(function()
	if gameState.Value == "Hiding" or gameState.Value == "Seeking" then
		statusTextLabel.Visible = true
		updatePlayerCount()
	else
		statusTextLabel.Visible = false
	end
end)

playersFound:GetPropertyChangedSignal("Value"):Connect(updatePlayerCount)
totalPlayersInRound:GetPropertyChangedSignal("Value"):Connect(updatePlayerCount)

-- >> LÍNEA CLAVE AÑADIDA: El script se hace hijo de la GUI para no ser destruido
script.Parent = screenGui
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")