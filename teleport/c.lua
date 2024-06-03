local screenW, screenH = guiGetScreenSize()
local baseW, baseH = 1980, 1080
local scaleX, scaleY = screenW / baseW, screenH / baseH

local windowX, windowY, windowWidth, windowHeight = scaleX * 600, scaleY * 300, scaleX * 720, scaleY * 480
local titleBarHeight = scaleY * 40
local buttonHeight = scaleY * 40
local buttonWidth = (windowWidth - 3 * scaleX * 20) / 2
local listHeight = windowHeight - titleBarHeight - buttonHeight - 3 * scaleY * 20

local isTeleportGuiVisible = false
local selectedPlayer = nil
local playerList = {}

function drawTeleportGui()
    if not isTeleportGuiVisible then return end
    
    dxDrawRectangle(windowX, windowY, windowWidth, windowHeight, tocolor(0, 0, 0, 200))
    dxDrawRectangle(windowX, windowY, windowWidth, titleBarHeight, tocolor(70, 130, 180, 255))
    dxDrawText("Panel Teleportu", windowX, windowY, windowX + windowWidth, windowY + titleBarHeight, tocolor(255, 255, 255, 255), scaleY * 1.2, "default-bold", "center", "center")
    
    local listX, listY = windowX + scaleX * 10, windowY + titleBarHeight + scaleY * 10
    for i, player in ipairs(playerList) do
        local itemY = listY + (i - 1) * (scaleY * 30)
        dxDrawRectangle(listX, itemY, windowWidth - 2 * scaleX * 10, scaleY * 30, tocolor(255, 255, 255, 100))
        dxDrawText(player, listX + scaleX * 5, itemY, listX + windowWidth - 2 * scaleX * 10, itemY + scaleY * 30, tocolor(0, 0, 0, 255), scaleY, "default", "left", "center")
    end
    
    dxDrawRectangle(windowX + scaleX * 20, windowY + windowHeight - scaleY * 60, buttonWidth, buttonHeight, tocolor(70, 130, 180, 255))
    dxDrawText("Teleportuj", windowX + scaleX * 20, windowY + windowHeight - scaleY * 60, windowX + scaleX * 20 + buttonWidth, windowY + windowHeight - scaleY * 60 + buttonHeight, tocolor(255, 255, 255, 255), scaleY, "default-bold", "center", "center")
    
    dxDrawRectangle(windowX + scaleX * 40 + buttonWidth, windowY + windowHeight - scaleY * 60, buttonWidth, buttonHeight, tocolor(70, 130, 180, 255))
    dxDrawText("Zamknij", windowX + scaleX * 40 + buttonWidth, windowY + windowHeight - scaleY * 60, windowX + scaleX * 40 + 2 * buttonWidth, windowY + windowHeight - scaleY * 60 + buttonHeight, tocolor(255, 255, 255, 255), scaleY, "default-bold", "center", "center")
end

function showTeleportGui()
    if isTeleportGuiVisible then return end
    
    playerList = {}
    for _, player in ipairs(getElementsByType("player")) do
        table.insert(playerList, getPlayerName(player))
    end
    
    isTeleportGuiVisible = true
    showCursor(true)
end

function closeTeleportGui()
    isTeleportGuiVisible = false
    showCursor(false)
end

function onClickTeleportGui(button, state)
    if not isTeleportGuiVisible or button ~= "left" or state ~= "up" then return end
    
    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = cursorX * screenW, cursorY * screenH
    
    local listX, listY = windowX + scaleX * 10, windowY + titleBarHeight + scaleY * 10
    for i, player in ipairs(playerList) do
        local itemY = listY + (i - 1) * (scaleY * 30)
        if cursorX > listX and cursorX < listX + windowWidth - 2 * scaleX * 10 and cursorY > itemY and cursorY < itemY + scaleY * 30 then
            selectedPlayer = player
        end
    end
    
    if cursorX > windowX + scaleX * 20 and cursorX < windowX + scaleX * 20 + buttonWidth and cursorY > windowY + windowHeight - scaleY * 60 and cursorY < windowY + windowHeight - scaleY * 60 + buttonHeight then
        if selectedPlayer then
            triggerServerEvent("onPlayerRequestTeleport", resourceRoot, selectedPlayer)
            closeTeleportGui()
        else
            outputChatBox("Wybierz gracza, do którego chcesz się teleportować.", 255, 0, 0)
        end
    end
    
    if cursorX > windowX + scaleX * 40 + buttonWidth and cursorX < windowX + scaleX * 40 + 2 * buttonWidth and cursorY > windowY + windowHeight - scaleY * 60 and cursorY < windowY + windowHeight - scaleY * 60 + buttonHeight then
        closeTeleportGui()
    end
end

addCommandHandler("tp", function()
    showTeleportGui()
end)

addEventHandler("onClientRender", root, drawTeleportGui)
addEventHandler("onClientClick", root, onClickTeleportGui)
