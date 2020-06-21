local sendEvent = game:GetService("ReplicatedStorage"):WaitForChild("Send Event")
local INCREMENTOR = require(script:WaitForChild("Incrementor"))
local TWEEN_HANDLER = require(script:WaitForChild("TWEEN HANDLER"))
local MAP_HANDLER = require(script:WaitForChild("Map Handler"))
local PATHFINDING = require(script:WaitForChild("PATHFINDING"))
local PLAYER_HANDLER = require(script:WaitForChild("PLAYER HANDLER"))

local function getPercentage(cell,percent)
	local percentage = math.ceil(tonumber(cell.BillboardGui.Score.Text)*percent)
	return percentage
end

function handleSendEvent(plr,cells,percent,target)
	--Get the actual cells described in client's message: <table> cells
	local targetActual = workspace["Current Map"]:FindFirstChild(target)
	local cellsActual = {}
	for i,cell in ipairs(cells) do
		table.insert(cellsActual,workspace["Current Map"]:FindFirstChild(cell))
	end
	
	--Find waypoints for each sending cell and transact the send
	for i,cell in ipairs(cellsActual) do
		local armySize = getPercentage(cell,percent)
		spawn(function()
			local wayPoints = PATHFINDING.findPath(cell,targetActual,plr)
			--If there are waypoints then continue
			if wayPoints and #wayPoints > 0 then
				table.remove(wayPoints,1)---REMOVE THE START PLACE FROM WAYPOINTS (I have the path return with the start place as well, which is not needed)
				if armySize > 0 then
					spawn(function()
						TWEEN_HANDLER.tweenSendie(plr,cell,wayPoints,armySize)
					end)
				end
				cell.BillboardGui.Score.Text = tonumber(cell.BillboardGui.Score.Text) - armySize
			else print("no path found...") end
			-------------------------------------------------------------------------------------------MAKE SURE EACH WAYPOINT IS CHECKED TO SEE IF IT IS SWALLOWED UP BY AN ENEMY THAT CAPTURES A CELL IN PATH BEFORE CELL REACHES TARGET
		end)
	end
end


sendEvent.OnServerEvent:Connect(handleSendEvent)
---------------------------------------------------------START---------------------------------------------------------
--Initiate listeners (Color pick, Music)
PLAYER_HANDLER.initiateColorPickListener()
--Wait For players (x)
PLAYER_HANDLER.startLobbyTimer(5)
--Bring in a map
MAP_HANDLER.intitializeMap()
--Allow players to pick their starting cell
local playirs = {}
for i,plr in ipairs(game:GetService("Players"):GetPlayers()) do
	if plr.TeamColor ~= BrickColor.new("White") then
		table.insert(playirs,plr)
	end
end

--Initialize cell increment thread
spawn(function()
	wait(3)----------------------------------------------------------------------------------Find another way to wait for workspace to load (players have loaded)
	INCREMENTOR.initializeIncrement(1,0.1)
end)