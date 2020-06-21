
local replicatedStorage = game:GetService("ReplicatedStorage")
local guiEvent = replicatedStorage.GuiEvent
local guiControl = {}
	function guiControl.printAll(command,what)
		guiEvent:FireAllClients(command,what)
	end
	function guiControl.initializeGui(playerList)
		for i, player in pairs(playerList) do
			guiEvent:FireClient(player,"initialize")
		end
	end
	function guiControl.printPlayer(player,command,what)
		guiEvent:FireClient(player,command,what)
	end
return guiControl