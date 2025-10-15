-- src/ServerScriptService/GameLogic.server.lua

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local AdminService = require(ServerScriptService.AdminService)

-- Esta función se ejecutará cada vez que un nuevo jugador entre al juego
local function onPlayerAdded(player)
    print(player.Name .. " ha entrado al juego.")

    -- Usamos nuestra función del módulo para revisar si es admin
    local isPlayerAdmin = AdminService.isAdmin(player)

    if isPlayerAdmin then
        print("¡" .. player.Name .. " es un administrador!")
    else
        print(player.Name .. " es un jugador normal.")
    end
end

-- Esta función se ejecutará cuando CUALQUIER jugador hable por el chat
local function onPlayerChatted(player, message)
    -- Convertimos el mensaje a minúsculas
    local lowerMessage = string.lower(message)

    -- Creamos un comando de admin de ejemplo: "/setseeker [nombre]"
    if lowerMessage:find("^/setseeker ") then -- Usamos ^ para asegurarnos que el comando está al inicio
        -- Primero, validamos si el que escribió el comando es admin
        if AdminService.isAdmin(player) then
            -- Extraemos el nombre del jugador del comando
            local targetName = message:sub(12)
            local targetPlayer = Players:FindFirstChild(targetName)

            if targetPlayer then
                print(player.Name .. " ha elegido a " .. targetPlayer.Name .. " para que busque.")
                -- Aquí iría la lógica para hacer que ese jugador busque
            else
                print("Jugador '" .. targetName .. "' no encontrado.")
            end
        else
            print(player.Name .. " intentó usar un comando de admin sin serlo.")
        end
    end
end

-- Conectamos nuestras funciones a los eventos GLOBALES del juego
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerChatted:Connect(onPlayerChatted) -- <-- ESTA ES LA FORMA CORRECTA