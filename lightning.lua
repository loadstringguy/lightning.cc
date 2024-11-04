if not getgenv().BypassLoaded then
    getgenv().BypassLoaded = true
else
    return warn("Already loaded bypass")
end

if not LPH_OBFUSCATED then
    getfenv().LPH_NO_VIRTUALIZE = function(f) return f end
  end
  

  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  

  local Handshake = ReplicatedStorage.Remotes.CharacterSoundEvent
  local Hooks = {}
  local HandshakeInts = {}
  
  LPH_NO_VIRTUALIZE(function()
    for i, v in getgc() do
        if typeof(v) == "function" and islclosure(v) then
            if (#getprotos(v) == 1) and table.find(getconstants(getproto(v, 1)), 4000001) then
                hookfunction(v, function() end)
            end
        end
    end
  end)()
  
  Hooks.__namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
  
    if not checkcaller() and (self == Handshake) and (Method == "fireServer") and (string.find(Args[1], "AC")) then
        if (#HandshakeInts == 0) then
            HandshakeInts = {table.unpack(Args[2], 2, 18)}
        else
            for i, v in HandshakeInts do
                Args[2][i + 1] = v
            end
        end
    end
  
    return Hooks.__namecall(self, ...)
  end))
  
  task.wait(1)

local blockreachon = false
local customblockreach = 5
local blocktransparency = 0.5
local antiblockon = false

local AutoFollowQb = false
local followCarrierTask = nil
local maxFollowDistance = 100
local predictionInterval = 0
local predictionFactor = 0.5 
local minPredictDistance = 20
local tackleOffset = 2 
local player = game:GetService("Players").LocalPlayer

local userInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local config = { DefaultSpeed = 20, MaxSpeed = 100 }
local moveToUsing = {}
local walkspeedEnabled = false
local customWalkSpeed = config.DefaultSpeed


if not LPH_OBFUSCATED then
	getfenv().LPH_NO_VIRTUALIZE = function(f) return f end
	getfenv().LPH_JIT_MAX = function(f) return f end
end


local LightingLib = {}
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local function isPlayerOnMobile()
	
    return UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled

end
local Mouse = LocalPlayer:GetMouse()

local function CreateDrag(gui)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
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

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function LightingLib:newWindow(Title: string)
	local window = {
		CurrentTab = nil
	}

	local LightingUI = Instance.new('ScreenGui', RS:IsStudio() and game.Players.LocalPlayer.PlayerGui or game:GetService("CoreGui"))
	local MainFrame = Instance.new('Frame', LightingUI)
	local MainFrameCorner = Instance.new('UICorner', MainFrame)
	local Line = Instance.new('Frame', MainFrame)
	local Line2 = Instance.new('Frame', MainFrame)
	local Line3 = Instance.new('Frame', MainFrame)
	local UiTitle = Instance.new('TextLabel', MainFrame)
	local Logo = Instance.new('ImageLabel', MainFrame)
	local TabHolder = Instance.new('Frame', MainFrame)
	local UIListLayout = Instance.new('UIListLayout', TabHolder)
	local UIPadding = Instance.new('UIPadding', TabHolder)
	local Welcome = Instance.new('TextLabel', MainFrame)
	local SettingsIcon = Instance.new('ImageLabel', MainFrame)

	LightingUI.Name = "LightingUI"
	LightingUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	MainFrame.Name = "MainFrame"
	MainFrame.Position = UDim2.new(0.2242, 0, 0.2399, 0)
	MainFrame.Size = UDim2.new(0, 752, 0, 414)
	MainFrame.BackgroundColor3 = Color3.new(0.051, 0.051, 0.051)
	MainFrame.BorderSizePixel = 0

	Line.Name = "Line"
	Line.Position = UDim2.new(0, 0, 0.8696, 0)
	Line.Size = UDim2.new(0, 752, 0, 1)
	Line.BackgroundColor3 = Color3.new(0.1882, 0.1882, 0.1882)
	Line.BorderSizePixel = 0

	Line2.Name = "Line2"
	Line2.Position = UDim2.new(0, 0, 0.1304, 0)
	Line2.Size = UDim2.new(0, 752, 0, 1)
	Line2.BackgroundColor3 = Color3.new(0.1843, 0.1843, 0.1843)
	Line2.BorderSizePixel = 0

	Line3.Name = "Line3"
	Line3.Position = UDim2.new(0.254, 0, 0.1304, 0)
	Line3.Size = UDim2.new(0, 1, 0, 306)
	Line3.BackgroundColor3 = Color3.new(0.1843, 0.1843, 0.1843)
	Line3.BorderSizePixel = 0

	UiTitle.Name = "UiTitle"
	UiTitle.Position = UDim2.new(0.0811, 0, 0.0314, 0)
	UiTitle.Size = UDim2.new(0, 75, 0, 32)
	UiTitle.BackgroundColor3 = Color3.new(1, 1, 1)
	UiTitle.BackgroundTransparency = 1
	UiTitle.Text = Title
	UiTitle.TextColor3 = Color3.new(0.8196, 0.8196, 0.8196)
	UiTitle.Font = Enum.Font.SourceSans
	UiTitle.TextSize = 25

	Logo.Name = "Logo"
	Logo.Position = UDim2.new(0, 0, 0.0097, 0)
	Logo.Size = UDim2.new(0, 50, 0, 50)
	Logo.BackgroundColor3 = Color3.new(1, 1, 1)
	Logo.BackgroundTransparency = 1
	Logo.Image = "rbxassetid://85204852226269"

	TabHolder.Name = "TabHolder"
	TabHolder.Position = UDim2.new(0, 0, 0.1329, 0)
	TabHolder.Size = UDim2.new(0, 192, 0, 305)
	TabHolder.BackgroundColor3 = Color3.new(1, 1, 1)
	TabHolder.BackgroundTransparency = 1

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 6)

	UIPadding.PaddingTop = UDim.new(0, 5)
	UIPadding.PaddingLeft = UDim.new(0, 10)

	Welcome.Name = "Welcome"
	Welcome.Position = UDim2.new(0.367, 0, 0.9106, 0)
	Welcome.Size = UDim2.new(0, 200, 0, 26)
	Welcome.BackgroundColor3 = Color3.new(1, 1, 1)
	Welcome.BackgroundTransparency = 1
	Welcome.Text = "Welcome, " .. LocalPlayer.Name
	Welcome.TextColor3 = Color3.new(0.7725, 0.7725, 0.7725)
	Welcome.Font = Enum.Font.SourceSans
	Welcome.TextSize = 17

	SettingsIcon.Name = "SettingsIcon"
	SettingsIcon.Position = UDim2.new(0.9455, 0, 0.0386, 0)
	SettingsIcon.Size = UDim2.new(0, 25, 0, 25)
	SettingsIcon.BackgroundColor3 = Color3.new(1, 1, 1)
	SettingsIcon.BackgroundTransparency = 1
	SettingsIcon.Image = "rbxassetid://127186588364408"

	CreateDrag(MainFrame)

	function window:newTab(Title: string)
		local tab = {
			Enabled = false
		}

		local ActiveTab = Instance.new('TextButton', TabHolder)
		local ActiveTabPadding = Instance.new('UIPadding', ActiveTab)
		local ActiveTabGradient = Instance.new('UIGradient', ActiveTab)
		local ActiveTabCorner = Instance.new('UICorner', ActiveTab)


		local CanvasHolder = Instance.new('Frame', MainFrame)
		local Canvas = Instance.new('ScrollingFrame', CanvasHolder)
		local UIListLayout = Instance.new('UIListLayout', Canvas)
		local UIPadding = Instance.new('UIPadding', Canvas)	
		
		

		ActiveTab.AutoButtonColor = false
		ActiveTab.Name = "ActiveTab"
		ActiveTab.Size = UDim2.new(0, 160, 0, 27)
		ActiveTab.BorderSizePixel = 0
		ActiveTab.Text = Title
		ActiveTab.TextColor3 = Color3.fromRGB(175, 175, 175)
		ActiveTab.Font = Enum.Font.SourceSans
		ActiveTab.TextSize = 16
		ActiveTab.TextXAlignment = Enum.TextXAlignment.Left
		ActiveTab.BackgroundTransparency = 1
		ActiveTab.BackgroundColor3 = Color3.fromRGB(122, 62, 190)

		ActiveTabPadding.PaddingLeft = UDim.new(0, 8)

		ActiveTabGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.6666666865348816, 0, 1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.43921568989753723, 0.21960784494876862, 0.658823549747467))
		})
		ActiveTabGradient.Enabled = false

		ActiveTabCorner.CornerRadius = UDim.new(0, 5)



		CanvasHolder.Name = "CanvasHolder"
		CanvasHolder.Position = UDim2.new(0.2553,0,0.1304,0)
		CanvasHolder.Size = UDim2.new(0,560,0,500)
		CanvasHolder.BackgroundColor3 = Color3.new(0.9529,0.3137,1)
		CanvasHolder.BackgroundTransparency = 1
		CanvasHolder.BorderSizePixel = 0
		CanvasHolder.BorderColor3 = Color3.new(0,0,0)
		Canvas.Name = "Canvas"
		Canvas.Size = UDim2.new(0,560,0,306)
		Canvas.BackgroundColor3 = Color3.new(1,1,1)
		Canvas.BackgroundTransparency = 1
		Canvas.BorderSizePixel = 0
		Canvas.BorderColor3 = Color3.new(0,0,0)
		Canvas.ScrollBarThickness = 0
		Canvas.ScrollBarImageColor3 = Color3.new(0,0,0)
		Canvas.Visible = false
		Canvas.ClipsDescendants = true
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0,5)
		UIPadding.PaddingTop = UDim.new(0,10)
		UIPadding.PaddingLeft = UDim.new(0,15)

		function tab:Enable()
			if not tab.Enabled then
				if window.CurrentTab then
					window.CurrentTab:Disable()
				end
				tab.Enabled = true
				ActiveTabGradient.Enabled = true
				ActiveTab.BackgroundTransparency = 0
				ActiveTab.TextColor3 = Color3.fromRGB(0, 0, 0)
				Canvas.Visible = true
				window.CurrentTab = tab

				for _, v in pairs(MainFrame:GetChildren()) do
					if v.Name == "DropDownOptions" then
						v.Visible = false
					end
				end
			end
		end

		function tab:Disable()
			if tab.Enabled then
				tab.Enabled = false
				ActiveTabGradient.Enabled = false
				ActiveTab.BackgroundTransparency = 1
				ActiveTab.TextColor3 = Color3.fromRGB(175, 175, 175)
				Canvas.Visible = false
			end
		end

		ActiveTab.MouseButton1Down:Connect(function()
			tab:Enable()
		end)

		if not window.CurrentTab then
			tab:Enable()
		end
		function tab:Dropdown(Title: string, Options: table)
			local Settings = {
				Default = Options.Default or "Select",
				Items = Options.Items or {},
				Callback = Options.Callback or function() end,
				Parent = Options.Parent or Canvas
			}
		
			local DropdownActive = Instance.new('Frame', Settings.Parent)
			local DropdownCorner = Instance.new('UICorner', DropdownActive)
			local DropdownButton = Instance.new('TextButton', DropdownActive)
			local DropdownTitle = Instance.new('TextLabel', DropdownActive)
			local DropdownList = Instance.new('Frame', Settings.Parent) 
		
			DropdownActive.Name = "DropdownActive"
			DropdownActive.Size = UDim2.new(0, 524, 0, 33)
			DropdownActive.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
			DropdownActive.BorderSizePixel = 0
			DropdownActive.BorderColor3 = Color3.new(0, 0, 0)
			DropdownActive.ZIndex = 100  
		
			DropdownCorner.CornerRadius = UDim.new(0, 6)
		
			DropdownButton.Name = "DropdownButton"
			DropdownButton.Size = UDim2.new(0, 524, 0, 33)
			DropdownButton.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
			DropdownButton.BorderSizePixel = 0
			DropdownButton.BorderColor3 = Color3.new(0, 0, 0)
			DropdownButton.Text = "" 
			DropdownButton.AutoButtonColor = false
			DropdownButton.ZIndex = 100
		
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.Position = UDim2.new(0.5, -43, 0.5, -8.5) 
			DropdownTitle.Size = UDim2.new(0, 86, 0, 17)
			DropdownTitle.BackgroundColor3 = Color3.new(1, 1, 1)
			DropdownTitle.BackgroundTransparency = 1
			DropdownTitle.Text = Title
			DropdownTitle.TextColor3 = Color3.new(0.6353, 0.6353, 0.6353)
			DropdownTitle.Font = Enum.Font.SourceSans
			DropdownTitle.TextSize = 15
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Center
			DropdownTitle.ZIndex = 102  
		
			DropdownList.Name = "DropdownList"
			DropdownList.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
			DropdownList.BorderSizePixel = 0
			DropdownList.Size = UDim2.new(0.96, 0, 0, 0)
			DropdownList.Position = UDim2.new(0.5, -43, 1, 5)  -- Adjust position to be below DropdownActive
			DropdownList.Visible = false
			DropdownList.ClipsDescendants = false 
			DropdownList.ZIndex = 99 
		
			local function createOption(item, index)
				local OptionButton = Instance.new('TextButton', DropdownList)
				OptionButton.Name = "OptionButton"
				OptionButton.Size = UDim2.new(1, 0, 0, 24)  
				OptionButton.Position = UDim2.new(0, 0, 0, 24 * (index - 1)) 
				OptionButton.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
				OptionButton.BorderSizePixel = 0
				OptionButton.Text = item
				OptionButton.TextColor3 = Color3.new(0.6353, 0.6353, 0.6353)
				OptionButton.Font = Enum.Font.SourceSans
				OptionButton.TextSize = 15
				OptionButton.TextXAlignment = Enum.TextXAlignment.Center  
				OptionButton.ZIndex = 101  
		
				local OptionCorner = Instance.new('UICorner', OptionButton)
				OptionCorner.CornerRadius = UDim.new(0, 4)
		
				OptionButton.MouseEnter:Connect(function()
					OptionButton.BackgroundColor3 = Color3.fromRGB(64, 9, 150)
				end)
		
				OptionButton.MouseLeave:Connect(function()
					OptionButton.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
				end)
		
				OptionButton.MouseButton1Click:Connect(function()
					DropdownTitle.Text = item  
					DropdownButton.Text = ""  
					DropdownList.Visible = false
					Settings.Callback(item)
				end)
			end
		
			for i, item in ipairs(Settings.Items) do
				createOption(item, i)
			end
		
			local DropdownOpen = false
			DropdownButton.MouseButton1Click:Connect(function()
				DropdownOpen = not DropdownOpen
				DropdownList.Visible = DropdownOpen
				if DropdownOpen then
					DropdownList.Size = UDim2.new(0.96, 0, 0, 24 * #Settings.Items)
				else
					DropdownList.Size = UDim2.new(0.96, 0, 0, 0)
				end
			end)
		
			-- Update DropdownList position on DropdownActive move
			DropdownActive:GetPropertyChangedSignal("Position"):Connect(function()
				DropdownList.Position = UDim2.new(0.5, -43, 1, 5)  -- Adjust accordingly
			end)
		
			return {
				DropdownButton = DropdownButton,
				DropdownList = DropdownList,
				SetValue = function(option)
					DropdownTitle.Text = option  
					DropdownButton.Text = ""  
					Settings.Callback(option)
				end
			}
		end
		
		
		

		function tab:NewToggle(Title: string, Options: table)
			local Settings = {
				Enabled = Options.Default or false,
				Parent = Options.Parent or Canvas,
				Callback = Options.Callback or function() end
			}

			local ToggleActive = Instance.new('ImageButton', Settings.Parent)
			local ToggleCorner = Instance.new('UICorner', ToggleActive)
			local Checkmark = Instance.new('Frame', ToggleActive)
			local CheckmarkStroke = Instance.new('UIStroke', Checkmark)
			local CheckmarkCorner = Instance.new('UICorner', Checkmark)
			local ToggleTitle = Instance.new('TextLabel', ToggleActive)

			ToggleActive.AutoButtonColor = false
			ToggleActive.Name = "ToggleActive"
			ToggleActive.Size = UDim2.new(0, 524, 0, 33)
			ToggleActive.BackgroundColor3 = Color3.new(0.0353, 0.0353, 0.0353)
			ToggleActive.BorderSizePixel = 0
			ToggleActive.BorderColor3 = Color3.new(0, 0, 0)

			ToggleCorner.CornerRadius = UDim.new(0, 6)

			Checkmark.Name = "Checkmark"
			Checkmark.Position = UDim2.new(0.0344, 0, 0.1818, 0)
			Checkmark.Size = UDim2.new(0, 20, 0, 20)
			Checkmark.BackgroundColor3 = Color3.new(0, 0, 0)
			Checkmark.BorderSizePixel = 0
			Checkmark.BorderColor3 = Color3.new(0, 0, 0)

			CheckmarkCorner.CornerRadius = UDim.new(0, 4)

			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Position = UDim2.new(0.1069, 0, 0.2424, 0)
			ToggleTitle.Size = UDim2.new(0, 86, 0, 17)
			ToggleTitle.BackgroundColor3 = Color3.new(1, 1, 1)
			ToggleTitle.BackgroundTransparency = 1
			ToggleTitle.Text = Title
			ToggleTitle.TextColor3 = Color3.new(0.6353, 0.6353, 0.6353)
			ToggleTitle.Font = Enum.Font.SourceSans
			ToggleTitle.TextSize = 15
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

			local function Toggle(Value)
				if Value then
					TS:Create(Checkmark, TweenInfo.new(.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Color3.fromRGB(64, 9, 150) }):Play()
				else
					TS:Create(Checkmark, TweenInfo.new(.2, Enum.EasingStyle.Quad), { BackgroundColor3 = Color3.fromRGB(0, 0, 0) }):Play()
				end
				Settings.Enabled = Value
				Settings.Callback(Settings.Enabled)
			end

			Toggle(Settings.Enabled)

			ToggleActive.MouseButton1Down:Connect(function()
				Toggle(not Settings.Enabled)
			end)

			return Settings
		end
		
		
		
		
		LPH_NO_VIRTUALIZE(function()
		function tab:NewSlider(Title: string, Options: table)

			local Settings = {
				Connections = {},
				Value 		= Options.Default or 0,
				MinVal 		= Options.Min or 0,
				MaxVal 		= Options.Max or 100,
				Parent		= Options.Parent or Canvas,
				Callback 	= Options.Callback or function() end
			}
			

			local Slider = Instance.new('ImageButton', Canvas)
			local SliderCorner = Instance.new('UICorner', Slider)
			local SliderTitle = Instance.new('TextLabel', Slider)

			local Value = Instance.new('TextLabel', Slider)
			local SliderBack = Instance.new('Frame', Slider)
			local SliderBackCorner = Instance.new('UICorner', SliderBack)
			local SliderMain = Instance.new('Frame', SliderBack)
			local SliderMainCorner = Instance.new('UICorner', SliderMain)
			local SliderBackStroke = Instance.new('UIStroke', SliderBack)
			
			Slider.AutoButtonColor = false
			Slider.Name = "Slider"
			Slider.Size = UDim2.new(0,524,0,33)
			Slider.BackgroundColor3 = Color3.new(0.0353,0.0353,0.0353)
			Slider.BorderSizePixel = 0
			Slider.BorderColor3 = Color3.new(0,0,0)
			SliderCorner.CornerRadius = UDim.new(0,6)
			SliderTitle.Name = "SliderTitle"
			SliderTitle.Position = UDim2.new(0.1069,0,0.2424,0)
			SliderTitle.Size = UDim2.new(0,86,0,17)
			SliderTitle.BackgroundColor3 = Color3.new(1,1,1)
			SliderTitle.BackgroundTransparency = 1
			SliderTitle.BorderSizePixel = 0
			SliderTitle.BorderColor3 = Color3.new(0,0,0)
			SliderTitle.Text = Title
			SliderTitle.TextColor3 = Color3.new(0.6353,0.6353,0.6353)
			SliderTitle.Font = Enum.Font.SourceSans
			SliderTitle.TextSize = 14
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

			Value.Name = "Value"
			Value.Position = UDim2.new(0.0134,0,0.2424,0)
			Value.Size = UDim2.new(0,41,0,17)
			Value.BackgroundColor3 = Color3.new(1,1,1)
			Value.BackgroundTransparency = 1
			Value.BorderSizePixel = 0
			Value.BorderColor3 = Color3.new(0,0,0)
			Value.Text = string.format(Options.Default or 0, Settings.MaxVal)
			Value.TextColor3 = Color3.new(0.5608,0.5608,0.5608)
			Value.Font = Enum.Font.SourceSans
			Value.TextSize = 14
			SliderBack.Name = "SliderBack"
			SliderBack.Position = UDim2.new(0.340,0,0.3636,0)
			SliderBack.Size = UDim2.new(0,342,0,9)
			SliderBack.BackgroundColor3 = Color3.new(0,0,0)
			SliderBack.BorderSizePixel = 0
			SliderBack.BorderColor3 = Color3.new(0,0,0)
			SliderBackCorner.CornerRadius = UDim.new(0,6)
			SliderMain.Name = "SliderMain"
			SliderMain.Size = UDim2.new(0,0,0,9)
			SliderMain.BackgroundColor3 = Color3.new(0.2235,0.0471,0.5216)
			SliderMain.BorderSizePixel = 0
			SliderMain.BorderColor3 = Color3.new(0,0,0)
			SliderMainCorner.CornerRadius = UDim.new(0,6)
			
			
			--canvas
			
			local function GetValue()
				return tonumber(Settings.Value)
			end

			function Settings:SetValue(v)
				local function roundToTwoDecimalPlaces(num)
					return math.floor(num * 100 + 0.5) / 100
				end
			
				if v == nil then
					local mouseX = UIS:GetMouseLocation().X
					local percentage = math.clamp((mouseX - SliderBack.AbsolutePosition.X) / (SliderBack.AbsoluteSize.X), 0, 1)
					local value = roundToTwoDecimalPlaces((((Settings.MaxVal - Settings.MinVal) * percentage) + Settings.MinVal))
					Value.Text = string.format("%.2f", value)
					SliderMain.Size = UDim2.fromScale(percentage, 1)
					Settings.Value = value
					Settings.Callback(value)
				else
					local value = roundToTwoDecimalPlaces(v)
					Value.Text = string.format("%.2f", value)
					SliderMain.Size = UDim2.fromScale(((value - Settings.MinVal) / (Settings.MaxVal - Settings.MinVal)), 1)
					Settings.Value = value
					Settings.Callback(value)
				end
			end
			

			local Connection;

			table.insert(Settings.Connections, UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					pcall(function()
						if Connection then
							Connection:Disconnect();
							Connection = nil;
						end
					end)
				end
			end))

			table.insert(Settings.Connections, Slider.MouseButton1Down:Connect(function()
				if(Connection) then
					Connection:Disconnect();
				end;

				Connection = RS.Heartbeat:Connect(function()
					Settings:SetValue()
				end)
			end))
			

			return Settings
		end
	end)()
		
		LPH_NO_VIRTUALIZE(function()
		function tab:NewSection(SectionTitle: string, Options: table)
			local Settings = {}

			local Section = Instance.new('Frame', Canvas)
			local STitle = Instance.new('TextLabel', Section)
			local UIPadding = Instance.new('UIPadding', Section)


			Section.Name = "Section"
			Section.Position = UDim2.new(0,0,0.2568,0)
			Section.Size = UDim2.new(0,524,0,12)
			Section.BackgroundColor3 = Color3.new(0.0353,0.0353,0.0353)
			Section.BackgroundTransparency = 1
			Section.BorderSizePixel = 0
			Section.BorderColor3 = Color3.new(0,0,0)
			STitle.Name = "SectionTitle"
			STitle.Position = UDim2.new(0.0344,0,-0.2576,0)
			STitle.Size = UDim2.new(0,86,0,17)
			STitle.BackgroundColor3 = Color3.new(1,1,1)
			STitle.BackgroundTransparency = 1
			STitle.BorderSizePixel = 0
			STitle.BorderColor3 = Color3.new(0,0,0)
			STitle.Text = SectionTitle
			STitle.TextColor3 = Color3.new(0.5137,0.5137,0.5137)
			STitle.Font = Enum.Font.SourceSans
			STitle.TextSize = 12
			STitle.TextXAlignment = Enum.TextXAlignment.Left
			UIPadding.PaddingRight = UDim.new(0,300)

		

			return Settings
		end
	end)()
		return tab
	end

	return window
end





LPH_JIT_MAX(function()
    LPH_NO_VIRTUALIZE(function()
    local Hooks = {}
    local Targets = {}
    local Whitelisted = {
        {655, 775, 724, 633, 891},
        {760, 760, 771, 665, 898},
        {660, 759, 751, 863, 771},
    }
    
    local function TableEquality(x, y)
        if (#x ~= #y) then
            return false
        end
    
        for i, v in next, x do
            if (y[i] ~= v) then
                return false
            end
        end
    
        return true
    end
    
    for i, v in next, getgc(true) do
        if (type(v) == "function") then
            local ScriptTrace, Line = debug.info(v, "sl")
    
            if string.find(ScriptTrace, "PlayerModule.LocalScript") and table.find({42, 51, 61}, Line) then
                table.insert(Targets, v)
            end
        end
        
        if (type(v) == "table") and (rawlen(v) == 19) and getrawmetatable(v) then
            Targets.__call = rawget(getrawmetatable(v), "__call")
        end
    end
    
    if not (Targets[1] and Targets[2] and Targets[3] and Targets.__call) then
        warn("Failed.")
        return
    end
    
    local ScriptPath = debug.info(Targets[1], "s")
    
    Hooks.debug_info = hookfunction(debug.info, function(...)
        if not checkcaller() and TableEquality({...}, {2, "s"}) then
            return ScriptPath
        end
    
        return Hooks.debug_info(...)
    end)
    
    hookfunction(Targets[1], function() end)
    hookfunction(Targets[2], function() end)
    hookfunction(Targets[3], function() end)
    
    Hooks.__call = hookfunction(Targets.__call, function(self, ...)
        if
            TableEquality(Whitelisted[1], {...}) or
            TableEquality(Whitelisted[2], {...}) or
            TableEquality(Whitelisted[3], {...})
        then
            return Hooks.__call(self, ...)
        end
    end)
    
    task.wait(3)
    
end)()
end)()
local LightingUI = LightingLib:newWindow("Lightning.cc")

--// services
local Workspace = game:GetService("Workspace")


local replicatedStorage = game:GetService("ReplicatedStorage")

--// variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local values = replicatedStorage:FindFirstChild("Values")


local ThrowingTab = LightingUI:newTab("Throwing")
local CatchingTab = LightingUI:newTab("Catching")
local PlayerTab = LightingUI:newTab("Player")
local AutomaticsTab = LightingUI:newTab("Automatics")
local PhysicsTab = LightingUI:newTab("Physics")
local MiscTab = LightingUI:newTab("Misc")
local VisualsTab = LightingUI:newTab("Visuals")
local TrollingTab = LightingUI:newTab("Trolling")

getgenv().ToggleSettings = {
    AllMags = false,
    HitboxEnabled = false,
    HitboxSize = 10,
    HitboxVisible = false,
    HitboxTransparency = 0.7,
    HitboxDuration = 7,
    unvCrange = 0,
    BCrange = 0,
    ActivationChance = 100, -- in percentage
    Delay = 0,
    LegitPower = 1, 
    LeaguePower = 1,
}
local ballresize = false
local resizedball = 1
local currentMagType = ""
local delayTime = 0.5 -- Default delay
local EnabledPullVector = false
local PullVectorDistance = 0
local Speed = 0
local AntiUnderMap = false
local OffsetY = 1
local SmoothFactor = 1 
local teleportEnabled = false
local teleportDistance = 0
local teleportHeight = 0
local currentMagType = ""
local enabled = false
local beamMode = false
local antiOOB = false
local sjujdaudaudfhaudapsiduwqjoaLhdyoduoadhao = false
local antiOOBThreshold = 3
local customLeadDistance = 0
local jpon = false
local jpvalue = 52 
local angleon = false
local anglevalue = 50
local angleind = false
local sizelegon = false
local sizedleg = 5
local Tackleon = false
local removeJumpCooldownConnection
local isAntiJamEnabled = false
local autobooston = false
local autoboostpower = 5
local teleportEnabled = false
local teleportDistance = 1 
local Headresizeon = false
local resizedheads = 5
local headtransparency = 0.5
local CFrameSpeedCallback = false
local CFrameSpeedValue = 0
local jumpCooldownOn = 0.505  
local jumpCooldownOff = 3.3  
local canJump = true  
local jumpCooldownEnabled = false
local undergroundPartName = "UndergroundPart"
local undergroundPart = workspace:FindFirstChild(undergroundPartName)
local undergroundPartHeight = 0.001 








local hitboxes = {}
local currentMagType = "Regular"

local function getEffectiveMagnetDistance(value)
    if currentMagType == "League" then
        return value * 0.1 * getgenv().ToggleSettings.LeaguePower 
    elseif currentMagType == "Legit" then
        return value * 0.25 * getgenv().ToggleSettings.LegitPower
    else
        return value * 1
    end
end

local function createOrUpdateHitbox(football)
    football.CanCollide = false
    football.Size = Vector3.new(getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize))
    
    local hitbox = football.Parent:FindFirstChild("Hitbox")
    if hitbox then
        hitbox.Size = Vector3.new(getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize))
    else
        hitbox = Instance.new("Part")
        hitbox.Name = "Hitbox"
        hitbox.Size = Vector3.new(getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize), getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize))
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Transparency = getgenv().ToggleSettings.HitboxVisible and getgenv().ToggleSettings.HitboxTransparency or 1
        hitbox.BrickColor = BrickColor.new("Cool grey")
        hitbox.Parent = football.Parent
    end
    hitbox.CFrame = CFrame.new(football.Position)
    
    spawn(function()
        wait(getgenv().ToggleSettings.HitboxDuration)
        hitbox:Destroy()
    end)
end

local function updateHitboxes()
    for _, football in ipairs(Workspace:GetChildren()) do
        if football.Name == "Football" and football:IsA("BasePart") then
            createOrUpdateHitbox(football)
        end
    end
end

local function regularCatch()
    if getgenv().ToggleSettings.AllMags then
        local catchRight = Players.LocalPlayer.Character:FindFirstChild("CatchRight")
        if not catchRight then
            return
        end
        
        local closestFootball = nil
        local closestDistance = math.huge
        
        for _, football in ipairs(Workspace:GetChildren()) do
            if football.Name == "Football" and football:IsA("BasePart") then
                local distance = (football.Position - catchRight.Position).Magnitude
                if distance < closestDistance and distance <= getgenv().ToggleSettings.unvCrange then
                    closestFootball = football
                    closestDistance = distance
                end
            end
        end
        
        if closestFootball then
            local chance = getgenv().ToggleSettings.ActivationChance
            local delay = getgenv().ToggleSettings.Delay
            
            if math.random(100, 100) <= chance then
                wait(delay)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 0)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 0)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 1)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 1)
            end
        end
    end
end

local function LegitCatch()
    if getgenv().ToggleSettings.AllMags then
        local catchRight = Players.LocalPlayer.Character:FindFirstChild("CatchRight")
        if not catchRight then
            return
        end
        
        local closestFootball = nil
        local closestDistance = math.huge
        
        for _, football in ipairs(Workspace:GetChildren()) do
            if football.Name == "Football" and football:IsA("BasePart") then
                local distance = (football.Position - catchRight.Position).Magnitude
                if distance < closestDistance and distance <= getgenv().ToggleSettings.unvCrange then
                    closestFootball = football
                    closestDistance = distance
                end
            end
        end
        
        if closestFootball then
            local chance = getgenv().ToggleSettings.ActivationChance
            local delay = getgenv().ToggleSettings.Delay
            
            if math.random(100, 100) <= chance then
                wait(delay)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 0)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 0)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 1)
                firetouchinterest(Players.LocalPlayer.Character["CatchRight"], closestFootball, 1)
            end
        end
    end
end

local function LeagueCatch()
    if getgenv().ToggleSettings.AllMags then
        local catchRight = Players.LocalPlayer.Character:FindFirstChild("CatchRight")
        if not catchRight then
            return
        end
        
        local closestFootball = nil
        local closestDistance = math.huge
        
        for _, football in ipairs(Workspace:GetChildren()) do
            if football.Name == "Football" and football:IsA("BasePart") then
                local distance = (football.Position - catchRight.Position).Magnitude
                if distance < closestDistance and distance <= getgenv().ToggleSettings.unvCrange then
                    closestFootball = football
                    closestDistance = distance
                end
            end
        end
        
        if closestFootball then
            local distanceAdjustment = getEffectiveMagnetDistance(getgenv().ToggleSettings.HitboxSize)
            local tweenService = game:GetService("TweenService")
            local tweenInfo = TweenInfo.new(0, Enum.EasingStyle.Linear)
            tweenService:Create(closestFootball, tweenInfo, {Position = catchRight.Position}):Play()
        end
    end
end

local function BlatantCatch()
    if getgenv().ToggleSettings.AllMags then
        local catchRight = Players.LocalPlayer.Character:FindFirstChild("CatchRight")
        if not catchRight then
            return
        end
        
        local closestFootball = nil
        local closestDistance = math.huge
        
        for _, football in ipairs(Workspace:GetChildren()) do
            if football.Name == "Football" and football:IsA("BasePart") then
                local distance = (football.Position - catchRight.Position).Magnitude
                if distance < closestDistance and distance <= getgenv().ToggleSettings.BCrange then
                    closestFootball = football
                    closestDistance = distance
                end
            end
        end
        
        if closestFootball then
            for _ = 1, 30 do
                wait()
                local tweenService = game:GetService("TweenService")
                local tweenInfo = TweenInfo.new(.0, Enum.EasingStyle.Linear)
                tweenService:Create(closestFootball, tweenInfo, {CFrame = catchRight.CFrame}):Play()
                wait()
            end
        end
    end
end

CatchingTab:NewSection("FireTouchInstance Magnets")





CatchingTab:Dropdown("Magnets Mode:", {
    Items = {"Regular", "Blatant", "Legit", "League"},
    Default = "",
    Callback = function(selectedItem)
        currentMagType = selectedItem
        print("You selected:", selectedItem)
        updateHitboxes()
    end
})

CatchingTab:NewToggle("Activate Magnets", {
    Default = false,
    Callback = function(enabled)
        getgenv().ToggleSettings.AllMags = enabled
        if enabled then
            getgenv().ToggleSettings.HitboxEnabled = true
        else
            getgenv().ToggleSettings.HitboxEnabled = false
            for _, v in ipairs(Workspace:GetChildren()) do
                if v.Name == "Football" and v:IsA("BasePart") then
                    local hitbox = v.Parent:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox:Destroy()
                    end
                end
            end
        end
    end
})

CatchingTab:NewSlider("Magnets Range", {
    Default = 0,
    Max = 40,
    Min = 1,
    Callback = function(size)
        getgenv().ToggleSettings.HitboxSize = size
        updateHitboxes()
    end
})


CatchingTab:NewSlider("Magnets Delay", {
    Default = 0,
    Max = 2,
    Min = 0,
    Callback = function(delay)
        getgenv().ToggleSettings.Delay = delay
    end
})



CatchingTab:NewToggle("Visualize Magnets Hitbox", {
    Default = false,
    Callback = function(visible)
        getgenv().ToggleSettings.HitboxVisible = visible
        for _, v in ipairs(Workspace:GetChildren()) do
            if v.Name == "Football" and v:IsA("BasePart") then
                local hitbox = v.Parent:FindFirstChild("Hitbox")
                if hitbox then
                    hitbox.Transparency = visible and getgenv().ToggleSettings.HitboxTransparency or 0.7
                end
            end
        end
    end
})






userInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if currentMagType == "Legit" then
            LegitCatch()
        elseif currentMagType == "League" then
            LeagueCatch()
        elseif currentMagType == "Blatant" then
            BlatantCatch()
        elseif currentMagType == "Regular" then
            regularCatch()
        end
    end
end)

spawn(function()
    while true do
        wait()
        if getgenv().ToggleSettings.HitboxEnabled then
            updateHitboxes()
        end
    end
end)




local TweenService = game:GetService("TweenService")



local teleportSettings = {
    maxDistance = 35,
    numTeleports = 30,
    tweenDuration = 0.05,
    tweenStyle = Enum.EasingStyle.Linear,
}

local isTeleportActive = false
local teleportDistance = 0

local function getCatchRight()
    return player.Character and player.Character:FindFirstChild("CatchRight")
end

local function getClosestFootball(catchRight)
    local closestFootball = nil
    local closestDistance = math.huge

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Football" then
            local distance = (obj.Position - catchRight.Position).Magnitude
            if distance < closestDistance and distance <= teleportDistance then
                obj.CanCollide = false
                closestDistance = distance
                closestFootball = obj
            end
        end
    end

    return closestFootball
end

local function teleportFootball(football, catchRight)
    local tweenInfo = TweenInfo.new(teleportSettings.tweenDuration, teleportSettings.tweenStyle)
    local tween = TweenService:Create(football, tweenInfo, {CFrame = catchRight.CFrame})

    tween:Play()
    tween.Completed:Wait()
end

local function handleInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local catchRight = getCatchRight()
        if not catchRight then
            return
        end

        local closestFootball = getClosestFootball(catchRight)
        if closestFootball then
            teleportFootball(closestFootball, catchRight)
        else
        end
    end
end

local function toggleTeleportation(isActive)
    isTeleportActive = isActive
    if isActive then
        UserInputService.InputBegan:Connect(handleInput)
        print("Teleportation")
    else
        print("Teleportation BUGGED")
    end
end

CatchingTab:NewSection("Velocity Powerered Magnets")


CatchingTab:NewToggle("Teleportation Magnets", {
    Default = false,
    Callback = toggleTeleportation
})

CatchingTab:NewSlider("Teleportation Distance", {
    Default = teleportSettings.maxDistance,
    Max = 40, 
    Min = 0,
    Callback = function(value)
        teleportDistance = value
    end
})

CatchingTab:NewSlider("Number of Teleports", {
    Default = teleportSettings.numTeleports,
    Max = 20, 
    Min = 0,
    Callback = function(value)
        teleportSettings.numTeleports = value
    end
})

CatchingTab:NewSlider("Tween Duration Delay", {
    Default = teleportSettings.tweenDuration,
    Max = 1,
    Min = 0,
    Callback = function(value)
        teleportSettings.tweenDuration = value
   end
})



local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local userInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerBackpack = player.Backpack
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

local teleportSettings = {
    maxDistance = 35,
    tweenDuration = 0.05,
    tweenStyle = Enum.EasingStyle.Linear,
    revertDuration = 3, 
}

local isTeleportActive = false
local teleportDistance = teleportSettings.maxDistance

local function getCatchRight()
    return player.Character and player.Character:FindFirstChild("CatchRight")
end

local function isInBackpack(item)
    for _, obj in pairs(playerBackpack:GetChildren()) do
        if obj:IsA("BasePart") and obj.Name == item.Name then
            return true
        end
    end
    return false
end

local function freezePlayer(duration)
    if humanoid then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        task.delay(duration, function()
            if humanoid then
                humanoid.PlatformStand = false
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end
end

local function getClosestFootball(catchRight)
    local closestFootball = nil
    local closestDistance = math.huge

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Football" and not isInBackpack(obj) then
            local distance = (obj.Position - catchRight.Position).Magnitude
            if distance < closestDistance and distance <= teleportDistance then
                obj.CanCollide = false
                closestDistance = distance
                closestFootball = obj
            end
        end
    end

    return closestFootball
end

local function teleportFootball(football, catchRight)
    local tweenInfo = TweenInfo.new(teleportSettings.tweenDuration, teleportSettings.tweenStyle)
    local tween = TweenService:Create(football, tweenInfo, {CFrame = catchRight.CFrame})
    tween:Play()
end

local function handleInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local catchRight = getCatchRight()
        if not catchRight then return end

        while true do
            local closestFootball = getClosestFootball(catchRight)
            if closestFootball then
                freezePlayer(teleportSettings.revertDuration) 
                teleportFootball(closestFootball, catchRight)
                task.wait()  
                if isInBackpack(closestFootball) then
                    break
                end
            else
                break
            end
        end
    end
end

local function toggleTeleportation(isActive)
    isTeleportActive = isActive
    if isActive then
        userInputService.InputBegan:Connect(handleInput)
    else
    end
end

getgenv().freezeEnabled = false
getgenv().freezeDuration = 5

local function freezeCharacter()
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoidRootPart or not humanoid then return end

    local targetPosition = humanoidRootPart.Position

    character:SetPrimaryPartCFrame(CFrame.new(targetPosition + Vector3.new(0, 0.1, 0)))

    local function onHeartbeat()
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 0.1, 0))
        end
    end

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not humanoidRootPart or not humanoid.PlatformStand then
            connection:Disconnect()
            return
        end
        onHeartbeat()
    end)

    task.delay(getgenv().freezeDuration, function()
        if humanoidRootPart and humanoid then
            humanoid.PlatformStand = false
        end
    end)
end

local function checkForItems()
    local character = player.Character
    local backpack = player.Backpack

    if character and character:FindFirstChildOfClass("Tool") then
        freezeCharacter()
        return false
    end

    if backpack and backpack:FindFirstChildOfClass("Tool") then
        freezeCharacter()
        return false 
    end

    return true 
end

local function startItemCheck()
    while getgenv().freezeEnabled do
        if checkForItems() then
            task.wait() 
        end
    end
end

local function onToolRemoved()
    if getgenv().freezeEnabled then
        startItemCheck()
    end
end

local function setupToolMonitoring()
    local backpack = player.Backpack
    if backpack then
        backpack.ChildRemoved:Connect(onToolRemoved)
    end
end

local currentFreezeType = ""

local function updateFreezeType()
    if currentFreezeType == "Blatant Freeze" then
        toggleTeleportation(isTeleportActive)
    elseif currentFreezeType == "Legit Freeze" then
        getgenv().freezeEnabled = isTeleportActive
        if isTeleportActive then
            setupToolMonitoring()
            task.spawn(startItemCheck)
        end
    end
end

CatchingTab:NewSection("Freeze Magnets")

CatchingTab:Dropdown("Freeze Type", {
    Items = {"Legit Freeze", "Blatant Freeze"},
    Default = "",
    Callback = function(selectedItem)
        currentFreezeType = selectedItem
        print("You selected:", selectedItem)
        updateFreezeType()
    end
})

CatchingTab:NewToggle("Freeze Magnets", {
    Default = false,
    Callback = function(value)
        isTeleportActive = value
        updateFreezeType()
    end
})

CatchingTab:NewSlider("Freeze Magnets Range", {
    Default = teleportSettings.maxDistance,
    Max = 50,
    Min = 0,
    Callback = function(value)
        teleportDistance = value
    end
})

CatchingTab:NewSlider("Freeze Duration", {
    Default = teleportSettings.revertDuration,
    Max = 10,
    Min = 1,
    Callback = function(value)
        teleportSettings.revertDuration = value
        getgenv().freezeDuration = value
    end
})

updateFreezeType()






-- Define the ball resize modes
local function BlatantCatch()
    task.spawn(function()
        while task.wait(delayTime) do
            if ballresize then
                Workspace.ChildAdded:Connect(function(Value)
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(resizedball, resizedball, resizedball)
                        Value.CanCollide = false
                    end
                end)
            else
                for _, Value in pairs(Workspace:GetChildren()) do
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(0.85, 1.2, 0.85)
                        Value.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function LegitCatch()
    task.spawn(function()
        while task.wait(delayTime) do
            if ballresize then
                Workspace.ChildAdded:Connect(function(Value)
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(resizedball * 0.7, resizedball, resizedball * 0.7)
                        Value.CanCollide = false
                    end
                end)
            else
                for _, Value in pairs(Workspace:GetChildren()) do
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(0.85, 1.2, 0.85)
                        Value.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function RegularCatch()
    task.spawn(function()
        while task.wait(delayTime) do
            if ballresize then
                Workspace.ChildAdded:Connect(function(Value)
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(resizedball * 0.9, resizedball, resizedball * 0.9)
                        Value.CanCollide = true
                    end
                end)
            else
                for _, Value in pairs(Workspace:GetChildren()) do
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(0.9, 1.1, 0.9)
                        Value.CanCollide = true
                    end
                end
            end
        end
    end)
end

local function LeagueCatch()
    task.spawn(function()
        while task.wait(delayTime) do
            if ballresize then
                Workspace.ChildAdded:Connect(function(Value)
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(resizedball * 0.45, resizedball, resizedball * 0.45)
                        Value.CanCollide = true
                    end
                end)
            else
                for _, Value in pairs(Workspace:GetChildren()) do
                    if Value.Name == "Football" and Value:IsA("BasePart") then
                        Value.Size = Vector3.new(0.7, 1.0, 0.7)
                        Value.CanCollide = true
                    end
                end
            end
        end
    end)
end

local function updateHitboxes()
    if currentMagType == "Blatant" then
        BlatantCatch()
    elseif currentMagType == "Legit" then
        LegitCatch()
    elseif currentMagType == "Regular" then
        RegularCatch()
    elseif currentMagType == "League" then
        LeagueCatch()
    end
end
CatchingTab:NewSection("Football Resize Magnets")

CatchingTab:Dropdown("Resize Type", {
    Items = {"Blatant", "Legit", "Regular", "League"},
    Default = "",
    Callback = function(selectedItem)
        currentMagType = selectedItem
        print("You selected:", selectedItem)
        updateHitboxes()
    end
})

CatchingTab:NewToggle("Ball Resize", {
    Default = false,
    Callback = function(value)
        ballresize = value
        updateHitboxes() 
    end,
})

CatchingTab:NewSlider("Custom Resize", {
    Default = 0,
    Max = 30,
    Min = 1,
    Callback = function(value)
        resizedball = value
        updateHitboxes() 
    end,
})

CatchingTab:NewSlider("Delay Time", {
    Default = 0.5,
    Max = 2,
    Min = 0,
    Callback = function(value)
        delayTime = value
    end,
})
CatchingTab:NewSection("Arm Length Resizement")


CatchingTab:NewToggle("Increase Arm Length", {
    Default = false,
    Callback = function(enabled)
        _G.CheckingTool = enabled
        if enabled then
            updateArms()
        else
            if LocalPlayer.Character:FindFirstChild('Left Arm') and LocalPlayer.Character:FindFirstChild('Right Arm') then
                LocalPlayer.Character['Left Arm'].Size = Vector3.new(1, 2, 1)
                LocalPlayer.Character['Right Arm'].Size = Vector3.new(1, 2, 1)
                LocalPlayer.Character['Left Arm'].Transparency = 0
                LocalPlayer.Character['Right Arm'].Transparency = 0
            end
        end
    end
})


CatchingTab:NewSlider("Custom Arm Length", {
    Default = _G.Arms,
    Max = 30,
    Min = 1,
    Callback = function(value)
        _G.Arms = value
        if _G.CheckingTool then
            updateArms()
        end
    end,
})

CatchingTab:NewSlider("Custom Arm Visibility", {
    Default = _G.Visibility,
    Max = 1,
    Min = 0,
    Callback = function(value)
        _G.Visibility = value
        if _G.CheckingTool then
            updateArms()
        end
    end,
})





local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local RepulsiveVectorDistance = 10
local RepulsiveVectorStrength = 1
local AttractiveVectorDistance = 10
local AttractiveVectorStrength = 1
local PullVectorDistance = 10
local Speed = 1
local OffsetY = 0
local teleportDistance = 10
local teleportHeight = 0
local SmoothFactor = 1
local AntiUnderMap = true
local EnabledPullVector = false
local teleportEnabled = false
local TweenTime = 1 
local TweenDistance = 10 
local teleportDelay = 1 
local currentMagType = ""
local function teleportToNearestFootball()
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end

    local closestFootball = nil
    local closestDistance = teleportDistance

    for _, football in ipairs(Workspace:GetDescendants()) do
        if football.Name == "Football" and football:IsA("BasePart") then
            local distance = (football.Position - humanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestFootball = football
                closestDistance = distance
            end
        end
    end

    if closestFootball then
        local targetPosition = closestFootball.Position + Vector3.new(0, teleportHeight, 0)
        delay(teleportDelay, function()
            humanoidRootPart.CFrame = CFrame.new(targetPosition)
        end)
    end
end

local function tweenToPosition(targetPosition)
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        return
    end

    local distance = (targetPosition - humanoidRootPart.Position).Magnitude
    if distance > TweenDistance then
        targetPosition = humanoidRootPart.Position + (targetPosition - humanoidRootPart.Position).unit * TweenDistance
    end

    local tweenInfo = TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local goal = { CFrame = CFrame.new(targetPosition) }

    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
end

local function updateMagnetSettings()
    EnabledPullVector = false
    teleportEnabled = false

    if currentMagType == "Repulsive" or currentMagType == "Attractive" or currentMagType == "Velocity" or currentMagType == "Gravitational" then
    elseif currentMagType == "Teleportation" then
    elseif currentMagType == "Tween" then
    end
end
    


local player =  game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local camera = workspace.CurrentCamera

local locked = false
local target = nil

local throwType = "Bullet"

local data = {
Angle = 45,
Direction = Vector3.new(0, 0, 0),
Power = 0
}











PlayerTab:NewSection("Custom Walkspeed")


local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

local currentWalkspeed = 20 

LPH_JIT_MAX(function()

PlayerTab:NewToggle("WalkSpeed", {
	Default = false,
	Callback = function(value)
		walkspeedEnabled = value
        if walkspeedEnabled then
            player.Character.Humanoid.WalkSpeed = currentWalkspeed
          
            spawn(function()
                while walkspeedEnabled do
                    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = currentWalkspeed
                    end
                    wait(2) 
                end
            end)
        else
            player.Character.Humanoid.WalkSpeed = 20 
        end
	end,
})

PlayerTab:NewSlider("Custom Speed", {
	Default = 20,
	Max     = 23,
	Min     = 20,
	Callback = function(value)
		currentWalkspeed = value
	end,
})


end)()








PlayerTab:NewSection("Custom JumpPower")
LPH_JIT_MAX(function()
PlayerTab:NewToggle("JumpPower", {
    Default = false,
    Callback = function(Value)
        jpon = Value
    end,
})

PlayerTab:NewSlider("Custom Power", {
    Default = 50,
    Max     = 70,
    Min     = 50,
    Callback = function(Value)
        jpvalue = Value
    end,
})
end)()


local function onCharacterMovement(character)
    local humanoid = character:WaitForChild("Humanoid")
    

    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping and jpon then
            task.wait(0.1)
            humanoidRootPart.AssemblyLinearVelocity += Vector3.new(0, jpvalue - 50, 0)
        end
    end)
end

onCharacterMovement(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

PlayerTab:NewSection("CharacterBoosts")



	PlayerTab:NewToggle("Angle Boosting", {
		Default = false,
		Callback = function(Value)
			angleon = Value
		end,
	})
	
	PlayerTab:NewSlider("JumpPower", {
		Default = 50,
		Max     = 70,
		Min     = 50,
		Callback = function(Value)
			anglevalue = Value
		end,
	})

	PlayerTab:NewToggle("Angle Indicator", {
		Default = false,
		Callback = function(Value)
			angleind = Value
		end,
	})



task.spawn(function()
	LPH_NO_VIRTUALIZE(function()
	local angleTick = os.clock()
	local oldLookVector = Vector3.new(0, 0, 0)
	
	local shiftLockEnabled = false
	local lastEnabled = false

	local function hookCharacter(character)
		local humanoid = character:WaitForChild("Humanoid")
		local hrp = character:WaitForChild("HumanoidRootPart")

		humanoid.Jumping:Connect(function()
			if humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then return end
			if os.clock() - angleTick > 0.2 then return end
			if not angleon then return end

			if angleind then
				local h = Instance.new("Hint")
				h.Text = "Angled"
				h.Parent = workspace

				game:GetService("Debris"):AddItem(h, 1)
			end

			task.wait(0.05)
			HumanoidRootPart.AssemblyLinearVelocity += Vector3.new(0, jpvalue - 50, 0)
		end)
	end

	hookCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

	LocalPlayer.CharacterAdded:Connect(hookCharacter)
	
	game:GetService("UserInputService"):GetPropertyChangedSignal("MouseBehavior"):Connect(function()
		if game:GetService("UserInputService").MouseBehavior == Enum.MouseBehavior.LockCenter then
			shiftLockEnabled = true
		else
			shiftLockEnabled = false
		end
	end)

	while true do
		task.wait()
		local character = LocalPlayer.Character
		if not character then continue end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then continue end
		local humanoid = character:FindFirstChild("Humanoid")
		if not humanoid then continue end	

		local lookVector = hrp.CFrame.LookVector
		local difference = (oldLookVector - lookVector).Magnitude

		if not shiftLockEnabled and lastEnabled then
			angleTick = os.clock()
		end

		if (os.clock() - angleTick < 0.2) and angleon then
			HumanoidRootPart.AssemblyLinearVelocity += Vector3.new(0, jpvalue - 50, 0)
		elseif not angleon then
			humanoid.JumpPower = 50
		end

		oldLookVector = hrp.CFrame.LookVector
		lastEnabled = shiftLockEnabled
	end
end)()
end) 


PlayerTab:NewSection("Other Player Configs")




local LeftLeg = Character:FindFirstChild("Left Leg") 
local RightLeg = Character:FindFirstChild("Right Leg") 



PlayerTab:NewToggle("Resize Player Legs", {
    Default = false,
    Callback = function(value)
        sizelegon = value
    end,
})

PlayerTab:NewSlider("Custom Size", {
    Default = 0,
    Max     = 15,
    Min     = 0,
    Callback = function(value)
        sizedleg = value
    end,
})


local function SizeLeg()
    if sizelegon and LeftLeg and RightLeg then
        LeftLeg.Size = Vector3.new(1, sizedleg, 1)
        RightLeg.Size = Vector3.new(1, sizedleg, 1)
	else
		LeftLeg.Size = Vector3.new(1, 2, 1)
        RightLeg.Size = Vector3.new(1, 2, 1)
    end
end


task.spawn(function()
    while task.wait() do
        SizeLeg()
    end
end)





PlayerTab:NewToggle("Tackle Extension", {
    Default = false,
    Callback = function(value)
		Tackleon = value
    end,
})

local function TackleEvent()
		if Tackleon then
	local args = {
		[1] = "Game",
		[2] = "TackleTouch",
		[3] = "Left Leg",
		[4] = "Right Leg"
	}

	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CharacterSoundEvent"):FireServer(unpack(args))

end
end

task.spawn(function()
while task.wait() do
TackleEvent()
end
end)


PlayerTab:NewToggle("No Jump Cooldown", {
    Default  = false,
    Callback = function(value)
       if value then
		removeJumpCooldownConnection = UIS.JumpRequest:Connect(function()
			if value then
				Player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			end
		end)
	else
		if removeJumpCooldownConnection then
			removeJumpCooldownConnection:Disconnect()
		end
	   end
    end,
})



local function updateCollisionState()
	while true do
		if isAntiJamEnabled then
			if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and game:GetService("Players").LocalPlayer.Character.Head.CanCollide then
				for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
					if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
						pcall(function()
							player.Character.Torso.CanCollide = false
							player.Character.Head.CanCollide = false
						end)
					end
				end
			end
		else
			if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") and not game:GetService("Players").LocalPlayer.Character.Head.CanCollide then
				game:GetService("Players").LocalPlayer.Character.Torso.CanCollide = true
				game:GetService("Players").LocalPlayer.Character.Head.CanCollide = true
			end
		end
		task.wait()
	end
end



PlayerTab:NewToggle("Anti Jam", {
    Default  = false,
    Callback = function(value)
		isAntiJamEnabled = value
    end,
})

spawn(updateCollisionState)














AutomaticsTab:NewSection("Kicker Aimbot")

local accuracy = 0.04
local power = 95.61

local function fireRemoteEvent()
    local args = {
        [1] = "KickData",
        [2] = 46,
        [3] = power,
        [4] = accuracy,  
        [5] = false
    }

    if workspace:FindFirstChild("KickerBall") and workspace.KickerBall:FindFirstChild("RemoteEvent") then
        workspace.KickerBall.RemoteEvent:FireServer(unpack(args))
    end
end

local function executeLoop()
    while isRunning do
        fireRemoteEvent()
        wait(0.2)
    end
end

AutomaticsTab:NewToggle("Auto Kick", {
    Default = false,
    Callback = function(v)
        isRunning = v
        if v then
            executeLoop()
        end
    end
})

AutomaticsTab:NewSlider("Auto Kick Accuracy", {
    Default = 0,
    Max = 100,
    Min = 0,
    Callback = function(value)
        accuracy = 0.04 + ((1 - 0.04) * ((100 - value) / 99))
    end
})

AutomaticsTab:NewSlider("Auto Kick Power", {
    Default = 0,
    Max = 100,
    Min = 0,
    Callback = function(value)
        power = value
    end
})


local function PredictPosition(carrier, humanoid)
    local targetPosition = carrier.Character and carrier.Character:FindFirstChild("HumanoidRootPart") and carrier.Character.HumanoidRootPart.Position
    
    if not targetPosition then
        return nil
    end
    
    local currentPos = humanoid.RootPart.Position
    local carrierVelocity = carrier.Character.HumanoidRootPart.Velocity
    local carrierAcceleration = carrier.Character.HumanoidRootPart:GetVelocityAtPosition(targetPosition) - carrierVelocity
    
    local predictedPosition = targetPosition + carrierVelocity * predictionFactor + 0.5 * carrierAcceleration * predictionFactor^2
    
    return predictedPosition
end

local function IsMoving(carrier)
    local carrierVelocity = carrier.Character and carrier.Character:FindFirstChild("HumanoidRootPart") and carrier.Character.HumanoidRootPart.Velocity
    return carrierVelocity and carrierVelocity.magnitude > 0
end

local function IsWithinFollowRange(carrier, humanoid)
    local carrierPosition = carrier.Character and carrier.Character:FindFirstChild("HumanoidRootPart") and carrier.Character.HumanoidRootPart.Position
    
    if not carrierPosition then
        return false
    end
        
    return distance <= maxFollowDistance
end

local function FollowCarrier()
    while AutoFollowQb do
        local carrier = game:GetService("ReplicatedStorage").Values.Carrier.Value
        
        if carrier and carrier:IsDescendantOf(game:GetService("Players")) and carrier.Team ~= game:GetService("Players").LocalPlayer.Team then
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
            
            if humanoid and IsWithinFollowRange(carrier, humanoid) then
                local predictedPosition = PredictPosition(carrier, humanoid)
                
                if predictedPosition then
                    local direction = (predictedPosition - humanoid.RootPart.Position).unit
                    
                    if IsMoving(carrier) then
                        humanoid:MoveTo(predictedPosition - direction * tackleOffset)
                    else
                        humanoid:MoveTo(predictedPosition)
                    end
                end
            end
        end
        
        wait(predictionInterval)
    end
end
--ui.par

local function ToggleFollowCarrier(value)
    AutoFollowQb = value
    if value then
        followCarrierTask = task.defer(FollowCarrier)
    else
        if followCarrierTask then
            followCarrierTask:cancel()
        end
    end
end
--ui.par
local function UpdateFollowRange()
    while true do
        if AutoFollowQb then
            local humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") -- ⚠️ Warning: 'humanoid' is already defined exactly the same.
            local carrier = game:GetService("ReplicatedStorage").Values.Carrier.Value -- ⚠️ Warning: 'carrier' is already defined exactly the same.
            
            if humanoid and carrier and carrier:IsDescendantOf(game:GetService("Players")) and carrier.Team ~= game:GetService("Players").LocalPlayer.Team then
                local targetPosition = carrier.Character and carrier.Character:FindFirstChild("HumanoidRootPart") and carrier.Character.HumanoidRootPart.Position -- ⚠️ Warning: 'targetPosition' is already defined exactly the same.
                
                if targetPosition then
                    local currentPos = humanoid.RootPart.Position -- ⚠️ Warning: 'currentPos' is already defined exactly the same.
                    local direction = (targetPosition - currentPos).unit
                    local distance = (targetPosition - currentPos).magnitude
                    
                    if distance > maxFollowDistance then
                        humanoid:MoveTo(currentPos + direction * (distance - maxFollowDistance))
                    end
                end
            end
        end
        
        wait()
    end
end

task.spawn(UpdateFollowRange)

AutomaticsTab:NewSection("Head Boost")
AutomaticsTab:NewToggle("Auto Rush Qb", {
    Default = false,
    Callback = ToggleFollowCarrier
})

AutomaticsTab:NewSlider("Auto Rush Distance", {
    Default = 0,
    Max = 30,
    Min = 0,
    Callback = function(value)
        maxFollowDistance = value
    end
})

AutomaticsTab:NewSlider("Auto Rush Prediction %", {
    Default = 0,
    Max = 3,
    Min = 0,
    Callback = function(value)
        minPredictDistance = value
    end
})

local isCatching = false
local IS_PRACTICE = game.PlaceId == 8206123457
local finishLine = not IS_PRACTICE and workspace.Models.LockerRoomA.FinishLine or Instance.new('Part')

autocapon = false
LPH_JIT_MAX(function()
	LPH_NO_VIRTUALIZE(function()
		AutomaticsTab:NewToggle("Auto Captain", {
		Default = false,
		Callback = function(value)
		autocapon = value
		end,
	})
	end)()
	end)()

	finishLine:GetPropertyChangedSignal("CFrame"):Connect(function()
		if autocapon and not isCatching and finishLine.Position.Y > 0 then
			for i = 1,7,1 do
				task.wait(0.2)
				player.Character.HumanoidRootPart.CFrame = finishLine.CFrame + Vector3.new(0, 2, 0)
			end
		end
	end)


	local function bHead()

	
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player ~= game:GetService("Players").LocalPlayer then
				local Character = player.Character
				if Character and Character:FindFirstChild("Head") then
					local head = Character:FindFirstChild("Head")
					if Headresizeon then
					head.Size = Vector3.new(resizedheads, resizedheads, resizedheads)
					head.Transparency = Headresizeon and headtransparency or 0
					else
						head.Size = Vector3.new(2, 1, 1)
						head.Transparency = 1
					end
				end
			end
		end
	end
	
	task.spawn(function()
		while task.wait() do
			bHead()
		end
	end)

	AutomaticsTab:NewSection("OnCharacterAutomatics")


LPH_JIT_MAX(function()
LPH_NO_VIRTUALIZE(function()
	AutomaticsTab:NewToggle("Auto Boost Off Player", {
	Default = false,
	Callback = function(value)
		autobooston = value
	end,
})


AutomaticsTab:NewSlider("Auto Boost Power", {
		Default = 0,
		Max     = 20,
		Min     = 1,
		Callback = function(value)
			autoboostpower = value
		end,
	})
end)()
end)()




PhysicsTab:NewSection("Blocking")



local function getBlockPart()
    return Character:FindFirstChild("BlockPart")
end


PhysicsTab:NewToggle("Block Reach", {
    Default = false,
    Callback = function(value)
        blockreachon = value
    end,
})

PhysicsTab:NewSlider("Block Distance", {
    Default = 0,
    Max     = 20,
    Min     = 1,
    Callback = function(value)
        customblockreach = value
    end,
})

PhysicsTab:NewSlider("Transparency", {
    Default = 1,
    Max     = 1,
    Min     = 0,
    Callback = function(value)
        blocktransparency = value
    end,
})
--local humanoid
PhysicsTab:NewToggle("Anti Block", {
    Default = false,
    Callback = function(value)
        antiblockon = value
    end,
})
local Torso = Character and Character:FindFirstChild("Torso")

local function DestroyBlockEvent()
	if antiblockon then
	local ffmover = Torso and Torso:FindFirstChild("FFmover")
	if ffmover then
		ffmover:Destroy()
	end
end
end
task.spawn(function()
	while task.wait() do
	DestroyBlockEvent()
	end
end)


local function updateBlockPart()
    local blockPart = getBlockPart()
    if blockPart then
        if blockreachon then
            blockPart.Size = Vector3.new(customblockreach, customblockreach, customblockreach)
            blockPart.Transparency = blocktransparency
        else
            blockPart.Size = Vector3.new(0.75, 5, 1.5)
			blockPart.Transparency = 1
        end
    end
end


task.spawn(function()
    while task.wait() do
        updateBlockPart()
    end
end)


PhysicsTab:NewSection("Teleportation")

repeat wait() until game:IsLoaded()




local function teleportForward()
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	if rootPart then
		local forwardVector = rootPart.CFrame.LookVector
		local newPosition = rootPart.Position + forwardVector * teleportDistance
		rootPart.CFrame = CFrame.new(newPosition, newPosition + forwardVector)
		
	else
		print("Root part not found")
	end

end


local function onKeyPress(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.F and not gameProcessedEvent then
	
		if teleportEnabled then
			teleportForward()
		end
	
	end
end

userInputService.InputBegan:Connect(onKeyPress)


LPH_NO_VIRTUALIZE(function()
PhysicsTab:NewToggle("Quick Teleportation (F)", {
	Default = false,
	Callback = function(value)
		teleportEnabled = value

		if teleportEnabled then
	if isPlayerOnMobile() then
		   local ScreenGui = Instance.new("ScreenGui")
		   local TextButton = Instance.new("TextButton")
		   local UICorner = Instance.new("UICorner")

		   ScreenGui.Parent = player:WaitForChild("PlayerGui")
		   ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		   TextButton.Parent = ScreenGui
		   TextButton.BackgroundColor3 = Color3.new(0.0588,0.0588,0.0588)
		   TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		   TextButton.BorderSizePixel = 0
		   TextButton.Position = UDim2.new(0.47683534, 0, 0.461152881, 0)
		   TextButton.Size = UDim2.new(0, 65, 0, 62)
		   TextButton.Font = Enum.Font.SourceSans
		   TextButton.Text = "TP"
		   TextButton.TextColor3 = Color3.new(0.8314,0.8314,0.8314)
		   TextButton.TextSize = 17.000

		   UICorner.Parent = TextButton

		 
		   local function dragify(button)
			   local dragging, dragInput, dragStart, startPos

			   local function update(input)
				   local delta = input.Position - dragStart
				   button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			   end

			   button.InputBegan:Connect(function(input)
				   if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					   dragging = true
					   dragStart = input.Position
					   startPos = button.Position

					   input.Changed:Connect(function()
						   if input.UserInputState == Enum.UserInputState.End then
							   dragging = false
						   end
					   end)
				   end
			   end)

			   button.InputChanged:Connect(function(input)
				   if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					   dragInput = input
				   end
			   end)

			   userInputService.InputChanged:Connect(function(input)
				   if dragging and input == dragInput then
					   update(input)
				   end
			   end)
		   end

		   dragify(TextButton)


			TextButton.MouseButton1Click:Connect(teleportForward)
		else

			local existingGui = player.PlayerGui:FindFirstChild("ScreenGui")
			if existingGui then
				existingGui:Destroy()
			end
		end
	end
	end,
})
end)()

LPH_NO_VIRTUALIZE(function()
PhysicsTab:NewSlider("Foward Range", {
	Default  = 0,
	Max      = 5,
	Min      = 0,
	Callback = function(value)
		teleportDistance = value
	end,
})
end)()
local connection
LPH_NO_VIRTUALIZE(function()
	PhysicsTab:NewToggle("Click Tackle Teleportation", {
		Default = false,
		Callback = function(v)
			if v then
				connection = game:GetService("Players").LocalPlayer:GetMouse().Button1Down:Connect(function()
					for i, v in pairs(game.workspace:GetDescendants()) do
						if v.Name == "Football" and v:IsA("Tool") then
							local toolPosition = v.Parent.HumanoidRootPart.Position
							local playerPosition = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
							if (toolPosition - playerPosition).Magnitude <= tprange then
								game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.HumanoidRootPart.CFrame + Vector3.new(1, 1, 1)
							end
						end
					end
				end)
			else
				if connection then
					connection:Disconnect() 
				end
			end
		end,
	})
	end)()
	


	LPH_NO_VIRTUALIZE(function()
	PhysicsTab:NewSlider("Teleport Range", {
		Default  = 0,
		Max      = 15,
		Min      = 0,
		Callback = function(v)
			tprange = v
		end,
	})
	end)()
	
	

local function setupCharacter()
	

end


Player.CharacterAdded:Connect(setupCharacter)


setupCharacter()




PhysicsTab:NewSection("Physics Innovator")



LPH_NO_VIRTUALIZE(function()
	PhysicsTab:NewToggle("Resize Heads", {
		Default = false,
		Callback = function(value)
			Headresizeon = value
		end,
	})
	end)()
	


	LPH_NO_VIRTUALIZE(function()
	PhysicsTab:NewSlider("Custom Size", {
		Default  = 0,
		Max      = 6,
		Min      = 0,
		Callback = function(value)
			resizedheads = value
		end,
	})
	end)()

	LPH_NO_VIRTUALIZE(function()
		PhysicsTab:NewSlider("Transparency", {
			Default  = 1,
			Max      = 1,
			Min      = 0,
			Callback = function(value)
				headtransparency = value
			end,
		})
		end)()	

	local function bHead()

	
		for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
			if player ~= game:GetService("Players").LocalPlayer then
				local Character = player.Character
				if Character and Character:FindFirstChild("Head") then
					local head = Character:FindFirstChild("Head")
					if Headresizeon then
					head.Size = Vector3.new(resizedheads, resizedheads, resizedheads)
					head.Transparency = Headresizeon and headtransparency or 0
					else
						head.Size = Vector3.new(2, 1, 1)
						head.Transparency = 1
					end
				end
			end
		end
	end
	
	task.spawn(function()
		while task.wait() do
			bHead()
		end
	end)



    LPH_NO_VIRTUALIZE(function()
        local boostfps = false
        local originalMaterials = {}
        
        MiscTab:NewToggle("FPS BOOST/LOW GRAPHICS", {
            Default = false,
            Callback = function(Value)
                boostfps = Value
                if Value then
                    for i, v in next, workspace:GetDescendants() do
                        if v:IsA("Part") and v.Material then
                            originalMaterials[v] = v.Material
                            v.Material = Enum.Material.SmoothPlastic
                        end
                    end
                else
                    for i, v in next, workspace:GetDescendants() do
                        if v:IsA("Part") and originalMaterials[v] then
                            v.Material = originalMaterials[v]
                            originalMaterials[v] = nil
                        end
                    end
                end
            end,
        })
        end)()
  
        
        
local predictionColor = Color3.fromRGB(64, 9, 150)
local eventConnection





FootballLandingPredictions = true

	local function beamProjectile(g, v0, x0, t1, segments)
		local dt = t1 / segments
		local points = {}
	
		for i = 0, segments do
			local t = i * dt
			local p = 0.5 * g * t * t + v0 * t + x0
			table.insert(points, p)
		end
	
		return points
	end
	
	local function createBeam(points)
		for i = 1, #points - 1 do
			local a0 = Instance.new("Attachment")
			local a1 = Instance.new("Attachment")
			a0.Position = points[i]
			a1.Position = points[i + 1]
	
			local beam = Instance.new("Beam")
			beam.Color = ColorSequence.new(predictionColor)
			beam.Transparency = NumberSequence.new(0, 0)
			beam.Segments = 10
			beam.Attachment0 = a0
			beam.Attachment1 = a1
			beam.Parent = workspace.Terrain
			a0.Parent = workspace.Terrain
			a1.Parent = workspace.Terrain
	
			task.delay(7, function()
				beam.Enabled = false
				beam:Destroy()
			end)
		end
	end



VisualsTab:NewSection("BallVisualisions")
VisualsTab:NewToggle("Visualize Ball Predictions", {
    Default  = false,
    Callback = function(value)

		FootballLandingPredictions = value
		if FootballLandingPredictions then
			if eventConnection then
				eventConnection:Disconnect()
			end

			eventConnection = workspace.ChildAdded:Connect(function(b)
				if b.Name == "Football" and b:IsA("BasePart") then
					task.wait()
					local vel = b.Velocity
					local pos = b.Position
					local points = beamProjectile(Vector3.new(0, -28, 0), vel, pos, 10, 100)
					createBeam(points)
				end
			end)
		elseif eventConnection then
			eventConnection:Disconnect()
			eventConnection = nil
		end

    end,
})





local main = game:GetService("CoreGui"):WaitForChild("LightingUI").MainFrame

UIS.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessedEvent then
		if main then
			main.Visible = not main.Visible
		end
	end
end)




if isPlayerOnMobile() then
    local ImageButton = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
	
    local screenGui = game:GetService("CoreGui"):FindFirstChild("Namessclal")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Namessclal"
        screenGui.Parent = game:GetService("CoreGui")
    end

    ImageButton.Parent = screenGui
    ImageButton.BackgroundColor3 = Color3.new(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0.654, 0, 0.371, 0)
    ImageButton.Size = UDim2.new(0, 43, 0, 42)
    ImageButton.Image = "rbxassetid://85204852226269"

    UICorner.Parent = ImageButton
	CreateDrag(ImageButton)

    ImageButton.MouseButton1Click:Connect(function()
        if main then
            main.Visible = not main.Visible
        end
    end)
end


--65 features here





local au = game:GetService("Players")
local av = game:GetService("Players").LocalPlayer:GetMouse()
FLYING = false
iyflyspeed = 0.25
vehicleflyspeed = 0.25

local CFrameSpeedCallbackFly = false
local CFrameSpeedValueFly = 0
function sFLY(aw)
    repeat
        wait()
    until au.LocalPlayer and au.LocalPlayer.Character and au.LocalPlayer.Character.HumanoidRootPart and
        au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat
        wait()
    until av
    if flyKeyDown or flyKeyUp then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
    end
    local ax = au.LocalPlayer.Character.HumanoidRootPart
    local ay = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local az = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local aA = 0
    local function aB()
        FLYING = true
        local aC = Instance.new("BodyGyro")
        local aD = Instance.new("BodyVelocity")
        aC.P = 9e4
        aC.Parent = ax
        aD.Parent = ax
        aC.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        aC.cframe = ax.CFrame
        aD.velocity = Vector3.new(0, 0, 0)
        aD.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(
            function()
                repeat
                    wait()
                    if not aw and au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
                    end
                    if ay.L + ay.R ~= 0 or ay.F + ay.B ~= 0 or ay.Q + ay.E ~= 0 then
                        aA = 50
                    elseif not (ay.L + ay.R ~= 0 or ay.F + ay.B ~= 0 or ay.Q + ay.E ~= 0) and aA ~= 0 then
                        aA = 0
                    end
                    if ay.L + ay.R ~= 0 or ay.F + ay.B ~= 0 or ay.Q + ay.E ~= 0 then
                        aD.velocity =
                            (workspace.CurrentCamera.CoordinateFrame.lookVector * (ay.F + ay.B) +
                            workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(ay.L + ay.R, (ay.F + ay.B + ay.Q + ay.E) * 0.2, 0).p -
                            workspace.CurrentCamera.CoordinateFrame.p) *
                            aA
                        az = {F = ay.F, B = ay.B, L = ay.L, R = ay.R}
                    elseif ay.L + ay.R == 0 and ay.F + ay.B == 0 and ay.Q + ay.E == 0 and aA ~= 0 then
                        aD.velocity =
                            (workspace.CurrentCamera.CoordinateFrame.lookVector * (az.F + az.B) +
                            workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(az.L + az.R, (az.F + az.B + ay.Q + ay.E) * 0.2, 0).p -
                            workspace.CurrentCamera.CoordinateFrame.p) *
                            aA
                    else
                        aD.velocity = Vector3.new(0, 0, 0)
                    end
                    aC.cframe = workspace.CurrentCamera.CoordinateFrame
                until not FLYING
                ay = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
                az = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
                aA = 0
                aC:Destroy()
                aD:Destroy()
                if au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
                end
            end
        )
    end
	--wait time
    flyKeyDown =
        av.KeyDown:Connect(
        function(aE)
            if aE:lower() == "w" then
                ay.F = aw and vehicleflyspeed or iyflyspeed
            elseif aE:lower() == "s" then
                ay.B = -(aw and vehicleflyspeed or iyflyspeed)
            elseif aE:lower() == "a" then
                ay.L = -(aw and vehicleflyspeed or iyflyspeed)
            elseif aE:lower() == "d" then
                ay.R = aw and vehicleflyspeed or iyflyspeed
            elseif QEfly and aE:lower() == "e" then
                ay.Q = (aw and vehicleflyspeed or iyflyspeed) * 2
            elseif QEfly and aE:lower() == "q" then
                ay.E = -(aw and vehicleflyspeed or iyflyspeed) * 2
            end
            pcall(
                function()
                    workspace.CurrentCamera.CameraType = Enum.CameraType.Track
                end
            )
        end
    )
    flyKeyUp =
        av.KeyUp:Connect(
        function(aE)
            if aE:lower() == "w" then
                ay.F = 0
            elseif aE:lower() == "s" then
                ay.B = 0
            elseif aE:lower() == "a" then
                ay.L = 0
            elseif aE:lower() == "d" then
                ay.R = 0
            elseif aE:lower() == "e" then
                ay.Q = 0
            elseif aE:lower() == "q" then
                ay.E = 0
            end
        end
    )
    aB()
end
function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then
        flyKeyDown:Disconnect()
        flyKeyUp:Disconnect()
    end
    if au.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        au.LocalPlayer.Character.Humanoid.PlatformStand = false
    end
    pcall(
        function()
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    )
end







MiscTab:NewSection("Cframe Adjusted Fly")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")



MiscTab:NewToggle("Enable Fly", {
	Default = false,
	Callback = function(m)
        if m then 
            sFLY()
            while m do
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame + game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * CFrameSpeedValueFly
				wait(0.01)
            end
        else
			CFrameSpeedValueFly = 0
            NOFLY()
            wait()
            NOFLY()
        end
    end
})







MiscTab:NewToggle("Custom Fly Cframe Speed", {
	Default = false,
	Callback = function(Value)
        CFrameSpeedCallback = Value
    end
})

task.spawn(function()
    while task.wait() do
        if CFrameSpeedCallback then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame + game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * CFrameSpeedValue
        end
    end
end)

MiscTab:NewSlider("Ajust Fly Cframe", {
	Default  = 0,
	Max      = 0.45,
	Min      = 0,
	Callback = function(Value)
        CFrameSpeedValue = Value
    end,
})




local function jump()
    local character = LocalPlayer.Character
    if character then
        
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            canJump = false  
            if jumpCooldownEnabled then
                wait(jumpCooldownOn)  
            else
                wait(jumpCooldownOff)
            end
            canJump = true  
        end
    end
end

local function jump()
    local character = LocalPlayer.Character 
    if character then
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            canJump = false  
            if jumpCooldownEnabled then
                wait(jumpCooldownOn)  
            else
                wait(jumpCooldownOff)
            end
            canJump = true  
        end
    end
end

local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.Space and canJump then
        jump()
    end
end

local function toggleJumpCooldown(enabled)
    jumpCooldownEnabled = enabled 
end

local function jump()
    local character = LocalPlayer.Character 
    if character then
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            canJump = false  
            if jumpCooldownEnabled then
                wait(jumpCooldownOn)  
            else
                wait(jumpCooldownOff)
            end
            canJump = true  
        end
    end
end

local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.Space and canJump then
        jump()
    end
end

local function toggleJumpCooldown(enabled)
    jumpCooldownEnabled = enabled
end
PhysicsTab:NewSection("Change Jump delay")

PhysicsTab:NewToggle("Velocity Jump", {
	Default = false,
	Callback = function(v)
        toggleJumpCooldown(v)  
    end
})

PhysicsTab:NewSlider("Velocity Time Adjust", {
	Default  = 0.505,
	Max      = 2,
	Min      = 0,
	Callback = function(Value)
        jumpCooldownOn = Value
    end,
})

PhysicsTab:NewSlider("Jump Wait Adjust", {
	Default  = 3.3,
	Max      = 5,
	Min      = 0,
	Callback = function(Value)
        jumpCooldownOff = Value
    end,
})



local undergroundPartHeight = 0.001 -- Default height
MiscTab:NewSection("Troll Your Dookie Servers")

local function toggleState(v)
    local state = v
    local transparency = state and 0.5 or 0
    local model = game:GetService("Workspace").Models.Field.Grass
    
    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
            part.Transparency = transparency
        end
    end
    
    local existingPart = game.Workspace:FindFirstChild("UndergroundPart")
    
    if state then
        if not existingPart then
            local part = Instance.new("Part")
            part.Name = "UndergroundPart"
            part.Size = Vector3.new(500, undergroundPartHeight, 500)
            part.CFrame = CFrame.new(Vector3.new(10.3562937, -1.51527438, 30.4708614))
            part.Anchored = true
            part.Parent = game.Workspace
        else
            existingPart.Size = Vector3.new(500, undergroundPartHeight, 500)
        end
        
        local Anim = Instance.new("Animation")
        Anim.AnimationId = "rbxassetid://" -- Add your animation ID here
        local track = game:GetService("Players").LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
        track:Play(0.1, 1, 1)
    else
        if track ~= nil then
            track:Stop()
        end
        if existingPart then
            existingPart:Destroy()
        end
    end
end

TrollingTab:NewToggle("Go Underground", {
    Default = false,
    Callback = function(v)
        toggleState(v)
    end
})

TrollingTab:NewSlider("Underground Part Height", {
    Default = 0.001,
    Max     = 10,
    Min     = 0,
    Callback = function(value)
        undergroundPartHeight = value
        local part = game.Workspace:FindFirstChild("UndergroundPart")
        if part then
            part.Size = Vector3.new(500, undergroundPartHeight, 500)
        end
    end
})


getgenv().deleteBoundariesEnabled = false

local function deleteBoundaries()
    local models = game.Workspace:FindFirstChild("Models")

    if not models then
        warn("you probably deleted it nigga")
        return
    end

    for _, item in pairs(models:GetChildren()) do
        if item.Name == "Boundaries" then
            item:Destroy()
        end
    end
end

local function monitorDeletionToggle()
    while true do
        if getgenv().deleteBoundariesEnabled then
            deleteBoundaries()
        end
        task.wait(1)
    end
end

MiscTab:NewToggle("No Qb Boundaries", {
    Default = false,
    Callback = function(value)
        getgenv().deleteBoundariesEnabled = value
        if value then
            task.spawn(monitorDeletionToggle)
        end
    end
})

TrollingTab:NewToggle("Anti Out Of Bounds.", {
    Default = false,
    Callback = function(value)
        getgenv().deleteBoundariesEnabled = value
        if value then
            task.spawn(monitorDeletionToggle)
        end
    end
})

local TeleportOffset = Vector3.new(0, 3, 0)
local MinDistanceThreshold = 10

local function findNearestPlayer()
    local player = Players.LocalPlayer
    local minDistance = math.huge
    local nearestPlayer = nil

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < minDistance then
                minDistance = distance
                nearestPlayer = otherPlayer
            end
        end
    end

    return nearestPlayer, minDistance
end

local function teleportToNearestPlayerHead()
    local player = Players.LocalPlayer -- ⚠️ Warning: 'player' is already defined exactly the same.
    local nearestPlayer, minDistance = findNearestPlayer()

    if nearestPlayer and minDistance <= MinDistanceThreshold then
        local targetHeadPosition = nearestPlayer.Character.Head.Position
        local humanoidRootPart = player.Character.HumanoidRootPart

        humanoidRootPart.CFrame = CFrame.new(targetHeadPosition + TeleportOffset)
    end
end

TrollingTab:NewSection("Player Adjustments")


TrollingTab:NewToggle("Loop Headstand Nearest.", {
    Default = false,
    Callback = function(enabled)
        isTeleporting = enabled
        if isTeleporting then
            while isTeleporting do
                teleportToNearestPlayerHead()
                wait(0.1)
            end
        end
    end
})

TrollingTab:NewSlider("Distance For Loop Headstand", {
    Default = 0,
    Max     = 40,
    Min     = 0,
    Callback = function(value)
        MinDistanceThreshold = value
    end
})

local delaytimez = 0.1

TrollingTab:NewSlider("Headstand Delay Adjustment 1/s", {
    Default = 0.1,
    Max     = 5,
    Min     = 0,
    Callback = function(value)
        delaytimez = value
    end
})

task.spawn(function()
    while true do
        if isTeleporting then
            teleportToNearestPlayerHead()
        end
        wait(delaytimez)
    end
end)


TrollingTab:NewSlider("Adjust Gravity", {
    Default = 196.2,
    Max     = 196.2,
    Min     = 0,
    Callback = function(value)
        game.Workspace.Gravity = value
    end
})
--freeze
TrollingTab:NewSlider("Hip Height", {
    Default = 0,
    Max     = 10,
    Min     = 0,
    Callback = function(value)
    _G.HipHeightValue = value
    if getgenv().EnableHipHeight then
        game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = value
    end
end
})

MiscTab:NewSection("Server Inequalities")


MiscTab:NewToggle("Rejoin Server", {
    Default = false,
    Callback = function(enabled)
        if enabled then
            local player = game:GetService("Players").LocalPlayer
            if player then
                wait(1)
                player:Kick("Rejoining server...")
                wait(1)
                game:GetService("TeleportService"):Teleport(game.PlaceId, player)
            end
        end
    end
})

local function serverHop()
    local teleportService = game:GetService("TeleportService")
    local player = game:GetService("Players").LocalPlayer
    local placeId = game.PlaceId

    teleportService:Teleport(placeId, player)
end
--65
MiscTab:NewToggle("Server Hop", {
    Default = false,
    Callback = function(enabled)
        if enabled then
            print("Server hopping...")
            serverHop()
        else
            print("Server hop disabled")
        end
    end
})


VisualsTab:NewToggle("Estimated Jump Locations", {
    Default = false,
    Callback = function(v)
	if v then
		local player = game.Players.LocalPlayer

		local function handleBall(ball)
			if ball.Name == "Football" and ball:IsA("BasePart") then
				local v0 = ball.Velocity
				local x0 = ball.Position
				local dt = 1/30
				local grav = Vector3.new(0, -28, 0)
				local points = { x0 }
				local function check(p, v0)
					local raycastParams = RaycastParams.new()
					raycastParams.RespectCanCollide = true
					local ray = workspace:Raycast(p, Vector3.new(0, -1000, 0), raycastParams)
					local ray2 = workspace:Raycast(p, Vector3.new(0, -7.2 * 2, 0), raycastParams)
					return ray and not ray2
				end
				while true do
					if not check(points[#points], v0) then
						if v0.Y < 0 then
							break
						end
					end
					local currentPoint = points[#points]
					v0 += grav * dt
					points[#points + 1] = currentPoint + (v0 * dt)
				end
				local optimal = points[#points]

				local model = Instance.new("Model")
				model.Name = "EstimatedJumpLocation"

				local function createPart(name, size, position, parent)
					local part = Instance.new("Part")
					part.Name = name
					part.Anchored = true
					part.CanCollide = false
					part.Size = size
					part.Position = position
					part.Transparency = 0.5
					part.Parent = parent
					return part
				end

				local rootPart = createPart("HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(optimal.X, player.Character.HumanoidRootPart.Position.Y + 1.5, optimal.Z), model)
				local head = createPart("Head", Vector3.new(2, 1, 1), rootPart.Position + Vector3.new(0, 3, 0), model)
				local torso = createPart("Torso", Vector3.new(2, 2, 1), rootPart.Position + Vector3.new(0, 1, 0), model)
				local leftArm = createPart("Left Arm", Vector3.new(1, 2, 1), torso.Position + Vector3.new(-1.5, 2, 0), model)
				local rightArm = createPart("Right Arm", Vector3.new(1, 2, 1), torso.Position + Vector3.new(1.5, 2, 0), model)
				local leftLeg = createPart("Left Leg", Vector3.new(1, 2, 1), rootPart.Position + Vector3.new(-0.5, -1.5, 0), model)
				local rightLeg = createPart("Right Leg", Vector3.new(1, 2, 1), rootPart.Position + Vector3.new(0.5, -1.5, 0), model)

				local humanoid = Instance.new("Humanoid")
				humanoid.Parent = model

				model.Parent = workspace

				repeat task.wait() until ball.Parent ~= workspace
				model:Destroy()
			end
		end

		local function handleChildAdded(ball)
			task.wait()
			handleBall(ball)
		end

		eventConnectionJump = workspace.ChildAdded:Connect(handleChildAdded)
	else
		if eventConnectionJump then
			eventConnectionJump:Disconnect()
			eventConnectionJump = nil
		end
	end
end
})



VisualsTab:NewToggle("Estimated Dive Locations", {
    Default = false,
    Callback = function(v)
	if v then
		local player = game.Players.LocalPlayer -- ⚠️ Warning: 'player' is already defined exactly the same.

		local function handleBall(ball)
			if ball.Name == "Football" and ball:IsA("BasePart") then
				local v0 = ball.Velocity -- ⚠️ Warning: 'v0' is already defined exactly the same.
				local x0 = ball.Position -- ⚠️ Warning: 'x0' is already defined exactly the same.
				local dt = 1/30 -- ⚠️ Warning: 'dt' is already defined exactly the same.
				local grav = Vector3.new(0, -28, 0) -- ⚠️ Warning: 'grav' is already defined exactly the same.
				local points = { x0 } -- ⚠️ Warning: 'points' is already defined exactly the same.
				local function check(p, v0)
					local raycastParams = RaycastParams.new() -- ⚠️ Warning: 'raycastParams' is already defined exactly the same.
					raycastParams.RespectCanCollide = true
					local ray = workspace:Raycast(p, Vector3.new(0, -1000, 0), raycastParams) -- ⚠️ Warning: 'ray' is already defined exactly the same.
					local ray2 = workspace:Raycast(p, Vector3.new(0, -7.2 * 2, 0), raycastParams) -- ⚠️ Warning: 'ray2' is already defined exactly the same.
					return ray and not ray2
				end
				while true do
					if not check(points[#points], v0) then
						if v0.Y < 0 then
							break
						end
					end
					local currentPoint = points[#points]
					v0 += grav * dt
					points[#points + 1] = currentPoint + (v0 * dt)
				end
				local optimal = points[#points]

				local function createPart(name, size, position, transparency, parent, orientation)
					local part = Instance.new("Part")
					part.Name = name
					part.Anchored = true
					part.CanCollide = false
					part.Size = size
					part.Position = position
					part.Transparency = transparency
					part.Orientation = orientation or Vector3.new(0, 0, 0)
					part.Parent = parent
					return part
				end

				local function createDivingCharacter(position, transparency)
					local model = Instance.new("Model")
					model.Name = "DivingCharacter"

					local rootPart = createPart("HumanoidRootPart", Vector3.new(2, 2, 1), position, transparency, model)
					local head = createPart("Head", Vector3.new(2, 1, 1), rootPart.Position + Vector3.new(0, 1.5, 0), transparency, model)
					local torso = createPart("Torso", Vector3.new(2, 2, 1), rootPart.Position + Vector3.new(0, 0.5, 0), transparency, model, Vector3.new(-120, 0, 0)) -- Rotate torso further forward

					local leftArm = createPart("Left Arm", Vector3.new(1, 2, 1), torso.Position + Vector3.new(-1.5, 1.5, 0), transparency, model, Vector3.new(90, 0, -30)) -- Arms up
					local rightArm = createPart("Right Arm", Vector3.new(1, 2, 1), torso.Position + Vector3.new(1.5, 1.5, 0), transparency, model, Vector3.new(90, 0, 30)) -- Arms up

					local leftLeg = createPart("Left Leg", Vector3.new(1, 2, 1), rootPart.Position + Vector3.new(-0.5, -1.5, -1), transparency, model, Vector3.new(60, 0, 0)) -- Legs tilted backward
					local rightLeg = createPart("Right Leg", Vector3.new(1, 2, 1), rootPart.Position + Vector3.new(0.5, -1.5, -1), transparency, model, Vector3.new(60, 0, 0)) -- Legs tilted backward

					local humanoid = Instance.new("Humanoid")
					humanoid.Parent = model

					model.Parent = workspace
					return model
				end

				local divePosition = Vector3.new(optimal.X, player.Character.HumanoidRootPart.Position.Y + 1, optimal.Z - 16.5)
				local divingCharacter = createDivingCharacter(divePosition, 0.7)

				repeat task.wait() until ball.Parent ~= workspace
				divingCharacter:Destroy()
			end
		end

		local function handleChildAdded(ball)
			task.wait()
			handleBall(ball)
		end

		eventConnectionDive = workspace.ChildAdded:Connect(handleChildAdded)
	else
		if eventConnectionDive then
			eventConnectionDive:Disconnect()
			eventConnectionDive = nil
		end
	end
end
})

local function updateCollisionState()
    while true do
        if isAntiJamEnabled then
            local localPlayer = game:GetService("Players").LocalPlayer
            local character = localPlayer.Character
            if character and character:FindFirstChild("Head") and character.Head.CanCollide then
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        pcall(function()
                            player.Character.Torso.CanCollide = false
                            player.Character.Head.CanCollide = false
                        end)
                    end
                end
            end
        else
            local localPlayer = game:GetService("Players").LocalPlayer -- ⚠️ Warning: 'localPlayer' is already defined exactly the same.
            local character = localPlayer.Character -- ⚠️ Warning: 'character' is already defined exactly the same.
            if character and character:FindFirstChild("Head") and not character.Head.CanCollide then
                character.Torso.CanCollide = true
                character.Head.CanCollide = true
            end
        end
        task.wait()
    end
end

MiscTab:NewToggle("Disable Character Collisions", {
    Default = false,
    Callback = function(v)
        isAntiJamEnabled = v
    end,
})

spawn(updateCollisionState)



local player = Players.LocalPlayer
local infiniteJumpConnection
local humanoid

local function enableInfiniteJump()
    if not infiniteJumpConnection then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if humanoid and humanoid.Parent then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

local function disableInfiniteJump()
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
end

local function onCharacterAdded(character)
    humanoid = character:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    onCharacterAdded(player.Character)
end

PlayerTab:NewToggle("Infinite Jump", {
    Default = false,
    Callback = function(v)
        if v then
            enableInfiniteJump()
        else
            disableInfiniteJump()
        end
    end
})

local UserInputService = game:GetService("UserInputService")


getgenv().ToggleSettings = {
    TeleportEnabled = false,
    TeleportRange = 2,
}

local function teleportForward()
    local player = Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local forwardDirection = rootPart.CFrame.LookVector
        rootPart.CFrame = rootPart.CFrame + forwardDirection * getgenv().ToggleSettings.TeleportRange
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end 

    if input.KeyCode == Enum.KeyCode.E and getgenv().ToggleSettings.TeleportEnabled then
        teleportForward()
    end
end)

PlayerTab:NewToggle("Dive Enhancer", {
    Default = false,
    Callback = function(enabled)
        getgenv().ToggleSettings.TeleportEnabled = enabled
        print("Teleport Enabled:", enabled) 
    end
})

TrollingTab:NewSlider("Adjust Dive Strength", {
    Default = 2,
    Max     = 4,
    Min     = 0,
    Callback = function(range)
        getgenv().ToggleSettings.TeleportRange = range
        print("Teleport Range Set To:", range) 
    end
})




				local AngleEnhancer = {
					Physics = {
						AngleEnhancer = true,
						NormalJumpPower = 40,
						BoostedJumpPower = 50,
					},
					ShiftBoostDuration = 1,
				}
				
				
				
				
				local boostActive = false
				
				local function isShiftPressed()
					return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
				end
				
				local function onCharacterMovement(character)
					local humanoid = character:WaitForChild("Humanoid")
					local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
				
					humanoid.StateChanged:Connect(function(_, newState)
						if newState == Enum.HumanoidStateType.Jumping and AngleEnhancer.Physics.AngleEnhancer then
							task.wait(0.05)
							if boostActive then
								local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
								humanoidRootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, AngleEnhancer.Physics.BoostedJumpPower, currentVelocity.Z)
							else
								local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
								humanoidRootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, AngleEnhancer.Physics.NormalJumpPower, currentVelocity.Z)
							end
						end
					end)
				end
				
				local function applyJumpBoost()
					if not boostActive then
						boostActive = true
						local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
						onCharacterMovement(character)
						task.delay(AngleEnhancer.ShiftBoostDuration, function()
							boostActive = false
						end)
					end
				end
				
				local function initializePlayer(player)
					player.CharacterAdded:Connect(function(character)
						onCharacterMovement(character)
					end)
					if player.Character then
						onCharacterMovement(player.Character)
					end
				end
				
				Players.PlayerAdded:Connect(initializePlayer)
				
				for _, player in next, Players:GetPlayers() do
					initializePlayer(player)
				end
				
				game:GetService("RunService").RenderStepped:Connect(function()
					if AngleEnhancer.Physics.AngleEnhancer then
						if isShiftPressed() then
							applyJumpBoost()
						end
					end
				end)
				

				
				PlayerTab:NewToggle("Velocity Angle Enhancer", {
					Default = false,
					Callback = function(enabled)
						AngleEnhancer.Physics.AngleEnhancer = enabled
					end,
					default = AngleEnhancer.Physics.AngleEnhancer
				})
				
				PlayerTab:NewSlider("Boosted Jump Power", {
					Default = 40,
					Max     = 70,
					Min     = 40,
					Callback = function(value)
						AngleEnhancer.Physics.BoostedJumpPower = value
					end
				})


				local autoswatv = 0

				local onsonny = false
				
				local function jumpshit()
					if onsonny then
						local player = game:GetService("Players").LocalPlayer
						local character = player.Character or player.CharacterAdded:Wait()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
						local RunService = game:GetService("RunService")
						
						local function checkDistance(part)
							local distance = (part.Position - humanoidRootPart.Position).Magnitude
							if distance <= autoswatv then
								keypress(0x20)
								keyrelease(0x20)
								task.wait()
							end
						end
						local function updateDistances()
							for _, v in pairs(game.Workspace:GetDescendants()) do
								if v.Name == "Football" and v:IsA("BasePart") then
									checkDistance(v)
								end
							end
						end
						connection = RunService.Heartbeat:Connect(updateDistances)
					else
						if connection then
							connection:Disconnect()
							connection = nil
						end
					end
				end
				
				
				AutomaticsTab:NewToggle("Auto Jump", {
					Default = false,
					Callback = function(v)
					onsonny = v
					jumpshit()
				end})
				
				AutomaticsTab:NewSlider("Distance From Ball", {
					Default = 0,
					Max     = 20,
					Min     = 0,
					Callback = function(v)
					autoswatv = v
				end})
				--auto catc
				
				local autoswatvv = 0
				
				local onsonnys = false

				
				local function jumpshits()
					if onsonnys then
						local player = game:GetService("Players").LocalPlayer
						local character = player.Character or player.CharacterAdded:Wait()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
						local RunService = game:GetService("RunService")
						
						local function checkDistance(part)
							local distance = (part.Position - humanoidRootPart.Position).Magnitude
							if distance <= autoswatvv then
								task.wait(0.1)
								keypress(0x63)
								keyrelease(0x63)
								task.wait()
							end
						end
						local function updateDistances()
							for _, v in pairs(game.Workspace:GetDescendants()) do
								if v.Name == "Football" and v:IsA("BasePart") then
									checkDistance(v)
								end
							end
						end
						connection = RunService.Heartbeat:Connect(updateDistances)
					else
						if connection then
							connection:Disconnect()
							connection = nil
						end
					end
				end
				
				
				AutomaticsTab:NewToggle("Auto Dive", {
					Default = false,
					Callback = function(v)
					onsonnys = v
					jumpshits()
				end})
				
				AutomaticsTab:NewSlider("Distance From Ball", {
					Default = 0,
					Max     = 20,
					Min     = 0,
					Callback = function(v)
					autoswatv = v
				end})

				
				
				
				
				local function jumpshits()
					if onsonnys then
						local player = game:GetService("Players").LocalPlayer
						local character = player.Character or player.CharacterAdded:Wait()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
						local RunService = game:GetService("RunService")
						
						local function checkDistance(part)
							local distance = (part.Position - humanoidRootPart.Position).Magnitude
							if distance <= autoswatvv then
								task.wait(0.1)
								keypress(0x78)
								keyrelease(0x78)
								task.wait()
							end
						end
						local function updateDistances()
							for _, v in pairs(game.Workspace:GetDescendants()) do
								if v.Name == "Football" and v:IsA("BasePart") then
									checkDistance(v)
								end
							end
						end
						connection = RunService.Heartbeat:Connect(updateDistances)
					else
						if connection then
							connection:Disconnect()
							connection = nil
						end
					end
				end
				
				
				AutomaticsTab:NewToggle("Auto Block", {
					Default = false,
					Callback = function(v)
					onsonnys = v
					jumpshits()
				end})
				
				AutomaticsTab:NewSlider("Distance From Ball", {
					Default = 0,
					Max     = 0,
					Min     = 40,
					Callback = function(v)
					autoswatv = v
				end})

				
				
				
				
				local function jumpshits()
					if onsonnys then
						local player = game:GetService("Players").LocalPlayer
						local character = player.Character or player.CharacterAdded:Wait()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
						local RunService = game:GetService("RunService")
						
						local function checkDistance(part)
							local distance = (part.Position - humanoidRootPart.Position).Magnitude
							if distance <= autoswatvv then
								task.wait(0.1)
								keypress(0x63)
								keyrelease(0x63)
								task.wait()
							end
						end
						local function updateDistances()
							for _, v in pairs(game.Workspace:GetDescendants()) do
								if v.Name == "Football" and v:IsA("BasePart") then
									checkDistance(v)
								end
							end
						end
						connection = RunService.Heartbeat:Connect(updateDistances)
					else
						if connection then
							connection:Disconnect()
							connection = nil
						end
					end
				end
				
				
				
				
				local function jumpshits()
					if onsonnys then
						local player = game:GetService("Players").LocalPlayer
						local character = player.Character or player.CharacterAdded:Wait()
						local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
						local RunService = game:GetService("RunService")
						
						local function checkDistance(part)
							local distance = (part.Position - humanoidRootPart.Position).Magnitude
							if distance <= autoswatvv then
								task.wait(0.1)
								keypress(0x63)
								keyrelease(0x63)
								task.wait()
							end
						end
						local function updateDistances()
							for _, v in pairs(game.Workspace:GetDescendants()) do
								if v.Name == "Football" and v:IsA("BasePart") then
									checkDistance(v)
								end
							end
						end
						connection = RunService.Heartbeat:Connect(updateDistances)
					else
						if connection then
							connection:Disconnect()
							connection = nil
						end
					end
				end
				
				
				AutomaticsTab:NewToggle("Auto Catch", {
					Default = false,
					Callback = function(v)
					onsonnys = v
					jumpshits()
				end})
				
				AutomaticsTab:NewSlider("Distance From Ball", {
					Default = 0,
					Max     = 20,
					Min     = 0,
					Callback = function(v)
					autoswatv = v
				end})

				--vector
