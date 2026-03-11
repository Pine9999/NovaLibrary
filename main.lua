local Nova = {}

function Nova:CreateWindow(Title)
	-- Setup the window
    local windowHandler = Instance.new("ScreenGui")
    windowHandler.Name = "Nova"
    windowHandler.Parent = game:GetService("CoreGui")
    -- Visual Elements
      --Window
    local window = Instance.new("Frame")
    window.Name = "NovaWindow"
    window.Parent = windowHandler
    window.Active = true
      -- User Interface Control
	local UserInputService = game:GetService("UserInputService")

    local gui = window

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
	    local delta = input.Position - dragStart
	    gui:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.04, true) -- This is what I changed
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

	
	
    
