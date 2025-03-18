
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local RoundConfig = require(game.ReplicatedStorage.Shared.Config.RoundConfig)
local GUICountdown = require(game.ServerScriptService.Components.GUICountdown)
local Stage = require(game.ServerScriptService.Modules.Stage)
local RoundAPI = require(game.ServerScriptService.Services.Rounds.RoundAPI)
local GameModes = require(game.ServerScriptService.Modules.GameModes)

local Maid: MaidModule.Maid = MaidModule.new()

local RoundInProgress: BoolValue = game.ReplicatedStorage.GameValues.RoundInProgress
local GameModeSelected: StringValue = game.ReplicatedStorage.GameValues.GameModeSelected
local CountdownGUi: ScreenGui = game.ReplicatedStorage.Assets.ScreenGui.Countdown

assert(RoundInProgress, 'RoundInProgress Value Missing')
assert(CountdownGUi, 'Countdown GUI Missing')

local StartRoundSignal = RoundAPI._GetStartRoundSignal()


local function StartingSequnce()
    Stage.HoverAllPlayersOnStage()
    GUICountdown.Create('Countdown',RoundConfig.StartingCountdownDuration,true)
    Stage.ReleasePlayers()
end

local function CreateGameMode()
    Maid['GameMode'] = GameModes.Create(GameModeSelected.Value)
end

local function Start()
    if RoundInProgress.Value then return end
    RoundInProgress.Value = true
    
    CreateGameMode()
    StartingSequnce()
end


StartRoundSignal:Connect(Start)
