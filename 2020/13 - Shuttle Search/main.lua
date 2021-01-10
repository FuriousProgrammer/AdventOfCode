-- This script specifically requires Lua 5.3 or above
-- Unfortunately, LuaJIT does not suppor the // integer divison,
-- which is required to get an exact answer in Part 2!

local file = io.open("input.txt")
local earliest = file:read("*l")
local busses = file:read("*l") .. ","
file:close()

earliest = tonumber(earliest)
local min, minID = math.huge, math.huge

for id in busses:gmatch("(%d+)") do
	id = tonumber(id)

	local wait = id - earliest%id

	if wait < min then
		min = wait
		minID = id
	end
end

print("Part 1:", min*minID)


-- Part 2 uses the Chinese Remainder Theorem to find `t` where:
-- t => ID - offset (mod ID)
-- I don't need to check for coprimality, because all my bus IDs are prime! :D

local nums = {}
local i = 0
local N = 1

for n in busses:gmatch("(.-),") do
	if n ~= "x" then
		n = tonumber(n)
		nums[#nums + 1] = {rem = (-i)%n, mod = n}
		N = N*n
	end
	i = i + 1
end

local t = 0

for _, num in pairs(nums) do
	local xi = 1
	local Ni = N//num.mod
	while (Ni*xi)%num.mod ~= 1 do
		xi = xi + 1
	end
--	print(num.mod, num.rem, Ni, xi, xi*num.rem*Ni)
	t = (t + xi*num.rem*Ni)%N
end


print("Part 2:", t)