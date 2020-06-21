local PhysicsService = game:GetService("PhysicsService")
PhysicsService:CreateCollisionGroup("Players")
PhysicsService:CollisionGroupSetCollidable("Players", "Players", false)

game.Players.PlayerAdded:Connect(function(plr)
	local char = plr.Character or plr.CharacterAdded:wait()
	for i,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(v, "Players")
		end
	end
end)