local data = {}
local list = {}

for line in io.lines("input.txt") do
	n = tonumber(line)
	if data[2020 - n] then
		print("Part 1:", n*(2020-n))
	end

	data[n] = true
	list[#list + 1] = n
end

for i, dif in ipairs(list) do
	local check = 2020 - dif
	for j = i + 1, #list do
		local n = list[j]
		if data[check - n] then
			print("Part 2:", dif*n*(check-n))
			return
		end
	end
end
