game.Players.PlayerAdded:Connect(function(plr)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local timePlayed = Instance.new("IntValue")
	timePlayed.Name = "Time"
	timePlayed.Value = 0
	timePlayed.Parent = leaderstats
end)

while wait(1) do
	for _,p in ipairs(game.Players:GetPlayers()) do
		local leaderstats = p:FindFirstChild("leaderstats")
		if leaderstats then
			local timePlayed = leaderstats:FindFirstChild("Time")
			if timePlayed then
				timePlayed.Value = timePlayed.Value + 1
			end
		end
	end
end