local bit = require("bit")

local input = io.open("input.txt")
input = input:read("*l"), input:close()


local first = {val = 0}
local cur = first

for i = 1, 255 do
	local n = {
		val = i;
		prev = cur;
	}
	cur.next = n
	cur = n
end
cur.next = first
first.prev = cur
cur = first

local skip = 0
local function step(len)
	if len > 1 then
		local rev = {}
		for i = 1, len do
			rev[#rev + 1] = cur.val
			cur = cur.next
		end
		cur = cur.prev
		for i = 1, len do
			cur.val = rev[i]
			cur = cur.prev
		end
		cur = cur.next
	end
	for i = 1, len + skip do
		cur = cur.next
	end
	skip = skip + 1
end

for n in input:gmatch("%d+") do
	step(tonumber(n))
end

print("Part 1:", first.val*first.next.val)


-- reset hash:
for i = 0, 255 do
	first.val = i
	first = first.next
end
skip = 0
cur = first


local lens = {}
for c in input:gmatch(".") do
	lens[#lens + 1] = string.byte(c)
end
lens[#lens + 1] = 17
lens[#lens + 1] = 31
lens[#lens + 1] = 73
lens[#lens + 1] = 47
lens[#lens + 1] = 23

for _ = 1, 64 do
	for _, v in ipairs(lens) do
		step(v)
	end
end

local res = ""
for i = 1, 16 do
	local n = 0
	for j = 1, 16 do
		n = bit.bxor(n, first.val)
		first = first.next
	end
	res = res .. string.format("%02x", n)
end
print("Part 2:", res)