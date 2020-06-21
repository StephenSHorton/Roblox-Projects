local LocalPlayer = game:GetService("Players").LocalPlayer
local AnnounceEvent = game:GetService("ReplicatedStorage"):WaitForChild("AnnounceEvent")
local announceGui = LocalPlayer.PlayerGui:WaitForChild("Announce Gui")
local announcedMsg = announceGui:WaitForChild("Announcement Box"):WaitForChild("Message")
local inputMenu = announceGui:WaitForChild("Input Menu")
local input = inputMenu:WaitForChild("Input")
local submit = inputMenu:WaitForChild("Submit")
local comm = workspace:WaitForChild("Comm")

local submitDebounce = true
submit.MouseButton1Click:Connect(function()
	if submitDebounce then
-- The submit button is unlocked after the message is done (AnnounceEvent.OnClientEvent)
		submitDebounce = false
		AnnounceEvent:FireServer(input.Text)
		inputMenu.Visible = false
		input.Text = ""
	end
end)

comm.ClickDetector.MouseClick:Connect(function(plr)
	if plr.Name == "Roger111" or plr.Name == "bt6k" or "Player 1"  then
		inputMenu.Visible = true
	end
end)

AnnounceEvent.OnClientEvent:Connect(function(msg)
	for i=1,#msg do
		wait(0.1)
		announcedMsg.Text = string.sub(msg,1,i)
	end
	wait(3)
	announcedMsg.Text = ""
	submitDebounce = true
end)