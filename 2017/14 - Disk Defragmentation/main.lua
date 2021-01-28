local bit = require("bit")

local input = "xlqgujun"

local function knotHash(input)
	local first = {val = 0}
	local cur = first

	for i = 1, 255 do
		local n = {
			val = i;
			prev = cur;
		}
		cur.next = n
		cur = n
	end
	cur.next = first
	first.prev = cur
	cur = first

	local skip = 0
	local function step(len)
		if len > 1 then
			local rev = {}
			for i = 1, len do
				rev[#rev + 1] = cur.val
				cur = cur.next
			end
			cur = cur.prev
			for i = 1, len do
				cur.val = rev[i]
				cur = cur.prev
			end
			cur = cur.next
		end
		for i = 1, len + skip do
			cur = cur.next
		end
		skip = skip + 1
	end

	local lens = {}
	for c in input:gmatch(".") do
		lens[#lens + 1] = string.byte(c)
	end
	lens[#lens + 1] = 17
	lens[#lens + 1] = 31
	lens[#lens + 1] = 73
	lens[#lens + 1] = 47
	lens[#lens + 1] = 23

	for _ = 1, 64 do
		for _, v in ipairs(lens) do
			step(v)
		end
	end

	local res = ""
	for i = 1, 16 do
		local n = 0
		for j = 1, 16 do
			n = bit.bxor(n, first.val)
			first = first.next
		end
		res = res .. string.format("%02x", n)
	end

	return res
end

local hexToBin_lookup = {
	['0'] = '0000';
	['1'] = '0001';
	['2'] = '0010';
	['3'] = '0011';
	['4'] = '0100';
	['5'] = '0101';
	['6'] = '0110';
	['7'] = '0111';
	['8'] = '1000';
	['9'] = '1001';
	['a'] = '1010';
	['b'] = '1011';
	['c'] = '1100';
	['d'] = '1101';
	['e'] = '1110';
	['f'] = '1111';
}
local function hexToBin(hex)
	local n = {}
	for c in hex:gmatch(".") do
		n[#n + 1] = hexToBin_lookup[c]
	end
	return table.concat(n)
end

local grid = {}
local part1 = 0
for y = 0, 127 do
	local bin = hexToBin(knotHash(input .. "-" .. y))
	grid[y] = {}
	local x = 0
	for c in bin:gmatch(".") do
		grid[y][x] = c == '1'
		if grid[y][x] then
			part1 = part1 + 1
		end
		x = x + 1
	end
end
print("Part 1:", part1)

local dirs = {
	{x =  0, y =  1};
	{x =  0, y = -1};
	{x =  1, y =  0};
	{x = -1, y =  0};
}
local function clear(x, y)
	if x < 0 or x > 127 or y < 0 or y > 127 then return end
	if not grid[y][x] then return end
	grid[y][x] = false
	for _, dir in pairs(dirs) do
		clear(x + dir.x, y + dir.y)
	end
end

local part2 = 0
for y = 0, 127 do
	for x = 0, 127 do
		if grid[y][x] then
			part2 = part2 + 1
			clear(x, y)
		end
	end
end
print("Part 2:", part2)