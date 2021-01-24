local input = io.open("input.txt")
input = input:read("*l"), input:close()

local safe = 0
local row = {}
for c in input:gmatch(".") do
	safe = safe + (c == "." and 1 or 0)
	row[#row + 1] = c == "^"
end
row[0] = false
row[#row + 1] = false

local function calcNextRow()
	local n = {}
	n[0] = false
	n[#row] = false

	for i = 1, #row - 1 do
		n[i] = row[i - 1] ~= row[i + 1]
		safe = safe + (n[i] and 0 or 1)
	end

	row = n
end

for _ = 2, 40 do
	calcNextRow()
end
print("Part 1:", safe)
for _ = 41, 400000 do
	calcNextRow()
end
print("Part 2:", safe)