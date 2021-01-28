local input = io.open("input.txt")
input = input:read("*l") .. ',', input:close()


local str = "bcdefghijklmnop"
local lookup = {}
local first = {let = "a"}
local cur = first

for c in str:gmatch(".") do
	local n = {
		let = c;
		prev = cur;
	}
	cur.next = n
	cur = n
	lookup[c] = n
end
cur.next = first
first.prev = cur
lookup.a = first

local function reduce()
	local n = {}
	for i = 1, 16 do
		n[#n + 1] = first.let
		first = first.next
	end
	return table.concat(n)
end

local function dance()
	for inst in input:gmatch("(.-),") do
		local op, rest = inst:match("(.)(.+)")
		if op == "s" then
			for i = 1, tonumber(rest) do
				first = first.prev
			end
		else
			local p1, p2
			if op == "x" then
				local a, b = rest:match("(%d+)/(%d+)")
				p1, p2 = first, first
				for i = 1, a do
					p1 = p1.next
				end
				for i = 1, b do
					p2 = p2.next
				end
			else --if op == "p" then
				local a, b = rest:match("(%a)/(%a)")
				p1, p2 = lookup[a], lookup[b]
			end

			p1.let, p2.let = p2.let, p1.let
			lookup[p1.let] = p1
			lookup[p2.let] = p2
		end
	end
end

dance()
print("Part 1:", reduce())

local txt
local memo = {} -- thankfully, this repeats itself rather quickly!
for i = 2, 10^9 do	
	if txt then
		txt = memo[txt]
	else
		local st = reduce()
		if memo[st] then
			txt = memo[st]
		else
			dance()
			memo[st] = reduce()
		end
	end
end
print("Part 2:", txt)
