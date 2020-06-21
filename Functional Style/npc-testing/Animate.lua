local AttackEvent = workspace:WaitForChild("AttackEvent")
local myChar = script.Parent
local myHumanoid = myChar:WaitForChild("Humanoid")
local readyToMove = myChar:WaitForChild("ReadyToMove")
local CurrentSlot = myChar:WaitForChild("CurrentSlot")

	local runAnimation = script:WaitForChild("Run")
	local runAnimTrack = myHumanoid:LoadAnimation(runAnimation)
	local walkAnimation = script:WaitForChild("Walk")
	local walkAnimTrack = myHumanoid:LoadAnimation(walkAnimation)
	local attackAnimation = script:WaitForChild("Attack")
	local attackAnimTrack = myHumanoid:LoadAnimation(attackAnimation)

	local currentAnimation = runAnimTrack
	local isRunning = false
	local isWalking = false

myHumanoid.Running:Connect(function(speed)
	if speed <= 8 and speed >= 1 and isWalking ~= true then
		isWalking = true
		isRunning = false
		currentAnimation:Stop()
		currentAnimation = walkAnimTrack
		walkAnimTrack:Play()
	elseif speed > 8 and isRunning ~= true then
		isWalking = false
		isRunning = true
		currentAnimation:Stop()
		currentAnimation = runAnimTrack
		runAnimTrack:Play()
	elseif speed < 1 then
		isWalking = false
		isRunning = false
		currentAnimation:Stop()
	end
end)

AttackEvent.Event:Connect(function(whom)
	if whom == myChar then
		attackAnimTrack:Play()
	end
end)

myHumanoid.Died:Connect(function()
	myChar.Parent = workspace
	readyToMove.Value = false
	CurrentSlot.Value.Value = false
	wait(2)
	for i,part in ipairs(myChar:GetDescendants()) do
		if part:IsA('BasePart') then
			part.Anchored = true
			part.CanCollide = false
		end
	end
	wait(2)
	for i,part in ipairs(myChar:GetDescendants()) do
		if part:IsA('BasePart') then
			spawn(function()
				for i= 0,1,0.01 do
					part.Transparency = i
					wait()
				end
			end)
		end
	end
	myChar:Destroy()
end)