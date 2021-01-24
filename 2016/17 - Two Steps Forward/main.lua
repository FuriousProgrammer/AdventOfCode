local input = "dmypynyp"

local md5 = require("md5") -- from LuaPower: https://luapower.com/md5
local function toHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02x', string.byte(c)) -- modified to be lowercase
	end))
end -- https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file

local maxLength = -math.huge
local minPath

local dirs = {
	[1] = {dir = "U", x = 0, y =-1};
	[2] = {dir = "D", x = 0, y = 1};
	[3] = {dir = "L", x =-1, y = 0};
	[4] = {dir = "R", x = 1, y = 0};
}

local queue = {{x=1,y=1,path=""}}
while #queue > 0 do
	local t = table.remove(queue)

	if t.x >= 1 and t.x <= 4 and t.y >= 1 and t.y <= 4 then
		if t.x == 4 and t.y == 4 then
			if not minPath then
				minPath	= t.path
			elseif #t.path < #minPath then
				minPath = t.path
			end
			maxLength = math.max(maxLength, #t.path)

		else
			local hash = toHex(md5.sum(input .. t.path))
			for i = 1, 4 do

				local c = hash:sub(i,i)
				if c:find("%a") and c ~= 'a' then
					queue[#queue + 1] = {
						path = t.path .. dirs[i].dir;
						x = t.x + dirs[i].x;
						y = t.y + dirs[i].y;
					}
				end

			end
		end
	end
end

print("Part 1:", minPath)
print("Part 2:", maxLength)