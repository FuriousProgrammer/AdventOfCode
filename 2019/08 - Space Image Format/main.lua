local data = io.open("inpt.txt"):read("*a")

local layers = {}
local w, h = 25, 6

local step = w*h
local min, mindata = math.huge
for i = 1, #data, step do
	local dat = data:sub(i, i+step - 1)
	
	local digits = {}
	local row = {}
	layers[#layers + 1] = row
	for d in dat:gmatch("%d") do
		d = tonumber(d)
		digits[d] = (digits[d] or 0) + 1
		row[#row + 1] = d
	end

	if min > digits[0] then
		min = digits[0]
		mindata = digits[1]*digits[2]
	end
end
print("Part 1:", mindata)

-- 0:black, 1:white, 2:transparent
local on, off = string.char(219), string.char(32)
local res = {}
for i = #layers, 1, -1 do
	for p, v in pairs(layers[i]) do
		if v ~= 2 then
			res[p] = v==1 and on or off
		end
	end
end

print("Part 2:")
for y = 0, h - 1 do
	for x = 0, w - 1 do
		io.write(res[y*w + x + 1] or " ")
	end
	print()
end