local nodes = setmetatable({}, {
	__index = function(t, i)
		t[i] = {
--			name = "",
--			weight = 0,
			carrying = {},
--			standingOn = nil,

--			totalWeight = 0,
		}
		return t[i]
	end;
})

local base
for line in io.lines("input.txt") do
	local name, weight, rest = line:match("^(%w+) %((%d+)%)(.*)$")
	weight, rest = tonumber(weight), #rest > 0 and rest:sub(5) .. ','

	nodes[name].name = name
	nodes[name].weight = weight
	if rest then
		for carry in rest:gmatch("(%a+),") do
			table.insert(nodes[name].carrying, nodes[carry])
			nodes[carry].standingOn = nodes[name]
		end
	end
	base = nodes[name]
end

while base.standingOn do
	base = base.standingOn
end
print("Part 1:", base.name)


-- set 'totalWeight' for all nodes, recursively
local function getWeight(node)
	if node.totalWeight then return node.totalWeight end

	local sum = node.weight
	for _, child in pairs(node.carrying) do
		sum = sum + getWeight(child)
	end

	node.totalWeight = sum
	return sum
end
getWeight(base)

-- find which nodes are carrying unbalanced loads
local unbalanced = {}
for _, node in pairs(nodes) do
	if #node.carrying > 0 then
		local carryWeight = node.totalWeight - node.weight
		if node.carrying[1].totalWeight ~= carryWeight/#node.carrying then
			unbalanced[#unbalanced + 1] = node
		end
	end
end

-- get the "topmost" unbalanced load (aka, the one unbalancing everything below it, if multiple are unbalanced)
local top = unbalanced[1]
if #unbalanced > 1 then
	for _, node in pairs(unbalanced) do
		notTop = false
		for _, carry in pairs(node.carrying) do
			if unbalanced[carry] then
				notTop = true
				break
			end
		end
		if not notTop then
			top = node
			break
		end
	end
end

-- the "wrong" node is being *carried* by this top-most unbalanced node, so...
-- find the odd-one-out and modify THAT node's weight to match!
-- NOTE: since ONLY one node can have the wrong weight, it's impossible for `top` to only be carrying 2 themselves-balanced nodes!


-- NOTE: my brain refuses to think of a better way to do this:
local counts = {}
for _, carry in pairs(top.carrying) do
	if not counts[carry.totalWeight] then
		counts[carry.totalWeight] = {carry}
	else
		table.insert(counts[carry.totalWeight], carry)
	end
end

local wrong, correctWeight
for count, nodes in pairs(counts) do
	if #nodes == 1 then
		wrong = nodes[1]
	else
		correctWeight = count
	end
end

print("Part 2:", wrong.weight + (correctWeight - wrong.totalWeight))