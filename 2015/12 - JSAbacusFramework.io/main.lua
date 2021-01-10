local input = io.open("input.txt"):read("*a")

local sum = 0
for n in input:gmatch("(%-?%d+)") do
	sum = sum + tonumber(n)
end

print("Part 1:", sum)

