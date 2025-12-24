-- Pastikan kamu sudah punya Rayfield di workspace atau via loadstring
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Membuat GUI
local Window = Rayfield:CreateWindow({
   Name = "Basic GUI",
   LoadingTitle = "Rayfield Basic GUI",
   LoadingSubtitle = "by ChatGPT",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RayfieldConfigs", -- folder untuk save config
      FileName = "BasicConfig"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- Membuat Tab
local MainTab = Window:CreateTab("Main", 4483362458) -- ID icon opsional

-- Membuat Section
local MainSection = MainTab:CreateSection("Basic Section")

-- Membuat Toggle
MainTab:CreateToggle({
    Name = "Example Toggle",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(value)
        print("Toggle state:", value)
    end
})

-- Membuat Button
MainTab:CreateButton({
    Name = "Example Button",
    Callback = function()
        print("Button clicked!")
    end
})

-- Membuat Slider
MainTab:CreateSlider({
    Name = "Example Slider",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- Membuat Label
MainTab:CreateLabel("This is a basic label")

-- Membuat Dropdown
MainTab:CreateDropdown({
    Name = "Example Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    Flag = "ExampleDropdown",
    Callback = function(option)
        print("Selected option:", option)
    end
})
