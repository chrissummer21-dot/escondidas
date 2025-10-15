-- src/StarterGui/SeekerSelectionUI.client.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ==================================================================
-- CREACIÓN DE LA INTERFAZ (Sin cambios aquí)
-- ==================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SeekerSelectionGUI"
screenGui.Enabled = false
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 31)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Parent = screenGui
local mainFrameCorner = Instance.new("UICorner", mainFrame)
mainFrameCorner.CornerRadius = UDim.new(0, 12)
local mainFrameStroke = Instance.new("UIStroke", mainFrame)
mainFrameStroke.Color = Color3.fromRGB(80, 80, 80)
mainFrameStroke.Thickness = 1

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.Text = "Seleccionar Buscador"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 37, 41)
titleLabel.Parent = mainFrame
local titleCorner = Instance.new("UICorner", titleLabel)
titleCorner.CornerRadius = UDim.new(0, 12)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "PlayerList"
scrollingFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 41)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame
local scrollingFrameCorner = Instance.new("UICorner", scrollingFrame)
scrollingFrameCorner.CornerRadius = UDim.new(0, 8)

local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local startGameButton = Instance.new("TextButton")
startGameButton.Name = "StartGameButton"
startGameButton.Size = UDim2.new(0.9, 0, 0, 40)
startGameButton.Position = UDim2.new(0.05, 0, 0.85, 0)
startGameButton.Text = "Iniciar Juego"
startGameButton.Font = Enum.Font.SourceSansBold
startGameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startGameButton.TextSize = 18
startGameButton.BackgroundColor3 = Color3.fromRGB(82, 128, 68)
startGameButton.Parent = mainFrame
local startButtonCorner = Instance.new("UICorner", startGameButton)
startButtonCorner.CornerRadius = UDim.new(0, 8)
startGameButton.AutoButtonColor = false
startGameButton.Active = false

-- ==================================================================
-- LÓGICA DE LA INTERFAZ (Aquí están los cambios)
-- ==================================================================
local selectedPlayer = nil
local playerButtons = {}

-- Función para actualizar la lista de jugadores en la GUI
local function updatePlayerList()
	-- Limpiamos la lista anterior
	for player, button in pairs(playerButtons) do
		button:Destroy()
	end
	table.clear(playerButtons)
	selectedPlayer = nil
	startGameButton.Active = false
	startGameButton.BackgroundColor3 = Color3.fromRGB(82, 128, 68)

	-- Creamos un botón para cada jugador en el servidor
	for i, player in ipairs(Players:GetPlayers()) do
		-- Usamos un Frame como contenedor principal para la foto y el texto
		local playerFrame = Instance.new("Frame")
		playerFrame.Name = player.Name
		playerFrame.Size = UDim2.new(1, 0, 0, 50) -- Hacemos la fila un poco más alta
		playerFrame.BackgroundColor3 = Color3.fromRGB(55, 57, 61)
		playerFrame.LayoutOrder = i
		playerFrame.Parent = scrollingFrame
		local corner = Instance.new("UICorner", playerFrame)
		corner.CornerRadius = UDim.new(0, 8)

		-- Añadimos la foto del jugador
		local playerImage = Instance.new("ImageLabel")
		playerImage.Name = "PlayerImage"
		playerImage.Size = UDim2.new(0, 40, 0, 40) -- Un cuadrado para la foto
		playerImage.Position = UDim2.new(0, 5, 0.5, -20)
		playerImage.BackgroundColor3 = Color3.fromRGB(35, 37, 41)
		playerImage.Parent = playerFrame
		local imageCorner = Instance.new("UICorner", playerImage)
		imageCorner.CornerRadius = UDim.new(0, 6) -- Hacemos la foto redondeada

		-- Añadimos el texto del nombre del jugador
		local playerNameLabel = Instance.new("TextLabel")
		playerNameLabel.Name = "PlayerName"
		playerNameLabel.Size = UDim2.new(1, -55, 1, 0) -- Ajustamos el tamaño para que no se solape
		playerNameLabel.Position = UDim2.new(0, 50, 0, 0)
		playerNameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
		playerNameLabel.Font = Enum.Font.SourceSans
		playerNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
		playerNameLabel.TextSize = 16
		playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
		playerNameLabel.BackgroundTransparency = 1
		playerNameLabel.Parent = playerFrame
		
		-- Creamos un botón invisible encima de todo para la selección
		local selectButton = Instance.new("TextButton")
		selectButton.Name = "SelectButton"
		selectButton.Size = UDim2.new(1, 0, 1, 0)
		selectButton.Text = ""
		selectButton.BackgroundTransparency = 1
		selectButton.Parent = playerFrame
		
		-- Obtenemos la foto del avatar del jugador
		local success, contentId = pcall(function()
			return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if success and contentId then
			playerImage.Image = contentId
		end

		playerButtons[player] = playerFrame -- Ahora guardamos el frame, no el botón

		selectButton.MouseButton1Click:Connect(function()
			-- Deseleccionamos al anterior
			if selectedPlayer and playerButtons[selectedPlayer] then
				playerButtons[selectedPlayer].BackgroundColor3 = Color3.fromRGB(55, 57, 61)
			end
			-- Seleccionamos al nuevo
			selectedPlayer = player
			playerFrame.BackgroundColor3 = Color3.fromRGB(80, 90, 120) -- Color de selección
			startGameButton.Active = true
			startGameButton.BackgroundColor3 = Color3.fromRGB(102, 158, 88)
		end)
	end
end

-- Cuando la GUI se active, actualizamos la lista
screenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
	if screenGui.Enabled then
		updatePlayerList()
	end
end)

-- Evento al hacer clic en Iniciar Juego
startGameButton.MouseButton1Click:Connect(function()
	if not startGameButton.Active or not selectedPlayer then return end
	print("Iniciando juego! El buscador es: " .. selectedPlayer.Name)
	-- TODO: Enviar evento al servidor para iniciar el juego
	screenGui.Enabled = false
end)

-- Finalmente, ponemos la GUI construida en la interfaz del jugador
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")