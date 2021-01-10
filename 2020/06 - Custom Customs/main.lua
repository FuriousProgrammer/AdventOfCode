local sum = 0
local sum2 = 0

local function process(t)
	local counted = {}
	local s = 0
	local n = 0
	for c in t:gmatch('.') do
		if c == '\n' then
			n = n + 1
		else
			if not counted[c] then
				s = s + 1
				counted[c] = 0
			end
			counted[c] = counted[c] + 1
		end
	end

	sum = sum + s
	s = 0
	for _, v in pairs(counted) do
		if v == n then
			s = s + 1
		end
	end
	sum2 = sum2 + s
end

local t = ""
for line in io.lines("input.txt") do
	if line == '' then
		process(t)
		t = ""
	else
		t = t .. '\n' .. line
	end
end
process(t)

print("Part 1:", sum)
print("Part 2:", sum2)