local function lookAndSay(str)
	local out = {}

	local c, len = str:sub(1,1), 0
	for n in str:gmatch(".") do
		if n == c then
			len = len + 1
		else
			out[#out + 1] = tostring(len) .. c
			c = n
			len = 1
		end
	end
	out[#out + 1] = tostring(len) .. c

	return table.concat(out)
end

local str = "1321131112"
for i = 1, 40 do
	str = lookAndSay(str)
end

print("Part 1:", #str)

for i = 1, 10 do
	str = lookAndSay(str)
end

print("Part 2:", #str)

-- TODO: Implement Conway's Cosmological Theorem for SPEEDS!!!