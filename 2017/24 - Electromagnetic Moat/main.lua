local data = {}

for line in io.lines("input.txt") do
	local a, b = line:match("(%d+)/(%d+)")
	data[#data + 1] = {
		a = tonumber(a),
		b = tonumber(b),
		used = false,
	}
end

local max = 0

local longest, longmax = 0, 0

local function build(port, str, len)
	max = math.max(max, str)
	if len >= longest then
		longest = len
		longmax = math.max(longmax, str)
	end

	for _, node in pairs(data) do
		if not node.used and (node.a == port or node.b == port) then
			str = str + node.a + node.b
			node.used = true
			if node.a == port then
				build(node.b, str, len + 1)
			elseif node.b == port then
				build(node.a, str, len + 1)
			end
			node.used = false
			str = str - node.a - node.b
		end
	end
end
build(0, 0, 0)

print("Part 1:", max)
print("Part 2:", longmax)