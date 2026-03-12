local Nova = {}
local UserInputService = game:GetService("UserInputService")

-- 1. Setup Theme
local Theme = {
    Background = Color3.fromRGB(20, 15, 35), -- Dark Bluish Purple
    Accent = Color3.fromRGB(110, 80, 255),    -- Bright Purple
    Text = Color3.fromRGB(240, 240, 255),    -- Off-white Blue
    CloseButton = Color3.fromRGB(255, 80, 80) -- Subtle Red for Close
}

function Nova:CreateWindow(Title)
    -- Setup the window handler
    local windowHandler = Instance.new("ScreenGui")
    windowHandler.Name = "Nova"
    
    local success, _ = pcall(function() 
        windowHandler.Parent = game:GetService("CoreGui") 
    end)
    if not success then 
        windowHandler.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") 
    end

    -- The Main Window
    local window = Instance.new("Frame")
    window.Name = "NovaWindow"
    window.Size = UDim2.new(0, 450, 0, 300)
    window.Position = UDim2.new(0.5, -225, 0.5, -150)
    window.BackgroundColor3 = Theme.Background
    window.BorderSizePixel = 0
    window.Active = true
    window.Parent = windowHandler

    -- Round the corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = window

    -- Title Bar / Top Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = Title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.Parent = window

    -- 2. CLOSE BUTTON (Using Google/Material Icons)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseBtn"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.TextColor3 = Theme.Text
    closeButton.Text = "close" -- The Google Icon name
    closeButton.Font = Enum.Font.MaterialSymbolsRounded -- Use the Google Font
    closeButton.TextSize = 24
    closeButton.Parent = window

    closeButton.MouseButton1Click:Connect(function()
        windowHandler:Destroy() -- Deletes the entire UI
    end)

    -- 3. YOUR DRAGGING LOGIC (With Tween Change)
    local gui = window
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui:TweenPosition(
            UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), 
            Enum.EasingDirection.InOut, 
            Enum.EasingStyle.Sine, 
            0.04, 
            true
        )
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return window
end

return Nova
