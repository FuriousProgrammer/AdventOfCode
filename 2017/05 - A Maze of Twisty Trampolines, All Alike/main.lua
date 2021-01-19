local data = {}
local data2 = {}

for line in io.lines("input.txt") do
	data[#data + 1] = tonumber(line)
	data2[#data2 + 1] = tonumber(line)
end

local steps = 0
local pc = 1
while data[pc] do
	local off = data[pc]
	data[pc] = off + 1
	pc = pc + off
	steps = steps + 1
end
print("Part 1:", steps)


steps, pc = 0, 1
while data2[pc] do
	local off = data2[pc]
	data2[pc] = off + (off >= 3 and -1 or 1) 
	pc = pc + off
	steps = steps + 1
end
print("Part 2:", steps)