
local RoundConfig = require(game.ReplicatedStorage.Shared.Config.RoundConfig)
local GUICountdown = require(game.ServerScriptService.Components.GUICountdown)
local Stage = require(game.ServerScriptService.Modules.Stage)
local RoundAPI = require(game.ServerScriptService.Services.Rounds.RoundAPI)

local RoundInProgress: BoolValue = game.ReplicatedStorage.GameValues.RoundInProgress
local CountdownGUi: ScreenGui = game.ReplicatedStorage.Assets.ScreenGui.Countdown

assert(RoundInProgress, 'RoundInProgress Value Missing')
assert(CountdownGUi, 'Countdown GUI Missing')

local StartRoundSignal = RoundAPI._GetStartRoundSignal()


local function StartingSequnce()
    Stage.HoverAllPlayersOnStage()
    GUICountdown.Create('Countdown',RoundConfig.StartingCountdownDuration,true)
    Stage.ReleasePlayers()
end

local function Start()
    if RoundInProgress.Value then return end
    RoundInProgress.Value = true
    
    StartingSequnce()
end

StartRoundSignal:Connect(Start)
