wait()
local SETUP = require(script.Parent.Game.Setup)

local Build = game.ReplicatedStorage.Build
local GuiControl = game.ReplicatedStorage.GuiControl
local serial = 1

local function performTransaction(player, buildingType)
	--charge player for buying buildng
	local plrGold = workspace.Resources[player.Name].Gold
	local plrLumber = workspace.Resources[player.Name].Lumber
	local buildingCost = game.Lighting[buildingType]["Attributes"]["Cost"].Value
	plrGold.Value = plrGold.Value - buildingCost
	--give lumber for cost
	plrLumber.Value = plrLumber.Value + buildingCost
	--increase income for team
	if workspace.Teams["Team 1"]:FindFirstChild(player.Name) then
		SETUP.addIncome(1, buildingCost*0.02)
	else
		SETUP.addIncome(2, buildingCost*0.02)
	end
	GuiControl:FireAllClients("Display Resource")
end

local function handleBuild(player, grid, gridParent, buildingType)
	local building = game.Lighting[buildingType]:Clone()
	building.Parent = workspace
	building:SetPrimaryPartCFrame(workspace[gridParent][grid].CFrame+Vector3.new(0,0.14,0))
	building.Name = player.Name .. "'s " .. buildingType .. " #" .. serial
	serial = serial + 1
	local ownerTag = Instance.new("ObjectValue")
	ownerTag.Value = player
	ownerTag.Name = "Owner"
	ownerTag.Parent = building
	building["Creep Spawner"].Disabled = false
	building["Handle Sell"].Disabled = false
	local gridConnection = Instance.new("ObjectValue", building)
	gridConnection.Name = "Grid Connection"
	gridConnection.Value = workspace[gridParent][grid]
	local spaceBlocked = Instance.new("StringValue")
	spaceBlocked.Name = "Space is used"
	spaceBlocked.Value = "Space is used"
	spaceBlocked.Parent = workspace[gridParent][grid]
	performTransaction(player, buildingType)
end

Build.onServerEvent:Connect(function(player, grid, gridParent, buildingType)
	local buildingTypeHolder = buildingType
	handleBuild(player, grid, gridParent, buildingTypeHolder)
end)