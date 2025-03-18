
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local MathUtil = require(game.ReplicatedStorage.Shared.Utils.MathUtil)
local GameConfig = require(game.ReplicatedStorage.Shared.Config.GameConfig)

local Maps: Folder = game.ReplicatedStorage.Assets.Maps
local PlayArea: Folder = game.Workspace.PlayArea

local Normal = {}
Normal.__index = Normal

Normal._TouchedSound = game.ReplicatedStorage.Assets.Sounds.Platform.Pop1

Normal._MAP_NAME = 'Layout1'
Normal._PLATFORM_RESPAWN_DURATION = 8

Normal._MAID = nil



function Normal.new()
    local self = setmetatable({}, Normal)
    self:__Constructor()
    return self
end


function Normal:_CreateAssets()
    local Map = Maps:FindFirstChild(self._MAP_NAME)
    assert(Map,`{self._MAP_NAME}: Not Found In Maps Folder`)

    local platformFolder = Map:FindFirstChild('Platforms')
    assert(platformFolder, `{Map}: Platforms Folder Not Found`)

    for _, child: Instance in Map:GetChildren() do
        local childClone = child:Clone()
        self._MAID:GiveTask(childClone)
        childClone.Parent = PlayArea
    end
end


function Normal:__Constructor()
    self._MAID = MaidModule.new()
    self:_CreateAssets()
    self:__ConnectToPlayForms()
end

function Normal:__TooglAttributes(platform: MeshPart | BasePart, isHiding: boolean)
    platform:SetAttribute('Hiding',isHiding)
	platform:SetAttribute('Showing',not isHiding)
end

function Normal:__HidingSequnce(platform: MeshPart | BasePart)
    if not platform or not platform.Parent then return end

	self:__TooglAttributes(platform,true)
	local startTime = tick()

	platform.Transparency = 1

	task.wait(MathUtil.GetTimeLeft(startTime,GameConfig.PlatformHidingEffectDuration))
	if not platform or not platform.Parent then return end

	platform.CanCollide = false
end

function Normal:__ShowingSequnce(platform: MeshPart | BasePart)
    if not platform or not platform.Parent then return end

	self:__TooglAttributes(platform,false)
	local startTime = tick()

	task.wait(MathUtil.GetTimeLeft(startTime,GameConfig.PlatformShowingEffectDuration))
	if not platform or not platform.Parent then return end

	platform.Transparency = 0
	platform.CanCollide = true
end

function Normal:__PlatformLogic(platform: MeshPart | BasePart)
	local hitbox = platform:FindFirstChild('hitbox') :: MeshPart
	assert(hitbox, "No 'hitbox' MeshPart Found Found")

	platform:SetAttribute('Hiding',false)
	platform:SetAttribute('Showing',false)

	local debounce = false

	self._MAID[platform] = hitbox.Touched:Connect(function(hit: Part)
		if not hit.Parent or not hit.Parent:FindFirstChild('Humanoid') then return end
		if debounce then return end
		debounce = true

		self:__HidingSequnce(platform)
		task.wait(self._PLATFORM_RESPAWN_DURATION)
		self:__ShowingSequnce(platform)

        debounce = false
	end)

end

function Normal:__ConnectToPlayForms()
    local platforms = PlayArea:FindFirstChild('Platforms') :: Folder

	for _, platform: MeshPart in platforms:GetChildren() do
        if not platform:IsA('MeshPart') and not platform:IsA('BasePart') then continue end
		self:__PlatformLogic(platform)
	end
end

function Normal:Destroy()
   self._MAID:Destroy()
   for index, _ in pairs(self) do
        self[index] = nil
    end
end

return Normal