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

local c = 0
for i = 3, #out, 3 do
	if out[i] == '2' then
		c = c + 1
	end
end

print("Part 1:", c)

--[[
	0: empty
	1: wall
	2: block
	3: paddle
	4: ball
--]]

out = {}
progbase['0'] = BigNum.new(2)
local prog = newIC(progbase, out)

local c = 0
for i = 3, #out, 3 do
	if out[i] == '2' then
		c = c + 1
	end
end

local tile = {[0]=' ', string.char(219), 'X', '=', 'o'}
local grid = {}

local paddle, ball
while true do
	local score = 0

	for i = 1, #out, 3 do
		local x, y, d = tonumber(out[i]), tonumber(out[i + 1]), tonumber(out[i + 2])
		if x == -1 and y == 0 then
			score = out[i + 2]
		else
			if not grid[y] then grid[y] = {} end
			if grid[y][x] == tile[2] and d ~= 2 then
				c = c - 1
			end
			grid[y][x] = tile[d]
			if d == 3 then
				paddle = x
			elseif d == 4 then
				ball = x
			end
		end
	end

	-- TODO: enable (and optimize!) visualization.

	if c == 0 then
		print("Part 2:", score)
		break
	else
		for i = 1, #out do out[i] = nil end
		resume(prog, (paddle == ball and 0 or (paddle > ball and -1 or 1)))
	end
end