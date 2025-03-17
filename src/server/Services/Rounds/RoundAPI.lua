
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)
local StartRoundSignal = Signal.new()

local RoundAPI = {}

function RoundAPI._GetStartRoundSignal(): Signal.SignalType
    return StartRoundSignal
end

function RoundAPI.StartNewRound()
    StartRoundSignal:Fire()
end


return RoundAPI