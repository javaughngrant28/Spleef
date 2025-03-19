local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local CharacterEvents = require(script.Parent.Parent.Components.CharacterEvents)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local CharacterConfig = require(game.ReplicatedStorage.Shared.Config.CharacterConfig)
local DoubleJumpConfig = require(game.ReplicatedStorage.Shared.Config.DoubleJumpConfig)

local Maid: MaidModule.Maid = MaidModule.new()

local CanDoubleJump = true
local JumpCount = 0

local debounce = false
local debounceTime = 0.2

local function SetDefaultJumpHight(humanoid: Humanoid)
    humanoid.UseJumpPower = false
    humanoid.JumpHeight = CharacterConfig.JumpHeight
    humanoid.AutoJumpEnabled = false
end

local function onHumanoidStateChanged(old: Enum.HumanoidStateType, new: Enum.HumanoidStateType)
    if new ~= Enum.HumanoidStateType.Landed then return end
    CanDoubleJump = true
    JumpCount = 0
end

local function onJumpRequest()
    if debounce then return end
    debounce = true

    task.delay(debounceTime, function() debounce = false end)

    local character: Model = player.Character
    assert(character,`character nil`)

    local humanoid = character:FindFirstChild('Humanoid') :: Humanoid
    assert(humanoid,`{character}: No humanoid found`)

    if humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then return end

    JumpCount += 1

    if JumpCount >= 2 and not CanDoubleJump then return end
    CanDoubleJump = false

    humanoid.JumpHeight = CharacterConfig.JumpHeight * DoubleJumpConfig.JUMP_MULTIPLIER
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    task.wait(0.1)
    SetDefaultJumpHight(humanoid)
end

local function onCharacterAdded(character: Model)
    local humanoid = character:WaitForChild('Humanoid',10) :: Humanoid
    assert(humanoid, `Humanoid Not Found: {humanoid}`)

    SetDefaultJumpHight(humanoid)

    Maid['stateChanged'] = humanoid.StateChanged:Connect(onHumanoidStateChanged)
    Maid['Jump Request'] = UserInputService.JumpRequest:Connect(onJumpRequest)
end

CharacterEvents.Spawn(onCharacterAdded)
