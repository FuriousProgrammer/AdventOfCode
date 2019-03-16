local inpt = io.open("input.txt")
inpt = inpt:read("*l"), inpt:close()

local x, y = 0, 0, 0, 0
local v = {
	["0-0"] = true;
	t = 1;
}

local santa = {x = 0, y = 0}
local robot = {x = 0, y = 0}
local v2 = {
	["0-0"] = true;
	t = 1;
}
local robo = false

for i = 1, #inpt do
	local c = inpt:sub(i,i)
	local dx, dy = 0, 0
	if c == "^" then dy = 1 end
	if c == "v" then dy = -1 end
	if c == "<" then dx = -1 end
	if c == ">" then dx = 1 end

	local p2 = robo and robot or santa
	robo = not robo

	x, y = x + dx, y + dy
	local t = x .. "-" .. y
	if not v[t] then
		v.t = v.t + 1
		v[t] = true
	end

	p2.x, p2.y = p2.x + dx, p2.y + dy
	local t2 = p2.x .. "-" .. p2.y
	if not v2[t2] then
		v2.t = v2.t + 1
		v2[t2] = true
	end
end

print("Part 1:", v.t)
print("Part 2:", v2.t)