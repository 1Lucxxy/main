local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "TEST GUI",
    HidePremium = false,
    SaveConfig = false
})

local Tab = Window:MakeTab({
    Name = "Test",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "GUI KEDETEKSI",
    Callback = function()
        print("GUI WORK")
    end
})

OrionLib:Init()
