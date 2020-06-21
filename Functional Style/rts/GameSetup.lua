local replicatedStorage = game:GetService("ReplicatedStorage")
local timeEvent = replicatedStorage:FindFirstChild("TimeEvent")
local fogOfWarEvent = replicatedStorage:FindFirstChild("FogOfWarEvent")
local maps = game:GetService("Lighting").Maps:GetChildren()
local mapCounter = {}
for i, thing in pairs(maps) do
	table.insert(mapCounter,thing)
end
local allowSeating = true
local gameSetup = {}
	function gameSetup.timer(x)
		local count = x
		wait(1)
		if count ~= 0 then
			timeEvent:FireAllClients(count)
			count = count -1
			return gameSetup.timer(count)
		else
			timeEvent:FireAllClients(count)
		end
	end
	function gameSetup.removeMap()
		workspace:FindFirstChild("Map"):Destroy()
	end
	function gameSetup.getMap()
		local number = math.random(#mapCounter)
		if number == 0 then
			repeat wait()
				number = math.random(#mapCounter)
			until number ~= 0
		end
		if #mapCounter == 1 then 
			mapCounter = nil
			mapCounter = {}
			for i, thing in pairs(maps) do
				table.insert(mapCounter,thing)
			end
		else
			table.remove(mapCounter, number)
		end
		if mapCounter[number] == nil then
			number = 1
		end
		local mapClone = mapCounter[number]:Clone()
		mapClone.Parent = workspace
		mapClone.MapTexturizer.Disabled = false
		mapClone.Name = "Map"
	end
	function gameSetup.waitForPlayers()--WAITS FOR 2 PLAYERS AND THEN ALLOWS GAME TO START
		while true do
			wait(2)
			local players = game:GetService("Players"):GetPlayers()
			if #players >= 2 then--------------------------------------------------------------------------------CHANGE THIS BACK TO 2
				wait(4)--Wait extra for characters
				break
			else
				print("Waiting for 2 players to start...")
			end
		end
	end
	function gameSetup.grabPlayers(playerList)--MAKES A TABLE OF ALL PLAYERS
		local players = game:GetService("Players"):GetChildren()
		for i, player in pairs(players) do
			local charCheck = player.Character or player.CharacterAdded:wait()
			table.insert(playerList, player)
		end
		return playerList
	end
	function gameSetup.assignTeams(playerList)--CREATES RED AND BLUE TEAMS, DIVIDES PLAYERS INTO THE TWO TEAMS
		local team1 = Instance.new("Team")
		team1.Name = "Red"
		team1.TeamColor = BrickColor.new("Bright red")
		team1.Parent = game:GetService("Teams")
		local team2 = Instance.new("Team")
		team2.Name = "Blue"
		team2.TeamColor = BrickColor.new("Bright blue")
		team2.Parent = game:GetService("Teams")
		local players = {}
		for i, thing in pairs(playerList) do
			table.insert(players,thing)
		end
		local totalPlayers = #players
		for x = 1, #players do
			wait()
			local randomNumber = math.random(#players)
			if #players <= totalPlayers / 2 and team1 and team2 then
				players[randomNumber].Team = team2
				table.remove(players, randomNumber)
			else
				players[randomNumber].Team = team1
				table.remove(players, randomNumber)
			end
		end
	end
	function gameSetup.giveResources(playerList)
		for i, player in pairs(playerList) do
			local resourceStats = Instance.new("IntValue", player.Character)
			resourceStats.Name = "ResourceStats"
			local goldStat = Instance.new("IntValue", resourceStats)
			local lumberStat = Instance.new("IntValue", resourceStats)
			local foodStat = Instance.new("IntValue", resourceStats)
			goldStat.Name = "GoldStat"
			lumberStat.Name = "LumberStat"
			foodStat.Name = "FoodStat"
			goldStat.Value = 500
			lumberStat.Value = 150
			foodStat.Value = 10
			player.Character:FindFirstChild("ResourceControl").Disabled = false
		end
	end
	function gameSetup.shrinkPlayers(playerList)--Shrinks player to fit map size
		for i, player in pairs(playerList) do
			local scale = .5
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.JumpPower = 35
				humanoid.WalkSpeed = 12
				humanoid.BodyHeightScale.Value = humanoid.BodyHeightScale.Value * scale
				humanoid.BodyWidthScale.Value = humanoid.BodyWidthScale.Value * scale
				humanoid.BodyDepthScale.Value = humanoid.BodyDepthScale.Value * scale
				humanoid.HeadScale.Value = humanoid.HeadScale.Value * scale
			end
			for i,v in pairs (player.Character:GetChildren()) do
				if v:IsA ("Accessory") then
		        	local clone = v:Clone()
		        	v:Destroy()
		        	clone.Parent = player.Character
				end
			end
		end
	end
	function gameSetup.getUpAndPlay()--Unfortunately when a player is sitting down they don't get teleported into the game, this is here to fix that
		local seatingArea = workspace["Waiting Area"]:FindFirstChild("Seating Area")
		if seatingArea == nil then
			print("error.. seating area not found..")
			return
		end
		if allowSeating == true then
			allowSeating = false
			for i, thing in pairs(seatingArea:GetChildren()) do
				for i, item in pairs(thing:GetChildren()) do
					if item:FindFirstChild("Seat") then
						item:FindFirstChild("Seat").Disabled = true
					end
				end
			end
		else
			allowSeating = true
			for i, thing in pairs(seatingArea:GetChildren()) do
				for i, item in pairs(thing:GetChildren()) do
					if item:FindFirstChild("Seat") then
						item:FindFirstChild("Seat").Disabled = false
					end
				end
			end
		end
	end
	function gameSetup.fogOfWar(playerList)
		for i, player in pairs(playerList) do
			fogOfWarEvent:FireClient(player,playerList)
		end
	end
return gameSetup
