local state = {}
local rules = {}

local i = 1
for line in io.lines("input.txt") do
	if i == 1 then
		line = line:sub(16)
		local j = 0
		for c in line:gmatch("(.)") do
			state[j] = c
			j = j + 1
		end
	elseif i >= 3 then
		local rule, output = line:match("(.....) => (.)")
		rules[rule] = output
	end
	i = i + 1
end

for _ = 1, 20 do
	local n = {}

	local function fill(pos)
		if n[pos] then return end
		local check = ""
		for i = pos - 2, pos + 2 do
			check = check .. (state[i] or ".")
		end
		n[pos] = rules[check]
	end

	for pos, plant in pairs(state) do
		if plant == "#" then
			for i = pos - 2, pos + 2 do
				fill(i)
			end
		end
	end

	state = n
end

local sum = 0
for pos, plant in pairs(state) do
	if plant == "#" then
		sum = sum + pos
	end
end
print("Part 1:", sum)

for generation = 21, 2000 do
	local n = {}

	local function fill(pos)
		if n[pos] then return end
		local check = ""
		for i = pos - 2, pos + 2 do
			check = check .. (state[i] or ".")
		end
		n[pos] = rules[check]
	end

	for pos, plant in pairs(state) do
		if plant == "#" then
			for i = pos - 2, pos + 2 do
				fill(i)
			end
		end
	end

	state = n
	if generation == 1000 then
		sum = 0
		for pos, plant in pairs(state) do
			if plant == "#" then
				sum = sum + pos
			end
		end
	end
end

sum2 = 0
for pos, plant in pairs(state) do
	if plant == "#" then
		sum2 = sum2 + pos
	end
end

-- I don't know if this will work for *every* input, but it works for mine!
-- sum: count at generation 1000
-- sum2: count at generation 2000
-- The growth between every 1000 generations appeared to be stable, and it turns out the pattern holds!
local d_thousand = sum2 - sum
part2 = (50000000000/1000 - 1)*d_thousand + sum

print("Part 2:", part2)