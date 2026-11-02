-- =======================================================
-- SCRIPT AUTO PROXIMITY MINI (NEON TOGGLE GUI)
-- Developer Credit: tamnhacai_.
-- =======================================================

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

local keyword = "Door"
local keyName = "E"
local offsetY = 3.000000
local interval = 2.000000
local isAutoEnabled = false

local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("TamNhaCai_MiniGui") then
    playerGui.TamNhaCai_MiniGui:Destroy()
end

local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "TamNhaCai_MiniGui"
MiniGui.ResetOnSpawn = false
MiniGui.Parent = playerGui

local Frame = Instance.new("Frame", MiniGui)
Frame.Size = UDim2.new(0, 200, 0, 75)
Frame.Position = UDim2.new(0.05, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke", Frame)
FrameStroke.Color = Color3.fromRGB(90, 105, 245)
FrameStroke.Thickness = 1.5

local CreLabel = Instance.new("TextLabel", Frame)
CreLabel.Size = UDim2.new(1, 0, 0, 22)
CreLabel.Position = UDim2.new(0, 0, 0, 6)
CreLabel.BackgroundTransparency = 1
CreLabel.Text = "ðŸ‘‘ tamnhacai_."
CreLabel.TextColor3 = Color3.fromRGB(140, 150, 255)
CreLabel.TextSize = 12
CreLabel.Font = Enum.Font.GothamBold

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 34)
ToggleBtn.Position = UDim2.new(0, 10, 0, 32)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
ToggleBtn.Text = "AUTO: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

task.spawn(function()
    while true do
        if isAutoEnabled then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local targetPrompt, targetPart
                local shortestDist = 9999

                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local parentPart = prompt.Parent
                        local objText = (prompt.ObjectText or ""):lower()
                        local actText = (prompt.ActionText or ""):lower()
                        local parentName = parentPart and parentPart.Name:lower() or ""
                        local kw = keyword:lower()

                        if string.find(objText, kw) or string.find(actText, kw) or string.find(parentName, kw) then
                            if parentPart and parentPart:IsA("BasePart") then
                                local dist = (hrp.Position - parentPart.Position).Magnitude
                                if dist < shortestDist then
                                    shortestDist = dist
                                    targetPrompt = prompt
                                    targetPart = parentPart
                                end
                            end
                        end
                    end
                end

                if targetPrompt and targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, offsetY, 0)
                    task.wait(0.4)

                    local keyEnum = Enum.KeyCode[keyName:upper()] or Enum.KeyCode.E
                    local holdTime = targetPrompt.HoldDuration or 0

                    if holdTime > 0 then
                        task.spawn(function() fireproximityprompt(targetPrompt) end)
                        VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                        task.wait(holdTime + 0.1)
                        VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
                    else
                        fireproximityprompt(targetPrompt)
                    end
                end
            end
        end
        task.wait(interval)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    isAutoEnabled = not isAutoEnabled
    if isAutoEnabled then
        ToggleBtn.Text = "AUTO: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 195, 115)
    else
        ToggleBtn.Text = "AUTO: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
    end
end)
