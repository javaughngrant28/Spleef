local GameConfig = require(game.ReplicatedStorage.Shared.Config.GameConfig)
local GUICountdown = require(game.ServerScriptService.Components.GUICountdown)

local screenName = 'Intermission'

local Intermission = {}

function Intermission.Start()
    GUICountdown.Create(screenName,GameConfig.Intermission,true)
end

return Intermission