--This script is used in the npc-testing game
local PathFindingService = game:GetService("PathfindingService")
local AttackEvent = workspace:WaitForChild("AttackEvent")

	local MAX_TARGET_WANDER_DIST = 10
	local MIN_DAMAGE,MAX_DAMAGE = 1,1
	local ATTACK_RANGE = 5
	local ATTACK_INTERVAL = 2
	local AGENT_HEIGHT = 5
	local AGENT_RADIUS = 4

local module = {}

function module.getReadyToMoveNPCS()
	local npcs = {}
	for i,npc in ipairs(workspace.NPCS:GetChildren()) do
		local npcReadyToMove = npc:FindFirstChild("ReadyToMove")
		if npcReadyToMove and npcReadyToMove.Value == true then
			npcReadyToMove.Value = false
			table.insert(npcs,npc)
		end
	end
	return npcs
end

function module.getTargets()
	local targets = {}
	for i,plr in ipairs(game.Players:GetPlayers()) do
		local char = plr.Character or plr.CharacterAdded:wait()
		table.insert(targets,char)
	end
	return targets
end

function module.matchTargetsAndNPCS(npcs,targets)----------------------------MIGHT WANT TO CHECK SLOT AVAILABILITY HERE (Remove this comment when resolved)
	local function getOpenSlot(slots)
		local slot
		for i,s in ipairs(slots:GetChildren()) do
			if s.Value == false then
				slot = s
				break
			end
		end
		return slot
	end
	local function canPath(npc,target,slot)
		local pathParams = {
			AgentHeight = AGENT_HEIGHT,
			AgentRadius = AGENT_RADIUS,
			AgentCanJump = false
		}
		local path = PathFindingService:CreatePath(pathParams)
		path:ComputeAsync(npc.PrimaryPart.Position, target.PrimaryPart.Position)
		if path.Status == Enum.PathStatus.Success then
			return true
		else
			return false
		end
	end
	local pairedObjects = {}
	for i,npc in ipairs(npcs) do
		local closestTarget = targets[1]
		local slot
		for i,target in ipairs(targets) do
			local slots = target:FindFirstChild("Slots")
			if target.Humanoid.Health > 0 and npc.Humanoid.Health > 0 and slots and closestTarget and getOpenSlot(slots) ~= nil and canPath(npc,target) then
				if (npc.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude <= (npc.PrimaryPart.Position - closestTarget.PrimaryPart.Position).Magnitude then
					closestTarget = target
					slot = getOpenSlot(slots)
				end
			end
		end
		if closestTarget ~= nil and slot ~= nil then
			print(npc.Name .. " wants to fight " .. closestTarget.Name)
			slot.Value = true
			npc:FindFirstChild("CurrentSlot").Value = slot--For the Animate script inside npc (opens slot when npc dies)
			table.insert(pairedObjects,{["NPC"] = npc,["TARGET"] = closestTarget,["SLOT"] = slot})
		else
			print(npc.Name .. " could not find a target")
			local npcReadyToMove = npc:FindFirstChild("ReadyToMove")
			npcReadyToMove.Value = true
		end
	end
	return pairedObjects
end

function module.pathToTargets(pairedObjects)
	local function sendBackToPool(npc,slot)
		local npcReadyToMove = npc:FindFirstChild("ReadyToMove")
		slot.Value = false
		npcReadyToMove.Value = true
	end
	local function getSlotPos(slot,target)
		local s = tonumber(slot.Name)
		local pos
		if s == 1 then
			pos = target.PrimaryPart.Position + target.PrimaryPart.CFrame.LookVector*(ATTACK_RANGE-1)
		elseif s == 2 then
			pos = target.PrimaryPart.Position - (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(45),0)).LookVector*(ATTACK_RANGE-1)
		elseif s == 3 then
			pos = target.PrimaryPart.Position - (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(90),0)).LookVector*(ATTACK_RANGE-1)
		elseif s == 4 then
			pos = target.PrimaryPart.Position - (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(135),0)).LookVector*(ATTACK_RANGE-1)
		elseif s == 5 then
			pos = target.PrimaryPart.Position - target.PrimaryPart.CFrame.LookVector*(ATTACK_RANGE-1)
		elseif s == 6 then
			pos = target.PrimaryPart.Position + (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(135),0)).LookVector*(ATTACK_RANGE-1)
		elseif s == 7 then
			pos = target.PrimaryPart.Position + (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(90),0)).LookVector*(ATTACK_RANGE-1)
		elseif s == 8 then
			pos = target.PrimaryPart.Position + (target.PrimaryPart.CFrame*CFrame.Angles(0,math.rad(45),0)).LookVector*(ATTACK_RANGE-1)
		end
		return pos
	end
	local function attack(npc,target,slot)
		if target == nil then sendBackToPool(npc,slot) return end
		local targetHumanoid = target:FindFirstChild("Humanoid")
		if targetHumanoid.Health > 0 and (npc.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude <= ATTACK_RANGE then
			npc.PrimaryPart.CFrame = CFrame.new(npc.PrimaryPart.Position,target.PrimaryPart.Position)
			AttackEvent:Fire(npc)
			local randomDamage = math.random(MIN_DAMAGE,MAX_DAMAGE)
			targetHumanoid:TakeDamage(randomDamage)
			wait(ATTACK_INTERVAL)
			return attack(npc,target,slot)
		else
			sendBackToPool(npc,slot)
		end
	end
	local function doPath(npc,target,slot)
		local npcHumanoid = npc:FindFirstChild("Humanoid")
		if target == nil then sendBackToPool(npc,slot) return end
		local targetOriginalPosition = target.PrimaryPart.Position
		if (npc.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude <= ATTACK_RANGE then return attack(npc,target,slot) end
		local pathParams = {
			AgentHeight = AGENT_HEIGHT,
			AgentRadius = AGENT_RADIUS,
			AgentCanJump = false
		}
		local path = PathFindingService:CreatePath(pathParams)
		path:ComputeAsync(npc.PrimaryPart.Position, getSlotPos(slot,target))
		if path.Status == Enum.PathStatus.Success then
			local targetReached = true
			local waypoints = path:GetWaypoints()
			local partTable = {}
			local brickC = npc.PrimaryPart.BrickColor
			for i, waypoint in ipairs(waypoints) do
				if i == #waypoints then break end
				local part = Instance.new("Part")
				part.Shape = "Ball"
				part.Material = Enum.Material.Neon
				part.Transparency = 0.2
				part.Reflectance = 0.1
				part.BrickColor = brickC
				part.Size = Vector3.new(0.6, 0.6, 0.6)
				part.Position = waypoint.Position
				part.Anchored = true
				part.CanCollide = false
				part.Parent = game.Workspace
				table.insert(partTable,part)
			end
			for i,waypoint in ipairs(waypoints) do
				npcHumanoid:MoveTo(waypoint.Position)
				--[[if waypoint.Action == Enum.PathWaypointAction.Jump then--------------------------------------------------------------------------------FOR JUMPING
					local save = npcHumanoid.WalkSpeed
					npcHumanoid.WalkSpeed = 20
					npcHumanoid.Jump = true
					wait(1)
					npcHumanoid.WalkSpeed = save
					npcHumanoid:MoveTo(waypoint.Position)
				end--]]
				local reached = npcHumanoid.MoveToFinished:wait()
				if reached then
					if partTable[i] ~= nil then partTable[i]:Destroy() end
					if i >= 3 and (targetOriginalPosition - target.PrimaryPart.Position).Magnitude > MAX_TARGET_WANDER_DIST then--Here is where the npc checks if the target has moved from its original position
						for i,part in ipairs(partTable) do
							part:Destroy()
						end
						return doPath(npc,target,slot)-------------------------------CANT DO THIS, state is locked in a spawn function
					end
				else
					--[[local reached = false----------------------------------------------------------------------------------------------------FOR move timeout/JUMPING (Broken..)
					repeat
						npcHumanoid:MoveTo(npc.PrimaryPart.Position - Vector3.new(npc.PrimaryPart.CFrame.LookVector*3))
						wait()
						npcHumanoid.MoveToFinished:wait()
						npcHumanoid:MoveTo(waypoint.Position)
						local save = npcHumanoid.WalkSpeed
						npcHumanoid.WalkSpeed = 20
						npcHumanoid.Jump = true
						wait(1)
						npcHumanoid.WalkSpeed = save
						npcHumanoid:MoveTo(waypoint.Position)
						reached = npcHumanoid.MoveToFinished:wait()
					until reached == true
					if partTable[i] ~= nil then partTable[i]:Destroy() end
					if i > 3 and (targetOriginalPosition - target.PrimaryPart.Position).Magnitude > 10 then--Here is where the npc checks if the target has moved from its original position
						for i,part in ipairs(partTable) do
							part:Destroy()
						end
						return doPath(npc,target,slot)
					end--]]
				end
			end
			-----------------------------------------------------------------------------------------------------------------------Here is where the npc goes back into the move pool decided by server
			npc.PrimaryPart.CFrame = CFrame.new(npc.PrimaryPart.Position,target.PrimaryPart.Position)
			sendBackToPool(npc,slot)--This is only reached if the target did not move far from their position at the start of the pathing
		else sendBackToPool(npc,slot) end
	end
	for _,pair in pairs(pairedObjects) do
		local npc,target,slot = pair["NPC"],pair["TARGET"],pair["SLOT"]
		spawn(function()
			doPath(npc,target,slot)
		end)
	end
end

return module
