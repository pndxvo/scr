repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local list = {
    -- Anime Ranger X
    [72829404259339] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/'))()",

    -- Build an Island
    [101949297449238] = "loadstring(game:HttpGet('https://raw.githubusercontent.com/'))()"
}

-- Get current game ID
local gameId = game.PlaceId

-- If script exists for this game, run it
if list[gameId] then
    loadstring(list[gameId])()
else
    warn("No script available for this game. PlaceId:", gameId)
end
