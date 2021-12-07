local vents = setmetatable({}, {
	__index = function(t, i)
		t[i] = setmetatable({}, {
			__index = function(t, i)
				t[i] = {0, 0}
				return t[i]
			end
		})
		return t[i]
	end
})

for line in io.lines("input.txt") do
	local x1, y1, x2, y2 = line:match("(%d+),(%d+) %-> (%d+),(%d+)")
	x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)

	if x1 > x2 then
		x1, x2 = x2, x1
		y1, y2 = y2, y1
	end

	-- TODO: check if any diagonals are *not* 45*
	local dx = x1 == x2 and 0 or 1
	local dy = y1 == y2 and 0 or (y1 > y2 and -1 or 1)

	local part1 = (dy == 0 or dx == 0) and 1 or 0

	local x, y = x1, y1
	while true do
		vents[y][x][1] = vents[y][x][1] + part1
		vents[y][x][2] = vents[y][x][2] + 1
		if x == x2 and y == y2 then break end		
		x = x + dx
		y = y + dy
	end
end

local part1 = 0
local part2 = 0
for _, row in pairs(vents) do
	for _, cell in pairs(row) do
		if cell[1] >= 2 then
			part1 = part1 + 1
		end
		if cell[2] >= 2 then
			part2 = part2 + 1
		end
	end
end

print("Part 1:", part1)
print("Part 2:", part2)