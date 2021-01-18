local points = {}
local minY, maxY, minX, maxX = math.huge, -math.huge, math.huge, -math.huge

for line in io.lines("input.txt") do
	local x, y = line:match("(%d+), (%d+)")
	x, y = tonumber(x), tonumber(y)
	minY, maxY, minX, maxX = math.min(minY, y), math.max(maxY, y), math.min(minX, x), math.max(maxX, x)
	points[#points + 1] = {x=x, y=y}
end

-- TODO: figure out some way to optimize this!
local counts = {}
for y = minY, maxY do
	for x = minX, maxX do

		local dists = {}
		for _, point in pairs(points) do
			dists[#dists + 1] = {
				dist = math.abs(point.x - x) + math.abs(point.y - y);
				point = point;
			}
		end
		table.sort(dists, function(a, b)
			return a.dist < b.dist
		end)
		if dists[1].dist < dists[2].dist then
			local min = dists[1].point
			if x == minX or x == maxX or y == minY or y == maxY then
				counts[min] = math.huge
			end
			counts[min] = (counts[min] or 0) + 1
		end

	end
end

local max = -math.huge
for _, count in pairs(counts) do
	if count ~= math.huge then
		max = math.max(max, count)
	end
end
print("Part 1:", max)

-- TODO: figure out some way to optimize this!
local maxSafeDist = 10000 -- <, not <=

local function manhattanSum(x, y)
	local sum = 0
	for _, point in pairs(points) do
		sum = sum + math.abs(point.x - x) + math.abs(point.y - y)
	end
	return sum
end

--[[
-- Expand boundaries in case the boundary of the "safe" region lies outside the bounds of the reported coordinates
-- Unnecessary for my input, likely for all inputs!
local stale = false
while not stale do -- TOP
	stale = true
	for x = minX, maxX do
		if manhattanSum(x, minY) < maxSafeDist then
			minY = minY - 1
			stale = false
			break
		end
	end
end
stale = false
while not stale do -- BOTTOM
	stale = true
	for x = minX, maxX do
		if manhattanSum(x, maxY) < maxSafeDist then
			maxY = maxY + 1
			stale = false
			break
		end
	end
end
stale = false
while not stale do -- LEFT
	stale = true
	for y = minY, maxY do
		if manhattanSum(minX, y) < maxSafeDist then
			minX = minX - 1
			stale = false
			break
		end
	end
end
stale = false
while not stale do -- RIGHT
	stale = true
	for y = minY, maxY do
		if manhattanSum(maxX, y) < maxSafeDist then
			maxX = maxX + 1
			stale = false
			break
		end
	end
end
--]]

local count = 0
for y = minY, maxY do
	for x = minX, maxX do
		if manhattanSum(x, y) < maxSafeDist then
			count = count + 1
		end
	end
end

print("Part 2:", count)