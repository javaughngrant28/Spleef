local Debris = game:GetService('Debris')
local Players = game:GetService('Players')

local localPlayer = Players.LocalPlayer

export type Target = {
    Name: string,
    Humanoid: Humanoid,
    HumanoidRootPart: BasePart,
    PrimaryPart: BasePart?,
    Children: {Instance},
}

local self = {}


function self.CreateHitBox(character: Model, size: Vector3?, forwardOffset: number?): {Target?}
	local size = size or Vector3.new(6.2, 6.2, 6.2)
	local forwardOffset = size.Z * 0.5
	local humanoidRootPart: BasePart = character:WaitForChild("HumanoidRootPart")

	-- Create the hitbox part
	local hitBox = Instance.new("Part")
	hitBox.Size = size
	hitBox.Anchored = false
	hitBox.CanCollide = false
	hitBox.Massless = true
	hitBox.Transparency = 0.8
	hitBox.Parent = workspace
	hitBox.BrickColor = BrickColor.Red()

	hitBox.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -forwardOffset)

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = humanoidRootPart
	weld.Part1 = hitBox
	weld.Parent = hitBox

	local nearestCharacter = nil
	local touchConnection = hitBox.Touched:Connect(function() end)
	local touchingParts = hitBox:GetTouchingParts()

	for _, part in ipairs(touchingParts) do
		local char = part.Parent
		local targetHumanoid: Humanoid = char:FindFirstChild("Humanoid")
		local charHRP: Part = char:FindFirstChild("HumanoidRootPart")
		local forceFeild: ForceField = char:FindFirstChild('ForceField')
		
		if forceFeild then continue end
		if char == character then continue end
		if not charHRP then continue end
		if not targetHumanoid then continue end
		if targetHumanoid.Health <= 0 then continue end

		if not nearestCharacter then 
			nearestCharacter = char
			continue
		end

		local nearestHRP: Part = nearestCharacter:FindFirstChild("HumanoidRootPart")
		if (humanoidRootPart.Position - nearestHRP.Position).Magnitude > (humanoidRootPart.Position - charHRP.Position).Magnitude then
			nearestCharacter = char
		end
	end

	-- Cleanup after a short delay
	touchConnection:Disconnect()
	Debris:AddItem(hitBox, 0.6)

	return { Target = nearestCharacter }
end

return self
