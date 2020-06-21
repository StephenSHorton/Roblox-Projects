--This script is used in the cell-conquest game
local PATHFINDING = {}
function PATHFINDING.findPath(start,finish,plr)--Returns a table of objects as a route to a destination (***Given that the connection between objects are beams***)
	if start == finish then return nil end
	local function findSurroundingNodes(startPlace)
		local touchingObjects = {}
		for i,beam in ipairs(startPlace:GetChildren()) do
			if beam:IsA("Beam") and beam.Attachment1 ~= nil then
				if beam.Attachment1.Parent == finish then
					touchingObjects = {beam.Attachment1.Parent}
					return touchingObjects
				else
					touchingObjects[#touchingObjects+1] = beam.Attachment1.Parent
				end
			end
		end
		return touchingObjects
	end

	local OPEN = {start}
	local CLOSED = {}
	
	local current = start
	local openPath = {}
	while true do
		if #OPEN == 0 then return nil end
		local lowest_f_cost
		local indexToRemove
		for i,node in ipairs(OPEN) do
			if node.tColor.Value ~= plr.TeamColor then
				if node == finish then
					local f_cost = (node.Position - start.Position).Magnitude + (node.Position - finish.Position).Magnitude
					if lowest_f_cost == nil or f_cost <= lowest_f_cost then
						indexToRemove = i
						current = node
						lowest_f_cost = f_cost
					end
				end
			else
				local f_cost = (node.Position - start.Position).Magnitude + (node.Position - finish.Position).Magnitude
				if lowest_f_cost == nil or f_cost <= lowest_f_cost then
					indexToRemove = i
					current = node
					lowest_f_cost = f_cost
				end
			end
		end
		table.remove(OPEN,indexToRemove)
		table.insert(CLOSED,current)
		if current == finish then openPath = CLOSED break end
		for i,node in ipairs(findSurroundingNodes(current)) do
			if table.find(CLOSED,node) == nil and table.find(OPEN,node) == nil and node.tColor.Value == plr.TeamColor or node == finish then
				table.insert(OPEN,node)
			end
		end
	end
	local result = {start}
	while true do
		local closest
		local nodes = findSurroundingNodes(result[#result])
		for i,node in ipairs(nodes) do
			if table.find(openPath,node) then
				if node == finish then
					table.insert(result,node)
					return result
				elseif closest and (node.Position - finish.Position).Magnitude < (closest.Position - finish.Position).Magnitude then
					closest = node
				elseif closest == nil then
					closest = node
				end
			end
		end
		table.insert(result,closest)
	end
end
return PATHFINDING
