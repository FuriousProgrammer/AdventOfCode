local inpt = io.open("input.txt")
inpt = inpt:read("*l"), inpt:close()

local md5 = require("md5")
-- I wasn't interested in getting the C-API working for this one,
-- so this will be slow if you run it without LuaJIT!

local five, six

local i = 0
while true do
	if i%1000 == 0 then
		print("i =", i)
	end

	local hex = md5.sumhexa(inpt .. i)
	if hex:sub(1, 5) == "00000" then
		if not five then five = i end
		if hex:sub(6, 6) == "0" then
			if not six then six = i end
		end
	end

	if five and six then break end
	i = i + 1
end

print("Part 1:", five)
print("Part 2:", six)