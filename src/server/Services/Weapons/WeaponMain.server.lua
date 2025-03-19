
local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local Weapon = require(game.ServerScriptService.Modules.Weapon)
local playerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()

local Weapons: {[string]: Weapon.WeaponType} = {}

local function CreateWeapon(player: Player)
    Weapons[player.Name] = Weapon.new(player,'Hammer')
end

local function EnableAttak(players: {})
    
end

local function onPlayerLoaded(player: Player)
   if player.Character then
    CreateWeapon(player)
    else
        player.CharacterAdded:Wait()
        CreateWeapon(player)
   end
end


playerLoadedSignal:Connect(onPlayerLoaded)