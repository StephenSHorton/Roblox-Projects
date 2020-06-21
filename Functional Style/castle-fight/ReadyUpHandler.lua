local GuiControl = game.ReplicatedStorage.GuiControl
local READY_UP_HANDLER = {}
	function READY_UP_HANDLER.setReady(plr,value)
		local plrReady = workspace["Players Ready"]:FindFirstChild(plr)
		if plrReady ~= nil then
			plrReady.Value = value
		end
		GuiControl:FireAllClients("Display Readies")
	end

	function READY_UP_HANDLER.setupListener()
		GuiControl.OnServerEvent:Connect(function(plr,gui,value)
			if gui == "READY_UP_HANDLER" then
				READY_UP_HANDLER.setReady(plr.Name,value)
			end
		end)
	end
return READY_UP_HANDLER
