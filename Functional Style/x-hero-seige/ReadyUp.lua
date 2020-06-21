local readyUpEvent = game:GetService("ReplicatedStorage"):WaitForChild("ReadyUpEvent")
local readyCount = 0
local playerTable = {}
local intermissionScreen = game:GetService("Workspace"):WaitForChild("IntermissionScreen")
local minimumPlayers = 1
intermissionScreen.SurfaceGui.Frame.Minimum.Text = minimumPlayers

local READYUP = {}
	function READYUP.check(player)
		if not player then
			readyUpEvent:FireAllClients(#playerTable)
			return
		end
		for i, plr in pairs(playerTable) do
			if plr.Name == player.Name then
				table.remove(playerTable,player)
				readyUpEvent:FireAllClients(#playerTable)
				readyCount = readyCount - 1
				if readyCount >= minimumPlayers then
					return playerTable
				else
					return false
				end
			end
		end
		table.insert(playerTable,player)
		readyUpEvent:FireAllClients(#playerTable)
		readyCount = readyCount + 1
		if readyCount >= minimumPlayers then
			return playerTable
		else
			return false
		end
	end
return READYUP
