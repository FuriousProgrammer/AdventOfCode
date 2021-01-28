local input = io.open("input.txt")
input = input:read("*l"), input:close()

local q, r = 0, 0
local dirs = {
	n  = {q =  0, r = -1};
	s  = {q =  0, r =  1};
	nw = {q = -1, r =  0};
	sw = {q = -1, r =  1};
	ne = {q =  1, r = -1};
	se = {q =  1, r =  0};
}

local function dist()
	return (math.abs(q) + math.abs(q + r) + math.abs(r))/2
end
local max = 0

for dir in input:gmatch("%a+") do
	q = q + dirs[dir].q
	r = r + dirs[dir].r
	max = math.max(max, dist())
end

-- (abs(a.q - b.q) + abs(a.q + a.r - b.q - b.r) + abs(a.r - b.r)) / 2

print("Part 1:", dist())
print("Part 2:", max)