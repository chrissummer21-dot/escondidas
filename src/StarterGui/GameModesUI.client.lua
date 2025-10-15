-- src/StarterGui/GameModesUI.client.lua

-- Este script construye una GUI estética y la añade a la interfaz del jugador

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameModesGUI"
screenGui.Enabled = false -- La empezamos oculta
screenGui.ResetOnSpawn = false

-- ======== Frame Principal ========
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 31) -- Un color oscuro y moderno
mainFrame.BackgroundTransparency = 0.1 -- Un toque de transparencia
mainFrame.Parent = screenGui

-- Borde redondeado para el frame principal
local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

-- Borde sutil para el frame
local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(80, 80, 80)
mainFrameStroke.Thickness = 1
mainFrameStroke.Parent = mainFrame


-- ======== Barra de Título ========
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 45) -- Un poco más alta
titleLabel.Text = "Modos de Juego"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 37, 41) -- Ligeramente más claro que el fondo
titleLabel.Parent = mainFrame

-- Borde redondeado solo para las esquinas superiores del título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel


-- ======== Botón de Escondidas ========
local hideAndSeekButton = Instance.new("TextButton")
hideAndSeekButton.Name = "HideAndSeekButton"
hideAndSeekButton.Size = UDim2.new(0.9, 0, 0, 40)
hideAndSeekButton.Position = UDim2.new(0.05, 0, 0, 70)
hideAndSeekButton.Text = "Escondidas"
hideAndSeekButton.Font = Enum.Font.SourceSans
hideAndSeekButton.TextColor3 = Color3.fromRGB(220, 220, 220) -- Un blanco menos intenso
hideAndSeekButton.TextSize = 18
hideAndSeekButton.BackgroundColor3 = Color3.fromRGB(55, 57, 61) -- Un gris oscuro
hideAndSeekButton.Parent = mainFrame

-- Borde redondeado para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = hideAndSeekButton

-- Borde para el botón
local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(110, 110, 110)
buttonStroke.Thickness = 1
buttonStroke.Parent = hideAndSeekButton

-- --- Efectos visuales para el botón ---
local originalButtonColor = hideAndSeekButton.BackgroundColor3

-- Efecto al pasar el ratón por encima
hideAndSeekButton.MouseEnter:Connect(function()
	hideAndSeekButton.BackgroundColor3 = Color3.fromRGB(75, 77, 81) -- Se aclara
end)

-- Efecto al quitar el ratón de encima
hideAndSeekButton.MouseLeave:Connect(function()
	hideAndSeekButton.BackgroundColor3 = originalButtonColor -- Vuelve al color original
end)

-- Evento al hacer clic en el botón
hideAndSeekButton.MouseButton1Click:Connect(function()
	print("Abriendo panel de selección de buscador...")
	
	-- Ocultamos esta GUI
	screenGui.Enabled = false
	
	-- Buscamos y mostramos la nueva GUI
	local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local seekerSelectionGui = playerGui:WaitForChild("SeekerSelectionGUI")
	if seekerSelectionGui then
		seekerSelectionGui.Enabled = true
	end
end)

-- Finalmente, ponemos la GUI construida en la interfaz del jugador
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")