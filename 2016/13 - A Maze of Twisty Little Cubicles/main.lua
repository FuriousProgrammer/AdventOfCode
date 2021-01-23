local input = 1352

--[[
From: https://graphics.stanford.edu/~seander/bithacks.html#ParityNaive
unsigned int v;  // word value to compute the parity of
v ^= v >> 16;
v ^= v >> 8;
v ^= v >> 4;
v &= 0xf;
return (0x6996 >> v) & 1;
--]]

local bit = require("bit")
local function isFloor(v)
	v = bit.bxor(v, bit.rshift(v, 16))
	v = bit.bxor(v, bit.rshift(v, 8))
	v = bit.bxor(v, bit.rshift(v, 4))
	v = bit.band(v, 0xf)
	return bit.band(bit.rshift(0x6996, v), 1) == 0
end

local part1 = math.huge
local part2 = 0
local visited = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

local dirs = {
	{x = 0, y = 1};
	{x = 0, y =-1};
	{x = 1, y = 0};
	{x =-1, y = 0};
}

local queue = {{x=1,y=1,steps=0}}

while #queue > 0 do
	local pos = table.remove(queue, 1)
	local x, y = pos.x, pos.y
	if pos.steps <= math.max(part1, 50) and pos.x >= 0 and pos.y >= 0 and isFloor(x*x + 3*x + 2*x*y + y + y*y + input) then
		if not visited[y][x] then
			visited[y][x] = pos.steps
			part2 = part2 + (pos.steps <= 50 and 1 or 0)
		end

		if pos.x == 31 and pos.y == 39 then
			part1 = math.min(part1, pos.steps)
		end

		visited[y][x] = math.min(visited[y][x], pos.steps)

		-- if we haven't already been here with fewer steps:
		if pos.steps == visited[y][x] then
			for _, d in pairs(dirs) do
				queue[#queue + 1] = {
					x = x + d.x;
					y = y + d.y;
					steps = pos.steps + 1;
				}
			end
		end
	end
end

print("Part 1:", part1)
print("Part 2:", part2)