-- vertical velocity when probe reaches y=0 after launch will be -(v_0 + 1)
-- the highest possible height is reached if, on the very next step, the probe reaches the *lowest* valid target `y`: miny = -(v_0 + 1)
-- highest position is thus 1+2+3+...+n where n = v_0 = -minY - 1 : n*(n+1)/2

local input = io.open("input.txt"):read("*l")

local minX, maxX, minY, maxY = input:match("x=(%-?%d+)%.%.(%-?%d+), y=(%-?%d+)%.%.(%-?%d+)")
minX, maxX, minY, maxY = tonumber(minX), tonumber(maxX), tonumber(minY), tonumber(maxY)

-- NOTE: this probably isn't necessary?
if minX > maxX then
	minX, maxX = maxX, minX
end
if minY > maxY then
	minY, maxY = maxY, minY
end

local maxDY = -minY - 1
print("Part 1:", (maxDY*(maxDY+1))/2)

local minDY, maxDX = minY, maxX -- fire directly at the furtherst corner...

--[[
minDX = n
minX = (n*(n+1))/2 -- precisely hits left edge with 0 velocity!
2*minX = n*n + n
n**2 + n - 2*minX = 0
n = ( -1 +- sqrt(1 + 8*minX) ) / 2
... ceil, because it must be an integer velocity
--]]

local minDX = math.ceil( (math.sqrt(1 + 8*minX) - 1)/2 )

local valid = 0
for DY = minDY, maxDY do
	for DX = minDX, maxDX do
		local x, dx, y, dy = 0, DX, 0, DY
		while true do
			x = x + dx
			dx = math.max(0, dx - 1)
			y = y + dy
			dy = dy - 1

			if x > maxX or y < minY then break end
			if x >= minX and y <= maxY then
				valid = valid + 1
				break
			end
		end
	end
end
print("Part 2:", valid)