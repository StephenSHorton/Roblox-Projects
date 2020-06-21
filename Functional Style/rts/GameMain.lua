wait()
--Modules
local guiControl = require(script.GuiControl)
local gameRestart = require(script.GameRestart)
local teleportModule = require(script.TeleportModule)
local gameSetup = require(script.GameSetup)
local buildModule = require(script.BuildModule)
--Services
local soundService = game:GetService("SoundService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
--Remote Events
local buildEvent = replicatedStorage:WaitForChild("BuildEvent")
--Variables
local playerList = {} --This will be initialized by gameSetup.grabPlayers() (It will return a table full of players)
--while true do
	--Step 1: Wait for at least 2 players
	gameSetup.waitForPlayers()
	--Step 2: Set up game
	guiControl.printAll("New Game","Starting new game..!")
	playerList = gameSetup.grabPlayers(playerList)
	gameSetup.getMap()
	gameSetup.assignTeams(playerList)
	gameSetup.timer(20)--Give a brief moment for players to realize new game and map to optimize textures
	gameSetup.giveResources(playerList)
	gameSetup.getUpAndPlay()--fixes seat teleport cancel by unallowing seat usage..
	wait(1)
	--gameSetup.fogOfWar(playerList)    --Still working on this!!!!!!!!!!!
	teleportModule.MoveToTeamSpawns()
	gameSetup.shrinkPlayers(playerList)
	guiControl.initializeGui(playerList)
	gameSetup.getUpAndPlay()--Allows players to sit again
	--Step 3: Listen to remote events (User inputs)
	buildEvent.OnServerEvent:Connect(function(player,building,CFrameSave,resourceChanged,value)--will need to disconnect this when new game is necessary
		if resourceChanged then
			buildModule.updateResources(player,resourceChanged,value)
			return
		end
		buildModule.Construct(player,building,CFrameSave)
	end)
--end
