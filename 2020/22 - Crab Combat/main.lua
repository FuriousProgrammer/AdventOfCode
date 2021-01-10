local deck1, deck2 = {}, {}

local active = deck1
for line in io.lines("input.txt") do
	if line == "" then active = deck2 end

	local card = line:match("^(%d+)$")
	if card then active[#active + 1] = tonumber(card) end
end

local b1, b2 = {}, {}
for i, v in pairs(deck1) do
	b1[i] = v
end
for i, v in pairs(deck2) do
	b2[i] = v
end



local winner
while true do
	if #deck1 == 0 or #deck2 == 0 then
		winner = #deck1 == 0 and deck2 or deck1
		break
	end

	if deck1[1] > deck2[1] then
		table.insert(deck1, deck1[1])
		table.insert(deck1, deck2[1])
		table.remove(deck1, 1)
		table.remove(deck2, 1)
	else
		table.insert(deck2, deck2[1])
		table.insert(deck2, deck1[1])
		table.remove(deck1, 1)
		table.remove(deck2, 1)
	end
end

local part1 = 0
for i, v in pairs(winner) do
	part1 = part1 + (#winner - i + 1)*v
end
print("Part 1:", part1)



local insert = table.insert
local function copy(t, n)
	local new = {}
	for i = 1, n do
		new[i] = t[i]
	end
	return new
end
local function cache(t1, t2)
	return table.concat(t1, "-") .. ":" .. table.concat(t2, "-")
end
local function draw(t)
	return table.remove(t, 1)
end

function recursiveCombat(deck1, deck2)
	local prev = {}

	while true do
		if #deck1 == 0 or #deck2 == 0 then
			return (#deck1 == 0 and "deck2" or "deck1")
		end
		local check = cache(deck1, deck2)
		if prev[check] then return "deck1" end
		prev[check] = true

		local winner
		local a, b = draw(deck1), draw(deck2)
		if #deck1 < a or #deck2 < b then
			winner = a > b and "deck1" or "deck2"
		else
			winner = recursiveCombat(copy(deck1, a), copy(deck2, b))
		end


		if winner == "deck1" then
			insert(deck1, a)
			insert(deck1, b)
		else
			insert(deck2, b)
			insert(deck2, a)
		end
	end
end
winner = recursiveCombat(b1, b2) == "deck1" and b1 or b2

local part2 = 0
for i, v in pairs(winner) do
	part2 = part2 + (#winner - i + 1)*v
end
print("Part 2:", part2)