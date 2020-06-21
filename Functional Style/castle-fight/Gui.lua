wait()
local LocalPlayer = game.Players.LocalPlayer

local GuiControl = game.ReplicatedStorage.GuiControl

function getResourceDisplay(off)
	local resourceGui = LocalPlayer.PlayerGui:FindFirstChild("Team Resource Leaderboard")
	repeat wait()
		resourceGui = LocalPlayer.PlayerGui:FindFirstChild("Team Resource Leaderboard")
	until resourceGui ~= nil
	if off then resourceGui.Enabled = false return end
	resourceGui.Enabled = true
	local t1 = workspace.Teams["Team 1"]:GetChildren()
	local t2 = workspace.Teams["Team 2"]:GetChildren()
	local playerFrames = LocalPlayer.PlayerGui:FindFirstChild("Team Resource Leaderboard").Container:GetChildren()
	local resourceTag = workspace.Resources
	if workspace.Teams["Team 1"]:FindFirstChild(LocalPlayer.Name) then
		for i=1,2 do
			if t1[i].Name == "Join" then playerFrames[i].Visible = false return end
			if t1[i].Value ~= "" then
				playerFrames[i]:FindFirstChild("Player").Text = t1[i].Name
				if resourceTag:FindFirstChild(t1[i].Name) == nil then print("CHECK 1") print(i) print(t1[i].Name) end
				playerFrames[i]:FindFirstChild("Gold").Text = resourceTag:FindFirstChild(t1[i].Name).Gold.Value
				playerFrames[i]:FindFirstChild("Lumber").Text = resourceTag:FindFirstChild(t1[i].Name).Lumber.Value
 			end 
		end
	else
		for i=1,2 do
			if t2[i].Name == "Join" then playerFrames[i].Visible = false return end
			if t2[i].Value ~= "" then
				playerFrames[i]:FindFirstChild("Player").Text = t2[i].Name
				playerFrames[i]:FindFirstChild("Gold").Text = resourceTag:FindFirstChild(t2[i].Name).Gold.Value
				playerFrames[i]:FindFirstChild("Lumber").Text = resourceTag:FindFirstChild(t2[i].Name).Lumber.Value
			end
		end
	end
end

function getModesDisplay(off)
	--Find modes gui
	local modesGui = LocalPlayer.PlayerGui:FindFirstChild("Modes Leaderboard") or LocalPlayer.PlayerGui:WaitForChild("Modes Leaderboard")
	repeat wait()
		modesGui = LocalPlayer.PlayerGui:FindFirstChild("Modes Leaderboard") or LocalPlayer.PlayerGui:WaitForChild("Modes Leaderboard")
	until modesGui ~= nil
	--Check if turning it off
	if off then modesGui.Enabled = false return end
	--turn it on if not turning off
	modesGui.Enabled = true
	--find modes check boxes
	local randomRaces = modesGui.Container["Random Races"].ImageButton
	local bans = modesGui.Container["Bans"].ImageButton
	local winLimit = modesGui.Container["Win Limit"].Number
	if workspace.Modes["Random Races"].Value == true then
		randomRaces.Image = "rbxassetid://3229284779"
	else
		randomRaces.Image = "rbxassetid://1264515756"
	end
	if workspace.Modes["Bans"].Value == true then
		bans.Image = "rbxassetid://3229284779"
	else
		bans.Image = "rbxassetid://1264515756"
	end
	winLimit.Text = tostring(workspace.Modes["Win Limit"].Value)
end

function getReadiesDisplay(off)
	local readyGui = LocalPlayer.PlayerGui:FindFirstChild("Ready Leaderboard")
	repeat wait()
		readyGui = LocalPlayer.PlayerGui:FindFirstChild("Ready Leaderboard")
	until readyGui ~= nil
	if off then readyGui.Enabled = false return end
	readyGui.Enabled = true
	local guiReadyTable = readyGui.Container:GetChildren()
	local readyTable = workspace["Players Ready"]:GetChildren()
	for i=1,4 do
		if readyTable[i] ~= nil then
			guiReadyTable[i].Player.Text = readyTable[i].Name
			guiReadyTable[i].Visible = true
			if readyTable[i].Value == true then
				guiReadyTable[i].Checkbox.Image = "rbxassetid://3229284779"
			else
				guiReadyTable[i].Checkbox.Image = "rbxassetid://1264515756"
			end
		else guiReadyTable[i].Visible = false end
	end
end

function getTeamsDisplay(off)
	local teamGui = LocalPlayer.PlayerGui:FindFirstChild("Team Select")
	repeat wait()
		teamGui = LocalPlayer.PlayerGui:FindFirstChild("Team Select")
	until teamGui ~= nil
	if off then teamGui.Enabled = false return end
	teamGui.Enabled = true
	local t1Gui = teamGui.Container["T1 Body"]:GetChildren()
	local t2Gui = teamGui.Container["T2 Body"]:GetChildren()
	local t1 = workspace.Teams["Team 1"]:GetChildren()
	local t2 = workspace.Teams["Team 2"]:GetChildren()
	for i=1,2 do
		if #t1 > 0 and t1[i] ~= nil then
			t1Gui[i].Text = t1[i].Name
		else
			t1Gui[i].Text = "Player"
		end
	end
	for i=1,2 do
		if #t2 > 0 and t2[i] ~= nil then
			t2Gui[i].Text = t2[i].Name
		else
			t2Gui[i].Text = "Player"
		end
	end
end

GuiControl.OnClientEvent:Connect(function(cmd)
	if cmd == "Display Resource" then
		getResourceDisplay()
	elseif cmd == "Display Readies" then
		getReadiesDisplay()
	elseif cmd == "Display Modes" then
		getModesDisplay()
	elseif cmd == "Display Teams" then
		getTeamsDisplay()
	elseif cmd == "Undisplay Resource" then
		getResourceDisplay("off")
	elseif cmd == "Undisplay Readies" then
		getReadiesDisplay("off")
	elseif cmd == "Undisplay Modes" then
		getModesDisplay("off")
	elseif cmd == "Undisplay Teams" then
		getTeamsDisplay("off")
	end
end)