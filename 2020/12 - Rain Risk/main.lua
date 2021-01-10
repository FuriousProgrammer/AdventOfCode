local pos = {x=0,y=0}
local dir = 0

local pos2 = {x=0,y=0}
local way = {x=10,y=1}

local dirs = {
	[0] = {dx=1,dy=0};  -- east
	[1] = {dx=0,dy=-1}; -- south
	[2] = {dx=-1,dy=0}; -- west
	[3] = {dx=0,dy=1};  -- north
} -- +1 = R, -1 = L

for line in io.lines("input.txt") do
	local op, arg = line:match("(.)(%d+)")
	arg = tonumber(arg)

	local dx, dy = 0, 0

	if op == "N" then
		dy = arg
		way.y = way.y + arg
	elseif op == "S" then
		dy = -arg
		way.y = way.y - arg
	elseif op == "E" then
		dx = arg
		way.x = way.x + arg
	elseif op == "W" then
		dx = -arg
		way.x = way.x - arg

	elseif op == "F" then
		dx = arg*dirs[dir].dx
		dy = arg*dirs[dir].dy
		pos2.x = pos2.x + arg*way.x
		pos2.y = pos2.y + arg*way.y

	elseif op == "R" then
		dir = (dir + arg/90)%4
		for i = 1, arg/90 do
			way.x, way.y = way.y, -way.x
		end

	elseif op == "L" then
		dir = (dir - arg/90)%4
		for i = 1, arg/90 do
			way.x, way.y = -way.y, way.x
		end
	end

	pos.x = pos.x + dx
	pos.y = pos.y + dy
end

print("Part 1:", math.abs(pos.x) + math.abs(pos.y))
print("Part 2:", math.abs(pos2.x) + math.abs(pos2.y))