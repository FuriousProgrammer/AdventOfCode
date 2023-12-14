local part1 = 0
local cards = {}

for line in io.lines("input.txt") do
    local wins = line:sub(10,39)
    local nums = line:sub(42)

    local w = 0
    for n in wins:gmatch("(...)") do
        if nums:find(n) then
            w = w + 1
        end
    end

    if w > 0 then
        part1 = part1 + 2^(w-1)
    end

    table.insert(cards, w)
end

io.write("Part 1: ", part1, '\n')

-- starting from the end (gauranteed no overruns)
-- a card produces 1 + the sum of the `w` cards after it, where w is the number of matches for this card
-- part2 = sum of resulting table
--[[ 
e.g.:
4 => 1 + 7+4+2+1 = 15
2 => 1 + 4+2     = 7
2 => 1 + 2+1     = 4
1 => 1 + 1       = 2
0 => 1           = 1
0 => 1           = 1
results sum to 30
--]]

for i = #cards, 1, -1 do
    local c = 1
    for j = i+1, i+cards[i] do
        c = c + cards[j]
    end
    cards[i] = c
end

local part2 = 0
for _, c in pairs(cards) do
    part2 = part2 + c
end

io.write("Part 2: ", part2, '\n')