local prog = {}
for line in io.lines("input.txt") do
	op, a, b = line:match("(...) (.) ?(.*)")
	if tonumber(a) then a = tonumber(a) end
	if tonumber(b) then b = tonumber(b) end

	table.insert(prog, {op=op,a=a,b=b})
end


-- each set of 18 instructions handles 1 model digit
-- nearly identical, except for 3 indicated :
--[[
inp w
mul x 0
add x z
mod x 26
div z XXX <== 1 or 26
add x YYY <== random?
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y ZZZ <== random?
mul y x
add z y
--]]

-- each "step" for each model number is thus:
--[[
local test = z%26 + YYY ~= w
z = z//XXX
if test then
	z = 26*z + w + ZZZ
end
--]]

-- whenever XXX == 1, the condition *never* fails!
-- *every* time XXX == 26, the condition *needs* to pass for a valid model num!
-- additionally, for my inputs at least, z is never negative!

local function recurse(part2, z, model)
	if not model then model = "" end
	if not z then z = 0 end

	if #model == 14 then return model end

	local i = #model
	local XXX, YYY, ZZZ = prog[18*i + 5].b, prog[18*i + 6].b, prog[18*i + 16].b
	-- TODO: grab these "inputs" more efficiently from the file

	if XXX == 1 then
		for w = (part2 and 1 or 9), (part2 and 9 or 1), (part2 and 1 or -1) do
			local ret = recurse(part2, z*26 + w + ZZZ, model .. w)
			if ret then return ret end
		end
	else -- XXX == 26
		local n = z%26 + YYY
		if n > 0 and n <= 9 then
			return recurse(part2, math.floor(z/26), model .. n)
		else
			return false
		end
	end

end

print("Part 1:", recurse())
print("Part 2:", recurse(true))

