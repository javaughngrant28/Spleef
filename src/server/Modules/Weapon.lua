
local Weapons: Folder = game.ReplicatedStorage.Assets.Models.Weapons

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local AttachModel = require(game.ServerScriptService.Components.AttachModel)

export type WeaponType = {
    new: (player: Player, weaponName: string)-> WeaponType,
    EnableAttack: (self: WeaponType) -> (),
    Destroy: (self: WeaponType)-> (),
}

local Weapon = {}
Weapon.__index = Weapon

Weapon._MODEL_REFRENCE = nil
Weapon._CURRENT_MODEL = nil
Weapon._MAID = nil


function Weapon.new(player: Player, weaponName: string): WeaponType
    local self = setmetatable({}, Weapon)
    self:__Constructor(player,weaponName)
    return self
end

function Weapon:EnableAttack()
    self:__Attach(AttachModel.Type.RightHand)
end

function Weapon:__Constructor(player: Player, weaponName: string)
    local character = player.Character
    assert(character,`{player} has no character`)

    self._MAID = MaidModule.new()
    self._PLAYER = player

    local model = Weapons:FindFirstChild(weaponName)
    assert(model,`{weaponName} no found in weaons folder`)

    self._MODEL_REFRENCE = model
    self:_AttachToCharacter()
end

function Weapon:_AttachToCharacter()
    self:__Attach(AttachModel.Type.Torso)
end

function Weapon:_AttachToHand()
    self:__Attach(AttachModel.Type.RightHand)
end


function Weapon:__Attach(attachmentType: string)
    local model = self:__CreateModel()
    assert(model,`{self._PLAYER}: Weaon model no found`)

    local character = self._PLAYER.Character
    assert(character,`{self._PLAYER}: Character no found`)

    AttachModel.Fire(character,model,attachmentType)
end

function Weapon:__CreateModel(): Model
    local model = self._MODEL_REFRENCE:Clone() :: Model
    self._MAID['Current Model'] = model
    self._CURRENT_MODEL = model
    return model
end


function Weapon:Destroy()
   self._MAID:Destroy()
   for index, _ in pairs(self) do
        self[index] = nil
    end
end

return Weapon