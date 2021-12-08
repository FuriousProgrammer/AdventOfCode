local crabs = setmetatable({}, {
	__index = function(t, i)
		t[i] = 0
		return t[i]
	end
})

local min, max = math.huge, -math.huge
for line in io.lines("input.txt") do
	for n in line:gmatch("%d+") do
		min = math.min(n, min)
		max = math.max(n, max)
		crabs[n] = crabs[n] + 1
	end
	break
end

local min1 = math.huge
local min2 = math.huge
for target = min, max do
	local sum1 = 0
	local sum2 = 0
	for source, amt in pairs(crabs) do
		local n = math.abs(target - source)
		sum1 = sum1 + n*amt
		sum2 = sum2 + amt*(n*(n+1))/2
	end
	min1 = math.min(sum1, min1)
	min2 = math.min(sum2, min2)
end
print("Part 1:", min1)
print("Part 2:", min2)