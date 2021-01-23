local input = "cuanljph"

local md5 = require("md5") -- from LuaPower: https://luapower.com/md5
local function toHex(str)
	return (str:gsub('.', function (c)
		return string.format('%02x', string.byte(c)) -- modified to be lowercase
	end))
end -- https://stackoverflow.com/questions/9137415/lua-writing-hexadecimal-values-as-a-binary-file


local memo = {}
local function hashAt(i, part2)
	if memo[i] then return memo[i] end
	local hash = toHex(md5.sum(input .. i))
	if part2 then
		for _ = 1, 2016 do
			hash = toHex(md5.sum(hash))
		end
	end
	memo[i] = hash
	return hash
end

local keys = 0
local i = 0
while keys < 64 do
	local hash = hashAt(i)
	local a = hash:match("(.)%1%1")
	if a then
		a = a:rep(5)
		for j = i+1, i+1000 do
			if hashAt(j):find(a) then
				keys = keys + 1
				if keys == 64 then
					print("Part 1:", i)
				end
				break
			end
		end
	end
	i = i + 1
end

keys = 0
i = 0
memo = {}
while keys < 64 do
	local foundkey = false
	local hash = hashAt(i, true)
	local a = hash:match("(.)%1%1")
	if a then
		a = a:rep(5)
		for j = i+1, i+1000 do
			if hashAt(j, true):find(a) then
				foundkey = true
				keys = keys + 1
				if keys == 64 then
					print("Part 2:", i)
				end
				break
			end
		end
	end
	if foundkey or i%1000 == 0 then
		io.write(keys, " ", math.floor(i/1000), "k\r")
	end
	i = i + 1
end