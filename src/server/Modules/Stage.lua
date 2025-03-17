local Players = game:GetService("Players")

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local SpawnInstance = require(game.ServerScriptService.Components.SpawnInstance)

local Maid: MaidModule.Maid = MaidModule.new()
local spawnPart: Part = workspace.PlayArea.Stage

local function CreateBodyVolocity(): BodyVelocity
	local bv = Instance.new('BodyVelocity')
	bv.MaxForce = Vector3.new(0,400000,0)
	bv.Velocity = Vector3.zero
	return bv
end


local Stage = {}

function Stage.ReleasePlayers()
	Maid:DoCleaning()
end


function Stage.HoverAllPlayersOnStage()
	for _, player: Player in Players:GetChildren() do
		local FinishedLoading = player:FindFirstChild('FinishedLoading') :: BoolValue
		if not FinishedLoading or not FinishedLoading.Value then continue end

		local character = player.Character
		if not character then continue end

		local bv = CreateBodyVolocity()
		bv.Parent = character:FindFirstChild('HumanoidRootPart') :: Part
		Maid[`{player.Name} bv`] = bv

		SpawnInstance.CharacterInPart(player,spawnPart)
	end
end


return Stage
