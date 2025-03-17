local RunService = game:GetService("RunService")

local player = game.Players.LocalPlayer

local BadNetwork = require(game.ReplicatedStorage.Shared.Modules.BadNetwork)
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)

local maid: MaidModule.Maid = MaidModule.new()
local network: BadNetwork.Client = BadNetwork.new()

local function CreateBodyVelocity(): BodyVelocity
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, 0, math.huge)  -- Only affects horizontal movement
    bv.Velocity = Vector3.zero
    return bv
end

local function Set(TARGET_SPEED)
    maid:DoCleaning()

    local character = player.Character or player.CharacterAdded:Wait()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local bv = CreateBodyVelocity()
    bv.Parent = character.HumanoidRootPart

    maid["RS"] = RunService.Heartbeat:Connect(function()
        if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
            maid:DoCleaning()
            return
        end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local moveDirection = character.Humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            bv.Velocity = moveDirection.Unit * TARGET_SPEED
        else
            bv.Velocity = Vector3.zero
        end
    end)
end

network:On("SetCharacterWalkSpeed", Set)

