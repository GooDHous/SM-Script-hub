--==[ Load RayField UI ]==--
local RayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/libui.lua'))()

--==[ Create Window ]==--
local Window = RayField:CreateWindow({
    Name = "SM-Script Hub",
    LoadingTitle = "Universal script for SM-Script Hub",
    LoadingSubtitle = "Made by SM-Team",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Save file in workspace if nil
        FileName = "SM-Script_Hub_Config"
    },
    KeySystem = false, 
    Logo = 7229442422, 
    Theme = "Dark",
    Settings = {
        Background = 2929919985, -- Cool background
        TileSize = 100,
        BackgroundColor = Color3.fromRGB(15, 15, 15),
        Font = Enum.Font.GothamBold,
        Topbar = true,
    },
})

--==[ Create Tabs ]==--
local universal = Window:CreateTab("Universal")
local misc = Window:CreateTab("Misc")
local settingsTab = Window:CreateTab("Settings")

local function LoadPlaceScript()
    local placeId = game.PlaceId
    if not placeId or placeId == 0 then
        warn("Invalid PlaceID")
        return false
    end

    local serverUrl = "https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/"
    
    -- Формируем URL для загрузки
    local scriptUrl = serverUrl .. tostring(placeId) .. ".lua"

 -- Выводим информацию для отладки
    print("Trying to load script from:", scriptUrl)
    
    -- Загружаем скрипт с сервера
    local success, response = pcall(function()
        return game:HttpGet(scriptUrl, true)
    end)
    
    if not success then
        warn("Failed to download script:", response)
        return false
    end
    
    -- Если файл не найден (404 ошибка)
    if response:find("404 Not Found") then
        warn("Script for PlaceID", placeId, "not found on server")
        return false
    end
    
    -- Выполняем загруженный скрипт
    local loadSuccess, executeResult = pcall(function()
        local loadedFunction = loadstring(response)
        if loadedFunction then
            -- Создаем безопасное окружение
            local env = getfenv()
            local safeEnv = setmetatable({
                script = nil, -- Убираем ссылку на оригинальный script
                getfenv = function() return safeEnv end,
                setfenv = function() end
            }, {__index = env})
            
            setfenv(loadedFunction, safeEnv)
            return loadedFunction()
        end
        return nil
    end)


--==[ universal Tab ]==--
local funSection = universal:CreateSection("Universal Features")

local infiniteJumpEnabled = false
local noclipEnabled = false


universal:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    SectionParent = funSection,
    Flag = "InfiniteJump",
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

universal:CreateToggle({
    Name = "Noclip (Walk Through Walls)",
    CurrentValue = false,
    SectionParent = funSection,
    Flag = "Noclip",
    Callback = function(Value)
        noclipEnabled = Value
    end,
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

universal:CreateButton({
   Name = "Fly Menu",
   Callback = loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/fly.lua'))()
   end,
})

universal:CreateButton({
   Name = "Server hop",
   Callback = loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/serverhop.lua'))()
   end,
})


--==[ Settings Tab ]==--
settingsTab:CreateButton({
    Name = "Unload The GUI",
      Callback = function()
        RayField:Destroy()
        task.wait(1)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/GooDHous/SM-Scripts/refs/heads/main/libui.lua'))()
    end,
})

--==[ Credits Tab ]==--
creditsTab:CreateLabel("Made by SM-Team")
creditsTab:CreateLabel("UI Framework: RayField (RayField Fork)")
creditsTab:CreateLabel("Special thanks to you for using it!")

succ_loaded = true
