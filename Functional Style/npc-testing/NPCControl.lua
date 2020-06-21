--NOTES: You can change the kind of npc that is affected by this script simply by adding more npc folders to the workspace and searching them separately
local PhysicsService = game:GetService("PhysicsService")
PhysicsService:CreateCollisionGroup("NoCollide")
PhysicsService:CollisionGroupSetCollidable("NoCollide","NoCollide",false)
for i,npc in ipairs(workspace:WaitForChild("NPCS"):GetChildren()) do
	for i,thing in ipairs(npc:GetDescendants()) do
		if thing:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(thing, "NoCollide")
		end
	end
end
local Players = game:GetService("Players")
local module = require(script:WaitForChild("ModuleScript"))

Players.PlayerAdded:Connect(function(plr)--Note: If a player is added to the game and they don't have these slots, make sure npc's know that
	local char = plr.Character or plr.CharacterAdded:wait()
	spawn(function()
		wait(3)
		for i,thing in ipairs(char:GetDescendants()) do
			if thing:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(thing, "NoCollide")
			end
		end
	end)
	local slotFolder = Instance.new("Folder")
	slotFolder.Name = "Slots"
	slotFolder.Parent = char
	
	for i=1,8 do
		local slot = Instance.new("BoolValue")
		slot.Name = i
		slot.Parent = slotFolder
	end
end)

while true do
	local npcs = module.getReadyToMoveNPCS()
	if #npcs > 0 then
		local targets = module.getTargets()
		if targets ~= nil then
			local pairedObjects = module.matchTargetsAndNPCS(npcs,targets)
			module.pathToTargets(pairedObjects)
		end
	end
	wait(1)
end