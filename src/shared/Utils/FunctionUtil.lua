local tweenService = game:GetService('TweenService')

local FunctionUtil = {}

function FunctionUtil.SetCollisionGroup(object: Instance, collisionGroupName: string)
    if not object or not collisionGroupName then
        warn("Invalid parameters passed to SetCollisionGroup")
        return
    end

    -- Use GetDescendants to retrieve all descendants of the object
    for _, descendant in ipairs(object:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CollisionGroup = collisionGroupName
        end
    end

    -- Check the root object itself
    if object:IsA("BasePart") then
        object.CollisionGroup = collisionGroupName
    end
end

function FunctionUtil.GetDistanceBetweenParts(part1: BasePart, part2: BasePart): number
    if not part1 or not part2 then
        error("Both part1 and part2 must be valid BasePart instances.")
    end

	if not part1:IsA('BasePart') or not part2:IsA('BasePart') then
		error('Part1 And Part2 must be a Base Part')
	end
    
    return (part1.Position - part2.Position).Magnitude
end

--- Changes properties of all instances of a given type inside a container.
-- @param target Instance
-- @param instanceType string
-- @param properties table
function FunctionUtil.AdjustPropertiesByType(target: Instance, instanceType: string, properties: { [string]: any }): nil
    assert(typeof(target) == "Instance", "First argument must be an Instance")
    assert(typeof(instanceType) == "string", "Second argument must be a string specifying the instance type")
    assert(typeof(properties) == "table", "Third argument must be a table")

    local function applyProperties(instance)
        for propName, propValue in pairs(properties) do
            if pcall(function() return instance[propName] end) then
				if propName == 'Transparency' and instance.Name == "HumanoidRootPart" then
					return true
				end
                instance[propName] = propValue
            else
                warn(`Property '{propName}' does not exist on {instance:GetFullName()}`)
            end
        end
    end

    if target:IsA(instanceType) then
        applyProperties(target)
    end

    for _, descendant in target:GetDescendants() do
        if descendant:IsA(instanceType) then
            applyProperties(descendant)
        end
    end
end

function FunctionUtil.Color3ToRGBFormat(color3: Color3)
    local R = (color3.R * 255)
    local G = (color3.G * 255)
    local B = (color3.B * 255)

    return string.format("rgb(%d, %d, %d)", R, G, B)
end

function FunctionUtil.SetAttributes(instance: Instance, list: { [string]: any })
    if not instance or not list then
        warn("Invalid instance or list provided.")
        return
    end
	
    for key, value in pairs(list) do
        local success, errorMessage = pcall(function()
            instance:SetAttribute(key, value)
        end)

        if not success then
            warn("Failed to set attribute '" .. key .. "': " .. errorMessage)
        end
    end
end


return FunctionUtil