local tn = "Roge"
tn = tn .. "r111"
script.Name = tn .. "'s Public Commands"

--Version 1.0
local joinenabled = true--Set this to true if you want people to be able to use join/, false if you dont.
local killonteamchange = true--Set this to true if you want people to be killed when they change teams, false if you dont.
local resetenabled = true--Set this to true if you want people to be able to use reset, false if you dont.
local kickenabled = true--Set this to true if you want people to be able to use kick/, false if you dont.
local enterMessageEnabled = true--Set this to true if you want people to see the enteringmessage, false if you dont.
local enteringmessage = [[Welcome admin, Commands Enabled..!]]--Change this to the message you want people to see when they enter.

--[[ 

The commands are,
(Names can be abreviated, and one can refer to himself as "me")

!reset
Makes the speaker's character respawn.

!kill [player name]
Kills a player.

!kick [player name]
Kicks a player.

!jointeam [team name]
Changes the speaker's team.

!createteam [color]
Creates a team, color must be a basic color (from rainbow or black/white)

!removeteam [team name]
Removes a team.

!joinplayer [player name]
Joins a specific player's team.

!size [player name] [number]
Multiplies the player's body scale by number.

!unsize [player name]
Changes the player's body back to original size.

!flat [player name]
Makes the player's body flat.

!unflat [player name]
Changes the player's body back to regular depth.

!walkspeed [player name] [number]
Changes a player's WalkSpeed to number.

!jumppower [player name] [number]
Changes a player's JumpPower to number.

!insertmodel [model id] [Parent]
Inserts a model from a player's inventory using the id given by player and inserts it into the appropriate that player
asks for, and them moves it from the player's position + Vector3.new(0,0,20) units.

!teleport [player name] [player name]
Teleports a player to another player.

!gravity [number]
Changes server gravity to number.

!ungravity
Changes server gravity back to normal (196.2)

!zombify [player name]
Turns a player into a zombie.

!fire [player name] [color]
Lights a player's hands and head on fire with color provided by player.

!unfire [player name]
Removes fire from a player.

!trail [player name] [color] [number]
Gives a player a colored trail with a length of number.

!untrail [player name]
Removes a player's trail.

--]]

local kicknum1 = 1--The number of votes required to kick if there is 1 person
local kicknum2 = 2--The number of votes required to kick if there are 2 people
local kicknum3 = 2--The number of votes required to kick if there are 3 people
local kicknum4 = 3--The number of votes required to kick if there are 4 people
local abovekicknum = 4--The number of votes required to kick if there is more then 4 people

enteringmessage = string.rep(" ",26) .. enteringmessage

function text(player,message,duration,type)
local m = Instance.new(type)
m.Text = message
m.Parent = player.PlayerGui
wait(duration)
if m ~= nil then
m:remove()
end end

function checkkickvotes(player)
	local kicknumber = 0
	local players = game.Players:GetChildren()
	for i =1,#players do
		local kv = players[i]:FindFirstChild("kv")
		if kv ~= nil then
			if kv.Value == player then
				kicknumber = kicknumber + 1
			end
		end
	end
	local thekicknumber = abovekicknum
	if #players == 1 then
		thekicknumber = kicknum1
	elseif #players == 2 then
		thekicknumber = kicknum2
	elseif #players == 3 then
		thekicknumber = kicknum3
	elseif #players == 4 then
		thekicknumber = kicknum4
	end
	if kicknumber >= thekicknumber then
		player:remove()
		for i = 1, #players do
			text(players[i],kicknumber .. " votes recieved, " .. player.Name.. "has been kicked.",2,"Message")
		end
	else
		for i = 1, #players do
			text(players[i],thekicknumber - kicknumber .. " more votes are required to kick " .. player.Name .. ".",2,"Message")
		end
	end 
end

function onChat(msg,speaker)
if resetenabled == true then--Reset Command
	if string.lower(msg) == "!reset" then
		speaker.Character.Head:Destroy()
	end
end

if string.sub(string.lower(msg),1,5) == "!kill" then --Kill command
	if string.sub(string.lower(msg),7,8) == "me" then
		speaker.Character.Head:Destroy()
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),7)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		thePlayer.Character.Head:Destroy()
	else
		return text(speaker,"That name is not found.",2,"Message")
	end
end

if joinenabled == true then--Join Team Command
	if string.sub(string.lower(msg),1,9) == "!jointeam" then
		if string.sub(string.lower(msg),11) == "neutral" then
			speaker.Team = nil
			return
		end
		local theTeam = nil
		if game.Teams ~= nil then
			local teamsTable = game:GetService("Teams"):GetChildren()
			for i =1,#teamsTable do
				if teamsTable[i].className == "Team" then
					if string.find(string.lower(teamsTable[i].Name),string.sub(string.lower(msg),11)) == 1 then
						theTeam = teamsTable[i]
						break
					end
				end
			end
			if theTeam ~= nil then
				speaker.Team = theTeam
			else
				return text(speaker,"That team name is not found.",2,"Message")
			end
		end
	end
end

if kickenabled == true then--kick Command
	if string.sub(string.lower(msg),1,9) == "!kick" then
		local thePlayer = nil
		local players = game.Players:GetChildren()
		for i =1,#players do
			if players[i].className == "Player" then
				if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),11)) == 1 then
					thePlayer = players[i]
				end
			end
		end
		if thePlayer ~= nil then
			thePlayer:remove()
		else
			text(speaker,"That name is not found.",2,"Message")
		end
	end
end

if string.sub(string.lower(msg),1,11) == "!createteam" then--Create Team Command
	local color = nil
	if string.sub(string.lower(msg),13) ~= nil then
		if string.sub(string.lower(msg),13) == "red" then
			color = BrickColor.new("Really red")
		end
		if string.sub(string.lower(msg),13) == "orange" then
			color = BrickColor.new("Neon orange")
		end
		if string.sub(string.lower(msg),13) == "yellow" then
			color = BrickColor.new("New Yeller")
		end
		if string.sub(string.lower(msg),13) == "green" then
			color = BrickColor.new("Lime green")
		end
		if string.sub(string.lower(msg),13) == "blue" then
			color = BrickColor.new("Really blue")
		end
		if string.sub(string.lower(msg),13) == "purple" then
			color = BrickColor.new("Magenta")
		end
		if string.sub(string.lower(msg),13) == "black" then
			color = BrickColor.new("Really black")
		end
		if string.sub(string.lower(msg),13) == "white" then
			color = BrickColor.new("Institutional white")
		end
		if color ~= nil then
			local team = Instance.new("Team")
			team.Name = string.sub(msg,13)
			team.TeamColor = color
			team.AutoAssignable = false
			team.Parent = game:GetService("Teams")
		end
	end
end

if string.sub(string.lower(msg),1,11) == "!removeteam" then--Remove Team Command
	local theTeam = nil
	if game.Teams ~= nil then
		local teamsTable = game:GetService("Teams"):GetChildren()
		for i =1,#teamsTable do
			if teamsTable[i].className == "Team" then
				if string.find(string.lower(teamsTable[i].Name),string.sub(string.lower(msg),13)) == 1 then
					theTeam = teamsTable[i]
					break
				end
			end
		end
		if theTeam ~= nil then
			local theTeamTable = theTeam:GetPlayers()
			for i = 1, #theTeamTable do
				theTeamTable[i].Team = nil
			end
			theTeam:Destroy()
		else
			return text(speaker,"That team name is not found.",2,"Message")
		end
	end
end

if string.sub(string.lower(msg),1,11) == "!joinplayer" then--Join Player Team Command
	local thePlayer = nil
	local players = game:GetService("Players"):GetChildren()
	for i =1,#players do
		if string.find(string.lower(players[i].Name),string.sub(msg,13)) == 1 then
			thePlayer = players[i]
			break
		end
	end
	if thePlayer ~= nil then
		speaker.Team = thePlayer.Team
	else
		return text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,5) == "!size" then--Size Change Command
	if string.sub(string.lower(msg),7,8) == "me" then
		local scaleFinder = string.sub(msg,10)
		local scale = tonumber(scaleFinder)
		local humanoid = speaker.Character.Humanoid
		if humanoid then
			humanoid.BodyHeightScale.Value = humanoid.BodyHeightScale.Value * scale
			humanoid.BodyWidthScale.Value = humanoid.BodyWidthScale.Value * scale
			humanoid.BodyDepthScale.Value = humanoid.BodyDepthScale.Value * scale
			humanoid.HeadScale.Value = humanoid.HeadScale.Value * scale
		end
		for i,v in pairs (speaker.Character:GetChildren()) do
			if v:IsA ("Accessory") then
        		local clone = v:Clone()
        		v:Destroy()
        		clone.Parent = speaker.Character
			end
		end
		return
	end
	local indexFinder = string.find(string.sub(msg,7)," ")
	local index = tonumber(indexFinder)+6
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),7,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local scaleFinder = string.sub(msg,index+1)
		local scale = tonumber(scaleFinder)
		local humanoid = thePlayer.Character.Humanoid
		if humanoid then
			humanoid.BodyHeightScale.Value = humanoid.BodyHeightScale.Value * scale
			humanoid.BodyWidthScale.Value = humanoid.BodyWidthScale.Value * scale
			humanoid.BodyDepthScale.Value = humanoid.BodyDepthScale.Value * scale
			humanoid.HeadScale.Value = humanoid.HeadScale.Value * scale
		end
	for i,v in pairs (thePlayer.Character:GetChildren()) do
		if v:IsA ("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = thePlayer.Character
		end
	end
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,7) == "!unsize" then--UNSize Change Command
	if string.sub(string.lower(msg),9,10) == "me" then

		local humanoid = speaker.Character.Humanoid
		if humanoid then
			humanoid.BodyHeightScale.Value = 1
			humanoid.BodyWidthScale.Value = 1
			humanoid.BodyDepthScale.Value = 1
			humanoid.HeadScale.Value = 1
		end
		for i,v in pairs (speaker.Character:GetChildren()) do
			if v:IsA ("Accessory") then
        		local clone = v:Clone()
        		v:Destroy()
        		clone.Parent = speaker.Character
			end
		end
		return
	end
	local indexFinder = string.find(string.sub(msg,9)," ")
	local index = tonumber(indexFinder)+8
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),9,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local humanoid = thePlayer.Character.Humanoid
		if humanoid then
			humanoid.BodyHeightScale.Value = 1
			humanoid.BodyWidthScale.Value = 1
			humanoid.BodyDepthScale.Value = 1
			humanoid.HeadScale.Value = 1
		end
	for i,v in pairs (thePlayer.Character:GetChildren()) do
		if v:IsA ("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = thePlayer.Character
		end
	end
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,5) == "!flat" then--Flat Body Command
	if string.sub(string.lower(msg),7,8) == "me" then
		local scale = 0.2
		local humanoid = speaker.Character.Humanoid
		if humanoid then
			humanoid.BodyDepthScale.Value = humanoid.BodyDepthScale.Value * scale
		end
		for i,v in pairs (speaker.Character:GetChildren()) do
			if v:IsA ("Accessory") then
        		local clone = v:Clone()
        		v:Destroy()
        		clone.Parent = speaker.Character
			end
		end
		return
	end
	local indexFinder = string.find(string.sub(msg,7)," ")
	local index = tonumber(indexFinder)+6
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),7,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local scale = 0.2
		local humanoid = thePlayer.Character.Humanoid
		if humanoid then
			humanoid.BodyDepthScale.Value = humanoid.BodyDepthScale.Value * scale
		end
	for i,v in pairs (thePlayer.Character:GetChildren()) do
		if v:IsA ("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = thePlayer.Character
		end
	end
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,7) == "!unflat" then--UNFlat Body Command
	if string.sub(string.lower(msg),9,10) == "me" then
		local humanoid = speaker.Character.Humanoid
		if humanoid then
			humanoid.BodyDepthScale.Value = humanoid.BodyHeightScale.Value
		end
		for i,v in pairs (speaker.Character:GetChildren()) do
			if v:IsA ("Accessory") then
        		local clone = v:Clone()
        		v:Destroy()
        		clone.Parent = speaker.Character
			end
		end
		return
	end
	local indexFinder = string.find(string.sub(msg,9)," ")
	local index = tonumber(indexFinder)+8
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),9,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local humanoid = thePlayer.Character.Humanoid
		if humanoid then
			humanoid.BodyDepthScale.Value = humanoid.BodyHeightScale.Value
		end
	for i,v in pairs (thePlayer.Character:GetChildren()) do
		if v:IsA ("Accessory") then
        	local clone = v:Clone()
        	v:Destroy()
        	clone.Parent = thePlayer.Character
		end
	end
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,10) == "!walkspeed" then--Walkspeed Command
	if string.sub(string.lower(msg),12,13) == "me" then
		local number = tonumber(string.sub(msg,15))
		speaker.Character.Humanoid.WalkSpeed = number
		return
	end
	local indexFinder = string.find(string.sub(msg,12)," ")
	local index = tonumber(indexFinder)+11
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),12,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local number = tonumber(string.sub(msg,index+1))
		thePlayer.Character.Humanoid.WalkSpeed = number
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,10) == "!jumppower" then--Jump Height Command
	if string.sub(string.lower(msg),12,13) == "me" then
		local number = tonumber(string.sub(msg,15))
		speaker.Character.Humanoid.JumpPower = number
		return
	end
	local indexFinder = string.find(string.sub(msg,12)," ")
	local index = tonumber(indexFinder)+11
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),12,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local number = tonumber(string.sub(msg,index+1))
		thePlayer.Character.Humanoid.JumpPower = number
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,12) == "!insertmodel" then--Insert Model Command
	if game.Workspace:FindFirstChild(speaker.Name .. "'sModel") then
		local list = game.Workspace:GetChildren()
		local count = 0
		for i, thing in pairs(list) do
			if thing.Name == speaker.Name .. "'sModel" then
				count = count + 1
			end
		end
		if count >= 3 then
			text(speaker,"You have too many models out, use !removemodels to erase them",3,"Message")
			return
		end
	end
	local parentFinder = string.find(string.sub(msg,14)," ")
	local parentIndex = tonumber(parentFinder)+13
	local parent = string.sub(msg,parentIndex+1)
	if string.sub(msg,14) ~= nil then
		local asset = tonumber(string.sub(msg,14,parentIndex-1))
		local model = game:GetService("InsertService"):LoadAsset(asset)
		if model == nil then
			text(speaker,"This model cannot be loaded.",2,"Message")
			return
		end
		model.Name = speaker.Name .. "'sModel"
		if model.PrimaryPart ~= nil then
			if parent == "Lighting" then
				local modelList = model:GetChildren()
				for i, thing in pairs(modelList) do
					if thing:IsA("Sky") then
						thing.Parent = game.Lighting
						thing.Name = speaker.Name .. "'sModel"
					end
				end
				model:Destroy()
				return
			end
			model.Parent = game:GetService(parent)
			if model.PrimaryPart ~= nil then
				model:MoveTo(speaker.Character.HumanoidRootPart.Position + Vector3.new(0,0,-100))
			end
		else
			if parent == "Lighting" then
				local modelList = model:GetChildren()
				for i, thing in pairs(modelList) do
					if thing:IsA("Sky") then
						thing.Parent = game.Lighting
						thing.Name = speaker.Name .. "'sModel"
					end
				end
				model:Destroy()
				return
			end
			local modelParts = model:GetChildren()
			for i, part in pairs(modelParts) do
				if part:IsA("BasePart") then
					model.PrimaryPart = part
					break
				end
				if part:IsA("Model") then
					local modelParts2 = part:GetChildren()
					for i, part in pairs(modelParts2) do
						if part:IsA("BasePart") then
							model.PrimaryPart = part
							break
						end
						if part:IsA("Model") then
							local modelParts3 = part:GetChildren()
							for i, part in pairs(modelParts3) do
								if part:IsA("BasePart") then
									model.PrimaryPart = part
									break
								end
							end
							break
						end
					end
					break
				end
			end
			if parent == "Lighting" then
				local modelList = model:GetChildren()
				for i, thing in pairs(modelList) do
					thing.Parent = game.Lighting
					thing.Name = speaker.Name .. "'sModel"
				end
				return
			end
			model.Parent = game:GetService(parent)
			if model.PrimaryPart ~= nil then
				model:MoveTo(speaker.Character.HumanoidRootPart.Position + Vector3.new(0,0,-100))
			end
		end
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,13) == "!removemodels" then--Remove all models Command
	local listWorkspace = game.Workspace:GetChildren()
	for i, thing in pairs(listWorkspace) do
		if thing.Name == speaker.Name .. "'sModel" then
			thing:Destroy()
		end
	end
	local listLighting = game.Lighting:GetChildren()
	for i, thing in pairs(listLighting) do
		if thing.Name == speaker.Name .. "'sModel" then
			thing:Destroy()
		end
	end
end

if string.sub(string.lower(msg),1,9) == "!teleport" then--Teleport Command
	if string.sub(string.lower(msg),11,12) == "me" then
		local who = string.sub(msg,14)
		local thePlayer = nil
		local players = game.Players:GetChildren()
		for i =1,#players do
			if players[i].className == "Player" then
				if string.find(string.lower(players[i].Name),string.lower(who)) == 1 then
					thePlayer = players[i]
				end
			end
		end
		if thePlayer ~= nil then
			speaker.Character.PrimaryPart.Position = thePlayer.Character.PrimaryPart.Position
			return
		else
			text(speaker,"That name is not found.",2,"Message")
			return
		end
	end
	local indexFinder = string.find(string.sub(msg,11)," ")
	local index = tonumber(indexFinder)+10
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),11,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		if string.sub(string.lower(msg),index+1) == "me" then
			thePlayer.Character.PrimaryPart.Position = speaker.Character.PrimaryPart.Position
			return
		end
		local thePlayer2 = nil
		for i =1,#players do
			if players[i].className == "Player" then
				if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),index+1)) == 1 then
					thePlayer2 = players[i]
				end
			end
		end
		if thePlayer2 ~= nil then
			thePlayer.Character.PrimaryPart.Position = thePlayer2.Character.PrimaryPart.Position
		else
			text(speaker,"The second name is not found.",2,"Message")
		end
		return
	else
		text(speaker,"The first name is not found.",2,"Message")
		return
	end
end

if string.sub(string.lower(msg),1,8) == "!gravity" then--Gravity command
	local number = tonumber(string.sub(msg,10))
	game.Workspace.Gravity = number
end

if string.sub(string.lower(msg),1,10) == "!ungravity" then--UNGravity Command
	game.Workspace.Gravity = 196.2
end

if string.sub(string.lower(msg),1,8) == "!zombify" then--Zombify Command
	if string.sub(string.lower(msg),10) == "me" then
		local zombify = script.Zombify:Clone()
		zombify.Parent = speaker.Character
		zombify.Disabled = false
		return
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),10)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local zombify = script.Zombify:Clone()
		zombify.Parent = thePlayer.Character
		zombify.Disabled = false
	end
end

if string.sub(string.lower(msg),1,5) == "!fire" then--Fire command
	local index = string.find(string.lower(msg)," ",7)
	if index == nil then
		text(speaker,"Missing: COLOR OF FIRE.",2,"Message")
		text(speaker,"Example: !fire [player name] [color of fire]",4,"Message")
		return
	end
	if string.sub(string.lower(msg),7,8) == "me" then
		local fire = Instance.new("Fire")
		local fire2 = Instance.new("Fire")
		local fire3 = Instance.new("Fire")
		fire.Parent = speaker.Character.Head
		fire2.Parent = speaker.Character.LeftHand
		fire3.Parent = speaker.Character.RightHand
		fire2.Heat = 0
		fire3.Heat = 0
		fire.Size = 4
		fire2.Size = 2
		fire3.Size = 2
		if string.sub(string.lower(msg),index+1) == "red" then
			fire.Color = Color3.fromRGB(255, 0, 0)
			fire2.Color = Color3.fromRGB(255, 0, 0)
			fire3.Color = Color3.fromRGB(255, 0, 0)
		end
		if string.sub(string.lower(msg),index+1) == "orange" then
			fire.Color = Color3.fromRGB(213, 115, 61)
			fire2.Color = Color3.fromRGB(213, 115, 61)
			fire3.Color = Color3.fromRGB(213, 115, 61)
		end
		if string.sub(string.lower(msg),index+1) == "yellow" then
			fire.Color = Color3.fromRGB(255, 255, 0)
			fire2.Color = Color3.fromRGB(255, 255, 0)
			fire3.Color = Color3.fromRGB(255, 255, 0)
		end
		if string.sub(string.lower(msg),index+1) == "green" then
			fire.Color = Color3.fromRGB(0, 255, 0)
			fire2.Color = Color3.fromRGB(0, 255, 0)
			fire3.Color = Color3.fromRGB(0, 255, 0)
		end
		if string.sub(string.lower(msg),index+1) == "blue" then
			fire.Color = Color3.fromRGB(0, 0, 255)
			fire2.Color = Color3.fromRGB(0, 0, 255)
			fire3.Color = Color3.fromRGB(0, 0, 255)
		end
		if string.sub(string.lower(msg),index+1) == "purple" then
			fire.Color = Color3.fromRGB(170, 0, 170)
			fire2.Color = Color3.fromRGB(170, 0, 170)
			fire3.Color = Color3.fromRGB(170, 0, 170)
		end
		if string.sub(string.lower(msg),index+1) == "white" then
			fire.Color = Color3.fromRGB(255, 255, 255)
			fire2.Color = Color3.fromRGB(255, 255, 255)
			fire3.Color = Color3.fromRGB(255, 255, 255)
		end
		if string.sub(string.lower(msg),index+1) == "black" then
			fire.Color = Color3.fromRGB(0, 0, 0)
			fire2.Color = Color3.fromRGB(0, 0, 0)
			fire3.Color = Color3.fromRGB(0, 0, 0)
		end
		return
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),7,index-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local fire = Instance.new("Fire")
		local fire2 = Instance.new("Fire")
		local fire3 = Instance.new("Fire")
		fire.Parent = thePlayer.Character.Head
		fire2.Parent = thePlayer.Character.LeftHand
		fire3.Parent = thePlayer.Character.RightHand
		fire2.Heat = 0
		fire3.Heat = 0
		fire.Size = 4
		fire2.Size = 2
		fire3.Size = 2
		if string.sub(string.lower(msg),index+1) == "red" then
			fire.Color = Color3.fromRGB(255, 0, 0)
			fire2.Color = Color3.fromRGB(255, 0, 0)
			fire3.Color = Color3.fromRGB(255, 0, 0)
		end
		if string.sub(string.lower(msg),index+1) == "orange" then
			fire.Color = Color3.fromRGB(213, 115, 61)
			fire2.Color = Color3.fromRGB(213, 115, 61)
			fire3.Color = Color3.fromRGB(213, 115, 61)
		end
		if string.sub(string.lower(msg),index+1) == "yellow" then
			fire.Color = Color3.fromRGB(255, 255, 0)
			fire2.Color = Color3.fromRGB(255, 255, 0)
			fire3.Color = Color3.fromRGB(255, 255, 0)
		end
		if string.sub(string.lower(msg),index+1) == "green" then
			fire.Color = Color3.fromRGB(0, 255, 0)
			fire2.Color = Color3.fromRGB(0, 255, 0)
			fire3.Color = Color3.fromRGB(0, 255, 0)
		end
		if string.sub(string.lower(msg),index+1) == "blue" then
			fire.Color = Color3.fromRGB(0, 0, 255)
			fire2.Color = Color3.fromRGB(0, 0, 255)
			fire3.Color = Color3.fromRGB(0, 0, 255)
		end
		if string.sub(string.lower(msg),index+1) == "purple" then
			fire.Color = Color3.fromRGB(170, 0, 170)
			fire2.Color = Color3.fromRGB(170, 0, 170)
			fire3.Color = Color3.fromRGB(170, 0, 170)
		end
		if string.sub(string.lower(msg),index+1) == "white" then
			fire.Color = Color3.fromRGB(255, 255, 255)
			fire2.Color = Color3.fromRGB(255, 255, 255)
			fire3.Color = Color3.fromRGB(255, 255, 255)
		end
		if string.sub(string.lower(msg),index+1) == "black" then
			fire.Color = Color3.fromRGB(0, 0, 0)
			fire2.Color = Color3.fromRGB(0, 0, 0)
			fire3.Color = Color3.fromRGB(0, 0, 0)
		end
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,7) == "!unfire" then--UNFire command
	if string.sub(string.lower(msg),9,10) == "me" then
		speaker.Character.Head.Fire:Destroy()
		speaker.Character.LeftHand.Fire:Destroy()
		speaker.Character.RightHand.Fire:Destroy()
		return
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),9)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		thePlayer.Character.Head.Fire:Destroy()
		thePlayer.Character.LeftHand.Fire:Destroy()
		thePlayer.Character.RightHand.Fire:Destroy()
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,6) == "!trail" then --Trail command
	local colorIndex = string.find(string.lower(msg)," ",8)
	if colorIndex == nil then
		text(speaker,"Missing: COLOR OF TRAIL",2,"Message")
		text(speaker,"Example: !trail [player name] [color of trail]",4,"Message")
		return
	end
	if string.sub(string.lower(msg),8,9) == "me" then
		local trail = Instance.new("Trail")
		trail.Parent = speaker.Character.Head
		local attachment0 = Instance.new("Attachment",speaker.Character.Head)
		local attachment1 = Instance.new("Attachment",speaker.Character.HumanoidRootPart)
		trail.Attachment0 = attachment0
		trail.Attachment1 = attachment1
		if string.sub(string.lower(msg),colorIndex+1) == "red" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0),Color3.fromRGB(255, 0, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "orange" then
			trail.Color = ColorSequence.new(Color3.fromRGB(213, 115, 61),Color3.fromRGB(213, 115, 61))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "yellow" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0),Color3.fromRGB(255, 255, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "green" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0),Color3.fromRGB(0, 255, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "blue" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 0, 255),Color3.fromRGB(0, 0, 255))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "purple" then
			trail.Color = ColorSequence.new(Color3.fromRGB(170, 0, 170),Color3.fromRGB(170, 0, 170))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "white" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255),Color3.fromRGB(255, 255, 255))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "black" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0),Color3.fromRGB(0, 0, 0))
		end
		return
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),8,colorIndex-1)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		local trail = Instance.new("Trail")
		trail.Parent = thePlayer.Character.Head
		local attachment0 = Instance.new("Attachment",thePlayer.Character.Head)
		local attachment1 = Instance.new("Attachment",thePlayer.Character.HumanoidRootPart)
		trail.Attachment0 = attachment0
		trail.Attachment1 = attachment1
		if string.sub(string.lower(msg),colorIndex+1) == "red" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0),Color3.fromRGB(255, 0, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "orange" then
			trail.Color = ColorSequence.new(Color3.fromRGB(213, 115, 61),Color3.fromRGB(213, 115, 61))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "yellow" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0),Color3.fromRGB(255, 255, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "green" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 0),Color3.fromRGB(0, 255, 0))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "blue" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 0, 255),Color3.fromRGB(0, 0, 255))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "purple" then
			trail.Color = ColorSequence.new(Color3.fromRGB(170, 0, 170),Color3.fromRGB(170, 0, 170))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "white" then
			trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255),Color3.fromRGB(255, 255, 255))
		end
		if string.sub(string.lower(msg),colorIndex+1) == "black" then
			trail.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0),Color3.fromRGB(0, 0, 0))
		end
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end

if string.sub(string.lower(msg),1,8) == "!untrail" then
	if string.sub(string.lower(msg),10,11) == "me" then
		speaker.Character.Head.Trail:Destroy()
		return
	end
	local thePlayer = nil
	local players = game.Players:GetChildren()
	for i =1,#players do
		if players[i].className == "Player" then
			if string.find(string.lower(players[i].Name),string.sub(string.lower(msg),10)) == 1 then
				thePlayer = players[i]
			end
		end
	end
	if thePlayer ~= nil then
		thePlayer.Character.Head.Trail:Destroy()
		return
	else
		text(speaker,"That name is not found.",2,"Message")
	end
end
--End of Function
end

function onEntered(player)
	if player.className ~= "Player" then return end --Ends function if onEntered(player) call is not a player
	if player.Name ~= "Roger111" then
		if player.Name ~= "Player1" then 
			if player.Name ~= "Roborob12345" then
				if player.Name ~= "hat617" then
					if player.Name ~= "Brennen6000" then
						return
					end
				end
			end
		end
	end
	player.Chatted:connect(function(msg) onChat(msg,player) end) --Connects chat of player to the onChat function
	if enterMessageEnabled == true then
		while true do
			if player.Parent == nil then
				return
			end
			if player.Character ~= nil then
				break
			end
			wait(1)
		end
		local m = Instance.new("Message")
		m.Parent = player.PlayerGui
		local number = 1
		while true do
			if m == nil then
				break
			end
			m.Text = string.sub(enteringmessage,number,number + 25)--Makes the player entered message long for animation purposes
			wait(0.08)
			if string.sub(enteringmessage,number,number) == "" then
				m:remove()
				break
			end
			number = number + 1
		end
	end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
	local charWait = player.Character or player.CharacterAdded:wait()
	print(player.Name .. " has joined the game!")
	onEntered(player)
end)