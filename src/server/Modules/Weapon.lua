
local Weapons: Folder = game.ReplicatedStorage.Assets.Models.Weapons

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local AttachModel = require(game.ServerScriptService.Components.AttachModel)

export type WeaponType = {
    new: (player: Player, weaponName: string)-> WeaponType,
    AttachToCharacter: (self: WeaponType)-> (),
    Destroy: (self: WeaponType)-> (),
}

local Weapon = {}
Weapon.__index = Weapon

Weapon._WEAON = nil
Weapon._MAID = nil


function Weapon.new(player: Player, weaponName: string)
    local self = setmetatable({}, Weapon)
    self:__Constructor(player,weaponName)
    return self
end

function Weapon:__Constructor(player: Player, weaponName: string)
    local character = player.Character
    assert(character,`{player} has no character`)

    self._MAID = MaidModule.new()
    self._PLAYER = player

    local model = Weapons:FindFirstChild(weaponName)
    assert(model,`{weaponName} no found in weaons folder`)

    self._WEAON = model:Clone()
    self:AttachToCharacter()
end

function Weapon:AttachToCharacter()
    local model: Model = self._WEAON
    assert(model,`{self._PLAYER}: Weaon model no found`)

    local character = self._PLAYER.Character
    assert(character,`{self._PLAYER}: Character no found`)

    AttachModel.Fire(character,model,AttachModel.Type.Torso)
end

function Weapon:Destroy()
   self._MAID:Destroy()
   for index, _ in pairs(self) do
        self[index] = nil
    end
end

return Weapon