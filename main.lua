-- [[ NOVA UI LIBRARY: SINGULARITY V4 ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Nova = {}
Nova.__index = Nova

-- Easing: Starts fast, slows down (Cubic Out)
local EasingInfo = TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

local function Animate(obj, goal)
	local tween = TweenService:Create(obj, EasingInfo, goal)
	tween:Play()
	return tween
end

function Nova.new(title)
	local self = setmetatable({}, Nova)
	self.Tabs = {}
	self.Toggled = false
	
	-- Root Gui
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "Nova_V4"
	self.ScreenGui.Parent = PlayerGui
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.DisplayOrder = 100

	-- Mobile Toggle (The Star)
	self.OpenBtn = Instance.new("TextButton")
	self.OpenBtn.Size = UDim2.new(0, 50, 0, 50)
	self.OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
	self.OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 65)
	self.OpenBtn.Text = "★"
	self.OpenBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
	self.OpenBtn.TextSize = 25
	self.OpenBtn.Font = Enum.Font.ArialBold
	self.OpenBtn.ZIndex = 105
	self.OpenBtn.Parent = self.ScreenGui
	Instance.new("UICorner", self.OpenBtn).CornerRadius = UDim.new(0, 12)

	-- Main Window
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
	self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ClipsDescendants = true
	self.MainFrame.Visible = false
	self.MainFrame.ZIndex = 100
	self.MainFrame.Parent = self.ScreenGui
	Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 10)

	-- 3D Lighting Effect
	local light = Instance.new("UIGradient")
	light.Color = ColorSequence.new(Color3.fromRGB(55, 50, 95), Color3.fromRGB(15, 12, 28))
	light.Rotation = 45
	light.Parent = self.MainFrame

	-- Top Bar
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 35)
	topBar.BackgroundTransparency = 1
	topBar.Parent = self.MainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title:upper()
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.Font = Enum.Font.ArialBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar

	-- X Button
	local xBtn = Instance.new("TextButton")
	xBtn.Size = UDim2.new(0, 30, 0, 30)
	xBtn.Position = UDim2.new(1, -35, 0, 2)
	xBtn.BackgroundTransparency = 1
	xBtn.Text = "X"
	xBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
	xBtn.Font = Enum.Font.ArialBold
	xBtn.TextSize = 18
	xBtn.Parent = topBar

	-- Tab Bar
	self.TabBar = Instance.new("Frame")
	self.TabBar.Size = UDim2.new(1, -20, 0, 30)
	self.TabBar.Position = UDim2.new(0, 10, 0, 40)
	self.TabBar.BackgroundTransparency = 1
	self.TabBar.Parent = self.MainFrame
	Instance.new("UIListLayout", self.TabBar).FillDirection = Enum.FillDirection.Horizontal

	-- Content
	self.ContentFrame = Instance.new("Frame")
	self.ContentFrame.Size = UDim2.new(1, -20, 1, -85)
	self.ContentFrame.Position = UDim2.new(0, 10, 0, 75)
	self.ContentFrame.BackgroundTransparency = 1
	self.ContentFrame.Parent = self.MainFrame

	self:_MakeDraggable(topBar)

	local function toggleUI()
		self.Toggled = not self.Toggled
		if self.Toggled then
			self.MainFrame.Visible = true
			Animate(self.MainFrame, {Size = UDim2.new(0, 400, 0, 260)})
		else
			local tw = Animate(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)})
			tw.Completed:Connect(function() 
				if not self.Toggled then self.MainFrame.Visible = false end 
			end)
		end
	end

	self.OpenBtn.MouseButton1Click:Connect(toggleUI)
	xBtn.MouseButton1Click:Connect(toggleUI)

	return self
end

function Nova:Notify(msg, dur)
    local nFrame = Instance.new("Frame")
    nFrame.Size = UDim2.new(0, 180, 0, 35)
    nFrame.Position = UDim2.new(1, 20, 1, -50)
    nFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
    nFrame.Parent = self.ScreenGui
    Instance.new("UICorner", nFrame).CornerRadius = UDim.new(0, 6)
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = msg
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.Arial
    txt.TextSize = 12
    txt.Parent = nFrame
    
    Animate(nFrame, {Position = UDim2.new(1, -200, 1, -50)})
    task.delay(dur or 3, function()
        local tw = Animate(nFrame, {Position = UDim2.new(1, 20, 1, -50)})
        tw.Completed:Connect(function() nFrame:Destroy() end)
    end)
end

function Nova:CreateTab(name)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 85, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 75)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
	tabBtn.Font = Enum.Font.Arial
	tabBtn.Parent = self.TabBar
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 0
	page.Visible = (#self.Tabs == 0)
	page.Parent = self.ContentFrame
	Instance.new("UIListLayout", page).Padding = UDim.new(0, 6)

	table.insert(self.Tabs, {Button = tabBtn, Page = page})

	tabBtn.MouseButton1Click:Connect(function()
		for _, t in pairs(self.Tabs) do
			t.Page.Visible = (t.Page == page)
			t.Button.BackgroundColor3 = (t.Page == page) and Color3.fromRGB(65, 60, 110) or Color3.fromRGB(40, 35, 75)
		end
	end)
	return page
end

function Nova:AddButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Arial
	btn.TextSize = 13
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
	btn.MouseButton1Click:Connect(function()
		Animate(btn, {Size = UDim2.new(0.96, 0, 0, 32)})
		task.wait(0.1)
		Animate(btn, {Size = UDim2.new(1, 0, 0, 36)})
		callback()
	end)
end

function Nova:_MakeDraggable(dragHandle)
	local dragging, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = self.MainFrame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

return Nova
