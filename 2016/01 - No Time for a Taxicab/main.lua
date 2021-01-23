local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})
local bot = {x=0, y=0, dir=0}
grid[0][0] = true

local dirs = {
	[0] = {x= 0, y=-1};
	[1] = {x= 1, y= 0};
	[2] = {x= 0, y= 1};
	[3] = {x=-1, y= 0};
}

-- NOTE: really only one line of input
local part2
for line in io.lines("input.txt") do
	for dir, steps in line:gmatch("(%a)(%d+)") do

		bot.dir = (bot.dir + (dir=="L" and -1 or 1))%4
		for i = 1, tonumber(steps) do
			bot.x = bot.x + dirs[bot.dir].x
			bot.y = bot.y + dirs[bot.dir].y

			if not part2 and grid[bot.y][bot.x] then
				part2 = {x=bot.x, y=bot.y}
			end
			grid[bot.y][bot.x] = true

		end

	end
end

print("Part 1:", math.abs(bot.y) + math.abs(bot.x))
print("Part 2:", math.abs(part2.y) + math.abs(part2.x))