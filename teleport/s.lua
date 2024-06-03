function findPlayerByName(name)
    local players = getElementsByType("player")
    for _, player in ipairs(players) do
        if getPlayerName(player) == name then
            return player
        end
    end
    return false
end

function teleportPlayerToPlayer(player, targetPlayerName)
    if not targetPlayerName then
        outputChatBox("Błąd: nie wskazano gracza.", player, 255, 0, 0)
        return
    end

    local targetPlayer = findPlayerByName(targetPlayerName)
    if not targetPlayer then
        outputChatBox("Gracz o nicku " .. targetPlayerName .. " nie został znaleziony.", player, 255, 0, 0)
        return
    end

    local x, y, z = getElementPosition(targetPlayer)
    setElementPosition(player, x, y, z)
    outputChatBox("Zostałeś przeteleportowany do " .. getPlayerName(targetPlayer) .. ".", player, 0, 255, 0)
end

addEvent("onPlayerRequestTeleport", true)
addEventHandler("onPlayerRequestTeleport", root, function(targetPlayerName)
    teleportPlayerToPlayer(client, targetPlayerName)
end)
