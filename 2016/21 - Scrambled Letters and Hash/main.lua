local instr = {}

for line in io.lines("input.txt") do
	local op = {}
	instr[#instr + 1] = op
	if line:find("swap position") then
		op.op = "swapP"
		a, b = line:match("(%d+) with position (%d+)")
		op.a = tonumber(a) + 1
		op.b = tonumber(b) + 1
	elseif line:find("swap letter") then
		op.op = "swapL"
		op.a, op.b = line:match("(%a) with letter (%a)")
	elseif line:find("rotate based") then
		op.op = "rotateL"
		op.a = line:sub(-1)
	elseif line:find("rotate") then
		op.op = "rotateP"
		op.a, b = line:match("(%a+) (%d+)")
		op.b = tonumber(b)
	else
		op.op, a, b = line:match("^(%a+).-(%d+).-(%d+)$")
		op.a = tonumber(a) + 1
		op.b = tonumber(b) + 1
	end
end


local funcs = {}
function funcs.reverse(egg, a, b)
	a, b = math.min(a, b), math.max(a, b)
	for i = a, math.floor((a+b)/2) do
		local n = b - (i - a)
		egg[i], egg[n] = egg[n], egg[i]
	end
end
function funcs.move(egg, a, b)
	local c = table.remove(egg, a)
	table.insert(egg, b, c)
end
function funcs.swapP(egg, a, b)
	egg[a], egg[b] = egg[b], egg[a]
end
function funcs.swapL(egg, a, b)
	for i, v in pairs(egg) do
		if v == a then
			a = i
		elseif v == b then
			b = i
		end
	end
	funcs.swapP(egg, a, b)
end
function funcs.rotateP(egg, a, b)
	if type(b) == "string" then
		a, b = b == "left", a
	else
		a = a ~= "left"
	end
	for _ = 1, b do
		local c = table.remove(egg, a and #egg or 1)
		table.insert(egg, a and 1 or #egg + 1, c)
	end
end


local egg = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
for i = 1, #instr do
	local op = instr[i]
	if funcs[op.op] then
		funcs[op.op](egg, op.a, op.b)
	else -- op.op == "rotateL"
		local index
		for i, v in pairs(egg) do
			if v == op.a then
				index = i
				break
			end
		end
		funcs.rotateP(egg, "right", index + (index >= 5 and 1 or 0))
	end
end
print("Part 1:", table.concat(egg))

local reverseLookup = {9, 1, 6, 2, 7, 3, 0, 4}
--[[
0 >> 1 = 1
1 >> 2 = 3
2 >> 3 = 5
3 >> 4 = 7
4 >> 6 = 2
5 >> 7 = 4
6 >> 8 = 6 // 0
7 >> 9 = 0
--]]

local unegg = {'f', 'b', 'g', 'd', 'c', 'e', 'a', 'h'}
for i = #instr, 1, -1 do
	local op = instr[i]
	if funcs[op.op] then
		funcs[op.op](unegg, op.b, op.a)
	else -- op.op == "rotateL"
		local index
		for i, v in pairs(unegg) do
			if v == op.a then
				index = i
				break
			end
		end
		funcs.rotateP(unegg, "left", reverseLookup[index])
	end
end
print("Part 2:", table.concat(unegg))