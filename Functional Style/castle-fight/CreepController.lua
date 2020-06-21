wait(1)
local ANIMATION = require(script.Animation)
local localCreep = script.Parent
local localHumanoid = localCreep.Humanoid
local attributes = localCreep:FindFirstChild("Creep Attributes")

	local DAMAGE = attributes:FindFirstChild("Damage").Value
	local DAMAGE_TYPE = attributes:FindFirstChild("Damage Type").Value
	local ATTACK_SPEED = tonumber(attributes:FindFirstChild("Attack Speed").Value)
	local ARMOR = attributes:FindFirstChild("Armor").Value
	local ARMOR_TYPE = attributes:FindFirstChild("Armor Type").Value
	local ATTACK_RANGE = attributes:FindFirstChild("Attack Range").Value
	local MOVE_SPEED = attributes:FindFirstChild("Move Speed").Value
	local HEALTH = attributes:FindFirstChild("Health").Value

	localHumanoid.MaxHealth = HEALTH
	localHumanoid.Health = HEALTH
	localHumanoid.WalkSpeed = MOVE_SPEED


local team = script.Parent:FindFirstChild("Team").Value

local defaultLocation
if team == "Team 1" then
	defaultLocation = workspace["Team 2 Creep Spawn"]
else
	defaultLocation = workspace["Team 1 Creep Spawn"]
end

local endGoal
if team == "Team 1" then
	endGoal = "Team 2 Creep Spawn"
else
	endGoal = "Team 1 Creep Spawn"
end

local enemyCastle
if team == "Team 1" then
	enemyCastle = workspace["Team 2 Castle"]
else
	enemyCastle = workspace["Team 1 Castle"]
end

local dead = false

--local range = Instance.new("Part", localCreep)
--range.Size = Vector3.new(ATTACK_RANGE, 1, ATTACK_RANGE)
--range.CFrame = localCreep.PrimaryPart.CFrame
--range.Name = "Range Indicator"
--range.CanCollide = false
--range.Transparency = 1
--local weld = Instance.new("WeldConstraint")
--weld.Parent = range
--weld.Part0 = range
--weld.Part1 = localCreep.HumanoidRootPart
--localCreep:WaitForChild("Range Indicator")

--function GetTouchingParts(part) --For noncollide parts
--	local connection = part.Touched:Connect(function() end)
--	local results = part:GetTouchingParts()
--	connection:Disconnect()
--	return results
--end

function onDeath()
	dead = true
	ANIMATION.death()
	localHumanoid:MoveTo(localCreep.PrimaryPart.Position, localCreep)
	wait(2)
	localCreep:Destroy()
end

function updateDamaged(target)
	local greenBar = target["Health Gui"]["Red Frame"]["Green Frame"]
	local health = target.Humanoid.Health
	local maxHealth = target.Humanoid.MaxHealth
	greenBar.Size = UDim2.new(health/maxHealth,0,1,0)
end

function giveDamage(target)
	local humanoid = target:FindFirstChild("Humanoid")
	if humanoid ~= nil then
		humanoid:TakeDamage(DAMAGE)
		updateDamaged(target)
		ANIMATION.defaultAttack(target,localCreep)
	end
end

function scanForEnemies()
	local target = nil
--	local partTable = GetTouchingParts(range)
	local min = localCreep.PrimaryPart.Position - Vector3.new(ATTACK_RANGE,5,ATTACK_RANGE)
	local max = localCreep.PrimaryPart.Position + Vector3.new(ATTACK_RANGE,20,ATTACK_RANGE)
	local region = Region3.new(min,max)
	local partTable = workspace:FindPartsInRegion3(region, nil, math.huge)
	for i, part in pairs(partTable) do
		if part.Parent ~= script.Parent then
			if part.Name == endGoal then target = "END" return target end
			if part.Name == "Body" and part.Parent:FindFirstChild("Humanoid") and part.Parent:FindFirstChild("Team") then
				if part.Parent["Team"].Value ~= team then
				target = part.Parent
				return target
				end
			end
		end
	end
	region = nil
	return target
end

function loopTargetFind()
	wait(ATTACK_SPEED)--THIS IS THE ATTACK SPEED RIGHT NOW.. Not sure if ok
	if dead then return end
	local target = scanForEnemies()
	if target == "END" then
		giveDamage(enemyCastle)
		loopTargetFind()
	end
	if target then
		giveDamage(target)
		localHumanoid:MoveTo(target.PrimaryPart.Position, target.PrimaryPart)
		loopTargetFind()
	else
		localHumanoid:MoveTo(defaultLocation.Position, defaultLocation)
		loopTargetFind()
	end
end

localHumanoid.Died:Connect(onDeath)


--START
loopTargetFind()