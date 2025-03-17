-- TweenUtil.lua
local TweenService = game:GetService("TweenService")

local TweenUtil = {}
local ActiveTweens = {}

export type TweenInfoData = {
    time: number,
    easingStyle: Enum.EasingStyle?,
    easingDirection: Enum.EasingDirection?,
    repeatCount: number?,
    reverses: boolean?,
    delayTime: number?
}


function TweenUtil.Tween(instance: Instance, properties: {[string]: any}, tweenData: TweenInfoData, autoPlay: boolean?): Tween
    assert(instance and instance:IsA("Instance"), "TweenUtil: First argument must be an Instance")
    assert(typeof(properties) == "table", "TweenUtil: Second argument must be a table of properties")

    -- Create TweenInfo
    local tweenInfo = TweenInfo.new(
        tweenData.time or 1,
        tweenData.easingStyle or Enum.EasingStyle.Sine,
        tweenData.easingDirection or Enum.EasingDirection.Out,
        tweenData.repeatCount or 0,
        tweenData.reverses or false,
        tweenData.delayTime or 0
    )

    -- Create Tween
    local tween = TweenService:Create(instance, tweenInfo, properties)

    -- Store active tween
    if not ActiveTweens[instance] then
        ActiveTweens[instance] = {}
    end
    table.insert(ActiveTweens[instance], tween)

    -- Play tween if autoPlay is enabled
    if autoPlay ~= false then
        tween:Play()
    end

    -- Cleanup when tween finishes
    tween.Completed:Connect(function()
        TweenUtil.RemoveTween(instance, tween)
    end)

    return tween
end


function TweenUtil.StopTweens(instance: Instance)
    if ActiveTweens[instance] then
        for _, tween in ipairs(ActiveTweens[instance]) do
            tween:Cancel()
        end
        ActiveTweens[instance] = nil
    end
end


function TweenUtil.RemoveTween(instance: Instance, tween: Tween)
    if ActiveTweens[instance] then
        for i, activeTween in ipairs(ActiveTweens[instance]) do
            if activeTween == tween then
                table.remove(ActiveTweens[instance], i)
                break
            end
        end
        if #ActiveTweens[instance] == 0 then
            ActiveTweens[instance] = nil
        end
    end
end

function TweenUtil.TweenAndDestroy(instance: Instance, properties: {[string]: any}, tweenData: TweenInfoData)
    local tween = TweenUtil.Tween(instance, properties, tweenData, true)
    tween.Completed:Connect(function()
        instance:Destroy()
    end)
    return tween
end

return TweenUtil
