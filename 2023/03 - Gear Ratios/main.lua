local grid = {}
local parts = {}

local i = 1
for line in io.lines("input.txt") do
    local row = {}
    table.insert(grid, row)

    local min, max, n = line:find("(%d+)")
    while min do
        -- numbers are always horizontal!
        -- insert full number into every cell containing a digit of it
        cell = {n = tonumber(n), used = false}
        for i = min, max do
            row[i] = cell
        end

        min, max, n = line:find("(%d+)", max + 1)
    end

    local pos, _, part = line:find("([^%d%.])")
    while pos do
        table.insert(parts, {
            x = pos,
            y = i,
            isGear = part=='*'
        })
        pos, _, part = line:find("([^%d%.])", pos + 1)
    end

    i = i + 1
end
grid[#grid + 1] = {}
grid[0] = {}


local part1 = 0
local part2 = 0

for _, part in pairs(parts) do
    local g = 1
    local count = 0

    for dy = -1, 1 do
        for dx = -1, 1 do
            local cell = grid[part.y + dy][part.x + dx]
            if cell and not cell.used then
                grid[part.y + dy][part.x + dx].used = true
                part1 = part1 + cell.n

                g = g*cell.n
                count = count + 1
            end
        end
    end

    if part.isGear and count == 2 then
        part2 = part2 + g
    end
end

io.write("Part 1: ", part1, '\n')
io.write("Part 2: ", part2, '\n')