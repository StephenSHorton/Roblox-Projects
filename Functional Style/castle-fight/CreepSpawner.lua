local attributes = script.Parent.Attributes
--wait(attributes["Spawn Rate"].Value)
local owner = script.Parent:FindFirstChild("Owner")
local team
if workspace.Teams["Team 1"]:FindFirstChild(owner.Value.Name) then
	team = "Team 1"
else
	team = "Team 2"
end
local color
if team == "Team 1" then
	color = BrickColor.new("Bright red")
else
	color = BrickColor.new("Bright blue")
end
script.Parent.Creep.HumanoidRootPart.BrickColor = color
script.Parent.Base.BrickColor = color

for i, part in ipairs(script.Parent.Building.Color:GetChildren()) do
	part.BrickColor = color
end
for i, part in ipairs(script.Parent.Creep.Body.Color:GetChildren()) do
	part.BrickColor = color
end

while workspace["Thread Function Stopper"].Value == false do
	wait(script.Parent.Attributes["Spawn Rate"].Value)
	local creep = script.Parent.Creep:Clone()
	local ownerClone = owner:Clone()
	ownerClone.Parent = creep
	local teamTag = Instance.new("StringValue")
	teamTag.Value = team
	teamTag.Name = "Team"
	teamTag.Parent = creep
	local creepAtt = attributes["Creep Attributes"]:Clone()
	creepAtt.Parent = creep
	creep.PrimaryPart = creep:FindFirstChild("HumanoidRootPart")
	creep:FindFirstChild("Health Gui").Enabled = true
	creep:FindFirstChild("HumanoidRootPart").Anchored = false
	creep.Parent = workspace
	if workspace.Teams["Team 1"]:FindFirstChild(owner.Value.Name) then
		creep:SetPrimaryPartCFrame(CFrame.new(workspace["Team 1 Creep Spawn"].Position + Vector3.new(0,0.5,8) - Vector3.new(0,0,math.random(15))))
	else
		creep:SetPrimaryPartCFrame(CFrame.new(workspace["Team 2 Creep Spawn"].Position + Vector3.new(0,0.5,8) - Vector3.new(0,0,math.random(15))))
	end
	creep["Creep Controller"].Disabled = false
end