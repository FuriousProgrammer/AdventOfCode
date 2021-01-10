local input = {6,4,12,1,20,0,16}


local function countingGame(n)
	local spoken = {}
	local prev, previ

	for i = 1, n do
--[[	if input[i] then
			prev = input[i]
		elseif previ then
			prev = i - previ - 1
		else
			prev = 0
		end
--]]
		prev = input[i] and input[i] or previ and i - previ - 1 or 0
		previ = spoken[prev]
		spoken[prev] = i
	end

	return prev
end

print("Part 1:", countingGame(2020))
print("Part 2:", countingGame(30000000))