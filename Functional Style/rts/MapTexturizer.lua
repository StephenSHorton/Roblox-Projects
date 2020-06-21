wait()
local materialTable = {Enum.Material.Grass,Enum.Material.Grass,Enum.Material.Grass,Enum.Material.Grass}
local colorTable = {BrickColor.new("Bright green"),BrickColor.new("Sea green"),BrickColor.new("Dark green"),BrickColor.new("Shamrock")}

local function randomChange(var)
	local number = math.random(4)
	if number == 0 then
		repeat wait()
			number = math.random(4)
		until number ~= 0
	end
	if var == "Material" then
		return materialTable[number]
	end
	if var == "BrickColor" then
		return colorTable[number]
	end
end

for i, model in pairs(script.Parent:GetChildren()) do
	if model.Name == "Grid 100x100" then
		for i, thing in pairs(model:GetChildren()) do
			if thing.Name == "Grid" then
				wait(0.005)
				thing.BrickColor = randomChange("BrickColor")
				thing.Material = randomChange("Material")
			elseif thing.Name == "TreeGrid" then
				wait(0.005)
				for i, part in pairs(thing.Tree:GetChildren()) do
					part.Transparency = 0
					if part.BrickColor == BrickColor.new("Dark green") then
						part.Material = Enum.Material.Grass
					else
						part.Material = Enum.Material.Wood
						part.Size = part.Size / Vector3.new(2,1,2)
					end
				end
				thing.Grid.BrickColor = randomChange("BrickColor")
				thing.Grid.Material = randomChange("Material")
				thing.Grid.Name = "TreeGrid"
			end
		end
	end
end