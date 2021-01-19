local input = 325489

-- 1) get ring the input-th node lies on (doesn't work for input = 1)
local size = 1
while size^2 < input do
	size = size + 2
end
-- 2) get offset of input-th node into that ring,
-- 3) modulo the diameter of the ring - 1 (think: making a box, 1 unit thick boards)
local offset = (input - size*size)%(size - 1)
-- 4) "flip" the offset into the lower range (decreasing distance from offset = 0 to half the "board" length, increasing afterwards!)
if offset >= (size - 1)/2 then
	offset = (size - 1) - offset
end
-- 5) get answer!
-- "corner" of our ring is at distance size/2 + size/2
-- subtract 1 because we start inset 1 instead of ON the corner
-- subtract the offset calculated above!
print("Part 1:", size - offset - 1)



local grid = setmetatable({}, {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end;
})

grid[0][0] = 1

local x, y = 1, 1
local dx, dy = 0, -1
local len = 2

while true do
	for _ = 1, 4 do

		-- calculate/fill nodes on the "board" we're currently walking on
		for __ = 1, len do
			x, y = x + dx, y + dy

			local sum = 0
			for dx = -1, 1 do
				for dy = -1, 1 do
					sum = sum + (grid[y + dy][x + dx] or 0)
				end
			end
			grid[y][x] = sum
			if sum > input then
				print("Part 2:", sum)
				os.exit()
			end
		end

		dx, dy = dy, -dx -- rotate on the corner
	end
	-- shift to next ring's start (one below the first entry in that ring!) + increase len
	x = x + 1
	y = y + 1
	len = len + 2
end