local input = 1309

local function powerAt(x, y)
	return tonumber(tostring((x + 10)*((x + 10)*y + input) + 1000):sub(-3,-3)) - 5
end
local grid = {}
for y = 1, 300 do
	grid[y] = {}
	for x = 1, 300 do
		grid[y][x] = powerAt(x, y)
	end
end

local max, maxCoords = -math.huge
for y = 1, 298 do
	for x = 1, 298 do

		local sum = 0
		for dy = 0, 2 do
			for dx = 0, 2 do
				sum = sum + grid[y + dy][x + dx]
			end
		end

		if sum > max then
			max = sum
			maxCoords = {x=x,y=y,size=3}
		end

	end
end
print("Part 1:", maxCoords.x .. ',' .. maxCoords.y)

for y = 1, 300 do
	for x = 1, 300 do

		-- try increasing squares from each coord, to reduce duplicate calculations
		local size = 1
		local sum = 0
		while true do
			for xx = x, x + size - 1 do
				sum = sum + grid[y + size - 1][xx]
			end
			for yy = y, y + size - 2 do -- don't double count the corner!
				sum = sum + grid[yy][x + size - 1]
			end

			if sum > max then
				max = sum
				maxCoords = {x=x,y=y,size=size}
			end

			size = size + 1
			if x + size - 1 > 300 or y + size - 1 > 300 then break end
		end

	end
end
print("Part 2:", maxCoords.x .. ',' .. maxCoords.y .. ',' .. maxCoords.size)