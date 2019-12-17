-- [[ SOURCE: https://rosettacode.org/wiki/Permutations#fast.2C_iterative_with_coroutine_to_use_as_a_generator
local function ipermgen(a,b)
	if a==0 then return end
	local taken = {} local slots = {}
	for i=1,a do slots[i]=0 end
	for i=1,b do taken[i]=false end
	local index = 1
	while index > 0 do repeat
		repeat slots[index] = slots[index] + 1
		until slots[index] > b or not taken[slots[index]]
		if slots[index] > b then
			slots[index] = 0
			index = index - 1
			if index > 0 then
				taken[slots[index]] = false
			end
			break
		else
			taken[slots[index]] = true
		end
		if index == a then
			coroutine.yield(slots)
			taken[slots[index]] = false
			break
		end
		index = index + 1
	until true end
end
local function iperm(a)
	local co=coroutine.create(function() ipermgen(a,a) end)
	return function()
		local code,res=coroutine.resume(co)
		return res
	end
end
--]]

local resume = coroutine.resume
local newIC = require("intcode")
local progbase = {}
do
	local c = 0
	local data = io.open("inpt.txt"):read("*a")
	for i in data:gmatch("(%-?%d+)") do
		progbase[c] = tonumber(i)
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


local max = 0
for phase in iperm(5) do
	local out = {0}
	for i = 1, 5 do
		local prog = newIC(copy(progbase), out)
		resume(prog, phase[i] - 1)
		resume(prog, out[i])
	end
	max = math.max(max, out[6])
end

print("Part 1:", max)

max = 0
for phase in iperm(5) do
	local out = {0}
	local amps = {}
	for i = 1, 5 do
		amps[i] = newIC(copy(progbase), out)
		resume(amps[i], phase[i] + 4)
	end

	local notDone = true
	while notDone do
		for i = 1, 5 do
			notDone = resume(amps[i], out[#out])
		end
	end
	max = math.max(max, out[#out])
end

print("Part 2:", max)