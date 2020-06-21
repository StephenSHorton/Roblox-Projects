local DirectMessage = game:GetService("ReplicatedStorage"):WaitForChild("DirectMessage")
local me = script.Parent
local touchPart = me:WaitForChild("TouchPart")
local finishPad = me:WaitForChild("FinishPad")
local startPad = me:WaitForChild("StartPad")
local glass = me:WaitForChild("Glass")
	
	local debounce = true
	local plrDebounces = {}
	
	local minRandom = 0.2
	local maxRandom = 2

function randomExcluded(min, max, excluded)
    local n = math.floor(math.random() * (max-min) + min);
    if (n >= excluded) then
		n = n + 1
	end
    return n
end

function scaleHumanoid(humanoid,operation,scale)
	local scaleFactor = randomExcluded(minRandom,maxRandom,0)
	for i , part in pairs(humanoid.Parent:GetDescendants()) do
		if part:IsA("BasePart") then
			local mesh = part:FindFirstChild("Mesh") or nil
			if mesh ~= nil then
				mesh.Scale = Vector3.new(scaleFactor,scaleFactor,scaleFactor) * scaleFactor
			end
			part.Size = Vector3.new(scaleFactor,scaleFactor,scaleFactor) * scaleFactor
		end
	end
	for i,v in pairs (humanoid.Parent:GetChildren()) do
		if v:IsA("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = humanoid.Parent
		end
	end
end

function distort(plrChar)
	local newSize = 1
	plrChar.PrimaryPart.Anchored = true
	plrChar:SetPrimaryPartCFrame(startPad.CFrame + Vector3.new(0,plrChar.PrimaryPart.Size.Y*3,0))
	
	for x=0,1,0.02 do
		for i,v in ipairs(plrChar:GetDescendants()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = x
			end
		end
		wait()
	end
	for i,v in ipairs(plrChar:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart"  then
			v.Transparency = 1
		end
	end
	
	scaleHumanoid(plrChar.Humanoid,"/",0)
	
	plrChar.Head.Mesh.Scale = Vector3.new(randomExcluded(minRandom,maxRandom,0),randomExcluded(minRandom,maxRandom,0),randomExcluded(minRandom,maxRandom,0))
	
	for i,thing in pairs(plrChar:GetDescendants()) do
		if thing.Name == "_Potato" then
			thing:Destroy()
		elseif thing:IsA("SpecialMesh") then
			thing.Scale = Vector3.new(randomExcluded(0.5,3,0),randomExcluded(0.5,3,0),randomExcluded(0.5,3,0))
		elseif thing:IsA("Accessory") then
			local handle = thing:FindFirstChild("Handle")
			if handle then
				local mesh = handle:FindFirstChild("Mesh")
				if mesh then mesh.Scale = Vector3.new(randomExcluded(minRandom,maxRandom,0),randomExcluded(minRandom,maxRandom,0),randomExcluded(minRandom,maxRandom,0)) end
			end
		end
	end
	
	plrChar:SetPrimaryPartCFrame(finishPad.CFrame + Vector3.new(0,plrChar.PrimaryPart.Size.Y*3,0))
	glass.BrickColor = BrickColor.new("Lime green")
	debounce = true
	
	for x=1,0,-0.02 do
		for i,v in ipairs(plrChar:GetDescendants()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart"  then
				v.Transparency = x
			end
		end
		wait()
	end
	for i,v in ipairs(plrChar:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart"  then
			v.Transparency = 0
		end
	end
	
	plrChar.PrimaryPart.Anchored = false
	wait()
	table.remove(plrDebounces,table.find(plrDebounces,plrChar))
end

touchPart.Touched:Connect(function(thing)
	if debounce and thing.Parent:FindFirstChild("Humanoid") and table.find(plrDebounces,thing.Parent) == nil then
		debounce = false
		table.insert(plrDebounces,thing.Parent)
		glass.BrickColor = BrickColor.new("Really red")
		local plrChar = thing.Parent
		distort(plrChar)
	end
end)