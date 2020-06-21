
local timeEvent = game:GetService("ReplicatedStorage"):WaitForChild("TimeEvent")
local TIMERS = {}
	function TIMERS.generalTimer(x)
		local count = x
		wait(1)
		if count ~= 0 then
			timeEvent:FireAllClients(count)
			count = count -1
			return TIMERS.generalTimer(count)
		else
			timeEvent:FireAllClients(count)
		end
	end
return TIMERS