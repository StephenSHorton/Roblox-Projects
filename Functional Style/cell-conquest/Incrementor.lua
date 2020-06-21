local INCREMENTOR = {}
function INCREMENTOR.initializeIncrement(c,t)
	while true do
		for i,thing in ipairs(workspace["Current Map"]:GetChildren()) do
			if string.sub(thing.Name,1,4) == "Cell" and thing.Color ~= Color3.fromRGB(248, 248, 248) then
				thing.BillboardGui.Score.Text = tonumber(thing.BillboardGui.Score.Text) + c
			end
		end
		wait(t)
	end
end
return INCREMENTOR
