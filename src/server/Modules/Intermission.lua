local GameConfig = require(game.ReplicatedStorage.Shared.Config.GameConfig)
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)


local screenName = 'Intermission'

local Intermission = {}

function Intermission.Start(yeiled: boolean?)
    local connection: RBXScriptConnection
    local startedTime = os.time()
    local goalTime = startedTime + GameConfig.Intermission

    connection = ScreenGuiUtil.AddToAllPlayersWithConnection(screenName,function(player: Player, screen: ScreenGui)
        RemoteUtil.FireClient('AnimateCountdownLable',player,screen,startedTime,goalTime)
    end)

    local function Destroy()
        connection:Disconnect()
        ScreenGuiUtil.RemoveFromAllPlayers(screenName)
    end

    if yeiled then
        task.wait(GameConfig.Intermission)
        Destroy()
        else
            task.delay(GameConfig.Intermission,Destroy)
    end
end

return Intermission