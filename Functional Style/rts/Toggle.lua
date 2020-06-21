wait()
local player = game:GetService("Players").LocalPlayer
local mainGui = player.PlayerGui:FindFirstChild("MainGui")
local dockFrame = mainGui:FindFirstChild("BuildDock")
local clickSound = game:GetService("SoundService"):FindFirstChild("Click3")
local button = script.Parent
local onOff = mainGui:WaitForChild("onOff")

button.MouseButton1Click:Connect(function()
	clickSound:Play()
	dockFrame:TweenPosition(UDim2.new(1,-347,1,0),"Out","Quad",1,true)
	onOff.Value = false
end)

button.MouseButton1Click:Connect(function()
	clickSound:Play()
	button.MouseButton1Down:Connect(function()
		script.Parent.Image = 'rbxassetid://3109752369'
		button.MouseLeave:Connect(function()
			script.Parent.Image = 'rbxassetid://3109715524'
		end)
		button.MouseButton1Up:Connect(function()
			script.Parent.Image = 'rbxassetid://3109715524'
		end)
	end)
end)