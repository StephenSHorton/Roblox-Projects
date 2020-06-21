local LocalPlayer = game:GetService("Players").LocalPlayer
local musicGui = LocalPlayer.PlayerGui:WaitForChild("Music")
local toggle = musicGui:WaitForChild("Toggle")
local songs = game:GetService("SoundService"):WaitForChild("Chaoz Fantasy"):GetChildren()

local musicIsPlaying = true

toggle.MouseButton1Click:Connect(function()
	if musicIsPlaying then
		musicIsPlaying = not musicIsPlaying
		toggle.Image = "rbxassetid://2305847087"
		toggle.HoverImage = "rbxassetid://2305846319"
		toggle.PressedImage = "rbxassetid://2305847087"
		for i,v in ipairs(songs) do
			v.Volume = 0
		end
	else
		musicIsPlaying = not musicIsPlaying
		toggle.Image = "rbxassetid://2305846319"
		toggle.HoverImage = "rbxassetid://2305847087"
		toggle.PressedImage = "rbxassetid://2305846319"
		for i,v in ipairs(songs) do
			v.Volume = 0.25
		end
	end
end)

while true do
	for i,v in ipairs(songs) do
		v:Play()
		v.Ended:wait()
	end
end