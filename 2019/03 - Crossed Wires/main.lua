-- Sparse array method.
local grid = {}

local part1, part2 = math.huge, math.huge
local checks = false

for line in io.lines("inpt.txt") do
	local x, y, c = 0, 0, 0
--	print(line)
	for dir, n in line:gmatch("([UDRL])(%d+)") do
		-- ignores first point (origin)
		local dx, dy = dir == "L" and -1 or (dir == "R" and 1 or 0),
		               dir == "D" and -1 or (dir == "U" and 1 or 0)

		for mc = 1, n do
			local x, y = x + dx*mc, y + dy*mc
			if (grid[y] and grid[y][x]) then
				if checks then
					-- intersection found!
					part1 = math.min(part1, math.abs(x) + math.abs(y))
					part2 = math.min(part2, grid[y][x] + c + mc)
--					print(x, y, c, part1, part2)
				end
			else -- not visited
				if not checks then
					if not grid[y] then grid[y] = {} end
					if not grid[y][x] then grid[y][x] = c + mc end -- uses only first visit to node if line crosses itself
				end
			end
		end
		x, y, c = x + n*dx, y + n*dy, c + n

--		print(x, y, c, dx, dy)
	end

	checks = true
end

print("Part 1:", part1)
print("Part 2:", part2)

--[[
-- Line segment intersection method.
-- Didn't bother working part 2 with this. Severely overengineered this.

local points = {}

for line in io.lines("inpt.txt") do
	local t = {{x=0,y=0}}
	points[#points + 1] = t
	local x, y = 0, 0

	for dir, n in line:gmatch("([UDRL])(%d+)") do
		if dir == "U" then
			y = y + n
		elseif dir == "D" then
			y = y - n
		elseif dir == "R" then
			x = x + n
		elseif dir == "L" then
			x = x - n
		end

		t[#t + 1] = {x=x, y=y}
	end
end

local minDist = math.huge
local px, py

for a = 1, #points[1] - 1 do
	local a1, a2 = points[1][a], points[1][a + 1]
	local aMinX, aMaxX, aMinY, aMaxY = math.min(a1.x, a2.x), math.max(a1.x, a2.x), math.min(a1.y, a2.y), math.max(a1.y, a2.y)

	for b = 1, #points[2] - 1 do
		local b1, b2 = points[2][b], points[2][b + 1]
		local bMinX, bMaxX, bMinY, bMaxY = math.min(b1.x, b2.x), math.max(b1.x, b2.x), math.min(b1.y, b2.y), math.max(b1.y, b2.y)

--		print(aMinX, aMinY, aMaxX, aMaxY, bMinX, bMinY, bMaxX, bMaxY)

		if aMinX <= bMaxX and aMaxX >= bMinX and
		   aMinY <= bMaxY and aMaxY >= bMinY then
			if aMinX == aMaxX then
			-- a is vertical
				px = aMinX
				if bMinX == bMaxX then
					-- b is vertical
					local min, max = math.max(aMinY, bMinY), math.min(aMaxY, bMaxY)
					if max < 0 then
						px = max
					elseif min > 0 then
						px = min
					else
						px = 0
					end
				else
					-- b is horizontal
					py = bMinY
				end
			else
			-- a is horizontal
				py = aMinY
				if bMinX == bMaxX then
					-- b is vertical
					px = bMinX
				else
					-- b is horizontal
					local min, max = math.max(aMinX, bMinX), math.min(aMaxX, bMaxX)
					if max < 0 then
						px = max
					elseif min > 0 then
						px = min
					else
						px = 0
					end
				end
			end

--			print(px, py)
			if px ~= 0 or py ~= 0 then
				minDist = math.min(math.abs(px) + math.abs(py), minDist)
			end
		end
	end
end

print("Part 1: ", minDist)
]]