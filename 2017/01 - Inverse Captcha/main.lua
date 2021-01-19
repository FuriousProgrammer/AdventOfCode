local nums = {}

-- NOTE: really only one line of input
local len = 0 -- for easy looping
for line in io.lines("input.txt") do
	for c in line:gmatch(".") do
		nums[len] = tonumber(c)
		len = len + 1
	end
end


local sum1 = 0
local sum2 = 0
for i = 0, len-1 do
	sum1 = sum1 + (nums[i] == nums[(i + 1)%len] and nums[i] or 0)
	sum2 = sum2 + (nums[i] == nums[(i + len/2)%len] and nums[i] or 0)
end

print("Part 1:", sum1)
print("Part 2:", sum2)