local Robot = require(game.ReplicatedStorage.Robot)
local arena = workspace:WaitForChild("Arena")
local slotM1 = arena:WaitForChild("Slot Machine 1")
local slotM2 = arena:WaitForChild("Slot Machine 2")
local bill1 = slotM1:WaitForChild("Clickable"):WaitForChild("BillboardGui")
local bill2 = slotM2:WaitForChild("Clickable"):WaitForChild("BillboardGui")

	local ROUND = 1

local botSlots = {
	"Laser",
	"Gunner",
	"Tank"
}
local weaponSlots = {
	"Laser Cannon",
	"Microwave",
	"Electric Bolt"
}
local utilitySlots ={
	"Barrier",
	"Hack",
	"Energize"
}

function getRoll(t)
	local x = {}
	for i=1,3 do
		x[i] = t[math.random(#t)]
	end
	return x
end

function toggleAllBots(r)
	r:toggleGunnerBot()
	r:toggleTankBot()
	r:toggleLaserBot()
end

function lookAtEachother(r1,r2)
	r1:setCFrame(CFrame.new(r1.Main.PrimaryPart.Position,r2.Main.PrimaryPart.Position))
	r2:setCFrame(CFrame.new(r2.Main.PrimaryPart.Position,r1.Main.PrimaryPart.Position))
end

function roll(option) -- when player rolls
	local r = getRoll(option)
	print(r[1],r[2],r[3])
	local t = {}
	for i,v in ipairs(r) do
		if t[v] ~= nil then
			t[v] += 1
		else
			t[v] = 1
		end
	end
	return t
end

function getOption(slotM)
	local c
	if slotM == slotM1 then
		c = slotM1.Bottom.BrickColor
	else c = slotM2.Bottom.BrickColor end
	local option
	if c == BrickColor.new("Bright blue") then
		option = botSlots
	elseif c == BrickColor.new("Bright red") then
		option = weaponSlots
	elseif c == BrickColor.new("Bright yellow") then
		option = utilitySlots
	end
	return option
end

local count = -1
function showTurn(t)
	count += 1
	if count == 2 then
		count = 0
		ROUND += 1
		print("ROUND -- " .. ROUND)
	end
	if t then -- Turn 1
		bill2.Enabled = false
		bill1.Enabled = true
	else -- Turn 2
		bill2.Enabled = true
		bill1.Enabled = false
	end
end

local robot1 = Robot("Roger111",arena.Part1.Position,1) -- Owner,Position,PlayerSlot
local robot2 = Robot("Roger111",arena.Part2.Position,2) -- Owner,Position,PlayerSlot

lookAtEachother(robot1,robot2)
print("ROUND -- 1")

local _turn = math.random(2) == 1 or false
showTurn(_turn)

local debounce1 = true
slotM1.Clickable.ClickDetector.MouseClick:Connect(function(who)
	if debounce1 and _turn == true then
		debounce1 = false
		local thisOption = getOption(slotM1)
		local thisRoll = roll(thisOption)
		if thisOption == weaponSlots then
			robot1:fireWeapon(thisRoll,robot2)
		elseif thisOption == botSlots then
			robot1:toggleBots(thisRoll)
		elseif thisOption == utilitySlots then
			robot1:fireUtility(thisRoll,robot2)
		end
		if ROUND ~= 1 then
			spawn(function() robot1:fireBots(robot2) end)
			robot2:fireBots(robot1)
		end
		wait(2) -- wait before swapping turns too quickly
		_turn = not _turn
		showTurn(_turn)
		debounce1 = true
	end
end)
local debounce2 = true
slotM2.Clickable.ClickDetector.MouseClick:Connect(function(who)
	if debounce2 and _turn == false then
		debounce2 = false
		local thisOption = getOption(slotM2)
		local thisRoll = roll(thisOption)
		if thisOption == weaponSlots then
			robot2:fireWeapon(thisRoll,robot1)
		elseif thisOption == botSlots then
			robot2:toggleBots(thisRoll)
		elseif thisOption == utilitySlots then
			robot2:fireUtility(thisRoll,robot1)
		end
		if ROUND ~= 1 then
			spawn(function() robot2:fireBots(robot1) end)
			robot1:fireBots(robot2)
		end
		wait(2) -- wait before swapping turns too quickly
		_turn = not _turn
		showTurn(_turn)
		debounce2 = true
	end
end)