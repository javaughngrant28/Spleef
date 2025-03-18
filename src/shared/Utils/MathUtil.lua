local MathUtil = {}

function MathUtil.Lerp(a: number, b: number, t: number): number
    return a + (b - a) * t
end

-- Returns the remaining time based on the provided start time and goal duration.
function MathUtil.GetTimeLeft(startedTime: number, goalDuration: number, useOSTime: boolean?): number
    local currentTime = useOSTime and os.time() or tick()
    local elapsedTime = currentTime - startedTime
    local timeLeft = goalDuration - elapsedTime
    return math.max(timeLeft, 0)
end

function MathUtil.Easing(t: number)
    local a = t * t
    local b = 1.0 - (1.0 - t) * (1.0 - t)
    return MathUtil.Lerp(a,b,t)
end


return MathUtil