local nums = {}

for line in io.lines("input.txt") do
	local a, b, c = line:match(".-(%d+).-(%d+).-(%d+)")
	nums[#nums + 1] = {tonumber(a), tonumber(b), tonumber(c)}
end

local part1 = 0
for _, tri in pairs(nums) do
	local a, b, c = tri[1], tri[2], tri[3]
	if a+b+c-math.max(a,b,c) > math.max(a,b,c) then
		part1 = part1 + 1
	end
end
print("Part 1:", part1)

local part2 = 0
for i = 1, #nums, 3 do
	for j = 1, 3 do
		local a, b, c = nums[i][j], nums[i + 1][j], nums[i + 2][j]
		if a+b+c-math.max(a,b,c) > math.max(a,b,c) then
			part2 = part2 + 1
		end
	end
end
print("Part 2:", part2)