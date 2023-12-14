local part1 = 0
local part2 = 0

local digits = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"} -- no zero!

for line in io.lines("input.txt") do
    local first = string.sub(line, 1, line:find("%d"))
    local last = string.sub(line, #line - line:reverse():find("%d") + 1)

    part1 = part1 + tonumber( first:sub(-1) .. last:sub(1,1) )
    
    local minpos = math.huge
    local num1 = nil
    for i = 1, 9 do
        local pos = first:find(digits[i])
        if pos and pos < minpos then
            minpos = pos
            num1 = i
        end
    end

    local maxpos = -math.huge
    local num2 = nil
    for i = 1, 9 do
        -- TODO: make this cleaner...
        local pos = last:find(digits[i])
        if pos then
            local tmp
            repeat
                tmp = last:find(digits[i], pos+1)
                if tmp then pos = tmp end
            until not tmp

            if pos > maxpos then
                maxpos = pos
                num2 = i
            end
        end
    end

    if not num1 then num1 = tonumber(first:sub(-1)) end
    if not num2 then num2 = tonumber(last:sub(1,1)) end

    part2 = part2 + (10*num1 + num2)
end

io.write("Part 1: ", part1, '\n')
io.write("Part 2: ", part2, '\n')