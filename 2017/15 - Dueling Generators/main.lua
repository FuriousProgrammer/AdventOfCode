local input = io.open("input.txt")
input = input:read("*a"), input:close()

local bit = require("bit")

local a_, b_ = input:match("with (%d+).+with (%d+)")
a, b = tonumber(a_), tonumber(b_)

local part1 = 0
for i = 1, 40*10^6 do
	a = (a*16807)%2147483647
	b = (b*48271)%2147483647

	if bit.band(a, 0xFFFF) == bit.band(b, 0xFFFF) then
		part1 = part1 + 1
	end
end
print("Part 1:", part1)


a, b = tonumber(a_), tonumber(b_)
local part2 = 0
for i = 1, 5*10^6 do
	repeat
		a = (a*16807)%2147483647
	until a%4 == 0
	repeat
		b = (b*48271)%2147483647
	until b%8 == 0

	if bit.band(a, 0xFFFF) == bit.band(b, 0xFFFF) then
		part2 = part2 + 1
	end
end
print("Part 2:", part2)