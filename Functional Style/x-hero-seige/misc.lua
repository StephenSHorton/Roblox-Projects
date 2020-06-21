local colors = {Color3.fromRGB(196, 40, 28),Color3.fromRGB(13, 105, 172),Color3.fromRGB(75, 151, 75),
	Color3.fromRGB(245, 205, 48),Color3.fromRGB(218, 133, 65),Color3.fromRGB(255, 102, 204),
	Color3.fromRGB(124, 92, 70),Color3.fromRGB(180, 210, 228)
	}
local MISC = {}
	function MISC.colorNames(playerList)
		for i, player in pairs(playerList) do
			local nameGui = Instance.new("BillboardGui",player.Character)
			nameGui.ExtentsOffsetWorldSpace = Vector3.new(0, 2, 0)
			nameGui.Size = UDim2.new(0, 75,0, 20)
			nameGui.PlayerToHideFrom = player
			nameGui.MaxDistance = 75
			local text = Instance.new("TextLabel",nameGui)
			text.Text = ('Player ' .. (#playerList-i))
			text.TextColor3 = colors[#playerList-i]
			text.Size = UDim2.new(1, 0, 1, 0)
			text.TextSize = 15
			text.BackgroundTransparency = 1
			text.Font = Enum.Font.SourceSansBold
		end
	end
	function MISC.unFreezePlayers(playerList)
		for i, player in pairs(playerList) do
			for i, part in pairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") then
					part.Anchored = false
				end
			end
		end
	end
	function MISC.ShopBillboards()
		local shopGroup = workspace["Lane Shops"]
		local challengeCircle = workspace["Challenge Circle"]
		local powerupCircle = workspace["Power-Up Circle"]
		challengeCircle.BillboardGui.Enabled = true
		powerupCircle.BillboardGui.Enabled = true
		for i, shop in pairs(shopGroup:GetChildren()) do
			if shop.ClassName == "Model" then
			shop.Base.BillboardGui.Enabled = true
			end
		end
	end
	function MISC.openGates(command)
		local gateFolder = workspace.Gates
		local gates = {gateFolder.Waypoint1, gateFolder.Waypoint2, gateFolder.Waypoint3,
			gateFolder.Waypoint4, gateFolder.Waypoint5, gateFolder.Waypoint6,
			gateFolder.Waypoint7, gateFolder.Waypoint8
			}
		if command == "ALL" then
			for i, gate in pairs(gates) do
				local decals = gate:GetChildren()
				for i, decal in pairs(decals) do
					decal:Destroy()
				end
				gate.Transparency = 1
				gate.CanCollide = false
			end
		else
			for i = 1, command do
				local decals = gates[i]:GetChildren()
				for i, decal in pairs(decals) do
					decal:Destroy()
				end
				gates[i].Transparency = 1
				gates[i].CanCollide = false
			end
		end
	end
--	function MISC.setRespawns(playerList)
--		for i, player in pairs(playerList) do
--			
--		end
--	end
return MISC
