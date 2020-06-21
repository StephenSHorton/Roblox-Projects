local GuiControl = game.ReplicatedStorage.GuiControl
local SETUP = {}
function SETUP.resources()
	for i, tag in pairs(game.Workspace["Players Ready"]:GetChildren()) do
		if game.Players:FindFirstChild(tag.Name) then
			local plrTag = Instance.new("StringValue")
			plrTag.Name = tag.Name
			plrTag.Value = tag.Name
			plrTag.Parent = workspace.Resources
			local goldTag = Instance.new("IntValue")
			goldTag.Name = "Gold"
			goldTag.Value = 265
			goldTag.Parent = plrTag
			local lumberTag = Instance.new("IntValue")
			lumberTag.Name = "Lumber"
			lumberTag.Value = 0
			lumberTag.Parent = plrTag
		end
	end
	GuiControl:FireAllClients("Display Resources")
end

function SETUP.buildMenu()
	--give Build
	for i, tag in pairs(game.Workspace["Players Ready"]:GetChildren()) do
		if game.Players:FindFirstChild(tag.Name) then
			game.Players:FindFirstChild(tag.Name).PlayerGui["Build Gui"].Enabled = true
		end
	end
end

function SETUP.movePlayers(where)
	local t1 = workspace.Teams["Team 1"]:GetChildren()
	local t2 = workspace.Teams["Team 2"]:GetChildren()
	if where == "Start" then
		for i=1,2 do
			if t1[i].Value ~= "" then
				game.Players[t1[i].Name].Character:MoveTo(workspace["Team 1 Spawn"].Position)
			end
		end
		for i=1,2 do
			if t2[i].Value ~= "" then
				game.Players[t2[i].Name].Character:MoveTo(workspace["Team 2 Spawn"].Position)
			end
		end
	end
end

function SETUP.income()
	spawn(function()
		
		while workspace["Thread Function Stopper"].Value == false do
			wait(10)
			local t1Inc = workspace.Income["Team 1"]
			local t2Inc = workspace.Income["Team 2"]
			local team1 = workspace.Teams["Team 1"]:GetChildren()
			for i=1,#team1 do
				if team1[i].Name ~= "Join" then
					workspace.Resources[team1[i].Name].Gold.Value = workspace.Resources[team1[i].Name].Gold.Value + t1Inc.Value
				end
			end
			local team2 = workspace.Teams["Team 2"]:GetChildren()
			for i=1,#team2 do
				if team2[i].Name ~= "Join" then
					workspace.Resources[team2[i].Name].Gold.Value = workspace.Resources[team2[i].Name].Gold.Value + t2Inc.Value
				end
			end
			GuiControl:FireAllClients("Display Resource")
		end
	end)
end

function SETUP.addIncome(team, amount)
	if team == 1 then
		workspace.Income["Team 1"].Value = workspace.Income["Team 1"].Value + amount
	else
		workspace.Income["Team 2"].Value = workspace.Income["Team 2"].Value + amount
	end
end

function SETUP.listenForGameEnd()
	local castle1 = workspace["Team 1 Castle"]
	local castle2 = workspace["Team 2 Castle"]
	local winner = nil
	castle1.Humanoid.Died:connect(function()
		print("TEAM 2 WINS")
		if castle1.Humanoid.Health <= 0 then
			local sparkles = Instance.new("Sparkles",castle2.PrimaryPart)
			sparkles.SparkleColor = castle2.Base.Color
			winner = 2
		end
	end)
	castle2.Humanoid.Died:connect(function()
		print("TEAM 1 WINS")
		if castle2.Humanoid.Health <= 0 then
			local sparkles = Instance.new("Sparkles",castle1.PrimaryPart)
			sparkles.SparkleColor = castle1.Base.Color
			winner = 1
		end
	end)
	repeat wait()
	until winner ~= nil
end

return SETUP
