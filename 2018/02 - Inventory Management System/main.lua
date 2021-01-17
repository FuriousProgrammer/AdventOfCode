local ids = {}

local twos = 0
local threes = 0

for line in io.lines("input.txt") do
	local str = {}
	ids[#ids + 1] = str

	local counts = {}
	for c in line:gmatch("(.)") do
		str[#str + 1] = c
		counts[c] = (counts[c] or 0) + 1
	end

	local two, three = false, false
	for _, count in pairs(counts) do
		if count == 2 then two = true end
		if count == 3 then three = true end
		if two and three then break end
	end
	if two then twos = twos + 1 end
	if three then threes = threes + 1 end
end

print("Part 1:", twos*threes)

for i = 1, #ids - 1 do
	for j = i, #ids do
		local a, b = ids[i], ids[j]
--		assert(#a == #b)

		local miss
		for pos = 1, #a do
			if a[pos] ~= b[pos] then
				if miss then
					miss = nil
					break
				else
					miss = pos
				end
			end
		end

		if miss then
			table.remove(a, miss)
			print("Part 2:", table.concat(a))
			os.exit()
		end

	end
end