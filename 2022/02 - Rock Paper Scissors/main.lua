local score1 = 0
local score2 = 0

for line in io.lines("input.txt") do
	local opponent = line:sub(1,1):byte() - ('A'):byte()
	local you = line:sub(3,3):byte() - ('X'):byte()

	--[[
		0: rock
		1: paper
		2: scissors
	--]]

	local win = 0
	if you == opponent then
		win = 3
	elseif you == (opponent+1)%3 then
		win = 6
	end

	score1 = score1 + you+1 + win

	--[[
	if you == 0 then
		played = (opponent-1)%3
	elseif you == 1 then
		played = opponent
	else
		played = (opponent+1)%3
	end
	--]]
	score2 = score2 + you*3 + (opponent+you-1)%3+1

end

print("Part 1: " .. score1)
print("Part 2: " .. score2)