-- src/StarterPlayerScripts/AdminController.client.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==================================================================
-- LÍNEA CORREGIDA
-- Ahora apuntamos al módulo "Icon" que sí existe en tu carpeta
-- ==================================================================
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"))
local adminStatusEvent = ReplicatedStorage:WaitForChild("AdminStatusEvent")

-- Esta función creará el botón
local function createAdminButton()
	-- Buscamos la GUI que creamos en el paso anterior
	local gameModesGui = PlayerGui:WaitForChild("GameModesGUI")

	-- Creamos un nuevo icono en la barra superior usando el módulo "Icon"
	local adminIcon = Icon.new() -- Cambiamos TopbarPlus.Icon por Icon
	adminIcon:setName("AdminPanel")
	adminIcon:setLabel("Admin")
	adminIcon:setImage("rbxassetid://4995028833") -- Un icono de escudo como ejemplo

	-- Esta función se ejecuta cada vez que se hace clic en el icono
	adminIcon.selected:Connect(function()
		gameModesGui.Enabled = true
	end)

	adminIcon.deselected:Connect(function()
		gameModesGui.Enabled = false
	end)

	-- Permite que se pueda cerrar la GUI haciendo clic de nuevo en el icono
	adminIcon:setRight() -- Lo alineamos a la derecha para no interferir con el chat
end

-- Nos conectamos al evento del servidor
adminStatusEvent.OnClientEvent:Connect(function(isAdmin)
	if isAdmin then
		print("Señal de admin recibida. Creando botón...")
		createAdminButton()
	end
end)