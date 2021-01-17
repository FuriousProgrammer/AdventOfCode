local data = {}

local part1 = 0
for line in io.lines("input.txt") do
	local n = tonumber(line:match("(%-?%d+)"))
	data[#data + 1] = n
	part1 = part1 + n
end
print("Part 1:", part1)

local part2 = {}
local current = 0

while true do
	for i = 1, #data do
		current = current + data[i]
		if part2[current] then
			print("Part 2:", current)
			os.exit()
		end
		part2[current] = true
	end
end