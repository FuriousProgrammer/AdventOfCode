local reps = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})
local med


local shorter = {}
local nextLet = string.byte("A")

local function split(str)
	local t = {}

	local i = 1
	while i <= #str do
		local a, b = str:sub(i, i), str:sub(i+1, i+1)
		if b and b == b:lower() then
			a = a .. b
			i = i + 1
		end

		if not shorter[a] then
			shorter[a] = string.char(nextLet)
			nextLet = nextLet + 1
		end

		t[#t + 1] = shorter[a]
		i = i + 1
	end

	return t
end

for line in io.lines("input.txt") do
	if not med then
		if line == "" then
			med = true
		else
			local from, to = line:match("(%a+) => (%a+)")
			if from ~= 'e' and not shorter[from] then
				shorter[from] = string.char(nextLet)
				nextLet = nextLet + 1
			end
			from = shorter[from] or from
			table.insert(reps[from], split(to))
		end
	else
		med = split(line)
	end
end

local unique = {}
for from, t in pairs(reps) do
	for _, to in pairs(t) do
		to = table.concat(to)

		for i = 1, #med do
			if med[i] == from then
				med[i] = to
				unique[table.concat(med)] = true
				med[i] = from
			end
		end

	end
end

local part1 = 0
for _ in pairs(unique) do
	part1 = part1 + 1
end
print("Part 1:", part1)

-- TODO: actually figure this out instead of copying someone else's ideas.
-- NOTE: I did this reduction by hand back in 2015, so I never cheated to get my answer!
local c = #med - 1
for _, v in pairs(med) do
	if v == shorter.Rn or v == shorter.Ar then
		c = c - 1
	elseif v == shorter.Y then
		c = c - 2
	end
end
print("Part 2:", c)