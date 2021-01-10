if type(jit) == "table" or tonumber(_VERSION:sub(-1)) < 3 then
	print("This code requires Lua 5.3+")
	print("tonumber is limited to 32 bits in LuaJIT")
	os.exit()
end

local mem = {}
local mem2 = {}
local mask

-- As numbers are 36-bit unsigned integers, and BitOP only supports
-- 32-bit integers (with signed-only output!), I'm doing this by hand...

-- base from https://stackoverflow.com/questions/9079853/lua-print-integer-as-a-binary
--create lookup table for octal to binary
oct2bin = {
	['0'] = '000',
	['1'] = '001',
	['2'] = '010',
	['3'] = '011',
	['4'] = '100',
	['5'] = '101',
	['6'] = '110',
	['7'] = '111'
}
function getOct2bin(a) return oct2bin[a] end
function convertBin(n)
	local s = string.format('%.12o', n)
	s = s:gsub('.', getOct2bin)
	local ret = {}
	for c in s:gmatch(".") do
		ret[#ret + 1] = c
	end
	return ret
end
--- 

local function domask(val)
	val = convertBin(tonumber(val))
	for i, v in pairs(mask) do
		val[i] = v=='X' and val[i] or v
	end
	return val
end

local function write(addr, val)
	local clean = true
	for i = 1, #addr do
		if addr[i] == "X" then
			addr[i] = '1'
			write(addr, val)

			addr[i] = '0'
			write(addr, val)

			addr[i] = 'X'
			clean = false
			break
		end
	end
	if clean then
		mem2[table.concat(addr)] = val
	end
end
local function domask2(addr, val)
	-- TODO: figure out some method of determining multi-cast overlaps?
	addr = convertBin(addr)
	for i, v in pairs(mask) do
		addr[i] = v=='0' and addr[i] or v
		-- 0: unchanged
		-- 1: overwrite with 1
		-- X: "floating", overwrite with X
	end
	write(addr, val)
end



for line in io.lines("input.txt") do
	if line:sub(1,4) == "mask" then
		--local mask = line:match("mask = (.+)")
		mask = {}
		for c in line:sub(8):gmatch(".") do
			mask[#mask + 1] = c
		end

	else
		local addr, val = line:match("mem%[(%d+)%] = (%d+)")
		mem[addr] = domask(val)
		domask2(addr, val)
	end
end

local sum = 0
for _, v in pairs(mem) do
	local val = tonumber(table.concat(v), 2)
	sum = sum + val
end
print("Part 1:", sum)

sum = 0
for _, v in pairs(mem2) do
	sum = sum + tonumber(v)
end
print("Part 2:", sum)