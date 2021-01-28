local nodes = setmetatable({}, {
	__index = function(t, i)
		t[i] = {
			id = i;
			connections = {};
		}
		return t[i]
	end;
})

for line in io.lines("input.txt") do
	-- TODO: verify bi-directionality!
	local source, rest = line:match("(%d+) <%-> (.+)")
	source = tonumber(source)
	local nc = nodes[source].connections
	for n in rest:gmatch("%d+") do
		n = tonumber(n)
		if source ~= n then -- self references are pointless!
			nc[#nc + 1] = nodes[n]
		end
	end
end

local visited = {}
local count = 0
local function visit(node)
	if visited[node] then return end
	visited[node] = true
	count = count + 1
	for _, v in pairs(node.connections) do
		visit(v)
	end
end
visit(nodes[0])

print("Part 1:", count)

groups = 1
for _, node in pairs(nodes) do
	if not visited[node] then
		groups = groups + 1
		visit(node)
	end
end
print("Part 2:", groups)