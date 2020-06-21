wait()
local V = Instance.new("IntValue")
V.Name = "Zombie"
V.Parent = script.Parent
P = script.Parent
H = P.Humanoid
if P:findFirstChild("Shirt") ~= nil then
P:findFirstChild("Shirt"):remove()
end
if P:findFirstChild("Pants") ~= nil then
P:findFirstChild("Pants"):remove()
end
P.Head.BrickColor = BrickColor.new("Forest green")
P.Head.face.Texture = "rbxassetid://151248649"
P:findFirstChild("RightUpperArm").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("RightLowerArm").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("RightHand").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("RightFoot").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("RightUpperLeg").BrickColor = BrickColor.new("Reddish brown")
P:findFirstChild("RightLowerLeg").BrickColor = BrickColor.new("Reddish brown")
P:findFirstChild("LeftUpperArm").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("LeftLowerArm").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("LeftHand").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("LeftFoot").BrickColor = BrickColor.new("Forest green")
P:findFirstChild("LeftUpperLeg").BrickColor = BrickColor.new("Reddish brown")
P:findFirstChild("LeftLowerLeg").BrickColor = BrickColor.new("Reddish brown")
P:findFirstChild("UpperTorso").BrickColor = BrickColor.new("Reddish brown")
P:findFirstChild("LowerTorso").BrickColor = BrickColor.new("Reddish brown")

for i, thing in pairs(P:GetChildren()) do
	if thing:IsA("Accessory") then
		thing:Destroy()
	end
end

local emitter = script.ParticleEmitter:Clone()
emitter.Parent = P.Head
emitter.Enabled = true


deb = true
function Hit(hit)
if deb then
deb = false
if not hit.Parent or not hit.Parent:findFirstChild("Humanoid") then deb = true return end
if hit.Parent == script.Parent then deb = true return end
if hit.Parent:findFirstChild("Zombie") then deb = true return end
script:clone().Parent = hit.Parent
wait()
deb = true
end
end


Connections = {}
ps = P:children()
for i=1, #ps do
if ps[i].className == "Part" then
table.insert(Connections, ps[i].Touched:connect(function(h) Hit(h) end))
end
end