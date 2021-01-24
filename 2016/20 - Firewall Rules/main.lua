local valid = {{min=0,max=4294967295}}

for line in io.lines("input.txt") do
	local min, max = line:match("(%d+)%-(%d+)")
	min, max = tonumber(min), tonumber(max)

	local n = {}
	for _, range in ipairs(valid) do
		-- valid range is entirely outside blacklisted range
		if max < range.min or min > range.max then
			n[#n + 1] = range

		-- valid range entirely contains blacklisted range (aka blacklist bisects valid range)
		elseif min > range.min and max < range.max then
			n[#n + 1] = {min = range.min, max = min - 1}
			n[#n + 1] = {min = max + 1,   max = range.max}

		-- valid range partially intersects blacklisted range
		elseif not (min <= range.min and max >= range.max) then
			n[#n + 1] = range
			
			if range.min >= min then
				range.min = max + 1
			else -- if range.max <= max then
				range.max = min - 1
			end

		end
	end

	valid = n
end

print("Part 1:", valid[1].min)
local count = 0
for _, range in pairs(valid) do
	count = count + (range.max - range.min) + 1
end
print("Part 2:", count)