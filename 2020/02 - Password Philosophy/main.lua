local valid1 = 0
local valid2 = 0

for line in io.lines("input.txt") do
	local min, max, c, pass = line:match("(%d+)%-(%d+) (%w): (%w+)")
	min, max = tonumber(min), tonumber(max)

	local count = 0
	for ch in pass:gmatch(".") do
		if ch == c then
			count = count + 1
		end
	end

	if count >= min and count <= max then
		valid1 = valid1 + 1
	end

	local a, b = pass:sub(min, min), pass:sub(max,max)
	if (a == c and b ~= c) or (a ~= c and b == c) then
		valid2 = valid2 + 1
	end
end

print("Part 1:", valid1)
print("Part 2:", valid2)