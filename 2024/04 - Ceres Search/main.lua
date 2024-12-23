local grid = setmetatable({}, {
    __index = function(t, k)
        return t
    end;
})

for line in io.lines("input.txt") do
    local row = {}
    table.insert(grid, row)

    for c in line:gmatch(".") do
        table.insert(row, c)
    end
end

local part1 = 0
local deltas = {
    {x=-1,y=-1},
    {x= 1,y=-1},
    {x=-1,y= 1},
    {x= 1,y= 1},
    {x= 0,y=-1},
    {x= 0,y= 1},
    {x= 1,y= 0},
    {x=-1,y= 0},
}

local part2 = 0

for y = 1, #grid do
    for x = 1, #grid[1] do
        if grid[y][x] == 'X' then
            for _, d in pairs(deltas) do
                if grid[y + 1*d.y][x + 1*d.x] == 'M' and
                   grid[y + 2*d.y][x + 2*d.x] == 'A' and
                   grid[y + 3*d.y][x + 3*d.x] == 'S' then
                    part1 = part1 + 1
                end
            end
        end

        if grid[y][x] == 'A' then
            local Scount, Mcount = 0, 0
            for i = 1, 4 do
                local c = grid[y + deltas[i].y][x + deltas[i].x]
                if c == 'M' then Mcount = Mcount + 1 end
                if c == 'S' then Scount = Scount + 1 end
            end
            if Mcount == 2 and Scount == 2 and grid[y-1][x-1] ~= grid[y+1][x+1] then part2 = part2 + 1 end
        end
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
