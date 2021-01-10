local nodes = setmetatable({}, {__index = function(t, i)
	t[i] = {}
	return t[i]
end})

for line in io.lines("input.txt") do
	local a, b, dist = line:match("(.+) to (.+) = (.+)")
	nodes[a][b] = dist
	nodes[b][a] = dist
end

local visited = {}
local min, max = math.huge, -math.huge

local function recurse(name, sum)
	visited[name] = true
	local s = 0
	for node, dist in pairs(nodes[name]) do
		if not visited[node] then
			s = s + 1
			recurse(node, sum + dist)
		end
	end
	visited[name] = false
	if s == 0 then
		min = math.min(min, sum)
		max = math.max(max, sum)
	end
end

for node in pairs(nodes) do
	recurse(node, 0)
end

print("Part 1:", min)
print("Part 2:", max)