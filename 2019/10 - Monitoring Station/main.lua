local data = {}
local nodes = {}
local WIDTH, HEIGHT

for line in io.lines("inpt.txt") do
	local row = {}
	data[#data + 1] = row
	for i = 1, #line do
		if line:sub(i,i) == "#" then
			local n = {x=i,y=#data}
			nodes[#nodes + 1] = n
			row[i] = n
		end
	end
	WIDTH = #line
end
HEIGHT = #data

local function gcd(a, b)
	if a < b then a, b = b, a end
	if b == 0 then return a end

	return gcd(b, a%b)
end

local max = 0
local maxdata
for _, node in pairs(nodes) do
	local mark = {}
	node.mark = mark
	local visible = 0
	local angles = {}

	for _, target in pairs(nodes) do
		if target.mark ~= mark then
			local dx, dy = target.x - node.x, target.y - node.y
			local g = gcd(math.abs(dx), math.abs(dy))
			dx, dy = dx/g, dy/g
			local miss = true
			local x, y = node.x, node.y

			local th = math.atan2(dx, -dy)%(math.pi*2) -- flip standard angle axes about y=x, reverse y as my graph is vertically inverted
			angles[#angles + 1] = {dx=dx,dy=dy,angle=th,nodes={}}
--			print("From:",x,y,"To:",target.x,target.y,"By:",dx,dy)
			while true do
				x, y = x + dx, y + dy
				if x > 0 and x <= WIDTH and y > 0 and y <= HEIGHT then
--					print(x, y, data[y][x])
					if data[y][x] then
						miss = false
						data[y][x].mark = mark
						table.insert(angles[#angles].nodes, data[y][x])
					end
				else
					break
				end
			end
			if not miss then visible = visible + 1 end
		end
	end

--	print(node.x, node.y, visible)

	if visible > max then
		max = visible
		maxdata = angles
	end
end

table.sort(maxdata, function(a, b)
	return a.angle < b.angle
end)

print("Part 1:", max)
if #maxdata >= 200 then
	print("Part 2:", maxdata[200].nodes[1].y - 1 + (maxdata[200].nodes[1].x - 1)*100)
else
	--TODO
end
--[[
for i = 1, 10 do
print(maxdata[i].angle, maxdata[i].dx, maxdata[i].dy, maxdata[i].nodes[1].x, maxdata[i].nodes[1].y)
end
--]]