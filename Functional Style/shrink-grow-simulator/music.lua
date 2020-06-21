local songs = game:GetService("SoundService"):WaitForChild("Roblox Playlist"):GetChildren()
while true do
	if #songs == 0 then
		songs = game:GetService("SoundService"):FindFirstChild("Roblox Playlist"):GetChildren()
	else
		local randomSong = songs[math.random(#songs)]
		if not randomSong.isLoaded then
			randomSong.Loaded:wait()
		end
		print("Current Song --> " .. randomSong.Name .. " " .. randomSong.TimeLength)
		randomSong.Looped = false
		randomSong.Volume = 0.2
		randomSong:Play()
		wait(randomSong.TimeLength-10)
		for i=1,10 do
			randomSong.Volume = randomSong.Volume - 0.02
			wait(1)
		end
		table.remove(songs,table.find(songs,randomSong))
	end
end