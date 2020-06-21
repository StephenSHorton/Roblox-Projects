local replicatedStorage = game:GetService("ReplicatedStorage")
local buildEvent = replicatedStorage:WaitForChild("BuildEvent")
local guiControl = require(script.Parent.GuiControl)
local buildModule = {}
	function buildModule.Construct(player,building,CFrameSave)
		local char = player.Character
		local gold = char:FindFirstChild("ResourceStats"):FindFirstChild("GoldStat").Value
		local lumber = char:FindFirstChild("ResourceStats"):FindFirstChild("LumberStat").Value
		local food = char:FindFirstChild("ResourceStats"):FindFirstChild("FoodStat").Value
		
		local G = 0
		local L = 0
		local F = 0
		if building == "Lumber House" then
			G = 160
			L = 30
		elseif building == "Farm" then
			G = 200
			L = 60
			F = 10
		elseif building == "Barracks" then
			G = 300
			L = 120
		end
		if gold - G < 0 then guiControl.printAll("Message","Need more Gold!") return end
		if lumber - L < 0 then guiControl.printAll("Message","Need more Lumber!") return end
		
		if building == "Lumber House" then
			buildEvent:FireClient(player,building)
			local houseClone = game.Lighting["House(Neutral)"]:Clone()
			houseClone.Click.Disabled = false
			houseClone.Parent = workspace
			houseClone.Pad.BrickColor = player.TeamColor
			houseClone.Name = "Building"
			houseClone:SetPrimaryPartCFrame(CFrameSave)
			houseClone = nil
		elseif building == "Farm" then
			buildEvent:FireClient(player,building)
			local houseClone = game.Lighting["Farm(Neutral)"]:Clone()
			houseClone.Click.Disabled = false
			houseClone.Parent = workspace
			houseClone.Pad.BrickColor = player.TeamColor
			houseClone.Name = "Building"
			houseClone:SetPrimaryPartCFrame(CFrameSave)
			houseClone = nil
		elseif building == "Barracks" then
			buildEvent:FireClient(player,building)
			local houseClone = game.Lighting["Barracks(Neutral)"]:Clone()
			houseClone.Click.Disabled = false
			houseClone.Parent = workspace
			houseClone.Pad.BrickColor = player.TeamColor
			houseClone.Name = "Building"
			houseClone:SetPrimaryPartCFrame(CFrameSave)
			houseClone = nil
		else
			guiControl.printPlayer(player,"Message",building)
		end
	end
	function buildModule.updateResources(player,resourceChanged,value)
		local char = player.Character
		local gold = char:FindFirstChild("ResourceStats"):FindFirstChild("GoldStat")
		local lumber = char:FindFirstChild("ResourceStats"):FindFirstChild("LumberStat")
		local food = char:FindFirstChild("ResourceStats"):FindFirstChild("FoodStat")
		if resourceChanged == "Gold" then
			gold.Value = value
		elseif resourceChanged == "Lumber" then
			lumber.Value = value
		elseif resourceChanged == "Food" then
			food.Value = value
		end
	end
return buildModule