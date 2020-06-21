local GuiControl = game.ReplicatedStorage.GuiControl
local CLEAN_UP_HANDLER = {}
	function CLEAN_UP_HANDLER.killUnits()
		for i, thing in ipairs(workspace:GetChildren()) do
			if thing.Name == "Creep" then
				thing:Destroy()
			end
		end
	end

	function CLEAN_UP_HANDLER.killPlayers()
		for i, player in ipairs(game.Players:GetPlayers()) do
			player.Character.Humanoid:TakeDamage(9999)
		end
	end

	function CLEAN_UP_HANDLER.killBuildings()
		for i, thing in ipairs(workspace:GetChildren()) do--destroys all objects containing a sell gui (kinda weird)
			if thing:FindFirstChild("Sell Gui") == true then
				thing:Destroy()
			end
		end
		for i, grid in ipairs(workspace["Grid Team 1"]:GetChildren()) do --Clean grid 1 of space is occupied
			if #grid:GetChildren() > 0 then
				for i, thing in ipairs(grid:GetChildren()) do
					thing:Destroy()
				end
			end
		end
		for i, grid in ipairs(workspace["Grid Team 2"]:GetChildren()) do --Clean grid 2 of space is occupied
			if #grid:GetChildren() > 0 then
				for i, thing in ipairs(grid:GetChildren()) do
					thing:Destroy()
				end
			end
		end
	end

	function CLEAN_UP_HANDLER.respawnCastles()
		workspace["Team 1 Castle"]:Destroy()
		workspace["Team 2 Castle"]:Destroy()
		local team1Castle = game.Lighting.Castles["Team 1 Castle"]:Clone()
		local team2Castle = game.Lighting.Castles["Team 2 Castle"]:Clone()
		team1Castle.Parent = workspace
		team2Castle.Parent = workspace
	end

	function CLEAN_UP_HANDLER.resetGuis()
		GuiControl:FireAllClients("UnDisplay Resource")
		for i, tag in pairs(game.Workspace["Players Ready"]:GetChildren()) do
			if game.Players:FindFirstChild(tag.Name) then
				game.Players:FindFirstChild(tag.Name).PlayerGui["Build Gui"].Enabled = false
			end
		end
		wait(10)--give smooth transition to players (Not working???)
		GuiControl:FireAllClients("Display Modes")
		GuiControl:FireAllClients("Display Readies")
		GuiControl:FireAllClients("Display Teams")
	end
return CLEAN_UP_HANDLER
