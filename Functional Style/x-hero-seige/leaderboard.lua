local Teams = game:GetService("Teams")
local LEADERBOARD = {}
	function LEADERBOARD.setup(playerList)
		print("Initializing leaderboard..")
		for i, player in pairs(playerList) do
			if player then
				local leaderstats = Instance.new("Folder",player)
				leaderstats.Name = "leaderstats"
				local kills = Instance.new("IntValue",leaderstats)
				kills.Name = "Kills"
				kills.Value = 0
				local gold = Instance.new("IntValue",leaderstats)
				gold.Name = "Gold"
				gold.Value = 0
				local level = Instance.new("IntValue",leaderstats)
				level.Name = "Level"
				level.Value = 1
				local exp = Instance.new("IntValue",leaderstats)
				exp.Name = "Exp"
				exp.Value = 0
			end
		end
	end
return LEADERBOARD