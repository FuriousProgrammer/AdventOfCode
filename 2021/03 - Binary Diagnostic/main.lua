local ones = {}
local nums = {}

for line in io.lines("input.txt") do
	if not LEN then
		LEN = #line
		for i = 1, LEN do
			ones[i] = 0
		end
	end

	for i = 1, LEN do
		ones[i] = ones[i] + tonumber(line:sub(i,i))
	end

	table.insert(nums, line)
end


local min = {}
local max = {}
for i = 1, LEN do
	max[i] = (ones[i] > #nums/2 and 1 or 0)
	min[i] = 1 - max[i]
end

print("Part 1:", tonumber(table.concat(min), 2)*tonumber(table.concat(max), 2))

local numsMin, numsMax = {}, {}
local goesMax = ones[1] > #nums/2 and '1' or '0'
-- TODO: verify that first pass is unambiguous
for _, line in pairs(nums) do
	table.insert(line:sub(1,1) == goesMax and numsMax or numsMin, line)
end

local i = 2
while #numsMax > 1 do
	local ones = 0
	for _, line in pairs(numsMax) do
		ones = ones + tonumber(line:sub(i,i))
	end

	local n = {}
	goesMax = ones >= #numsMax/2 and '1' or '0'

	for _, line in pairs(numsMax) do
		if line:sub(i,i) == goesMax then
			table.insert(n, line)
		end
	end

	numsMax = n
	i = i + 1
end

i = 2
while #numsMin > 1 do
	local ones = 0
	for _, line in pairs(numsMin) do
		ones = ones + tonumber(line:sub(i,i))
	end

	local n = {}
	goesMin = ones >= #numsMin/2 and '0' or '1'

	for _, line in pairs(numsMin) do
		if line:sub(i,i) == goesMin then
			table.insert(n, line)
		end
	end

	numsMin = n
	i = i + 1
end

print("Part 2:", tonumber(numsMin[1], 2)*tonumber(numsMax[1], 2))