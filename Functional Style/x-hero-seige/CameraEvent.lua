local cameraEvent = game:GetService("ReplicatedStorage"):WaitForChild("CameraEvent")
local cameras = game:GetService("Workspace"):WaitForChild("Cameras")

local CAMERA_EVENT = {}
	function CAMERA_EVENT.Intro()
		--Swivel camera all cool like :D
	end
	function CAMERA_EVENT.mainMenu(player)
		cameraEvent:FireClient(player,"Main Menu")
	end
	function CAMERA_EVENT.lanePreview(playerList)
		for i, player in pairs(playerList) do
			cameraEvent:FireClient(player,"Lane Preview")
		end
	end
	function CAMERA_EVENT.returnAll(playerList)
		for i, player in pairs(playerList) do
			cameraEvent:FireClient(player,"Return")
		end
	end
	function CAMERA_EVENT.alert(playerList,message)
		for i, player in pairs(playerList) do
			cameraEvent:FireClient(player,"Alert",message)
		end
	end
return CAMERA_EVENT
