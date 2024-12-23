local part1 = 0
local part2 = 0

local function isSafe(nums)
    local safe = true
    local up = nums[2] > nums[1]
    for i = 2, #nums do
        cur, prev = nums[i], nums[i - 1]
        local dif = math.abs(cur - prev)
        if dif < 1 or dif > 3 or (up and cur < prev) or (not up and cur > prev) then return false end
    end

    return true
end

for line in io.lines("input.txt") do
    local nums = {}
    for v in line:gmatch("(%d+)") do
        table.insert(nums, tonumber(v))
    end

    if isSafe(nums) then part1 = part1 + 1 end

    for i = 1, #nums do
        local n = table.remove(nums, i)
        if isSafe(nums) then part2 = part2 + 1 break end
        table.insert(nums, i, n)
    end
end

print("Part 1:", part1)
print("Part 2:", part2)
