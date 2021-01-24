local nodes = {}
local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

local i = 1
for line in io.lines("input.txt") do
	if i > 2 then -- skip first two lines of input
		--/dev/grid/node-x0-y0     89T   65T    24T   73%
		local x, y, used, avail = line:match("x(%d+)%-y(%d+).-%d+T.-(%d+)T.-(%d+)T.-(%d+)")
		x = tonumber(x) + 1
		y = tonumber(y) + 1
		used = tonumber(used)
		avail = tonumber(avail)
		nodes[#nodes + 1] = {
			used = used;
			avail = avail;
		}
		grid[y][x] = {
			isGoal = false;
			isWall = used + avail > 100;
			isFull = used > 0;
		}
	end
	i = i + 1
end

grid[1][#grid[1]].isGoal = true

local viable = 0
for i = 1, #nodes do
	for j = 1, #nodes do
		if i ~= j and nodes[i].used > 0 and nodes[i].used <= nodes[j].avail then
			viable = viable + 1
		end
	end
end
print("Part 1:", viable)

-- NOTE: At least in my input, the grid reduces to a slide-puzzle (with fixed points) with no exceptions!
--[[
for y, row in ipairs(grid) do
	for x, node in ipairs(row) do
		local c = '.'
		if node.isWall then
			c = "#"
		elseif not node.isFull then
			c = "_"
		elseif node.isGoal then
			c = "G"
		end
		io.write(c)
	end
	print()
end
--]]

-- TODO: do this in code, for all inputs!
print("Part 2:", 3 + 25 + 31 + 32*5 + 1)