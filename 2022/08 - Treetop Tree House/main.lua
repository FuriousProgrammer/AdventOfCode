local grid = {}

for line in io.lines("input.txt") do
	local row = {}
	table.insert(grid, row)

	for c in line:gmatch(".") do
		local cell = {
			height = tonumber(c);
		}
		table.insert(row, cell)
	end
end

local h, w = #grid, #grid[1] -- NOTE: assuming all inputs are rectangular

for y = 1, h do
	-- walk each row from the left
	local max = -1
	for x = 1, w do
		if grid[y][x].height > max then
			max = grid[y][x].height
			grid[y][x].visible = true
		end
	end

	-- walk each row from the right
	max = -1
	for x = w, 1, -1 do
		if grid[y][x].height > max then
			max = grid[y][x].height
			grid[y][x].visible = true
		end
	end
end

for x = 1, w do
	-- walk each col from above
	local max = -1
	for y = 1, h do
		if grid[y][x].height > max then
			max = grid[y][x].height
			grid[y][x].visible = true
		end
	end

	-- walk each col from below
	max = -1
	for y = h, 1, -1 do
		if grid[y][x].height > max then
			max = grid[y][x].height
			grid[y][x].visible = true
		end
	end
end

local dx = {-1,0,1,0}
local dy = {0,-1,0,1}
local function computeScenicScore(sx, sy)
	local score = 1
	for i = 1, 4 do
		local dirScore = 0

		local x, y = sx+dx[i], sy+dy[i]
		while (x > 0 and x <= w) and (y > 0 and y <= h) do
			dirScore = dirScore + 1
			if grid[y][x].height >= grid[sy][sx].height then
				break
			end
			x = x + dx[i]
			y = y + dy[i]
		end

		score = score*dirScore
	end
	return score
end

local part1 = 0
local part2 = 0
for y = 1, h do
	for x = 1, w do
		if grid[y][x].visible then
			part1 = part1 + 1
		end

		part2 = math.max(part2, computeScenicScore(x, y))
	end
end
print("Part 1: " .. part1)
print("Part 2: " .. part2)