local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local CONFIG_URL = "https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/places.json"


local function loadScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if success and response then
        local loadedFunction, err = loadstring(response)
        if loadedFunction then
            local execSuccess, execErr = pcall(loadedFunction)
            if not execSuccess then
                warn("Error running script:", execErr)
            end
        else
            warn("Error loafing script:", err)
        end
    else
        warn("Loading script failed:", response)
    end
end

local function loadConfig()
    local success, response = pcall(function()
        return game:HttpGet(CONFIG_URL, true)
    end)
    
    if success and response then
        return HttpService:JSONDecode(response)
    else
        warn("Failed loading config, using fallback")
        return {
            ["Universal"] = "https://raw.githubusercontent.com/GooDHous/SM-Scripts/main/universal.lua"
        }
    end
end

local function main()
    local config = loadConfig()
    local currentPlaceId = tostring(game.PlaceId)
    
    local scriptUrl = config[currentPlaceId] or config["Universal"]
    
    if scriptUrl then
        print("Loading script", currentPlaceId)
        loadScript(scriptUrl)
    else
        warn("Script for this place not exist")
    end
end



local success, err = pcall(main)
if not success then
    warn("Error loading script:", err)
end
