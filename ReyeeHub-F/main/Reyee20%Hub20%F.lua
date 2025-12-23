-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Loadstring Executor",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by dafaaa",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Tab
local Tab = Window:CreateTab("Map / Game", 4483362458)

-- ===== MAP BUTTONS =====

Tab:CreateButton({
    Name = "aimbot",
    Callback = function()
        Rayfield:Destroy() -- GUI langsung hilang
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1Lucxxy/Fayyxiee/refs/heads/main/Script-Games/main/aimbot.lua"))()
    end,
})

Tab:CreateButton({
    Name = "Map 2",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://link-script-map-2.lua"))()
    end,
})

Tab:CreateButton({
    Name = "Map 3",
    Callback = function()
        Rayfield:Destroy()
        loadstring(game:HttpGet("https://link-script-map-3.lua"))()
    end,
})
