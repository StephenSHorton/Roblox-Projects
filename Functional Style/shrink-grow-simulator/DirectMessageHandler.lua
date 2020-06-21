local DirectMessage = game:GetService("ReplicatedStorage"):WaitForChild("DirectMessage")
local LocalPlayer = game.Players.LocalPlayer
local gui = LocalPlayer.PlayerGui:WaitForChild("DirectMessage")

function handleMessage(msg)
	local messageLabel = gui.TextLabel:Clone()
	messageLabel.Text = msg
	messageLabel.Parent = gui
	messageLabel.Visible = true
	wait(3)
	messageLabel:Destroy()
end

DirectMessage.OnClientEvent:Connect(handleMessage)