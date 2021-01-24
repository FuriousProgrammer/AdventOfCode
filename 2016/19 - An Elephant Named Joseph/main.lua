local input = 3005290

-- Part 1
local first = {i = 1}
local cur = first
for i = 2, input do
	local n = {i = i}
	cur.next = n
	cur = n
end
cur.next = first
cur = first

while cur.next ~= cur do
	cur.next = cur.next.next
	cur = cur.next
end
print("Part 1:", cur.i)

-- Part 2
--[[ -- Very easy pattern in the output!
for input = 1, 100 do
	local first = {i = 1}
	local cur = first
	local count = input
	for i = 2, input do
		local n = {i = i}
		cur.next = n
		cur = n
	end
	cur.next = first
	cur = first

	while cur.next ~= cur do
		local rem = cur
		for _ = 1, math.floor(count/2) - 1 do
			rem = rem.next
		end
		rem.next = rem.next.next
		cur = cur.next
		count = count - 1
	end
	print(cur.i)
end
--]]

local n = 0
while 3^(n + 1) < input do
	n = n + 1
end

local c = input - 3^n
if c > 3^n then
	c = 3^n + 2*(c - 3^n)
end
print("Part 2:", c)