local left, right = {}, {}
local counts = {}

for line in io.lines("input.txt") do
    l, r = line:match("(%d+).-(%d+)")
    table.insert(left, tonumber(l))
    table.insert(right, tonumber(r))

    counts[tonumber(r)] = (counts[tonumber(r)] or 0) + 1
end

table.sort(left)
table.sort(right)

local part1 = 0
local part2 = 0

for i = 1, #left do
    part1 = part1 + math.abs(left[i] - right[i])
    part2 = part2 + left[i]*(counts[left[i]] or 0)
end

print("Part 1:", part1)
print("Part 2:", part2)
