local inpt = io.open("input.txt")
inpt = inpt:read("*l"), inpt:close()


local md5 = require("md5") -- from LuaPower: https://luapower.com/md5
local function toHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02X', string.byte(c))
	end))
end -- https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file


local five, six

local i = 0
while true do
	if i%1000 == 0 then io.write(i/1000, '\r') end

	local hex = toHex(md5.sum(inpt .. i))
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