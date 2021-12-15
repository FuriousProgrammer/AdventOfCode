local map = setmetatable({}, {
	__index = function(t, i)
		t[i] = {
			paths = {};
			small = i == string.lower(i);
			visits = 0;
		}
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	local a, b = line:match("(.+)%-(.+)")
	if b ~= "start" then
		table.insert(map[a].paths, b)
	end
	if a ~= "start" then
		table.insert(map[b].paths, a)
	end
end


local part1 = 0
local part2 = 0

function visit(name, smallVisitedTwice)
	if name == "end" then
		part1 = part1 + (smallVisitedTwice and 0 or 1)
		part2 = part2 + 1
		return
	end

	local node = map[name]
	if node.small then
		if node.visits == 2 then
			return
		elseif node.visits == 1 then
			if smallVisitedTwice then return end
			smallVisitedTwice = true
		end
	end

	node.visits = node.visits + 1
	for _, nxt in pairs(node.paths) do
		visit(nxt, smallVisitedTwice)
	end
	node.visits = node.visits - 1
end
visit("start", false)

print("Part 1:", part1)
print("Part 2:", part2)