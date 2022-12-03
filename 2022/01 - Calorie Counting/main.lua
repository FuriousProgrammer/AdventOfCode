local elfs = {}

local sum = 0
for line in io.lines("input.txt") do
	if line == "" then
		table.insert(elfs, sum)
		sum = 0
	else
		sum = sum + tonumber(line)
	end
end

if sum ~= 0 then
	table.insert(elfs, sum)
end

table.sort(elfs)

print("Part 1: " .. elfs[#elfs])
print("Part 2: " .. elfs[#elfs] + elfs[#elfs - 1] + elfs[#elfs - 2])