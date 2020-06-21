wait()
local replicatedStorage = game:GetService("ReplicatedStorage")
local timeEvent = replicatedStorage:FindFirstChild("TimeEvent")
local localPlayer = game:GetService("Players").LocalPlayer
local debounce = false

timeEvent.OnClientEvent:Connect(function(x)--Timer gui
	local textGui = localPlayer.PlayerGui:WaitForChild("Timer"):WaitForChild("TextLabel")
	local timeGui = localPlayer.PlayerGui:WaitForChild("Timer"):WaitForChild("Time")
	local count = x
	local gui = localPlayer.PlayerGui:WaitForChild("Timer")
	gui.Time.Text = tostring(x)
	gui.Enabled = true
	if debounce == false then
		debounce = true
		timeGui:TweenPosition(UDim2.new(0.03,0,0.8,0),"Out","Bounce",1,false)
		wait(0.2)
		textGui:TweenPosition(UDim2.new(0.03,0,0.768,0),"Out","Bounce",1,false)
	end
	if count == 0 then
		timeGui:TweenPosition(UDim2.new(0,-200,0.8,0),"Out","Linear",.5,false)
		textGui:TweenPosition(UDim2.new(0,-200,0.768,0),"Out","Linear",.5,false)
		debounce = false
	end
end)
