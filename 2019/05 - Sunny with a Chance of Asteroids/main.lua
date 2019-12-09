local run = require("intcode")
local data = io.open("inpt.txt"):read("*a")

local part1 = {}
local part2 = {}
local c = 0
for i in data:gmatch("(%-?%d+)") do
	part1[c] = tonumber(i)
	part2[c] = part1[c]
	c = c + 1
end

local out = {}
run(part1, {1}, out)
print("Part 1:", out[#out])
run(part2, {5}, out)
print("Part 2:", out[#out])