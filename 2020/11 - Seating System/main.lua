local grid = {}
local grid2 = {}

for line in io.lines("input.txt") do
	local row = {}
	grid[#grid + 1] = row

	for c in line:gmatch(".") do
		row[#row + 1] = c
	end

	row[0] = '_' -- uses more space, but avoids a lot of nil checks!
	row[#row + 1] = '_'
end

do -- add an extra floor row above and below, same as line 11's thingy
	local row = {} -- can use this twice, since it's never modified!
	for i = 0, #grid[1] do
		row[i] = '_'
	end
	grid[0] = row
	grid[#grid + 1] = row
end

-- copy grid to grid2 for Part 2:
for y = 0, #grid do
	grid2[y] = {}
	for x = 0, #grid[y] do
		grid2[y][x] = grid[y][x]
	end
end

-- . = floor, L = empty, # = full

-- PART 1:
-- L -> # if no adjacent filled
-- # -> L if 4+ adjacent filled
local stable = false
while not stable do
	stable = true
	local nxt = {}
	-- TODO: moving-window sum may save some compuation here
	for y = 0, #grid do
		nxt[y] = {}
		for x = 0, #grid[y] do

			local c = grid[y][x]
			nxt[y][x] = c

			if c == "#" or c == "L" then
				
				local fullNeighbors = 0
				for dy = -1, 1 do
					for dx = -1, 1 do
						if not (dx == 0 and dy == 0) then
							fullNeighbors = fullNeighbors + (grid[y+dy][x+dx] == "#" and 1 or 0)
						end
					end
				end

				if c == "#" and fullNeighbors >= 4 then
					nxt[y][x] = "L"
					stable = false
				elseif c == "L" and fullNeighbors == 0 then
					nxt[y][x] = "#"
					stable = false
				end
			end
		end
	end

	grid = nxt
end

local part1 = 0
for y = 1, #grid - 1 do
	for x = 1, #grid[y] - 1 do
		if grid[y][x] == "#" then
			part1 = part1 + 1
		end
	end
end

print("Part 1:", part1)

grid = grid2

-- PART 2:
-- L -> # if no visible filled
-- # -> L if 5+ visible filled
-- "visible" is first seat in straight lines (skipping floors!)
local stable = false
while not stable do
	stable = true
	local nxt = {}
	-- TODO: moving-window sum may save some compuation here
	for y = 0, #grid do
		nxt[y] = {}
		for x = 0, #grid[y] do

			local c = grid[y][x]
			nxt[y][x] = c

			if c == "#" or c == "L" then

				local fullNeighbors = 0
				for dy = -1, 1 do
					for dx = -1, 1 do
						if not (dx == 0 and dy == 0) then

							-- PART 2 change here!
							local n = 1
							while true do
								local see = grid[y+n*dy][x+n*dx]
								if see == "_" or see == "L" then break end -- saw a wall, or an empty seat!
								if see == "#" then -- saw an occupied seat!
									fullNeighbors = fullNeighbors + 1
									break
								end
								n = n + 1
							end

						end
					end
				end

				if c == "#" and fullNeighbors >= 5 then
					nxt[y][x] = "L"
					stable = false
				elseif c == "L" and fullNeighbors == 0 then
					nxt[y][x] = "#"
					stable = false
				end
			end
		end
	end

	grid = nxt
end

local part2 = 0
for y = 1, #grid - 1 do
	for x = 1, #grid[y] - 1 do
		if grid[y][x] == "#" then
			part2 = part2 + 1
		end
	end
end

print("Part 2:", part2)