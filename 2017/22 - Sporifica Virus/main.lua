local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

local mt2 = {
	__index = function(t, i)
		t[i] = 3
		return 3
	end;
}
local grid2 = setmetatable({}, {
	__index = function(t, i)
		t[i] = setmetatable({}, mt2)
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	local row = grid[#grid + 1]
	local row2 = grid2[#grid2 + 1]
	for c in line:gmatch(".") do
		row[#row + 1] = c == "#"
		row2[#row2 + 1] = (c == "#" and 1 or 3)
	end
end

local dirs = {
	[0] = {x = 1, y = 0};
	[1] = {x = 0, y = 1};
	[2] = {x =-1, y = 0};
	[3] = {x = 0, y =-1};
}


local dir = 3
local x, y = 13, 13 -- NOTE: my grid is (and probably all grids are) precisely 25x25
local part1 = 0
for _ = 1, 10000 do
	dir = (dir + (grid[y][x] and 1 or -1))%4

	grid[y][x] = not grid[y][x]
	part1 = part1 + (grid[y][x] and 1 or 0)

	y = y + dirs[dir].y
	x = x + dirs[dir].x
end
print("Part 1:", part1)


dir = 3
x, y = 13, 13
local part2 = 0
for _ =  1, 10000000 do
	dir = (dir + grid2[y][x])%4
	grid2[y][x] = (grid2[y][x] + 1)%4

	part2 = part2 + (grid2[y][x] == 1 and 1 or 0)

	y = y + dirs[dir].y
	x = x + dirs[dir].x
end
print("Part 2:", part2)