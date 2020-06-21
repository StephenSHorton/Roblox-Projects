local localPlayer = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local buildingClickEvent = replicatedStorage:FindFirstChild("BuildingClickEvent")
local guiEvent = replicatedStorage.GuiEvent
local printGui = localPlayer.PlayerGui:WaitForChild("PrintGui")
local mainGui = localPlayer.PlayerGui:WaitForChild("MainGui")
local resourceGui = localPlayer.PlayerGui:WaitForChild("ResourceGui")
local clickSound = game:GetService("SoundService"):WaitForChild("Click3")

local houseDockOnOff = false
local farmDockOnOff = false
local barracksDockOnOff = false

guiEvent.OnClientEvent:Connect(function(command,what)
	if command == "New Game" then
		printGui.NewGame.TextLabel.Text = what
		printGui.NewGame.Visible = true
		wait(10)
		printGui.NewGame.Visible = false
	elseif command == "initialize" then
		mainGui.Enabled = true
		resourceGui.Enabled = true
	elseif command == "Message" then
		printGui.Message.TextLabel.Text = what
		printGui.Message.Visible = true
		wait(1.5)
		printGui.Message.Visible = false
	end
end)
buildingClickEvent.OnClientEvent:Connect(function(building)
	local houseDock = mainGui:FindFirstChild("HouseDock")
	local farmDock = mainGui:FindFirstChild("FarmDock")
	local barracksDock = mainGui:FindFirstChild("BarracksDock")
	if building == "Lumber House" then
		clickSound:Play()
		if houseDockOnOff == false then
			houseDockOnOff = true
			houseDock:TweenPosition(UDim2.new(1,-347,1,-246),"Out","Quad",1,true)
		elseif houseDockOnOff == true then
			houseDockOnOff = false
			houseDock:TweenPosition(UDim2.new(1,-347,1,0),"Out","Quad",1,true)
		end
	end
	if building == "Farm" then
		clickSound:Play()
		if farmDockOnOff == false then
			farmDockOnOff = true
			farmDock:TweenPosition(UDim2.new(1,-347,1,-246),"Out","Quad",1,true)
		elseif farmDockOnOff == true then
			farmDockOnOff = false
			farmDock:TweenPosition(UDim2.new(1,-347,1,0),"Out","Quad",1,true)
		end
	end
	if building == "Barracks" then
		clickSound:Play()
		if barracksDockOnOff == false then
			barracksDockOnOff = true
			barracksDock:TweenPosition(UDim2.new(1,-347,1,-246),"Out","Quad",1,true)
		elseif barracksDockOnOff == true then
			barracksDockOnOff = false
			barracksDock:TweenPosition(UDim2.new(1,-347,1,0),"Out","Quad",1,true)
		end
	end
end)
