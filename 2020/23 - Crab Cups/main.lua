local input = "362981754"
local cups = {}

for c in input:gmatch(".") do
	cups[#cups + 1] = tonumber(c)
end

local function doJob(iterations, length)
	local lookup = {}
	local cup = {n = cups[1]}
	lookup[cups[1]] = cup
	local temp = cup
	for i = 2, length do
		local n = {
			n = cups[i] or i;
		}
		temp.next = n
		lookup[n.n] = n
		temp = n
	end
	temp.next = cup

	for i = 1, iterations do
		local frag = cup.next
		cup.next = cup.next.next.next.next

		local destn = (cup.n - 2)%length + 1
		while destn == frag.n or destn == frag.next.n or destn == frag.next.next.n do
			destn = (destn - 2)%length + 1
		end

		local dest = lookup[destn]
		frag.next.next.next = dest.next
		dest.next = frag

		cup = cup.next
	end

	return lookup[1]
end

io.write("Part 1:\t")
local pr = doJob(100, 9).next
for i = 1, 8 do
	io.write(pr.n)
	pr = pr.next
end
print()

local pr = doJob(10000000, 1000000).next
print("Part 2:", pr.n*pr.next.n)