local grid1 = {
	{'1', '2', '3'};
	{'4', '5', '6'};
	{'7', '8', '9'};
}
grid1[0] = {}
grid1[4] = {}
local pos1 = {x=2, y=2}
local part1 = ""


local grid2 = {
	{nil, nil, '1', nil, nil};
	{nil, '2', '3', '4', nil};
	{'5', '6', '7', '8', '9'};
	{nil, 'A', 'B', 'C', nil};
	{nil, nil, 'D', nil, nil};
}
grid2[0] = {}
grid2[6] = {}
local pos2 = {x=1, y=3}
local part2 = ""


local dirs = {
	U = {x= 0, y=-1};
	D = {x= 0, y= 1};
	L = {x=-1, y= 0};
	R = {x= 1, y= 0};
}


for line in io.lines("input.txt") do
	for c in line:gmatch(".") do
		local dir = dirs[c]

		if grid1[pos1.y + dir.y][pos1.x + dir.x] then
			pos1.y = pos1.y + dir.y
			pos1.x = pos1.x + dir.x
		end
		if grid2[pos2.y + dir.y][pos2.x + dir.x] then
			pos2.y = pos2.y + dir.y
			pos2.x = pos2.x + dir.x
		end

	end

	part1 = part1 .. grid1[pos1.y][pos1.x]
	part2 = part2 .. grid2[pos2.y][pos2.x]
end

print("Part 1:", part1)
print("Part 2:", part2)