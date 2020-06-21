wait(2)
for i,v in ipairs(workspace["Size Testing"]:GetChildren()) do
	if v.Name == "Army" then
		local amount = tonumber(v.BillboardGui.Score.Text)
		local sizeModification = (amount*0.008)/4
		if sizeModification < 0.3 then
			sizeModification = 0.3
		elseif sizeModification <= 2.5 and sizeModification >= 1.7 then
			sizeModification = (amount*0.006)/4
		end
		if sizeModification > 2.5 then
			sizeModification = 2.5
		end
		v.Size = Vector3.new(sizeModification* 0.5,sizeModification,sizeModification)
	end
end