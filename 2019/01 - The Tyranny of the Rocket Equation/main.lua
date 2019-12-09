local fuel1 = 0
local fuel2 = 0

for line in io.lines("inpt.txt") do
	local m = math.floor(tonumber(line)/3) - 2
	fuel1 = fuel1 + m
	while m > 0 do
		fuel2 = fuel2 + m
		m = math.floor(m/3) - 2
	end
end

print("Part 1:", fuel1)
print("Part 2:", fuel2)