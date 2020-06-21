local cameraEvent = game:GetService("ReplicatedStorage"):WaitForChild("CameraEvent")
local readyUpEvent = game:GetService("ReplicatedStorage"):WaitForChild("ReadyUpEvent")
local localPlayer = game:GetService("Players").LocalPlayer
local localCamera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local cameras = game:GetService("Workspace"):WaitForChild("Cameras")
local charCheck = localPlayer.Character or localPlayer.CharacterAdded:Wait()

local startScreen = game:GetService("Workspace"):WaitForChild("StartScreen")
local intermissionScreen = game:GetService("Workspace"):WaitForChild("IntermissionScreen")

local idleStopper = true
local generalDebounce = false
local currentTween

--RunService.RenderStepped:Wait()
repeat wait()
	localCamera.CameraType = Enum.CameraType.Scriptable
until localCamera.CameraType == Enum.CameraType.Scriptable

function intro()
	--To Do
end
function idle()
	local tweenInfo = TweenInfo.new(
		2, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		true, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local tweenInfo2 = TweenInfo.new(
		2, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		true, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local tween = TweenService:Create(localCamera, tweenInfo, {CFrame = localCamera.CoordinateFrame * CFrame.fromEulerAnglesXYZ(0,math.rad(1),0)})
	local tween2 = TweenService:Create(localCamera, tweenInfo, {CFrame = localCamera.CoordinateFrame * CFrame.fromEulerAnglesXYZ(0,math.rad(-1),0)})
	while true do
		if idleStopper then
			tween:Play()
			currentTween = tween
			tween.Completed:Wait()
			if idleStopper then
				tween2:Play()
				currentTween = tween2
				tween2.Completed:Wait()
			else
				break
			end
		else
			break
		end
	end
end
function lanePreview()
	idleStopper = false
	wait(1)
	intermissionScreen.SurfaceGui.Enabled = false
	intermissionScreen.PointLight:Destroy()
	local num = 7 --Speed of lanePreview
	local easing = Enum.EasingStyle.Linear
	local tweenInfo = TweenInfo.new(
		num, -- Time
		easing, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local tween = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.LaneCam1.CFrame})
	local tween2 = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.LaneCam2.CFrame})
	local tween3 = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.LaneCam3.CFrame})
	local tween4 = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.LaneCam4.CFrame})
	local tween5 = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.MainMenu2.CFrame})
	tween:Play()
	local tutorial = localPlayer.PlayerGui:FindFirstChild("Tutorial")
	local specialEventTimer = localPlayer.PlayerGui:FindFirstChild("SpecialEventTimer")
	local waveTimer = localPlayer.PlayerGui:FindFirstChild("WaveTimer")
	spawn(function()
		local t = 7
		local w = 5
		tutorial.Text1.Visible = true
		wait(7)
		tutorial.Text1.Visible = false
		tutorial.Text2.Visible = true
		wait(t)
		tutorial.Text2.Visible = false
		tutorial.Text3.Visible = true
		wait(t)
		tutorial.Text3.Visible = false
		tutorial.Text4.Visible = true
		wait(t)
		tutorial.Text4.Visible = false
		tutorial.Text5.Visible = true
		waveTimer.Enabled = true
		wait(w)
		waveTimer.Enabled = false
		tutorial.Text5.Visible = false
		tutorial.Text6.Visible = true
		specialEventTimer.Enabled = true
		wait(w)
		specialEventTimer.Enabled = false
		tutorial.Text6.Visible = false
		tutorial.Text7.Visible = true
		wait(t)
		tutorial.Text7.Visible = false
		tutorial.Text8.Visible = true
		wait(w)
		tutorial.Text8.Visible = false
	end)
	currentTween = tween
	tween.Completed:Wait()
	num = 6
	tween2:Play()
	currentTween = tween
	tween2.Completed:Wait()
	tween3:Play()
	currentTween = tween
	tween3.Completed:Wait()
	tween4:Play()
	currentTween = tween
	tween4.Completed:Wait()
	easing = Enum.EasingStyle.Quad
	tween5:Play()
	currentTween = tween
	tween5.Completed:Wait()
	idle()
	wait(4)
	cameraEvent:FireServer()
end
function mainMenu()
	localCamera.CFrame = cameras.MainMenu1.CFrame
	startScreen.SurfaceGui.Enabled = true
	local tweenInfo = TweenInfo.new(
		6, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0.5 -- DelayTime
	)
	local tween = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.MainMenu2.CFrame})
	tween:Play()
	currentTween = tween
	tween.Completed:Connect(idle)
end
function returnToPlayer()
	idleStopper = true
	wait(1)
	local tweenInfo = TweenInfo.new(
		4, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local head = localPlayer.Character.Head
	local tween = TweenService:Create(localCamera, tweenInfo,
		{CFrame = ((head.CFrame - head.CFrame.LookVector*12)*CFrame.fromEulerAnglesXYZ(math.rad(-23),0,0))+ Vector3.new(0,5,0)})
	tween:Play()
	currentTween = tween
	tween.Completed:Wait()
	repeat wait()
		localCamera.CameraType = Enum.CameraType.Custom
	until localCamera.CameraType == Enum.CameraType.Custom
	intermissionScreen.SurfaceGui.Enabled = false
	idleStopper = false
end
function readyUpdate(num)
	local totalPlrs =  game:GetService("Players").NumPlayers
	local text = intermissionScreen.SurfaceGui.Frame.ReadyPlayers
	text.Text = (num .. '/' .. totalPlrs)
end
function alert(message)
	local alertGui = localPlayer.PlayerGui:FindFirstChild("Alert")
	alertGui.TextLabel.Text = message
	alertGui.Enabled = true
	wait(3)
	alertGui.Enabled = false
end
-------------------------------------------------MAIN MENU CONTROL---------------------------------------------------------------
local button = startScreen.SurfaceGui.Frame.Play
local light = Instance.new("PointLight")
light.Brightness = 4
light.Range = 17

local lightClone = light:Clone()
lightClone.Parent = startScreen

local function playButton()
	currentTween:Cancel()
	spawn(function() wait(1);startScreen.SurfaceGui.Enabled = false end)
	light:Destroy()
	intermissionScreen.SurfaceGui.Enabled = true
	local tweenInfo = TweenInfo.new(
		3, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local tween = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.MainMenu3.CFrame})
	tween:Play()
	readyUpEvent:FireServer()
	tween.Completed:Wait()
	generalDebounce = false
	idleStopper = true
	idle()
end

button.MouseButton1Click:Connect(function()
	if generalDebounce then return end
	generalDebounce = true
	idleStopper = false
	currentTween:Cancel()
	lightClone.Parent = intermissionScreen
	button.Image = 'rbxassetid://3109934055'
	playButton()
end)
button.MouseButton1Down:Connect(function()
	button.Image = 'rbxassetid://3110163083'
	button.MouseLeave:Connect(function()
		button.Image = 'rbxassetid://3109934055'
	end)
	button.MouseButton1Up:Connect(function()
		button.Image = 'rbxassetid://3109934055'
	end)
end)
----------------------------------------------------INTERMISSION CONTROL-------------------------------------------------------
local notReadyButton = intermissionScreen.SurfaceGui.Frame["Not Ready"]
local function notReady()
	currentTween:Cancel()
	startScreen.SurfaceGui.Enabled = true
	light:Destroy()
	spawn(function() wait(1);intermissionScreen.SurfaceGui.Enabled = false end)
	local tweenInfo = TweenInfo.new(
		3, -- Time
		Enum.EasingStyle.Quad, -- EasingStyle
		Enum.EasingDirection.Out, -- EasingDirection
		0, -- RepeatCount (when less than zero the tween will loop indefinitely)
		false, -- Reverses (tween will reverse once reaching it's goal)
		0 -- DelayTime
	)
	local tween = TweenService:Create(localCamera, tweenInfo, {CFrame = cameras.MainMenu2.CFrame})
	tween:Play()
	readyUpEvent:FireServer()
	tween.Completed:Wait()
	generalDebounce = false
	idleStopper = true
	idle()
end

notReadyButton.MouseButton1Click:Connect(function()
	if generalDebounce then return end
	generalDebounce = true
	idleStopper = false
	currentTween:Cancel()
	lightClone.Parent = startScreen
	notReadyButton.Image = 'rbxassetid://3109934055'
	notReady()
end)
notReadyButton.MouseButton1Down:Connect(function()
	notReadyButton.Image = 'rbxassetid://3110163083'
	notReadyButton.MouseLeave:Connect(function()
		notReadyButton.Image = 'rbxassetid://3109934055'
	end)
	notReadyButton.MouseButton1Up:Connect(function()
		notReadyButton.Image = 'rbxassetid://3109934055'
	end)
end)
-------------------------------------------------------------------------------------------------------------------------------------
cameraEvent.OnClientEvent:Connect(function(command,message)
	if command == "Main Menu" then
		mainMenu()
		return
	end
	if command == "Lane Preview" then
		lanePreview()
		return
	end
	if command == "Return" then
		returnToPlayer()
		return
	end
	if command == "Alert" then
		alert(message)
		return
	end
end)
readyUpEvent.OnClientEvent:Connect(readyUpdate)