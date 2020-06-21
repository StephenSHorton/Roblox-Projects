local Class = require(game.ReplicatedStorage.Class)
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Robot = Class:extend()
local robotModels = game.ServerStorage["Robot Models"]

local VALUE_TABLE = {
	["Laser Cannon"] = {20,30,40},
	["Electric Bolt"] = {5,5,5},
	["Microwave"] = {12,17,25},
	["Gunner"] = {3,4,5},
	["Tank"] = {6,9,12},
	["Laser"] = {10,15,20},
	["Repair"] = {0.50,0.65,0.80}
}

function getTargetHumanoid(target)
	local t = target.Main.Humanoid
	if target.LaserBot then
		t = target.LaserBot.Humanoid
	elseif target.GunnerBot then
		t = target.GunnerBot.Humanoid
	elseif target.TankBot then
		t = target.TankBot.Humanoid
	else t = target.Main.Humanoid end
	return t
end

function damage(weapon,level,humanoid,modifier)
	local t = humanoid
	local d = VALUE_TABLE[weapon][level]
	if modifier then
		d = d*modifier
	end
	--print("DAMAGE: " .. d)
	t:TakeDamage(d)
end

function onBotDeath(bot)
	local part = Instance.new("Part")
	part.Transparency = 1
	part.Size = Vector3.new(1,1,1)
	part.Anchored = true
	part.CanCollide = false
	part.CFrame = bot.PrimaryPart.CFrame
	part.Parent = workspace
	local explosion = Instance.new("Explosion")
	explosion.BlastPressure = 0
	explosion.BlastRadius = 0
	explosion.ExplosionType = Enum.ExplosionType.NoCraters
	explosion.Position = part.Position
	explosion.Parent = part
	--explosionSound:Play()
	Debris:AddItem(part,3)
	bot:Destroy()
end

function repairEffect(bot)
	local repairSound = Instance.new("Sound")
	repairSound.SoundId = "rbxassetid://2349519342"
	repairSound.Volume = 1
	repairSound.Parent = bot.PrimaryPart
	repairSound.Ended:Connect(function()
		repairSound:Destroy()
	end)
	local effect = Instance.new("ParticleEmitter")
	effect.Rate = 60
	effect.Speed = NumberRange.new(0)
	effect.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(24, 255, 12)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(24, 255, 12))
	})
	effect.Lifetime = NumberRange.new(1)
	effect.Parent = bot.PrimaryPart
	repairSound:Play()
	wait(3)
	effect.Enabled = false
	Debris:AddItem(effect,4)
end

function Robot:new(owner,pos,playerSlot)
	self.Owner = owner
	if playerSlot == 1 then
		self.Color = Color3.fromRGB(255, 89, 89) -- red
	elseif playerSlot == 2 then
		self.Color = Color3.fromRGB(51, 122, 255) -- blue
	else
		self.Color = Color3.fromRGB(255,255,255)
	end
	
	self.GunnerBot = nil
	self.TankBot = nil
	self.LaserBot = nil
	
	self.Main = robotModels:FindFirstChild("Main"):Clone()
	self.Main:SetPrimaryPartCFrame(CFrame.new(pos or Vector3.new()))
	self.Main.Eye.Color = self.Color
	self.Main.Parent = workspace
end

function Robot:printAttributes()
	for i, v in pairs(self) do
		print(i .. ": " .. tostring(v))
	end
end

function Robot:setCFrame(cf)
	self.Main:SetPrimaryPartCFrame(cf)
end

function Robot:fireWeapon(roll,target)
	for weapon,level in pairs(roll) do
		wait(1)
		local t = getTargetHumanoid(target).Parent
		if level > 0 then
			if weapon == "Laser Cannon" then
				local laserSound = Instance.new("Sound")
				laserSound.SoundId = "rbxassetid://201858072"
				laserSound.Parent = self.Main.PrimaryPart
				laserSound.PlaybackSpeed = 0.7
				laserSound.Volume = 1
				laserSound.TimePosition = 0.025
				laserSound.Ended:Connect(function()laserSound:Destroy() end)
				local part = Instance.new("Part")
				part.Name = "Laser"
				part.BrickColor = BrickColor.new('Royal purple')
				part.Material = Enum.Material.Neon
				part.Transparency = 0.4
				part.Anchored = true
				part.CanCollide = false
				part.Size = Vector3.new(1,1,(self.Main.Eye.Position-t.PrimaryPart.Position).Magnitude)
				part.CFrame = CFrame.new(self.Main.Eye.CFrame:Lerp(t.PrimaryPart.CFrame, 0.5).Position, t.PrimaryPart.Position)
				local sparkles = Instance.new("Sparkles")
				sparkles.SparkleColor = part.Color
				sparkles.Parent = t.PrimaryPart
				part.Parent = workspace
				laserSound:Play()
				wait(2)
				damage(weapon,level,t.Humanoid)
				sparkles:Destroy()
				part:Destroy()
			elseif weapon == "Microwave" then
				local microwaveSound = Instance.new("Sound")
				microwaveSound.SoundId = "rbxassetid://1447681819"
				microwaveSound.Volume = 1
				microwaveSound.Parent = self.Main.PrimaryPart
				local explosionSound = Instance.new("Sound")
				explosionSound.Parent = t.PrimaryPart
				explosionSound.SoundId = "rbxassetid://142070127"
				explosionSound.Ended:Connect(function()explosionSound:Destroy() end)
				local beam = Instance.new("Beam")
				beam.Texture = "rbxassetid://877105013"
				beam.TextureSpeed = 3
				beam.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0,Color3.fromRGB(255, 86, 20)),
					ColorSequenceKeypoint.new(1,Color3.fromRGB(255, 86, 20))
				})
				beam.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, .5), -- transparent
					NumberSequenceKeypoint.new(0.5, 0), -- opaque
					NumberSequenceKeypoint.new(1, 1), -- transparent
				})
				microwaveSound:Play()
				beam.Parent = self.Main.Body
				beam.Attachment0 = self.Main.Eye.Attachment
				beam.Attachment1 = t.Body.Attachment 
				wait(2)
				local possibleTargets = {
					target.Main
				}
				if target.LaserBot then table.insert(possibleTargets,target.LaserBot) end
				if target.TankBot then table.insert(possibleTargets,target.TankBot) end
				if target.GunnerBot then table.insert(possibleTargets,target.GunnerBot) end
				table.remove(possibleTargets,table.find(possibleTargets,t))
				damage(weapon,level,t.Humanoid)
				for i,v in ipairs(possibleTargets) do
					damage(weapon,level,v.Humanoid,0.40)
				end
				microwaveSound:Destroy()
				local explosion = Instance.new("Explosion")
				explosion.BlastPressure = 0
				explosion.BlastRadius = 0
				explosion.ExplosionType = Enum.ExplosionType.NoCraters
				explosion.Position = t.PrimaryPart.Position
				explosion.Parent = t.PrimaryPart
				explosionSound:Play()
				Debris:AddItem(explosion,2)
				beam:Destroy()
			elseif weapon == "Electric Bolt" then --------------------------------------------------TODO: Cause electic bolt to hit random targets, and only the same on if there is only one.
				local possibleTargets = {
					target.Main
				}
				if target.LaserBot then table.insert(possibleTargets,target.LaserBot) end
				if target.TankBot then table.insert(possibleTargets,target.TankBot) end
				if target.GunnerBot then table.insert(possibleTargets,target.GunnerBot) end
				for i=1,level do
					local randomT = possibleTargets[math.random(#possibleTargets)]
					if randomT == target.Main and #possibleTargets > 1 then
						repeat randomT = possibleTargets[math.random(#possibleTargets)]
						until randomT ~= target.Main
					end
					local boltSound = Instance.new("Sound")
					boltSound.Parent = self.Main.PrimaryPart
					boltSound.SoundId = "rbxassetid://2220756150"
					boltSound.TimePosition = 0.6 -- The sound is blank early on
					boltSound.Ended:Connect(function()boltSound:Destroy() end)
					local part = Instance.new("Part")
					part.Name = "Bolt"
					part.BrickColor = BrickColor.new('Electric blue')
					part.Material = Enum.Material.Neon
					part.Anchored = true
					part.CanCollide = false
					part.Size = Vector3.new(1,1,2)
					part.CFrame = CFrame.new(self.Main.Eye.Position,randomT.PrimaryPart.Position)
					local tweenInfo = TweenInfo.new(
						0.75, -- Time
						Enum.EasingStyle.Linear, -- EasingStyle
						Enum.EasingDirection.Out, -- EasingDirection
						0, -- RepeatCount (when less than zero the tween will loop indefinitely)
						false, -- Reverses (tween will reverse once reaching it's goal)
						0 -- DelayTime
					)
					local tween = TweenService:Create(part, tweenInfo, { Position = randomT.PrimaryPart.Position })
					local disabledEffect = Instance.new("ParticleEmitter")
					disabledEffect.Rate = 8
					disabledEffect.Size = NumberSequence.new{
					    NumberSequenceKeypoint.new(0,0.25), -- (time, value)
					    NumberSequenceKeypoint.new(1,0.75)
					}
					disabledEffect.SpreadAngle = Vector2.new(100,100)
					disabledEffect.Lifetime = NumberRange.new(0.5)
					disabledEffect.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0,Color3.fromRGB(133, 255, 251)),
						ColorSequenceKeypoint.new(1,Color3.fromRGB(133, 255, 251))
					})
					disabledEffect.Name = "_DisabledEffect"
					disabledEffect.RotSpeed = NumberRange.new(25,25)
					disabledEffect.LightInfluence = 0
					part.Parent = workspace
					boltSound:Play()
					tween:Play()
					tween.Completed:Wait()
					if randomT ~= target.Main then randomT:FindFirstChild("Disabled").Value = true end
					disabledEffect.Parent = randomT.PrimaryPart
					damage(weapon,level,randomT.Humanoid)
					if #possibleTargets > 2 then
						table.remove(possibleTargets,table.find(possibleTargets,randomT))
					end
					--wait(1) -- Removed due to slow attack
					part:Destroy()
				end
			end
		end
	end
end

function Robot:fireUtility(roll,target)
	for utility,level in pairs(roll) do
		wait(1)
		if level > 0 then
			if utility == "Barrier" then
				print("SETTING UP BARRIER LEVEL X" .. level)
				wait(2)
			elseif utility == "Hack" then
				print("SETTING UP HACK LEVEL X" .. level)
				wait(2)
			elseif utility == "Energize" then
				print("SETTING UP ENERGIZE LEVEL X" .. level)
				wait(2)
			end
		end
	end
end

function Robot:fireBots(target)
	print("Bots shoot* pew* pew*")
	--[[
	spawn(function()
		if self.TankBot and self.TankBot:FindFirstChild("Disabled").Value == false then
			
		end
	end)
	spawn(function()
		if self.LaserBot and self.LaserBot:FindFirstChild("Disabled").Value == false then
			
		end
	end)
	if self.GunnerBot and self.GunnerBot:FindFirstChild("Disabled").Value == false then
		
	end
	]]
end

function Robot:toggleGunnerBot(level)
	if self.GunnerBot then
		self.GunnerBot:Destroy()
		self.GunnerBot = nil
	else
		self.GunnerBot = robotModels:FindFirstChild("Gunner"):Clone()
		self.GunnerBot.Humanoid.Died:Connect(function()
			local ref = self.GunnerBot
			self.GunnerBot = nil
			onBotDeath(ref)
		end)
		self.GunnerBot:SetPrimaryPartCFrame(self.Main["Bot CFrames"]["Gun Bot CFrame"].CFrame)
		self.GunnerBot.Eye.Color = self.Color
		self.GunnerBot.Parent = self.Main
	end
end

function Robot:toggleTankBot(level)
	if self.TankBot then
		self.TankBot:Destroy()
		self.TankBot = nil
	else
		self.TankBot = robotModels:FindFirstChild("Tank"):Clone()
		self.TankBot.Humanoid.Died:Connect(function()
			local ref = self.TankBot
			self.TankBot = nil
			onBotDeath(ref)
		end)
		self.TankBot:SetPrimaryPartCFrame(self.Main["Bot CFrames"]["Tank Bot CFrame"].CFrame)
		self.TankBot.Eye.Color = self.Color
		self.TankBot.Parent = self.Main
	end
end

function Robot:toggleLaserBot(level)
	if self.LaserBot then
		self.LaserBot:Destroy()
		self.LaserBot = nil
	else
		self.LaserBot = robotModels:FindFirstChild("Laser"):Clone()
		self.LaserBot.Humanoid.Died:Connect(function()
			local ref = self.LaserBot
			self.LaserBot = nil
			onBotDeath(ref)
		end)
		self.LaserBot:SetPrimaryPartCFrame(self.Main["Bot CFrames"]["Laser Bot CFrame"].CFrame)
		self.LaserBot.Eye.Color = self.Color
		self.LaserBot.Parent = self.Main
	end
end

function Robot:toggleBots(roll)--------------------------------TODO: add ranks, and upgrade functionality
	for bot,level in pairs(roll) do
		wait(1)
		if level > 0 then
			if bot == "Gunner" then
				if self.GunnerBot then
					spawn(function()
						self.GunnerBot:FindFirstChild("Disabled").Value = false
						local dEffect = self.GunnerBot.PrimaryPart:FindFirstChild("_DisabledEffect")
						if dEffect then dEffect:Destroy() end
						repairEffect(self.GunnerBot)
					end)
					self.GunnerBot.Humanoid.Health += self.GunnerBot.Humanoid.Health*VALUE_TABLE["Repair"][level]
				else
					self:toggleGunnerBot()
				end
			elseif bot == "Laser" then
				if self.LaserBot then
					spawn(function()
						self.LaserBot:FindFirstChild("Disabled").Value = false
						local dEffect = self.LaserBot.PrimaryPart:FindFirstChild("_DisabledEffect")
						if dEffect then dEffect:Destroy() end
						repairEffect(self.LaserBot)
					end)
					self.LaserBot.Humanoid.Health += self.LaserBot.Humanoid.Health*VALUE_TABLE["Repair"][level]
				else
					self:toggleLaserBot()
				end
			elseif bot == "Tank" then
				if self.TankBot then
					spawn(function()
						self.TankBot:FindFirstChild("Disabled").Value = false
						local dEffect = self.TankBot.PrimaryPart:FindFirstChild("_DisabledEffect")
						if dEffect then dEffect:Destroy() end
						repairEffect(self.TankBot)
					end)
					self.TankBot.Humanoid.Health += self.TankBot.Humanoid.Health*VALUE_TABLE["Repair"][level]
				else
					self:toggleTankBot()
				end
			end
		end
	end
end

return Robot
