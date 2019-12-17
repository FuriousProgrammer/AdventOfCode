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

local delta = {[0]={dx=0,dy=-1},{dx=1,dy=0},{dx=0,dy=1},{dx=-1,dy=0}} -- clockwise: +1, anti: -1, both mod 4



local dir = 0
local x, y = 0, 0
local grid = {}

local out = {}
local count = 0
local prog = newIC(copy(progbase), out)

local notDone = true
while notDone do
	if not grid[y] then grid[y] = {} end
	out[1], out[2] = nil, nil -- clear outputs
	notDone = resume(prog, grid[y][x] or 0)
	out[1], out[2] = tonumber(tostring(out[1])), tonumber(tostring(out[2]))
--	print(y, x, grid[y][x], out[1], out[2])
	if out[1] then
		if not grid[y][x] then count = count + 1 end
		grid[y][x] = out[1]
		dir = (dir + (out[2] == 1 and 1 or -1))%4
		y = y + delta[dir].dy
		x = x + delta[dir].dx
	end
end

print("Part 1:", count)



dir, x, y, grid, out = 0, 0, 0, {[0]={[0]=1}}, {}
prog = newIC(copy(progbase), out)

minX, maxX, minY, maxY = 0, 0, 0, 0

notDone = true
while notDone do
	if not grid[y] then grid[y] = {} end
	out[1], out[2] = nil, nil -- clear outputs
	notDone = resume(prog, grid[y][x] or 0)
	out[1], out[2] = tonumber(tostring(out[1])), tonumber(tostring(out[2]))
--	print(y, x, grid[y][x], out[1], out[2])
	if out[1] then
		if not grid[y][x] then count = count + 1 end
		grid[y][x] = out[1]
		dir = (dir + (out[2] == 1 and 1 or -1))%4
		minX, maxX, minY, maxY = math.min(minX, x), math.max(maxX, x), math.min(minY, y), math.max(maxY, y)
		y = y + delta[dir].dy
		x = x + delta[dir].dx
	end
end

print("Part 2:")

local on, off = string.char(219), string.char(32)
for y = minY, maxY do
	for x = minX, maxX do
		io.write(grid[y][x] == 1 and on or off)
	end
	print()
end