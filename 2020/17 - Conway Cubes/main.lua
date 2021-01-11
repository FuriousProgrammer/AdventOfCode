local mt3 = { -- X coord
	__index = function(t, i)
		t[i] = false
		return t[i]
	end;
}
local mt2 = { -- Y coord
	__index = function(t, i)
		t[i] = setmetatable({}, mt3)
		return t[i]
	end;
}
local mt1 = { -- Z coord
	__index = function(t, i)
		t[i] = setmetatable({}, mt2)
		return t[i]
	end;
}
local mt0 = { -- W coord (part 2)
	__index = function(t, i)
		t[i] = setmetatable({}, mt1)
		return t[i]
	end;
}

local map = setmetatable({}, mt1)
local map2 = setmetatable({map}, mt0)
for line in io.lines("input.txt") do
	local row = map[1][#map[1] + 1]
	for c in line:gmatch(".") do
		row[#row + 1] = c == "#"
	end
end

-- TODO: generalize to arbitrary (positive integer) dimensions!

print("NOTICE: this code modifies Tables being iterated over using `pairs`. While *my* inputs produce correct outputs, this is not guaranteed for *any* inputs!")

-- Part 1 (3D):
for i = 1, 6 do
	local nxt = setmetatable({}, mt1)

	local function process(z, y, x) -- Note: this doesn't really need to be a closure.
		if rawget(nxt[z][y], x) ~= nil then return end -- ignore already-processed cubes
		local activeNeighbors = 0
		for dz = -1, 1 do
			for dy = -1, 1 do
				for dx = -1, 1 do
					if not (dz == 0 and dy == 0 and dx == 0) then
						activeNeighbors = activeNeighbors + (map[z + dz][y + dy][x + dx] and 1 or 0)
					end
				end
			end
		end 
		nxt[z][y][x] = (activeNeighbors == 3) or (activeNeighbors == 2 and map[z][y][x])
	end

	for z, plane in pairs(map) do
		for y, row in pairs(plane) do
			for x, active in pairs(row) do
				if active then

					for dz = -1, 1 do
						for dy = -1, 1 do
							for dx = -1, 1 do
								process(z + dz, y + dy, x + dx)
							end
						end
					end

				end
			end
		end
	end

	map = nxt
end

local part1 = 0
for z, plane in pairs(map) do
	for y, row in pairs(plane) do
		for x, active in pairs(row) do
			part1 = part1 + (active and 1 or 0)
		end
	end
end
print("Part 1:", part1)

-- Part 2 (4D):
for i = 1, 6 do
	local nxt = setmetatable({}, mt0)

	local function process(w, z, y, x) -- Note: this doesn't really need to be a closure.
		if rawget(nxt[w][z][y], x) ~= nil then return end -- ignore already-processed hypercubes
		local activeNeighbors = 0
		for dw = -1, 1 do
			for dz = -1, 1 do
				for dy = -1, 1 do
					for dx = -1, 1 do
						if not (dw == 0 and dz == 0 and dy == 0 and dx == 0) then
							activeNeighbors = activeNeighbors + (map2[w + dw][z + dz][y + dy][x + dx] and 1 or 0)
						end
					end
				end
			end
		end
		nxt[w][z][y][x] = (activeNeighbors == 3) or (activeNeighbors == 2 and map2[w][z][y][x])
	end

	for w, cube in pairs(map2) do
		for z, plane in pairs(cube) do
			for y, row in pairs(plane) do
				for x, active in pairs(row) do
					if active then

						for dw = -1, 1 do
							for dz = -1, 1 do
								for dy = -1, 1 do
									for dx = -1, 1 do
										process(w + dw, z + dz, y + dy, x + dx)
									end
								end
							end
						end

					end
				end
			end
		end
	end

	map2 = nxt
end

local part2 = 0
for w, cube in pairs(map2) do
	for z, plane in pairs(cube) do
		for y, row in pairs(plane) do
			for x, active in pairs(row) do
				part2 = part2 + (active and 1 or 0)
			end
		end
	end
end
print("Part 2:", part2)