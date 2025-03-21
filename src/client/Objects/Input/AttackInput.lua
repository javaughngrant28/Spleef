local Players = game:GetService("Players")
local InputBase = require(script.Parent.InputBase)
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)
local AnimationUtil = require(game.ReplicatedStorage.Shared.Utils.AnimationUtil)

local AtatckInput = setmetatable({}, { __index = InputBase })
AtatckInput.__index = AtatckInput

AtatckInput._SWING_SOUND = nil
AtatckInput._ATTACK_ANIMATION_TRACK = nil

function AtatckInput.new(...)
    local self = setmetatable({}, AtatckInput)
    self:__Constructor(...)
    return self
end

function AtatckInput:_Load()
    local character = Players.LocalPlayer.Character
    local swingAnimationID = self._PROPS['AttackAnimationID']
    self._SWING_SOUND = self._PROPS['SwingSound']
    self._ATTACK_ANIMATION_TRACK = AnimationUtil.LoadAnimationTrack(character,swingAnimationID)
end

function AtatckInput:InputTriggered(_, inputState: Enum.UserInputState)
    local RootPart = Players.LocalPlayer.Character.HumanoidRootPart
    SoundUtil.PlayInPart(self._SWING_SOUND,RootPart)
    self._ATTACK_ANIMATION_TRACK:Play()
    self._REMOTE:FireServer(RootPart.CFrame.LookVector)
end

function AtatckInput:Destroy()
    self:_UnbindContextAction()
    self._MAID:Destroy()
    for index, _ in pairs(self) do
        self[index] = nil
    end
end

return AtatckInput