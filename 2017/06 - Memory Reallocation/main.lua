local banks = {}

-- NOTE: really just one line of input
for line in io.lines("input.txt") do
	for n in line:gmatch("%d+") do
		banks[#banks + 1] = tonumber(n)
	end
end

local seen = {}
seen[table.concat(banks, ":")] = 0

local cycles = 0
while true do
	cycles = cycles + 1

	local max, maxi = -math.huge
	for i, count in ipairs(banks) do
		if count > max then
			max = count
			maxi = i
		end
	end
	banks[maxi] = 0

	while max > 0 do
		maxi = maxi % #banks + 1
		banks[maxi] = banks[maxi] + 1
		max = max - 1
	end

	local cache = table.concat(banks, ":")
	if seen[cache] then
		seen = seen[cache]
		break
	end
	seen[cache] = cycles
end

print("Part 1:", cycles)
print("Part 2:", cycles - seen)