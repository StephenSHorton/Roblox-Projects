local AnnounceEvent = game:GetService("ReplicatedStorage"):WaitForChild("AnnounceEvent")

AnnounceEvent.OnServerEvent:Connect(function(plr,msg)
	local m = plr.Name .. ": " .. msg
	AnnounceEvent:FireAllClients(m)
end)