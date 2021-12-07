local fish = {}
for i = 0, 8 do
	fish[i] = 0
end

for line in io.lines("input.txt") do
	for c in line:gmatch("%d") do
		c = tonumber(c)
		fish[c] = fish[c] + 1
	end
	break
end


for day = 1, 80 do
	local new = fish[0]
	for i = 0, 7 do
		fish[i] = fish[i + 1]
	end
	fish[6] = fish[6] + new
	fish[8] = new
end
local total = 0
for i = 0, 8 do
	total = total + fish[i]
end
print("Part 1:", total)


for day = 81, 256 do
	local new = fish[0]
	for i = 0, 7 do
		fish[i] = fish[i + 1]
	end
	fish[6] = fish[6] + new
	fish[8] = new
end
local total = 0
for i = 0, 8 do
	total = total + fish[i]
end
print("Part 2:", total)