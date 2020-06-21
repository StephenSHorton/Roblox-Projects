wait()
--THIS IS THE BARRACKS BUTTON SCRIPT
local player = game:GetService("Players").LocalPlayer
local mainGui = player.PlayerGui:FindFirstChild("MainGui")
local frame = mainGui:FindFirstChild("Frame")
local clickSound = game:GetService("SoundService"):FindFirstChild("Click3")
local buildingPlacementSound = game:GetService("SoundService"):FindFirstChild("BuildingPlacement")
local button = script.Parent
local onOff = mainGui:WaitForChild("onOff")
local onOff2 = true
local mouse = player:GetMouse()
local moveConnection
local leftClickConnection
local clickConnection
local rotateConnection
local shadowHouse
local houseClone
local targetPlacement
local replicatedStorage = game:GetService("ReplicatedStorage")
local buildEvent = replicatedStorage:WaitForChild("BuildEvent")

local function shadowHouseMove()
	local target = mouse.Target
	if target == nil then return end
	if target.Name == "Grid" then
		local test = mouse.Target.Size.Y
		shadowHouse:SetPrimaryPartCFrame(target.CFrame + Vector3.new(-1.5,test-1.25,-1.5))
		targetPlacement = target
		return
	end
	wait()
end

local function rotate()
	shadowHouse:SetPrimaryPartCFrame(shadowHouse:GetPrimaryPartCFrame() * CFrame.Angles(0,1.5705,0))
end

local function buildHouse()
	for i, part in pairs(shadowHouse:GetChildren()) do
		if part:IsA("BasePart") then
			local partTable = part:GetTouchingParts()
			for i, part in pairs(partTable) do
				if part.Name == "TreeGrid" then
					buildEvent:FireServer("Can't Build there: Tree Obstacle")
					return
				end
				if part.Parent.Name == "Building" or part.Parent.Parent.Name == "Building" or part.Parent.Parent.Parent.Name == "Building" then
					buildEvent:FireServer("Can't Build there: Building Obstacle")
					return
				end
				if part.Parent.Name == "GoldMine" or part.Parent.Parent.Name == "GoldMine" or part.Parent.Parent.Parent.Name == "GoldMine" then
					buildEvent:FireServer("Can't Build there: GoldMine Obstacle")
					return
				end
				if part.Parent.Name == "NPC" or part.Parent.Parent.Name == "NPC" or part.Parent.Parent.Parent.Name == "NPC" then
					buildEvent:FireServer("Can't Build there: Unit Obstacle")
					return
				end
			end
		end
	end
	local min = shadowHouse.PrimaryPart.Position + Vector3.new(-15, -3, -15)
	local max = shadowHouse.PrimaryPart.Position + Vector3.new(15, 6, 15)
	local region = Region3.new(min, max)
--	local part = Instance.new("Part", workspace)
--	part.Anchored = true
--	part.CanCollide = false
--	part.Transparency = 0.5
--	part.Size = region.Size
--	part.CFrame = region.CFrame
	local partTable = workspace:FindPartsInRegion3(region,nil,math.huge)
	local canBuildHere = false
	for i, part in pairs(partTable) do
		if part.Parent.Name ~= "ShadowHouse" or part.Parent.Parent.Name ~= "ShadowHouse" or part.Parent.Parent.Parent.Name ~= "ShadowHouse" then
			if part.BrickColor == player.TeamColor then
				canBuildHere = true
				break
			end
		end
	end
	if canBuildHere ~= true then
		buildEvent:FireServer("Can't Build there: Too far from Base")
		return
	end
	onOff2 = true
	clickSound:Play()
	local CFrameSave = shadowHouse.PrimaryPart.CFrame
	shadowHouse:Destroy()
	buildEvent:FireServer("Barracks",CFrameSave)
	buildingPlacementSound:Play()
	clickConnection:Disconnect()
	moveConnection:Disconnect()
	leftClickConnection:Disconnect()
	rotateConnection:Disconnect()
end

button.MouseButton1Click:Connect(function()
	if onOff2 == false then
		return
	else
		onOff2 = false
	end
	clickSound:Play()
	shadowHouse = game.Lighting["Barracks(Neutral)"]:Clone()
	for i,part in pairs(shadowHouse:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 0.4
		end
		if part:IsA("UnionOperation") then
			part.Transparency = 0.4
		end
	end
	shadowHouse.Parent = workspace
	moveConnection = mouse.Move:Connect(shadowHouseMove)
	clickConnection = mouse.Button1Down:Connect(buildHouse)
	rotateConnection = mouse.KeyDown:connect(function(key)
		if key == "r" then
			rotate()
		end
	end)
	leftClickConnection = mouse.Button2Down:Connect(function()
		clickConnection:Disconnect()
		moveConnection:Disconnect()
		rotateConnection:Disconnect()
		leftClickConnection:Disconnect()
		shadowHouse:Destroy()
		shadowHouse = nil
		onOff2 = true
	end)
	button.MouseButton1Down:Connect(function()
		script.Parent.Image = 'rbxassetid://3127408628'
		button.MouseLeave:Connect(function()
			script.Parent.Image = 'rbxassetid://3127408436'
		end)
		button.MouseButton1Up:Connect(function()
			script.Parent.Image = 'rbxassetid://3127408436'
		end)
	end)
end)