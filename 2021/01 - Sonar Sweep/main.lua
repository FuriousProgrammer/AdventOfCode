local prev1 = math.huge
local count1 = 0

local nums = {}
local i = 1
local running = 0
local prev2 = math.huge
local count2 = 0

for line in io.lines("input.txt") do
	local n = tonumber(line)
	nums[i] = n

	if n > prev1 then
		count1 = count1 + 1
	end
	prev1 = n

	running = running + n - (nums[i - 3] or 0)
	if i >= 3 then
		if running > prev2 then
			count2 = count2 + 1
		end
		prev2 = running
	end

	i = i + 1
end

print("Part 1:", count1)
print("Part 2:", count2)