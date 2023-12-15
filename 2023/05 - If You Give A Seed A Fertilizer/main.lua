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

    table.sort(map, function(a, b) return a.src < b.src end)
end

----------

-- TODO: merge this with part 2 code, using intervals of length 1.
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
io.write("Part 1: ")
print( part1 )

----------

local function printInterval(interval)
    print()
    for _, range in pairs(interval) do
        print(range.Start, range.End, "[" .. range.End - range.Start + 1 .. "]")
    end
    print()
end

local function inject( interval, newStart, newEnd )
    -- printInterval(interval)
    -- print(delStart, delEnd)
    -- print("--==--")
    if #interval == 0 then
        table.insert(interval, {Start=newStart, End=newEnd})
        return
    end

    -- TODO: refactor this?

    local i = 1
    -- insert new range
    while true do
        local cur = interval[i]
        -- cur and new are exactly adjacent
        if cur.End == newStart - 1 then -- cur before new
            cur.End = newEnd
            break
        elseif newEnd == cur.Start - 1 then -- new before cur
            cur.Start = newStart
            if i == 1 then return end
            i = i - 1
            break
        -- cur is before new, with a gap
        elseif cur.End < newStart then
            if i == #interval then -- cur is last range tracked
                table.insert(interval, {Start=newStart, End=newEnd})
                return -- no overlaps possible
            end
            i = i + 1
        -- cur is after new, with a gap
        elseif newEnd < cur.Start then
            table.insert(interval, i, {Start=newStart, End=newEnd})
            return -- no overlaps possible
        -- OVERLAPS
        -- new starts sooner or at the same time
        elseif newStart <= cur.Start then
            cur.Start = newStart
            -- partial overlap
            if newEnd < cur.End then return end
            -- new contains cur
            cur.End = newEnd
            break
        -- cur starts sooner
        elseif cur.Start < newStart then
            cur.End = math.max(cur.End, newEnd)
            break
        else
            error("BAD")
            return
        end
    end

    -- merge excess overlapping ranges, if any
    local cur = interval[i]
    i = i + 1
    local nxt = interval[i]
    while nxt do
        if nxt.Start < cur.End or nxt.Start == cur.End + 1 then -- overlap!
            cur.End = math.max(cur.End, nxt.End)
            table.remove(interval, i)
        else -- no overlap!
            break
        end
        nxt = interval[i]
    end
end

local function cut( interval, delStart, delEnd )
    -- printInterval(interval)
    -- print(delStart, delEnd)
    -- print("--==--")
    local removed = {}
    local i = 1

    -- TODO: refactor this?
    while true do
        local cur = interval[i]
        -- all possible segments checked
        if not cur then
            break
        -- cur ends before cut
        elseif cur.End < delStart then
            i = i + 1
        -- cur starts after cut
        elseif cur.Start > delEnd then
            break
        -- OVERLAPS
        -- cur fully contained by cut
        elseif cur.Start >= delStart and cur.End <= delEnd then
            inject(removed, cur.Start, cur.End)
            table.remove(interval, i)
        -- cut overlaps front of cur
        elseif cur.Start >= delStart and cur.End > delEnd then
            inject(removed, cur.Start, delEnd)
            cur.Start = delEnd + 1
            break
        -- cut overlaps end of cur
        elseif cur.Start < delStart and cur.End <= delEnd then
            inject(removed, delStart, cur.End)
            cur.End = delStart - 1
            i = i + 1
        -- cut is inside of cur
        elseif cur.Start < delStart and cur.End > delEnd then
            inject(removed, delStart, delEnd)
            table.insert(interval, i+1, {Start=delEnd + 1, End=cur.End})
            cur.End = delStart - 1
            break
        else
            error("BAD")
            return
        end
    end
    return removed
end

local part2 = {}
for i = 1, #seeds, 2 do
    inject(part2, seeds[i], seeds[i] + seeds[i + 1] - 1)
end

for _, map in ipairs(maps) do
    local new = {}
    for _, data in pairs(map) do
        -- cut out, transform, and inject applicable sections
        local transform = data.dst - data.src
        local interval = cut( part2, data.src, data.src + data.range - 1 )
        for _, part in pairs(interval) do
            inject(new, part.Start + transform, part.End + transform)
        end
    end
    -- inject untransformed sections
    for _, part in pairs(part2) do
        inject(new, part.Start, part.End)
    end

    part2 = new
end

io.write("Part 2: ")
print( part2[1].Start )