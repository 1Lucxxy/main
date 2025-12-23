local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "My GUI",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyConfig"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "Hello",
    Callback = function()
        print("Hello Orion")
    end
})

OrionLib:Init()
