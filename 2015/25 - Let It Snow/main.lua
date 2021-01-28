local input = io.open("input.txt")
input = input:read("*l"), input:close()

local row, col = input:match("row (%d+), column (%d+)")

-- get steps to bottom of the target diagonal:
local steps = 1
local len = 1
for i = 2, row + col - 1 do
	steps = steps + len
	len = len + 1
end
-- add steps to final coordinates
steps = steps + col - 1

local code = 20151125
for i = 2, steps do
	code = (code*252533)%33554393
end

print("Part 1:", code)
print("Part 2:", "Admire the Tree!")