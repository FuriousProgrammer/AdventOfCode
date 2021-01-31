local grid = {}
local start

for line in io.lines("input.txt") do
	local row = {}
	grid[#grid + 1] = row

	for c in line:gmatch(".") do
		row[#row + 1] = {
			path = c ~= " ";
			let  = c:match("%a")
		}

		if row[#row].path and not start then
			start = {x = #row, y = 1}
		end
	end
end

local dirs = {
	[0] = {x = 1, y = 0};
	[1] = {x = 0, y = 1};
	[2] = {x =-1, y = 0};
	[3] = {x = 0, y =-1};
}
local dir = 1
local pos = {x = start.x, y = start.y}

local part1 = ""
local part2 = 1 -- since stepping into the top counts!

while true do
	if grid[pos.y + dirs[dir].y][pos.x + dirs[dir].x].path then
		pos.y = pos.y + dirs[dir].y
		pos.x = pos.x + dirs[dir].x
		part1 = part1 .. (grid[pos.y][pos.x].let or "")
		part2 = part2 + 1
	elseif grid[pos.y + dirs[(dir + 1)%4].y][pos.x + dirs[(dir + 1)%4].x].path then
		dir = (dir + 1)%4
	elseif grid[pos.y + dirs[(dir - 1)%4].y][pos.x + dirs[(dir - 1)%4].x].path then
		dir = (dir - 1)%4
	else
		break
	end
end

print("Part 1:", part1)
print("Part 2:", part2)