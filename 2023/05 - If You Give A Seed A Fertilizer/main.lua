local seeds = {}
local maps = {}

local iter = io.lines("input.txt")

-- seeds!
for n in iter():gmatch("(%d+)") do
    table.insert(seeds, tonumber(n))
end
iter() -- ignore empty line 2

-- maps!
for i = 1, 7 do
    local map = {}
    table.insert(maps, map)

    iter() -- ignore header line
    while true do
        local line = iter()
        if not line or line == "" then break end -- to next map!!

        local dst, src, range = line:match("(%d+) (%d+) (%d+)")
        table.insert(map, {
            dst = tonumber(dst),
            src = tonumber(src),
            range = tonumber(range)
        })
    end
end

-------

local function process(id)
    for _, map in ipairs(maps) do
        for _, data in pairs(map) do
            if id >= data.src and id < data.src + data.range then
                id = data.dst + (id - data.src)
                break
            end
        end
    end
    return id
end

local part1 = math.huge
for _, seed in pairs(seeds) do
    part1 = math.min( part1, process(seed) )
end
io.write("Part 1: ", part1, '\n')


-- way too slow:
local part2 = math.huge
for i = 1, #seeds, 2 do
    for seed = seeds[i], seeds[i] + seeds[i+1] do
        part2 = math.min( part2, process(seed) )
    end
end
io.write("Part 2: ", part2, '\n')
