local disc = {}

for line in io.lines("input.txt") do
	local mod, offset = line:match("(%d+) positions.-position (%d+)")
	disc[#disc + 1] = {mod=mod, offset=offset}
end

local function gcd(a, b)
	while b ~= 0 do
		a, b = b, a%b
	end
	return a
end
local function lcm(a, b)
	return a/gcd(a, b) * b
end

local function count()
	local step = disc[1].mod
	local t = (disc[1].mod - 1) - disc[1].offset -- -1 % disc[1].mod
	for i = 2, #disc do
		local pos = (t + disc[i].offset)%disc[i].mod
		while pos ~= disc[i].mod - i do
			pos = (pos + step)%disc[i].mod
			t = t + step
		end
		step = lcm(disc[i].mod, step)
	end
	return t
end

print("Part 1:", count())
disc[#disc + 1] = {
	mod = 11,
	offset = 0,
}
print("Part 2:", count())