local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundUtil = require(game.ReplicatedStorage.Shared.Utils.SoundUtil)

local soundFolder = game.ReplicatedStorage.Assets.Sounds.GUI

local Global = {
    ["hover_size"] = Vector3.new(1.1, 1.1, 1),
    ["debounce"] = 0.3
}

local function parseVector3(value, default)
    if typeof(value) == "string" then
        local success, result = pcall(function()
            return Vector3.new(unpack(string.split(value, ",")))
        end)
        if success then return result end
    end
    return default
end

local function parseColor3(value, default)
    if typeof(value) == "string" then
        local success, result = pcall(function()
            local parts = string.split(value, ",")
            return Color3.fromRGB(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
        end)
        if success then return result end
    end
    return default
end

local function applyStylesToButton(button)
    if not (button:IsA("TextButton") or button:IsA("ImageButton")) or button:GetAttribute("no_style") ~= nil then
        return
    end

    local hoverSize = parseVector3(button:GetAttribute("hover_size"), Global["hover_size"])
    local hoverSoundName = button:GetAttribute("hover_sound") or Global["hover_sound"]
    local hoverColor = parseColor3(button:GetAttribute("hover_color"), Global["hover_color"])
    local hoverTextColor = parseColor3(button:GetAttribute("hover_text_color"), Global["hover_text_color"])
    local clickSoundName = button:GetAttribute("click_sound") or Global["click_sound"]
    local hoverTransparency = button:GetAttribute("hover_transparency") or Global["hover_transparency"]
    local debounceTime = button:GetAttribute("debounce") or Global["debounce"]

    local originalSize = button.Size
    local originalColor = button.BackgroundColor3
    local originalTextColor = button:IsA("TextButton") and button.TextColor3 or nil
    local originalTransparency = button.BackgroundTransparency

    local newSize = UDim2.new(
        originalSize.X.Scale * hoverSize.X, originalSize.X.Offset * hoverSize.X,
        originalSize.Y.Scale * hoverSize.Y, originalSize.Y.Offset * hoverSize.Y
    )

    local hoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = newSize,
        BackgroundColor3 = hoverColor,
        BackgroundTransparency = hoverTransparency
    })

    local unhoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = originalSize,
        BackgroundColor3 = originalColor,
        BackgroundTransparency = originalTransparency
    })

    local debounce = false

    button.MouseEnter:Connect(function()
        hoverTween:Play()
        if button:IsA("TextButton") and hoverTextColor then
            button.TextColor3 = hoverTextColor
        end

        if hoverSoundName then
            SoundUtil.PlaySoundInElement(soundFolder:FindFirstChild(hoverSoundName), button)
        end
    end)

    button.MouseLeave:Connect(function()
        unhoverTween:Play()
        if button:IsA("TextButton") then
            button.TextColor3 = originalTextColor
        end
    end)

    button.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        button.Active = false
        if button:IsA("ImageButton") then
            button.Interactable = false
        end

        if clickSoundName then
            SoundUtil.PlaySoundInElement(soundFolder:FindFirstChild(clickSoundName), button)
        end

        task.wait(debounceTime)

        button.Active = true
        if button:IsA("ImageButton") then
            button.Interactable = true
        end
        debounce = false
    end)
end

local function scanScreenGui(gui)
    for _, button in ipairs(gui:GetDescendants()) do
        applyStylesToButton(button)
    end
end

local function onPlayerGuiAdded(playerGui)
    playerGui.ChildAdded:Connect(scanScreenGui)
    for _, gui in ipairs(playerGui:GetChildren()) do
        scanScreenGui(gui)
    end
end

local function setupForLocalPlayer()
    local player = Players.LocalPlayer
    if player then
        onPlayerGuiAdded(player:FindFirstChildOfClass("PlayerGui"))
    end
end

setupForLocalPlayer()
