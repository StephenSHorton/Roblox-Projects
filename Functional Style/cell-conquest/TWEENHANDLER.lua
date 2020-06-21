local TweenService = game:GetService("TweenService")
local TWEEN_HANDLER = {}
function TWEEN_HANDLER.tweenSendie(plr,startCell,wayPoints,armySize)
	local sendie = startCell:Clone()
	sendie.Attachment:Destroy()
	for i,v in ipairs(sendie:GetChildren()) do
		if v:IsA("Beam") then v:Destroy() end
	end
	sendie.Name = "Army"
	sendie.BillboardGui.Score.Text = armySize
	local sizeModification = (armySize*0.008)/4
	if sizeModification < 0.3 then
		sizeModification = 0.3
	elseif sizeModification <= 2.5 and sizeModification >= 1.7 then
		sizeModification = (armySize*0.006)/4
	end
	if sizeModification > 2.5 then
		sizeModification = 2.5
	end
	sendie.Size = Vector3.new(sizeModification* 0.5,sizeModification,sizeModification)
	sendie.BillboardGui.Score.TextSize = 10
	sendie.Parent = workspace
	
	
	local function doTransaction(cell)--Will transact the landing cell of the army
		local score = cell.BillboardGui.Score
		if cell.tColor.Value ~= plr.TeamColor then
			local change = math.ceil(tonumber(score.Text) - armySize)
			--if the attack is overwhelming then capture the cell, otherwise just subtract
			if change < 0 then
				score.Text = math.abs(change)
				cell.Color = sendie.Color
				cell.tColor.Value = plr.TeamColor
			else
				score.Text = change
			end
		else
			score.Text = tonumber(score.Text) + armySize
		end
	end
	
	
	for i,wayPoint in ipairs(wayPoints) do
		local goal = {
			CFrame = wayPoint.CFrame
		}		
		local tweenInfo = TweenInfo.new(
			(sendie.Position - wayPoint.Position).Magnitude,--Affects speed of armies
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.Out,
			0,
			false,
			0
		)
		local tween = TweenService:Create(sendie,tweenInfo,goal)
		tween:Play()
		tween.Completed:wait()
		--Check if current waypoint was still owned by player, else do transaction with that cell and leave the loop
		if wayPoint.tColor.Value ~= plr.TeamColor or wayPoints[#wayPoints] == wayPoint then
			doTransaction(wayPoint)
			break
		end
	end
	sendie:Destroy()
end

--[[
function TWEEN_HANDLER.findWayPoints(plr,startCell,targetCell)
	local wayPoints = {}
	
	local function findDestinations(cell_)
		print("----------------------------------------------------FROM: " .. cell_.Name .. " TO: " .. targetCell.Name ..  "----------------------------------------------------")
		local possibleDestinations = {}
		print("Possible Destinations:")
		for i,path in ipairs(cell_:GetChildren()) do
			if path:IsA("Beam") and path.Name == "Path" then
				local possibleCellDest = path.Attachment1.Parent
				if possibleCellDest.Owner.Value == plr or possibleCellDest == targetCell then
					print(possibleCellDest.Name)
					table.insert(possibleDestinations,possibleCellDest)
				end
				
			end
		end
		return possibleDestinations
	end
	
	local function findClosestDestination(destinations)
		local closest = destinations[1]
		print("Closest of Possible:")
		for i,dest in ipairs(destinations) do
			if (dest.Position - targetCell.Position).Magnitude < (closest.Position - targetCell.Position).Magnitude then
				closest = dest
			end
		end
		print(closest.Name)
		return closest--Return the closest cell found in relation to the targetCell
	end
	
	local wayPoint = startCell
	while true do
		local destinations = findDestinations(wayPoint)
		wayPoint = findClosestDestination(destinations)
		if wayPoint == targetCell then--IF and when we reach the target cell, break the loop and return wayPoints[]
			table.insert(wayPoints,wayPoint)
			print("INSERTED: " .. wayPoint.Name)
			break
		elseif wayPoint == nil then return nil--IF there is no path to the target cell then send back nil and END FUNCTION EARLY
		else
			table.insert(wayPoints,wayPoint)
			print("INSERTED: " .. wayPoint.Name)
		end
	end
	
	return wayPoints
end
--]]

return TWEEN_HANDLER
