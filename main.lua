-- NOVA Library 1.0 Betq

local Nova = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

function Nova:CreateWindow(Title)
    -- Setup the window
    local windowHandler = Instance.new("ScreenGui")
    windowHandler.Name = "Nova"
    -- Attempt CoreGui, fallback to PlayerGui for Studio testing
    local success, err = pcall(function() windowHandler.Parent = game:GetService("CoreGui") end)
    if not success then windowHandler.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- Main Window Frame
    local window = Instance.new("Frame")
    window.Name = "NovaWindow"
    window.Size = UDim2.new(0, 550, 0, 350) -- Standard Rayfield size
    window.Position = UDim2.new(0.5, -275, 0.5, -175)
    window.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    window.Active = true
    window.Parent = windowHandler

    -- UI Corner (Makes it look modern)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = window

    -- DRAGGING LOGIC (Optimized)
    local dragging, dragInput, dragStart, startPos

    window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)

    -- Use InputEnded to stop dragging globally
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            -- Your Tween Logic
            window:TweenPosition(
                UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y),
                "Out", "Quint", 0.1, true -- Slightly longer 'Quint' feels even smoother
            )
        end
    end)
    
    return window -- Return the frame so you can add Tabs to it later
end

return Nova
