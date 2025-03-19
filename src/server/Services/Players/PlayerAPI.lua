
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)

local PlayerLoadedSignal = Signal.new()



local PlayerAPI = {}

function PlayerAPI.GetPlayerLoadedSignal(): Signal.SignalType
    return PlayerLoadedSignal
end

return PlayerAPI