wait()
local localPlayer = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local fogOfWarEvent = replicatedStorage:FindFirstChild("FogOfWarEvent")

fogOfWarEvent.OnClientEvent:Connect(function(playerList)
	--Hide other players from playerList from this player
	for i, player in pairs(playerList) do
		if player.Name ~= localPlayer.Name then
			for i, part in pairs(player.Character:GetChildren()) do
				part:Destroy()
			end
		end
	end
	--Hide other players' buildings from this player unless they are within a certain distance
end)