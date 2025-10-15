-- src/StarterGui/GameModesUI.client.lua

-- Este script construye la GUI y la añade a la interfaz del jugador

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameModesGUI"
screenGui.Enabled = false -- La empezamos oculta
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = "Modos de Juego"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.Parent = mainFrame

local hideAndSeekButton = Instance.new("TextButton")
hideAndSeekButton.Name = "HideAndSeekButton"
hideAndSeekButton.Size = UDim2.new(0.9, 0, 0, 40)
hideAndSeekButton.Position = UDim2.new(0.05, 0, 0, 70)
hideAndSeekButton.Text = "Escondidas"
hideAndSeekButton.Font = Enum.Font.SourceSans
hideAndSeekButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hideAndSeekButton.TextSize = 18
hideAndSeekButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
hideAndSeekButton.Parent = mainFrame

hideAndSeekButton.MouseButton1Click:Connect(function()
	print("Modo de juego 'Escondidas' seleccionado por el admin.")
	-- Aquí iría la lógica para iniciar este modo de juego
end)

-- Finalmente, ponemos la GUI construida en la interfaz del jugador
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")