local screenW, screenH = guiGetScreenSize()
local sx, sy = guiGetScreenSize()
local px, py = (sx / 1690), (sy / 1050)
local czcionka = dxCreateFont("Flockey.ttf", 18)
local hudVisible = true
local loggedIn = false

-- Funkcja rysująca HUD
function renderHUD()
    if not hudVisible or not loggedIn then return end

    local money = getPlayerMoney(localPlayer)
    local fps = getElementData(localPlayer, "fps") or 0
    local ping = getPlayerPing(localPlayer)

    dxDrawText("#8FCE00PLN #FFFFFF"..przecinek(money), screenW * 0.7732, screenH * 0.2238, screenW * 0.9589, screenH * 0.2943, tocolor(0, 0, 0, 255), 1.50, czcionka, "center", "top", false, false, false, true, false)
    dxDrawText("#8FCE00PLN #FFFFFF"..przecinek(money), screenW * 0.7732, screenH * 0.2238, screenW * 0.9589, screenH * 0.2943, tocolor(10, 106, 40, 217), 1.50, czcionka, "center", "top", false, false, false, true, false)
    dxDrawText("| FPS: "..fps.."  | PING: "..ping.." |", screenW * 0.8097+1, screenH * 0.0143+1, screenW * 0.9575+1, screenH * 0.0456+1, tocolor(0, 0, 0, 255), 1.5, "default-bold", "center", "top", false, false, false, false, false)
    dxDrawText("| FPS: "..fps.."  | PING: "..ping.." |", screenW * 0.8097, screenH * 0.0143, screenW * 0.9575, screenH * 0.0456, tocolor(255, 255, 255, 255), 1.5, "default-bold", "center", "top", false, false, false, false, false)
end
addEventHandler("onClientRender", root, renderHUD)

-- Funkcja formatująca liczby
function przecinek(liczba)
    local format = liczba
    while true do
        format, k = string.gsub(format, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return format
end

-- Funkcja obsługująca wciśnięcie klawisza F7
function toggleHUD()
    hudVisible = not hudVisible
end
bindKey("F7", "down", toggleHUD)

-- Funkcja obsługująca logowanie gracza
function onPlayerLogin()
    loggedIn = true
end
addEventHandler("onClientPlayerSpawn", root, onPlayerLogin)

-- Ukrywanie HUD-a podczas logowania
addEventHandler("onClientResourceStart", resourceRoot, function()
    showPlayerHudComponent("radar", true)
    showPlayerHudComponent("crosshair", true)
    showPlayerHudComponent("weapon", true)
    showPlayerHudComponent("health", true)
    showPlayerHudComponent("breath", true)
    showPlayerHudComponent("armour", true)
    showPlayerHudComponent("clock", true)
    showPlayerHudComponent("ammo", true)
    
    -- Ukryj HUD dopóki gracz się nie zaloguje
    loggedIn = false
end)
