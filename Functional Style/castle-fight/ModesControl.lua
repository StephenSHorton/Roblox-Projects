local GuiControl = game.ReplicatedStorage.GuiControl
local MODES_CONTROL = {}
	function MODES_CONTROL.setMode(mode,value)
		local modes = workspace.Modes
		local modeQuery = modes:FindFirstChild(mode)
		if modeQuery ~= nil then
			modeQuery.Value = value
		end
		GuiControl:FireAllClients("Display Modes")
	end
	
	function MODES_CONTROL.setupListener()
		GuiControl.OnServerEvent:Connect(function(plr,gui,mode,value)
			if gui == "MODES_CONTROL" then
				print(plr.Name .. " has attempted to change " .. mode .. " to " .. tostring(value))
				MODES_CONTROL.setMode(mode,value)
			end
		end)
	end
return MODES_CONTROL
