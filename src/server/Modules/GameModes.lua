local ServerScriptService = game:GetService("ServerScriptService")
local GameConfig = require(game.ReplicatedStorage.Shared.Config.GameConfig)

export type GameModeType = {
    Destroy: (GameModeType) -> (),
    new: () -> (),
}

local GameModeList: {[string]: GameModeType} = {
    [GameConfig.GameModeNames.Noraml] = require(ServerScriptService.Objects.GameModes.Normal)
}

local GameMode = {}

function GameMode.Create(typeName: string): GameModeType
    assert(GameModeList[typeName], typeName .. " is not a valid type.")
    return GameModeList[typeName].new()
end

return GameMode