local lights = {}

for line in io.lines("input.txt") do
	local x, y, dx, dy = line:match("position=<(......), (......)> velocity=<(..), (..)>")
	local n = {
		x = tonumber(x);
		y = tonumber(y);
		dx = tonumber(dx);
		dy = tonumber(dy);
	}
	lights[#lights + 1] = n
end

print("Part 1:")
local t = 0
local minX, maxX, minY, maxY
while true do
	minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
	for _, point in pairs(lights) do
		point.x = point.x + point.dx
		point.y = point.y + point.dy
		minX, maxX, minY, maxY = math.min(minX, point.x), math.max(maxX, point.x), math.min(minY, point.y), math.max(maxY, point.y)
	end
	t = t + 1

	if maxY - minY + 1 == 10 then break end -- letter height discovered through trial and error!
end

local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})
for _, point in pairs(lights) do
	grid[point.y][point.x] = true
end
for y = minY, maxY do
	local out = ""
	for x = minX, maxX do
		out = out .. (grid[y][x] and "#" or " ")
	end
	print(out)
end
print("Part 2:", t)