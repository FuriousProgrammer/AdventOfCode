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
local start = os.clock()
resume(newIC(copy(progbase), out), 1)
print("Part 1:", out[1])
resume(newIC(copy(progbase), out), 2)
print("Part 2:", out[2])
print(string.format("elapsed time (for both parts!): %.2f\n", os.clock() - start))