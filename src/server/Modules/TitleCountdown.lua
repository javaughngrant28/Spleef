
local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)

local GUI_NAME = 'TitleCountdown'
local DefaultGUI = game.ReplicatedStorage.Assets.ScreenGui[GUI_NAME]

local TitleCountdown = {}

TitleCountdown.__TITLE = nil
TitleCountdown.__DURATION = nil
TitleCountdown.__GUI_REFERENCE = nil
TitleCountdown._MAID = nil

function TitleCountdown.new(title: string, duration: number, gui: ScreenGui?)

    local self = setmetatable({}, { __index = TitleCountdown })

    self.__TITLE = title
    self.__DURATION = duration
    self.__GUI_REFERENCE = gui or DefaultGUI
    self._MAID = MaidModule.new()

    self:_Start()

    return self
end

function TitleCountdown:_Start()
    local screenGui: ScreenGui = self.__GUI_REFERENCE
    assert(screenGui and screenGui:IsA("ScreenGui"), `Invalid ScreenGui provided: {screenGui}`)

    local guiClone = screenGui:Clone()
    screenGui.Name = GUI_NAME
    self._MAID['GUI CLONE'] = guiClone

    if self.__TITLE then
        local title = Instance.new('StringValue')
        title.Name = 'TitleValue'
        title.Value = self.__TITLE
        title.Parent = guiClone
    end

    local countDownGoal = Instance.new('StringValue')
    countDownGoal.Name = 'CountDownGoal'
    countDownGoal.Value = tostring(os.time() + self.__DURATION)
    countDownGoal.Parent = guiClone

    self._MAID['Connection'] = ScreenGuiUtil.AddToAllPlayers(guiClone,true)

    task.delay(self.__DURATION, function()
        self:Destroy()
    end)
end

function TitleCountdown:Destroy()
    if not self or not self._MAID then return end
    self._MAID:DoCleaning()
    ScreenGuiUtil.RemoveFromAllPlayers(GUI_NAME)
    for key, _ in pairs(self) do
        self[key] = nil
    end
end

return TitleCountdown
