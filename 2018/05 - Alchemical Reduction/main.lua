local data = {}
local types = {}

-- NOTE: really only 1 line
for line in io.lines("input.txt") do
	for c in line:gmatch("(.)") do
		data[#data + 1] = c
		types[c:lower()] = true
	end
end

-- TODO: refactor to avoid table.remove!
local function collapse(data)
	stale = false
	while not stale do
		stale = true

		local i = 1
		while i <= #data - 1 do
			local a, b = data[i], data[i + 1]
			if a ~= b and a:lower() == b:lower() then
				stale = false
				table.remove(data, i)
				table.remove(data, i)
			else
				i = i + 1
			end
		end
	end

	return #data
end

local function copy(t)
	local n = {}
	for i, v in pairs(t) do
		n[i] = v
	end
	return n
end

local min = collapse(copy(data))
print("Part 1:", min)

-- TODO: progress indicator (since `collapse` is slow)
for c in pairs(types) do
	local data = copy(data)

	local i = 1
	while i <= #data do
		if data[i]:lower() == c then
			table.remove(data, i)
		else
			i = i + 1
		end
	end
	min = math.min(min, collapse(data))
end
print("Part 2:", min)