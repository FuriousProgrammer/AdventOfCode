local map = {}
local height = 0
local width

for line in io.lines("input.txt") do
	local new = {}
	map[height] = new
	height = height + 1

	width = 0
	for c in line:gmatch(".") do
		new[width] = c
		width = width + 1
	end
end

local stale = true

local function moveEast()
	for y = 0, height - 1 do
		local moves = {}
		for x = 0, width - 1 do
			if map[y][x] == ">" and map[y][(x + 1)%width] == "." then
				stale = true
				moves[x] = true
			end
		end

		for x in pairs(moves) do
			map[y][x] = "."
			map[y][(x + 1)%width] = ">"
		end
	end
end

local function moveSouth()
	for x = 0, width - 1 do
		local moves = {}
		for y = 0, height - 1 do
			if map[y][x] == "v" and map[(y + 1)%height][x] == "." then
				stale = true
				moves[y] = true
			end
		end

		for y in pairs(moves) do
			map[y][x] = "."
			map[(y + 1)%height][x] = "v"
		end
	end
end

local turns = 0
while stale do
	stale = false
	moveEast()
	moveSouth()
	turns = turns + 1
end

print("Part 1:", turns)
print("Part 2:\tMUR CRIMIS")