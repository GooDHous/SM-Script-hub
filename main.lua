local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/libui.lua'))()

-- Создаем главное окно
local Window = Rayfield:CreateWindow({
    Name = "SM-Team Hub",
    LoadingTitle = "Loading Interface...",
    LoadingSubtitle = "by SM-Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SM-TeamConfig",
        FileName = "Config"
    }
})



local universal = Window:CreateTab("Universal", 4483362458)
local misc = Window:CreateTab("Misc", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Секции
local funSection = universal:CreateSection("Player Functions")
local toolsSection = misc:CreateSection("Tools")

-- Infinite Jump
local infiniteJumpEnabled = false
universal:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    SectionParent = funSection,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip
local noclipEnabled = false
universal:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    SectionParent = funSection,
    Callback = function(Value)
        noclipEnabled = Value
    end
})

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly Menu
universal:CreateButton({
    Name = "Fly Menu",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/fly.lua'))()
    end
})

-- Server Hop
universal:CreateButton({
    Name = "Server Hop",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/serverhop.lua'))()
    end
})

-- Infinity Yield
misc:CreateButton({
    Name = "Infinity Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source'))()
    end
})

-- Dex Explorer
misc:CreateButton({
    Name = "Dex Explorer",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/DexExplorer.lua'))()
    end
})

-- Settings
SettingsTab:CreateLabel("HUB Version: 1.0")
SettingsTab:CreateLabel("Made with Rayfield UI")
SettingsTab:CreateButton({
    Name = "Unload UI",
    Callback = function()
        Rayfield:Destroy()
    end
})


local function LoadGameTabs()
    local placeId = game.PlaceId
    local url = "https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/"..placeId..".lua"
    
    -- Пробуем загрузить
    local success, content = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    -- Если загрузилось - выполняем
    if success and content and #content > 20 then
        local func = loadstring(content)
        if func then
            -- Передаем только самое необходимое
            setfenv(func, {
                Window = Window,
                game = game,
                _G = _G,
                Rayfield = Rayfield,
		task = task
            })
            pcall(func)
        end
    end
end
task.spawn(LoadGameTabs)




Rayfield:Notify({
    Title = "SM-Team Hub",
    Content = "All features loaded successfully!",
    Duration = 5,
    Image = 4483362458
})
