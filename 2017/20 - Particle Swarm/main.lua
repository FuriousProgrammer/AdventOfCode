local parts = {}

local part1, minAcc = -1, math.huge

for line in io.lines("input.txt") do
	--p=<1609,-863,-779>, v=<-15,54,-69>, a=<-10,0,14>
	local px, py, pz, vx, vy, vz, ax, ay, az = line:match("p=<(%-?%d+),(%-?%d+),(%-?%d+)>, v=<(%-?%d+),(%-?%d+),(%-?%d+)>, a=<(%-?%d+),(%-?%d+),(%-?%d+)>")
	parts[#parts + 1] = {
		pos = {x = tonumber(px), y = tonumber(py), z = tonumber(pz)};
		vel = {x = tonumber(vx), y = tonumber(vy), z = tonumber(vz)};
		acc = {x = tonumber(ax), y = tonumber(ay), z = tonumber(az)};
	}

	local acc = math.abs(ax) + math.abs(ay) + math.abs(az)
	if acc < minAcc then
		minAcc = acc
		part1 = #parts - 1 -- 0-indexing!
	end
end

print("Part 1:", part1)

local count, dur = #parts, 0
-- A "cheap" way to determine if all collisions have happened
while dur < 30 do
	-- clear collisions:
	local i = 1
	while i < #parts do
		local j = i + 1
		local hit = false

		while j <= #parts do
			local a, b = parts[i], parts[j]
			if a.pos.x == b.pos.x and a.pos.y == b.pos.y and a.pos.z == b.pos.z then
				table.remove(parts, j)
				hit = true
			else
				j = j + 1
			end
		end

		if hit then
			table.remove(parts, i)
		else
			i = i + 1
		end
	end

	-- update tracker
	if #parts < count then
		count = #parts
		dur = 1
	else
		dur = dur + 1
	end

		-- update positions:
	for _, node in pairs(parts) do
		node.vel.x = node.vel.x + node.acc.x
		node.vel.y = node.vel.y + node.acc.y
		node.vel.z = node.vel.z + node.acc.z

		node.pos.x = node.pos.x + node.vel.x
		node.pos.y = node.pos.y + node.vel.y
		node.pos.z = node.pos.z + node.vel.z
	end
end

print("Part 2:", #parts)