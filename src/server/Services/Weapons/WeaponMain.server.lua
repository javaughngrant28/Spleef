
local PlayerAPI = require(game.ServerScriptService.Services.Players.PlayerAPI)
local WeaponAPI = require(game.ServerScriptService.Services.Weapons.WeaponAPI)
local Weapon = require(game.ServerScriptService.Modules.Weapon)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local Maid: MaidModule.Maid = MaidModule.new()

local playerLoadedSignal = PlayerAPI.GetPlayerLoadedSignal()
local enableAttackSignal = WeaponAPI._GetEnableAttackSignal()

local Weapons: {[string]: Weapon.WeaponType} = {}

local function CreateWeapon(player: Player, WeaponName: string)
    local weapon = Weapon.new(player,WeaponName)
    Maid[player.Name] = weapon
    Weapons[player.Name] = weapon
end

local function EnableAttack(players: {Player})
    for _, player in players do
        local weapon = Weapons[player.Name]
        assert(weapon, `{player} has no weapon`)

        weapon:EnableAttack()
    end
end

local function onPlayerLoaded(player: Player)
   if player.Character then
    CreateWeapon(player,'Hammer')
   end

   player.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild('Humanoid',5) :: Humanoid
    assert(humanoid,`{player}'s character has no humanoid`)

    CreateWeapon(player,'Hammer')

    humanoid.Died:Once(function()
        Maid[player.Name] = nil
    end)
   end)
end

enableAttackSignal:Connect(EnableAttack)
playerLoadedSignal:Connect(onPlayerLoaded)