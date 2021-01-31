local rules = {}

for line in io.lines("input.txt") do
	local from, to = line:match("^(.+) => (.+)$")
	
	if #from == 5 then -- 2x2 to 3x3
		-- ab/cd -> ca/db : 90* rotation
		local a, b, c, d = from:match("(.)(.)/(.)(.)")
		for _ = 1, 4 do
			rules[a .. b .. '/' .. c .. d] = to
			rules[b .. a .. '/' .. d .. c] = to -- horizontal reflection
			a, b, c, d = c, a, d, b
		end

	else -- 3x3 to 4 2x2s
		local a12, b12, a34, b34, c12, d12, c34, d34 = to:match("(..)(..)/(..)(..)/(..)(..)/(..)(..)")
		local to = {a12 .. '/' .. a34, b12 .. '/' .. b34, c12 .. '/' .. c34, d12 .. '/' .. d34}

		-- abc/dxe/fgh -> fda/gxb/hec : 90* rotation
		local a, b, c, d, x, e, f, g, h = from:match("(.)(.)(.)/(.)(.)(.)/(.)(.)(.)")
		for _ = 1, 4 do
			rules[a .. b .. c .. '/' .. d .. x .. e .. '/' .. f .. g .. h] = to
			rules[c .. b .. a .. '/' .. e .. x .. d .. '/' .. h .. g .. f] = to -- horizontal reflection
			a, b, c, d, e, f, g, h = f, d, a, g, b, h, e, c
		end
	end
end


local data = {{".#./..#/###"}}
local odd = true

local i = 0
while i < 18 do
	if odd then
		i = i + 1
		for y = 1, 2*#data, 2 do
			table.insert(data, y + 1, {})
			for x = 1, 2*#data[y], 2 do
				local rule = rules[data[y][x]]

				data[y]    [x]     = rule[1]
				table.insert(data[y], x + 1, rule[2])
				data[y + 1][x]     = rule[3]
				data[y + 1][x + 1] = rule[4]
			end
		end
	else -- even
		i = i + 1
		for y, row in pairs(data) do
			for x, str in pairs(row) do
				row[x] = rules[str]
			end
		end

		if i == 5 then
			local part1 = 0
			for y, row in pairs(data) do
				for x, str in pairs(row) do
					local _, count = str:gsub("#", "#")
					part1 = part1 + count
				end
			end
			print("Part 1:", part1)
		end

		i = i + 1
		for y = 1, 1.5*#data, 3 do
			table.insert(data, y + 1, {})
			for x = 1, 1.5*#data[y], 3 do
				local TL, TR, BL, BR = data[y][x], data[y][x + 1], data[y + 2][x], data[y + 2][x + 1]
				--[[
					aab bcc
					aab bcc
					dde eff

					dde eff
					ggh hii
					ggh hii
				--]]
				local a12, b1, a34, b3, d12, e1 = TL:match("(..)(.)/(..)(.)/(..)(.)")
				local d34, e3, g12, h1, g34, h3 = BL:match("(..)(.)/(..)(.)/(..)(.)")
				local b2, c12, b4, c34, e2, f12 = TR:match("(.)(..)/(.)(..)/(.)(..)")
				local e4, f34, h2, i12, h4, i34 = BR:match("(.)(..)/(.)(..)/(.)(..)")

				data[y]    [x]     = rules[a12 .. '/' .. a34]
				table.insert(data[y],     x + 1, rules[b1 .. b2 .. '/' .. b3 .. b4])
				data[y]    [x + 2] = rules[c12 .. '/' .. c34]
				data[y + 1][x]     = rules[d12 .. '/' .. d34]
				data[y + 1][x + 1] = rules[e1 .. e2 .. '/' .. e3 .. e4]
				data[y + 1][x + 2] = rules[f12 .. '/' .. f34]
				data[y + 2][x]     = rules[g12 .. '/' .. g34]
				table.insert(data[y + 2], x + 1, rules[h1 .. h2 .. '/' .. h3 .. h4])
				data[y + 2][x + 2] = rules[i12 .. '/' .. i34]
			end
		end
	end

	odd = not odd
end

local part2 = 0
for y, row in pairs(data) do
	for x, str in pairs(row) do
		local _, count = str:gsub("#", "#")
		part2 = part2 + count
	end
end
print("Part 2:", part2)