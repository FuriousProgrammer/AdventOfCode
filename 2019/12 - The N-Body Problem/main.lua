local moons = {}

for line in io.lines("inpt.txt") do
	local x, y, z = line:match("(%-?%d+).-(%-?%d+).-(%-?%d+)")
	moons[#moons + 1] = {x=tonumber(x),y=tonumber(y),z=tonumber(z),dx=0,dy=0,dz=0}
end

local s = {'x','y','z'}

local past = {x={}, y={}, z={}}
local periods = {}
local time = 0
local function save()
	for i = 1, 3 do
		local axis = s[i]
		local str = string.format("%d:%d:%d:%d:%d:%d:%d:%d",
				moons[1][axis],        moons[2][axis],        moons[3][axis],        moons[4][axis],
				moons[1]['d' .. axis], moons[2]['d' .. axis], moons[3]['d' .. axis], moons[4]['d' .. axis])
		if past[axis][str] and not periods[axis] then
			periods[axis] = time
		end
		past[axis][str] = true
	end
end
save()

local function step()
	for i = 1, #moons - 1 do
		-- gravity doesn't reset between steps
		for j = i + 1, #moons do
			local a, b = moons[i], moons[j]
			for k = 1, 3 do
				local axis = s[k]
				if a[axis] > b[axis] then
					a['d' .. axis] = a['d' .. axis] - 1
					b['d' .. axis] = b['d' .. axis] + 1
				elseif a[axis] < b[axis] then
					a['d' .. axis] = a['d' .. axis] + 1
					b['d' .. axis] = b['d' .. axis] - 1
				end
			end
		end
	end

	for _, moon in pairs(moons) do
		moon.x = moon.x + moon.dx
		moon.y = moon.y + moon.dy
		moon.z = moon.z + moon.dz
	end
	time = time + 1
	save()
end

for i = 1, 1000 do
	step()
end

local abs = math.abs
local total = 0
for _, moon in pairs(moons) do
	total = total + (abs(moon.x) + abs(moon.y) + abs(moon.z))*(abs(moon.dx) + abs(moon.dy) + abs(moon.dz))
end

print("Part 1:", total)

while not (periods.x and periods.y and periods.z) do
	step()
end

-- DID NOT FIGURE THIS OUT ON MY OWN:
-- LCM of the per-axis periods is the period of the combined system!
require("bignum")
local x, y, z = BigNum.new(periods.x), BigNum.new(periods.y), BigNum.new(periods.z)
local a = BigNum.gcd(x, BigNum.gcd(y, z))
x, y, z = x/a, y/a, z/a

print("Part 2:", x*y*z)