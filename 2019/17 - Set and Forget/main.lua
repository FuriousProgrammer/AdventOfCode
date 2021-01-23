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

local botDir, botX, botY = 0
local x, y = 1, 1
local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})
for i = 1, #out do
	local c = string.char(out[i])
--	io.write(c)
	if c == '\n' then
		x, y = 1, y + 1
	else
		grid[y][x] = (c ~= '.')
		if c == '^' then
			botX = x
			botY = y
		end
		x = x + 1
	end
	out[i] = nil
end

-- This assumes ALL intersections are 4-way. No T-junctions!
local sum = 0
for y = 2, #grid - 1 do
	for x = 2, #grid[y] - 1 do
		if grid[y][x] and grid[y - 1][x] and grid[y + 1][x] and grid[y][x - 1] and grid[y][x + 1] then
			sum = sum + (y - 1)*(x - 1)
		end
	end
end
print("Part 1:", sum)

--[[ TODO: make this work programmatically!
local dirs = {
	[0] = {x =  0, y = -1}; -- Up
	[1] = {x =  1, y =  0}; -- Right
	[2] = {x =  0, y =  1}; -- Down
	[3] = {x = -1, y =  0}; -- Left
}
local path = {}
while true do
	local n

	local right = dirs[(botDir + 1)%4]
	local left  = dirs[(botDir - 1)%4]
	if grid[botY + right.y][botX + right.x] then
		n = "R,"
		botDir = (botDir + 1)%4
	elseif grid[botY + left.y][botX + left.x] then
		n = "L,"
		botDir = (botDir - 1)%4
	else
		break
	end

	local len = 0
	while grid[botY + dirs[botDir].y][botX + dirs[botDir].x] do
		len = len + 1
		botX = botX + dirs[botDir].x
		botY = botY + dirs[botDir].y
	end

	path[#path + 1] = n .. len
end

pathStr = table.concat(path,",") .. ','

local function subIn(pathStr, offset, replace)
	local n = ""
	local pathN
	for i = offset+1, #path do
		n = n .. path[i] .. ','
		print(i, path[i], n)
		local _, count = pathStr:gsub(n, replace)
		if #n > 20 or count == 1 then
			pathN = i - 1
			break
		end
	end
	n = ""
	for i = offset+1, pathN do
		n = n .. path[i] .. ','
	end
	n = n:sub(1, -2)

	return pathN - offset, n
end

local offset = 0
local offsetCountA, A = subIn(pathStr, offset, "A,")
pathStr = pathStr:gsub(A, "A")

while pathStr:find("^A,") do
	pathStr = pathStr:sub(3)
	offset = offset + offsetCountA
end

offsetCountB, B = subIn(pathStr, offset, "B,")
pathStr = pathStr:gsub(B, "B")

while pathStr:find("^B,") do
	pathStr = pathStr:sub(3)
	offset = offset + offsetCountB
end

_, C = subIn(pathStr, offset, "C,")
pathStr = table.concat(path, ","):gsub(A, "A"):gsub(B, "B"):gsub(C, "C")
print(pathStr)
print(A)
print(B)
print(C)

os.exit()
--]]

out = {}
progbase["0"] = BigNum.new(2)
local co = newIC(copy(progbase), out)

local instr = [[
A,A,B,C,B,C,B,A,C,A
R,8,L,12,R,8
L,10,L,10,R,8
L,12,L,12,L,10,R,10
n
]]

for c in instr:gmatch(".") do
	resume(co, string.byte(c))
end

print("Part 2:", out[#out])