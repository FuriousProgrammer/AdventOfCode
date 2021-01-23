local part1 = 0
local part2 = 0

for line in io.lines("input.txt") do
	local main = {}
	local hyper = {}
	local isMain = true

	for txt in line:gmatch("%a+") do
		table.insert(isMain and main or hyper, txt)
		isMain = not isMain
	end

	local aba = {}
	local hasABBA = false
	for _, txt in pairs(main) do
		local a, b = txt:match("(.)(.)%2%1")
		if a and a ~= b then
			hasABBA = true
		end

		for i = 1, #txt - 2 do
			local a, b, c = txt:sub(i,i), txt:sub(i + 1, i + 1), txt:sub(i + 2, i + 2)
			if a == c and a ~= b then
				aba[#aba + 1] = b .. a .. b
			end
		end
	end

	-- NOTE: could probably combine these, but it's easier to do them separately!
	local valid
	if hasABBA then
		valid = true
		for _, txt in pairs(hyper) do
			local a, b = txt:match("(.)(.)%2%1")
			if a and a ~= b then
				valid = false
				break
			end
		end
		part1 = part1 + (valid and 1 or 0)
	end

	valid = false
	for _, bab in pairs(aba) do
		for _, txt in pairs(hyper) do
			if txt:find(bab) then
				valid = true
				break
			end
		end
		if valid then break end
	end
	part2 = part2 + (valid and 1 or 0)
end

print("Part 1:", part1)
print("Part 2:", part2)