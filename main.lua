-- External Tabs Definition
local function CreateExtraTabs()
    -- Get game name safely with fallback
    local gameName = "Current Game"
    local success, gameInfo = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if success and gameInfo then
        gameName = gameInfo.Name
    end

    -- Create main tab with game name
    local PlaceTabs = Window:CreateTab(gameName, 7733960981)
    
    -- Farming Section
    local farmingSection = PlaceTabs:CreateSection("Farming Features")
    
    -- Initialize global variables
    _G.autoChestFarm = false
    _G.autoSpinFarm = false
    _G.infiniteDominusPet = false
    _G.instaWinLoop = false

    -- Auto Gem Toggle
    PlaceTabs:CreateToggle({
        Name = "💎 Auto Gem Farm",
        CurrentValue = _G.infiniteDominusPet,
        SectionParent = farmingSection,
        Flag = "GemFarmToggle",
        Callback = function(Value)
            _G.infiniteDominusPet = Value
            if Value then
                Rayfield:Notify({
                    Title = "Auto Gem",
                    Content = "Enabled automatic gem farming",
                    Duration = 3,
                    Image = 7733960981
                })
            end
            task.spawn(function()
                while _G.infiniteDominusPet and task.wait(0.1) do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.SpinPrizeEvent:FireServer(5)
                    end)
                end
            end)
        end,
    })

    -- Auto Chest Farm Toggle
    PlaceTabs:CreateToggle({
        Name = "💰 Chest Auto Farm",
        CurrentValue = _G.autoChestFarm,
        SectionParent = farmingSection,
        Flag = "ChestFarmToggle",
        Callback = function(Value)
            _G.autoChestFarm = Value
            if Value then
                Rayfield:Notify({
                    Title = "Chest Farm",
                    Content = "Enabled automatic chest farming",
                    Duration = 3,
                    Image = 7733960981
                })
            end
            task.spawn(function()
                while _G.autoChestFarm and task.wait(0.1) do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.TreasureEvent:FireServer("Chest")
                    end)
                end
            end)
        end,
    })
    
    -- Unlimited Spins Toggle
    PlaceTabs:CreateToggle({
        Name = "🎰 Unlimited Spins",
        CurrentValue = _G.autoSpinFarm,
        SectionParent = farmingSection,
        Flag = "SpinFarmToggle",
        Callback = function(Value)
            _G.autoSpinFarm = Value
            if Value then
                Rayfield:Notify({
                    Title = "Unlimited Spins",
                    Content = "Enabled automatic spinning",
                    Duration = 3,
                    Image = 7733960981
                })
            end
            task.spawn(function()
                while _G.autoSpinFarm and task.wait(0.5) do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.SpinPrizeEvent:FireServer(3)
                    end)
                end
            end)
        end,
    })

    -- Auto Triple Dominus Toggle
    PlaceTabs:CreateToggle({
        Name = "👑 Auto Triple Dominus",
        CurrentValue = _G.infiniteDominusPet,
        SectionParent = farmingSection,
        Flag = "DominusToggle",
        Callback = function(Value)
            _G.infiniteDominusPet = Value
            if Value then
                Rayfield:Notify({
                    Title = "Triple Dominus",
                    Content = "Enabled automatic dominus farming",
                    Duration = 3,
                    Image = 7733960981
                })
            end
            task.spawn(function()
                while _G.infiniteDominusPet and task.wait(0.1) do
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.SpinPrizeEvent:FireServer(4)
                    end)
                end
            end)
        end,
    })

    -- Smart Insta-Win Toggle
    PlaceTabs:CreateToggle({
        Name = "🤖 Smart Insta-Win",
        CurrentValue = _G.instaWinLoop,
        Flag = "InstaWinToggle",
        Callback = function(Value)
            _G.instaWinLoop = Value
            if Value then
                Rayfield:Notify({
                    Title = "Insta-Win",
                    Content = "Enabled smart instant win system",
                    Duration = 3,
                    Image = 9605261863
                })
            end
            task.spawn(function()
                local player = game.Players.LocalPlayer
                local char = player.Character or player.CharacterAdded:Wait()
                
                while _G.instaWinLoop do
                    task.wait(0.1)
                    
                    char = player.Character
                    if not char then continue end
                    
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end

                    local closestWinPart, worldIndex
                    local shortestDistance = math.huge

                    -- Optimized world search
                    for i = 1, 10 do
                        local world = workspace:FindFirstChild("World"..i)
                        if world then
                            local winPart = world:FindFirstChild("WinPart", true)
                            if winPart then
                                local distance = (hrp.Position - winPart.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    closestWinPart = winPart
                                    worldIndex = i
                                end
                            end
                        end
                    end

                    if closestWinPart then
                        pcall(function()
                            hrp.CFrame = closestWinPart.CFrame + Vector3.new(0, 8, 0)
                            task.wait(0.2) -- Prevent spamming
                        end)
                    end
                end
            end)
        end,
    })

    -- Add credits section
    local creditsSection = PlaceTabs:CreateSection("Credits")
    PlaceTabs:CreateLabel("Script Version: 2.0")
    PlaceTabs:CreateLabel("UI Library: Rayfield")
    PlaceTabs:CreateLabel("Developer: YourName")
end

-- Execute tab creation
CreateExtraTabs()

-- Success notification
Rayfield:Notify({
    Title = "Game-Specific Tabs Loaded",
    Content = string.format("Successfully loaded features for %s", gameName),
    Duration = 5,
    Image = 7733960981
})
