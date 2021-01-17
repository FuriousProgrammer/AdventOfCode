local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

local claims = {}
for line in io.lines("input.txt") do
	local id, x, y, w, h = line:match("^.-(%d+).-(%d+).-(%d+).-(%d+).-(%d+)$")
	claims[id] = true

	for yy = y, y+h-1 do
		for xx = x, x+w-1 do
			if not grid[yy][xx] then
				grid[yy][xx] = {id}
			else
				table.insert(grid[yy][xx], id)
				for _, id in pairs(grid[yy][xx]) do
					claims[id] = false
				end
			end
		end
	end
end

local part1 = 0
for _, row in pairs(grid) do
	for _, claims in pairs(row) do
		if #claims > 1 then
			part1 = part1 + 1
		end
	end
end
print("Part 1:", part1)

for id, valid in pairs(claims) do
	if valid then
		print("Part 2:", id)
--		os.exit()
	end
end