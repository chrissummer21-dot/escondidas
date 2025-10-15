-- src/ServerScriptService/GameLogic.server.lua

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminService = require(ServerScriptService.AdminService)

-- CONFIGURACIÓN DEL JUEGO
local HIDING_DURATION = 60
local SEEKING_DURATION = 300
local DEFAULT_WALKSPEED = 16
local SEEKER_WALKSPEED = 22

-- ==================================================================
-- >> NUEVO: Función auxiliar para crear objetos de forma segura
-- ==================================================================
local function getOrCreate(className, name)
	local instance = ReplicatedStorage:FindFirstChild(name)
	if not instance or not instance:IsA(className) then
		if instance then instance:Destroy() end
		instance = Instance.new(className)
		instance.Name = name
		instance.Parent = ReplicatedStorage
	end
	return instance
end

-- VALORES REPLICADOS (Ahora usando la nueva función)
local gameState = getOrCreate("StringValue", "GameState")
local gameTimer = getOrCreate("NumberValue", "GameTimer")
local playersFound = getOrCreate("NumberValue", "PlayersFound")
local totalPlayersInRound = getOrCreate("NumberValue", "TotalPlayersInRound")

-- EVENTOS DE COMUNICACIÓN
local adminStatusEvent = getOrCreate("RemoteEvent", "AdminStatusEvent")
local startGameEvent = getOrCreate("RemoteEvent", "StartGameEvent")
local gameEndEvent = getOrCreate("RemoteEvent", "GameEndEvent")
local announceSeekerEvent = getOrCreate("RemoteEvent", "AnnounceSeekerEvent")
-- ==================================================================

-- VARIABLES DE ESTADO DEL JUEGO
local gameInProgress = false
local playersInRound = {}
local foundPlayerUserIds = {}
local seekerTouchedConnections = {}
local currentSeeker = nil

-- LÓGICA PRINCIPAL (sin cambios)
local function endGame(reason, survivors)
	if not gameInProgress then return end
	print("El juego ha terminado. Razón: " .. reason)
	
	gameInProgress = false
	gameState.Value = "Intermission"
	
	for _, connection in ipairs(seekerTouchedConnections) do
		connection:Disconnect()
	end
	table.clear(seekerTouchedConnections)
	
	if currentSeeker and currentSeeker.Character then
		local humanoid = currentSeeker.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = DEFAULT_WALKSPEED
		end
	end
	
	currentSeeker = nil
	table.clear(playersInRound)
	table.clear(foundPlayerUserIds)
	
	gameEndEvent:FireAllClients(reason, survivors)
end

local function onSeekerTouch(hit)
	local otherPlayer = Players:GetPlayerFromCharacter(hit.Parent)
	if not otherPlayer or otherPlayer == currentSeeker or not table.find(playersInRound, otherPlayer.UserId) or table.find(foundPlayerUserIds, otherPlayer.UserId) then
		return
	end

	table.insert(foundPlayerUserIds, otherPlayer.UserId)
	playersFound.Value += 1
	print(currentSeeker.Name .. " ha encontrado a " .. otherPlayer.Name)
	
	if otherPlayer.Character then
		otherPlayer:LoadCharacter()
	end
	
	if playersFound.Value >= totalPlayersInRound.Value - 1 then
		endGame("SeekerWins", {})
	end
end

local function startGame(seekerPlayer)
	if gameInProgress then return end
	gameInProgress = true
	currentSeeker = seekerPlayer

	gameState.Value = "Intermission" -- Aseguramos estado inicial
	table.clear(playersInRound)
	for _, player in ipairs(Players:GetPlayers()) do
		table.insert(playersInRound, player.UserId)
	end
	
	totalPlayersInRound.Value = #playersInRound
	playersFound.Value = 0

	announceSeekerEvent:FireAllClients(seekerPlayer.UserId)

	local seekerCharacter = seekerPlayer.Character or seekerPlayer.CharacterAdded:Wait()
	local seekerHumanoid = seekerCharacter:WaitForChild("Humanoid")
	seekerHumanoid.WalkSpeed = SEEKER_WALKSPEED
	
	gameState.Value = "Hiding"
	for i = HIDING_DURATION, 0, -1 do
		if not gameInProgress then return end
		gameTimer.Value = i; task.wait(1)
	end
	
	for _, part in ipairs(seekerCharacter:GetDescendants()) do
		if part:IsA("BasePart") then
			local connection = part.Touched:Connect(onSeekerTouch)
			table.insert(seekerTouchedConnections, connection)
		end
	end

	gameState.Value = "Seeking"
	for i = SEEKING_DURATION, 0, -1 do
		if not gameInProgress then return end
		gameTimer.Value = i; task.wait(1)
	end
	
	if gameInProgress then
		local survivors = {}
		for _, userId in ipairs(playersInRound) do
			if userId ~= seekerPlayer.UserId and not table.find(foundPlayerUserIds, userId) then
				table.insert(survivors, userId)
			end
		end
		endGame("HidersWin", survivors)
	end
end

-- MANEJO DE EVENTOS (sin cambios)
local function onPlayerAdded(player)
    if AdminService.isAdmin(player) then
        adminStatusEvent:FireClient(player, true) 
    end
end

local function onPlayerRemoving(player)
	if not gameInProgress or not table.find(playersInRound, player.UserId) then return end
	
	local wasFound = table.find(foundPlayerUserIds, player.UserId)
	
	local index = table.find(playersInRound, player.UserId)
	if index then table.remove(playersInRound, index) end
	
	if wasFound then
		local foundIndex = table.find(foundPlayerUserIds, player.UserId)
		if foundIndex then table.remove(foundPlayerUserIds, foundIndex) end
		playersFound.Value -= 1
	end
	
	totalPlayersInRound.Value -= 1
	
	if gameInProgress and playersFound.Value >= totalPlayersInRound.Value - 1 then
		endGame("SeekerWins", {})
	end
end

startGameEvent.OnServerEvent:Connect(function(adminPlayer, seekerPlayer)
	if not AdminService.isAdmin(adminPlayer) then return end
	-- Ponemos el estado en Intermission antes de empezar para limpiar las GUIs
	gameState.Value = "Intermission" 
	task.spawn(startGame, seekerPlayer)
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Estado inicial al arrancar el servidor
gameState.Value = "Intermission"