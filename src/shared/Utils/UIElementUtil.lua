
local ScreenGuiUtil = require(game.ReplicatedStorage.Shared.Utils.ScreenGuiUtil)
local Folder: Folder = game.ReplicatedStorage.Assets.UIElements

local function GetParentElement(screenGui: ScreenGui, elementName: string?): GuiObject?
    if not screenGui or not elementName then return end
    local child = screenGui:FindFirstChild(elementName)
    local descendant = screenGui:FindFirstChild(elementName, true)
    return child or descendant
end

local UIElementUtil = {}

local function CreateGuiObjectClone( uiElement: string | GuiObject): GuiObject
    local uiElementClone: GuiObject
    if typeof(uiElement) == "string" then
        local guiObject = UIElementUtil.Get(uiElement)
        uiElementClone = guiObject:Clone()

        else
            assert(
                typeof(uiElement) =="Instance" and uiElement:IsA('GuiObject'), 
                'uiElement Property Must Be String Or GuiObject'
            )
            uiElementClone = uiElement:Clone()
    end
    return uiElementClone
end

function UIElementUtil.Get(uiElementName: string): GuiObject
    local uiElement = Folder:FindFirstChild(uiElementName) :: GuiObject
    assert(uiElement and uiElement:IsA('GuiObject'),`GuiObject Not Found Named: {uiElement}`)
    return uiElement
end

function UIElementUtil.AddToScreen(player: Player, uiElement: string | GuiObject, screenName: string ,parentElementName: string?): GuiObject
    local screenGui = ScreenGuiUtil.Find(player,screenName)
    assert(screenGui,`{player}: {screenName} Not Found To Add {uiElement} To`)

    local parentElement: Instance = GetParentElement(screenGui,parentElementName) or screenGui
    local uiElementClone: GuiObject = CreateGuiObjectClone(uiElement)
    uiElementClone.Parent = parentElement
    
    return uiElementClone
    
end

function UIElementUtil.MakeVisible(player: Player, screenGui: ScreenGui | string, elementName: string, value: boolean)
    if not player or not player:IsA("Player") or not player:FindFirstChild("PlayerGui") then
        warn("Invalid player or missing PlayerGui")
        return
    end

    local playerGui = player:FindFirstChild("PlayerGui")
    local targetScreenGui

    if type(screenGui) == "string" then
        targetScreenGui = playerGui:FindFirstChild(screenGui)
    else
        targetScreenGui = screenGui
    end

    if not targetScreenGui or not targetScreenGui:IsA("ScreenGui") then
        warn("ScreenGui not found: " .. tostring(screenGui))
        return
    end

    local element = targetScreenGui:FindFirstChild(elementName, true) -- true allows recursive search
    if element and element:IsA("GuiObject") then
        element.Visible = value
    else
        warn("UI element not found: " .. elementName)
    end
end

function UIElementUtil.UpdateTextLabel(player: Player, screenGui: ScreenGui | string, elementName: string, value: string)
    if not player or not player:IsA("Player") or not player:FindFirstChild("PlayerGui") then
        warn("Invalid player or missing PlayerGui")
        return
    end

    local playerGui = player:FindFirstChild("PlayerGui")
    local targetScreenGui

    if type(screenGui) == "string" then
        targetScreenGui = playerGui:FindFirstChild(screenGui)
    else
        targetScreenGui = screenGui
    end

    if not targetScreenGui or not targetScreenGui:IsA("ScreenGui") then
        warn("ScreenGui not found: " .. tostring(screenGui))
        return
    end

    local element = targetScreenGui:FindFirstChild(elementName, true)
    if element and element:IsA("TextLabel") then
        element.Text = value
    else
        warn("UI element not found or is not a TextLabel: " .. elementName)
    end
end


return UIElementUtil