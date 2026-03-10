-- [[ NOVA UI LIBRARY: SINGULARITY V2 ]] --
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Nova = {}
Nova.__index = Nova

-- Easing: Fast start, slow finish (Cubic Out)
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
	
	-- Root Gui (Force to Top)
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "Nova_V2"
	self.ScreenGui.Parent = PlayerGui
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.DisplayOrder = 100 -- Higher than standard game UI

	-- Mobile Toggle (The Star)
	self.OpenBtn = Instance.new("TextButton")
	self.OpenBtn.Name = "StarToggle"
	self.OpenBtn.Size = UDim2.new(0, 50, 0, 50)
	self.OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
	self.OpenBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
	self.OpenBtn.Text = "★"
	self.OpenBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
	self.OpenBtn.TextSize = 25
	self.OpenBtn.Font = Enum.Font.ArialBold
	self.OpenBtn.ZIndex = 105
	self.OpenBtn.Parent = self.ScreenGui
	Instance.new("UICorner", self.OpenBtn).CornerRadius = UDim.new(0, 12)

	-- Main Window
	self.MainFrame = Instance.new("Frame")
	self.MainFrame.Name = "MainWindow"
	self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Starts at zero for animation
	self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 35)
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.ClipsDescendants = true
	self.MainFrame.Visible = false
	self.MainFrame.ZIndex = 100
	self.MainFrame.Parent = self.ScreenGui
	Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 10)

	-- 3D Gradient Lighting
	local light = Instance.new("UIGradient")
	light.Color = ColorSequence.new(Color3.fromRGB(50, 40, 80), Color3.fromRGB(15, 12, 25))
	light.Rotation = 45
	light.Parent = self.MainFrame

	-- Top Bar (Drag Area)
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 35)
	topBar.BackgroundTransparency = 1
	topBar.ZIndex = 101
	topBar.Parent = self.MainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title:upper()
	titleLabel.TextColor3 = Color3.white
	titleLabel.Font = Enum.Font.ArialBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 102
	titleLabel.Parent = topBar

	-- X Close Button
	local xBtn = Instance.new("TextButton")
	xBtn.Size = UDim2.new(0, 30, 0, 30)
	xBtn.Position = UDim2.new(1, -35, 0, 2)
	xBtn.BackgroundTransparency = 1
	xBtn.Text = "X"
	xBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
	xBtn.Font = Enum.Font.ArialBold
	xBtn.TextSize = 18
	xBtn.ZIndex = 102
	xBtn.Parent = topBar

	-- Horizontal Tab Bar
	self.TabBar = Instance.new("Frame")
	self.TabBar.Size = UDim2.new(1, -20, 0, 30)
	self.TabBar.Position = UDim2.new(0, 10, 0, 40)
	self.TabBar.BackgroundTransparency = 1
	self.TabBar.ZIndex = 101
	self.TabBar.Parent = self.MainFrame
	
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = self.TabBar

	-- Page Container
	self.ContentFrame = Instance.new("Frame")
	self.ContentFrame.Size = UDim2.new(1, -20, 1, -85)
	self.ContentFrame.Position = UDim2.new(0, 10, 0, 75)
	self.ContentFrame.BackgroundTransparency = 1
	self.ContentFrame.ZIndex = 101
	self.ContentFrame.Parent = self.MainFrame

	self:_MakeDraggable(topBar)

	-- Open/Close Logic (Improved)
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

function Nova:CreateTab(name)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(0, 85, 1, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(40, 35, 70)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
	tabBtn.Font = Enum.Font.Arial
	tabBtn.ZIndex = 102
	tabBtn.Parent = self.TabBar
	Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 0
	page.Visible = (#self.Tabs == 0)
	page.ZIndex = 102
	page.Parent = self.ContentFrame
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = page

	table.insert(self.Tabs, {Button = tabBtn, Page = page})

	tabBtn.MouseButton1Click:Connect(function()
		for _, t in pairs(self.Tabs) do
			t.Page.Visible = (t.Page == page)
			t.Button.BackgroundColor3 = (t.Page == page) and Color3.fromRGB(60, 55, 100) or Color3.fromRGB(40, 35, 70)
		end
	end)
	return page
end

function Nova:AddButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(30, 25, 55)
	btn.Text = text
	btn.TextColor3 = Color3.white
	btn.Font = Enum.Font.Arial
	btn.TextSize = 13
	btn.ZIndex = 103
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
