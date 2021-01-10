local max = -math.huge
local min = math.huge

local dat = {}

for t in io.lines("input.txt") do

	t = t:gsub('B', '1')
	t = t:gsub('F', '0')
	t = t:gsub('R', '1')
	t = t:gsub('L', '0')

	local n = tonumber(t, 2)
	dat[n] = true
	max = math.max(max, n)
	min = math.min(min, n)

end

print("Part 1:", max)

for i = min, max do
	if not dat[i] then
		print("Part 2:", i)
		break
	end
end