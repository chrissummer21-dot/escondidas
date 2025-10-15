-- src/StarterGui/SeekerAnnouncementUI.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local announceSeekerEvent = ReplicatedStorage:WaitForChild("AnnounceSeekerEvent")

-- ==================================================================
-- CREACIÓN DE LA INTERFAZ DE ANUNCIO MINIMALISTA
-- ==================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SeekerAnnouncementGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Usaremos un solo TextLabel para todo el anuncio
local announcementLabel = Instance.new("TextLabel")
announcementLabel.Name = "AnnouncementLabel"
announcementLabel.Size = UDim2.new(1, 0, 0, 200) -- Ocupa todo el ancho, con altura suficiente
announcementLabel.AnchorPoint = Vector2.new(0.5, 0) -- Ancla en el centro del borde superior
announcementLabel.Position = UDim2.new(0.5, 0, 0, 30) -- Posicionado arriba y centrado, con un margen de 30px
announcementLabel.BackgroundTransparency = 1 -- Fondo completamente invisible

-- Propiedades del texto
announcementLabel.Font = Enum.Font.SourceSansBold
announcementLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
announcementLabel.TextSize = 52 -- Letras bien grandes
announcementLabel.TextWrapped = true
announcementLabel.RichText = true -- Para poder combinar tamaños y colores
announcementLabel.Text = ""
announcementLabel.Visible = false
announcementLabel.Parent = screenGui

-- Borde negro para el texto que asegura la visibilidad
local textStroke = Instance.new("UIStroke")
textStroke.Color = Color3.fromRGB(0, 0, 0)
textStroke.Thickness = 2.5 -- Un borde un poco más grueso para letras grandes
textStroke.Parent = announcementLabel

-- ==================================================================
-- LÓGICA DE LA INTERFAZ
-- ==================================================================
announceSeekerEvent.OnClientEvent:Connect(function(seekerUserId)
	local isSeeker = (seekerUserId == LocalPlayer.UserId)
	
	if isSeeker then
		-- Mensaje para el buscador
		announcementLabel.Text = "<font size='60'>¡ERES EL BUSCADOR!</font>\n<font size='36'>Encuentra a todos</font>"
	else
		-- Mensaje para los que se esconden
		local nameSuccess, seekerName = pcall(Players.GetNameFromUserIdAsync, Players, seekerUserId)
		if not nameSuccess then seekerName = "???" end
		
		announcementLabel.Text = "El buscador es\n<font color='#FFAA00'>"..seekerName.."</font>"
	end
	
	announcementLabel.Visible = true
	task.wait(6) -- Muestra el anuncio por 6 segundos
	announcementLabel.Visible = false
end)