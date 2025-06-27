--fe slithering jiggling dick

local length = 5
local jiggleness = 2





local inf = math.huge
local lp = game.Players.LocalPlayer
local char = lp.Character
local ignore = {char}
local rs = game:GetService("RunService")
local stepped = rs.RenderStepped
local heartbeat = rs.Heartbeat
local ti = table.insert
local cons = {}
local netless_Y = Vector3.new(0, -30, 0)
local v3_101 = Vector3.new(1, 0, 1)
local v3_0 = Vector3.zero
local inf = math.huge

for _, part in pairs(char:GetDescendants()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
		part.Massless = false -- allow the part to contribute to total mass
	end
end

local function getNetlessVelocity(realPartVelocity)
	if not realPartVelocity then
		warn("getNetlessVelocity: realPartVelocity was nil")
		return Vector3.zero
	end

	if math.abs(realPartVelocity.Y) > 1 then
		return realPartVelocity * (25.1 / realPartVelocity.Y)
	end

	realPartVelocity = realPartVelocity * v3_101
	local mag = realPartVelocity.Magnitude
	if mag > 1 then
		realPartVelocity = realPartVelocity * (100 / mag)
	end
	return realPartVelocity + netless_Y
end
local function align(Part0, Part1, p, r)
    Part0.CustomPhysicalProperties = PhysicalProperties.new(0.0001, 0.0001, 0.0001, 0.0001, 0.0001)
    Part0.CFrame = Part1.CFrame

    local att0 = Instance.new("Attachment", Part0)
    att0.Name = "att0_" .. Part0.Name
    att0.Position = v3_0
    att0.Orientation = r or v3_0

    local att1 = Instance.new("Attachment", Part1)
    att1.Name = "att1_" .. Part1.Name
    att1.Position = p or v3_0
    att1.Orientation = v3_0

    local ape = Instance.new("AlignPosition", att0)
    ape.Name = "AlignPositionRtrue"
    ape.ApplyAtCenterOfMass = false
    ape.MaxForce = inf
    ape.MaxVelocity = inf
    ape.ReactionForceEnabled = false
    ape.Responsiveness = 200
    ape.Attachment0 = att0
    ape.Attachment1 = att1
    ape.RigidityEnabled = true

    local ao = Instance.new("AlignOrientation", att0)
    ao.Name = "AlignOrientation"
    ao.MaxAngularVelocity = inf
    ao.MaxTorque = inf
    ao.PrimaryAxisOnly = false
    ao.ReactionTorqueEnabled = true
    ao.Responsiveness = 200
    ao.Attachment0 = att0
    ao.Attachment1 = att1
    ao.RigidityEnabled = true

    if type(getNetlessVelocity) == "function" then
        local realVelocity = Vector3.new(0, 30, 0)
        local steppedcon = stepped:Connect(function()
            Part0.Velocity = realVelocity
        end)
        local heartbeatcon = heartbeat:Connect(function()
            realVelocity = Part0.Velocity
            Part0.Velocity = getNetlessVelocity(realVelocity)
        end)
        Part0.Destroying:Connect(function()
            steppedcon:Disconnect()
            heartbeatcon:Disconnect()
        end)
        ti(cons, steppedcon)
        ti(cons, heartbeatcon)
    end

    return att0, att1
end
-- Ignore accessories
for _, v in pairs(char:GetDescendants()) do
	if v:IsA("Accessory") then
		table.insert(ignore, v)
	end
end

-- Track added Pal Hairs
local palhairs = {}
char.ChildAdded:Connect(function(child)
	if child.Name == "Pal Hair" then
		table.insert(palhairs, child)
	end
end)

-- Spawn hats via command
local cmd = "-gh 62724852"
for i = 1, length do
	cmd = cmd .. ",8721781803"
end
game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(cmd)
wait(1)
game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("-net")
-- Detect already present Pal Hairs just in case
for _, v in ipairs(char:GetChildren()) do
	if v.Name == "BurgerHat" and not table.find(palhairs, v) then
		table.insert(palhairs, v)
	end
end

-- Wait until all Pal Hairs are added
repeat task.wait() until #palhairs >= length

-- Remove welds/meshes
for _, v in pairs(char:GetDescendants()) do
	if (v:IsA("Constraint") or v:IsA("Weld") or v:IsA("SpecialMesh")) and not table.find(ignore, v.Parent.Parent) then
		v:Destroy()
	end
end

local v1 = char["Kate Hair"]
v1.Handle.Massless = true

align(v1.Handle, char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"), Vector3.new(0, -1.25, -0.5), Vector3.new(0, 90, 0))
local suc, err = pcall(function()
	if type(getNetlessVelocity) == "function" then
		local realVelocity = Vector3.new(0, 30, 0)

		local steppedcon = stepped:Connect(function()
			if v1 and v1:FindFirstChild("Handle") then
				v1.Handle.Velocity = realVelocity
			end
		end)

		local heartbeatcon = heartbeat:Connect(function()
			if v1 and v1:FindFirstChild("Handle") then
				realVelocity = v1.Handle.Velocity
				v1.Handle.Velocity = getNetlessVelocity(realVelocity)
			end
		end)

		if v1 and v1:FindFirstChild("Handle") then
			v1.Handle.Destroying:Connect(function()
				steppedcon:Disconnect()
				heartbeatcon:Disconnect()
			end)
		end

		ti(cons, steppedcon)
		ti(cons, heartbeatcon)
	end
end)

if not suc then
	error("creator is a fucking dumbass, fix this fag: " .. err)
end

-- Crank toggle logic
local iscranking = false
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if game:GetService("UserInputService"):GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.E then
		iscranking = not iscranking
	end	
end)

-- Crank state alternator
local crank = false
coroutine.wrap(function()
	while true do
		crank = not crank
		wait(0.1)
	end
end)()

-- Cranker object to move
local cranker = nil
local prev = nil

-- Apply alignments to each Pal Hair
for i, v in next, palhairs do
	local v2 = v
	if not v2:FindFirstChild("Handle") then continue end
	v2.Handle.Massless = true
	local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	local att0, att1 = align(v2.Handle, torso)
	local proxy = Instance.new("Part", workspace)
	proxy.Massless = true
	proxy.Transparency = 1
	proxy.Size = v2.Handle.Size
	proxy.CFrame = v2.Handle.CFrame
	proxy.CanCollide = false

	for _, limb in pairs(char:GetDescendants()) do
		if limb:IsA("BasePart") then
			local noc = Instance.new("NoCollisionConstraint")
			noc.Part0 = proxy
			noc.Part1 = limb
			noc.Parent = proxy
		end
	end

	local connector = Instance.new("BallSocketConstraint", proxy)
	connector.LimitsEnabled = true
	connector.UpperAngle = jiggleness + 20

	connector.TwistLimitsEnabled = true
	connector.TwistLowerAngle = -jiggleness
	connector.TwistUpperAngle = jiggleness + 20

	local catt0 = Instance.new("Attachment")
	if prev then
		catt0.Parent = prev
		catt0.Position = Vector3.new(0, 0, -0.5)
	else
		catt0.Parent = torso
		catt0.Position = Vector3.new(0, -1, -0.5)
	end
	connector.Attachment0 = catt0

	local catt1 = Instance.new("Attachment", proxy)
	catt1.Position = Vector3.new(0, 0, 0.4)
	connector.Attachment1 = catt1

	local suc, err = pcall(function()
		if type(getNetlessVelocity) == "function" then
			local realVelocity = Vector3.new(0, 30, 0)
			local steppedcon = stepped:Connect(function()
				if v2 and v2:FindFirstChild("Handle") then
					if proxy and att1 and torso then
						-- Position relative to torso
						att1.Position = torso.CFrame:pointToObjectSpace(proxy.Position)

						-- Rotation relative to torso
						local relativeCFrame = torso.CFrame:toObjectSpace(proxy.CFrame)
						local x, y, z = relativeCFrame.Rotation:ToEulerAnglesXYZ()
						att1.Rotation = Vector3.new(
							math.deg(x),
							math.deg(y),
							math.deg(z)
						)
					end
				end
			end)
		end
	end)

	if not suc then
		error("creator is a fucking dumbass, fix this fag: " .. err)
	end

	prev = v2.Handle
	if i == length then
		cranker = att0
	end
end
