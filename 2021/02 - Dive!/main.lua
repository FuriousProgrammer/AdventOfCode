local x, y = 0, 0
local y2, aim = 0, 0

for line in io.lines("input.txt") do
	local dir, amt = line:match("(%w+) (%d+)")
	amt = tonumber(amt)

	if dir == "forward" then
		x = x + amt
		y2 = y2 + amt*aim
	elseif dir == "up" then
		y = y - amt
		aim = aim - amt
	elseif dir == "down" then
		y = y + amt
		aim = aim + amt
	end

end

print("Part 1:", y*x)
print("Part 2:", y2*x)