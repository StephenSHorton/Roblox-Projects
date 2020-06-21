local Debris = game:GetService("Debris")
local attackSound = script.Attack
local ANIMATION = {}
	function ANIMATION.defaultAttack(enemyCreep, localCreep)
		local beam = Instance.new("Beam",workspace)
		local attachment0 = Instance.new("Attachment", localCreep.PrimaryPart)
		local attachment1 = Instance.new("Attachment", enemyCreep.PrimaryPart)
		beam.Attachment0 = attachment0
		beam.Attachment1 = attachment1
		beam.Texture = "rbxassetid://439227796"
		beam.Color = ColorSequence.new(localCreep.HumanoidRootPart.Color)
		beam.TextureSpeed = 8
		beam.Transparency = NumberSequence.new(0.2)
		beam.FaceCamera = true
		beam.Width0 = 0.5
		beam.Width1 = 0.5
		attackSound:Play()
		Debris:AddItem(beam, 0.5)
		Debris:AddItem(attachment0, 0.3)
		Debris:AddItem(attachment1, 0.3)
	end
	function ANIMATION.death()
		local deathSound = script.Death
		deathSound:Play()
	end
return ANIMATION
