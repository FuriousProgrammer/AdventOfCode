local grid = {}

for y = 0, 5 do
	grid[y] = {}
	for x = 0, 49 do
		grid[y][x] = false
	end
end

for line in io.lines("input.txt") do
	if line:find("rect") then
		local w, h = line:match("(%d+)x(%d+)")
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				grid[y][x] = true
			end
		end
	else
		local xy, id, by = line:match("(.)=(%d+) by (%d+)")
		id, by = tonumber(id), tonumber(by)
		if xy == "y" then
			local n = {}
			for x = 0, 49 do
				n[(x + by)%50] = grid[id][x]
			end
			grid[id] = n
		else -- xy == "y"
			local n = {}
			for y = 0, 5 do
				n[(y + by)%6] = grid[y][id]
			end

			for y = 0, 5 do
				grid[y][id] = n[y]
			end
		end
	end
end

-- NOTE: I refuse to print these out of order
local part1 = 0
for y = 0, 5 do
	for x = 0, 49 do
		part1 = part1 + (grid[y][x] and 1 or 0)
	end
end

print("Part 1:", part1)

local boxes = {
	[0] = ' ';
	[1] = string.char(223);
	[2] = string.char(220);
	[3] = string.char(219);
}

print("Part 2:")
for y = 0, 5, 2 do
	for x = 0, 49 do
		local id = 0
		if grid[y][x] then id = id + 1 end
		if grid[y + 1][x] then id = id + 2 end
		io.write(boxes[id])
	end
	io.write("\n")
end
print()