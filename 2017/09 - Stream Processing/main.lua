local score = 0
local garbage = 0

-- NOTE: really only one line of input
for line in io.lines("input.txt") do
	local value = 0
	local inGarbage = false
	local cancelled = false

	for c in line:gmatch(".") do
		if cancelled then
			cancelled = false
		elseif inGarbage then
			if c == "!" then
				cancelled = true
			elseif c == ">" then
				inGarbage = false
			else
				garbage = garbage + 1
			end
		else -- not garbage
			if c == "{" then
				value = value + 1
			elseif c == "}" then
				score = score + value
				value = value - 1
			elseif c == "<" then
				inGarbage = true
			end
		end
	end
end

print("Part 1:", score)
print("Part 2:", garbage)