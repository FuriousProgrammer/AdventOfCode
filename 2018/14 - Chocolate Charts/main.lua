local input = 165061
local input2 = {}
for c in tostring(input):gmatch("(.)") do
	input2[#input2 + 1] = tonumber(c)
end


local elfA = 1
local elfB = 2

local scores = {3, 7}
local part2
local part2_pos = 1

local function checkForPart2(pos)
	pos = pos - 1
	for i = 1, #input2 do
		if scores[pos + i] ~= input2[i] then
			return nil
		end
	end
	return pos
end

while #scores < input + 10 or not part2 do
	local n = scores[elfA] + scores[elfB]
	if n >= 10 then -- max `n` is 18
		scores[#scores + 1] = 1
		n = n - 10
	end
	scores[#scores + 1] = n

	elfA = (elfA + scores[elfA])%#scores + 1
	elfB = (elfB + scores[elfB])%#scores + 1


	if not part2 then
		while part2_pos < #scores - #input2 + 1 do
			part2 = checkForPart2(part2_pos)
			part2_pos = part2_pos + 1
			if part2 then break end
		end
	end
end


local part1 = ""
for i = input + 1, input + 10 do
	part1 = part1 .. scores[i]
end
print("Part 1:", part1)
print("Part 2:", part2)