local file = io.open("input.txt")
local function n()
	return tonumber(file:read("*n"))
end

local part1 = 0
local function parseNode()
	local childCount, metaCount = n(), n()
	local node = {children = {}, metadata = {}}

	for i = 1, childCount do
		table.insert(node.children, parseNode())
	end
	for i = 1, metaCount do
		local val = n()
		part1 = part1 + val
		table.insert(node.metadata, val)
	end

	return node
end

local tree = parseNode()
print("Part 1:", part1)

local function getValue(node, memo)
	if not memo then memo = {} end
	if not node then return 0 end
	if memo[node] then return memo[node] end

	local sum = 0
	for _, val in pairs(node.metadata) do
		sum = sum + (#node.children == 0 and val or getValue(node.children[val], memo))
	end

	memo[node] = sum
	return sum
end
print("Part 2:", getValue(tree))