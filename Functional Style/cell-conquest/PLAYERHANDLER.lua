local pickColorsEvent = game:GetService("ReplicatedStorage"):WaitForChild("Pick Colors Event")
local lobbyTimer = game.Workspace:WaitForChild("Lobby Timer")
local PLAYER_HANDLER = {}
function PLAYER_HANDLER.startLobbyTimer(t)
	local playersInGameAtTimeOfStart
	while wait(1) do
		playersInGameAtTimeOfStart = game:GetService("Players"):GetPlayers()
		if #playersInGameAtTimeOfStart > 0 then
			for i,plr in ipairs(playersInGameAtTimeOfStart) do
				local char = plr.Character or plr.CharacterAdded:wait()
			end
			break
		end
	end
	for i=t,0,-1 do
		lobbyTimer.SurfaceGui.TextLabel.Text = i
		wait(1)
	end
end
function PLAYER_HANDLER.initiateColorPickListener()
	game:GetService("Players").PlayerAdded:Connect(function(plr)
		local charWait = plr.Character or plr.CharacterAdded:wait()
		pickColorsEvent:FireClient(plr)
	end)
	pickColorsEvent.OnServerEvent:Connect(function(plr,color)
		plr.TeamColor = color
		activateCellSelection(plr)
		local charLoad = plr.Character or plr.CharacterAdded:wait()
		local connections = {}
		for x,part in ipairs(charLoad:GetChildren()) do
			if part:IsA("BasePart") then
				local connection = part.Touched:Connect(function(thing)
					if string.sub(thing.Name,1,4) == "Cell" and thing.BrickColor == BrickColor.new("Institutional white") then
						thing.BrickColor = plr.TeamColor
						thing.tColor.Value = plr.TeamColor
						for _,connectino in ipairs(connections) do
							connectino:Disconnect()
						end
					end
				end)
				table.insert(connections,connection)
			end
		end
	end)
end
function activateCellSelection(plr)
	plr.Character["Full Send Baby"].Disabled = false
end
return PLAYER_HANDLER
