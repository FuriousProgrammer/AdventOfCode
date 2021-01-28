local data = {}
local total = 0

for line in io.lines("input.txt") do
	table.insert(data, 1, tonumber(line))
	total = total + tonumber(line)
end

local minCount, minQE = math.huge, math.huge

-- NOTE: This code *does not* verify if the remaining numbers can be split into the remaining groups!
local function addNextToGroup(current, currentCount, currentQE, target, fromI)
	if current > target or currentCount > minCount or currentQE > minQE then return end
	if current == target then
		minCount = currentCount
		minQE = math.min(minQE, currentQE)
		return
	end

	for i = fromI, #data do
		addNextToGroup(current + data[i], currentCount + 1, currentQE*data[i], target, i + 1)
	end
end

addNextToGroup(0, 0, 1, total/3, 1)
print("Part 1:", minQE)

minCount, minQE = math.huge, math.huge

addNextToGroup(0, 0, 1, total/4, 1)
print("Part 2:", minQE)