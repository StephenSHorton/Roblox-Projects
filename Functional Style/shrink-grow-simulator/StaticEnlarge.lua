local TweenService = game:GetService("TweenService")
local touchPart = script.Parent:WaitForChild("Touch Part")
local barrier = script.Parent:WaitForChild("_Barrier")
local startPad = script.Parent:WaitForChild("StartPad")
local finishPad = script.Parent:WaitForChild("FinishPad")
local billboard = touchPart:WaitForChild("BillboardGui")

	local debounce = true

local function getTouchingParts(part)
   local connection = part.Touched:Connect(function() end)
   local results = part:GetTouchingParts()
   connection:Disconnect()
   return results
end

function barrierTween()
	local tweenInfo = TweenInfo.new(
		8,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	)
	local tweens = {}
	for i,part in ipairs(barrier:GetChildren()) do
		local tween = TweenService:Create(part,tweenInfo,{ Position = part.Position, Transparency = 0 })
		part.Position = part.Position + Vector3.new(0,25,0)
		table.insert(tweens,tween)
	end
	for i,tween in ipairs(tweens) do
		tween:Play()
	end
	tweens[#tweens].Completed:wait()
	for i,part in ipairs(barrier:GetChildren()) do
		part.CanCollide = true
	end
end

function barrierReset()
	for i,part in ipairs(barrier:GetChildren()) do
		part.CanCollide = false
		part.Transparency = 1
	end
end

function countDown()
	wait(5)
	billboard.Enabled = true
	spawn(function()
		for i=30,0,-1 do
			billboard.TextLabel.Text = i
			wait(1)
		end
		script.Parent:FindFirstChild("_Enlarged Model"):Destroy()
		script.Parent:FindFirstChild("_Enlarged Clones"):Destroy()
		billboard.Enabled = false
		debounce = true
	end)
end

function scaleHumanoid(humanoid,scales)
	humanoid.BodyHeightScale.Value = scales.BodyHeightScale
	humanoid.BodyWidthScale.Value = scales.BodyWidthScale
	humanoid.BodyDepthScale.Value = scales.BodyDepthScale
	humanoid.HeadScale.Value = scales.HeadScale
	for i,v in pairs (humanoid.Parent:GetChildren()) do
		if v:IsA("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = humanoid.Parent
		end
	end
end

function staticCopy(parts)
	local model = Instance.new("Model")
	model.Name = "_Enlarged Model"
	local model2 = Instance.new("Model")
	model2.Name = "_Enlarged Clones"
	local primaryP = Instance.new("Part")
	primaryP.Size = Vector3.new(2,2,2)
	primaryP.Transparency = 1
	primaryP.Anchored = true
	primaryP.CanCollide = false
	primaryP.CFrame = startPad.CFrame + Vector3.new(0,1.5,0)
	primaryP.Parent = model
	model.PrimaryPart = primaryP
	local playerChars = {}
	local moveParts = {}
	for i, part in pairs(parts) do
		if part.Name == "_Potato" then
			part:Destroy()
		else
			local humanoid = part.Parent:FindFirstChild("Humanoid") or part.Parent.Parent:FindFirstChild("Humanoid")
			if part ~= startPad and part.Parent.Name ~= "_Barrier" and humanoid == nil then
				local clonedPart = part:Clone()
				clonedPart.Anchored = true
				clonedPart.CanCollide = true
				clonedPart.Parent = model
			elseif humanoid and table.find(playerChars,humanoid.Parent) == nil then
				local movePart = Instance.new("Part")
				movePart.Size = humanoid.Parent.PrimaryPart.Size
				movePart.CFrame = humanoid.Parent.PrimaryPart.CFrame
				movePart.Name = humanoid.Parent.Name
				movePart.Anchored = true
				movePart.Transparency = 1
				movePart.CanCollide = false
				movePart.Parent = model
				moveParts[humanoid.Parent.Name] = movePart
				table.insert(playerChars,humanoid.Parent)
			end
		end
	end
	local dilationCentre = finishPad.Position
	local scaleFactor = 4
	for i , part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local mesh = part:FindFirstChild("Mesh")
			if mesh ~= nil then
				mesh.Scale = mesh.Scale * scaleFactor
			end
			if part.Name ~= "Head" then
				local partPos = part.Position
				local offset = partPos - dilationCentre
				offset = offset * scaleFactor
				part.Position = dilationCentre + offset
				part.Size = part.Size * scaleFactor
			else
				local partPos = part.Position
				local offset = partPos - dilationCentre
				offset = offset * scaleFactor
				part.Position = dilationCentre + offset
				part.Size = part.Size * scaleFactor * 0.4--For the player's head
			end
		end
	end
	model2.Parent = script.Parent
	model.Parent = script.Parent
	model:SetPrimaryPartCFrame(finishPad.CFrame+Vector3.new(0,4.5,0))
	model["EPIC DUCK"].Position = model["EPIC DUCK"].Position + Vector3.new(0,1.5,0)
	for _,plrChar in ipairs(playerChars) do
		plrChar.Archivable = true
		local origScales = {
			BodyHeightScale = plrChar.Humanoid.BodyHeightScale.Value,
			BodyWidthScale = plrChar.Humanoid.BodyWidthScale.Value,
			BodyDepthScale = plrChar.Humanoid.BodyDepthScale.Value,
			HeadScale = plrChar.Humanoid.HeadScale.Value
		}
		local newScales = {
			BodyHeightScale = plrChar.Humanoid.BodyHeightScale.Value * scaleFactor,
			BodyWidthScale = plrChar.Humanoid.BodyWidthScale.Value * scaleFactor,
			BodyDepthScale = plrChar.Humanoid.BodyDepthScale.Value * scaleFactor,
			HeadScale = plrChar.Humanoid.HeadScale.Value * scaleFactor
		}
		scaleHumanoid(plrChar.Humanoid,newScales)
		local clone = plrChar:Clone()
		for i,v in ipairs(clone:GetDescendants()) do
			if v:IsA("Script") or v:IsA("LocalScript") then
				v:Destroy()
			elseif v:IsA("BasePart") then
				v.Anchored = true
				if v.Name ~= "HumanoidRootPart" then
					v.Transparency = 0
				end
			elseif v:IsA("Humanoid") then
				v.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			end
		end
		clone.Name = plrChar.Name .. " _Clone"
		clone.Parent = model2
		scaleHumanoid(plrChar.Humanoid,origScales)
		clone:SetPrimaryPartCFrame(moveParts[plrChar.Name].CFrame)
		plrChar.Archivable = false
	end
	barrierReset()
end

touchPart.Touched:Connect(function(thing)
	if debounce and thing.Parent:FindFirstChild("Humanoid") then
		debounce = false
		barrierTween()
		countDown()
		staticCopy(getTouchingParts(touchPart))
	end
end)