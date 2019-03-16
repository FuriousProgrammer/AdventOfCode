local t = 0
local rib = 0

for line in io.lines("input.txt") do
	local l, w, h = line:match("(%d+)x(%d+)x(%d+)")
	l, w, h = tonumber(l), tonumber(w), tonumber(h)
	t = t + 2*l*w + 2*w*h + 2*h*l + math.min(l*w, w*h, h*l)
	rib = rib + l*w*h + 2*(l + w + h - math.max(l, w, h))
end

print("Part 1:", math.floor(t)) -- to strip trailing .0
print("Part 2:", math.floor(rib))