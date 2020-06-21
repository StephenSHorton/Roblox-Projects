local maps = game:GetService("Lighting"):WaitForChild("Maps"):GetChildren()
local lobbySuicideBarrier = workspace["Suicide Barrier"]

local MAP_HANDLER = {}
function MAP_HANDLER.intitializeMap()
	local map = maps[math.random(#maps)]:Clone()
	map.Parent = workspace
	map.Name = "Current Map"
	lobbySuicideBarrier.Parent = game.Lighting
end
function MAP_HANDLER.startBusDrop()
	--Spawn bus
	
	--change player cameras to bus
		--give player ability to jump out
		--give player camera back when they jump
end
return MAP_HANDLER
