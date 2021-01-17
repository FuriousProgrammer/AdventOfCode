local tiles = {}

local tile
for line in io.lines("input.txt") do
	if not tile then
		tile = {data = {}}
		tile.id = line:match("Tile (%d+):")
		tiles[#tiles + 1] = tile
	elseif line == "" then
		local dat = tile.data
		local a, b = "", ""
		for i = 1, #dat do
			a = a .. dat[i][1]
			b = b .. dat[i][#dat[i]]
		end
		tile.borders = {top = table.concat(dat[1]), right = b, bottom = table.concat(dat[#dat]), left = a}
		tile.matches = {}
		tile = nil
	else
		local row = {}
		tile.data[#tile.data + 1] = row
		for c in line:gmatch(".") do
			row[#row + 1] = c
		end
	end
end

local corners = {}
for _, tile in pairs(tiles) do
	local count = 0
	for i, str1 in pairs(tile.borders) do
		if tile.matches[i] then
			count = count + 1
		else

			for _, check in pairs(tiles) do
				if tile ~= check then

					for j, str2 in pairs(check.borders) do
						local dobreak = false
						if str1 == str2 or str1 == str2:reverse() then
							count = count + 1
							tile.matches[i]  = {tile = check, dir = j}
							check.matches[j] = {tile = tile,  dir = i}
							dobreak = true
							break
						end
						if dobreak then break end
					end

				end
			end

		end
	end

	if count == 2 then
		corners[#corners + 1] = tile
	end
end

local part1 = 1
for _, tile in pairs(corners) do
	part1 = part1*tile.id
end
print("Part 1:", part1)



local size = math.sqrt(#tiles)
local tileSize = #tiles[1].data -- yay everything is squares!

local camArray = {}
for i = 1, size do
	camArray[i] = {}
end

local grid = {}
for i = 1, size*(tileSize - 2) do
	grid[i] = {}
end

local function reverseArray(t)
	local n = {}
	for i = #t, 1, -1 do
		n[#n + 1] = t[i]
	end
	return n
end

-- NOTE: "matches" `dir` references TO the given tile become invalid after any of these functions are called
local function flipVer(tile)
	tile.data = reverseArray(tile.data)

	tile.borders.left = tile.borders.left:reverse()
	tile.borders.right = tile.borders.right:reverse()
	tile.borders.top, tile.borders.bottom = tile.borders.bottom, tile.borders.top
	tile.matches.top, tile.matches.bottom = tile.matches.bottom, tile.matches.top
end

local function flipHor(tile)
	for y, row in pairs(tile.data) do
		tile.data[y] = reverseArray(row)
	end

	tile.borders.top = tile.borders.top:reverse()
	tile.borders.bottom = tile.borders.bottom:reverse()
	tile.borders.left, tile.borders.right = tile.borders.right, tile.borders.left
	tile.matches.left, tile.matches.right = tile.matches.right, tile.matches.left
end

local function rotate(tile) -- 90* clockwise!
	local n = {}
	for x = 1, tileSize do
		n[x] = {}
		for y = tileSize, 1, -1 do
			table.insert(n[x], tile.data[y][x])
		end
	end
	tile.data = n

	tile.borders.top, tile.borders.right, tile.borders.bottom, tile.borders.left =
		tile.borders.left:reverse(), tile.borders.top, tile.borders.right:reverse(), tile.borders.bottom
	tile.matches.top, tile.matches.right, tile.matches.bottom, tile.matches.left =
		tile.matches.left, tile.matches.top, tile.matches.right, tile.matches.bottom
end

-- 1) Set corner
local current = corners[1]

if current.matches.top then
	flipVer(current)
end
if current.matches.left then
	flipHor(current)
end
camArray[1][1] = current

-- 2) Finish left-most column
for y = 2, size do
	local nxt = current.matches.bottom
	camArray[y][1] = nxt.tile
	if nxt.dir == "bottom" then
		flipVer(nxt.tile)
	elseif nxt.dir ~= "top" then
		rotate(nxt.tile)
		if nxt.dir == "right" then
			flipVer(nxt.tile)
		end
	end
	if nxt.tile.borders.top ~= current.borders.bottom then
		flipHor(nxt.tile)
	end
	current = nxt.tile
end

-- 3) Finish each row
for y = 1, size do
	current = camArray[y][1]
	for x = 2, size do
		local nxt = current.matches.right
		camArray[y][x] = nxt.tile
		if nxt.dir == "right" then
			flipHor(nxt.tile)
		elseif nxt.dir ~= "left" then
			rotate(nxt.tile)
			if nxt.dir == "top" then
				flipHor(nxt.tile)
			end
		end
		if nxt.tile.borders.left ~= current.borders.right then
			flipVer(nxt.tile)
		end
		current = nxt.tile
	end
end

-- 4) Build full picture!
for y = 1, size do
	local offset = (y - 1)*(tileSize - 2)
	for x = 1, size do
		local tile = camArray[y][x]

		for tileY = 2, tileSize - 1 do
			local t = grid[offset + tileY - 1]
			for tileX = 2, tileSize - 1 do
				t[#t + 1] = tile.data[tileY][tileX] == '#'
			end
		end

	end
end

-- 5) S C A N 
local pattern = {
	{true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,true};
	{false,true,true,true,true,false,false,true,true,true,true,false,false,true,true,true,true,false,false,false};
	{true,false,true,true,false,true,true,false,true,true,false,true,true,false,true,true,false,true,true,true};
}
-- ' '=> true, '#'=> false; opposite of `grid`, so I can binary-or!

local foundMonsters = false
local function scan()
	for y = 0, #grid - #pattern do
		for x = 0, #grid[1] - #pattern[1] do

			local matches = true
			for yy, row in pairs(pattern) do
				for xx, chk in pairs(row) do
					matches = chk or grid[y + yy][x + xx]
					if not matches then break end
				end
				if not matches then break end
			end

			-- TODO: modify this for pretty-printing of the sea monsters!
			-- TODO: skip ahead a few steps, since monsters don't overlap?
			if matches then
				for yy, row in pairs(pattern) do
					for xx, chk in pairs(row) do
						if not chk then
							grid[y + yy][x + xx] = false
						end
					end
				end
			end

		end
	end
end

for i = 1, 2 do
	for j = 1, 4 do
		scan()
		if foundMonsters then break end
		local n = {}
		for x = 1, #grid do
			n[x] = {}
			for y = #grid, 1, -1 do
				table.insert(n[x], grid[y][x])
			end
		end
		grid = n
	end
	if foundMonsters then break end
	reverseArray(grid)
end

local part2 = 0
for y, row in pairs(grid) do
	for x, data in pairs(row) do
		part2 = part2 + (data and 1 or 0)
	end
end
print("Part 2:", part2)