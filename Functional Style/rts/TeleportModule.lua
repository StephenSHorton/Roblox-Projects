local teleportModule = {}
	function teleportModule.MoveToTeamSpawns()--MOVE PLAYERS TO RESPECTIVE TEAMS
		local currentMap = workspace:FindFirstChild("Map") --put a variable in here that changes with the map that is currently selected
		local RedTeamSpawn = currentMap:FindFirstChild("RedSpawn") or nil
		local BlueTeamSpawn = currentMap:FindFirstChild("BlueSpawn") or nil
		local players = game:GetService("Players"):GetPlayers()
		for i, player in pairs(players) do
		local char = player.Character or player.CharacterAdded:wait()
			if player.TeamColor == BrickColor.new("Bright red") then
				if RedTeamSpawn ~= nil then
					char:MoveTo(RedTeamSpawn.Position)
				end
			elseif player.TeamColor == BrickColor.new("Bright blue") then
				if BlueTeamSpawn ~= nil then
					char:MoveTo(BlueTeamSpawn.Position)
				end
			end
		end
	end
return teleportModule
