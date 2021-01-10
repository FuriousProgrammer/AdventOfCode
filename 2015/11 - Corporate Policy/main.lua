local input = "hxbxwxba"

local num = {}
for c in input:gmatch(".") do
	num[#num + 1] = string.byte(c) - string.byte('a')
end

local i = string.byte('i') - string.byte('a') -- could probably hardcode these
local o = string.byte('o') - string.byte('a')
local l = string.byte('l') - string.byte('a')

local function increment()
	local pos = 8
	while pos > 0 do
		num[pos] = num[pos] + 1
		if num[pos] == i or num[pos] == o or num[pos] == l then
			num[pos] = num[pos] + 1
		end
		if num[pos] == 26 then
			num[pos] = 0
			pos = pos - 1
		else
			pos = 0
		end
	end
end

local function validate()
	-- increasing straight of 3:
	local pass = false
	for i = 1, 6 do
		if num[i + 2] == num[i + 1] + 1 and num[i + 1] == num[i] + 1 then
			pass = true
			break
		end
	end
	if not pass then return false end
	pass = 0
	-- two non-overlapping matching pairs
	local i = 1
	while i <= 7 do
		if num[i] == num[i + 1] then
			pass = pass + 1
			i = i + 1
		end
		i = i + 1
	end
	if pass < 2 then return false end
	return true
end

local function translate()
	local s = {}

	for i = 1, 8 do
		s[#s + 1] = string.char(string.byte('a') + num[i])
	end

	return table.concat(s)
end


one = true
while true do
	increment()
	if validate() then
		print("Part " .. (one and 1 or 2) .. ":", translate())
		if not one then break end
		one = false
	end
end