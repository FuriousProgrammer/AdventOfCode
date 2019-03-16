local g = {}
for y = 0, 999 do
	g[y] = {}
	for x = 0, 999 do
		g[y][x] = {on = false, bright = 0}
	end
end

for line in io.lines("input.txt") do
	local on = not not line:find("on")
	local t = line:find("toggle")
	local x1,y1,x2,y2 = line:match("(%d+),(%d+) through (%d+),(%d+)")

	for y = y1, y2 do
		for x = x1, x2 do
			g[y][x].on = t and not g[y][x].on or on
			g[y][x].bright = math.max(0, g[y][x].bright + (t and 2 or on and 1 or -1))
		end
	end
end

local p1, p2 = 0, 0
for y = 0, 999 do
	for x = 0, 999 do
		p1 = p1 + (g[y][x].on and 1 or 0)
		p2 = p2 + g[y][x].bright
	end
end

print("Part 1:", p1)
print("Part 2:", p2)