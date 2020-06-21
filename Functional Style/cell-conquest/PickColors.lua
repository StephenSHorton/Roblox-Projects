local pickColorsEvent = game:GetService("ReplicatedStorage"):WaitForChild("Pick Colors Event")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local colorGui = PlayerGui:WaitForChild("ColorGui")
local colorGuiFrame = colorGui:WaitForChild("Frame")
local colorFrame = colorGuiFrame:WaitForChild("Color Frame")
local randomBtn = colorGuiFrame:WaitForChild("Random")
local changeBtn = colorGuiFrame:WaitForChild("Change")
local confirmBtn = colorGuiFrame:WaitForChild("Confirm")
local randomBtnAdvisory = colorGui:WaitForChild("Random Button Advisory")
local confirmBtnAdvisory = colorGui:WaitForChild("Confirm Button Advisory")

function pickColor()
	colorGui.Enabled = true
end

local modalActive = false
function generateColorModal()
	local function box(color, x, y)
		local colorsNotAvailable = {}
		table.insert(colorsNotAvailable,BrickColor.new("Institutional white"))
		if table.find(colorsNotAvailable,color) == nil then
			local m = Instance.new("TextButton", colorGui)
			m.Size = UDim2.new(0, 20, 0, 15)
			m.AnchorPoint = Vector2.new(0.5,0.5)
			m.Position = UDim2.new(0.6, x * 20, 0.3, y * 16)
			m.Text = ""
			m.BackgroundColor3 = color.Color
			m.MouseButton1Click:Connect(function()
				colorFrame.BackgroundColor3 = m.BackgroundColor3
				for i,v in ipairs(m.Parent:GetChildren()) do
					if v:IsA("TextButton") then
						v:Destroy()
					end
				end
				modalActive = false
			end)
		end
	end
	
	local i = 0
	local function row(W, y)
		for x = 0, W - 1 do
			local color = BrickColor.palette(i)
			box(color, x - W/2, y)
			i = i + 1
		end
	end
	
	local y = 0
	-- 7, 8, .., 12, 13
	for W = 7, 13 do
		row(W, y)
		y = y + 1
	end
	-- 12, ..., 8, 7
	for W = 12, 7, -1 do
		row(W, y)
		y = y + 1
	end
end

randomBtn.MouseButton1Click:Connect(function()----------------Random Button
	local randomColor
	repeat
		local usedColors = {}
		for i,plr in ipairs(game:GetService("Players"):GetPlayers()) do
			table.insert(usedColors,plr.TeamColor)
		end
		randomColor = BrickColor.random()
	until table.find(usedColors,randomColor) == nil and randomColor ~= BrickColor.new("Institutional white")
	colorFrame.BackgroundColor3 = randomColor.Color
end)
randomBtn.MouseEnter:Connect(function()
	randomBtnAdvisory.Visible = true
end)
randomBtn.MouseLeave:Connect(function()
	randomBtnAdvisory.Visible = false
end)

changeBtn.MouseButton1Click:Connect(function()----------------Change Button
	if modalActive then
		for i,v in ipairs(colorGui:GetChildren()) do
			if v:IsA("TextButton") then
				v:Destroy()
			end
		end
		modalActive = false
	else
		modalActive = true
		generateColorModal()
	end
end)

local msgDebounce = true
confirmBtn.MouseButton1Click:Connect(function()----------------Confirm Button
	--Capture the picked color and send to server for local player's team color to change
	if colorFrame.BackgroundColor3 ~= Color3.fromRGB(248,248,248) then
		pickColorsEvent:FireServer(BrickColor.new(colorFrame.BackgroundColor3))
		colorGui.Enabled = false
		--Delete color modal if it was left open
		for i,v in ipairs(colorGui:GetChildren()) do
			if v:IsA("TextButton") then
				v:Destroy()
			end
		end
		modalActive = false
	else
		--tell player to pick a color (you can't be white, neutral is white)
		if msgDebounce then
			msgDebounce = false
			confirmBtnAdvisory.Visible = true
			spawn(function()
				wait(3)
				confirmBtnAdvisory.Visible = false
				msgDebounce = true
			end)
		end
	end
	
end)

pickColorsEvent.OnClientEvent:Connect(pickColor)