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
    
