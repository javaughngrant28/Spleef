
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local RemoteUtil = require(game.ReplicatedStorage.Shared.Utils.RemoteUtil)

local function Countdown(textLabel: TextLabel, startedTime: number, goalTime: number)
    local duration = goalTime - startedTime

    while textLabel and textLabel.Parent and duration > 0 do
        textLabel.Text = tostring(duration) -- Update the TextLabel with the remaining time
        task.wait(1) -- Wait for 1 second
        duration -= 1 -- Decrease the duration
    end
end

local function ActiveCountdown(screen: ScreenGui,startedTime: number, goalTime: number)
    assert(
        startedTime and type(startedTime) == "number" and goalTime and type(goalTime) == "number",
        `Values: {startedTime} {goalTime}`
    )

    local textLable = screen:FindFirstChild('Countdown',true) :: TextLabel
    assert(textLable and textLable:IsA('TextLabel'),`{screen}: Countdown Text leble not: {textLable}`)

    textLable.Visible = true
    Countdown(textLable,startedTime,goalTime)
end

RemoteUtil.OnClient('AnimateCountdownLable',ActiveCountdown)