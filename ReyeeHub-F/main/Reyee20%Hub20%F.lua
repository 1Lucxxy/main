local Games = 
loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/ReyeeHub-F/main/gamelist.lua"))()

local URL = Games[game.GameId]

if URL then loadstring(game:HttpGet(URL))()
end
