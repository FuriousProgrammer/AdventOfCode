local map = {}

for line in io.lines("input.txt") do
	local n = {}
	table.insert(map, n)

	for c in line:gmatch(".") do
		table.insert(n, {risk = tonumber(c), totalRisk = math.huge})
	end
end
local width, height = #map[1], #map

for y = 1, height do
	for x = 1, width do
		map[y][x].y = y
		map[y][x].x = x
	end
end

map[1][1].totalRisk = 0
map[1][1].stale = true
local queue = {map[1][1]}
local queueSize = 1

local function process(x, y, enterRisk)
	if x < 1 or x > width or y < 1 or y > height then return end
	
	local newRisk = map[y][x].risk + enterRisk
	if newRisk > map[height][width].totalRisk then return end

	if map[y][x].totalRisk > newRisk then
		map[y][x].totalRisk = newRisk

		table.insert(queue, map[y][x])
		queueSize = queueSize + 1

		map[y][x].stale = true
	end
end

local function djikstra()
	map[height][width].totalRisk = 0
	for x = 2, width do
		map[height][width].totalRisk = map[height][width].totalRisk + map[1][x].risk
	end
	for y = 2, height do
		map[height][width].totalRisk = map[height][width].totalRisk + map[y][width].risk
	end

	while queueSize > 0 do
		local max, index = math.huge
		for n, t in pairs(queue) do
			if map[t.y][t.x].totalRisk < max then
				max = map[t.y][t.x].totalRisk
				index = n
			end
		end

		node = queue[index]
		queue[index] = nil
		queueSize = queueSize - 1

		if map[node.y][node.x].stale then
			map[node.y][node.x].stale = false

			process(node.x + 1, node.y, node.totalRisk)
			process(node.x - 1, node.y, node.totalRisk)
			process(node.x, node.y + 1, node.totalRisk)
			process(node.x, node.y - 1, node.totalRisk)
		end
	end
end

djikstra()
print("Part 1:", map[width][height].totalRisk)

-- add map edges to queue:
for y = 1, height do
	table.insert(queue, map[y][width])
	map[y][width].stale = true
end
for x = 1, width - 1 do
	table.insert(queue, map[height][x])
	map[height][x].stale = true
end
queueSize = #queue

-- expand map:
for tileY = 0, 4 do
	for tileX = 0, 4 do

		if tileX ~= 0 or tileY ~= 0 then

			for y = 1, height do
				if not map[y + height*tileY] then
					map[y + height*tileY] = {}
				end

				for x = 1, width do
					local n = tileY + tileX + map[y][x].risk
					if n > 9 then n = n - 9 end
					map[y + height*tileY][x + width*tileX] = {y = y + height*tileY, x = x + width*tileX, risk = n, totalRisk = math.huge}
				end
			end

		end

	end
end
width = 5*width
height = 5*height

djikstra()
print("Part 2:", map[width][height].totalRisk)