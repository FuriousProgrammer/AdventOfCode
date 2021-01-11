local grid = {}
local moves = {
	w  = {x=-1,y=0 };
	nw = {x=0, y=-1};
	sw = {x=-1,y=1 };
	e  = {x=1, y=0 };
	ne = {x=1, y=-1};
	se = {x=0, y=1 };
}

for line in io.lines("input.txt") do
	local pos = {x=0,y=0}

	local i = 1
	while i <= #line do
		local c = line:sub(i,i)
		if c == "n" or c == "s" then
			c = line:sub(i,i+1)
			i = i + 1
		end
		i = i + 1

		pos.x = pos.x + moves[c].x
		pos.y = pos.y + moves[c].y
	end

	if not grid[pos.y] then grid[pos.y] = {} end
	grid[pos.y][pos.x] = not grid[pos.y][pos.x]
end

local black = 0
for _, row in pairs(grid) do
	for _, isBlack in pairs(row) do
		black = black + (isBlack and 1 or 0)
	end
end
print("Part 1:", black)


for _ = 1, 100 do
	-- Hex conway!
	local nxt = {}

	local function doConway(x, y)
		if not nxt[y] then nxt[y] = {} end
		if nxt[y][x] ~= nil then return end

		-- Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
		-- Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
		--[[
		From: B W
		0, 3+ W W
		1     B W
		2     B B
	    --]]

		local count = 0
		for _, move in pairs(moves) do
			if grid[y + move.y] and grid[y + move.y][x + move.x] then
				count = count + 1
			end
		end

		if count == 2 then
			nxt[y][x] = true
		elseif count == 1 then
			nxt[y][x] = grid[y] and grid[y][x] or false
		else -- 0, 3+
			nxt[y][x] = false
		end
	end

	for y, row in pairs(grid) do
		for x, isBlack in pairs(row) do
			if isBlack then
				doConway(x, y)
				for _, move in pairs(moves) do
					doConway(x + move.x, y + move.y)
				end
			end
		end
	end

	grid = nxt
end

black = 0
for _, row in pairs(grid) do
	for _, isBlack in pairs(row) do
		black = black + (isBlack and 1 or 0)
	end
end
print("Part 2:", black)