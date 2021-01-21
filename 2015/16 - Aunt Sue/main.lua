local attributes = {
	children = 3,
	cats = 7,        -- greater than
	samoyeds = 2,
	pomeranians = 3, -- fewer than
	akitas = 0,
	vizslas = 0,
	goldfish = 5,    -- fewer than
	trees = 3,       -- greater than
	cars = 2,
	perfumes = 1,
}

local fewer = {
	goldfish = true,
	pomeranians = true,
}
local greater = {
	cats = true,
	trees = true,
}

local valid1, valid2
for line in io.lines("input.txt") do
	local sue, data = line:match("^Sue (%d+): (.+)$")

	local v1, v2 = true, true
	for attr, amount in data:gmatch("(%a+): (%d+)") do
		amount = tonumber(amount)
		if attributes[attr] ~= amount then
			v1 = false
			if not greater[attr] and not fewer[attr] then
				v2 = false
			end
		end

		if greater[attr] and amount <= attributes[attr] then
			v2 = false
		elseif fewer[attr] and amount >= attributes[attr] then
			v2 = false
		end
	end

	if v1 then valid1 = sue end
	if v2 then valid2 = sue end
	if valid1 and valid2 then break end
end

print("Part 1:", valid1)
print("Part 2:", valid2)