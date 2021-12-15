local map = {}

for line in io.lines("input.txt") do
	local n = {}
	for c in line:gmatch(".") do
		table.insert(n, {val = tonumber(c), visited = false})
	end

	table.insert(map, n)
end

local width, height = #map[1], #map
local function isLow(x, y)
	local val = map[y][x].val
	if y > 1      and map[y - 1][x].val <= val then return false end
	if y < height and map[y + 1][x].val <= val then return false end
	if x > 1      and map[y][x - 1].val <= val then return false end
	if x < width  and map[y][x + 1].val <= val then return false end
	return true
end

local function getBasinSize(x, y)
	-- basic flood fill - "visited" map is reused for all basins as no basins overlap!
	local size = 0

	local queue = {{x=x,y=y}}
	while #queue > 0 do
		local pos = table.remove(queue)
		if pos.y >= 1 and pos.y <= height and pos.x >= 1 and pos.x <= width then
			local cell = map[pos.y][pos.x]
			if cell.val ~= 9 and not cell.visited then
				cell.visited = true
				size = size + 1
				table.insert(queue, {y = pos.y + 1, x = pos.x})
				table.insert(queue, {y = pos.y - 1, x = pos.x})
				table.insert(queue, {y = pos.y, x = pos.x + 1})
				table.insert(queue, {y = pos.y, x = pos.x - 1})
			end
		end
	end

	return size
end

local part1 = 0
local basins = {}
for y, row in pairs(map) do
	for x, val in pairs(row) do
		if isLow(x, y) then
			part1 = part1 + 1 + val.val
			table.insert(basins, getBasinSize(x, y))
		end
	end
end

table.sort(basins)
print("Part 1:", part1)
print("Part 2:", basins[#basins]*basins[#basins - 1]*basins[#basins - 2])