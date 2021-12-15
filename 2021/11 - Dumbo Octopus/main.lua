local map = {}

for line in io.lines("input.txt") do
	local n = {}

	for d in line:gmatch(".") do
		table.insert(n, {power = tonumber(d)})
	end

	table.insert(map, n)
end


local function update(old)
	local new = {}
	local queue = {}

	for y = 1, 10 do
		local row = {}
		for x = 1, 10 do
			row[x] = {power = old[y][x].power + 1}
			if row[x].power > 9 then
				table.insert(queue, {x=x,y=y})
			end
		end
		new[y] = row
	end

	while #queue > 0 do
		local t = table.remove(queue)

		if not new[t.y][t.x].flashed then
			new[t.y][t.x].flashed = true

			for dy = -1, 1 do
				for dx = -1, 1 do

					local cell = new[t.y + dy] and new[t.y + dy][t.x + dx]
					if cell then
						cell.power = cell.power + 1
						if cell.power > 9 and not cell.flashed then
							table.insert(queue, {x = t.x + dx, y = t.y + dy})
						end
					end
					
				end
			end

		end

	end

	local flashes = 0
	for _, row in pairs(new) do
		for _, cell in pairs(row) do
			if cell.power > 9 then
				flashes = flashes + 1
				cell.power = 0
			end
		end
	end

	return new, flashes
end

local part1 = 0
local part2 = 0

while true do
	part2 = part2 + 1
	map, numFlashes = update(map)

	if part2 <= 100 then
		part1 = part1 + numFlashes
		if part2 == 100 then
			print("Part 1:", part1)
		end
	end

	if numFlashes == 100 then
		print("Part 2:", part2)
		break
	end
end