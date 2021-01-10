local nums = {}

for line in io.lines("input.txt") do
	nums[#nums + 1] = tonumber(line)
end

local counts = setmetatable({}, {__index = function(t, i)
	t[i] = 0;
	return 0;
end})
for i = 1, 25 do
	counts[nums[i]] = counts[nums[i]] + 1
end

local pos = 1
local n

local function search(sum)
	for i = pos, pos + 23 do -- previous 24, skipping last!
		local val = sum - nums[i]
		if counts[val] > (nums[i] == val and 1 or 0) then
			return true
		end
	end
	return false
end

while true do
	n = nums[pos + 25]
	if not search(n) then break end
	counts[nums[pos]] = counts[nums[pos]] - 1
	counts[n] = counts[n] + 1
	pos = pos + 1
end

print("Part 1:", n)

local first, last = 1, 2
sum = nums[1] + nums[2]

while true do
	last = last + 1
	sum = sum + nums[last]

	while sum > n do
		sum = sum - nums[first]
		first = first + 1
	end

	if sum == n then break end
end

local min, max = math.huge, -math.huge
for i = first, last do
	min = math.min(min, nums[i])
	max = math.max(max, nums[i])
end
print("Part 2:", max + min)