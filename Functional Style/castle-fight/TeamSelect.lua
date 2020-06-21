local GuiControl = game.ReplicatedStorage.GuiControl
local TEAM_SELECT = {}
	function TEAM_SELECT.changeTeam(plr,team)
		local teamChange = workspace.Teams:FindFirstChild(team)
		if teamChange ~= nil and plr ~= nil then
			--clear the players name on his current team
			for i, t in ipairs(workspace.Teams:GetChildren()) do
				for i, playerSlot in ipairs(t:GetChildren()) do
					if playerSlot.Value == plr then
						playerSlot.Value = ""
						playerSlot.Name = "Join"
					end
				end
			end
			--move player name to new team
			for i, playerSlot in ipairs(teamChange:GetChildren()) do
				if playerSlot.Value == "" then
					playerSlot.Value = plr
					playerSlot.Name = plr
					break
				end
			end
			GuiControl:FireAllClients("Display Teams")
		end
	end
	
	function TEAM_SELECT.setupListener()
		GuiControl.OnServerEvent:Connect(function(plr,gui,team)
			if gui == "TEAM_SELECT" then
				print(plr.Name .. " has attempted to move to " .. team)
				TEAM_SELECT.changeTeam(plr.Name,team)
			end
		end)
	end
return TEAM_SELECT
