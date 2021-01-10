local rules = {}
local checkNow = false

local part1 = 0
for line in io.lines("input.txt") do
	if line == "" then
		checkNow = true
	elseif not checkNow then
		local n, rest = line:match("(%d+): (.+)")
		n = tonumber(n)
		if rest:match('"."') then
			rules[n] = rest:sub(2,-2)
		else
			local subrule = {}
			rules[n] = {subrule}

			for c in rest:gmatch("(%S+)") do
				if c == "|" then
					subrule = {}
					table.insert(rules[n], subrule)
				else
					subrule[#subrule + 1] = tonumber(c)
				end
			end

		end
	else -- checkNow
		-- TODO
	end
end

print("Part 1:", part1)