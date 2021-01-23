local data = setmetatable({}, {
	__index = function(t, i)
		t[i] = {lookup = {}, sortable = {}}
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	for i = 1, #line do
		local let = line:sub(i,i)
		if not data[i].lookup[let] then
			local n = {let = let, count = 1}
			data[i].lookup[let] = n
			table.insert(data[i].sortable, n)
		else
			data[i].lookup[let].count = data[i].lookup[let].count + 1 -- rip +=, I miss you much
		end
	end
end

local function sortFunc(a, b)
	return a.count > b.count
end
for i = 1, #data do
	table.sort(data[i].sortable, sortFunc)
end

local part1, part2 = "", ""
for i = 1, #data do
	part1 = part1 .. data[i].sortable[1].let
	part2 = part2 .. data[i].sortable[#data[i].sortable].let
end

print("Part 1:", part1)
print("Part 2:", part2)