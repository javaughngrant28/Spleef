
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local GUICountdown = {}

function GUICountdown.Create(screen: ScreenGui | string, duration: number, yeiled: boolean?)
    local connection: RBXScriptConnection
    local startedTime = os.time()
    local goalTime = startedTime + duration

    connection = ScreenGuiUtil.AddToAllPlayersWithConnection(screen,function(player: Player, screen: ScreenGui)
        RemoteUtil.FireClient('AnimateCountdownLable',player,screen,startedTime,goalTime)
    end)

    local function Destroy()
        connection:Disconnect()
        ScreenGuiUtil.RemoveFromAllPlayers(screen)
    end

    if yeiled then
        task.wait(duration)
        Destroy()
        else
            task.delay(duration,Destroy)
    end
end


return GUICountdown