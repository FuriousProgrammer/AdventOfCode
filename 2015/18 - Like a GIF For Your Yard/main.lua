local grid1 = {}
local grid2 = {}

for line in io.lines("input.txt") do
	local row1 = {}
	local row2 = {}
	grid1[#grid1 + 1] = row1
	grid2[#grid2 + 1] = row2

	for c in line:gmatch(".") do
		row1[#row1 + 1] = c == "#"
		row2[#row2 + 1] = c == "#"
	end
end

grid1[0] = {}
grid1[101] = {}

grid2[0] = {}
grid2[101] = {}

grid2[1][1] = true
grid2[100][1] = true
grid2[1][100] = true
grid2[100][100] = true

-- TODO: optimize by only checking lit points + their neighbors instead of all 10000 cells
for _ = 1, 100 do
	local n1, n2 = {}, {}

	for y = 1, 100 do
		n1[y] = {}
		n2[y] = {}
		for x = 1, 100 do

			local c1, c2 = 0, 0
			for dy = -1, 1 do
				for dx = -1, 1 do
					if dx ~= 0 or dy ~= 0 then
						c1 = c1 + (grid1[y + dy][x + dx] and 1 or 0)
						c2 = c2 + (grid2[y + dy][x + dx] and 1 or 0)
					end
				end
			end
			n1[y][x] = c1 == 3 or (grid1[y][x] and c1 == 2)
			n2[y][x] = c2 == 3 or (grid2[y][x] and c2 == 2)

		end
	end

	n1[0], n1[101] = {}, {}
	n2[0], n2[101] = {}, {}
	grid1, grid2 = n1, n2

	grid2[1][1] = true
	grid2[100][1] = true
	grid2[1][100] = true
	grid2[100][100] = true
end

local sum1, sum2 = 0, 0
for y = 1, 100 do
	for x = 1, 100 do
		sum1 = sum1 + (grid1[y][x] and 1 or 0)
		sum2 = sum2 + (grid2[y][x] and 1 or 0)
	end
end

print("Part 1:", sum1)
print("Part 2:", sum2)