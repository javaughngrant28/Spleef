local Players = game:GetService("Players")

local WeaponFolder: Folder = game.ReplicatedStorage.Assets.Models.Weapons

local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local HitBox = require(game.ReplicatedStorage.Shared.Modules.HitBox)
local Knockback = require(game.ReplicatedStorage.Shared.Modules.Knockback)
local AttachModel = require(game.ServerScriptService.Components.AttachModel)
local InputDetector = require(game.ServerScriptService.Modules.InputDetector)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local ParticleUtil = require(game.ReplicatedStorage.Shared.Utils.ParticleUtil)


export type WeaponType = {
    new: (player: Player, weaponName: string)-> WeaponType,
    EnableAttack: (self: WeaponType) -> (),
    Destroy: (self: WeaponType)-> (),
}

local Weapon = {}
Weapon.__index = Weapon

Weapon._PLAYER = nil
Weapon._CHARACTER = nil
Weapon._MODEL_REFRENCE = nil
Weapon._CURRENT_MODEL = nil
Weapon._MAID = nil

Weapon._ATTACK_COOLDOWN = 0.6
Weapon._ATTACK_ANIMATION_ID = 'rbxassetid://18639155807'
Weapon._SWING_SOUND = game.ReplicatedStorage.Assets.Sounds.Attack.Swing
Weapon._HIT_SOUND = game.ReplicatedStorage.Assets.Sounds.Attack.Hit
Weapon._HIT_EFFECT = game.ReplicatedStorage.Assets.Particles.Smack


function Weapon.new(player: Player, weaponName: string): WeaponType
    local self = setmetatable({}, Weapon)
    self:__Constructor(player,weaponName)
    return self
end

function Weapon:Attack(lookVector: Vector3)
    local HitboxResults = HitBox.CreateHitBox(self._CHARACTER)
    local Target = HitboxResults and HitboxResults['Target']
    if not Target then return end

    Knockback.ServerSided(Target,lookVector,20,Players:GetPlayerFromCharacter(Target))
    
    Target.Humanoid:TakeDamage(2)
    SoundUtil.PlayInPart(self._HIT_SOUND,Target.HumanoidRootPart)
    ParticleUtil.EmitParticlesAtPosition(self._HIT_EFFECT,Target.HumanoidRootPart.Position)
end

function Weapon:EnableAttack()
    self:__Attach(AttachModel.Type.RightHand)
    self:_ConnectToInpue()
end

function Weapon:__Constructor(player: Player, weaponName: string)
    local character = player.Character
    assert(character,`{player} has no character`)

    self._MAID = MaidModule.new()
    self._PLAYER = player
    self._CHARACTER = character

    local model = WeaponFolder:FindFirstChild(weaponName)
    assert(model,`{weaponName} no found in weaons folder`)

    self._MODEL_REFRENCE = model
    self:_AttachToCharacter()
    task.wait(1)
    self:EnableAttack()
end

function Weapon:_AttachToCharacter()
    self:__Attach(AttachModel.Type.Torso)
end

function Weapon:_AttachToHand()
    self:__Attach(AttachModel.Type.RightHand)
end

function Weapon:_ConnectToInpue()
    local InputDetectorObject = InputDetector.new(self._PLAYER,'Attack','AttackInput')
    self._MAID['InputDetectorObject'] = InputDetectorObject
    InputDetectorObject.Cooldown = self._ATTACK_COOLDOWN

    InputDetectorObject.Peramiters = {
        AttackAnimationID = self._ATTACK_ANIMATION_ID,
        SwingSound = self._SWING_SOUND,
    }

    InputDetectorObject:Connect(function(...)
        self:Attack(...)
    end)
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