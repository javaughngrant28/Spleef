local MaidModule = require(game.ReplicatedStorage.Shared.Modules.Maid)
local ContextAction = require(script.Parent.Parent.Parent.Modules.ContextAction)

export type InputBaseType = {
    new:(Remote: RemoteEvent, props: {any})-> (),
    Destroy: (InputBaseType)-> ()
}

local InputBase = {}
InputBase.__index = InputBase

InputBase._MAID = nil
InputBase._REMOTE = nil
InputBase._CALLBACK_FUNCTION = nil
InputBase._COOLDOWN = 0
InputBase._PROPS = {}

InputBase._LastTimeActivated = nil



function InputBase.new(Remote: RemoteEvent, props: {any})
    local self = setmetatable({}, InputBase)
    self:__Constructor(Remote, props)
    return self
end


function InputBase:__Constructor(Remote: RemoteEvent, props: {any})
    self._MAID = MaidModule.new()
    self._COOLDOWN = props['Cooldown'] or 0
    self._PROPS = props
    self._REMOTE = Remote
    self:_BindContextAction()
    self:_Load()
end

function InputBase:_Load()
    return
end

function InputBase:InputTriggered(actionName: string, inputState: Enum.UserInputState)
    warn('InputTriggered Method not overridden')
end

function InputBase:_BindContextAction()
    local keybindName = self._PROPS['KeybindName']
    assert(keybindName,`'KeybindName' not found in props {unpack(self._PROPS)}`)

    local callback = function(actionName: string, inputState: Enum.UserInputState)
        if inputState ~= Enum.UserInputState.Begin then return end
        if self:_Cooldown() then return end
        self:InputTriggered(actionName, inputState)
    end

    self._CALLBACK_FUNCTION = callback
    ContextAction.BindKeybind(keybindName,1,self._CALLBACK_FUNCTION)
end

function InputBase:_UnbindContextAction()
    ContextAction.UnbindKeybind(self._PROPS['KeybindName'],self._CALLBACK_FUNCTION)
end

function InputBase:_Cooldown(): boolean
	if self._COOLDOWN > 0 and self._LastTimeActivated and (tick() - self._LastTimeActivated) < self._COOLDOWN then
		return true
	end
	self._LastTimeActivated = tick()
	return false
end


function InputBase:Destroy()
    self:_UnbindContextAction()

    self._MAID:Destroy()
    for index, _ in pairs(self) do
        self[index] = nil
    end
end

return InputBase