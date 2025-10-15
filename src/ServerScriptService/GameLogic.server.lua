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

-- Esta es la ÚNICA y correcta función onPlayerAdded
local function onPlayerAdded(player)
    print(player.Name .. " ha entrado al juego.")

    if AdminService.isAdmin(player) then
        print("¡" .. player.Name .. " es un administrador!")
        -- Le enviamos la señal a ESTE jugador específico para decirle que es admin
        adminStatusEvent:FireClient(player, true) 
    else
        print(player.Name .. " es un jugador normal.")
    end
end

-- Esta función se ejecuta UNA SOLA VEZ cuando CUALQUIER jugador chatea
local function onPlayerChatted(player, message)
    -- Convertimos el mensaje a minúsculas
    local lowerMessage = string.lower(message)

    -- Creamos un comando de admin: "/setseeker [nombre]"
    if lowerMessage:find("^/setseeker ") then
        -- Validamos si el que escribió el comando es admin
        if AdminService.isAdmin(player) then
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
-- CONEXIONES DE EVENTOS
-- ==================================================================

-- Conectamos la función onPlayerAdded al evento global de entrada de jugadores
Players.PlayerAdded:Connect(onPlayerAdded)

-- Conectamos la función onPlayerChatted al evento global del chat
Players.PlayerChatted:Connect(onPlayerChatted)