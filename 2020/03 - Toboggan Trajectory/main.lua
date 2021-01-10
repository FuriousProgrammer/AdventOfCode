local map = {}
local width

for line in io.lines("input.txt") do
	local t = {}
	local i = 0
	map[#map + 1] = t
	for c in line:gmatch(".") do
		t[i] = c == '#'
		i = i + 1
	end
	width = #line
end

local function t(sx, sy)
	local x, y = 0, 1
	local count = 0
	while true do
		x = (x + sx)%width
		y = y + sy

		if map[y][x] then
			count = count + 1
		end

		if y == #map then break end
	end

	return count
end

print("Part 1:", t(3, 1))
print("Part 2:", t(1, 1)*t(3,1)*t(5,1)*t(7,1)*t(1,2))