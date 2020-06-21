local TweenService = game:GetService("TweenService")
local me = script.Parent
local touchPart = me:WaitForChild("Touch Part")
local tunnel = me:WaitForChild("Tunnel")
local light1 = me:WaitForChild("Light1")
local electricity = tunnel:WaitForChild("Electricity")
local finishSound = tunnel:WaitForChild("Finish")
local meshId = script.Mesh.MeshId
local textureId = script.Mesh.TextureId

function potatify(plrChar)
	electricity:Play()
	plrChar.PrimaryPart.Anchored = true
	plrChar:SetPrimaryPartCFrame(touchPart.CFrame*CFrame.Angles(0,math.rad(180),0))
	for i,thing in ipairs(plrChar:GetDescendants()) do
		if thing:IsA("BasePart") then
			thing.Transparency = 1
		end
	end
	local originalHumanoidSizeX = plrChar.Humanoid.BodyWidthScale.Value
	local originalHumanoidSizeY = plrChar.Humanoid.BodyHeightScale.Value
	local originalHumanoidSizeZ = plrChar.Humanoid.BodyDepthScale.Value
	local torso = plrChar:FindFirstChild("Torso") or plrChar:FindFirstChild("UpperTorso")
	local potatoMesh = Instance.new("FileMesh")
	potatoMesh.MeshId = meshId
	potatoMesh.TextureId = textureId
	potatoMesh.Name = "Potato Mesh"
	potatoMesh.Scale = Vector3.new(0.1,0.1,0.1)
	local potatoPart = Instance.new("Part")
	potatoPart.Transparency = 1
	potatoPart.Name = "_Potato"
	potatoPart.Size = Vector3.new(5,5,5)
	potatoPart.Size = plrChar.HumanoidRootPart.Size * 2
	potatoPart.CFrame = torso.CFrame*CFrame.Angles(0,math.rad(180),0)
	potatoPart.CanCollide = false
	potatoMesh.Parent = potatoPart
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = potatoPart
	weld.Part1 = torso
	weld.Parent = potatoPart
	potatoPart.Parent = plrChar
	local tweenInfo = TweenInfo.new(
		4,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	)
	local tween = TweenService:Create(potatoMesh,tweenInfo,{ Scale = Vector3.new(originalHumanoidSizeX*script.Mesh.Scale.X,originalHumanoidSizeY*script.Mesh.Scale.Y,originalHumanoidSizeZ*script.Mesh.Scale.Z) })
	spawn(function()
		for i=1,0,-0.01 do
			potatoPart.Transparency = i
			wait()
		end
		potatoPart.Transparency = 0
	end)
	tween:Play()
	tween.Completed:wait()
end

function dePotatoify(plrChar)
	electricity:Play()
	plrChar.PrimaryPart.Anchored = true
	plrChar:SetPrimaryPartCFrame(touchPart.CFrame*CFrame.Angles(0,math.rad(180),0))
	for i,thing in ipairs(plrChar:GetDescendants()) do
		if thing:IsA("BasePart") and thing.Name ~= "HumanoidRootPart" then
			spawn(function()
				for i=1,0,-0.01 do
					thing.Transparency = i
					wait()
				end
				thing.Transparency = 0
			end)
			thing.Transparency = 0
		end
	end
	local torso = plrChar:FindFirstChild("Torso") or plrChar:FindFirstChild("UpperTorso")
	local potatoPart = plrChar:FindFirstChild("_Potato")
	local potatoMesh = potatoPart:FindFirstChild("Potato Mesh")
	local tweenInfo = TweenInfo.new(
		4,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	)
	local tween = TweenService:Create(potatoMesh,tweenInfo,{ Scale = Vector3.new(0.1,0.1,0.1) })
	spawn(function()
		for i=0,1,0.01 do
			potatoPart.Transparency = i
			wait()
		end
		potatoPart.Transparency = 1
	end)
	tween:Play()
	tween.Completed:wait()
	potatoPart:Destroy()
end

local debounce = true
function moveOutOfMachine(plrChar)
	local tweenInfo = TweenInfo.new(
			1,
			Enum.EasingStyle.Linear,
			Enum.EasingDirection.Out,
			0,
			false,
			0
		)
	local finishTransform = TweenService:Create(plrChar.PrimaryPart,tweenInfo,{ CFrame = plrChar.PrimaryPart.CFrame + (plrChar.PrimaryPart.CFrame.LookVector*10) })
	finishTransform:Play()
	finishTransform.Completed:wait()
	plrChar.PrimaryPart.Anchored = false
	debounce = true
end

touchPart.Touched:Connect(function(thing)
	if debounce and thing.Parent:FindFirstChild("Humanoid") then
		local plrChar = thing.Parent
		if plrChar:FindFirstChild("_Potato") then
			debounce = false
			local originalColor = tunnel.BrickColor
			spawn(function()
				while debounce == false do
					tunnel.BrickColor = BrickColor.random()
					wait()
				end
				tunnel.BrickColor = originalColor
			end)
			light1.BrickColor = BrickColor.new("Really red")
			dePotatoify(plrChar)
			light1.BrickColor = BrickColor.new("Lime green")
			electricity:Stop()
			finishSound:Play()
			moveOutOfMachine(plrChar)
		else
			debounce = false
			local originalColor = tunnel.BrickColor
			spawn(function()
				while debounce == false do
					tunnel.BrickColor = BrickColor.random()
					wait()
				end
				tunnel.BrickColor = originalColor
			end) 
			light1.BrickColor = BrickColor.new("Really red")
			potatify(plrChar)
			light1.BrickColor = BrickColor.new("Lime green")
			electricity:Stop()
			finishSound:Play()
			moveOutOfMachine(plrChar)
		end
	end
end)