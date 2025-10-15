-- src/ServerScriptService/AdminService.lua

local AdminService = {}

--[[
Aquí es donde pones los User IDs de los administradores.
Para encontrar tu User ID, ve a tu perfil de Roblox y en la URL
(ej: www.roblox.com/users/123456/profile), el número es tu ID.
--]]
local adminUserIDs = {
    1, -- El User ID del creador de Roblox (para ejemplo)
    9237699659, -- PON TU USER ID AQUÍ
    -- Puedes añadir más IDs separados por comas
}

--[[
Esta función revisa si un jugador es un administrador.
@param player: El objeto del jugador que queremos revisar.
@return boolean: Devuelve 'true' si es admin, 'false' si no lo es.
--]]
function AdminService.isAdmin(player)
    if not player then
        return false
    end

    -- Buscamos el UserId del jugador en nuestra tabla de admins
    for _, userId in ipairs(adminUserIDs) do
        if player.UserId == userId then
            return true -- ¡Lo encontramos! Es un admin.
        end
    end

    return false -- No está en la lista, no es admin.
end


-- Aquí es donde prepararemos las futuras formas de ser admin
function AdminService.hasGamePass(player)
    -- TODO: Programar la lógica para revisar si tiene un Game Pass
    return false
end

function AdminService.hasUsedCode(player)
    -- TODO: Programar la lógica para revisar si usó un código
    return false
end


return AdminService