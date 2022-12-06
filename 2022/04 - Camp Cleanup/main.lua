local part1 = 0
local part2 = 0

for line in io.lines("input.txt") do
	local a_min, a_max, b_min, b_max = line:match("(%d+)%-(%d+),(%d+)%-(%d+)")
	a_min, a_max, b_min, b_max = tonumber(a_min), tonumber(a_max), tonumber(b_min), tonumber(b_max)

	if (a_min >= b_min and a_max <= b_max) or (b_min >= a_min and b_max <= a_max) then
	   	part1 = part1 + 1
	end

	if (a_min >= b_min and a_min <= b_max) or (b_min >= a_min and b_min <= a_max) then
		part2 = part2 + 1
	end
end

print("Part 1: " .. part1)
print("Part 2: " .. part2)