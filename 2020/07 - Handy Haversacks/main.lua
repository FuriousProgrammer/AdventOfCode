local rules = setmetatable({}, {__index = function(t, i)
	t[i] = {
		children = {};
		parents = {};
	}
	return t[i]
end})

for line in io.lines("input.txt") do
	local n, rest = line:match("(.+) bags contain (.+)")

	if rest ~= "no other bags." then
		for c, bag in rest:gmatch("(%d+) ([a-z%s]+) bags?%p") do
			rules[n].children[bag] = c
			table.insert(rules[bag].parents, n)
		end
	end
end

local sum = 0

local function count_back(name)
	for _, p in pairs(rules[name].parents) do
		if not rules[p].visited then
			rules[p].visited = true
			sum = sum + 1
		end
		count_back(p)
	end
end
count_back("shiny gold")

print("Part 1:", sum)


sum = 0

local function count_forward(name, multiplier)
	for bag, count in pairs(rules[name].children) do
		sum = sum + count*multiplier
		count_forward(bag, multiplier*count)
	end
end
count_forward("shiny gold", 1)

print("Part 2:", sum)