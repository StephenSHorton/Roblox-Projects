local level1 = false
local level2 = false
local level3 = false
local level4 = false

local spawnLocations = workspace:WaitForChild("Creep Spawns")

local CREEPS = {}
	function CREEPS.test()
		local test = true
		spawn(function()
			while test do
				if test == true then
					local creepGroup = game.Lighting:FindFirstChild("Creeps"):FindFirstChild("Test"):GetChildren()
					for i, group in pairs(creepGroup) do
						group.Parent = workspace
						group:MoveTo(spawnLocations:FindFirstChild("Lane 1").Position)
					end
					for i, group in pairs(creepGroup) do
						for i, npc in pairs(group:GetChildren()) do
							npc:FindFirstChild("TargetFinder").Disabled = false
						end
					end
				end
				wait(10)
			end
		end)
	end
	function CREEPS.start()
		level1 = true
		local creepGroups = game.Lighting:FindFirstChild("Creeps"):FindFirstChild("Level 1"):GetChildren()
		local spawnLocationList = spawnLocations:GetChildren()
		spawn(function()
			while level1 == true do
				if level1 == true then
					if #creepGroups == 0 then
					creepGroups = game.Lighting:FindFirstChild("Creeps"):FindFirstChild("Level 1"):GetChildren()
					end
					--spawn group in appropriate lanes
					local creepGroup = creepGroups[1]:Clone()
					creepGroup.Parent = workspace
					creepGroup:MoveTo(spawnLocations:FindFirstChild("Lane 1").Position)
					for i, npc in pairs(creepGroup:GetChildren()) do
						npc:FindFirstChild("TargetFinder").Disabled = false
					end
					table.remove(creepGroups,1)
				end
				wait(10)
			end
		end)
	end
return CREEPS
