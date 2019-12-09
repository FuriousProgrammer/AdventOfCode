local min = 130254
local max = 678275

-- this puzzle SCREAMS a more exact solution is available!

-- Many optimizations are possible here, but the range is relatively tiny.
-- Big one: construct numbers in a way that always strictly increases!
local part1 = 0
local part2 = 0
for n = min, max do
	local digits = {}
	for i = 6, 1, -1 do
		digits[i] = n%10
		n = math.floor(n/10)
	end

	local double = false
	local doubledouble = false
	local decreases = true

	local c = 1
	local cc
	for i = 2, 6 do
		if digits[i] == digits[i - 1] then
			double = true
			c = c + 1
			if c == 2 and not doubledouble then
				cc = digits[i]
				doubledouble = true
			elseif cc == digits[i] then
				doubledouble = false
			end
		else
			c = 1
		end
		if digits[i] < digits[i - 1] then
			decreases = false
		end
	end

	if double and decreases then
		part1 = part1 + 1
		if doubledouble then
			part2 = part2 + 1
		end
	end
end

print("Part 1:", part1)
print("Part 2:", part2)