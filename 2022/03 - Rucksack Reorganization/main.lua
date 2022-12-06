local part1 = 0

local group = {}
local i = 0
local part2 = 0

for line in io.lines("input.txt") do
	group[i] = {}

	local counts1 = {} -- first compartment
	local a = line:sub(1, #line/2)
	for c in a:gmatch('.') do
		counts1[c] = true
		group[i][c] = true
	end

	local counts2 = {} -- second compartment
	local b = line:sub(#line/2 + 1)
	for c in b:gmatch('.') do
		counts2[c] = true
		group[i][c] = true
	end

	for c in pairs(counts2) do
		if counts1[c] then
			part1 = part1 + c:lower():byte() - ('a'):byte() + (c:lower() == c and 1 or 27)
		end
	end

	i = (i + 1)%3
	if i == 0 then
		for c in pairs(group[0]) do
			if group[1][c] and group[2][c] then
				part2 = part2 + c:lower():byte() - ('a'):byte() + (c:lower() == c and 1 or 27)
			end
		end
	end
end

print("Part 1: " .. part1)
print("Part 2: " .. part2)