wait()
local replicatedStorage = game:GetService("ReplicatedStorage")
local timeEvent = replicatedStorage:FindFirstChild("TimeEvent")
local localPlayer = game:GetService("Players").LocalPlayer
local tween
local textGui = localPlayer.PlayerGui:WaitForChild("Timer"):FindFirstChild("TextLabel")
local timeGui = localPlayer.PlayerGui:WaitForChild("Timer"):FindFirstChild("Time")
tween = timeEvent.OnClientEvent:Connect(function(x)
	tween:Disconnect()
	timeGui:TweenPosition(UDim2.new(0.03,0,0.8,0),"Out","Bounce",1,false)
	wait(0.2)
	textGui:TweenPosition(UDim2.new(0.03,0,0.768,0),"Out","Bounce",1,false)
end)
timeEvent.OnClientEvent:Connect(function(x)--Timer gui
	local count = x
	local gui = localPlayer.PlayerGui:WaitForChild("Timer")
	gui.Time.Text = tostring(x)
	gui.Enabled = true
	if count == 0 then
		gui.Enabled = false
		textGui.Position = UDim2.new(0,-200,0.8,0)
		timeGui.Position = UDim2.new(0,-200,0.8,0)
	end
end)
