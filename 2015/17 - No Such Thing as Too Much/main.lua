local caps = {}

for line in io.lines("input.txt") do
	caps[#caps + 1] = tonumber(line)
end

table.sort(caps, function(a, b) return a > b end)

local min, minCount = math.huge, 0
local combos = 0

local function use(rem, count, used)
	rem = rem - caps[used]

	if rem < 0 then return end

	if rem == 0 then
		combos = combos + 1
		if count < min then
			min = count
			minCount = 1
		elseif count == min then
			minCount = minCount + 1
		end
		return
	end

	for i = used + 1, #caps do
		use(rem, count + 1, i)
	end
end

for i = 1, #caps do
	use(150, 0, i)
end

print("Part 1:", combos)
print("Part 2:", minCount)