local DirectMessage = game:GetService("ReplicatedStorage"):WaitForChild("DirectMessage")
local me = script.Parent
local touchPart = me:WaitForChild("TouchPart")
local finishPad = me:WaitForChild("FinishPad")
local startPad = me:WaitForChild("StartPad")
local glass = me:WaitForChild("Glass")
	
	local debounce = true
	local plrDebounces = {}

function scaleHumanoid(humanoid,operation,scale)
	if operation == "*" then
		humanoid.BodyDepthScale.Value = scale
	elseif operation == "/" then
		humanoid.BodyDepthScale.Value = scale
	end
	for i,v in pairs (humanoid.Parent:GetChildren()) do
		if v:IsA("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = humanoid.Parent
		end
	end
end

function transparentify(model,state)
	local t
	if state == "Invisible" then
		t = 1
	else
		t = 0
	end
	for i,part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = t
		end
	end
end

function flatten(plrChar)
	if plrChar.Humanoid.BodyDepthScale.Value <= 0.1 then
		DirectMessage:FireClient(game.Players:GetPlayerFromCharacter(plrChar),"You can't flatten anymore")
		glass.BrickColor = BrickColor.new("Lime green")
		debounce = true
		wait(3)
		table.remove(plrDebounces,table.find(plrDebounces,plrChar))
		return
	end
	local increment = 0.01
	if plrChar.Humanoid.BodyHeightScale.Value > 1 and plrChar.Humanoid.BodyHeightScale.Value < 4 then
		increment = 0.05
	elseif plrChar.Humanoid.BodyHeightScale.Value > 4 then
		increment = 0.1
	end
	local newSize = 0.1
	local _size = plrChar.PrimaryPart.Size.Y*2
	plrChar.PrimaryPart.Anchored = true
	plrChar:SetPrimaryPartCFrame(startPad.CFrame + Vector3.new(0,_size,0))
	
	for i=plrChar.Humanoid.BodyHeightScale.Value,0.01,-increment do
		scaleHumanoid(plrChar.Humanoid,"/",i)
		wait()
	end
	
	transparentify(plrChar,"Invisible")
	plrChar:SetPrimaryPartCFrame(finishPad.CFrame + Vector3.new(0,_size,0))
	glass.BrickColor = BrickColor.new("Lime green")
	debounce = true
	transparentify(plrChar,"Visible")
	
	for i=0.01,newSize,increment do
		scaleHumanoid(plrChar.Humanoid,"*",i)
		wait()
	end
	
	plrChar.Head.Mesh.Scale = Vector3.new(plrChar.Head.Mesh.Scale.X,plrChar.Head.Mesh.Scale.Y,0.1)
	
	for i,thing in pairs(plrChar:GetDescendants()) do
		if thing:IsA("FileMesh") or thing:IsA("SpecialMesh") then
			thing.Scale = Vector3.new(thing.Scale.X,thing.Scale.Y,0.1)
		elseif thing:IsA("Accessory") then
			local handle = thing:FindFirstChild("Handle")
			if handle then
				local mesh = handle:FindFirstChild("Mesh")
				if mesh then mesh.Scale = Vector3.new(mesh.Scale.X,mesh.Scale.Y,0.1) end
			end
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
		flatten(plrChar)
	end
end)