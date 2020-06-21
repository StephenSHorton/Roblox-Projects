script.Parent.Touched:Connect(function(part)
	local player = game.Players:GetPlayerFromCharacter(part.Parent)
	if player then
		local scale = 1
		local humanoid = player.Character.Humanoid
		if humanoid then
			humanoid.JumpPower = 37
			humanoid.WalkSpeed = 16
			humanoid.BodyHeightScale.Value = scale
			humanoid.BodyWidthScale.Value = scale
			humanoid.BodyDepthScale.Value = scale
			humanoid.HeadScale.Value = scale
		end
		for i,v in pairs (player.Character:GetChildren()) do
			if v:IsA ("Accessory") then
        		local clone = v:Clone()
        		v:Destroy()
        		clone.Parent = player.Character
			end
		end
	end
end)