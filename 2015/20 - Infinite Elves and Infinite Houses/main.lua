local input = 33100000

--[[ FAR too slow!
local function presentsAt(house)
	local a, b = 0, 0
	for elf = 1, house do

		if house%elf == 0 then
			a = a + elf*10
			if house/elf < 50 then
				b = b + elf*11
			end
		end

	end
	return a, b
end


local part1, part2
local i = 1
while not part1 or not part2 do
	a, b = presentsAt(i)
	if a >= input then
		part1 = i
	end
	if b >= input then
		part2 = i
	end
	i = i + 1
end

print("Part 1:", part1)
print("Part 2:", part2)
--]]

local houses1 = {}
local houses2 = {}

io.write(0, "\r")
for elf = 1, input/10 do
	for i = elf, input, elf do
		houses1[i] = (houses1[i] or 0) + elf*10
		if i/elf <= 50 then
			houses2[i] = (houses2[i] or 0) + elf*11
		end
	end
	if (elf <= 100 and elf%10 == 0) or
			(elf <= 1000 and elf%100 == 0) or
			(elf <= 10000 and elf%1000 == 0) or
			(elf%10000 == 0) then
		io.write(elf, "\r")
	end
end

for i = 1, #houses1 do
	if houses1[i] >= input then
		print("Part 1:", i)
		break
	end
end

for i = 1, #houses2 do
	if houses2[i] >= input then
		print("Part 2:", i)
		break
	end
end