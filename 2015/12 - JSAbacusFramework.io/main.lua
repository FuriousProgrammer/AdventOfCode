local input = io.open("input.txt"):read("*a")

local json = require("json")
local tab = json.decode(input)

local sum1, sum2 = 0, 0
local function recurse(node, ignoreRed)
	-- first pass, find if this object/array has a "red" property
	if not ignoreRed then
		for i, v in pairs(node) do
			if type(i) ~= "number" and v == "red" then
				ignoreRed = true
				break
			end
		end
	end

	-- second pass, count nums + recurse
	for _, v in pairs(node) do
		if type(v) == "number" then
			sum1 = sum1 + v
			sum2 = sum2 + (ignoreRed and 0 or v)
		elseif type(v) == "table" then
			recurse(v, ignoreRed)
		end
	end
end
recurse(tab)

print("Part 1:", sum1)
print("Part 2:", sum2)
