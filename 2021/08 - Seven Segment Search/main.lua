local part1 = 0
local part2 = 0

--[[
 aaa
b   c
b   c
 ddd
e   f
e   f
 ggg

0: abcefg
1: cf
2: acdeg
3: acdfg
4: bcdf
5: abdfg
6: abdefg
7: acf
8: abcdefg
9: abcdfg

a: 0 23 56789 | 8
b: 0   456 89 | 6
c: 01234  789 | 8
d:   23456 89 | 7
e: 0 2   6 8  | 4
f: 01 3456789 | 9
g: 0 23 56 89 | 7
--]]

local decode = {
	["abcefg"] = 0;
	["cf"] = 1;
	["acdeg"] = 2;
	["acdfg"] = 3;
	["bcdf"] = 4;
	["abdfg"] = 5;
	["abdefg"] = 6;
	["acf"] = 7;
	["abcdefg"] = 8;
	["abcdfg"] = 9;
}

for line in io.lines("input.txt") do
	local inputs, outputs = line:match("([%w ]+) | ([%w ]+)")

	local counts = {}
	local one
	local four
	for signal in inputs:gmatch("%w+") do
		for c in signal:gmatch(".") do
			counts[c] = (counts[c] or 0) + 1
		end
		if #signal == 2 then
			one = signal
		elseif #signal == 4 then
			four = signal
		end
	end

	local map = {}

	-- find b, e, and f from signal counts
	for ch, count in pairs(counts) do
		if count == 4 then
			map['e'] = ch
		elseif count == 6 then
			map['b'] = ch
		elseif count == 9 then
			map['f'] = ch
		end
	end
	-- find c: signal with 2 bits, not `f`
	map['c'] = one:match("[^" .. map['f'] .. "]")
	-- find a: signal with 8 counts, not `c`
	for ch, count in pairs(counts) do
		if count == 8 and ch ~= map['c'] then
			map['a'] = ch
			break
		end
	end
	-- find d: signal with 4 bits, not `bcf`
	map['d'] = four:match("[^" .. map['b'] .. map['c'] .. map['f'] .. "]")
	-- find g: signal with 7 counts, not `d`
	for ch, count in pairs(counts) do
		if count == 7 and ch ~= map['d'] then
			map['g'] = ch
			break
		end
	end

	-- invert map:
	local nmap = {}
	for to, from in pairs(map) do
		nmap[from] = to
	end

	-- translate, sort string, concatenate, add
	local num = ""
	for signal in outputs:gmatch("%w+") do
		if #signal == 2 or #signal == 3 or #signal == 4 or #signal == 7 then
			part1 = part1 + 1
		end

		local n = {}
		for c in signal:gmatch(".") do
			table.insert(n, nmap[c])
		end
		table.sort(n)
		num = num .. decode[table.concat(n)]
	end
	part2 = part2 + tonumber(num)
end

print("Part 1:", part1)
print("Part 2:", part2)