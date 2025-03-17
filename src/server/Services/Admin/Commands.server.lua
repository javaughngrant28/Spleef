local Players = game:GetService('Players')

local groupId = 35325652
local developerRank = 13
local prefix = '/'

local RoundAPI = require(game.ServerScriptService.Services.Rounds.RoundAPI)

local self = {}

function IsDeveloperOrHigher(player: Player)
	-- if not player:IsInGroup(groupId) then return false end
	-- if player:GetRankInGroup(groupId) < developerRank then return false end
	return true
end


Players.PlayerAdded:Connect(function(player: Player)
	print(`{player.Name} Use Commaneds Set To: {IsDeveloperOrHigher(player)} `)
	player.Chatted:Connect(function(text: string)
		local splitText = text:split(' ')
		local command = splitText[1]:split(prefix)

		if self[command[2]] == nil then return end
		if not IsDeveloperOrHigher(player) then return end
		table.remove(splitText, 1)
		self[command[2]](player, table.unpack(splitText))
        
	end)
end)

function self.KillAll()
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			player.Character.Humanoid.Health = 0
		end
	end
end

function self.StartRound()
	RoundAPI.StartNewRound()
end

function self.Kill(player: Player)
	if player and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.Health = 0
	end
end


return self
