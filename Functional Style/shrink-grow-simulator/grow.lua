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
		humanoid.BodyHeightScale.Value = scale
		humanoid.BodyWidthScale.Value = scale
		humanoid.BodyDepthScale.Value = scale
		humanoid.HeadScale.Value = scale
	elseif operation == "/" then
		humanoid.BodyHeightScale.Value = scale
		humanoid.BodyWidthScale.Value = scale
		humanoid.BodyDepthScale.Value = scale
		humanoid.HeadScale.Value = scale
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

function grow(plrChar)
	if plrChar.Humanoid.BodyHeightScale.Value * 1.5 > 10 then
		DirectMessage:FireClient(game.Players:GetPlayerFromCharacter(plrChar),"You can't grow anymore")
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
	local newSize = plrChar.Humanoid.BodyHeightScale.Value * 1.5
	local _size = plrChar.PrimaryPart.Size.Y*2
	plrChar.PrimaryPart.Anchored = true
	plrChar:SetPrimaryPartCFrame(startPad.CFrame + Vector3.new(0,_size,0))
	for i,thing in ipairs(plrChar:GetDescendants()) do
		if thing.Name == "_Potato" then
			thing:Destroy()
		end
	end
	
	for i=plrChar.Humanoid.BodyHeightScale.Value,0.01,-increment do
		scaleHumanoid(plrChar.Humanoid,"/",i)
		wait()
	end
	transparentify(plrChar,"Invisible")
	plrChar:SetPrimaryPartCFrame(finishPad.CFrame + Vector3.new(0,_size*2,0))
	glass.BrickColor = BrickColor.new("Lime green")
	debounce = true
	transparentify(plrChar,"Visible")
	for i=increment,newSize,increment do
		scaleHumanoid(plrChar.Humanoid,"*",i)
		wait()
	end
	plrChar.Humanoid.WalkSpeed = plrChar.Humanoid.WalkSpeed + 20 / 12
	plrChar.Humanoid.JumpPower = plrChar.Humanoid.JumpPower + 50 / 16
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
		grow(plrChar)
	end
end)