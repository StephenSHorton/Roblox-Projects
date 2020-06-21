local Players = game:GetService("Players")
local TELEPORT_PLAYERS = {}
	function TELEPORT_PLAYERS.start(playerList)
		for i, player in pairs(playerList) do
			if player and Players:FindFirstChild(player.Name) then
				local char = player.Character or player.CharacterAdded:Wait()
				char.PrimaryPart.Position = Vector3.new(284, 88, 28)
			end
		end
	end
return TELEPORT_PLAYERS
