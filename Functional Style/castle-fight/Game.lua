--TODO
	--Ready up and balance teams does not check multiple times incase player moves or unreadies.
    wait()
    local Players = game:GetService("Players")
    
    local SETUP = require(script["Setup"])
    local MODES_CONTROL = require(script["Modes Control"])
    local TEAM_SELECT = require(script["Team Select"])
    local READY_UP_HANDLER = require(script["Ready Up Handler"])
    local CLEAN_UP_HANDLER = require(script["Clean Up Handler"])
    
    local singlePlayerMode = true
    
    local GuiControl = game.ReplicatedStorage.GuiControl
    
    local currentState = "Modes"
    
    Players.PlayerRemoving:Connect(function(plr)
        if game.Workspace["Players Ready"]:FindFirstChild(plr.Name) then
            game.Workspace["Players Ready"]:FindFirstChild(plr.Name):Destroy()
        end
    end)
    
    function generateReadyTag(plr)
        if plr == nil then print("ERROR: cannot generate player tag for NIL value") return end
        local pr = workspace["Players Ready"] or workspace:WaitForChild("Players Ready")
        local check = pr:FindFirstChild(plr.Name)
        if check == nil then
            local boolVal = Instance.new("BoolValue")
            boolVal.Parent = workspace["Players Ready"]
            boolVal.Name = plr.Name
        end
    end
    
    function listenForModes()
        GuiControl:FireAllClients("Display Modes")
        GuiControl:FireAllClients("Display Teams")
        MODES_CONTROL.setupListener()
    end
    
    function waitForTeams()
        TEAM_SELECT.setupListener()
        if singlePlayerMode then
            return
        end
        while wait(2) do
            local count1 = 0
            local count2 = 0
            for i, playerSlot in ipairs(workspace.Teams["Team 1"]:GetChildren()) do
                if playerSlot.Value ~= "" then count1 = count1+1 end
            end
            for i, playerSlot in ipairs(workspace.Teams["Team 2"]:GetChildren()) do
                if playerSlot.Value ~= "" then count2 = count2+1 end
            end
            if count1 == 0 or count1 ~= count2 then
                count1 = 0
                count2 = 0
            else break end
            print("Waiting for teams to be balanced...")
        end
        print("Teams are balanced!")
    end
    
    function waitForReady()
        READY_UP_HANDLER.setupListener()
        if singlePlayerMode then
            generateReadyTag(game.Players:FindFirstChild("Roger111"))
            GuiControl:FireAllClients("Display Readies")
            waitForTeams()
            while true do
                local readyTable = workspace["Players Ready"]:GetChildren()
                local totalReadies = 0
                for index, ready in pairs(readyTable) do
                    if ready.Value == true then
                        totalReadies = totalReadies + 1
                    end
                end
                if totalReadies == #readyTable and totalReadies ~= 0 then
                    break
                end
                print("Waiting for players to be ready...")
                wait(2)
            end
        end
        GuiControl:FireAllClients("Display Readies")
        waitForTeams() --------------------------------Waiting for teams happens in ready up function
        while true do
            local readyTable = workspace["Players Ready"]:GetChildren()
            local totalReadies = 0
            for index, ready in pairs(readyTable) do
                if ready.Value == true then
                    totalReadies = totalReadies + 1
                end
            end
            if totalReadies == #readyTable then
                break
            end
            print("Waiting for players to be ready...")
            wait(2)
        end
        return print("Players are ready!")
    end
    
    function setup()
        workspace["Game Is Started"].Value = true
        SETUP.resources()
        GuiControl:FireAllClients("Display Resource")
        GuiControl:FireAllClients("Undisplay Modes")
        GuiControl:FireAllClients("Undisplay Readies")
        GuiControl:FireAllClients("Undisplay Teams")
        SETUP.movePlayers("Start")
        SETUP.buildMenu()
        SETUP.income()
        SETUP.listenForGameEnd()
    end
    
    function cleanUp()
        wait()
        CLEAN_UP_HANDLER.killUnits()
        wait()
        CLEAN_UP_HANDLER.killPlayers()
        wait()
        CLEAN_UP_HANDLER.killBuildings()
        wait()
        CLEAN_UP_HANDLER.respawnCastles()
        wait()
        workspace["Game Is Started"].Value = false
    end
    
    function runGame()
        currentState = "Modes"
        listenForModes()
        waitForReady()
        currentState = "Gameplay"
        setup()
        --wait for game end (inside setup())
        cleanUp()
        runGame()
    end
    -----------------------------------------------------------------------------------------------------FIX CHARACTER ADDED, doesn't read..
    Players.PlayerAdded:Connect(function(plr)
        print(plr.Name .. " has joined the game...")
        wait(2)
        local char = plr.Character or plr.CharacterAdded:wait()
        local gui = plr.PlayerGui:WaitForChild("Modes Leaderboard")
        generateReadyTag(plr)
        if currentState == "Modes" then
            GuiControl:FireAllClients("Display Modes")
            GuiControl:FireAllClients("Display Readies")
            GuiControl:FireAllClients("Display Teams")
        end
    end)
    
    runGame()