local part1 = 0
local part2 = 0

for line in io.lines("input.txt") do
	local words, valid1 = {}, true
	local anagrams, valid2 = {}, true

	for word in line:gmatch("%w+") do
		if words[word] then valid1 = false end
		words[word] = true

		local ana = {}
		for c in word:gmatch(".") do
			ana[#ana + 1] = c
		end
		table.sort(ana)
		word = table.concat(ana)
		if anagrams[word] then valid2 = false end
		anagrams[word] = true
	end

	part1 = part1 + (valid1 and 1 or 0)
	part2 = part2 + (valid2 and 1 or 0)
end

print("Part 1:", part1)
print("Part 2:", part2)