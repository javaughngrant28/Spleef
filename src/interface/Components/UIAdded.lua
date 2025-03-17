local Players = game:GetService("Players")

type CallbackFunction = (ScreenGui) -> ()
type CallbackTable = {CallbackFunction}

local callbackTable: {[string]:{CallbackFunction}} = {}

local function FireCallbackFunctions(gui: ScreenGui,callbackTable: CallbackTable)
    for _, callback in callbackTable do
        callback(gui)
    end
end

local function FindExistingGUI(guiName: string, callback: CallbackFunction)
    for _, gui in Players.LocalPlayer.PlayerGui:GetChildren() do
        if not gui:IsA('ScreenGui') and not gui:IsA('Frame') then continue end
        if guiName == gui.Name then
            callback(gui)
        end
    end
end

local function AddCallbackAndGetIndex(guiName: string, callback: CallbackFunction) : number
    local existingCallbackTable = callbackTable[guiName]
    local index = 1

    if existingCallbackTable then
        table.insert(callbackTable,callback)
        index = #existingCallbackTable
        else
            callbackTable[guiName] = {callback}
    end

    return index
end

local function RemoveCallBack(guiName: string, index: number)
    local existingCallbackTable = callbackTable[guiName]
    assert(existingCallbackTable,`{guiName}: No Callback Table Found`)

    existingCallbackTable[index] = nil

    if #existingCallbackTable == 0 then
        callbackTable[guiName] = nil
    end
end

local function onGuiAdded(gui: ScreenGui)
    if not gui:IsA('ScreenGui') and not gui:IsA('Frame') then return end
    local callbackTable = callbackTable[gui.Name] :: CallbackTable?

    if callbackTable then
        FireCallbackFunctions(gui,callbackTable)
    end
end

Players.LocalPlayer.PlayerGui.ChildAdded:Connect(onGuiAdded)

local UIAdded = {}

type UIAddedPublic = {
    new: (name: string, callback: (ScreenGui) -> ()) -> UIAddedPublic,
    Destroy: (self: UIAdded) -> (),
}

export type UIAdded = {
    __CALLBACK_INDEX: number,
    __GUI_NAME: string,

    new: (name: string, callback: (ScreenGui) -> ()) -> UIAddedPublic,
    Destroy: (self: UIAdded) -> (),
}

function UIAdded.new(name: string, callback: CallbackFunction): UIAddedPublic
    assert(type(name) == "string", "Invalid argument #1: Expected string.")
    assert(type(callback) == "function", "Invalid argument #2: Expected function.")

    local index = AddCallbackAndGetIndex(name,callback)
    FindExistingGUI(name,callback)

    local self = setmetatable({}, { __index = UIAdded })
    self.__CALLBACK_INDEX = index
    self.__GUI_NAME = name
    return self
end

function UIAdded.Destroy(self: UIAdded)
    RemoveCallBack(self.__GUI_NAME,self.__CALLBACK_INDEX)
    for key, _ in pairs(self) do
        self[key] = nil
    end
end

return UIAdded
