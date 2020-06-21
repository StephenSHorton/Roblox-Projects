local CREEPS = require(script.Creeps)
local LEADERBOARD = require(script.Leaderboard)
local TIMERS = require(script.Timers)
local SPECIAL_WAVES = require(script["Special Waves"])
local TELEPORT_PLAYERS = require(script["Teleport Players"])
local CAMERA_EVENT = require(script["Camera Event"])
local READYUP = require(script.ReadyUp)--Gets the playerList
local MISC = require(script.Misc)
local Players = game:GetService("Players")
local readyUpEvent = game:GetService("ReplicatedStorage"):WaitForChild("ReadyUpEvent")
local cameraEvent = game:GetService("ReplicatedStorage"):WaitForChild("CameraEvent")

function runGame(playerList)
	TIMERS.generalTimer(5)
	TELEPORT_PLAYERS.start(playerList)
	CAMERA_EVENT.lanePreview(playerList)
	local playerCount = 0
	cameraEvent.OnServerEvent:Wait()
	cameraEvent.OnServerEvent:Connect(function()
		playerCount = playerCount + 1
		if playerCount ~= #playerList then
			cameraEvent.OnServerEvent:Wait()
		end
	end)
	CAMERA_EVENT.returnAll(playerList)
	MISC.unFreezePlayers(playerList)
	LEADERBOARD.setup(playerList)
--	MISC.colorNames(playerList)
	MISC.ShopBillboards()
	MISC.openGates(#playerList)
	wait(15)
	CREEPS.start()
	CAMERA_EVENT.alert(playerList,"Here they come!")
end

Players.PlayerAdded:Connect(function(player)--Send player to main menu on join
	wait()
	READYUP.check()
	CAMERA_EVENT.mainMenu(player)
	local char = player.Character or player.CharacterAdded:Wait()
	local tag = Instance.new("BoolValue",char)
	tag.Value = false
	for i, thing in pairs(char:GetChildren()) do
		if thing:IsA("BasePart") then
			thing.Anchored = true
		end
	end
end)
readyUpEvent.OnServerEvent:Connect(function(player)--If enough players are ready to start runGame() will be called
	local check = READYUP.check(player)
	if check then print("Starting game.."); runGame(check) end
end)