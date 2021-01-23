local input = "ugkcyxxp"

local md5 = require("md5") -- from LuaPower: https://luapower.com/md5
local function toHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02x', string.byte(c)) -- modified to be lowercase
	end))
end -- https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file

local part1 = {}
local part2 = {count = 0}

io.write("[--------] [--------]\r")

local id = 0
while #part1 < 8 or part2.count < 8 do
	local res = toHex(md5.sum(input .. id))
	id = id + 1

	if res:sub(1,5) == "00000" then
		if #part1 < 8 then
			part1[#part1 + 1] = res:sub(6,6)
		end
		local pos = tonumber(res:sub(6,6))
		if pos and pos < 8 and not part2[pos + 1] then
			part2[pos + 1] = res:sub(7,7)
			part2.count = part2.count + 1
		end

		io.write("[")
		for i = 1, 8 do
			io.write(part1[i] or '-')
		end
		io.write("] [")
		for i = 1, 8 do
			io.write(part2[i] or '-')
		end
		io.write("]\r")
	end
end
part2.count = nil

print("Part 1:", table.concat(part1), string.rep(" ", 6)) -- the \t could 0-4 characters, spaces at the end ensure the "animation" gets fully erased
print("Part 2:", table.concat(part2))