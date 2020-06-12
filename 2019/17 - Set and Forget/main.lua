local resume = coroutine.resume
local newIC = require("intcode")
require("bignum")
local progbase = {}
do
	local c = 0
	local data = io.open("inpt.txt"):read("*a")
	for i in data:gmatch("(%-?%d+)") do
		progbase[tostring(c)] = BigNum.new(i)
		c = c + 1
	end
end

local function copy(t)
	local n = {}
	for i, v in pairs(t) do
		n[i] = v
	end
	return n
end

local out = {}
newIC(copy(progbase), out)

local sum = 0
local x, y = 0,0
local grid = {}
for i = 1, #out do
	local c = string.char(out[i])
	io.write(c)
	if c == '\n' then
		x, y = 0, y+1
	else
		if not grid[y] then grid[y] = {} end
		grid[y][x] = (c ~= '.')
		x = x+1
	end
	out[i] = nil
end

-- This assumes ALL intersections are 4-way. No T-junctions!
for y = 1, #grid - 2 do
	for x = 1, #grid[y] - 2 do
		if grid[y][x] and grid[y - 1][x] and grid[y + 1][x] and grid[y][x - 1] and grid[y][x + 1] then
			sum = sum + y*x
		end
	end
end

print("Part 1:", sum)

-- PART TWO
