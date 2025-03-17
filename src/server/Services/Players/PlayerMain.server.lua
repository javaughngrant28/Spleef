
local Players = game:GetService("Players")

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)

local PLayerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()

local function onPlayerAdded(player: Player)
    local playerLoaded = player:WaitForChild('FinishedLoading',20):: BoolValue
    if not playerLoaded then return end

    playerLoaded.Value = true
    
    task.wait(0.2)
    PLayerLoadedSignal:Fire(player)
end

local function onPlayerRemoving(player: Player)
    local playerName = player.Name
    print(playerName)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)
