local rules = {}
local checkNow = false
local lines = {}

for line in io.lines("input.txt") do
	if line == "" then
		checkNow = true

	-- rule parsing:
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

	else -- checkNow == true
		lines[#lines + 1] = line
	end
end

local function validate(text, rule)
	if not text or #text == 0 then return false end
	if type(rules[rule]) == "string" then
		return text:sub(1,1) == rules[rule] and text:sub(2)
	end

	for _, subrule in pairs(rules[rule]) do
		local subText = text
		for _, innerRule in ipairs(subrule) do
			subText = validate(subText, innerRule)
		end
		if subText then return subText end
	end
end

local sum = 0
for _, line in pairs(lines) do
	if validate(line, 0) == "" then
		sum = sum + 1
	end
end
print("Part 1:", sum)

-- rules[8] = {{42}, {42, 8}}
-- rules[11] = {{42, 31}, {42, 11, 31}}
-- NOTE: rules 8 and 11 are ONLY used by themselves and rule 0 so...

	-- match rule 42 for the nth time, return false if failed
	-- match rule 31 until we fully match, fail, or have matched n-1 times without fully matching
		-- if fully matched, return empty string!
	-- recurse, incrementing n!

local function part2(line, depth)
	line = validate(line, 42)
	if not line then return false end

	local line2 = line
	for i = 1, depth do
		line2 = validate(line2, 31)
		if not line2 then break end -- early out optimization!
		if line2 == "" then return line2 end
	end

	return part2(line, depth + 1)
end

sum = 0
for _, line in pairs(lines) do
	if part2(line, 0) == "" then
		sum = sum + 1
	end
end
print("Part 2:", sum)