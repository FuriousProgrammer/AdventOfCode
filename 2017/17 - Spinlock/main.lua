local input = 371

local cur = {val=0}
cur.next = cur
local first = cur

for i = 1, 2017 do
	for _ = 1, input do
		cur = cur.next
	end
	local n = {val=i}
	n.next = cur.next
	cur.next = n
	cur = n
end

print("Part 1:", cur.next.val)

local pos = 0
local part2 = 0
for i = 1, 50*10^6 - 1 do
	pos = (pos + input)%i
	if pos == 0 then
		part2 = i
	end
	pos = (pos + 1)%(i + 1)
end
print("Part 2:", part2)