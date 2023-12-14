local data = {}
for line in io.lines("input.txt") do
    local game = {}
    table.insert(data, game)

    line = "; " .. line:match("Game %d+: (.+)")
    for pull in line:gmatch("; [^;]+") do
        table.insert(game, {
            r = tonumber(pull:match("(%d+) r") or 0),
            g = tonumber(pull:match("(%d+) g") or 0),
            b = tonumber(pull:match("(%d+) b") or 0)
        })
    end
end


local part1 = 0
local maxR, maxG, maxB = 12, 13, 14

local part2 = 0

for i, game in pairs(data) do
    local valid = true
    local minR, minG, minB = 0, 0, 0
    for _, pull in pairs(game) do
        if pull.r > maxR or pull.g > maxG or pull.b > maxB then
            valid = false
        end
        minR = math.max(minR, pull.r)
        minG = math.max(minG, pull.g)
        minB = math.max(minB, pull.b)
    end
    if valid then part1 = part1 + i end
    part2 = part2 + minR*minG*minB
end

io.write("Part 1: ", part1, '\n')
io.write("Part 2: ", part2, '\n')