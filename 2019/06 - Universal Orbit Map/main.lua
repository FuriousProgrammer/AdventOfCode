local nodes = {}

for line in io.lines("inpt.txt") do
	local a, b = line:sub(1,3), line:sub(5,7)
	if not nodes[a] then nodes[a] = {name = a, orbiters = {}} end
	if not nodes[b] then nodes[b] = {name = b, orbiters = {}} end

	nodes[b].orbits = nodes[a]
	table.insert(nodes[a].orbiters, nodes[b])
end

local part1 = 0

-- NOTE: all of this assumes a strictly tree-like structure with no loops
local function count(node, indirect)
	node.visited = true
	local c = #node.orbiters
	c = c + c*indirect
	for _, moon in pairs(node.orbiters) do
		c = c + count(moon, indirect + 1)
	end
	return c
end
for _, node in pairs(nodes) do
	if not node.visited then
		-- descend to innermost object, recurse outward
		while node.orbits do
			node = node.orbits
		end
		part1 = part1 + count(node, 0)
	end
end

print("Part 1:", part1)

local YOU = {}
local node = nodes["YOU"]
local depth = 0
while node.orbits do
	node = node.orbits
	YOU[node.name] = depth
	depth = depth + 1
end

node = nodes["SAN"]
depth = 0
while node.orbits do
	node = node.orbits
	if YOU[node.name] then
		print("Part 2:", depth + YOU[node.name])
		break
	end
	depth = depth + 1
end