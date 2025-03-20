
local Signal = require(game.ReplicatedStorage.Shared.Modules.Signal)
local EnableAttackSignal = Signal.new()


local WeaponAPI = {}

function WeaponAPI._GetEnableAttackSignal(): Signal.SignalType
    return EnableAttackSignal
end

function WeaponAPI.EnableAtatck(playerList: {Player})
    EnableAttackSignal:Fire(playerList)
end


return WeaponAPI