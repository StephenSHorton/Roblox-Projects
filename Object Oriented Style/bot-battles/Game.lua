local Robot = require(game.ReplicatedStorage.Robot)
local arena = workspace:WaitForChild("Arena")
local slotM1 = {
	Model = arena:WaitForChild("Slot Machine 1"),
	Debounce1 = true,
	Debounce2 = true,
	modeIndex = 1
}
slotM1.Button1 = slotM1.Model:FindFirstChild("Buttons"):FindFirstChild("Button1")
slotM1.Button2 = slotM1.Model:FindFirstChild("Buttons"):FindFirstChild("Button2")
slotM1.Billboard = slotM1.Model:FindFirstChild("BillboardGui")
slotM1.mf1 = slotM1.Button1:FindFirstChild("PrismaticConstraint").MotorMaxForce
slotM1.mf2 = slotM1.Button2:FindFirstChild("PrismaticConstraint").MotorMaxForce
local slotM2 = {
	Model = arena:WaitForChild("Slot Machine 2"),
	Debounce1 = true,
	Debounce2 = true,
	modeIndex = 1
}
slotM2.Button1 = slotM2.Model:FindFirstChild("Buttons"):FindFirstChild("Button1")
slotM2.Button2 = slotM2.Model:FindFirstChild("Buttons"):FindFirstChild("Button2")
slotM2.Billboard = slotM2.Model:FindFirstChild("BillboardGui")
slotM2.mf1 = slotM2.Button1:FindFirstChild("PrismaticConstraint").MotorMaxForce
slotM2.mf2 = slotM2.Button2:FindFirstChild("PrismaticConstraint").MotorMaxForce

	local ROUND = 1

local botSlots = {
	"LaserBot",
	"GunnerBot",
	"TankBot"
}
local weaponSlots = {
	"LaserCannon",
	"LaserCannon", -- Microwave
	"LaserCannon" -- ElectricBolt
}
local utilitySlots ={
	"Barrier",
	"Barrier", -- Hack
	"Barrier" -- Energize
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
	local c = slotM.Button2:FindFirstChild("Button"):FindFirstChild("Rim").BrickColor
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
		slotM2.Billboard.Enabled = false
		slotM1.Billboard.Enabled = true
	else -- Turn 2
		slotM2.Billboard.Enabled = true
		slotM1.Billboard.Enabled = false
	end
end

local robot1 = Robot("Roger111",arena.Part1.Position,1) -- Owner,Position,PlayerSlot
local robot2 = Robot("Roger111",arena.Part2.Position,2) -- Owner,Position,PlayerSlot

lookAtEachother(robot1,robot2)
print("ROUND -- 1")

local _turn = math.random(2) == 1 or false
showTurn(_turn) -- true is slotm1 false is slotm2

local colors = {
	BrickColor.new("Bright red"),
	BrickColor.new("Bright blue"),
	BrickColor.new("Bright yellow")
}
function getIndex(slotM)
	if slotM.modeIndex + 1 == 4 then
		slotM.modeIndex = 1
	else slotM.modeIndex += 1 end
	return slotM.modeIndex
end
--SLOT MACHINE 1
slotM1.Button1.Button.Rim.Touched:Connect(function(hit)
	if slotM1.Debounce1 and _turn == true then
		local char = hit.Parent:FindFirstChild("Humanoid") and hit.Parent or nil
		if char then
			slotM1.Debounce1 = false
			slotM1.Button1.Root.Sound:Play()
			
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
				spawn(function() robot2:fireBots(robot1) end)
				robot1:fireBots(robot2)
			end
			wait(2) -- wait before swapping turns too quickly
			_turn = not _turn
			showTurn(_turn)
			
			slotM1.Button1.PrismaticConstraint.MotorMaxForce = slotM1.mf1 + 1000
			wait(0.25)
			slotM1.Button1.PrismaticConstraint.MotorMaxForce = slotM1.mf1
			wait()
			slotM1.Debounce1 = true
		end
	end
end)
slotM1.Button2.Button.Rim.Touched:Connect(function(hit)
	if slotM1.Debounce2 then
		local char = hit.Parent:FindFirstChild("Humanoid") and hit.Parent or nil
		if char then
			slotM1.Debounce2 = false
			slotM1.Button2.Root.Sound:Play()
			local i = getIndex(slotM1)
			slotM1.Button2.Button.Part.BrickColor = colors[i]
			slotM1.Button2.Button.Rim.BrickColor = colors[i]
			wait(0.5)
			slotM1.Button2.PrismaticConstraint.MotorMaxForce = slotM1.mf2 + 600
			wait(0.25)
			slotM1.Button2.PrismaticConstraint.MotorMaxForce = slotM1.mf2
			wait()
			slotM1.Debounce2 = true
		end
	end
end)
--SLOT MACHINE 2
slotM2.Button1.Button.Rim.Touched:Connect(function(hit)
	if slotM2.Debounce1 and _turn == false then
		local char = hit.Parent:FindFirstChild("Humanoid") and hit.Parent or nil
		if char then
			slotM2.Debounce1 = false
			slotM2.Button1.Root.Sound:Play()
			
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
				spawn(function() robot1:fireBots(robot2) end)
				robot2:fireBots(robot1)
			end
			wait(2) -- wait before swapping turns too quickly
			_turn = not _turn
			showTurn(_turn)
			
			slotM2.Button1.PrismaticConstraint.MotorMaxForce = slotM2.mf1 + 1000
			wait(0.25)
			slotM2.Button1.PrismaticConstraint.MotorMaxForce = slotM2.mf1
			wait()
			slotM2.Debounce1 = true
		end
	end
end)
slotM2.Button2.Button.Rim.Touched:Connect(function(hit)
	if slotM2.Debounce2 then
		local char = hit.Parent:FindFirstChild("Humanoid") and hit.Parent or nil
		if char then
			slotM2.Debounce2 = false
			slotM2.Button2.Root.Sound:Play()
			local i = getIndex(slotM2)
			slotM2.Button2.Button.Part.BrickColor = colors[i]
			slotM2.Button2.Button.Rim.BrickColor = colors[i]
			wait(0.5)
			slotM2.Button2.PrismaticConstraint.MotorMaxForce = slotM2.mf2 + 600
			wait(0.25)
			slotM2.Button2.PrismaticConstraint.MotorMaxForce = slotM2.mf2
			wait()
			slotM2.Debounce2 = true
		end
	end
end)