local InputBase = require(script.Parent.InputBase)

local AtatckInput = setmetatable({}, { __index = InputBase })
AtatckInput.__index = AtatckInput

function AtatckInput.new(...)
    local self = setmetatable({}, AtatckInput)
    self:__Constructor(...)
    return self
end

function AtatckInput:InputTriggered(_, inputState: Enum.UserInputState)
    self._REMOTE:FireServer('Yes','None','Musted')
end

function AtatckInput:Destroy()
    self:_UnbindContextAction()
    self._MAID:Destroy()
    for index, _ in pairs(self) do
        self[index] = nil
    end
end

return AtatckInput