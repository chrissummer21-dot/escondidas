-- src/ServerScriptService/GameLogic.server.lua

-- Obtenemos los servicios al inicio para un código más limpio y eficiente
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Importamos nuestro módulo de administración
local AdminService = require(ServerScriptService.AdminService)

-- Creamos el evento que usaremos para la comunicación
local adminStatusEvent = Instance.new("RemoteEvent")
adminStatusEvent.Name = "AdminStatusEvent"
adminStatusEvent.Parent = ReplicatedStorage

local function onPlayerAdded(player)
    print(player.Name .. " ha entrado al juego.")

    if AdminService.isAdmin(player) then
        print("¡" .. player.Name .. " es un administrador!")
        -- Le enviamos una señal a ESTE jugador específico para decirle que es admin
        adminStatusEvent:FireClient(player, true) 
    else
        print(player.Name .. " es un jugador normal.")
    end
end

-- Esta función se ejecuta CADA VEZ que un nuevo jugador entra al juego
local function onPlayerAdded(player)
    print(player.Name .. " ha entrado al juego.")

    -- Usamos nuestra función del módulo para revisar si es admin
    if AdminService.isAdmin(player) then
        print("¡" .. player.Name .. " es un administrador!")
    else
        print(player.Name .. " es un jugador normal.")
    end
end

-- Esta función se ejecuta UNA SOLA VEZ cuando CUALQUIER jugador chatea
local function onPlayerChatted(player, message)
    -- Convertimos el mensaje a minúsculas para que el comando no distinga mayúsculas
    local lowerMessage = string.lower(message)

    -- Creamos un comando de admin: "/setseeker [nombre]"
    -- El símbolo ^ se asegura que el comando esté al inicio del mensaje
    if lowerMessage:find("^/setseeker ") then
        -- Primero, validamos si el que escribió el comando es admin
        if AdminService.isAdmin(player) then
            -- Extraemos el nombre del jugador del comando (el texto después del espacio)
            local targetName = message:sub(12)
            local targetPlayer = Players:FindFirstChild(targetName)

            if targetPlayer then
                print(player.Name .. " (Admin) ha elegido a " .. targetPlayer.Name .. " para que busque.")
                -- Aquí irá la lógica para hacer que ese jugador busque
            else
                print("Comando de Admin: Jugador '" .. targetName .. "' no encontrado.")
            end
        else
            print(player.Name .. " intentó usar un comando de admin sin serlo.")
        end
    end
end

-- ==================================================================
-- CONEXIONES DE EVENTOS (La parte más importante)
-- ==================================================================

-- Conectamos la función onPlayerAdded al evento global de entrada de jugadores
Players.PlayerAdded:Connect(onPlayerAdded)

-- Conectamos la función onPlayerChatted al evento global del chat.
-- Esta es la línea que corrige el error.
Players.PlayerChatted:Connect(onPlayerChatted)