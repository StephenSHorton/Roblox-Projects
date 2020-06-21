local map = script.Parent
function addBeams()
	for i,cell in ipairs(map:GetChildren()) do
		if cell:IsA("BasePart") then
			local pathBeam = Instance.new("Beam")
			pathBeam.Name = "Path"
			pathBeam.Width0 = 0.2
			pathBeam.Width1 = 0.2
			pathBeam.FaceCamera = true
			pathBeam.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), -- white
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)), -- white
				}
			)
			local regSiz = 12
			local min = cell.Position+Vector3.new(-10,-regSiz,-regSiz)
			local max = cell.Position+Vector3.new(10,regSiz,regSiz)
			local region = Region3.new(min,max)
		--		local regionPart = Instance.new("Part")
		--		regionPart.Size = region.Size
		--		regionPart.BrickColor = BrickColor.new("Bright red")
		--		regionPart.Transparency = 0.9
		--		regionPart.Material = Enum.Material.Neon
		--		regionPart.CFrame = cell.CFrame - Vector3.new(0,1,0)
		--		regionPart.Anchored = true
		--		regionPart.CanCollide = false
		--		regionPart.Name = "Region"
		--		regionPart.Parent = cell
			for i,thing in ipairs(workspace:FindPartsInRegion3(region,nil,math.huge)) do
				if string.sub(thing.Name,1,4) == "Cell" and thing~= cell then
					local pathBeamClone = pathBeam:Clone()
					pathBeamClone.Attachment0 = cell.Attachment
					pathBeamClone.Attachment1 = thing.Attachment
					pathBeamClone.Parent = cell
				end
			end
			region = nil
		end
	end
end
function removeBeams()
	for i,cell in ipairs(map:GetChildren()) do
		if cell:IsA("BasePart") then
			for x,v in ipairs(cell:GetChildren()) do
				if v:IsA("Beam") then
					v:Destroy()
				end 
			end
		end
	end
end
removeBeams()
--addBeams()