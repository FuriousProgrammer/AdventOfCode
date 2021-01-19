local sum1 = 0
local sum2 = 0

for line in io.lines("input.txt") do
	local nums = {}
	local max, min = -math.huge, math.huge
	for n in line:gmatch("%d+") do
		n = tonumber(n)
		nums[#nums + 1] = n
		max = math.max(max, n)
		min = math.min(min, n)
	end

	sum1 = sum1 + max - min
	table.sort(nums)
	local dobreak = false
	for i = #nums, 1, -1 do
		for j = 1, i-1 do
			if nums[i] % nums[j] == 0 then
				sum2 = sum2 + nums[i]/nums[j]
				dobreak = true
				break
			end
		end
		if dobreak then break end
	end
end

print("Part 1:", sum1)
print("Part 2:", sum2)