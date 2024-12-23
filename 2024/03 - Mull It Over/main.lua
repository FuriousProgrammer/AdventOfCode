local part1 = 0
local part2 = 0

local input = io.open("input.txt"):read("*a")

-- for x,y in input:gmatch("mul%((%d+),(%d+)%)") do
--     part1 = part1 + x*y
-- end

local enabled = true
local index = 1
while true do
    local startEnable, endEnable = input:find("do%(%)", i)
    local startDisable, endDisable = input:find("don't%(%)", i)
    local startMul, endMul, x, y = input:find("mul%((%d+),(%d+)%)", i)

    if not startMul then break end
    local min = math.min(startEnable or math.huge, startDisable or math.huge, startMul or math.huge)

    if min == startEnable then
        enabled = true
        i = endEnable + 1
    elseif min == startDisable then
        enabled = false
        i = endDisable + 1
    else --if min == startMul then
        part1 = part1 + x*y
        if enabled then
            part2 = part2 + x*y
        end
        i = endMul + 1
    end
end


print("Part 1", part1)
print("Part 2", part2)
