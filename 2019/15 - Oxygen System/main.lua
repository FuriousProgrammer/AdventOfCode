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

--[[
Inputs:
	1: NORTH
	2: SOUTH
	3: WEST
	4: EAST 
Outputs:
	0: hit wall, no movement
	1: moved
	2: moved, found oxygen system
--]]

local dirs = {{dx=0,dy=-1},{dx=0,dy=1},{dx=-1,dy=0},{dx=1,dy=0}}
local grid = {} -- could start with a node at 0,0 to avoid a step, but no guarantee is given that the droid doesn't START at the oxygen system!
local minX, minY, maxX, maxY = 0, 0, 0, 0

local output = {}
local threads = {
	{x=0,y=0,thread=newIC(progbase, output),prog=progbase}
}

local verts = {}
local oxy, ori

-- (1) Build grid map via flood-fill.
-- yes my repair droid is self-replicating :>
while #threads > 0 do
	local t = table.remove(threads)
	local last, lastprog = t.thread, t.prog
	local backup = copy(t.prog)

	for i = 1, 4 do
		local x, y = t.x + dirs[i].dx, t.y + dirs[i].dy
		minX, maxX, minY, maxY = math.min(x, minX), math.max(x, maxX), math.min(y, minY), math.max(y, maxY)

		if not grid[y] then grid[y] = {} end
		if not grid[y][x] then
			if not last then
				lastprog = copy(backup)
				last = newIC(lastprog, output)
			end
			resume(last, i)

			out, output[1] = tonumber(output[1]), nil
			if out == 0 then
				grid[y][x] = {isWall = true}
			else
				last = false
				threads[#threads + 1] = {x=x,y=y,thread=last,prog=lastprog}
				grid[y][x] = {x=x,y=y,isWall = false,dist=math.huge}
				verts[#verts + 1] = grid[y][x]
				if out == 2 then
					grid[y][x].isOxygen = true
					oxy = grid[y][x]
				end
			end
		end
	end
end

ori = grid[0][0]
oxy.dist = 0
-- (2) Bellman-Fords' the resulting map to find minimum oxygen system path + time to fill at once.
for _ = 1, #verts - 1 do
	for _, v in pairs(verts) do
		for i = 1, 4 do
			local targ = grid[v.y + dirs[i].dy][v.x + dirs[i].dx]
			if not targ.isWall then
--				v.dist = math.min(v.dist, targ.dist + 1)
				if targ.dist + 1 < v.dist then
					v.dist = targ.dist + 1
					v.pre = targ
				end
			end
		end
	end
end

local t = ori.pre
while t ~= oxy do
	t.Mark = true
	t = t.pre
end
local max = 0

-- [[
for y = minY, maxY do
	for x = minX, maxX do
		if not grid[y][x] then
			io.write(" ")
		elseif grid[y][x].isWall then
			io.write(string.char(219))
		else
			if y == 0 and x == 0 then
				io.write("@")
			elseif grid[y][x].Mark then
				io.write("*")
			elseif grid[y][x].isOxygen then
				io.write("O")
			else
				io.write(".")
			end
			max = math.max(max, grid[y][x].dist)
		end
	end
	print()
end
--]]


print("Part 1:", ori.dist)
print("Part 2:", max)