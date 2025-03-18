local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local TweenUtil = require(game.ReplicatedStorage.Shared.Utils.TweenUtil)
local GameConfig = require(game.ReplicatedStorage.Shared.Config.GameConfig)

local Maid: MaidModule.Maid = MaidModule.new()

local PlayArea: Folder = workspace.PlayArea
local hexPart: Part = game.ReplicatedStorage.Assets.PlatformParts.Hex

local function CreateHexClone(platform: MeshPart | BasePart): MeshPart | BasePart
    local hexClone = hexPart:Clone()
    hexClone.Parent = workspace
    hexClone.Size = platform.Size * 0.8
    hexClone.CFrame = platform.CFrame
    hexClone.BrickColor = platform.BrickColor
    return hexClone
end

function Hide(platform: MeshPart | BasePart)
    local hexClone = CreateHexClone(platform)

    local goal1 = {
        Position = platform.CFrame.Position - Vector3.new(0,0.4,0)
    }

    local tweenData1 = {
        time = GameConfig.PlatformHidingEffectDuration
    }

    local goal2 = {
        Position = platform.CFrame.Position - Vector3.new(0,8,0),
        Transparency = 1,
    }

    local tweenData2 = {
        time = 2
    }

    local tween = TweenUtil.Tween(hexClone,goal1,tweenData1)

    tween.Completed:Once(function()
        local tween2 = TweenUtil.TweenAndDestroy(hexClone,goal2,tweenData2)
        tween2:Play()
        tween:Destroy()
    end)

    tween:Play()
end

function Show(platform: MeshPart | BasePart)
    local hexClone = CreateHexClone(platform)
    hexClone.Position = platform.CFrame.Position - Vector3.new(0,1,0)

    local goal = {
        Position = platform.CFrame.Position
    }

    local tweenData = {
        time = GameConfig.PlatformShowingEffectDuration
    }

    local tween = TweenUtil.TweenAndDestroy(hexClone,goal,tweenData)
    tween:Play()
end

local function ListenToAttribues(platform: MeshPart | BasePart)
	local hideConnection = platform:GetAttributeChangedSignal('Hiding'):Connect(function()
		if not platform:GetAttribute('Hiding') then return end
		Hide(platform)
	end)

	local showingConnection = platform:GetAttributeChangedSignal('Showing'):Connect(function()
		if not platform:GetAttribute('Showing') then return end
		Show(platform)
	end)

	platform.Destroying:Once(function()
		hideConnection:Disconnect()
		hideConnection = nil

		showingConnection:Disconnect()
		showingConnection = nil
	end)
end


local function FindPlatformFolder(instance: Instance)
	if instance.Name ~= 'Platforms' or not instance:IsA('Folder') then return end
	Maid[instance] = instance.ChildAdded:Connect(ListenToAttribues)

	for _, platform in instance:GetChildren() do
		ListenToAttribues(platform)
	end
end

PlayArea.ChildAdded:Connect(FindPlatformFolder)

for _, child in PlayArea:GetChildren() do
	FindPlatformFolder(child)
end

